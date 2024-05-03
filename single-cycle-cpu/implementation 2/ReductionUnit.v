module full_adder_1bit(
    input A,
    input B,
    input Cin,
    output S,
	output G,
	output P
);

wire w1, w2, w3;

xor (w1, A, B);
xor (S, w1, Cin);

and (w2, w1, Cin);
and (w3, A, B);

assign G = A & B;
assign P = A ^ B;

endmodule

module cla_4bit (input [3:0] A, input [3:0] B, input Cin, output [3:0] S, output Cout);

	wire [2:0] carries;
	wire [3:0] G, P;
	
	assign carries[0] = G[0] | (Cin & P[0]);
	assign carries[1] = G[1] | (G[0] & P[1]) | (Cin & P[0] & P[1]) ;
	assign carries[2] = G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (Cin & P[0] & P[1] & P[2]);
	assign Cout = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (Cin & P[0] & P[1] & P[2] & P[3]);
	
	full_adder_1bit iAdder[3:0] (.A(A), .B(B), .Cin({carries, Cin}), .S(S), .G(G), .P(P)); 

endmodule

module ReductionUnit (input [15:0] A, input [15:0] B, output [15:0] S);

	wire carryAB, carryCD, carryLM, carryMU;
	wire [8:0] S_AB, S_CD;
	
	cla_4bit lowerAB(.A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .S(S_AB[3:0]), .Cout(carryAB));
	cla_4bit upperAB(.A(A[15:12]), .B(B[15:12]), .Cin(carryAB), .S(S_AB[7:4]), .Cout(S_AB[8]));

	cla_4bit lowerCD(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(S_CD[3:0]), .Cout(carryCD));
	cla_4bit upperCD(.A(A[7:4]), .B(B[7:4]), .Cin(carryCD), .S(S_CD[7:4]), .Cout(S_CD[8]));
	
	cla_4bit reduction_9bit_low(.A(S_AB[3:0]), .B(S_CD[3:0]), .Cin(1'b0), .S(S[3:0]), .Cout(carryLM));
	cla_4bit reduction_9bit_middle(.A(S_AB[7:4]), .B(S_CD[7:4]), .Cin(carryLM), .S(S[7:4]), .Cout(carryMU));
	cla_4bit reduction_9bit_upper(.A({3'h0, S_AB[8]}), .B({3'h0, S_CD[8]}), .Cin(carryMU), .S(S[11:8]), .Cout(S[12]));
	
	assign S[15:13] = 3'h0;


endmodule
