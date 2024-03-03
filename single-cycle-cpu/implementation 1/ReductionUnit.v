module ReductionUnit (input [15:0] A, input [15:0] B, output [15:0] S);

	wire carryAB, carryCD, carryLM, carryMU;
	wire [8:0] S_AB, S_CD;
	wire [15:0] S_9bit;
	
	cla_4bit lowerAB(.A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .S(S_AB[3:0]), .Cout(carryAB), .ovfl());
	cla_4bit upperAB(.A(A[15:12]), .B(B[15:12]), .Cin(carryAB), .S(S_AB[7:4]), .Cout(S_AB[8]), .ovfl());

	cla_4bit lowerCD(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(S_CD[3:0]), .Cout(carryCD), .ovfl());
	cla_4bit upperCD(.A(A[7:4]), .B(B[7:4]), .Cin(carryCD), .S(S_CD[7:4]), .Cout(S_CD[8]), .ovfl());
	
	cla_4bit reduction_9bit_low(.A(S_AB[3:0]), .B(S_CD[3:0]), .Cin(1'b0), .S(S_9bit[3:0]), .Cout(carryLM), .ovfl());
	cla_4bit reduction_9bit_middle(.A(S_AB[7:4]), .B(S_CD[7:4]), .Cin(carryLM), .S(S_9bit[7:4]), .Cout(carryMU), .ovfl());
	cla_4bit reduction_9bit_upper(.A({3'h0, S_AB[8]}), .B({3'h0, S_CD[8]}), .Cin(carryMU), .S(S_9bit[11:8]), .Cout(S_9bit[12]), .ovfl());
	
	assign S = {{6{S_9bit[9]}}, S_9bit[9:0]};
endmodule

