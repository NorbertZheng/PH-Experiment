module flopr(clk, reset, stall, flush, d, q);
	parameter width = 32;
	
	input clk;
	input reset;
	input stall;
	input flush;
	input [width - 1:0] d;
	output reg [width - 1:0] q;
	
	always@(negedge clk or negedge reset)
		begin
		if(!reset)
			begin
			q <= {width{1'b0}};
			end
		else if(!stall)
			begin
			if(flush)
				begin
				q <= {width{1'b0}};
				end
			else
				begin
				q <= d;
				end
			end
		end
endmodule