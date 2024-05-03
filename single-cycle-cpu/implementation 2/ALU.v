module ALU(a, b, BInv, ALUOp, out, ovfl, zero, neg);

    // ---ALUOp---
    // 0000: add
    // 0001: xor
    // 0010: red
    // 0011: sll
    // 0100: sra
    // 0101: ror
    // 0110: paddsb
    // 0111: llb
    // 1000: lhb
    // ---ALUOp---

    input [15:0] a, b;
    input [3:0] ALUOp;
    input BInv;
    output [15:0] out;
    output ovfl, zero, neg;

    wire [15:0] add_out, xor_out, sll_out, sra_out, ror_out, llb_out, lhb_out, red_out, paddsb_out, unused_in;

    assign zero = (out == 0);
    assign neg = (out[15] == 1);

    Add16 Add(.a(a), .b(b), .sub(BInv), .sum(add_out), .ovfl(ovfl));
    Xor Xor(.a(a), .b(b), .out(xor_out));
    ReductionUnit Red(.A(a), .B(b), .S(red_out));
    Sll Sll(.in(a), .shamt(b), .out(sll_out));
    Sra Sra(.in(a), .shamt(b), .out(sra_out));
    Ror Ror(.in(a), .shamt(b), .out(ror_out));
    Paddsb Paddsb(.a(a), .b(b), .out(paddsb_out));
    Llb Llb(.a(a), .b(b), .out(llb_out));
    Lhb Lhb(.a(a), .b(b), .out(lhb_out));

    Mux16to1 Mux16to1(.in0(add_out), .in1(xor_out), .in2(red_out), .in3(sll_out), .in4(sra_out), .in5(ror_out), .in6(paddsb_out), .in7(llb_out),
            .in8(lhb_out), .in9(unused_in), .in10(unused_in), .in11(unused_in), .in12(unused_in), .in13(unused_in), .in14(unused_in), .in15(unused_in),
            .sel(ALUOp), .out(out));

endmodule