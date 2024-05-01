module cache_fill_FSM(clk, rst, miss_detected, miss_address, fsm_busy, write_data_array, 
                      write_tag_array, memory_address, memory_data_valid);
    input clk, rst;           
    input miss_detected;        
    input memory_data_valid;    
    input[15:0] miss_address;   
    output reg fsm_busy;        
    output[15:0] memory_address;
    output reg write_tag_array; 
    output reg write_data_array;

    wire state;                 
    reg next_state;               
    wire[3:0] next_count, count;  
    wire[3:0] count_up_one;  
    reg count_en;            
    wire count_full;              
    wire[11:0] block_address;   
                 

    dff state_flip_flop(.clk(clk), .rst(rst), .d(next_state), .q(state), .wen(1'b1));
    
    dff counter[3:0](.clk(clk), .rst(rst), .d(next_count[3:0]), .q(count[3:0]), .wen(count_en));
    inc_3bit inc_count_one(.in(count[2:0]), .out(count_up_one[2:0]), .cout(count_up_one[3])); 
    assign next_count = (state & count_full) ? 4'b0000 : count_up_one; 
    assign count_full = count[3]; 
    
    assign block_address = miss_detected ? miss_address[15:4] : block_address;                                   
    assign memory_address = fsm_busy ? {block_address, count[2:0], 1'b0} : miss_address;
          
    always @ (state, miss_detected, memory_data_valid, count_full)
        casex ({state, miss_detected, memory_data_valid, count_full}) 
            4'b0_0_?_?: begin next_state = 0; fsm_busy = 0; write_tag_array = 0; write_data_array = 0; count_en = 0; end
            4'b0_1_?_?: begin next_state = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 0; count_en = 0; end
            4'b1_?_?_1: begin next_state = 0; fsm_busy = 1; write_tag_array = 1; write_data_array = 0; count_en = 1; end
            4'b1_?_0_0: begin next_state = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 0; count_en = 0; end
            4'b1_?_1_0: begin next_state = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 1; count_en = 1; end   
            default: begin next_state = 0; fsm_busy = 0; write_tag_array = 0; write_data_array = 0; count_en = 0; end
        endcase
      
endmodule

module inc_3bit(in, out, cout);
    input[2:0] in;      // 3 bit input
    output[2:0] out;    // input + 1
	output cout;        // carry after the 3rd bit
    
    wire int1, int2;
    
    assign out[0] = in[0] ^ 1; 
    assign int1 = in[0] & 1;
    
    assign out[1] = in[1] ^ int1;
    assign int2 = in[1] & int1;
    
    assign out[2] = in[2] ^ int2;
	assign cout = in[2] & int2;
    
endmodule

