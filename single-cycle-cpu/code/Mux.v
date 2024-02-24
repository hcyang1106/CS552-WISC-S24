module Mux(a, b, sel, out);

    input [15:0] a;
    input [15:0] b;
    input sel;
    output [15:0] out;

    assign out = sel ? a : b;

endmodule