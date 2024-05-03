module ReadDecoder_4_16(input [3:0] RegId, output [15:0] Wordline);
    assign Wordline = (RegId == 4'd0)  ? 16'b0000000000000001 :
                      (RegId == 4'd1)  ? 16'b0000000000000010 :
                      (RegId == 4'd2)  ? 16'b0000000000000100 :
                      (RegId == 4'd3)  ? 16'b0000000000001000 :
                      (RegId == 4'd4)  ? 16'b0000000000010000 :
                      (RegId == 4'd5)  ? 16'b0000000000100000 :
                      (RegId == 4'd6)  ? 16'b0000000001000000 :
                      (RegId == 4'd7)  ? 16'b0000000010000000 :
                      (RegId == 4'd8)  ? 16'b0000000100000000 :
                      (RegId == 4'd9)  ? 16'b0000001000000000 :
                      (RegId == 4'd10) ? 16'b0000010000000000 :
                      (RegId == 4'd11) ? 16'b0000100000000000 :
                      (RegId == 4'd12) ? 16'b0001000000000000 :
                      (RegId == 4'd13) ? 16'b0010000000000000 :
                      (RegId == 4'd14) ? 16'b0100000000000000 :
                                         16'b1000000000000000;
endmodule

module WriteDecoder_4_16(input [3:0] RegId, input WriteReg, output [15:0] Wordline);
    assign Wordline = WriteReg ? ((RegId == 4'd0)  ? 16'b0000000000000001 :
                                  (RegId == 4'd1)  ? 16'b0000000000000010 :
                                  (RegId == 4'd2)  ? 16'b0000000000000100 :
                                  (RegId == 4'd3)  ? 16'b0000000000001000 :
                                  (RegId == 4'd4)  ? 16'b0000000000010000 :
                                  (RegId == 4'd5)  ? 16'b0000000000100000 :
                                  (RegId == 4'd6)  ? 16'b0000000001000000 :
                                  (RegId == 4'd7)  ? 16'b0000000010000000 :
                                  (RegId == 4'd8)  ? 16'b0000000100000000 :
                                  (RegId == 4'd9)  ? 16'b0000001000000000 :
                                  (RegId == 4'd10) ? 16'b0000010000000000 :
                                  (RegId == 4'd11) ? 16'b0000100000000000 :
                                  (RegId == 4'd12) ? 16'b0001000000000000 :
                                  (RegId == 4'd13) ? 16'b0010000000000000 :
                                  (RegId == 4'd14) ? 16'b0100000000000000 :
                                                     16'b1000000000000000) : 16'b0;
endmodule

module BitCell(input clk, input rst, input D, input WriteEnable, input ReadEnable1, input
ReadEnable2, inout Bitline1, inout Bitline2);
    wire q;

    DFlipFlop dff(
        .q(q),
        .d(D),
        .wen(WriteEnable),
        .clk(clk),
        .rst(rst)
    );

    assign Bitline1 = ReadEnable1 ? q : 1'bz;
    assign Bitline2 = ReadEnable2 ? q : 1'bz;

endmodule

module Register(input clk, input rst, input [15:0] D, input WriteReg, input ReadEnable1, input
ReadEnable2, inout [15:0] Bitline1, inout [15:0] Bitline2);

    BitCell b15(.clk(clk), .rst(rst), .D(D[15]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[15]), .Bitline2(Bitline2[15]));
    BitCell b14(.clk(clk), .rst(rst), .D(D[14]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[14]), .Bitline2(Bitline2[14]));
    BitCell b13(.clk(clk), .rst(rst), .D(D[13]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[13]), .Bitline2(Bitline2[13]));
    BitCell b12(.clk(clk), .rst(rst), .D(D[12]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[12]), .Bitline2(Bitline2[12]));
    BitCell b11(.clk(clk), .rst(rst), .D(D[11]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[11]), .Bitline2(Bitline2[11]));
    BitCell b10(.clk(clk), .rst(rst), .D(D[10]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[10]), .Bitline2(Bitline2[10]));
    BitCell b9(.clk(clk), .rst(rst), .D(D[9]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[9]), .Bitline2(Bitline2[9]));
    BitCell b8(.clk(clk), .rst(rst), .D(D[8]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[8]), .Bitline2(Bitline2[8]));
    BitCell b7(.clk(clk), .rst(rst), .D(D[7]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[7]), .Bitline2(Bitline2[7]));
    BitCell b6(.clk(clk), .rst(rst), .D(D[6]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[6]), .Bitline2(Bitline2[6]));
    BitCell b5(.clk(clk), .rst(rst), .D(D[5]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[5]), .Bitline2(Bitline2[5]));
    BitCell b4(.clk(clk), .rst(rst), .D(D[4]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[4]), .Bitline2(Bitline2[4]));
    BitCell b3(.clk(clk), .rst(rst), .D(D[3]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[3]), .Bitline2(Bitline2[3]));
    BitCell b2(.clk(clk), .rst(rst), .D(D[2]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[2]), .Bitline2(Bitline2[2]));
    BitCell b1(.clk(clk), .rst(rst), .D(D[1]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[1]), .Bitline2(Bitline2[1]));
    BitCell b0(.clk(clk), .rst(rst), .D(D[0]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[0]), .Bitline2(Bitline2[0]));

endmodule

module RegFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0]
DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

    wire [15:0] ReadEnable1, ReadEnable2, WriteEnable;
    wire [15:0] BitLine15_1, BitLine15_2, BitLine14_1, BitLine14_2, BitLine13_1, BitLine13_2,
                BitLine12_1, BitLine12_2, BitLine11_1, BitLine11_2, BitLine10_1, BitLine10_2,
                BitLine9_1, BitLine9_2, BitLine8_1, BitLine8_2, BitLine7_1, BitLine7_2,
                BitLine6_1, BitLine6_2, BitLine5_1, BitLine5_2, BitLine4_1, BitLine4_2,
                BitLine3_1, BitLine3_2, BitLine2_1, BitLine2_2, BitLine1_1, BitLine1_2,
                BitLine0_1, BitLine0_2;

    ReadDecoder_4_16 rd1(SrcReg1, ReadEnable1);
    ReadDecoder_4_16 rd2(SrcReg2, ReadEnable2);
    WriteDecoder_4_16 wd(DstReg, WriteReg, WriteEnable);

    Register r15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[15]), .ReadEnable1(ReadEnable1[15]), .ReadEnable2(ReadEnable2[15]), .Bitline1(BitLine15_1), .Bitline2(BitLine15_2));
    Register r14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[14]), .ReadEnable1(ReadEnable1[14]), .ReadEnable2(ReadEnable2[14]), .Bitline1(BitLine14_1), .Bitline2(BitLine14_2));
    Register r13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[13]), .ReadEnable1(ReadEnable1[13]), .ReadEnable2(ReadEnable2[13]), .Bitline1(BitLine13_1), .Bitline2(BitLine13_2));
    Register r12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[12]), .ReadEnable1(ReadEnable1[12]), .ReadEnable2(ReadEnable2[12]), .Bitline1(BitLine12_1), .Bitline2(BitLine12_2));
    Register r11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[11]), .ReadEnable1(ReadEnable1[11]), .ReadEnable2(ReadEnable2[11]), .Bitline1(BitLine11_1), .Bitline2(BitLine11_2));
    Register r10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[10]), .ReadEnable1(ReadEnable1[10]), .ReadEnable2(ReadEnable2[10]), .Bitline1(BitLine10_1), .Bitline2(BitLine10_2));
    Register r9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[9]), .ReadEnable1(ReadEnable1[9]), .ReadEnable2(ReadEnable2[9]), .Bitline1(BitLine9_1), .Bitline2(BitLine9_2));
    Register r8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[8]), .ReadEnable1(ReadEnable1[8]), .ReadEnable2(ReadEnable2[8]), .Bitline1(BitLine8_1), .Bitline2(BitLine8_2));
    Register r7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[7]), .ReadEnable1(ReadEnable1[7]), .ReadEnable2(ReadEnable2[7]), .Bitline1(BitLine7_1), .Bitline2(BitLine7_2));
    Register r6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[6]), .ReadEnable1(ReadEnable1[6]), .ReadEnable2(ReadEnable2[6]), .Bitline1(BitLine6_1), .Bitline2(BitLine6_2));
    Register r5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[5]), .ReadEnable1(ReadEnable1[5]), .ReadEnable2(ReadEnable2[5]), .Bitline1(BitLine5_1), .Bitline2(BitLine5_2));
    Register r4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[4]), .ReadEnable1(ReadEnable1[4]), .ReadEnable2(ReadEnable2[4]), .Bitline1(BitLine4_1), .Bitline2(BitLine4_2));
    Register r3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[3]), .ReadEnable1(ReadEnable1[3]), .ReadEnable2(ReadEnable2[3]), .Bitline1(BitLine3_1), .Bitline2(BitLine3_2));
    Register r2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[2]), .ReadEnable1(ReadEnable1[2]), .ReadEnable2(ReadEnable2[2]), .Bitline1(BitLine2_1), .Bitline2(BitLine2_2));
    Register r1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[1]), .ReadEnable1(ReadEnable1[1]), .ReadEnable2(ReadEnable2[1]), .Bitline1(BitLine1_1), .Bitline2(BitLine1_2));
    Register r0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[0]), .ReadEnable1(ReadEnable1[0]), .ReadEnable2(ReadEnable2[0]), .Bitline1(BitLine0_1), .Bitline2(BitLine0_2));

    assign SrcData1 = ReadEnable1[0] ? BitLine0_1 :
          ReadEnable1[1] ? BitLine1_1 :
          ReadEnable1[2] ? BitLine2_1 :
          ReadEnable1[3] ? BitLine3_1 :
          ReadEnable1[4] ? BitLine4_1 :
          ReadEnable1[5] ? BitLine5_1 :
          ReadEnable1[6] ? BitLine6_1 :
          ReadEnable1[7] ? BitLine7_1 :
          ReadEnable1[8] ? BitLine8_1 :
          ReadEnable1[9] ? BitLine9_1 :
          ReadEnable1[10] ? BitLine10_1 :
          ReadEnable1[11] ? BitLine11_1 :
          ReadEnable1[12] ? BitLine12_1 :
          ReadEnable1[13] ? BitLine13_1 :
          ReadEnable1[14] ? BitLine14_1 :
          ReadEnable1[15] ? BitLine15_1 : 0;

    assign SrcData2 = ReadEnable2[0] ? BitLine0_2 :
          ReadEnable2[1] ? BitLine1_2 :
          ReadEnable2[2] ? BitLine2_2 :
          ReadEnable2[3] ? BitLine3_2 :
          ReadEnable2[4] ? BitLine4_2 :
          ReadEnable2[5] ? BitLine5_2 :
          ReadEnable2[6] ? BitLine6_2 :
          ReadEnable2[7] ? BitLine7_2 :
          ReadEnable2[8] ? BitLine8_2 :
          ReadEnable2[9] ? BitLine9_2 :
          ReadEnable2[10] ? BitLine10_2 :
          ReadEnable2[11] ? BitLine11_2 :
          ReadEnable2[12] ? BitLine12_2 :
          ReadEnable2[13] ? BitLine13_2 :
          ReadEnable2[14] ? BitLine14_2 :
          ReadEnable2[15] ? BitLine15_2 : 0;
endmodule