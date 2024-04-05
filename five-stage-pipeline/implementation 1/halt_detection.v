module halt_detection (input [3:0] opcode, output halt_pc);

	assign halt_pc = (opcode == 4'b1111);

endmodule