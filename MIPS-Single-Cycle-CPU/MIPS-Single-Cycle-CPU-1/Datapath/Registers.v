module Registers(clk, RegWrite, readReg1, readReg2, writeReg, writeData, readData1, readData2);
	parameter width = 32, AddrWidth = 5, num = 32;
	
	input clk;
	input RegWrite;
	input [AddrWidth - 1:0] readReg1;
	input [AddrWidth - 1:0] readReg2;
	input [AddrWidth - 1:0] writeReg;
	input [width - 1:0] writeData;
	output [width - 1:0] readData1;
	output [width - 1:0] readData2;
	
	reg [width - 1:0] registers[num - 1:0];
	integer i;
	
	initial
		begin
		for(i = 0;i < num;i = i + 1)
			registers[i] = 0;
		end
	
	assign readData1 = registers[readReg1];
	assign readData2 = registers[readReg2];
	
	always@(negedge clk)
		begin
		if(RegWrite)
			begin
			registers[writeReg] = (writeReg != 0) ? writeData : 0;
			$display("Registers  %x  %x", writeReg, writeData);
			end
		end
endmodule