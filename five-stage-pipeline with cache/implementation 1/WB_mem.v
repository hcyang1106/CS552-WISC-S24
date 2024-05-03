module WB_mem(clk, rst_n, stall, RegWrite_in, MemtoReg_in, Halt_in, RegWrite_out, MemtoReg_out, Halt_out);
	input clk, stall;
	input rst_n;
	input RegWrite_in, MemtoReg_in, Halt_in;
	output RegWrite_out, MemtoReg_out, Halt_out;
	
	assign wen = ~stall;
	
	dff RegWrite(.q(RegWrite_out), .d(RegWrite_in), .wen(wen), .clk(clk), .rst(rst_n));
	dff MemtoReg(.q(MemtoReg_out), .d(MemtoReg_in), .wen(wen), .clk(clk), .rst(rst_n));
	dff Halt(.q(Halt_out), .d(Halt_in), .wen(wen), .clk(clk), .rst(rst_n));

endmodule