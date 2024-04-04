module hazard_detection (input [3:0] EX_wd, input EX_MemtoReg, input EX_RegWrite, input EX_set_N, input EX_set_V, input EX_set_Z, input [15:0] instruction, output reg stall);
	always @(*) begin
		case (instruction[15:12])
			4'b0000: begin // ADD
				stall = (EX_MemtoReg & EX_RegWrite) ? (((instruction[7:4] == EX_wd) | (instruction[3:0] == EX_wd)) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0001: begin // SUB
				stall = (EX_MemtoReg & EX_RegWrite) ? (((instruction[7:4] == EX_wd) | (instruction[3:0] == EX_wd)) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0010: begin // XOR
				stall = (EX_MemtoReg & EX_RegWrite) ? (((instruction[7:4] == EX_wd) | (instruction[3:0] == EX_wd)) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0011: begin // RED
				stall = (EX_MemtoReg & EX_RegWrite) ? (((instruction[7:4] == EX_wd) | (instruction[3:0] == EX_wd)) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0100: begin // SLL
				stall = (EX_MemtoReg & EX_RegWrite) ? ((instruction[7:4] == EX_wd) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0101: begin // SRA
				stall = (EX_MemtoReg & EX_RegWrite) ? ((instruction[7:4] == EX_wd) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0110: begin // ROR
				stall = (EX_MemtoReg & EX_RegWrite) ? ((instruction[7:4] == EX_wd) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b0111: begin // PADDSB
				stall = (EX_MemtoReg & EX_RegWrite) ? (((instruction[7:4] == EX_wd) | (instruction[3:0] == EX_wd)) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b1000: begin // LW
				stall = (EX_MemtoReg & EX_RegWrite) ? ((instruction[7:4] == EX_wd) ? 1'b1 : 1'b0) : 1'b0;
			end
			
			4'b1001: begin // SW
				stall = (EX_MemtoReg & EX_RegWrite) ? ((instruction[7:4] == EX_wd) ? 1'b1 : 1'b0) : 1'b0; // TODO
			end
			
			4'b1010: begin // LLB
				stall = 1'b0;
			end
			
			4'b1011: begin // LHB
				stall = 1'b0;
			end
			
			4'b1100: begin // B
				stall = (EX_set_N | EX_set_V | EX_set_Z);
			end
			
			4'b1101: begin // BR
				stall = (EX_set_N | EX_set_V | EX_set_Z);
			end
			
			4'b1110: begin // PCS
				stall = 1'b0;
			end
			
			4'b1111: begin // HLT
				stall = 1'b0;
			end
			
			default: begin // HLT
				stall = 1'b0;
			end
		endcase
	end
endmodule 