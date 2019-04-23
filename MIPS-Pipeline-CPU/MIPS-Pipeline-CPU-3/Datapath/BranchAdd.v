module BranchAdd(PCplus4, signEXTOffset, branchPC);
	input [31:0] PCplus4;
	input [31:0] signEXTOffset;
	output reg [31:0] branchPC;
	
	always@(*)
		begin
		branchPC = PCplus4 + (signEXTOffset << 2);
		end
endmodule