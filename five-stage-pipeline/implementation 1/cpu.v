module cpu (input clk, input rst_n, output hlt, output [15:0] pc);

	wire [15:0] PC_curr, PC_next, PC_br_addr, PC_branch;
	
	wire [3:0]  src_reg_2;
	wire [15:0] reg_write_data, reg_data_1, reg_data_2;
	
	wire [15:0] ALU_src_2;
	wire [15:0] ALU_out;
	wire [15:0] BitMask_out;
	wire [15:0] exec_out;
	wire N_next, Z_next, V_next, set_N, set_Z, set_V, N, Z, V;
	
	wire [15:0] d_mem_out;
	wire enable;
	wire halt_pc;
	wire stall;
	wire flush;
	
	wire [15:0] f_instru, d_instru;
	wire [15:0] f_PC_inc, d_PC_inc;
	
	wire [1:0] x_forward_wdata;
	wire [1:0] x_forward_ALU_src_1;
	wire [1:0] x_forward_ALU_src_2;
	wire [1:0] m_forward_wdata;
	
	// control
	wire Halt;
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
	
	
	// fetch datapath
	assign PC_next = flush ? PC_branch : f_PC_inc;
	
	assign PC_wen = (stall | halt_pc);
	PC PCreg(.in(PC_next), .wen(PC_wen), .clk(clk), .rst(~rst_n), .out(PC_curr));
	
	assign pc = PC_curr;
	cla_16bit PC_increment(.A(PC_curr), .B(16'h0002), .Cin(1'b0), .S(f_PC_inc), .Cout(), .ovfl());
	
	memory1c InstructionMEM(.data_out(f_instru), .data_in(16'h0000), .addr(PC_curr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	halt_detection (.opcode(f_instru[15:12]), halt_pc(halt_pc));
	
	IF_ID_mem iIF_ID(.clk(clk), .rst_n(~rst_n), .flush(flush), .stall(stall), .instruction_in(f_instru), .PC_inc_in(f_PC_inc), .instruction_out(d_instru), .PC_inc_out(d_PC_inc));
	
	// decode datapath
	Control iControl(.opcode(d_instru[15:12]), .CCC(d_instru[11:9]), .N(N), .Z(Z), .V(V), .set_N(d_set_N), .set_Z(d_set_Z), .set_V(d_set_V), .BrSrc(d_BrSrc), .RegSrc(d_RegSrc), .RegWrite(d_RegWrite), .ExtSrc(d_ExtSrc), .ByteSel(d_ByteSel), .ALUSrc(d_ALUSrc), .MemWrite(d_MemWrite), .LoadByte(d_LoadByte), .PCS(d_PCS), .MemtoReg(d_MemtoReg), .ALUop(d_ALUop), .BrReg(d_BrReg), .Branch(d_Branch), .Halt(d_Halt));
	cla_16bit PC_branch_adder(.A(d_PC_inc), .B({{6{d_instru[8]}}, d_instru[8:0], 1'b0}), .Cin(1'b0), .S(PC_br_addr), .Cout(), .ovfl());
	assign PC_branch = BrSrc ? reg_data_1 : PC_br_addr;
	
	assign src_reg_2 = RegSrc ? d_instru[11:8] : d_instru[3:0];
	RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(d_instru[7:4]), .SrcReg2(src_reg_2), .DstReg(d_wd), .WriteReg(w_RegWrite), .DstData(reg_write_data), .SrcData1(d_reg_data_1), .SrcData2(d_reg_data_2));
	
	assign d_ext_imm = ExtSrc ? {{11{d_instru[3]}}, d_instru[3:0], 1'b0} : {{12{1'b0}}, d_instru[3:0]}
	assign d_hbu_imm = d_instru[7:0];
	assign d_rd_1 = d_instru[7:4];
	assign d_rd_2 = src_reg_2;
	assign d_wd = d_instru[11:8];
	
	WB_mem ID_EX_WB_MEM(.clk(clk), .rst_n(~rst_n), .RegWrite_in(d_RegWrite), .MemtoReg_in(d_MemtoReg), .Halt_in(d_Halt), .RegWrite_out(x_RegWrite), .MemtoReg_out(x_MemtoReg), .Halt_out(x_Halt));
	M_mem ID_EX_M_MEM(.clk(clk), .rst_n(~rst_n), .MemWrite_in(d_MemWrite), .PCS_in(d_PCS), .LoadByte_in(d_LoadByte), .MemWrite_out(x_MemWrite), .PCS_out(x_PCS), .LoadByte_out(x_LoadByte));
	EX_mem ID_EX_EX_MEM(.clk(clk), .rst_n(~rst_n), .ALUsrc_in(d_ALUSrc), .ALUop_in(d_ALUop), .ByteSel_in(d_ByteSel), .set_N_in(d_set_N), set_V_in(d_set_V), set_Z_in(d_set_Z), .ALUsrc_out(x_ALUSrc), .ALUop_out(x_ALUop), .ByteSel_out(x_ByteSel), .set_N_out(x_set_N), set_V_out(x_set_V), set_Z_out(x_set_Z));
	ID_EX_mem iID_EX(.clk(clk), .rst_n(~rst_n), .PC_inc_in(d_PC_inc), .rdata_1_in(d_reg_data_1), .rdata_2_in(d_reg_data_2), .ext_data_in(d_ext_imm), .hbu_imm_in(d_hbu_imm), .rd_1_in(d_rd_1), .rd_2_in(d_rd_2), .wd_in(d_wd), .PC_out(x_PC_inc), .rdata_1_out(x_reg_data_1), .rdata_2_out(x_reg_data_2), .ext_data_out(x_ext_imm), .hbu_imm_out(x_hbu_imm), .rd_1_out(x_rd_1), .rd_2_out(x_rd_2), .wd_out(x_wd));
	
	// execution datapath
	assign ALU_src_1 = x_forward_ALU_src_1[1] ? reg_write_data:
					   x_forward_ALU_src_1[0] ? m_exec_out:
					   x_reg_data_1;
	
	assign ALU_src_2 = x_forward_ALU_src_2[1] ? reg_write_data:
					   x_forward_ALU_src_2[0] ? m_exec_out:
					   x_ALUSrc ? x_ext_imm : 
					   x_reg_data_2;

	assign x_wdata = x_forward_wdata[1] ? reg_write_data : 
					 x_forward_wdata[0] ? m_exec_out :
					 x_reg_data_2;
	
	ALU alu(.a(ALU_src_1), .b(ALU_src_2), .ALUOp(x_ALUop), .out(x_ALU_out), .N(N_next), .Z(Z_next), .V(V_next));
	FlagReg FLAG(.clk(clk), .rst(~rst_n), .N_in(N_next), .Z_in(Z_next), .V_in(V_next), .set_N(x_set_N), .set_Z(x_set_Z), .set_V(x_set_V), .N(N), .Z(Z), .V(V));
	
	HalfBitMask BitMask(.Rd(x_wdata), .imm(x_hbu_imm), .ctrl(x_ByteSel), .out(x_BitMask_out));
	
	WB_mem ID_EX_WB_MEM(.clk(clk), .rst_n(~rst_n), .RegWrite_in(x_RegWrite), .MemtoReg_in(x_MemtoReg), .Halt_in(x_Halt), .RegWrite_out(m_RegWrite), .MemtoReg_out(m_MemtoReg), .Halt_out(m_Halt));
	M_mem ID_EX_M_MEM(.clk(clk), .rst_n(~rst_n), .MemWrite_in(x_MemWrite), .PCS_in(x_PCS), .LoadByte_in(x_LoadByte), .MemWrite_out(m_MemWrite), .PCS_out(m_PCS), .LoadByte_out(m_LoadByte));
	EX_M_mem iID_EX(.clk(clk), .rst_n(~rst_n), .PC_inc_in(x_PC_inc), .ALU_result_in(x_ALU_out), .wdata_in(x_wdata), .BitMask_in(x_BitMask_out), .rd_2_in(x_rd_2), .wd_in(x_wd), .PC_inc_out(m_PC_inc), .ALU_result_out(m_ALU_out), .wdata_out(m_wdata), .BitMask_out(m_BitMask_out), .rd_2_out(m_rd_2), .wd_out(m_wd));
	
	// memory datapath
	assign enable = MemtoReg | MemWrite;
	memory1c DataMEM(.data_out(d_mem_out), .data_in(reg_data_2), .addr(ALU_out), .enable(enable), .wr(MemWrite), .clk(clk), .rst(~rst_n));
	
	// writeback datapath
	assign reg_write_data = MemtoReg ? d_mem_out : exec_out;
	
endmodule 