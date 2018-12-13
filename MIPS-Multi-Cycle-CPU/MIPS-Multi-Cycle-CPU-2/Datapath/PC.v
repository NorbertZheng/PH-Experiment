module PC(clk, write_next, PC_i, PC_o);
	input clk;
	input write_next;
	input [31:0] PC_i;
	output reg [31:0] PC_o;
	
	initial
		begin
		PC_o = 32'h0000_3000;
		end
	
	always@(negedge clk)
		begin
		if(write_next)
			begin
			PC_o <= PC_i;
			end
		else
			begin
			PC_o <= PC_o;
			end
		end
endmodule