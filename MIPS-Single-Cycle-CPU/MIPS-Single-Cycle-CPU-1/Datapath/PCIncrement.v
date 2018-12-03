module PCIncrement(currentPC, nextPC);
	input [31:0] currentPC;
	output [31:0] nextPC;
	
	assign nextPC = currentPC + 4;
endmodule