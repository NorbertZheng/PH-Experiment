module flopr(clk, update, d, q);
	parameter width = 32;
	
	input clk;
	input update;
	input [width - 1:0] d;
	output reg [width - 1:0] q;
	
	always@(negedge clk)
		begin
		q <= (update == 1) ? d : q;
		end
endmodule