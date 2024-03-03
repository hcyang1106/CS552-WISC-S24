module HalfBitMask (input [15:0] Rd, input [7:0] imm, input ctrl, output out);
	// ctrl = 1, LHB
	// ctrl = 0, LLB
	assign out = ctrl ? {imm, Rd[7:0]} : {Rd[15:8], imm};
endmodule