`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU//Define//instruction_def.v"
module ALUControl(ALUOp, opcode, funct, ALU_control);
	input [1:0] ALUOp;
	input [5:0] opcode;
	input [5:0] funct;
	output reg [3:0] ALU_control;
	
	initial
		begin
		ALU_control = 4'b0000;
		end
	
	always@(*)
		begin
		case(ALUOp)
			2'b00:
				begin
				ALU_control = 4'b0010;
				end
			2'b01:
				begin
				case(opcode)
					`ori_opcode:
						begin
						ALU_control = 4'b0001;
						end
					`beq_opcode:
						begin
						ALU_control = 4'b0110;
						end
				endcase
				end
			2'b10:
				begin
				case(funct)
					`addu_funct:
						begin
						ALU_control = 4'b0010;
						end
					`subu_funct:
						begin
						ALU_control = 4'b0110;
						end
				endcase
				end
		endcase
		end
endmodule