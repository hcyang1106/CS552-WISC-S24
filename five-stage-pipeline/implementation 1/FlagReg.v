module FlagReg (clk, rst, N_in, Z_in, V_in, set_N, set_Z, set_V, N, Z, V);
	input clk, rst;
	input N_in, Z_in, V_in;
	input set_N, set_Z, set_V;
	input N, Z, V;

	dff iN(.q(N), .d(N_in), .wen(set_N), .clk(clk), .rst(rst));
	dff iZ(.q(Z), .d(Z_in), .wen(set_Z), .clk(clk), .rst(rst));
	dff iV(.q(V), .d(V_in), .wen(set_V), .clk(clk), .rst(rst));
endmodule