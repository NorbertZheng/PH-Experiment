module flopr(clk, rst, d, q);
	parameter width = 32;
	
	input clk;
	input rst;
	input [width - 1:0] d;
	output reg [width - 1:0] q;
	
	always@(posedge clk)
		begin
		q <= (rst == 1) ? 0 : d;
		end
endmodule