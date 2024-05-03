module EX_mem(clk, rst_n, stall, ALUsrc_in, ALUop_in, ByteSel_in, set_N_in, set_V_in, set_Z_in, ALUsrc_out, ALUop_out, ByteSel_out, set_N_out, set_V_out, set_Z_out);
	input clk, stall;
	input rst_n;
	input [2:0] ALUop_in;
	input ALUsrc_in, ByteSel_in, set_N_in, set_V_in, set_Z_in;
	output ALUsrc_out, ByteSel_out, set_N_out, set_V_out, set_Z_out;
	output [2:0] ALUop_out;
	
	assign wen = ~stall;
	
	dff ALUsrc(.q(ALUsrc_out), .d(ALUsrc_in), .wen(wen), .clk(clk), .rst(rst_n));
	dff ByteSel(.q(ByteSel_out), .d(ByteSel_in), .wen(wen), .clk(clk), .rst(rst_n));
	dff set_N(.q(set_N_out), .d(set_N_in), .wen(wen), .clk(clk), .rst(rst_n));
	dff set_V(.q(set_V_out), .d(set_V_in), .wen(wen), .clk(clk), .rst(rst_n));
	dff set_Z(.q(set_Z_out), .d(set_Z_in), .wen(wen), .clk(clk), .rst(rst_n));
	
	dff ALUop_0(.q(ALUop_out[0]), .d(ALUop_in[0]), .wen(wen), .clk(clk), .rst(rst_n));
	dff ALUop_1(.q(ALUop_out[1]), .d(ALUop_in[1]), .wen(wen), .clk(clk), .rst(rst_n));
	dff ALUop_2(.q(ALUop_out[2]), .d(ALUop_in[2]), .wen(wen), .clk(clk), .rst(rst_n));
	
endmodule