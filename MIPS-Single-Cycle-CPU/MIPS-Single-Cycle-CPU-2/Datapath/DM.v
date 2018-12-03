module DM(clk, DMWr, addr_i, din_i, dout_o);
	input clk;
	input DMWr;
	input [11:2] addr_i;
	input [31:0] din_i;
	output [31:0] dout_o;
	
	integer i;
	reg [31:0] DataMemory[1023:0];
	
	initial
		begin
		for(i = 0;i < 1024;i = i + 1)
			begin
			DataMemory[i] <= 32'b0;
			end
		end
	
	assign dout_o = DataMemory[addr_i];
	
	always@(negedge clk)
		begin
		if(DMWr)
			begin
			DataMemory[addr_i] <= din_i;
			$display("DataMemory  %x  %x", addr_i, din_i);
			end
		end
endmodule