module TargetPC(clk, nextPC, target, targetPC);
	input clk;
	input [31:0] nextPC;
	input [25:0] target;
	output reg [31:0] targetPC;
	
	always@(negedge clk)
		begin
		targetPC <= {nextPC[31:28], target, 2'b00};
		end
endmodule