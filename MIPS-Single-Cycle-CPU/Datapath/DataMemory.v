module DataMemory(clk, MemWrite, MemRead, Address, Write_data, Read_data);
	parameter width = 32, AddrWidth = 32, num = 1024;
	
	input clk;
	input MemWrite;
	input MemRead;
	input [AddrWidth - 1:0] Address;
	input [width - 1:0] Write_data;
	output [width - 1:0] Read_data;
	
	reg [width - 1:0] dataMemory[num - 1:0];
	integer i;
	
	initial
		begin
		for(i = 0;i < num;i = i + 1)
			dataMemory[i] <= 0;
		end
	
	assign Read_data = (MemRead) ? dataMemory[Address >> 2] : 32'b0;
	
	always@(negedge clk)
		begin
		if(MemWrite)
			begin
			dataMemory[Address >> 2] = Write_data;
			$display("DataMemory  %x  %x", Address, Write_data);
			end
		end
endmodule