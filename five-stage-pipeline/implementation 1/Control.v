module Control(opcode, d_flush, CCC, N, Z, V, set_N, set_Z, set_V, Halt, RegSrc, RegWrite, ExtSrc, ByteSel, ALUSrc, MemWrite, LoadByte, PCS, MemtoReg, ALUop, BrSrc, Branch);
	
	input [3:0] opcode;
	input [2:0] CCC;
	input N, Z, V;
	output reg set_N, set_Z, set_V;
	output reg Halt, RegSrc, RegWrite, ExtSrc, ByteSel, ALUSrc, MemWrite, LoadByte, PCS, MemtoReg, BrSrc, Branch;
	output reg [2:0] ALUop;
	
	wire b_control;
	
	branch_control iB_control(.CCC(CCC), .N(N), .Z(Z), .V(V), .out(b_control));
	
	always @(*) begin
		case (opcode)
			4'b0000: begin // ADD
				Halt = 1'b0;
				RegSrc = 1'b0;
				RegWrite = ~d_flush;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b0;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'b000;
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = ~d_flush;
				set_V = ~d_flush;
				set_Z = ~d_flush;
			end
			
			4'b0001: begin // SUB
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b1;
				set_V = 1'b1;
				set_Z = 1'b1;
			end
			
			4'b0010: begin // XOR
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b1;
			end
			
			4'b0011: begin // RED
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b1;
			end
			
			4'b0100: begin // SLL
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b1;
			end
			
			4'b0101: begin // SRA
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b1;
			end
			
			4'b0110: begin // ROR
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b1;
			end
			
			4'b0111: begin // PADDSB
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1000: begin // LW
				Halt = 1'b0;
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
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1001: begin // SW
				Halt = 1'b0;
				RegSrc = 1'b1;
				RegWrite = 1'b0;
				ExtSrc = 1'b1;
				ByteSel = 1'bx;
				ALUSrc = 1'b1;
				MemWrite = 1'b1;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'b0;
				ALUop = 3'b000;
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1010: begin // LLB
				Halt = 1'b0;
				RegSrc = 1'b1;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'b0;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b1;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1011: begin // LHB
				Halt = 1'b0;
				RegSrc = 1'b1;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'b1;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'b1;
				PCS = 1'b0;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1100: begin // B
				Halt = 1'b0;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'b0;
				Branch = b_control;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1101: begin // BR
				Halt = 1'b0;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'b1;
				Branch = b_control;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1110: begin // PCS
				Halt = 1'b0;
				RegSrc = 1'bx;
				RegWrite = 1'b1;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'b0;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'b1;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'b0;
				Branch = 1'b0;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			4'b1111: begin // HLT
				Halt = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'bx;
				Branch = 1'bx;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
			
			default: begin // HLT
				Halt = 1'b1;
				RegSrc = 1'bx;
				RegWrite = 1'b0;
				ExtSrc = 1'bx;
				ByteSel = 1'bx;
				ALUSrc = 1'bx;
				MemWrite = 1'b0;
				LoadByte = 1'bx;
				PCS = 1'bx;
				MemtoReg = 1'b0;
				ALUop = 3'bxxx;
				BrSrc = 1'bx;
				Branch = 1'bx;
				set_N = 1'b0;
				set_V = 1'b0;
				set_Z = 1'b0;
			end
		endcase
	end
endmodule

module branch_control(CCC, N, Z, V, out);

	input [2:0] CCC;
	input N, Z, V;
	output reg out;

	always @(*) begin
		case (CCC)
			3'b000: begin out = (Z == 1'b0); end
			3'b001: begin out = (Z == 1'b1); end
			3'b010: begin out = ((Z == 1'b0) | (N == 1'b0)); end
			3'b011: begin out = (N == 1'b1); end
			3'b100: begin out = ((Z == 1'b1) | ((N == 1'b0) & (Z == 1'b0))); end
			3'b101: begin out = ((N == 1'b1) | (Z == 1'b1)); end
			3'b110: begin out = (V == 1'b1); end
			3'b111: begin out = 1'b1; end
			default: begin out = 1'bx; end
		endcase
	end
	
endmodule