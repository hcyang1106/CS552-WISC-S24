module EX_mem(clk, rst_n, ALUsrc_in, ALUop_in, ByteSel_in, set_N_in, set_V_in, set_Z_in, ALUsrc_out, ALUop_out, ByteSel_out, set_N_out, set_V_out, set_Z_out);
	input clk;
	input rst_n;
	input [2:0] ALUop_in;
	input ALUsrc_in, ByteSel_in, set_N_in, set_V_in, set_Z_in;
	output ALUsrc_out, ByteSel_out, set_N_out, set_V_out, set_Z_out;
	output [2:0] ALUop_out;
	
	dff ALUsrc(.q(ALUsrc_in), .d(ALUsrc_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff ByteSel(.q(ByteSel_in), .d(ByteSel_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff set_N(.q(set_N_in), .d(set_N_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff set_V(.q(set_V_in), .d(set_V_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff set_Z(.q(set_Z_in), .d(set_Z_out), .wen(1'b1), .clk(clk), .rst(rst));
	
	dff ALUop_0(.q(ALUop_in[0]), .d(ALUop_out[0]), .wen(1'b1), .clk(clk), .rst(rst));
	dff ALUop_1(.q(ALUop_in[1]), .d(ALUop_out[1]), .wen(1'b1), .clk(clk), .rst(rst));
	dff ALUop_2(.q(ALUop_in[2]), .d(ALUop_out[2]), .wen(1'b1), .clk(clk), .rst(rst));
	
endmodule