module M_WB_mem(clk, rst_n, mem_out_in, exec_out_in, wd_in, mem_out_out, exec_out_out, wd_out);
	input clk, rst_n;
	input [15:0] mem_out_in, exec_out_in;
	input [3:0] wd_in;
	output [15:0] mem_out_out, exec_out_out;
	output [3:0] wd_out;
	
	dff mem_out_reg[15:0](.q(mem_out_out), .d(mem_out_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff exec_out_reg[15:0](.q(exec_out_out), .d(exec_out_in), .wen(1'b1), .clk(clk), .rst(rst_n));

	dff wd_reg[3:0](.q(wd_out), .d(wd_in), .wen(1'b1), .clk(clk), .rst(rst_n));
endmodule