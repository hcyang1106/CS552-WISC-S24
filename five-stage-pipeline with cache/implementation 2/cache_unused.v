module cache_unused(clk, rst, instr_data_in, instr_data_out, instr_address, cache_enable, cache_write,
            stall, mem_data_in, mem_data_out, mem_en, mem_write, mem_valid, mem_address);
    input clk, rst;
    input cache_enable;
    input cache_write;
    input mem_valid; // 1 when memory data is ready
    input[15:0] instr_data_in; // data writes to cache
    input[15:0] instr_address; // 
    input[15:0] mem_data_out; // data read from mem
    output stall;
    output mem_en;
    output mem_write;
    output[15:0] instr_data_out; // data returned by cache
    output[15:0] mem_data_in; // data sent from cache to mem
    output[15:0] mem_address; // address sent from cache to mem

    wire[5:0] active_tag;
    wire[5:0] active_set;
    wire[63:0] set_select;
    wire[15:0] tag_word;
    wire tag_1_HIT, tag_0_HIT;
    wire miss_detected;
    wire hit_detected;

    wire[5:0] tag0, tag1;
    wire valid0, valid1;
    wire LRU0, LRU1;

    wire blockLSB;
    wire[6:0] active_block;
    wire[127:0] block_select;
    wire[2:0] proc_word;
    wire[2:0] mem_word;
    wire[2:0] active_word;
    wire[7:0] word_select;

    wire[15:0] writeAddress;
    wire data_write;
    wire meta_write;
    wire[15:0] array_data_in;
    reg[15:0] new_tag_word;

    wire data_update;
    wire tag_update;

    DataArray data(.clk(clk), .rst(rst), .DataIn(arrayDataIn), .Write(dataWrite), 
                   .BlockEnable(blockSelect), .WordEnable(wordSelect), .DataOut(procDataOut));

    MetaDataArray meta(.clk(clk), .rst(rst), .DataIn(newTagWord), 
                       .Write(metaWrite), .SetEnable(setSelect), .DataOut(tagWord));

    cache_fill_FSM missHandler(.clk(clk), .rst(rst), .miss_detected(miss_detected),
                               .miss_address(instr_address), .fsm_busy(stall),
                               .write_data_array(data_update), .write_tag_array(tag_update,
                               .memory_address(mem_address), .memory_data_valid(mem_valid));

    assign active_tag = instr_address[15:10];
    assign active_set = instr_address[9:4];
    decoder_6_64 setFinder(.in(active_set), .out(set_select));
    assign {LRU1, valid1, tag1, LRU0, valid0, tag0} = tag_word;
    assign tag_1_HIT = (tag1 == active_tag) & valid1;
    assign tag_0_HIT = (tag0 == active_tag) & valid0;
    assign miss_detected = !(tag_1_HIT | tag_0_HIT) & cache_enable;
    assign hit_detected = (tag_1_HIT | tag_0_HIT) & cache_enable;

    assign blockLSB = stall ? ((!valid0) ? 0 : ((!valid1) ? 1 : LRU1)) : tag_1_HIT;
    assign active_block = {active_set, blockLSB};
    decoder_7_128 blockFinder(.in(active_block), .out(block_select));

    assign proc_word = instr_address[3:1];
    assign mem_word = writeAddress[3:1];
    assign active_word = stall ? mem_word : proc_word;
    decoder_3_8 wordFinder(.in(active_word), .out(word_select) , .en(1'b1));

    assign mem_write = cache_enable & cache_write & !stall;
    assign mem_en = mem_write | stall;

    dff saveAdd[15:0](.d(mem_address), .q(writeAddress), .clk(clk), .rst(rst), .wen(mem_en));

    assign data_write = (cache_write & !stall) | data_update;

    assign meta_write = (cache_enable & !stall) | tag_update

    always @ (*) 
        casex({tag_update LRU1})
            2'b0_x: new_tag_word = {tag_0_HIT, valid1, tag1, LRU0, valid0, tag0};
            2'b1_0: new_tag_word = {!LRU1, valid0, tag1, LRU0, 1'b1, active_tag};
            2'b1_1: new_tag_word = {!LRU1, valid0, active_tag, LRU0, 1'b1, tag0};
        endcase

    assign array_data_in = stall ? mem_data_out : instr_data_in;
    assign mem_data_in = instr_data_in;
    
endmodule
