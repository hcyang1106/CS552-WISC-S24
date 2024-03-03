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