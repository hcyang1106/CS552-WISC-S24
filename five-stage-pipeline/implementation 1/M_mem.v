module M_mem(clk, rst_n, MemWrite_in, PCS_in, LoadByte_in, MemWrite_out, PCS_out, LoadByte_out);
	input clk;
	input rst_n;
	input MemWrite_in, PCS_in, LoadByte_in;
	output MemWrite_out, PCS_out, LoadByte_out;
	
	dff MemWrite(.q(MemWrite_in), .d(MemWrite_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff PCS(.q(PCS_in), .d(PCS_out), .wen(1'b1), .clk(clk), .rst(rst));
	dff LoadByte(.q(LoadByte_in), .d(LoadByte_out), .wen(1'b1), .clk(clk), .rst(rst));

endmodule