module flopr(clk, rst, d, q);
	parameter width = 32;
	
	input clk;
	input rst;
	input [width - 1:0] d;
	output reg [width - 1:0] q;
	
	always@(negedge clk)
		begin
		if(!rst)
			begin
			q <= d;
			end
		else
			begin
			q <= 0;
			end
		end
endmodule