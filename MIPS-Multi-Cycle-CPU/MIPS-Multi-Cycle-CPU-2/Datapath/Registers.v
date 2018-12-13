module Registers(clk, RegWrite, Read_register1, Read_register2, Write_register, Write_data, Read_data1, Read_data2);
	parameter width = 32, AddrWidth = 5, num = 32;
	
	input clk;
	input RegWrite;
	input [AddrWidth - 1:0] Read_register1;
	input [AddrWidth - 1:0] Read_register2;
	input [AddrWidth - 1:0] Write_register;
	input [width - 1:0] Write_data;
	output [width - 1:0] Read_data1;
	output [width - 1:0] Read_data2;
	
	reg [width - 1:0] registers[num - 1:0];
	integer i;
	
	initial
		begin
		for(i = 0;i < num;i = i + 1)
			registers[i] <= 0;
		registers[28] <= 32'h00001800;
		registers[29] <= 32'h00002ffe;
		end
	
	assign Read_data1 = registers[Read_register1];
	assign Read_data2 = registers[Read_register2];
	
	always@(negedge clk)
		begin
		if(RegWrite)
			begin
			registers[Write_register] = (Write_register != 0) ? Write_data : 0;
			`ifdef RF_DEBUG
			$display("R[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", 0, registers[1], registers[2], registers[3], registers[4], registers[5], registers[6], registers[7]);
			$display("R[08-15]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", registers[8], registers[9], registers[10], registers[11], registers[12], registers[13], registers[14], registers[15]);
			$display("R[16-23]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", registers[16], registers[17], registers[18], registers[19], registers[20], registers[21], registers[22], registers[23]);
			$display("R[24-31]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", registers[24], registers[25], registers[26], registers[27], registers[28], registers[29], registers[30], registers[31]);
			`endif
			//$display("Registers  %x  %x", Write_register, Write_data);
			end
		end
endmodule