module Add(a, b, sub, sum, ovfl);

    // Should be modified to a CLA adder, this is used temporarily

    input [15:0] a;
    input [15:0] b;
    input sub;
    output [15:0] sum;
    output ovfl;

    wire [15:0] _b = sub ? ~b : b;
    wire cin0 = sub;
    wire cin1, cin2, cin3, cin4,
        cin5, cin6, cin7, cin8,
        cin9, cin10, cin11, cin12,
        cin13, cin14, cin15, cin16;

    FullAdder FA0(.a(a[0]), .b(_b[0]), .cin(cin0), .sum(sum[0]), .cout(cin1));
    FullAdder FA1(.a(a[1]), .b(_b[1]), .cin(cin1), .sum(sum[1]), .cout(cin2));
    FullAdder FA2(.a(a[2]), .b(_b[2]), .cin(cin2), .sum(sum[2]), .cout(cin3));
    FullAdder FA3(.a(a[3]), .b(_b[3]), .cin(cin3), .sum(sum[3]), .cout(cin4));

    FullAdder FA4(.a(a[4]), .b(_b[4]), .cin(cin4), .sum(sum[4]), .cout(cin5));
    FullAdder FA5(.a(a[5]), .b(_b[5]), .cin(cin5), .sum(sum[5]), .cout(cin6));
    FullAdder FA6(.a(a[6]), .b(_b[6]), .cin(cin6), .sum(sum[6]), .cout(cin7));
    FullAdder FA7(.a(a[7]), .b(_b[7]), .cin(cin7), .sum(sum[7]), .cout(cin8));

    FullAdder FA8(.a(a[8]), .b(_b[8]), .cin(cin8), .sum(sum[8]), .cout(cin9));
    FullAdder FA9(.a(a[9]), .b(_b[9]), .cin(cin9), .sum(sum[9]), .cout(cin10));
    FullAdder FA10(.a(a[10]), .b(_b[10]), .cin(cin10), .sum(sum[10]), .cout(cin11));
    FullAdder FA11(.a(a[11]), .b(_b[11]), .cin(cin11), .sum(sum[11]), .cout(cin12));

    FullAdder FA12(.a(a[12]), .b(_b[12]), .cin(cin12), .sum(sum[12]), .cout(cin13));
    FullAdder FA13(.a(a[13]), .b(_b[13]), .cin(cin13), .sum(sum[13]), .cout(cin14));
    FullAdder FA14(.a(a[14]), .b(_b[14]), .cin(cin14), .sum(sum[14]), .cout(cin15));
    FullAdder FA15(.a(a[15]), .b(_b[15]), .cin(cin15), .sum(sum[15]), .cout(cin16));
    
    assign ovfl = cin15 ^ cin16;

endmodule