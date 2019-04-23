module PCIncrement(currentPC, nextPC);
	input [31:0] currentPC;
	output reg[31:0] nextPC;
	
	always@(*)
		begin
		nextPC = currentPC + 4;
		end
endmodule