module cla_4bit (input [3:0] A, input [3:0] B, input Cin, output [3:0] S, output Cout, output ovfl);

	wire [2:0] carries;
	wire [3:0] G, P;
	
	assign carries[0] = G[0] | (Cin & P[0]);
	assign carries[1] = G[1] | (G[0] & P[1]) | (Cin & P[0] & P[1]) ;
	assign carries[2] = G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (Cin & P[0] & P[1] & P[2]);
	assign Cout = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (Cin & P[0] & P[1] & P[2] & P[3]);
	
	assign ovfl = carries[2] ^ Cout;
	full_adder_1bit iAdder[3:0] (.A(A), .B(B), .Cin({carries, Cin}), .S(S), .G(G), .P(P)); 

endmodule