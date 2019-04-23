module Registers(clk, reset, RegWrite, readReg1, readReg2, writeReg, writeData, readData1, readData2, CPU_MIO);
	parameter width = 32, AddrWidth = 5, num = 32;
	
	input clk;
	input reset;
	input RegWrite;
	input [AddrWidth - 1:0] readReg1;
	input [AddrWidth - 1:0] readReg2;
	input [AddrWidth - 1:0] writeReg;
	input [width - 1:0] writeData;
	output [width - 1:0] readData1;
	output [width - 1:0] readData2;
	output[31:0] CPU_MIO;
	
	reg [width - 1:0] registers[num - 1:0];
	integer i;
	
	assign readData1 = registers[readReg1];
	assign readData2 = registers[readReg2];
	
	always@(negedge clk or negedge reset)
		begin
		if(!reset)
			begin
			for(i = 0;i < num;i = i + 1)
				registers[i] <= 0;
			registers[28] <= 32'h00001800;
			registers[29] <= 32'h00002ffe;
			end
		else if(RegWrite)
			begin
			registers[writeReg] <= (writeReg != 0) ? writeData : 0;
			$display("Registers  %x  %x", writeReg, writeData);
			end
		end
		
	assign CPU_MIO = registers[17] + 32'h00000020;
endmodule