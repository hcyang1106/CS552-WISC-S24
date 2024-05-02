module paddsb (input [15:0] A, input [15:0] B, output [15:0] out);

	wire AE_of, BF_of, CG_of, DH_of;
	wire AE_cout, BF_cout, CG_cout, DH_cout;
	
	wire [3:0] AE_out, BF_out, CG_out, DH_out;
	wire [3:0] AE_sat, BF_sat, CG_sat, DH_sat;

	cla_4bit AE(.A(A[15:12]), .B(B[15:12]), .Cin(1'b0), .S(AE_out), .Cout(AE_cout), .ovfl(AE_of));
	cla_4bit BF(.A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .S(BF_out), .Cout(BF_cout), .ovfl(BF_of));
	cla_4bit CG(.A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .S(CG_out), .Cout(CG_cout), .ovfl(CG_of));
	cla_4bit DH(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(DH_out), .Cout(DH_cout), .ovfl(DH_of));
	
	assign AE_sat = AE_of ? (AE_cout ? 4'b1000 : 4'b0111) : AE_out;
	assign BF_sat = BF_of ? (BF_cout ? 4'b1000 : 4'b0111) : BF_out;
	assign CG_sat = CG_of ? (CG_cout ? 4'b1000 : 4'b0111) : CG_out;
	assign DH_sat = DH_of ? (DH_cout ? 4'b1000 : 4'b0111) : DH_out;
	
	assign out = {AE_sat, BF_sat, CG_sat, DH_sat};
endmodule