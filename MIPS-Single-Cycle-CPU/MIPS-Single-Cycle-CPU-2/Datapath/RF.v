module RF(clk, we, ra0_i, ra1_i, wa_i, wd_i, rd0_o, rd1_o);
	input we;
	input clk;
	input [4:0] ra0_i, ra1_i, wa_i;
	input [31:0] wd_i;
	output [31:0] rd0_o, rd1_o;
	
	integer i;
	reg [31:0] Registers[31:0];
	
	initial
		begin
		for(i = 0;i < 32;i = i + 1)
			begin
			Registers[i] <= 0;
			end
		end
	
	assign rd0_o = Registers[ra0_i];
	assign rd1_o = Registers[ra1_i];
	
	always@(negedge clk)
		begin
		if(we)
			begin
			Registers[wa_i] <= (wa_i != 5'b0) ? wd_i : 32'b0;
			$display("Registers  %x  %x", wa_i, wd_i);
			end
		end
endmodule