module cpu (input clk, input rst_n, output hlt, output [15:0] pc);

	wire [15:0] PC_curr, PC_inc, PC_next, PC_branch;
	wire [15:0] instru;
	
	wire [3:0]  src_reg_2;
	wire [15:0] reg_write_data, reg_data_1, reg_data_2;
	
	wire [15:0] ALU_src_2;
	wire [15:0] ALU_out;
	wire [15:0] BitMask_out;
	wire [15:0] exec_out;
	wire N_next, Z_next, V_next, set_N, set_Z, set_V, N, Z, V;
	
	wire [15:0] d_mem_out;
	wire enable;
	
	// control
	wire PCWrite;		// PC wen
	wire RegSrc; 		// Select Register Read 2 src
	wire RegWrite;		// Register file wen
	wire ExtSrc;
	wire ByteSel;		// Selects LLB or LHB
	wire ALUSrc;		// Select ALU reg or immediate
	wire MemWrite; 		// Memory wen
	wire LoadByte;
	wire PCS;
	wire MemtoReg;		// Reg write src select
	wire [2:0] ALUop;	// ALU operation selection
	wire BrReg;	
	wire Branch;
	
	Control iControl(.opcode(instru[15:12]), .CCC(instru[11:9]), .N(N), .Z(Z), .V(V), .set_N(set_N), .set_Z(set_Z), .set_V(set_V), .PCWrite(PCWrite), .RegSrc(RegSrc), .RegWrite(RegWrite), .ExtSrc(ExtSrc), .ByteSel(ByteSel), .ALUSrc(ALUSrc), .MemWrite(MemWrite), .LoadByte(LoadByte), .PCS(PCS), .MemtoReg(MemtoReg), .ALUop(ALUop), .BrReg(BrReg), .Branch(Branch));
	assign hlt = ~PCWrite;
	
	// PC datapath
	PC PCreg(.in(PC_next), .wen(PCWrite), .clk(clk), .rst(~rst_n), .out(PC_curr));
	cla_16bit PC_increment(.A(PC_curr), .B(16'h0002), .Cin(1'b0), .S(PC_inc), .Cout(), .ovfl());
	cla_16bit PC_branch_adder(.A(PC_inc), .B({{6{instru[8]}}, instru[8:0], 1'b0}), .Cin(1'b0), .S(PC_branch), .Cout(), .ovfl());
	
	assign pc = PC_curr;
	
	assign PC_next = BrReg ? reg_data_1 : 
					 Branch ? PC_branch : PC_inc;
	
	// instruction decode datapath
	memory1c InstructionMEM(.data_out(instru), .data_in(16'h0000), .addr(PC_curr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));

	assign src_reg_2 = RegSrc ? instru[11:8] : instru[3:0];
	RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(instru[7:4]), .SrcReg2(src_reg_2), .DstReg(instru[11:8]), .WriteReg(RegWrite), .DstData(reg_write_data), .SrcData1(reg_data_1), .SrcData2(reg_data_2));

	
	// execution datapath
	assign ALU_src_2 = ALUSrc ? (ExtSrc ? {{11{instru[3]}}, instru[3:0], 1'b0} : {{12{1'b0}}, instru[3:0]}) : reg_data_2;
	ALU alu(.a(reg_data_1), .b(ALU_src_2), .ALUOp(ALUop), .out(ALU_out), .N(N_next), .Z(Z_next), .V(V_next));
	FlagReg FLAG(.clk(clk), .rst(~rst_n), .N_in(N_next), .Z_in(Z_next), .V_in(V_next), .set_N(set_N), .set_Z(set_Z), .set_V(set_V), .N(N), .Z(Z), .V(V));
	HalfBitMask BitMask(.Rd(reg_data_2), .imm(instru[7:0]), .ctrl(ByteSel), .out(BitMask_out));
	assign exec_out = PCS ? PC_inc : 
					  LoadByte ? BitMask_out : ALU_out;
					  
	// memory datapath
	assign enable = MemtoReg | MemWrite;
	memory1c DataMEM(.data_out(d_mem_out), .data_in(reg_data_2), .addr(ALU_out), .enable(enable), .wr(MemWrite), .clk(clk), .rst(~rst_n));
	
	// writeback datapath
	assign reg_write_data = MemtoReg ? d_mem_out : exec_out;
	
endmodule 