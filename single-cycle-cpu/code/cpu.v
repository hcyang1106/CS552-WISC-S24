module cpu(clk, rst_n, hlt, pc);

    input clk, rst_n;
    output hlt;
    output [15:0] pc;

    // component outputs
    wire [15:0] pc_out, addpc_out, im_out, dm_out, rf_out_1, rf_out_2, alu_out, 
                writeregsrc_mux_out, signext4_out, signext8_out, shift_out, shiftimm_mux_out,
                alusrc_mux_out, unused_16b_in;
    wire [3:0] readreg1src_mux_out, readreg2src_mux_out;
    wire V, addpc_ovfl; // V represents overflow, addpc_ovfl unused

    // control signals
    wire [1:0] ALUSrc, WriteRegSrc;
    wire [3:0] ALUOp;
    wire MemWrite, BInv, RegWrite, ShiftImm, ReadReg1Src, ReadReg2Src, Halt;

    // fixed setting
    wire [15:0] word_len = 16'h2;
    wire addpc_sub = 1'b0, im_wen = 1'b0;

    PC PC(.in(addpc_out), .wen(~Halt), .clk(clk), .rst(~rst_n), .out(pc_out));
    Add AddPC(.a(pc_out), .b(word_len), .sub(addpc_sub), .sum(addpc_out), .ovfl(addpc_ovfl));
    Control Control(.opcode(im_out[15:12]), .MemWrite(MemWrite), .WriteRegSrc(WriteRegSrc), .RegWrite(RegWrite), .BInv(BInv), .ALUSrc(ALUSrc), .ALUOp(ALUOp), .ShiftImm(ShiftImm), .ReadReg1Src(ReadReg1Src), .ReadReg2Src(ReadReg2Src), .Halt(Halt));
    IM IM(.data_out(im_out), .data_in(unused_16b_in), .addr(pc_out), .enable(rst_n), .wr(im_wen), .clk(clk), .rst(~rst_n));
    Mux2to1 #(4) ReadReg1SrcMux(.in0(im_out[7:4]), .in1(im_out[11:8]), .sel(ReadReg1Src), .out(readreg1src_mux_out));
    Mux2to1 #(4) ReadReg2SrcMux(.in0(im_out[3:0]), .in1(im_out[11:8]), .sel(ReadReg2Src), .out(readreg2src_mux_out));
    RegFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(readreg1src_mux_out), .SrcReg2(readreg2src_mux_out), .DstReg(im_out[11:8]), .WriteReg(RegWrite), .DstData(writeregsrc_mux_out), .SrcData1(rf_out_1), .SrcData2(rf_out_2));
    SignExt #(4) SignExt4(.in(im_out[3:0]), .out(signext4_out));
    Shift Shift(.in(signext4_out), .out(shift_out));
    Mux2to1 ShiftImmMux(.in0(signext4_out), .in1(shift_out), .sel(ShiftImm), .out(shiftimm_mux_out));
    SignExt #(8) SignExt8(.in(im_out[7:0]), .out(signext8_out));
    Mux4to1 ALUSrcMux(.in0(rf_out_2), .in1(shiftimm_mux_out), .in2(signext8_out), .in3(unused_16b_in), .sel(ALUSrc), .out(alusrc_mux_out));
    ALU ALU(.a(rf_out_1), .b(alusrc_mux_out), .BInv(BInv), .ALUOp(ALUOp), .out(alu_out), .v(V));
    DM DM(.data_out(dm_out), .data_in(rf_out_2), .addr(alu_out), .enable(rst_n), .wr(MemWrite), .clk(clk), .rst(~rst_n));
    Mux4to1 WriteRegSrcMux(.in0(alu_out), .in1(dm_out), .in2(addpc_out), .in3(unused_16b_in), .sel(WriteRegSrc), .out(writeregsrc_mux_out));

endmodule