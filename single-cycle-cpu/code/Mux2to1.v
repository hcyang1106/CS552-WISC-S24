module Mux2to1(in0, in1, sel, out);

    parameter bit = 16;

    input [bit-1:0] in0;
    input [bit-1:0] in1;
    input sel;
    output [bit-1:0] out;

    assign out = sel ? in1 : in0;

endmodule