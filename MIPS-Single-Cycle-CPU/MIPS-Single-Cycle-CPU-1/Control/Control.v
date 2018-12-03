`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-1//Define//instruction_def.v"
module Control(opcode, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input [5:0] opcode;
	output reg RegDst;
	output reg Jump;
	output reg Branch;
	output reg MemRead;
	output reg MemtoReg;
	output reg [1:0] ALUOp;
	output reg MemWrite;
	output reg ALUSrc;
	output reg RegWrite;
	
	initial
		begin
		RegDst = 1'b0;
		ALUSrc = 1'b0;
		MemtoReg = 1'b0;
		RegWrite = 1'b0;
		MemRead = 1'b0;
		MemWrite = 1'b0;
		Branch = 1'b0;
		Jump = 1'b0;
		ALUOp = 2'b00;
		end
	
	always@(*)
		begin
		case(opcode)
			`addu_opcode:
				begin
				RegDst = 1'b1;
				ALUSrc = 1'b0;
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 2'b10;
				end
			`subu_opcode:
				begin
				RegDst = 1'b1;
				ALUSrc = 1'b0;
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 2'b10;
				end
			`ori_opcode:
				begin
				RegDst = 1'b0;
				ALUSrc = 1'b1;
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 2'b01;
				end
			`lw_opcode:
				begin
				RegDst = 1'b0;
				ALUSrc = 1'b1;
				MemtoReg = 1'b1;
				RegWrite = 1'b1;
				MemRead = 1'b1;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 2'b00;
				end
			`sw_opcode:
				begin
				RegDst = 1'bx;
				ALUSrc = 1'b1;
				MemtoReg = 1'bx;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b1;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 2'b00;
				end
			`beq_opcode:
				begin
				RegDst = 1'bx;
				ALUSrc = 1'b0;
				MemtoReg = 1'bx;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b1;
				Jump = 1'b0;
				ALUOp = 2'b01;
				end
			`jal_opcode:
				begin
				RegDst = 1'bx;
				ALUSrc = 1'bx;
				MemtoReg = 1'bx;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'bx;
				Jump = 1'b1;
				ALUOp = 2'bxx;
				end
		endcase
		end
endmodule