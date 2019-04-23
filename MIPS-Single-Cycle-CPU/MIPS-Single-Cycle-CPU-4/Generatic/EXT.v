`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-4//Define//Fragment_Define.v"

module EXT(EXTOp, Imm16, Imm32);
	input [1:0] EXTOp;
	input [15:0] Imm16;
	output reg [31:0] Imm32;
	
	always@(*)
		begin
		case(EXTOp)
			`LogicEXT:
				begin
				Imm32 = {16'b0, Imm16};
				end
			`ArithmeticEXT:
				begin
				Imm32 = (Imm16[15] == 1) ? {16'hFFFF, Imm16} : {16'b0, Imm16};
				end
			`LUIEXT:
				begin
				Imm32 = {Imm16, 16'b0};
				end
		endcase
		end
endmodule