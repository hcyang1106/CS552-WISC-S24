module ID_EX_mem(clk, rst_n, PC_inc_in, rdata_1_in, rdata_2_in, ext_data_in, hbu_imm_in, rd_1_in, rd_2_in, wd_in, PC_inc_out, rdata_1_out, rdata_2_out, ext_data_out, hbu_imm_out, rd_1_out, rd_2_out, wd_out);
	input clk, rst_n;
	input [15:0] PC_inc_in, rdata_1_in, rdata_2_in, ext_data_in;
	input [7:0] hbu_imm_in;
	input [3:0] rd_1_in, rd_2_in, wd_in;
	output [15:0] PC_inc_out, rdata_1_out, rdata_2_out, ext_data_out;
	output [7:0] hbu_imm_out;
	output [3:0] rd_1_out, rd_2_out, wd_out;
	
	dff PC_inc_reg[15:0](.q(PC_inc_out), .d(PC_inc_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff rdata_1_reg[15:0](.q(rdata_1_out), .d(rdata_1_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff rdata_2_reg[15:0](.q(rdata_2_out), .d(rdata_2_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff ext_data_reg[15:0](.q(ext_data_out), .d(ext_data_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff hbu_imm_reg[7:0](.q(hbu_imm_out), .d(hbu_imm_in), .wen(1'b1), .clk(clk), .rst(rst_n));

	dff rd_1_reg[3:0](.q(rd_1_out), .d(rd_1_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff rd_2_reg[3:0](.q(rd_2_out), .d(rd_2_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff wd_reg[3:0](.q(wd_out), .d(wd_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	
endmodule