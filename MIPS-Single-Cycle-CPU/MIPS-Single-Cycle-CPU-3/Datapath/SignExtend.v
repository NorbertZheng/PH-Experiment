module SignExtend(offset, extendedOffset);
	input [15:0] offset;
	output reg [31:0] extendedOffset;
	
	initial
		begin
		extendedOffset = 32'b0;
		end
	
	always@(offset)
		begin
		extendedOffset= (offset[15] == 1'b1) ? {16'hFFFF, offset} : {16'b0, offset};
		end
endmodule