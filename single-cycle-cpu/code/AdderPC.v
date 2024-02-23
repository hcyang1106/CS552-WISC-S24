module AdderPC(in, out);

    input  [15:0] in;
    output [15:0] out;

    wire cin1, cin2, cin3, cin4, cin5, cin6, cin7, cin8,
     cin9, cin10, cin11, cin12, cin13, cin14, cin15, cin16;

    // assign out = in + 16'h2;
    
    FullAdder FA0(.a(in[0]), .b(1'b0), .cin(1'b0), .sum(out[0]), .cout(cin1));
    FullAdder FA1(.a(in[1]), .b(1'b1), .cin(cin1), .sum(out[1]), .cout(cin2)); // PC = PC + 2
    FullAdder FA2(.a(in[2]), .b(1'b0), .cin(cin2), .sum(out[2]), .cout(cin3));
    FullAdder FA3(.a(in[3]), .b(1'b0), .cin(cin3), .sum(out[3]), .cout(cin4));
    FullAdder FA4(.a(in[4]), .b(1'b0), .cin(cin4), .sum(out[4]), .cout(cin5));
    FullAdder FA5(.a(in[5]), .b(1'b0), .cin(cin5), .sum(out[5]), .cout(cin6));
    FullAdder FA6(.a(in[6]), .b(1'b0), .cin(cin6), .sum(out[6]), .cout(cin7));
    FullAdder FA7(.a(in[7]), .b(1'b0), .cin(cin7), .sum(out[7]), .cout(cin8));
    FullAdder FA8(.a(in[8]), .b(1'b0), .cin(cin8), .sum(out[8]), .cout(cin9));
    FullAdder FA9(.a(in[9]), .b(1'b0), .cin(cin9), .sum(out[9]), .cout(cin10));
    FullAdder FA10(.a(in[10]), .b(1'b0), .cin(cin10), .sum(out[10]), .cout(cin11));
    FullAdder FA11(.a(in[11]), .b(1'b0), .cin(cin11), .sum(out[11]), .cout(cin12));
    FullAdder FA12(.a(in[12]), .b(1'b0), .cin(cin12), .sum(out[12]), .cout(cin13));
    FullAdder FA13(.a(in[13]), .b(1'b0), .cin(cin13), .sum(out[13]), .cout(cin14));
    FullAdder FA14(.a(in[14]), .b(1'b0), .cin(cin14), .sum(out[14]), .cout(cin15)); 
    FullAdder FA15(.a(in[15]), .b(1'b0), .cin(cin15), .sum(out[15]), .cout(cin16));

endmodule