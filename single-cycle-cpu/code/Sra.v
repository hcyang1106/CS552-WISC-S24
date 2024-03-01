module Sra(in, shamt, out);

    // Implementation should be changed using mux, this is used temporarily

    input [15:0] in;
    input [15:0] shamt;
    output [15:0] out;
    
    assign out = in >> shamt;

endmodule