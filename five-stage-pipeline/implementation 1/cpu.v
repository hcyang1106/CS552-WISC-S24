module cpu (input clk, input rst_n, output hlt, output [15:0] pc);	
	wire [1:0] x_forward_wdata;
	wire [1:0] x_forward_ALU_src_1;
	wire [1:0] x_forward_ALU_src_2;
	wire [1:0] m_forward_wdata;
	
	wire [3:0] d_rd_1, d_rd_2, d_wd;
	wire [3:0] x_rd_1, x_rd_2, x_wd;
	wire [3:0] m_rd_2, m_wd;
	wire [3:0] w_wd;
	
	wire stall;
	
	// fetch
	wire [15:0] PC_curr, PC_next, PC_branch;
	wire PC_wen;
	wire halt_pc;
	wire d_flush;
	
	wire [15:0] f_PC_inc, f_instru, d_PC_inc, d_instru;
	
	// decode
	wire flush, d_BrSrc, d_RegSrc, d_ExtSrc; 
	wire [15:0] PC_br_addr;
	wire [3:0] src_reg_2;
	
	wire [15:0] d_reg_data_1, d_reg_data_2, d_ext_imm, x_reg_data_1, x_reg_data_2, x_ext_imm;
	wire [7:0] d_hbu_imm, x_hbu_imm;

	wire d_RegWrite, d_MemtoReg, d_Halt;
	wire d_MemWrite, d_PCS, d_LoadByte;
	wire d_ALUSrc, d_ByteSel, d_set_N, d_set_Z, d_set_V;
	wire [2:0] d_ALUop;
	
	// execute
	wire N, Z, V, N_next, Z_next, V_next;
	wire [15:0] ALU_src_1, ALU_src_2;
	
	wire [15:0] x_PC_inc, x_wdata, x_ALU_out, x_BitMask_out, m_PC_inc, m_wdata, m_ALU_out, m_BitMask_out;
	
	wire x_RegWrite, x_MemtoReg, x_Halt;
	wire x_MemWrite, x_PCS, x_LoadByte;
	wire x_ALUSrc, x_ByteSel, x_set_N, x_set_Z, x_set_V;
	wire [2:0] x_ALUop;
	
	// memory
	wire [15:0] mem_write_data;
	wire enable;
	
	wire [15:0] m_mem_out, m_exec_out, w_mem_out, w_exec_out;
	
	wire m_RegWrite, m_MemtoReg, m_Halt;
	wire m_MemWrite, m_PCS, m_LoadByte;
	
	// writeback
	wire [15:0] reg_write_data;
	wire w_RegWrite, w_MemtoReg, w_Halt;
	
	ForwardingUnit iForward(.EX_MEM_RegWd(m_wd), .MEM_WB_RegWd(w_wd), .EX_MEM_RegWrite(m_RegWrite), .MEM_WB_RegWrite(w_RegWrite), .ID_EX_RegRd1(x_rd_1), .ID_EX_RegRd2(x_rd_2), .EX_MEM_RegRd2(m_rd_2), .ALUsrc(x_ALUSrc), .ForwardA(x_forward_ALU_src_1), .ForwardB(x_forward_ALU_src_2), .ForwardC(x_forward_wdata), .ForwardD(m_forward_wdata));
	hazard_detection iHazard_Detection(.EX_wd(x_wd), .EX_MemtoReg(x_MemtoReg), .EX_RegWrite(x_RegWrite), .EX_set_N(x_set_N), .EX_set_V(x_set_V), .EX_set_Z(x_set_Z), .instruction(d_instru), .stall(stall));

	// fetch datapath
	assign PC_next = flush ? PC_branch : f_PC_inc;
	
	assign PC_wen = stall ? 1'b0 :
					flush ? 1'b1 :
					~halt_pc;
					
	PC PCreg(.in(PC_next), .wen(PC_wen), .clk(clk), .rst(~rst_n), .out(PC_curr));
	
	assign pc = PC_curr;
	cla_16bit PC_increment(.A(PC_curr), .B(16'h0002), .Cin(1'b0), .S(f_PC_inc), .Cout(), .ovfl());
	
	memory1c InstructionMEM(.data_out(f_instru), .data_in(16'h0000), .addr(PC_curr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	halt_detection halt_detect(.opcode(f_instru[15:12]), .halt_pc(halt_pc));
	
	IF_ID_mem iIF_ID(.clk(clk), .rst_n(~rst_n), .flush(flush), .stall(stall), .instruction_in(f_instru), .PC_inc_in(f_PC_inc), .instruction_out(d_instru), .PC_inc_out(d_PC_inc), .flush_out(d_flush));
	
	// decode datapath
	Control iControl(.opcode(d_instru[15:12]), .d_flush(d_flush), .CCC(d_instru[11:9]), .N(N), .Z(Z), .V(V), .set_N(d_set_N), .set_Z(d_set_Z), .set_V(d_set_V), .BrSrc(d_BrSrc), .RegSrc(d_RegSrc), .RegWrite(d_RegWrite), .ExtSrc(d_ExtSrc), .ByteSel(d_ByteSel), .ALUSrc(d_ALUSrc), .MemWrite(d_MemWrite), .LoadByte(d_LoadByte), .PCS(d_PCS), .MemtoReg(d_MemtoReg), .ALUop(d_ALUop), .Branch(flush), .Halt(d_Halt));
	cla_16bit PC_branch_adder(.A(d_PC_inc), .B({{6{d_instru[8]}}, d_instru[8:0], 1'b0}), .Cin(1'b0), .S(PC_br_addr), .Cout(), .ovfl());
	assign PC_branch = d_BrSrc ? d_reg_data_1 : PC_br_addr;
	
	assign src_reg_2 = d_RegSrc ? d_instru[11:8] : d_instru[3:0];
	RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(d_instru[7:4]), .SrcReg2(src_reg_2), .DstReg(w_wd), .WriteReg(w_RegWrite), .DstData(reg_write_data), .SrcData1(d_reg_data_1), .SrcData2(d_reg_data_2));
	
	assign d_ext_imm = d_ExtSrc ? {{11{d_instru[3]}}, d_instru[3:0], 1'b0} : {{12{1'b0}}, d_instru[3:0]};
	assign d_hbu_imm = d_instru[7:0];
	assign d_rd_1 = d_instru[7:4];
	assign d_rd_2 = src_reg_2;
	assign d_wd = d_instru[11:8];
	
	WB_mem ID_EX_WB_MEM(.clk(clk), .rst_n(~rst_n), .RegWrite_in(d_RegWrite), .MemtoReg_in(d_MemtoReg), .Halt_in(d_Halt), .RegWrite_out(x_RegWrite), .MemtoReg_out(x_MemtoReg), .Halt_out(x_Halt));
	M_mem ID_EX_M_MEM(.clk(clk), .rst_n(~rst_n), .MemWrite_in(d_MemWrite), .PCS_in(d_PCS), .LoadByte_in(d_LoadByte), .MemWrite_out(x_MemWrite), .PCS_out(x_PCS), .LoadByte_out(x_LoadByte));
	EX_mem ID_EX_EX_MEM(.clk(clk), .rst_n(~rst_n), .ALUsrc_in(d_ALUSrc), .ALUop_in(d_ALUop), .ByteSel_in(d_ByteSel), .set_N_in(d_set_N), .set_V_in(d_set_V), .set_Z_in(d_set_Z), .ALUsrc_out(x_ALUSrc), .ALUop_out(x_ALUop), .ByteSel_out(x_ByteSel), .set_N_out(x_set_N), .set_V_out(x_set_V), .set_Z_out(x_set_Z));
	ID_EX_mem iID_EX(.clk(clk), .rst_n(~rst_n), .PC_inc_in(d_PC_inc), .rdata_1_in(d_reg_data_1), .rdata_2_in(d_reg_data_2), .ext_data_in(d_ext_imm), .hbu_imm_in(d_hbu_imm), .rd_1_in(d_rd_1), .rd_2_in(d_rd_2), .wd_in(d_wd), .PC_inc_out(x_PC_inc), .rdata_1_out(x_reg_data_1), .rdata_2_out(x_reg_data_2), .ext_data_out(x_ext_imm), .hbu_imm_out(x_hbu_imm), .rd_1_out(x_rd_1), .rd_2_out(x_rd_2), .wd_out(x_wd));
	
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
	
	WB_mem EX_M_WB_MEM(.clk(clk), .rst_n(~rst_n), .RegWrite_in(x_RegWrite), .MemtoReg_in(x_MemtoReg), .Halt_in(x_Halt), .RegWrite_out(m_RegWrite), .MemtoReg_out(m_MemtoReg), .Halt_out(m_Halt));
	M_mem EX_M_M_MEM(.clk(clk), .rst_n(~rst_n), .MemWrite_in(x_MemWrite), .PCS_in(x_PCS), .LoadByte_in(x_LoadByte), .MemWrite_out(m_MemWrite), .PCS_out(m_PCS), .LoadByte_out(m_LoadByte));
	EX_M_mem iEX_M(.clk(clk), .rst_n(~rst_n), .PC_inc_in(x_PC_inc), .ALU_result_in(x_ALU_out), .wdata_in(x_wdata), .BitMask_in(x_BitMask_out), .rd_2_in(x_rd_2), .wd_in(x_wd), .PC_inc_out(m_PC_inc), .ALU_result_out(m_ALU_out), .wdata_out(m_wdata), .BitMask_out(m_BitMask_out), .rd_2_out(m_rd_2), .wd_out(m_wd));
	
	// memory datapath
	assign enable = m_MemtoReg | m_MemWrite;
	assign mem_write_data = m_forward_wdata ? reg_write_data : m_wdata;
	memory1c DataMEM(.data_out(m_mem_out), .data_in(mem_write_data), .addr(m_ALU_out), .enable(enable), .wr(m_MemWrite), .clk(clk), .rst(~rst_n));
	
	assign m_exec_out = m_PCS ? m_PC_inc :
						m_LoadByte ? m_BitMask_out :
						m_ALU_out;
	
	WB_mem M_WB_WB_MEM(.clk(clk), .rst_n(~rst_n), .RegWrite_in(m_RegWrite), .MemtoReg_in(m_MemtoReg), .Halt_in(m_Halt), .RegWrite_out(w_RegWrite), .MemtoReg_out(w_MemtoReg), .Halt_out(w_Halt));
	M_WB_mem iM_WB(.clk(clk), .rst_n(~rst_n), .mem_out_in(m_mem_out), .exec_out_in(m_exec_out), .wd_in(m_wd), .mem_out_out(w_mem_out), .exec_out_out(w_exec_out), .wd_out(w_wd));
	// writeback datapath
	assign reg_write_data = w_MemtoReg ? w_mem_out : w_exec_out;
	assign hlt = w_Halt;
	
endmodule 