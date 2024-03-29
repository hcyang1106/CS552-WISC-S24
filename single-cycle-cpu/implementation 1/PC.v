module PC(in, wen, clk, rst, out);

    input [15:0] in;
    input wen, clk, rst;
    output [15:0] out;

    dff dff15(.q(out[15]), .d(in[15]), .wen(wen), .clk(clk), .rst(rst));
    dff dff14(.q(out[14]), .d(in[14]), .wen(wen), .clk(clk), .rst(rst));
    dff dff13(.q(out[13]), .d(in[13]), .wen(wen), .clk(clk), .rst(rst));
    dff dff12(.q(out[12]), .d(in[12]), .wen(wen), .clk(clk), .rst(rst));
    dff dff11(.q(out[11]), .d(in[11]), .wen(wen), .clk(clk), .rst(rst));
    dff dff10(.q(out[10]), .d(in[10]), .wen(wen), .clk(clk), .rst(rst));
    dff dff9(.q(out[9]), .d(in[9]), .wen(wen), .clk(clk), .rst(rst));
    dff dff8(.q(out[8]), .d(in[8]), .wen(wen), .clk(clk), .rst(rst));
    dff dff7(.q(out[7]), .d(in[7]), .wen(wen), .clk(clk), .rst(rst));
    dff dff6(.q(out[6]), .d(in[6]), .wen(wen), .clk(clk), .rst(rst));
    dff dff5(.q(out[5]), .d(in[5]), .wen(wen), .clk(clk), .rst(rst));
    dff dff4(.q(out[4]), .d(in[4]), .wen(wen), .clk(clk), .rst(rst));
    dff dff3(.q(out[3]), .d(in[3]), .wen(wen), .clk(clk), .rst(rst));
    dff dff2(.q(out[2]), .d(in[2]), .wen(wen), .clk(clk), .rst(rst));
    dff dff1(.q(out[1]), .d(in[1]), .wen(wen), .clk(clk), .rst(rst));
    dff dff0(.q(out[0]), .d(in[0]), .wen(wen), .clk(clk), .rst(rst));
    
endmodule