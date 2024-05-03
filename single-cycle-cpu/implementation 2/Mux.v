module Mux16to1(in0, in1, in2, in3, in4, in5, in6, in7,
                in8, in9, in10, in11, in12, in13, in14, in15,
                sel, out);

    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7,
                 in8, in9, in10, in11, in12, in13, in14, in15;
    input [3:0] sel;
    output [15:0] out;

    wire [15:0] low_out, high_out;

    Mux8to1 low(.in0(in0), .in1(in1), .in2(in2), .in3(in3), 
    .in4(in4), .in5(in5), .in6(in6), .in7(in7), .sel(sel[2:0]), .out(low_out));
    Mux8to1 high(.in0(in8), .in1(in9), .in2(in10), .in3(in11), 
    .in4(in12), .in5(in13), .in6(in14), .in7(in15), .sel(sel[2:0]), .out(high_out));
    Mux2to1 top(.in0(low_out), .in1(high_out), .sel(sel[3]), .out(out));

endmodule

module Mux8to1(in0, in1, in2, in3, in4, in5, in6, in7,
               sel, out);

    parameter bit = 16;

    input [bit-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
    input [2:0] sel;
    output [bit-1:0] out;

    wire [bit-1:0] low_out, high_out;

    Mux4to1 #(bit) low(.in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel[1:0]), .out(low_out));
    Mux4to1 #(bit) high(.in0(in4), .in1(in5), .in2(in6), .in3(in7), .sel(sel[1:0]), .out(high_out));
    Mux2to1 #(bit) top(.in0(low_out), .in1(high_out), .sel(sel[2]), .out(out));

endmodule

module Mux4to1(in0, in1, in2, in3, sel, out);

    parameter bit = 16;

    input [bit-1:0] in0, in1, in2, in3;
    input [1:0] sel;
    output [bit-1:0] out;

    wire [bit-1:0] low_out, high_out;

    Mux2to1 #(bit) low(.in0(in0), .in1(in1), .sel(sel[0]), .out(low_out));
    Mux2to1 #(bit) high(.in0(in2), .in1(in3), .sel(sel[0]), .out(high_out));
    Mux2to1 #(bit) top(.in0(low_out), .in1(high_out), .sel(sel[1]), .out(out));

endmodule

module Mux2to1(in0, in1, sel, out);

    parameter bit = 16;

    input [bit-1:0] in0;
    input [bit-1:0] in1;
    input sel;
    output [bit-1:0] out;

    assign out = sel ? in1 : in0;

endmodule