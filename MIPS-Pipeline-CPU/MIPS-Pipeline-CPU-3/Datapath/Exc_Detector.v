`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//CoPR0_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
module Exc_Detector(RI, Ov, ExcCode);
	input RI;
	input Ov;
	output reg [1:0] ExcCode;
	
	always@(*)
		begin
		if(Ov)
			begin
			ExcCode = `Ov;
			end
		else if(RI)
			begin
			ExcCode = `Unimpl;
			end
		else
			begin
			ExcCode = `Int;
			end
		end
endmodule