module Xor_tb;
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] out;

    Xor uut(.a(a), .b(b), .out(out));

    initial begin
        repeat (10) begin
            a = $random;
            b = $random;
            #10;
        end
        $finish;
    end

    initial begin
        $monitor("Time=%t | a=%b, b=%b | out=%b", $time, a, b, out);
    end
endmodule

