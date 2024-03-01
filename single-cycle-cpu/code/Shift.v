module Shift(in, out);

    input [15:0] in, out;
    assign out = in << 1;

endmodule

