module PC(clk, PCWr, PC_i, PC_o);
	input clk;
	input PCWr;
	input [31:0] PC_i;
	output reg [31:0] PC_o;
	
	initial
		begin
		PC_o <= 32'h0000_3000; 
		end
	
	always@(posedge clk)
		begin
		if(PCWr)
			begin
			PC_o <= PC_i;
			end
		end
endmodule