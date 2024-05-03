module Paddsb(a, b, out);

    input [15:0] a;
    input [15:0] b;
    output [15:0] out;

    wire [3:0] sum0, sum1, sum2, sum3;
    wire ovfl0, ovfl1, ovfl2, ovfl3;
    wire sub = 1'b0;

    Add4 adder0(.a(a[3:0]), .b(b[3:0]), .sub(sub), .sum(sum0), .ovfl(ovfl0));
    Add4 adder1(.a(a[7:4]), .b(b[7:4]), .sub(sub), .sum(sum1), .ovfl(ovfl1));
    Add4 adder2(.a(a[11:8]), .b(b[11:8]), .sub(sub), .sum(sum2), .ovfl(ovfl2));
    Add4 adder3(.a(a[15:12]), .b(b[15:12]), .sub(sub), .sum(sum3), .ovfl(ovfl3));

    assign out[3:0]   = (ovfl0 & sum0[3]) ? 4'b1000 : // Negative overflow
                           (ovfl0 & ~sum0[3]) ? 4'b0111 : // Positive overflow
                           sum0;
    assign out[7:4]   = (ovfl1 & sum1[3]) ? 4'b1000 :
                           (ovfl1 & ~sum1[3]) ? 4'b0111 :
                           sum1;
    assign out[11:8]  = (ovfl2 & sum2[3]) ? 4'b1000 :
                           (ovfl2 & ~sum2[3]) ? 4'b0111 :
                           sum2;
    assign out[15:12] = (ovfl3 & sum3[3]) ? 4'b1000 :
                           (ovfl3 & ~sum3[3]) ? 4'b0111 :
                           sum3;

endmodule
