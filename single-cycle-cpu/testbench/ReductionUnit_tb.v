module ReductionUnit_tb ();
	reg [15:0] A, B, Sol;
	wire [15:0] S;
	reg [8:0] AB, CD;
	ReductionUnit iDUT(.A(A), .B(B), .S(S));
	
	integer i;
	initial begin
		for (i = 0; i < 100000; i = i+1) begin
			A = $random;
			B = $random;
			Sol = (A[7:0] + B[7:0]) + (A[15:8] + B[15:8]);
			AB = (A[15:8] + B[15:8]);
			CD = (A[7:0] + B[7:0]);
			#1;
			if (S !== Sol) begin
				$display("Error A = %h, B = %h, S = %h, Expected = %h", A, B, S, Sol);
			end
		end
		
		$display("Test complete");
		$stop;
	end
endmodule