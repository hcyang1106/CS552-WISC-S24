module Add16(a, b, sub, sum, ovfl);

    input [15:0] a;
    input [15:0] b;
    input sub;
    output [15:0] sum;
    output ovfl;

    wire [15:0] G; 
    wire [15:0] P; 
    wire [16:0] C; 
    
    wire [15:0] _b = sub ? ~b : b;
    wire [15:0] raw_sum;
    
    assign G = a & _b;
    assign P = a | _b;
    
    assign C[0] = sub;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (&P[1:0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (&P[2:1] & G[0]) | (&P[2:0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (&P[3:2] & G[1]) | (&P[3:1] & G[0]) | (&P[3:0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) | (&P[4:3] & G[2]) | (&P[4:2] & G[1]) | (&P[4:1] & G[0]) | (&P[4:0] & C[0]);
    assign C[6] = G[5] | (P[5] & G[4]) | (&P[5:4] & G[3]) | (&P[5:3] & G[2]) | (&P[5:2] & G[1]) | (&P[5:1] & G[0]) | (&P[5:0] & C[0]);
    assign C[7] = G[6] | (P[6] & G[5]) | (&P[6:5] & G[4]) | (&P[6:4] & G[3]) | (&P[6:3] & G[2]) | (&P[6:2] & G[1]) | (&P[6:1] & G[0]) | (&P[6:0] & C[0]);
    assign C[8] = G[7] | (P[7] & G[6]) | (&P[7:6] & G[5]) | (&P[7:5] & G[4]) | (&P[7:4] & G[3]) | (&P[7:3] & G[2]) | (&P[7:2] & G[1]) | (&P[7:1] & G[0]) | (&P[7:0] & C[0]);
    assign C[9] = G[8] | (P[8] & G[7]) | (&P[8:7] & G[6]) | (&P[8:6] & G[5]) | (&P[8:5] & G[4]) | (&P[8:4] & G[3]) | (&P[8:3] & G[2]) | (&P[8:2] & G[1]) | (&P[8:1] & G[0]) | (&P[8:0] & C[0]);
    assign C[10] = G[9] | (P[9] & G[8]) | (&P[9:8] & G[7]) | (&P[9:7] & G[6]) | (&P[9:6] & G[5]) | (&P[9:5] & G[4]) | (&P[9:4] & G[3]) | (&P[9:3] & G[2]) | (&P[9:2] & G[1]) | (&P[9:1] & G[0]) | (&P[9:0] & C[0]);
    assign C[11] = G[10] | (P[10] & G[9]) | (&P[10:9] & G[8]) | (&P[10:8] & G[7]) | (&P[10:7] & G[6]) | (&P[10:6] & G[5]) | (&P[10:5] & G[4]) | (&P[10:4] & G[3]) | (&P[10:3] & G[2]) | (&P[10:2] & G[1]) | (&P[10:1] & G[0]) | (&P[10:0] & C[0]);
    assign C[12] = G[11] | (P[11] & G[10]) | (&P[11:10] & G[9]) | (&P[11:9] & G[8]) | (&P[11:8] & G[7]) | (&P[11:7] & G[6]) | (&P[11:6] & G[5]) | (&P[11:5] & G[4]) | (&P[11:4] & G[3]) | (&P[11:3] & G[2]) | (&P[11:2] & G[1]) | (&P[11:1] & G[0]) | (&P[11:0] & C[0]);
    assign C[13] = G[12] | (P[12] & G[11]) | (&P[12:11] & G[10]) | (&P[12:10] & G[9]) | (&P[12:9] & G[8]) | (&P[12:8] & G[7]) | (&P[12:7] & G[6]) | (&P[12:6] & G[5]) | (&P[12:5] & G[4]) | (&P[12:4] & G[3]) | (&P[12:3] & G[2]) | (&P[12:2] & G[1]) | (&P[12:1] & G[0]) | (&P[12:0] & C[0]);
    assign C[14] = G[13] | (P[13] & G[12]) | (&P[13:12] & G[11]) | (&P[13:11] & G[10]) | (&P[13:10] & G[9]) | (&P[13:9] & G[8]) | (&P[13:8] & G[7]) | (&P[13:7] & G[6]) | (&P[13:6] & G[5]) | (&P[13:5] & G[4]) | (&P[13:4] & G[3]) | (&P[13:3] & G[2]) | (&P[13:2] & G[1]) | (&P[13:1] & G[0]) | (&P[13:0] & C[0]);
    assign C[15] = G[14] | (P[14] & G[13]) | (&P[14:13] & G[12]) | (&P[14:12] & G[11]) | (&P[14:11] & G[10]) | (&P[14:10] & G[9]) | (&P[14:9] & G[8]) | (&P[14:8] & G[7]) | (&P[14:7] & G[6]) | (&P[14:6] & G[5]) | (&P[14:5] & G[4]) | (&P[14:4] & G[3]) | (&P[14:3] & G[2]) | (&P[14:2] & G[1]) | (&P[14:1] & G[0]) | (&P[14:0] & C[0]);
    assign C[16] = G[15] | (P[15] & G[14]) | (&P[15:14] & G[13]) | (&P[15:13] & G[12]) | (&P[15:12] & G[11]) | (&P[15:11] & G[10]) | (&P[15:10] & G[9]) | (&P[15:9] & G[8]) | (&P[15:8] & G[7]) | (&P[15:7] & G[6]) | (&P[15:6] & G[5]) | (&P[15:5] & G[4]) | (&P[15:4] & G[3]) | (&P[15:3] & G[2]) | (&P[15:2] & G[1]) | (&P[15:1] & G[0]) | (&P[15:0] & C[0]);

    assign raw_sum = a ^ _b ^ C[15:0];
    assign ovfl = C[16] ^ C[15];
    assign sum = ovfl & !(sub ^ a[15]) ? 16'h7FFF : // Saturate to 32767 for positive overflow
                 ovfl & (sub ^ a[15]) ? 16'h8000 : // Saturate to -32768 for negative overflow
                 raw_sum; // No overflow

endmodule

module Add4(a, b, sub, sum, ovfl);

    input [3:0] a;
    input [3:0] b;
    input sub;
    output [3:0] sum;
    output ovfl;

    wire [3:0] G; 
    wire [3:0] P; 
    wire [4:0] C; 
    
    wire [3:0] _b = sub ? ~b : b;
    wire [3:0] raw_sum;
    
    assign G = a & _b;
    assign P = a | _b;
    
    assign C[0] = sub;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (&P[1:0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (&P[2:1] & G[0]) | (&P[2:0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (&P[3:2] & G[1]) | (&P[3:1] & G[0]) | (&P[3:0] & C[0]);

    assign raw_sum = a ^ _b ^ C[3:0];
    assign ovfl = C[4] ^ C[3];
    assign sum = ovfl & !(sub ^ a[3]) ? 4'h7 : // Saturate to 7 for positive overflow
                 ovfl & (sub ^ a[3]) ? 4'h8 : // Saturate to -8 for negative overflow
                 raw_sum; // No overflow

endmodule