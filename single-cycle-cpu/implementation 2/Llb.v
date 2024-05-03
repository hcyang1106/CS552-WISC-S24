module Llb(a, b, out);

    input [15:0] a;
    input [15:0] b;
    output [15:0] out;
    
    assign out = {a[15:8], b[7:0]};

endmodule