module EX_M_mem(clk, rst_n, PC_inc_in, ALU_result_in, wdata_in, BitMask_in, rd_2_in, wd_in, PC_inc_out, ALU_result_out, wdata_out, BitMask_out, rd_2_out, wd_out);
	input clk, rst_n;
	input [15:0] PC_inc_in, ALU_result_in, wdata_in, BitMask_in;
	input [3:0] rd_2_in, wd_in;
	output [15:0] PC_inc_out, ALU_result_out, wdata_out, BitMask_out;
	output [3:0] rd_2_out, wd_out;
	
	dff PC_inc_reg[15:0](.q(PC_inc_out), .d(PC_inc_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff ALU_result_reg[15:0](.q(ALU_result_out), .d(ALU_result_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff wdata_reg[15:0](.q(wdata_out), .d(wdata_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff BitMask_reg[15:0](.q(BitMask_out), .d(BitMask_in), .wen(1'b1), .clk(clk), .rst(rst_n));

	dff rd_2_reg[3:0](.q(rd_2_out), .d(rd_2_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff wd_reg[3:0](.q(wd_out), .d(wd_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	
endmodule