module SignExt(in, out);

    parameter bit = 4;

    input  [bit-1:0] in;
    output [15:0] out;

    assign out = {{(16-bit){in[bit-1]}}, in[bit-1:0]};

endmodule