module d_cache(clk, rst_n, data_out, data_in, addr, wr, enable, memory_data_valid, stall, mem_enable, mem_write, memory_address);
	input clk, rst_n, wr, enable;
	input [15:0] data_in, addr;
	input memory_data_valid;
	output stall, mem_enable, mem_write;
	output [15:0] data_out, memory_address;
	
	wire [127:0] BlockEnable;
	wire [7:0] WordEnable;
	wire [7:0] MetaDataArray_tag;
	wire [2:0] word_select, byte_count;
	wire write_data_array;
	
	assign word_select = write_data_array ? byte_count : addr[3:1];
	
	bit_7_decoder BlockEnable_decoder(.in({addr[9:4], set_line}), .en(1'b1), .out(BlockEnable));
	bit_3_decoder WordEnable_decoder(.in(word_select), .en(1'b1), .out(WordEnable));

	DataArray DA(.clk(clk), .rst(rst_n), .DataIn(data_in), .Write(write_data_array | mem_write), .BlockEnable(BlockEnable), .WordEnable(WordEnable), .DataOut(data_out));
	MetaDataArray MDA(.clk(clk), .rst(rst_n), .DataIn({new_LRU_bit, new_v_bit, addr[15:10]}), .Write(update_MetaData), .BlockEnable(BlockEnable), .DataOut(MetaDataArray_tag));
	
	d_cache_controller controller(.clk(clk), .rst_n(rst_n), .wr(wr), .addr(addr), .enable(enable), .memory_data_valid(memory_data_valid), .mem_enable(mem_enable), .MetaDataArray_tag(MetaDataArray_tag), .set_line(set_line), .update_MetaData(update_MetaData), .new_LRU_bit(new_LRU_bit), .new_v_bit(new_v_bit), .memory_address(memory_address), .write_data_array(write_data_array), .stall(stall), .byte_count(byte_count), .mem_write(mem_write));
endmodule

module d_cache_controller(clk, rst_n, wr, addr, enable, memory_data_valid, MetaDataArray_tag, set_line, mem_enable, update_MetaData, new_LRU_bit, new_v_bit, memory_address, write_data_array, stall, byte_count, mem_write);
	input clk, rst_n, wr, memory_data_valid, enable;
	input [15:0] addr;
	input [7:0] MetaDataArray_tag;
	output write_data_array, mem_enable;
	output [2:0] byte_count;
	output [15:0] memory_address;
	output reg set_line, update_MetaData, new_LRU_bit, new_v_bit, stall, mem_write;
	
	wire LRU_line;
	wire [15:0] miss_address, memory_address_fill;
	wire [3:0] state;
	wire [5:0] tag, MDA_tag;
	wire fsm_busy, write_tag_array;
	wire v_bit_old, set_line_out;
	reg next_set_line, wen_set_line, wen_miss_addr;
	reg next_v_bit_old, v_bit_old_wen;
	reg next_LRU_line, wen_LRU_line, miss_detected;
	reg [3:0] next_state;
	
	dff miss_addr[15:0](.q(miss_address), .d(addr), .wen(wen_miss_addr), .clk(clk), .rst(rst_n));
	dff state_reg[3:0](.q(state), .d(next_state), .wen(1'b1), .clk(clk), .rst(rst_n));
	dff LRU(.q(LRU_line), .d(next_LRU_line), .wen(wen_LRU_line), .clk(clk), .rst(rst_n));
	dff set_line_reg(.q(set_line_out), .d(next_set_line), .wen(wen_set_line), .clk(clk), .rst(rst_n));
	dff V_old(.q(v_bit_old), .d(next_v_bit_old), .wen(v_bit_old_wen), .clk(clk), .rst(rst_n));
	
	i_cache_fill_FSM FSM(.clk(clk), .rst_n(rst_n), .miss_detected(miss_detected), .miss_address(miss_address), .fsm_busy(fsm_busy), .mem_enable(mem_enable), .write_data_array(write_data_array), .write_tag_array(write_tag_array), .memory_address(memory_address_fill), .memory_data(), .memory_data_valid(memory_data_valid), .byte_count_out(byte_count));
	
	assign tag = miss_address[15:10];
	assign LRU_bit = MetaDataArray_tag[7];
	assign v_bit = MetaDataArray_tag[6];
	assign MDA_tag = MetaDataArray_tag[5:0];
	
	assign memory_address = mem_write ? miss_address : memory_address_fill;
	
	always @(*) begin
		case (state)
			4'b0000: begin // fill miss
				next_state = enable ? (fsm_busy ? 4'b0000 : 4'b0110) : 4'b0011;
				set_line = fsm_busy ? LRU_line : (LRU_line ? 1'b0: 1'b1);
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = enable ? 1'b1 : 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = fsm_busy ? write_tag_array : 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = enable ? 1'b1 : 1'b0;
			end
			
			4'b0001: begin // check line 1
				next_state = (v_bit & (tag == MDA_tag)) ? (LRU_bit ? 4'b1000 : (wr ? 4'b1010 : 4'b1011)) : 4'b0010;
 				set_line = 1'b0;
				next_LRU_line = 1'b0;
				wen_LRU_line = LRU_bit;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b1;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b0010: begin // check line 2
				next_state = (v_bit & (tag == MDA_tag)) ? (LRU_bit ? 4'b1001 : (wr ? 4'b1010 : 4'b1011)) : 4'b0000;
				set_line = 1'b1;
				next_LRU_line = 1'b1;
				wen_LRU_line = LRU_bit;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b1;
				
				update_MetaData = 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b1;
				wen_set_line = 1'b1;
				
				mem_write = 1'b0;

				stall = 1'b1;
			end
			
			4'b0011: begin // IDLE
				next_state = (enable | wr) ? 4'b0001 : 4'b0011;
				set_line = set_line_out;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b0;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = (enable | wr) ? 1'b1 : 1'b0;
			end
			
			4'b0100: begin // update line 2 LRU bit to 0
				next_state = wr ? 4'b1010 : 4'b1011;
				set_line = 1'b1;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b1;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b0101: begin // update line 1 LRU bit to 0
				next_state = wr ? 4'b1010 : 4'b1011;
				set_line = 1'b0;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b1;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;

				stall = 1'b1;
			end
			
			4'b0110: begin // get line v_bit
				next_state = 4'b0111;
				set_line = LRU_line ? 1'b0 : 1'b1;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b0;
				
				next_v_bit_old = v_bit;
				v_bit_old_wen = 1'b1;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;

				stall = 1'b1;
			end
			
			4'b0111: begin // update line v_bit
				next_state = wr ? 4'b1010 : 4'b1011;
				set_line = LRU_line ? 1'b0 : 1'b1;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b1;
				new_LRU_bit = 1'b1;
				new_v_bit = v_bit_old;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = LRU_line;
				wen_set_line = 1'b1;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b1000: begin // update line 2 LRU bit to 1
				next_state = 4'b0101;
				set_line = 1'b1;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b1;
				new_LRU_bit = 1'b1;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b1001: begin // update line 1 LRU bit to 1
				next_state = 4'b0100;
				set_line = 1'b0;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b1;
				new_LRU_bit = 1'b1;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b1010: begin // write through
				next_state = 4'b1011;
				set_line = set_line_out;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b0;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b1;
				
				stall = 1'b1;
			end
			
			4'b1011: begin // read
				next_state = 4'b0011;
				set_line = set_line_out;
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b0;
				wen_miss_addr = 1'b0;
				
				update_MetaData = 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b0;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b0;
			end
			
			4'b1100: begin // unused
				next_state = fsm_busy ? 4'b0000 : 4'b0110;
				set_line = fsm_busy ? LRU_line : (LRU_line ? 1'b0: 1'b1);
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b1;
				wen_miss_addr = 1'b0;
				
				update_MetaData = fsm_busy ? write_tag_array : 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b1101: begin // unused
				next_state = fsm_busy ? 4'b0000 : 4'b0110;
				set_line = fsm_busy ? LRU_line : (LRU_line ? 1'b0: 1'b1);
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b1;
				wen_miss_addr = 1'b0;
				
				update_MetaData = fsm_busy ? write_tag_array : 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b1110: begin // unused
				next_state = fsm_busy ? 4'b0000 : 4'b0110;
				set_line = fsm_busy ? LRU_line : (LRU_line ? 1'b0: 1'b1);
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b1;
				wen_miss_addr = 1'b0;
				
				update_MetaData = fsm_busy ? write_tag_array : 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			4'b1111: begin // unused
				next_state = fsm_busy ? 4'b0000 : 4'b0110;
				set_line = fsm_busy ? LRU_line : (LRU_line ? 1'b0: 1'b1);
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b1;
				wen_miss_addr = 1'b0;
				
				update_MetaData = fsm_busy ? write_tag_array : 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
			
			default: begin // unused
				next_state = fsm_busy ? 4'b0000 : 4'b0110;
				set_line = fsm_busy ? LRU_line : (LRU_line ? 1'b0: 1'b1);
				next_LRU_line = 1'b0;
				wen_LRU_line = 1'b0;
				miss_detected = 1'b1;
				wen_miss_addr = 1'b0;
				
				update_MetaData = fsm_busy ? write_tag_array : 1'b0;
				new_LRU_bit = 1'b0;
				new_v_bit = 1'b1;
				
				next_v_bit_old = 1'b0;
				v_bit_old_wen = 1'b0;
				
				next_set_line = 1'b0;
				wen_set_line = 1'b0;
				
				mem_write = 1'b0;
				
				stall = 1'b1;
			end
		endcase
	
	end
endmodule