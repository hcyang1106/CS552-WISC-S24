module decoder_tb();
	integer i;

	reg en;
	wire [127:0] out;

	bit_7_decoder DUT(.in(i), .en(en), .out(out));
	initial begin
		en = 1;
		for (i = 0; i < 128; i = i + 1) begin
			#1;
			if (out != (1'b1 << i)) begin
				$display("ERROR: out = %d", out);
			end
			else begin
				$display("%d", out);
			end
		end
		
		$stop();
	end
endmodule