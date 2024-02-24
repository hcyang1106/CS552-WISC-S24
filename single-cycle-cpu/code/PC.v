module PC(in, halt, clk, rst, out);

    input [15:0] in;
    input halt, clk, rst;
    output [15:0] out;

    DFlipFlop dff15(.q(out[15]), .d(in[15]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff14(.q(out[14]), .d(in[14]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff13(.q(out[13]), .d(in[13]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff12(.q(out[12]), .d(in[12]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff11(.q(out[11]), .d(in[11]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff10(.q(out[10]), .d(in[10]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff9(.q(out[9]), .d(in[9]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff8(.q(out[8]), .d(in[8]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff7(.q(out[7]), .d(in[7]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff6(.q(out[6]), .d(in[6]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff5(.q(out[5]), .d(in[5]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff4(.q(out[4]), .d(in[4]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff3(.q(out[3]), .d(in[3]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff2(.q(out[2]), .d(in[2]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff1(.q(out[1]), .d(in[1]). .wen(halt), .clk(clk), .rst(rst));
    DFlipFlop dff0(.q(out[0]), .d(in[0]). .wen(halt), .clk(clk), .rst(rst));
    
endmodule