module IF_ID_mem(clk, rst_n, flush, stall, instruction_in, PC_inc_in, instruction_out, PC_inc_out, flush_out);
	input clk, rst_n;
	input flush;
	input stall;
	input [15:0] instruction_in;
	input [15:0] PC_inc_in;
	output [15:0] instruction_out;
	output [15:0] PC_inc_out;
	output flush_out;
	
	wire wen;
	wire [15:0] instruction;
	
	assign wen = ~stall;
	assign instruction = flush ? 16'h0000 : instruction_in;
	
	dff flush_reg(.q(flush_out), .d(flush), .wen(wen), .clk(clk), .rst(rst_n));
	dff instruction_reg[15:0](.q(instruction_out), .d(instruction), .wen(wen), .clk(clk), .rst(rst_n));
	dff PC_inc_reg[15:0](.q(PC_inc_out), .d(PC_inc_in), .wen(wen), .clk(clk), .rst(rst_n));

endmodule