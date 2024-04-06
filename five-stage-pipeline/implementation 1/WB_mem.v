module WB_mem(clk, rst_n, RegWrite_in, MemtoReg_in, Halt_in, RegWrite_out, MemtoReg_out, Halt_out);
	input clk;
	input rst_n;
	input RegWrite_in, MemtoReg_in, Halt_in;
	output RegWrite_out, MemtoReg_out, Halt_out;
	
	dff RegWrite(.q(RegWrite_in), .d(RegWrite_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff MemtoReg(.q(MemtoReg_in), .d(MemtoReg_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff Halt(.q(Halt_in), .d(Halt_out), .wen(1'b1), .clk(clk), .rst(rst));

endmodule