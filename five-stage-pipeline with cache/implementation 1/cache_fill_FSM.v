// NOT TESTED

module cache_fill_FSM(clk, rst, miss_detected, miss_address, fsm_busy, write_data_array, 
        write_tag_array, memory_address, memory_data_valid);
    input clk, rst;          
    input miss_detected;        
    input memory_data_valid;    
    input[15:0] miss_address;   
    output reg fsm_busy;        
    output reg write_tag_array; 
    output reg write_data_array;
    output[15:0] memory_address;

    wire state;                 // Output of state flop
    wire nxtState;              // Input of state flop
    wire[3:0] nxtCount, count;  // Input and Output of counter flop
    wire[3:0] countUp;          // count + 1
    wire cnt_full;              // high when count == 8
    wire[11:0] block_address;   // first 12 bits of missing address
    wire cnt_en;                // enable signal for counter flop
    
    // State encodings
    parameter IDLE = 1'b0;
    parameter WAIT = 1'b1;

    // 0: IDLE, 1: WAIT
    dff stateFlop(.clk(clk), .rst(rst), .d(nxtState), .q(state), .wen(1'b1));
    
    // counter counts from 1 to 8, cnt_full = 1 when it current count is 8
    dff counter[3:0](.clk(clk), .rst(rst), .d(nxtCount[3:0]), .q(count[3:0]), .wen(cnt_en));
    inc_3bit inc_count(.in(count[2:0]), .out(countUp[2:0]), .cout(countUp[3])); 
    assign nxtCount = countUp;
    assign cnt_full = count[3];

    // cnt_en logic
    assign cnt_en =  (state == WAIT) & memory_data_valid & !cnt_full;
    // nxtState logic
	assign nxtState = (state == WAIT) & !cnt_full;
    // fsm_busy logic
    assign fsm_busy = (state == WAIT) | (miss_detected & state == IDLE); 
    // write_tag_array logic
    assign write_tag_array = (state == WAIT) & cnt_full;
    // write_data_array logic
    assign write_data_array = (state == WAIT) & memory_data_valid;

    assign block_address = miss_address[15:4];                                 
    assign memory_address = {block_address, count[2:0], 1'b0};
      
endmodule

module inc_3bit(in, out, cout);
    input[2:0] in;      // 3 bit input
    output[2:0] out;    // input + 1
	output cout;        // carry after the 3rd bit
    
    wire int1, int2;
    
    // 1st bit
    assign out[0] = in[0] ^ 1; 
    assign int1 = in[0] & 1;
    
    // 2nd bit
    assign out[1] = in[1] ^ int1;
    assign int2 = in[1] & int1;
    
    // 3rd bit
    assign out[2] = in[2] ^ int2;
	assign cout = in[2] & int2;
    
endmodule
