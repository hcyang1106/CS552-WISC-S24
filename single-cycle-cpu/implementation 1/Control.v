module Control(opcode, CCC, N, Z, V, PCWrite, RegSrc, RegWrite, ExtSrc, ByteSel, ALUSrc, MemWrite, LoadByte, PCS, MemtoReg, ALUop, BrReg, Branch);
	
	input [3:0] opcode;
	input [2:0] CCC;
	input N, Z, V;
	output reg PCWrite, RegSrc, RegWrite, ExtSrc, ByteSel, ALUSrc, MemWrite, LoadByte, PCS, MemtoReg, ALUop, BrReg, Branch;
	
	wire control;
	
	branch_control branch_control(.CCC(CCC), .N(N), .Z(Z), .V(V), .out(control));
	
	always @(opcode) begin
		case (opcode)
			4'b0000: begin // ADD
				PCWrite = 1'b1;
				RegSrc = 1'b0;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b000;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0001: begin // SUB
				PCWrite = 1'b1;
				RegSrc = 1'b0;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b001;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0010: begin // XOR
				PCWrite = 1'b1;
				RegSrc = 1'b0;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b010;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0011: begin // RED
				PCWrite = 1'b1;
				RegSrc = 1'b0;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b011;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0100: begin // SLL
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'b0;
				ByteSel = 1'bx;
				ALUSrc = 1'b1;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b100;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0101: begin // SRA
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'b0;
				ByteSel = 1'bx;
				ALUSrc = 1'b1;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b101;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0110: begin // ROR
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'b0;
				ByteSel = 1'bx;
				ALUSrc = 1'b1;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b110;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b0111: begin // PADDSB
				PCWrite = 1'b1;
				RegSrc = 1'b0;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b111;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b1000: begin // LW
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'b1;
				ByteSel = 1'bx;
				ALUSrc = 1'b1;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'b1;
				ALUop = 3'b000;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b1001: begin // SW
				PCWrite = 1'b1;
				RegSrc = 1'b1;
				RegWrite = 1'b0;
				ExtSrc = 1'b1;
				ByteSel = 1'bx;
				ALUSrc = 1'b1;
				MemWrite = 1'b1;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'bx;
				ALUop = 3'b000;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b1010: begin // LLB
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'b0;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'b1;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b1011: begin // LHB
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'b1;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'b1;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b1100: begin // B
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'bx;
				ALUop = 3'bxxx;
				BrReg = 1'b0;
				Branch = control;
			end
			
			4'b1101: begin // BR // TODO CC check
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'bx;
				ALUop = 3'bxxx;
				BrReg = control;
				Branch = 1'b0;
			end
			
			4'b1110: begin // PCS
				PCWrite = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'b1;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrReg = 1'b0;
				Branch = 1'b0;
			end
			
			4'b1111: begin // HLT
				PCWrite = 1'b0;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'bx;
				ALUop = 3'bxxx;
				BrReg = 1'bx;
				Branch = 1'bx;
			end
			
			default: begin // HLT
				PCWrite = 1'b0;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'bx;
				ALUop = 3'bxxx;
				BrReg = 1'bx;
				Branch = 1'bx;
			end
		endcase
	end

endmodule

module branch_control(CCC, N, Z, V, out);

	input [2:0] CCC;
	input N, Z, V;
	output reg out;

	always @(CCC) begin
		case (CCC)
			3'b000: out = (Z == 1'b0); 
			3'b001: out = (Z == 1'b1); 
			3'b010: out = ((Z == 1'b0) && (N == 1'b0)); 
			3'b011: out = (N == 1'b1); 
			3'b100: out = ((Z == 1'b1) || ((N == 1'b0) && (Z == 1'b0))); 
			3'b101: out = ((N == 1'b1) || (Z == 1'b1));
			3'b110: out = (V == 1'b1); 
			3'b111: out = 1'b1; 
			default: out = 1'bx;
			
		endcase
	end
	
endmodule