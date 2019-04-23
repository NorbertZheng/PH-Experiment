module PCIncrement(PC_o, PCplus4);
	input [31:0] PC_o;
	output reg [31:0] PCplus4;
	
	always@(*)
		begin
		PCplus4 = PC_o + 32'd4;
		end
endmodule