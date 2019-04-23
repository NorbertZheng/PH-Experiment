`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-4//Define//Instruction_Define.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-4//Define//ALUOP_Define.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-4//Define//Fragment_Define.v"
module Control(Op, Funct, MIO_ready, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, EXTOp, MemWrite, ALUSrc, RegWrite, CPU_MIO);
	input[5:0] Op;
	input[5:0] Funct;
	input MIO_ready;
	output reg[1:0] RegDst;
	output reg Jump;
	output reg Branch;
	output reg MemRead;
	output reg[1:0] MemtoReg;
	output reg[5:0] ALUOp;
	output reg[1:0] EXTOp;
	output reg MemWrite;
	output reg ALUSrc;
	output reg RegWrite;
	output reg CPU_MIO;
	
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
						RegDst = 2'b00;
						ALUSrc = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_AND;
						EXTOp = `LogicEXT;
						end
					`or_funct:
						begin
						RegDst = 2'b00;
						ALUSrc = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_OR;
						EXTOp = `LogicEXT;
						end
					`nor_funct:
						begin
						RegDst = 2'b00;
						ALUSrc = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_NOR;
						EXTOp = `LogicEXT;
						end
					`slt_funct:
						begin
						RegDst = 2'b00;
						ALUSrc = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_SLT;
						EXTOp = `LogicEXT;
						end
					`add_funct:
						begin
						RegDst = 2'b00;
						ALUSrc = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = `ALUOP_ADD;
						EXTOp = `LogicEXT;
						end
					default:
						begin
						RegDst = 2'b00;
						ALUSrc = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b0;
						MemRead = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Jump = 1'b0;
						ALUOp = 6'b0;
						EXTOp = `LogicEXT;
						end
				endcase
				end
			`lw_opcode:
				begin
				RegDst = 2'b01;
				ALUSrc = 1'b1;
				MemtoReg = 2'b01;
				RegWrite = 1'b1;
				MemRead = 1'b1;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = `ALUOP_ADD;
				EXTOp = `ArithmeticEXT;
				end
			`sw_opcode:
				begin
				RegDst = 2'bxx;
				ALUSrc = 1'b1;
				MemtoReg = 2'bxx;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b1;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = `ALUOP_ADD;
				EXTOp = `ArithmeticEXT;
				end
			`beq_opcode:
				begin
				RegDst = 2'bxx;
				ALUSrc = 1'b0;
				MemtoReg = 2'bxx;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b1;
				Jump = 1'b0;
				ALUOp = `ALUOP_SUB;
				EXTOp = `ArithmeticEXT;
				end
			`j_opcode:
				begin
				RegDst = 2'bxx;
				ALUSrc = 1'bx;
				MemtoReg = 2'bxx;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'bx;
				Jump = 1'b1;
				ALUOp = 6'bxx;
				EXTOp = `LogicEXT;
				end
			default:
				begin
				RegDst = 2'b00;
				ALUSrc = 1'b0;
				MemtoReg = 2'b00;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				ALUOp = 6'b0;
				EXTOp = `LogicEXT;
				end
		endcase
		end
endmodule