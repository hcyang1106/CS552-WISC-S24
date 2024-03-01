module Ror(in, shamt, out);

    // Implementation should be changed using mux, this is used temporarily

    input [15:0] in;
    input [15:0] shamt;
    output [15:0] out;

    wire [31:0] rotated, remain;

    assign rotated = in << (16 - shamt); // Bits that will be rotated to the left
    assign remain = in >> shamt; // Bits that remain on the right
    assign out = rotated | remain;

endmodule