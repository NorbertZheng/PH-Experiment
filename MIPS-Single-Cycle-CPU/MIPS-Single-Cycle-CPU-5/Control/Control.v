`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-5//Define//Instruction_Define.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-5//Define//ALUOP_Define.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-5//Define//Fragment_Define.v"
module Control(Op, Funct, MIO_ready, RegDst, Jump, JumpReg, Branch, Reverse, MemtoReg, ALUOp, EXTOp, MemWrite, ALUSrcA, ALUSrcB, RegWrite, CPU_MIO);
	input[5:0] Op;
	input[5:0] Funct;
	input MIO_ready;
	output reg[1:0] RegDst;
	output reg Jump;
	output reg JumpReg;
	output reg Branch;
	output reg Reverse;
	output reg[1:0] MemtoReg;
	output reg[5:0] ALUOp;
	output reg[1:0] EXTOp;
	output reg MemWrite;
	output reg ALUSrcA;
	output reg ALUSrcB;
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
					`jalr_funct:
						begin
						RegDst = 2'b10;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b10;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b1;
						JumpReg = 1'b1;
						ALUOp = 6'b0;
						EXTOp = `LogicEXT;
						end
					`jr_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b1;
						JumpReg = 1'b1;
						ALUOp = 6'b0;
						EXTOp = `LogicEXT;
						end
					`and_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_AND;
						EXTOp = `LogicEXT;
						end
					`or_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_OR;
						EXTOp = `LogicEXT;
						end
					`nor_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_NOR;
						EXTOp = `LogicEXT;
						end
					`slt_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_SLT;
						EXTOp = `LogicEXT;
						end
					`add_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_ADD;
						EXTOp = `LogicEXT;
						end
					`sub_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_SUB;
						EXTOp = `LogicEXT;
						end
					`srl_funct:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b1;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b1;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = `ALUOP_SRL;
						EXTOp = `LogicEXT;
						end
					default:
						begin
						RegDst = 2'b00;
						ALUSrcA = 1'b0;
						ALUSrcB = 1'b0;
						MemtoReg = 2'b00;
						RegWrite = 1'b0;
						MemWrite = 1'b0;
						Branch = 1'b0;
						Reverse = 1'b0;
						Jump = 1'b0;
						JumpReg = 1'b0;
						ALUOp = 6'b0;
						EXTOp = `LogicEXT;
						end
				endcase
				end
			`addi_opcode,
			`andi_opcode,
			`ori_opcode,
			`lui_opcode,
			`slti_opcode:
				begin
				RegDst = 2'b01;
				ALUSrcA = 1'b0;
				ALUSrcB = 1'b1;
				MemtoReg = 2'b00;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Reverse = 1'b0;
				Jump = 1'b0;
				JumpReg = 1'b0;
				case(Op)
					`addi_opcode:
						begin
						ALUOp = `ALUOP_ADD;
						EXTOp = `ArithmeticEXT;
						end
					`andi_opcode:
						begin
						ALUOp = `ALUOP_AND;
						EXTOp = `LogicEXT;
						end
					`ori_opcode:
						begin
						ALUOp = `ALUOP_OR;
						EXTOp = `LogicEXT;
						end
					`lui_opcode:
						begin
						ALUOp = `ALUOP_LUI;
						EXTOp = `LogicEXT;
						end
					`slti_opcode:
						begin
						ALUOp = `ALUOP_SLT;
						EXTOp = `ArithmeticEXT;
						end
					default:
						begin
						ALUOp = 6'b0;
						EXTOp = `LogicEXT;
						end
				endcase
				end
			`lw_opcode:
				begin
				RegDst = 2'b01;
				ALUSrcA = 1'b0;
				ALUSrcB = 1'b1;
				MemtoReg = 2'b01;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Reverse = 1'b0;
				Jump = 1'b0;
				JumpReg = 1'b0;
				ALUOp = `ALUOP_ADD;
				EXTOp = `ArithmeticEXT;
				end
			`sw_opcode:
				begin
				RegDst = 2'b00;
				ALUSrcA = 1'b0;
				ALUSrcB = 1'b1;
				MemtoReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b1;
				Branch = 1'b0;
				Reverse = 1'b0;
				Jump = 1'b0;
				JumpReg = 1'b0;
				ALUOp = `ALUOP_ADD;
				EXTOp = `ArithmeticEXT;
				end
			`beq_opcode,
			`bne_opcode:
				begin
				RegDst = 2'b00;
				ALUSrcA = 1'b0;
				ALUSrcB = 1'b0;
				MemtoReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b1;
				Jump = 1'b0;
				JumpReg = 1'b0;
				case(Op)
					`beq_opcode:
						begin
						Reverse = 1'b0;
						ALUOp = `ALUOP_SUB;
						EXTOp = `ArithmeticEXT;
						end
					`bne_opcode:
						begin
						Reverse = 1'b1;
						ALUOp = `ALUOP_SUB;
						EXTOp = `ArithmeticEXT;
						end
					default:
						begin
						Reverse = 1'b0;
						ALUOp = 6'b0;
						EXTOp = `LogicEXT;
						end
				endcase
				end
			`j_opcode,
			`jal_opcode:
				begin
				ALUSrcA = 1'b0;
				ALUSrcB = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b1;
				JumpReg = 1'b0;
				ALUOp = 6'b0;
				EXTOp = `LogicEXT;
				case(Op)
					`j_opcode:
						begin
						RegDst = 2'b00;
						MemtoReg = 2'b00;
						RegWrite = 1'b0;
						end
					`jal_opcode:
						begin
						RegDst = 2'b10;
						MemtoReg = 2'b10;
						RegWrite = 1'b1;
						end
					default:
						begin
						RegDst = 2'b00;
						MemtoReg = 2'b00;
						RegWrite = 1'b0;
						end
				endcase
				end
			default:
				begin
				RegDst = 2'b00;
				ALUSrcA = 1'b0;
				ALUSrcB = 1'b0;
				MemtoReg = 2'b00;
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				JumpReg = 1'b0;
				ALUOp = 6'b0;
				EXTOp = `LogicEXT;
				end
		endcase
		end
endmodule