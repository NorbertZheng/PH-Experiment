module BranchSignal(Branch, Zero, branchSignal);
	input Branch;
	input Zero;
	output reg branchSignal;
	
	always@(*)
		begin
		branchSignal = Branch & Zero;
		end
endmodule