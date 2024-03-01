module Control(opcode, MemWrite, MemToReg, RegWrite, BInv, ALUSrc, ALUOp, ShiftImm, ReadReg1Src, ReadReg2Src);
    
    input [3:0] opcode;
    output reg MemWrite, MemToReg, RegWrite, BInv, ShiftImm, ReadReg1Src, ReadReg2Src;
    output reg [1:0] ALUSrc;
    output reg [3:0] ALUOp;

    always @(*) begin
		case(opcode)
			4'b0000: begin //ADD
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b00;
				ALUOp			<= 4'b0000;
                ReadReg1Src     <= 1'b0;
                ReadReg2Src     <= 1'b0;
                // ShiftImm don't care 
			end
			4'b0001: begin // SUB
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b1;
                ALUSrc          <= 2'b00;
				ALUOp			<= 4'b0000;
                ReadReg1Src     <= 1'b0;
                ReadReg2Src     <= 1'b0;
                // ShiftImm don't care 
			end
			4'b0010: begin // XOR
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b00;
				ALUOp			<= 4'b0001;
                ReadReg1Src     <= 1'b0;
                ReadReg2Src     <= 1'b0;
                // ShiftImm don't care
			end
			4'b0011: begin // RED
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b00;
				ALUOp			<= 4'b0010;
                ReadReg1Src     <= 1'b0;
                ReadReg2Src     <= 1'b0;
                // ShiftImm don't care	
			end
            4'b0100: begin // SLL
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b01;
				ALUOp			<= 4'b0011;
                ShiftImm        <= 1'b0;
                ReadReg1Src     <= 1'b0;
                // ReadReg2Src don't care   
			end
            4'b0101: begin // SRA
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b01;
				ALUOp			<= 4'b0100;
                ShiftImm        <= 1'b0;
                ReadReg1Src     <= 1'b0;
                // ReadReg2Src don't care 
			end
            4'b0110: begin // ROR
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b01;
				ALUOp			<= 4'b0101;
                ShiftImm        <= 1'b0;
                ReadReg1Src     <= 1'b0;
                // ReadReg2Src don't care 
			end
            // 4'b0010: begin // PADDSB
				
			// end
            4'b1010: begin // LLB
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b10;
				ALUOp			<= 4'b0111;
                ReadReg1Src     <= 1'b1;
                // ShiftImm don't care
                // ReadReg2Src don't care
			end
            4'b1011: begin // LHB
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b0;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b10;
				ALUOp			<= 4'b1000;
                ReadReg1Src     <= 1'b1;
                // ShiftImm don't care
                // ReadReg2Src don't care
			end
            4'b1000: begin // LW
				MemWrite		<= 1'b0;
                MemToReg        <= 1'b1;
                RegWrite		<= 1'b1;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b01;
				ALUOp			<= 4'b0000;
                ShiftImm        <= 1'b1;
                ReadReg1Src     <= 1'b0;
                // ReadReg2Src don't care
			end
            4'b1001: begin // SW
				MemWrite		<= 1'b1;
                RegWrite		<= 1'b0;
                BInv            <= 1'b0;
                ALUSrc          <= 2'b01;
				ALUOp			<= 4'b0000;
                ShiftImm        <= 1'b1;
                ReadReg1Src     <= 1'b0;
                ReadReg2Src     <= 1'b1;
                // MemToReg don't care
			end
            default: begin
            MemWrite        <= 1'b0;
            MemToReg        <= 1'b0;
            RegWrite        <= 1'b0;
            BInv            <= 1'b0;
            ALUSrc          <= 2'b00;
            ALUOp           <= 4'b0000;
            ShiftImm        <= 1'b0;
            ReadReg1Src     <= 1'b0;
	        ReadReg2Src     <= 1'b0;
        end
		endcase
	end

endmodule