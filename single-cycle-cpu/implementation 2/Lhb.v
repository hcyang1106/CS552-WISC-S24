module Lhb(a, b, out);

    input [15:0] a;
    input [15:0] b;
    output [15:0] out;
    
    assign out = {b[7:0], a[7:0]};

endmodule