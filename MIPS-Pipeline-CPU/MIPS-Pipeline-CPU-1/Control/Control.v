`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-1//Define//Instruction_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-1//Define//ALUOP_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-1//Define//Fragment_Define.v"

module Control(clk, reset, Op, Funct, Rt, RegDst, RegWrite, ALUSrcA, ALUSrcB, ALUOp, ChangeType, MemRead, MemWrite, MemtoReg, StoreType, LoadType, Reverse);
	input clk;
	input reset;
	input [5:0] Op;
	input [5:0] Funct;
	input [4:0] Rt;
	output reg [1:0] RegDst;
	output reg RegWrite;
	output reg [1:0] ALUSrcA;
	output reg [2:0] ALUSrcB;
	output reg [5:0] ALUOp;
	output reg [1:0] ChangeType;
	output reg MemRead;
	output reg MemWrite;
	output reg [1:0] MemtoReg;
	output reg [1:0] StoreType;
	output reg [2:0] LoadType;
	output reg Reverse;
	
	initial
		begin
		RegDst <= 2'b0;
		RegWrite <= 1'b0;
		ALUSrcA <= 2'b0;
		ALUSrcB <= 3'b0;
		ALUOp <= 6'b0;
		ChangeType <= 2'b0;
		MemRead <= 1'b0;
		MemWrite <= 1'b0;
		MemtoReg <= 2'b0;
		StoreType <= 2'b0;
		LoadType <= 3'b0;
		Reverse <= 1'b0;
		end
		
	always@(posedge clk)
		begin
		if(!reset)
			begin
			RegDst <= 2'b0;
			RegWrite <= 1'b0;
			ALUSrcA <= 2'b0;
			ALUSrcB <= 3'b0;
			ALUOp <= 6'b0;
			ChangeType <= 2'b0;
			MemRead <= 1'b0;
			MemWrite <= 1'b0;
			MemtoReg <= 2'b0;
			StoreType <= 2'b0;
			LoadType <= 3'b0;
			Reverse <= 1'b0;
			end
		else
			begin
			case(Op)
				`R_opcode,
				`jalr_opcode,
				`jr_opcode:
					begin
					case(Funct)
						`jalr_funct:
							begin
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `JumpReg;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b10;
							end
						`jr_funct:
							begin
							RegWrite <= 1'b0;
							ChangeType <= `JumpReg;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							end
						`add_funct:
							begin
							ALUOp <= `ALUOP_ADD;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`addu_funct:
							begin
							ALUOp <= `ALUOP_ADDU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`sub_funct:
							begin
							ALUOp <= `ALUOP_SUB;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`subu_funct:
							begin
							ALUOp <= `ALUOP_SUBU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`sll_funct:
							begin
							ALUOp <= `ALUOP_SLL;
							ALUSrcA <= 2'b10;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`sllv_funct:
							begin
							ALUOp <= `ALUOP_SLLV;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`sra_funct:
							begin
							ALUOp <= `ALUOP_SRA;
							ALUSrcA <= 2'b10;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`srav_funct:
							begin
							ALUOp <= `ALUOP_SRAV;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`srl_funct:
							begin
							ALUOp <= `ALUOP_SRL;
							ALUSrcA <= 2'b10;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`srlv_funct:
							begin
							ALUOp <= `ALUOP_SRLV;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`and_funct:
							begin
							ALUOp <= `ALUOP_AND;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`or_funct:
							begin
							ALUOp <= `ALUOP_OR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`xor_funct:
							begin
							ALUOp <= `ALUOP_XOR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`nor_funct:
							begin
							ALUOp <= `ALUOP_NOR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`slt_funct:
							begin
							ALUOp <= `ALUOP_SLT;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						`sltu_funct:
							begin
							ALUOp <= `ALUOP_SLTU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= 1'b1;
							ChangeType <= `Sequence;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b00;
							end
						default:
							begin
							RegDst <= 2'b0;
							RegWrite <= 1'b0;
							ALUSrcA <= 2'b0;
							ALUSrcB <= 3'b0;
							ALUOp <= 6'b0;
							ChangeType <= 2'b0;
							MemRead <= 1'b0;
							MemWrite <= 1'b0;
							MemtoReg <= 2'b0;
							StoreType <= 2'b0;
							LoadType <= 3'b0;
							Reverse <= 1'b0;
							$display("Unknown R_type Instruction!");
							end
					endcase
					end
				`addi_opcode,
				`addiu_opcode,
				`andi_opcode,
				`ori_opcode,
				`xori_opcode,
				`lui_opcode,
				`slti_opcode,
				`sltiu_opcode:
					begin
					RegDst <= 2'b00;
					RegWrite <= 1'b1;
					ChangeType <= `Sequence;
					MemRead <= 1'b0;
					MemWrite <= 1'b0;
					MemtoReg <= 2'b00;
					case(Op)
						`addi_opcode:
							begin
							ALUOp <= `ALUOP_ADD;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b010;
							end
						`addiu_opcode:
							begin
							ALUOp <= `ALUOP_ADDU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b010;
							end
						`andi_opcode:
							begin
							ALUOp <= `ALUOP_AND;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							end
						`ori_opcode:
							begin
							ALUOp <= `ALUOP_OR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							end
						`xori_opcode:
							begin
							ALUOp <= `ALUOP_XOR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							end
						`lui_opcode:
							begin
							ALUOp <= `ALUOP_LUI;
							ALUSrcB <= 3'b100;
							end
						`slti_opcode:
							begin
							ALUOp <= `ALUOP_SLT;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b010;
							end
						`sltiu_opcode:
							begin
							ALUOp <= `ALUOP_SLTU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							end
					endcase
					end
				`lb_opcode,
				`lbu_opcode,
				`lh_opcode,
				`lhu_opcode,
				`lw_opcode:
					begin
					RegDst <= 2'b00;
					RegWrite <= 1'b1;
					ALUSrcA <= 2'b01;
					ALUSrcB <= 3'b010;
					ALUOp <= `ALUOP_ADD;
					ChangeType <= 2'b0;
					MemRead <= 1'b1;
					MemWrite <= 1'b0;
					MemtoReg <= 2'b01;
					case(Op)
						`lb_opcode:
							begin 
							LoadType <= `LoadByte;
							end
						`lbu_opcode:
							begin 
							LoadType <= `LoadByteU;
							end
						`lh_opcode:
							begin 
							LoadType <= `LoadHalfWord;
							end
						`lhu_opcode:
							begin 
							LoadType <= `LoadHalfWordU;
							end
						`lw_opcode:
							begin 
							LoadType <= `LoadWord;
							end
					endcase
					end
				`sb_opcode,
				`sh_opcode,
				`sw_opcode:
					begin
					RegWrite <= 1'b0;
					ALUSrcA <= 2'b01;
					ALUSrcB <= 3'b010;
					ALUOp <= `ALUOP_ADD;
					ChangeType <= 2'b0;
					MemRead <= 1'b0;
					MemWrite <= 1'b1;
					case(Op)	
						`sb_opcode:
							begin
							StoreType <= `StoreByte;
							end
						`sh_opcode:
							begin
							StoreType <= `StoreHalfWord;
							end
						`sw_opcode:
							begin
							StoreType <= `StoreWord;
							end
					endcase
					end
				`beq_opcode,
				`bltz_opcode,
				`bgez_opcode,
				`bgtz_opcode,
				`blez_opcode,
				`bne_opcode:
					begin
					RegWrite <= 1'b0;
					ALUSrcA <= 2'b01;
					ChangeType <= `Branch;
					MemRead <= 1'b0;
					MemWrite <= 1'b0;
					case(Op)
						`beq_opcode:
						begin
						ALUSrcB <= 3'b000;
						ALUOp <= `ALUOP_SUB;
						Reverse <= 1'b0;
						end
						`bltz_opcode,
						`bgez_opcode:
							begin
							case(Rt)
								5'b1:
									begin
									ALUSrcB <= 3'b101;
									ALUOp <= `ALUOP_SLT;
									Reverse <= 1'b0;
									end
								5'b0:
									begin
									ALUSrcB <= 3'b101;
									ALUOp <= `ALUOP_SLT;
									Reverse <= 1'b1;
									end
							endcase
							end
						`bgtz_opcode:
							begin
							ALUSrcB <= 3'b101;
							ALUOp <= `ALUOP_SGT;
							Reverse <= 1'b1;
							end
						`blez_opcode:
							begin
							ALUSrcB <= 3'b101;
							ALUOp <= `ALUOP_SGT;
							Reverse <= 1'b0;
							end
						`bne_opcode:
							begin
							ALUSrcB <= 3'b000;
							ALUOp <= `ALUOP_SUB;
							Reverse <= 1'b1;
							end
					endcase
					end
				`j_opcode,
				`jal_opcode:
					begin
					ChangeType <= `Jump;
					MemRead <= 1'b0;
					case(Op)
						`j_opcode:
							begin
							RegWrite <= 1'b0;
							MemWrite <= 1'b0;
							end
						`jal_opcode:
							begin
							RegDst <= 2'b10;							
							MemtoReg <= 2'b10;
							RegWrite <= 1'b1;
							MemWrite <= 1'b0;
							end
					endcase
					end
			endcase
			end
		end
endmodule