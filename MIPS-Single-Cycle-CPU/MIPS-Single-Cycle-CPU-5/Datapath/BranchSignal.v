module BranchSignal(Branch, Reverse, Zero, branchSignal);
	input Branch;
	input Reverse;
	input Zero;
	output reg branchSignal;
	
	always@(*)
		begin
		if(Branch)
			begin
			branchSignal = Reverse ? ~Zero : Zero;
			end
		else
			begin
			branchSignal = 1'b0;
			end
		end
endmodule