module paddsb_tb ();
	reg [15:0] A, B, Solution;
	wire [15:0] out;
	paddsb iDUT(.A(A), .B(B), .out(out));
	
	reg [3:0] AE, BF, CG, DH;
	
	integer i;
	initial begin
		for (i = 0; i < 100000; i = i+1) begin
			A = $random;
			B = $random;
		
			AE = A[15:12] + B[15:12];
			BF = A[11:8] + B[11:8];
			CG = A[7:4] + B[7:4];
			DH = A[3:0] + B[3:0];
		
			if ((A[15] === B[15]) && (A[15] !== AE[3])) begin
				AE = A[15] ? 4'b1000 : 4'b0111;
			end
			if ((A[11] === B[11]) && (A[11] !== BF[3])) begin
				BF = A[11] ? 4'b1000 : 4'b0111;
			end
			if ((A[7] === B[7]) && (A[7] !== CG[3])) begin
				CG = A[7] ? 4'b1000 : 4'b0111;
			end
			if ((A[3] === B[3]) && (A[3] !== DH[3])) begin
				DH = A[3] ? 4'b1000 : 4'b0111;
			end
			
			Solution = {AE, BF, CG, DH};
		
			#1;
			if (out !== Solution) begin
				$display("Error A = %h, B = %h, S = %h, Expected = %h", A, B, out, Solution);
			end
		end
		
		$display("Test complete");
		$stop;
	end
endmodule