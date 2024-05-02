module decoder_7_128(in, out);
    input[6:0] in;
    output[127:0] out;
    
    wire[7:0] enLine;
    
    decoder_3_8 first(.in(in[6:4]), .out(enLine), .en(1'b1));
    
    decoder_4_16 last[7:0](.in(in[3:0]), .en(enLine[7:0]), .out(out));
    
endmodule

module decoder_3_8(in, en, out);
    input en;
	input [2:0] in;
	output [7:0] out;
    
    wire [7:0] tempOut;

	assign tempOut[7] = in[2] & in[1] & in[0];
	assign tempOut[6] = in[2] & in[1] & ~in[0];
	assign tempOut[5] = in[2] & ~in[1] & in[0];
	assign tempOut[4] = in[2] & ~in[1] & ~in[0];
	assign tempOut[3] = ~in[2] & in[1] & in[0];
	assign tempOut[2] = ~in[2] & in[1] & ~in[0];
	assign tempOut[1] = ~in[2] & ~in[1] & in[0];
	assign tempOut[0] = ~in[2] & ~in[1] & ~in[0];
    
    assign out = en ? tempOut : 8'h00;

endmodule

module decoder_4_16(in, en, out);
    input en;
	input [3:0] in;
	output [15:0] out;
    
    wire[15:0] tempOut;

	assign tempOut[15] = in[3] & in[2] & in[1] & in[0];
	assign tempOut[14] = in[3] & in[2] & in[1] & ~in[0];
	assign tempOut[13] = in[3] & in[2] & ~in[1] & in[0];
	assign tempOut[12] = in[3] & in[2] & ~in[1] & ~in[0];
	assign tempOut[11] = in[3] & ~in[2] & in[1] & in[0];
	assign tempOut[10] = in[3] & ~in[2] & in[1] & ~in[0];
	assign tempOut[9] = in[3] & ~in[2] & ~in[1] & in[0];
	assign tempOut[8] = in[3] & ~in[2] & ~in[1] & ~in[0];
	assign tempOut[7] = ~in[3] & in[2] & in[1] & in[0];
	assign tempOut[6] = ~in[3] & in[2] & in[1] & ~in[0];
	assign tempOut[5] = ~in[3] & in[2] & ~in[1] & in[0];
	assign tempOut[4] = ~in[3] & in[2] & ~in[1] & ~in[0];
	assign tempOut[3] = ~in[3] & ~in[2] & in[1] & in[0];
	assign tempOut[2] = ~in[3] & ~in[2] & in[1] & ~in[0];
	assign tempOut[1] = ~in[3] & ~in[2] & ~in[1] & in[0];
	assign tempOut[0] = ~in[3] & ~in[2] & ~in[1] & ~in[0];
    
    assign out = en ? tempOut : 16'h0000;
    

endmodule

module decoder_6_64(in, out);
    input[5:0] in;
    output[63:0] out;
    
    wire[7:0] enLine;
    
    decoder_3_8 first(.in(in[5:3]), .out(enLine), .en(1'b1));
    
    decoder_3_8 last[7:0](.in(in[2:0]), .en(enLine[7:0]), .out(out));
    
endmodule