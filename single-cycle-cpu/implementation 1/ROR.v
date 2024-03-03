module ROR(input [15:0] in, input [3:0] shamt, output [15:0] out);
	
	wire [15:0] stage;
	
	assign stage = shamt[0] ? (shamt[1] ? {in[2:0], in[15:3]} : {in[0], in[15:1]}) : (shamt[1] ? {in[1:0], in[15:2]} : in);
	assign out = shamt[2] ? (shamt[3] ? {stage[11:0], stage[15:12]} : {stage[3:0], stage[15:4]}) : (shamt[1] ? {stage[7:0], stage[15:8]} : stage);

endmodule

