`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Define//Instruction_Define.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Define//ALUOP_Define.v"
module Control(Op, Funct, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input [5:0] Op;
	input [5:0] Funct;
	output reg RegDst;
	output reg Jump;
	output reg Branch;
	output reg MemRead;
	output reg MemtoReg;
	output reg [5:0] ALUOp;
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
		ALUOp = 6'b0;
		end
	
	always@(*)
		begin
		case(Op)
			`R_opcode,
			`jalr_opcode,
			`jr_opcode:
				begin
				case(Funct)
					`and_funct:
						begin
						RegDst = 1'b1;
						ALUSrc = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_AND;
						end
					`or_funct:
						begin
						RegDst = 1'b1;
						ALUSrc = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_OR;
						end
					`nor_funct:
						begin
						RegDst = 1'b1;
						ALUSrc = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_NOR;
						end
					`slt_funct:
						begin
						RegDst = 1'b1;
						ALUSrc = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_SLT;
						end
					`add_funct:
						begin
						RegDst = 1'b1;
						ALUSrc = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_ADD;
						end
					default:
						begin
						RegDst = 1'b0;
						ALUSrc = 1'b0;
						MemtoReg = 1'b0;
						RegWrite = 1'b0;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = 6'b0;
						end
				endcase
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
				ALUOp = `ALUOP_ADD;
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
				ALUOp = `ALUOP_ADD;
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
				ALUOp = `ALUOP_SUB;
				end
			`j_opcode:
				begin
				RegDst = 1'bx;
				ALUSrc = 1'bx;
				MemtoReg = 1'bx;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'bx;
				Jump = 1'b1;
				ALUOp = 6'bxx;
				end
			default:
				begin
				RegDst = 1'b0;
				ALUSrc = 1'b0;
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 6'b0;
				end
		endcase
		end
endmodule