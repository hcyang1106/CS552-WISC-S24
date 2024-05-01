
module cache_tb;
    // Declare signals
    reg clk, rst;
    reg cacheEnable, cacheWrite, memValid;
    reg[15:0] procDataIn, procAddress, memDataOut;
    wire stall, memEnable, memWrite;
    wire[15:0] procDataOut, memDataIn, memAddress;

    // Instantiate the cache module
    cache dut(
        .clk(clk), .rst(rst),
        .procDataIn(procDataIn), .procDataOut(procDataOut),
        .procAddress(procAddress), .cacheEnable(cacheEnable),
        .cacheWrite(cacheWrite), .stall(stall),
        .memDataIn(memDataIn), .memDataOut(memDataOut),
        .memEnable(memEnable), .memWrite(memWrite),
        .memValid(memValid), .memAddress(memAddress)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    // Test scenarios
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        cacheEnable = 0;
        cacheWrite = 0;
        memValid = 0;
        procDataIn = 0;
        procAddress = 0;
        memDataOut = 0;

        // Release reset after a few clock cycles
        #10 rst = 0;

        // Test case 1: Cache read miss
        #10;
        cacheEnable = 1;
        cacheWrite = 0;
        procAddress = 16'h1234;
        
        #55; // 75
        memValid = 1;
        memDataOut = 16'hABCD;

	#10;
	memValid = 0;

	#10;
        memValid = 1;
        memDataOut = 16'hABCE;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABCF;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABA0;

	#10;
	memValid = 0;

	#10; 
        memValid = 1;
        memDataOut = 16'hABA1;

	#10;
	memValid = 0;

	#10;
        memValid = 1;
        memDataOut = 16'hABA2;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABA3;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABA4; // 8

	#10;
	memValid = 0;


       // Test case 2: Cache read miss
        #35;
        cacheEnable = 1;
        cacheWrite = 0;
        procAddress = 16'h1244;
        
        #55; // 75
        memValid = 1;
        memDataOut = 16'hABCD;

	#10;
	memValid = 0;

	#10;
        memValid = 1;
        memDataOut = 16'hABCE;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABCF;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABA0;

	#10;
	memValid = 0;

	#10; 
        memValid = 1;
        memDataOut = 16'hABA1;

	#10;
	memValid = 0;

	#10;
        memValid = 1;
        memDataOut = 16'hABA2;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABA3;

	#10;
	memValid = 0;


	#10;
        memValid = 1;
        memDataOut = 16'hABA4; // 8

	#10;
	memValid = 0;

        // Add more test cases as needed

        // Finish simulation
        #100;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t, procAddress: %h, procDataOut: %h, memAddress: %h, memDataIn: %h, stall: %h",
                 $time, procAddress, procDataOut, memAddress, memDataIn, stall);
    end
endmodule