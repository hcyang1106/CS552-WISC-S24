module Flag(Zin, Nin, Vin, ENZ, ENN, ENV, clk, rst, Zout, Nout, Vout);

    input Zin, Nin, Vin, ENZ, ENN, ENV, clk, rst;
    output Zout, Nout, Vout;

    DFlipFlop Z(.q(Zout), .d(Zin), .wen(ENZ), .clk(clk), .rst(rst));
    DFlipFlop N(.q(Nout), .d(Nin), .wen(ENN), .clk(clk), .rst(rst));
    DFlipFlop V(.q(Vout), .d(Vin), .wen(ENV), .clk(clk), .rst(rst));

endmodule