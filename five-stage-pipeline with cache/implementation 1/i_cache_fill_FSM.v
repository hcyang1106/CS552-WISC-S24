module i_cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data, memory_data_valid, mem_enable, byte_count_out);
	input clk, rst_n;
	input miss_detected; // active high when tag match logic detects a miss
	input [15:0] miss_address; // address that missed the cache
	output fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output write_data_array; // write enable to cache data array to signal when filling with memory_data
	output write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
	output [15:0] memory_address; // address to read from memory
	output mem_enable; // enable reads from mem
	output [2:0] byte_count_out;
	input [15:0] memory_data; // data returned by memory (after delay)
	input memory_data_valid; // active high indicates valid data returning on memory bus
	
	wire [3:0] byte_count, byte_count_next;
	wire init_count;
	wire state, next_state;
	wire [3:0] word_addr_count, word_addr_count_inc;
	wire [15:0] address;
	
	assign byte_count_out = byte_count[2:0];
	
	cla_4bit incrementer(.S(byte_count_next), .ovfl(), .A(byte_count), .B(4'b0001), .Cin(1'b0), .Cout());
	cla_4bit word_incrementer(.S(word_addr_count_inc), .ovfl(), .A({1'b0, memory_address[3:1]}), .B(4'b0001), .Cin(1'b0), .Cout());
	
	dff state_reg(.clk(clk), .rst(rst_n), .q(state), .d(next_state), .wen(1'b1));
	dff count[3:0](.clk(clk), .rst(init_count), .q(byte_count), .d(byte_count_next), .wen(increment));
	
	// assign word_addr_count_next = init_count ? 3'b001 : word_addr_count_inc;
	dff word_addr[3:0](.clk(clk), .rst(rst_n), .q(word_addr_count), .d(word_addr_count_inc), .wen(mem_enable));
	assign address = {miss_address[15:4], word_addr_count << 1}; // TODO
	
	// state 0: idle, 1: wait
	assign next_state = state ? ((byte_count == 4'b1000) ? 1'b0 : 1'b1) : (miss_detected ? 1'b1 : 1'b0);
	assign fsm_busy = state ? ((byte_count == 4'b1000) ? 1'b0 : 1'b1) : (miss_detected ? 1'b1 : 1'b0);
	assign init_count = state ? 1'b0 : (miss_detected ? 1'b1 : 1'b0);
	
	assign memory_address = state ? address : (miss_detected ? {miss_address[15:4], 4'h0} : address);
	assign mem_enable = state ? (word_addr_count != 4'b1000) : (miss_detected ? 1'b1 : 1'b0);
	// assign inc_word_addr = state ? (word_addr_count != 4'b1000) : (miss_detected ? 1'b1 : 1'b0);
	
	assign increment = state ? ((memory_data_valid & (byte_count != 4'b1000)) ? 1'b1 : 1'b0) : 1'b0;
	assign write_data_array = state ? ((memory_data_valid & (byte_count != 4'b1000)) ? 1'b1 : 1'b0) : 1'b0;

	assign write_tag_array = state ? ((byte_count == 4'b0111) ? 1'b1 : 1'b0) : 1'b0;
endmodule