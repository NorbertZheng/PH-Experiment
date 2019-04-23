module PC(clk, reset, PC_i, PC_o);
	input clk;
	input reset;
	input [31:0] PC_i;
	output reg [31:0] PC_o;
	
	always@(posedge clk or negedge reset)
		begin
		if(!reset)
			begin
			PC_o <= 32'h0000_3000;
			end
		else
			begin
			PC_o <= PC_i;
			end
		end
endmodule