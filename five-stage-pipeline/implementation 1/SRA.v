module SRA(input [15:0] in, input [3:0] shamt, output [15:0] out);
	
	wire [15:0] stage;
	
	assign stage = shamt[0] ? (shamt[1] ? {{3{in[15]}}, in[15:3]} : {{1{in[15]}}, in[15:1]}) : (shamt[1] ? {{2{in[15]}}, in[15:2]} : in);
	assign out = shamt[2] ? (shamt[3] ? {{12{stage[15]}}, stage[15:12]} : {{4{stage[15]}}, stage[15:4]}) : (shamt[3] ? {{8{stage[15]}}, stage[15:8]} : stage);

endmodule

