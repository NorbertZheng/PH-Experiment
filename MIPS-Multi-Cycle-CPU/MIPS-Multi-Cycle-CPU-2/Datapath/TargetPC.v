module TargetPC(nextPC, target, targetPC);
	input [31:0] nextPC;
	input [25:0] target;
	output reg [31:0] targetPC;
	
	always@(*)
		begin
		targetPC = {nextPC[31:28], target, 2'b00};
		$display("targetPC = %x", targetPC);
		end
endmodule