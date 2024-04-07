module M_mem(clk, rst_n, MemWrite_in, PCS_in, LoadByte_in, MemWrite_out, PCS_out, LoadByte_out);
	input clk;
	input rst_n;
	input MemWrite_in, PCS_in, LoadByte_in;
	output MemWrite_out, PCS_out, LoadByte_out;
	
	dff MemWrite(.q(MemWrite_out), .d(MemWrite_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff PCS(.q(PCS_out), .d(PCS_in), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff LoadByte(.q(LoadByte_out), .d(LoadByte_in), .wen(1'b1), .clk(clk), .rst(rst_n));

endmodule