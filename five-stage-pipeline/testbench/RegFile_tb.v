module RegisterFile_tb();

	reg clk, rst, WriteReg;
	reg [3:0] SrcReg1, SrcReg2, DstReg;
	reg [15:0] DstData;
	wire [15:0] SrcData1, SrcData2;
	
	reg [15:0] reg_file [15:0];
	RegisterFile iReg(.clk(clk), .rst(rst), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(DstReg), .WriteReg(WriteReg), .DstData(DstData), .SrcData1(SrcData1), .SrcData2(SrcData2));

	integer i;
	initial begin
		clk = 0;
		rst = 1;
		
		for (i = 0; i < 16; i = i+1) begin
			reg_file[i] = 0;
		end
		
		@(posedge clk);
		rst = 0;

		for (i = 0; i < 1000; i = i+1) begin
			SrcReg1 = $random;
			SrcReg2 = $random;

			WriteReg = $random;
			DstReg = $random;
			DstData = $random;
			
			@(negedge clk);
			
			if((SrcReg1 === DstReg) & WriteReg) begin
				if((SrcData1 !== DstData)) begin
					$display("Read source 1 passthrough error, i = %d, SrcReg1 = %b, SrcData1 = %d, reg_file[SrcReg1] = %d", i, SrcReg1, SrcData1, reg_file[SrcReg1]);
				end
			end
			else if (SrcData1 !== reg_file[SrcReg1]) begin
				$display("Read source 1 error, i = %d, SrcReg1 = %b, SrcData1 = %d, reg_file[SrcReg1] = %d", i, SrcReg1, SrcData1, reg_file[SrcReg1]);
			end
			if((SrcReg2 === DstReg) & WriteReg) begin
				if(SrcData2 !== DstData) begin
					$display("Read source 2 passthrough error, i = %d, SrcReg2 = %b", i, SrcReg2);
				end
			end
			else if(SrcData2 !== reg_file[SrcReg2]) begin
				$display("Read source 2 error, i = %d, SrcReg2 = %b", i, SrcReg2);
			end
			
			
			if(WriteReg === 1) begin
				reg_file[DstReg] = DstData;
			end
		
			@(posedge clk);
		end
		
		$display("Test complete");
		$stop();
	end
	
	always
		#5 clk = ~clk;
endmodule