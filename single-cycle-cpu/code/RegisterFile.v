// Gokul's D-flipflop

module dff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	   wen; //Write Enable
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state;

    assign q = state;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    end

endmodule

module ReadDecoder_4_16(input [3:0] RegId, output [15:0] Wordline);
	assign Wordline[0] = ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];
	assign Wordline[1] = ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];
	assign Wordline[2] = ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];
	assign Wordline[3] = ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0];
	
	assign Wordline[4] = ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];
	assign Wordline[5] = ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0];
	assign Wordline[6] = ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0];
	assign Wordline[7] = ~RegId[3] & RegId[2] & RegId[1] & RegId[0];
	
	assign Wordline[8] = RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];
	assign Wordline[9] = RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];
	assign Wordline[10] = RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];
	assign Wordline[11] = RegId[3] & ~RegId[2] & RegId[1] & RegId[0];
	
	assign Wordline[12] = RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];
	assign Wordline[13] = RegId[3] & RegId[2] & ~RegId[1] & RegId[0];
	assign Wordline[14] = RegId[3] & RegId[2] & RegId[1] & ~RegId[0];
	assign Wordline[15] = RegId[3] & RegId[2] & RegId[1] & RegId[0];
endmodule

module WriteDecoder_4_16(input [3:0] RegId, input WriteReg, output [15:0] Wordline);
	assign Wordline[0] = ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[1] = ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0] & WriteReg;
	assign Wordline[2] = ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[3] = ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0] & WriteReg;
	
	assign Wordline[4] = ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[5] = ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0] & WriteReg;
	assign Wordline[6] = ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[7] = ~RegId[3] & RegId[2] & RegId[1] & RegId[0] & WriteReg;
	
	assign Wordline[8] = RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[9] = RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0] & WriteReg;
	assign Wordline[10] = RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[11] = RegId[3] & ~RegId[2] & RegId[1] & RegId[0] & WriteReg;
	
	assign Wordline[12] = RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[13] = RegId[3] & RegId[2] & ~RegId[1] & RegId[0] & WriteReg;
	assign Wordline[14] = RegId[3] & RegId[2] & RegId[1] & ~RegId[0] & WriteReg;
	assign Wordline[15] = RegId[3] & RegId[2] & RegId[1] & RegId[0] & WriteReg;
endmodule

module BitCell( input clk,  input rst, input D, input WriteEnable, input ReadEnable1, input ReadEnable2, inout Bitline1, inout Bitline2);
	
	wire q, out;
	
	assign out = WriteEnable ? D : q;
	
	bufif1 line1(Bitline1, out, ReadEnable1);
	bufif1 line2(Bitline2, out, ReadEnable2);

	dff iDFF(.q(q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

endmodule

module Register( input clk,  input rst, input [15:0] D, input WriteReg, input ReadEnable1, input ReadEnable2, inout [15:0] Bitline1, inout [15:0] Bitline2);
	BitCell iCell[15:0] (.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));
endmodule

module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0] DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);
	wire [15:0] ReadEnable1, ReadEnable2, WriteLine;
	
	ReadDecoder_4_16 ReadDecode1(.RegId(SrcReg1), .Wordline(ReadEnable1));
	ReadDecoder_4_16 ReadDecode2(.RegId(SrcReg2), .Wordline(ReadEnable2));
	WriteDecoder_4_16 WriteDecode(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteLine));
	Register iRegister[15:0] (.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteLine), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(SrcData1), .Bitline2(SrcData2));
endmodule