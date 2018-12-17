`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-1//Define//DEBUG_Define.v"
`timescale  1ns/1ps

module dm_4k(addr, be, din, DMWr, clk, dout);
	parameter width = 32, AddrWidth = 10, num = 1024;
	
	input [AddrWidth + 2 - 1:2] addr;
	input [3:0] be;
	input [width - 1:0] din;
	input DMWr;
	input clk;
	output [width - 1:0] dout;
	
	reg [width - 1:0] dataMemory[num - 1:0];
	integer i;
	
	initial
		begin
		for(i = 0;i < num;i = i + 1)
			dataMemory[i] <= 0;
		end
		
	assign dout = dataMemory[addr];
	
	always@(posedge clk)
		begin
		#20
		if(DMWr)
			begin
			case(be)
				4'b1111:
					begin
					dataMemory[addr] <= din;
					end
				4'b1100:
					begin
					dataMemory[addr][31:16] <= din[15:0];
					end
				4'b0011:
					begin
					dataMemory[addr][15:0] <= din[15:0];
					end
				4'b1000:
					begin
					dataMemory[addr][31:24] <= din[7:0];
					end
				4'b0100:
					begin
					dataMemory[addr][23:16] <= din[7:0];
					end
				4'b0010:
					begin
					dataMemory[addr][15:8] <= din[7:0];
					end
				4'b0001:
					begin
					dataMemory[addr][7:0] <= din[7:0];
					end
			endcase
			`ifdef DM_DEBUG
			#20 $display("DataMemory  %x  %x", (addr << 2), dataMemory[addr]);
			`endif
			end
		end
endmodule