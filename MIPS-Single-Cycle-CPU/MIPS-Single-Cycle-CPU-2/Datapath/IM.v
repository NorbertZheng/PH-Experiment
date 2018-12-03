module IM(addr_i, dout_o);
	parameter initAddress = 32'h0000_0c00;
	
	input [13:2] addr_i;
	output [31:0] dout_o;
	
	integer i;
	reg [31:0] InstructionMemory[1023:0];
	
	initial
		begin
		for(i = 0;i < 1024;i = i + 1)
			begin
			InstructionMemory[i] = 32'b0;
			end
		end

	assign dout_o = InstructionMemory[addr_i - initAddress];
endmodule