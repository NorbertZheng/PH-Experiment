`timescale  1ns/1ps
module TargetPC(clk, nextPC, target, targetPC);
	input clk;
	input [31:0] nextPC;
	input [25:0] target;
	output reg [31:0] targetPC;
	
	always@(posedge clk)
		begin
		#(20) targetPC = {nextPC[31:28], target, 2'b00};
		//$display("targetPC  %x", targetPC);
		end
endmodule