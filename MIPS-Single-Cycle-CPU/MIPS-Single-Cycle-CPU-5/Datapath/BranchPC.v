module BranchPC(nextPC, extendedOffset, branchPC);
	input [31:0] nextPC;
	input [31:0] extendedOffset;
	output reg[31:0] branchPC;
	
	always@(*)
		begin
		branchPC = nextPC + (extendedOffset << 2);
		end
endmodule