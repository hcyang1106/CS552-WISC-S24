module instruction_cache_tb();

	reg clk, rst_n;
	reg [15:0] addr; 
	
	wire [15:0] data_in, memory_address, data_out;
	
	cache Icache(.clk(clk), .rst_n(~rst_n), .data_out(data_out), .data_in(data_in), .addr(addr), .wr(1'b0), .enable(1'b1), .memory_data_valid(memory_data_valid), .memory_address(memory_address), .stall(I_cache_stall), .mem_enable(mem_enable), .mem_write());   
	memory4c Imem(.data_out(data_in), .data_in(16'h0000), .addr(memory_address), .enable(mem_enable), .wr(1'b0), .clk(clk), .rst(~rst_n), .data_valid(memory_data_valid));
    
	initial begin
		clk = 0;
		rst_n = 0;
		addr = 16'h0002;
		
		repeat (2) @(negedge clk);
		rst_n = 1;
		
		repeat (20) @(posedge clk);
		
		$stop();
	end

	always #5 begin
      clk = ~clk;
    end

endmodule