module SLL(input [15:0] in, input [3:0] shamt, output [15:0] out);

	wire [15:0] stage;
	
	assign stage = shamt[0] ? (shamt[1] ? in << 3 : in << 1) : (shamt[1] ? in << 2 : in);
	assign out = shamt[2] ? (shamt[3] ? stage << 12 : stage << 4) : (shamt[3] ? stage << 8 : stage);

endmodule

