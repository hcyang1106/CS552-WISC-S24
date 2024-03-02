module cpu(clk, rst_n, hlt, pc);

    input clk, rst_n;
    output hlt;
    output [15:0] pc;

    // component outputs
    wire [15:0] pc_out, addpc_out, im_out, dm_out, rf_out_1, rf_out_2, alu_out, 
                writeregsrc_mux_out, signext4_out, signext8_out, signext9_out, shiftimm_out, shiftimm_mux_out,
                alusrc_mux_out, unused_16b_in, shiftbr_out, addbr_out, br_mux_out, brreg_mux_out;
    wire [3:0] readreg1src_mux_out, readreg2src_mux_out;
    wire alu_ovfl, alu_zero, alu_neg, addpc_ovfl, addbr_ovfl, z_out, n_out, v_out, andbr_out, andbrreg_out, brcond_mux_out,
         brcond_neq, brcond_eq, brcond_gt, brcond_lt, brcond_gte, brcond_lte, brcond_ovfl, brcond_uncond; // addpc_ovfl, addbr_ovfl unused

    // control signals
    wire [1:0] ALUSrc, WriteRegSrc;
    wire [3:0] ALUOp;
    wire MemWrite, BInv, RegWrite, ShiftImm, ReadReg1Src, ReadReg2Src, Halt, ENZ, ENN, ENV, Br, BrReg;

    // fixed setting
    wire [15:0] word_len = 16'h2;
    wire addpc_sub = 1'b0, addbr_sub = 1'b0, im_wen = 1'b0;

    PC PC(.in(brreg_mux_out), .wen(~Halt), .clk(clk), .rst(~rst_n), .out(pc_out));
    Add AddPC(.a(pc_out), .b(word_len), .sub(addpc_sub), .sum(addpc_out), .ovfl(addpc_ovfl));
    Control Control(.opcode(im_out[15:12]), .MemWrite(MemWrite), .WriteRegSrc(WriteRegSrc), .RegWrite(RegWrite), .BInv(BInv), .ALUSrc(ALUSrc), .ALUOp(ALUOp), 
                    .ShiftImm(ShiftImm), .ReadReg1Src(ReadReg1Src), .ReadReg2Src(ReadReg2Src), .Halt(Halt), .ENZ(ENZ), .ENN(ENN), .ENV(ENV), .Br(Br), .BrReg(BrReg));
    IM IM(.data_out(im_out), .data_in(unused_16b_in), .addr(pc_out), .enable(rst_n), .wr(im_wen), .clk(clk), .rst(~rst_n));
    Mux2to1 #(4) ReadReg1SrcMux(.in0(im_out[7:4]), .in1(im_out[11:8]), .sel(ReadReg1Src), .out(readreg1src_mux_out));
    Mux2to1 #(4) ReadReg2SrcMux(.in0(im_out[3:0]), .in1(im_out[11:8]), .sel(ReadReg2Src), .out(readreg2src_mux_out));
    RegFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(readreg1src_mux_out), .SrcReg2(readreg2src_mux_out), .DstReg(im_out[11:8]), .WriteReg(RegWrite),
                    .DstData(writeregsrc_mux_out), .SrcData1(rf_out_1), .SrcData2(rf_out_2));
    SignExt #(4) SignExt4(.in(im_out[3:0]), .out(signext4_out));
    Shift ShiftImm1(.in(signext4_out), .out(shiftimm_out));
    Mux2to1 ShiftImmMux(.in0(signext4_out), .in1(shiftimm_out), .sel(ShiftImm), .out(shiftimm_mux_out));
    SignExt #(8) SignExt8(.in(im_out[7:0]), .out(signext8_out));
    Mux4to1 ALUSrcMux(.in0(rf_out_2), .in1(shiftimm_mux_out), .in2(signext8_out), .in3(unused_16b_in), .sel(ALUSrc), .out(alusrc_mux_out));
    ALU ALU(.a(rf_out_1), .b(alusrc_mux_out), .BInv(BInv), .ALUOp(ALUOp), .out(alu_out), .ovfl(alu_ovfl), .zero(alu_zero), .neg(alu_neg));
    DM DM(.data_out(dm_out), .data_in(rf_out_2), .addr(alu_out), .enable(rst_n), .wr(MemWrite), .clk(clk), .rst(~rst_n));
    Mux4to1 WriteRegSrcMux(.in0(alu_out), .in1(dm_out), .in2(addpc_out), .in3(unused_16b_in), .sel(WriteRegSrc), .out(writeregsrc_mux_out));

    Flag Flag(.Zin(alu_zero), .Nin(alu_neg), .Vin(alu_ovfl), .ENZ(ENZ), .ENN(ENN), .ENV(ENV), .clk(clk), .rst(~rst_n), .Zout(z_out), 
              .Nout(n_out), .Vout(v_out));
    BrCond BrCond(.Z(z_out), .N(n_out), .V(v_out), .neq(brcond_neq), .eq(brcond_eq), .gt(brcond_gt), .lt(brcond_lt), .gte(brcond_gte), .lte(brcond_lte),
                  .ovfl(brcond_ovfl), .uncond(brcond_uncond));
    Mux8to1 #(1) BrCondMux(.in0(brcond_neq), .in1(brcond_eq), .in2(brcond_gt), .in3(brcond_lt), .in4(brcond_gte), .in5(brcond_lte), .in6(brcond_ovfl),
                  .in7(brcond_uncond), .sel(im_out[11:9]), .out(brcond_mux_out));
    Add AddBr(.a(addpc_out), .b(shiftbr_out), .sub(addbr_sub), .sum(addbr_out), .ovfl(addbr_ovfl));
    SignExt #(9) SignExt9(.in(im_out[8:0]), .out(signext9_out));
    Shift ShiftBr1(.in(signext9_out), .out(shiftbr_out));
    And AndBr(.a(Br), .b(brcond_mux_out), .out(andbr_out));
    And AndBrReg(.a(BrReg), .b(brcond_mux_out), .out(andbrreg_out));
    Mux2to1 BrMux(.in0(addpc_out), .in1(addbr_out), .sel(andbr_out), .out(br_mux_out));
    Mux2to1 BrRegMux(.in0(br_mux_out), .in1(rf_out_1), .sel(andbrreg_out), .out(brreg_mux_out));
    
endmodule