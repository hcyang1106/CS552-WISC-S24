module hazard_detection_tb;
	reg EX_MemtoReg, EX_RegWrite, EX_set_N, EX_set_V, EX_set_Z;
	reg [15:0] instruction;
	reg [3:0] EX_wd;
	wire stall;
	
	hazard_detection iDUT(.EX_wd(EX_wd), .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite), .EX_set_N(EX_set_N), .EX_set_V(EX_set_V), .EX_set_Z(EX_set_Z), .instruction(instruction), .stall(stall));
	
	reg expected;
	
	integer i;
	initial begin
		EX_set_V = 0;
		EX_set_Z = 0;
		for (i = 0; i < 100000; i = i + 1) begin
			EX_set_N = $random;
			instruction = $random;
			EX_MemtoReg = $random;
			EX_RegWrite = $random;
			EX_wd = $random;
			if ($random % 2 == 1) begin
				instruction[7:4] = EX_wd;
				instruction[3:0] = EX_wd;
			end
			
			case (instruction[15:12])
				4'b0000: begin // ADD
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd || instruction[3:0] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0001: begin // SUB
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd || instruction[3:0] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0010: begin // XOR
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd || instruction[3:0] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0011: begin // RED
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd || instruction[3:0] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0100: begin // SLL
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0101: begin // SRA
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0110: begin // ROR
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b0111: begin // PADDSB
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd || instruction[3:0] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b1000: begin // LW
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b1001: begin // SW
					if(EX_MemtoReg && EX_RegWrite && (instruction[7:4] == EX_wd)) begin
						expected = 1'b1;
					end else begin 
						expected = 1'b0;
					end
				end
				
				4'b1010: begin // LLB
					expected = 1'b0;
				end
				
				4'b1011: begin // LHB
					expected = 1'b0;
				end
				
				4'b1100: begin // B
					if (EX_set_N == 1 || EX_set_V == 1 || EX_set_Z == 1) begin
						expected = 1'b1;
					end else begin
						expected = 1'b0;
					end
				end
				
				4'b1101: begin // BR
					if (EX_set_N == 1 || EX_set_V == 1 || EX_set_Z == 1) begin
						expected = 1'b1;
					end else begin
						expected = 1'b0;
					end
				end
				
				4'b1110: begin // PCS
					expected = 1'b0;
				end
				
				4'b1111: begin // HLT
					expected = 1'b0;
				end
				
				default: begin // HLT
					expected = 1'b0;
				end
			endcase
			
			#1;
			
			if (expected !== stall) begin
				$display("Error, expected: %b, actual: %b", expected, stall);
			end
			
		end
		$display("Test Complete");
	end
endmodule