module BranchPC(nextPC, extendedOffset, branchPC);
	input [31:0] nextPC;
	input [31:0] extendedOffset;
	output [31:0] branchPC;
	
	assign branchPC = nextPC + (extendedOffset << 2);
endmodule