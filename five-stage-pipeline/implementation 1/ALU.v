module ALU(a, b, ALUOp, out, N, Z, V);

    // ---ALUOp---
    // 000: add
    // 001: sub
    // 010: xor
    // 011: red
    // 100: sll
    // 101: sra
    // 110: ror
    // 111: paddsb
    // ---ALUOp---

    input [15:0] a, b;
    input [2:0] ALUOp;
    output reg [15:0] out;
	output reg N, Z, V;

    wire [15:0] add_out, xor_out, sll_out, sra_out, ror_out, red_out, paddsb_out;
	
	// add_sub
	wire [15:0] add_b, sat_out, S;
	wire ovfl, Cout;
	
	assign add_b = ALUOp[0] ? ~b : b;
    cla_16bit iAdd(.A(a), .B(add_b), .Cin(ALUOp[0]), .S(S), .Cout(Cout), .ovfl(ovfl));
	assign sat_out = Cout ? {1'b1, {15{1'b0}}} : {1'b0, {15{1'b1}}};
	assign add_out = ovfl ? sat_out : S;
	
	// xor
	assign xor_out = a ^ b;
	
	// red
    ReductionUnit iReduction(.A(a), .B(b), .S(red_out));

	// sll
    SLL Sll(.in(a), .shamt(b[3:0]), .out(sll_out));
    
	// sra
	SRA Sra(.in(a), .shamt(b[3:0]), .out(sra_out));
	
	// ror
    ROR Ror(.in(a), .shamt(b[3:0]), .out(ror_out));
	
    // paddsb
	paddsb Paddsb(.A(a), .B(b), .out(paddsb_out));
	
	// set N
	always @(ALUOp) begin
		case (ALUOp) 
			3'b000: N = add_out[15];
			3'b001: N = add_out[15];
			default: N = 1'bx;
		endcase
	end
	
	// set Z
	always @(ALUOp) begin
		case (ALUOp) 
			3'b000: Z = (add_out == 16'h0000);
			3'b001: Z = (add_out == 16'h0000);
			3'b010: Z = (xor_out == 16'h0000);
			3'b011: Z = (red_out == 16'h0000);
			3'b100: Z = (sll_out == 16'h0000);
			3'b101: Z = (sra_out == 16'h0000);
			default: Z = 1'bx;
		endcase
	end
	
	// set V
	always @(ALUOp) begin
		case (ALUOp) 
			3'b000: V = ovfl;
			3'b001: V = ovfl;
			default: V = 1'bx;
		endcase
	end
	
	
	// selection
	always @(ALUOp) begin
		case (ALUOp) 
			3'b000: out = add_out;
			3'b001: out = add_out;
			3'b010: out = xor_out;
			3'b011: out = red_out;
			3'b100: out = sll_out;
			3'b101: out = sra_out;
			3'b110: out = ror_out;
			3'b111: out = paddsb_out;
			default: out = 16'h0000;
		endcase
	end
	
endmodule