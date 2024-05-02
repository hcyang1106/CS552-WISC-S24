module bit_3_decoder(input [2:0] in, input en, output reg [7:0] out);
	always @(*) begin
		case (in)
			3'b000: out = 8'b00000001 & {8{en}};
			3'b001: out = 8'b00000010 & {8{en}};
			3'b010: out = 8'b00000100 & {8{en}};
			3'b011: out = 8'b00001000 & {8{en}};
			3'b100: out = 8'b00010000 & {8{en}};
			3'b101: out = 8'b00100000 & {8{en}};
			3'b110: out = 8'b01000000 & {8{en}};
			3'b111: out = 8'b10000000 & {8{en}};
			default: out = 8'b00000001 & {8{en}};
		endcase
	end
endmodule

module bit_2_decoder(input [1:0] in, input en, output reg [3:0] out);
	always @(*) begin
		case (in)
			2'b00: out = 4'b0001 & {4{en}};
			2'b01: out = 4'b0010 & {4{en}};
			2'b10: out = 4'b0100 & {4{en}};
			2'b11: out = 4'b1000 & {4{en}};
			default: out = 4'b0001 & {4{en}};
		endcase
	end
endmodule

module bit_4_decoder(input [3:0] in, input en, output [15:0] out);
	wire [3:0] out_1;
	
	bit_2_decoder decoder_1(.in(in[3:2]), .en(en), .out(out_1));
	bit_2_decoder decoder_2_0(.in(in[1:0]), .en(out_1[0]), .out(out[3:0]));
	bit_2_decoder decoder_2_1(.in(in[1:0]), .en(out_1[1]), .out(out[7:4]));
	bit_2_decoder decoder_2_2(.in(in[1:0]), .en(out_1[2]), .out(out[11:8]));
	bit_2_decoder decoder_2_3(.in(in[1:0]), .en(out_1[3]), .out(out[15:12]));
endmodule


module bit_7_decoder(input [6:0] in, input en, output [127:0] out);
	wire [7:0] out_1;

	bit_3_decoder decoder_1(.in(in[6:4]), .en(en), .out(out_1));
	
	bit_4_decoder decoder_2_0(.in(in[3:0]), .en(out_1[0]), .out(out[15:0]));
	bit_4_decoder decoder_2_1(.in(in[3:0]), .en(out_1[1]), .out(out[31:16]));
	bit_4_decoder decoder_2_2(.in(in[3:0]), .en(out_1[2]), .out(out[47:32]));
	bit_4_decoder decoder_2_3(.in(in[3:0]), .en(out_1[3]), .out(out[63:48]));
	bit_4_decoder decoder_2_4(.in(in[3:0]), .en(out_1[4]), .out(out[79:64]));
	bit_4_decoder decoder_2_5(.in(in[3:0]), .en(out_1[5]), .out(out[95:80]));
	bit_4_decoder decoder_2_6(.in(in[3:0]), .en(out_1[6]), .out(out[111:96]));
	bit_4_decoder decoder_2_7(.in(in[3:0]), .en(out_1[7]), .out(out[127:112]));
endmodule 