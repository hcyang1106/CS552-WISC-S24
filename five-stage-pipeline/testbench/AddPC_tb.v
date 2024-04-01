module AddPC_tb;
    reg [15:0] in;
    wire [15:0] out;

    AddPC uut(.in(in), .out(out));

    initial begin
        repeat (10) begin
            in = $unsigned($random) % 100;
            #10;
        end
        $finish;
    end

    initial begin
        $monitor("Time=%t | in=%d | out=%d", $time, in, out);
    end
endmodule

