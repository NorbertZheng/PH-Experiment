`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Instruction_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//ALUOP_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
module Control(clk, reset, Op, Funct, Rs, Rt, RegDst, RegWrite, ALUSrcA, ALUSrcB, ALUOp, ChangeType, MemRead, MemWrite, MemtoReg, StoreType, LoadType, Reverse, IMPC_Mux_select, syscall, eret, RI, CR_Read, CR_Write);
	input clk;
	input reset;
	input [5:0] Op;
	input [5:0] Funct;
	input [4:0] Rs;
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
	output reg IMPC_Mux_select;
	output reg syscall;
	output reg eret;
	output reg RI;
	output reg CR_Read;
	output reg CR_Write;
	
	initial
		begin
		RegDst <= 2'b0;
		RegWrite <= `DISABLE;
		ALUSrcA <= 2'b0;
		ALUSrcB <= 3'b0;
		ALUOp <= 6'b0;
		ChangeType <= 2'b0;
		MemRead <= `DISABLE;
		MemWrite <= `DISABLE;
		MemtoReg <= 2'b0;
		StoreType <= 2'b0;
		LoadType <= 3'b0;
		Reverse <= `DISABLE;
		IMPC_Mux_select <= `DISABLE;
		syscall <= `DISABLE;
		eret <= `DISABLE;
		RI <= `DISABLE;		// Reserved Instruction 异常
		CR_Read <= `DISABLE;
		CR_Write <= `DISABLE;
		end
		
	always@(posedge clk or negedge reset)		// 一定要有这个异步reset，否则初始Control信号都不对，导致CoPR0直接报错，产生RI异常，Flush整个IF_ID_REG
		begin
		if(!reset)
			begin
			RegDst <= 2'b0;
			RegWrite <= `DISABLE;
			ALUSrcA <= 2'b0;
			ALUSrcB <= 3'b0;
			ALUOp <= 6'b0;
			ChangeType <= 2'b0;
			MemRead <= `DISABLE;
			MemWrite <= `DISABLE;
			MemtoReg <= 2'b0;
			StoreType <= 2'b0;
			LoadType <= 3'b0;
			Reverse <= `DISABLE;
			IMPC_Mux_select <= `DISABLE;
			syscall <= `DISABLE;
			eret <= `DISABLE;
			RI <= `DISABLE;
			CR_Read <= `DISABLE;
			CR_Write <= `DISABLE;
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
							RegWrite <= `ENABLE;
							ChangeType <= `Jump;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b10;
							IMPC_Mux_select <= `DISABLE;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b101;
							ALUOp <= `ALUOP_ADD;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`jr_funct:
							begin
							RegWrite <= `DISABLE;
							ChangeType <= `Jump;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							IMPC_Mux_select <= `DISABLE;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b101;
							ALUOp <= `ALUOP_ADD;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`add_funct:
							begin
							ALUOp <= `ALUOP_ADD;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`addu_funct:
							begin
							ALUOp <= `ALUOP_ADDU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`sub_funct:
							begin
							ALUOp <= `ALUOP_SUB;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`subu_funct:
							begin
							ALUOp <= `ALUOP_SUBU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`sll_funct:
							begin
							ALUOp <= `ALUOP_SLL;
							ALUSrcA <= 2'b10;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`sllv_funct:
							begin
							ALUOp <= `ALUOP_SLLV;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`sra_funct:
							begin
							ALUOp <= `ALUOP_SRA;
							ALUSrcA <= 2'b10;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`srav_funct:
							begin
							ALUOp <= `ALUOP_SRAV;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`srl_funct:
							begin
							ALUOp <= `ALUOP_SRL;
							ALUSrcA <= 2'b10;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`srlv_funct:
							begin
							ALUOp <= `ALUOP_SRLV;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`and_funct:
							begin
							ALUOp <= `ALUOP_AND;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`or_funct:
							begin
							ALUOp <= `ALUOP_OR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`xor_funct:
							begin
							ALUOp <= `ALUOP_XOR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`nor_funct:
							begin
							ALUOp <= `ALUOP_NOR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`slt_funct:
							begin
							ALUOp <= `ALUOP_SLT;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`sltu_funct:
							begin
							ALUOp <= `ALUOP_SLTU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b000;
							RegDst <= 2'b01;
							RegWrite <= `ENABLE;
							ChangeType <= `Sequence;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b00;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `DISABLE;
							RI <= `DISABLE;
							end
						`syscall_funct:		// syscall 特权指令( 可能会导致特权级别的转化 )
							begin
							RegDst <= 2'b0;
							RegWrite <= `DISABLE;
							ALUSrcA <= 2'b0;
							ALUSrcB <= 3'b0;
							ALUOp <= 6'b0;
							ChangeType <= 2'b0;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b0;
							StoreType <= 2'b0;
							LoadType <= 3'b0;
							Reverse <= `DISABLE;
							IMPC_Mux_select <= `DISABLE;
							syscall <= `ENABLE;
							RI <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							RegDst <= 2'b0;
							RegWrite <= `DISABLE;
							ALUSrcA <= 2'b0;
							ALUSrcB <= 3'b0;
							ALUOp <= 6'b0;
							ChangeType <= 2'b0;
							MemRead <= `DISABLE;
							MemWrite <= `DISABLE;
							MemtoReg <= 2'b0;
							StoreType <= 2'b0;
							LoadType <= 3'b0;
							Reverse <= `DISABLE;
							IMPC_Mux_select <= `DISABLE;
							RI <= `ENABLE;
							$display("Unknown R_type Instruction!");
							end
					endcase
					eret <= `DISABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
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
					RegWrite <= `ENABLE;
					ChangeType <= `Sequence;
					MemRead <= `DISABLE;
					MemWrite <= `DISABLE;
					MemtoReg <= 2'b00;
					IMPC_Mux_select <= `DISABLE;
					syscall <= `DISABLE;
					eret <= `DISABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
					case(Op)
						`addi_opcode:
							begin
							ALUOp <= `ALUOP_ADD;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b010;
							RI <= `DISABLE;
							end
						`addiu_opcode:
							begin
							ALUOp <= `ALUOP_ADDU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b010;
							RI <= `DISABLE;
							end
						`andi_opcode:
							begin
							ALUOp <= `ALUOP_AND;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							RI <= `DISABLE;
							end
						`ori_opcode:
							begin
							ALUOp <= `ALUOP_OR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							RI <= `DISABLE;
							end
						`xori_opcode:
							begin
							ALUOp <= `ALUOP_XOR;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							RI <= `DISABLE;
							end
						`lui_opcode:
							begin
							ALUOp <= `ALUOP_LUI;
							ALUSrcB <= 3'b100;
							RI <= `DISABLE;
							end
						`slti_opcode:
							begin
							ALUOp <= `ALUOP_SLT;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b010;
							RI <= `DISABLE;
							end
						`sltiu_opcode:
							begin
							ALUOp <= `ALUOP_SLTU;
							ALUSrcA <= 2'b01;
							ALUSrcB <= 3'b100;
							RI <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							RI <= `ENABLE;
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
					RegWrite <= `ENABLE;
					ALUSrcA <= 2'b01;
					ALUSrcB <= 3'b010;
					ALUOp <= `ALUOP_ADD;
					ChangeType <= 2'b0;
					MemRead <= `ENABLE;
					MemWrite <= `DISABLE;
					MemtoReg <= 2'b01;
					IMPC_Mux_select <= `DISABLE;
					syscall <= `DISABLE;
					eret <= `DISABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
					case(Op)
						`lb_opcode:
							begin 
							LoadType <= `LoadByte;
							RI <= `DISABLE;
							end
						`lbu_opcode:
							begin 
							LoadType <= `LoadByteU;
							RI <= `DISABLE;
							end
						`lh_opcode:
							begin 
							LoadType <= `LoadHalfWord;
							RI <= `DISABLE;
							end
						`lhu_opcode:
							begin 
							LoadType <= `LoadHalfWordU;
							RI <= `DISABLE;
							end
						`lw_opcode:
							begin 
							LoadType <= `LoadWord;
							RI <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							RI <= `ENABLE;
							end
					endcase
					end
				`sb_opcode,
				`sh_opcode,
				`sw_opcode:
					begin
					RegWrite <= `DISABLE;
					ALUSrcA <= 2'b01;
					ALUSrcB <= 3'b010;
					ALUOp <= `ALUOP_ADD;
					ChangeType <= 2'b0;
					MemRead <= `DISABLE;
					MemWrite <= `ENABLE;
					IMPC_Mux_select <= `DISABLE;
					syscall <= `DISABLE;
					eret <= `DISABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
					case(Op)	
						`sb_opcode:
							begin
							StoreType <= `StoreByte;
							RI <= `DISABLE;
							end
						`sh_opcode:
							begin
							StoreType <= `StoreHalfWord;
							RI <= `DISABLE;
							end
						`sw_opcode:
							begin
							StoreType <= `StoreWord;
							RI <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							RI <= `ENABLE;
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
					RegWrite <= `DISABLE;
					ALUSrcA <= 2'b01;
					ChangeType <= `Branch;
					MemRead <= `DISABLE;
					MemWrite <= `DISABLE;
					IMPC_Mux_select <= `ENABLE;
					syscall <= `DISABLE;
					eret <= `DISABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
					case(Op)
						`beq_opcode:
							begin
							ALUSrcB <= 3'b000;
							ALUOp <= `ALUOP_SUB;
							Reverse <= `DISABLE;
							RI <= `DISABLE;
							end
						`bltz_opcode,
						`bgez_opcode:
							begin
							case(Rt)
								5'b1:
									begin
									ALUSrcB <= 3'b101;
									ALUOp <= `ALUOP_SLT;
									Reverse <= `DISABLE;
									RI <= `DISABLE;
									end
								5'b0:
									begin
									ALUSrcB <= 3'b101;
									ALUOp <= `ALUOP_SLT;
									Reverse <= `ENABLE;
									RI <= `DISABLE;
									end
								default:		// Reserved Instruction 异常
									begin
									ALUOp <= `ALUOP_NOP;
									Reverse <= `ENABLE;
									RI <= `ENABLE;
									end
							endcase
							end
						`bgtz_opcode:
							begin
							ALUSrcB <= 3'b101;
							ALUOp <= `ALUOP_SGT;
							Reverse <= `ENABLE;
							RI <= `DISABLE;
							end
						`blez_opcode:
							begin
							ALUSrcB <= 3'b101;
							ALUOp <= `ALUOP_SGT;
							Reverse <= `DISABLE;
							RI <= `DISABLE;
							end
						`bne_opcode:
							begin
							ALUSrcB <= 3'b000;
							ALUOp <= `ALUOP_SUB;
							Reverse <= `ENABLE;
							RI <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							ALUOp <= `ALUOP_NOP;
							Reverse <= `ENABLE;
							RI <= `ENABLE;
							end
					endcase
					end
				`j_opcode,
				`jal_opcode:
					begin
					ChangeType <= `Jump;
					MemRead <= `DISABLE;
					IMPC_Mux_select <= `DISABLE;
					ALUSrcA <= 2'b11;
					ALUSrcB <= 3'b110;
					ALUOp <= `ALUOP_JUMP;
					syscall <= `DISABLE;
					eret <= `DISABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
					case(Op)
						`j_opcode:
							begin
							RegWrite <= `DISABLE;
							MemWrite <= `DISABLE;
							RI <= `DISABLE;
							end
						`jal_opcode:
							begin
							RegDst <= 2'b10;							
							MemtoReg <= 2'b10;
							RegWrite <= `ENABLE;
							MemWrite <= `DISABLE;
							RI <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							RegWrite <= `DISABLE;
							MemWrite <= `DISABLE;
							RI <= `ENABLE;
							end
					endcase
					end
				`eret_opcode,
				`mtc0_opcode,
				`mfc0_opcode:
					begin
					ALUSrcA <= 2'b0;
					ALUSrcB <= 3'b0;
					ALUOp <= 6'b0;
					ChangeType <= 2'b0;
					MemRead <= `DISABLE;
					MemWrite <= `DISABLE;
					StoreType <= 2'b0;
					LoadType <= 3'b0;
					Reverse <= `DISABLE;
					IMPC_Mux_select <= `DISABLE;
					case(Rs)
						`eret_rs:
							begin
							if(Funct == `eret_funct)
								begin
								RegDst <= 2'b0;
								RegWrite <= `DISABLE;
								MemtoReg <= 2'b0;
								syscall <= `DISABLE;
								eret <= `ENABLE;
								RI <= `DISABLE;
								CR_Read <= `DISABLE;
								CR_Write <= `DISABLE;
								end
							else		// Reserved Instruction 异常
								begin
								RegDst <= 2'b0;
								RegWrite <= `DISABLE;
								MemtoReg <= 2'b0;
								syscall <= `DISABLE;
								eret <= `DISABLE;
								RI <= `ENABLE;
								CR_Read <= `DISABLE;
								CR_Write <= `DISABLE;
								end
							end
						`mtc0_rs:
							begin
							RegDst <= 2'b0;
							RegWrite <= `DISABLE;
							MemtoReg <= 2'b0;
							syscall <= `DISABLE;
							eret <= `DISABLE;
							RI <= `DISABLE;
							CR_Read <= `DISABLE;
							CR_Write <= `ENABLE;
							end
						`mfc0_rs:
							begin
							RegDst <= 2'b0;
							RegWrite <= `ENABLE;
							MemtoReg <= 2'b0;
							syscall <= `DISABLE;
							eret <= `DISABLE;
							RI <= `DISABLE;
							CR_Read <= `ENABLE;
							CR_Write <= `DISABLE;
							end
						default:		// Reserved Instruction 异常
							begin
							RegDst <= 2'b0;
							RegWrite <= `DISABLE;
							MemtoReg <= 2'b0;
							syscall <= `DISABLE;
							eret <= `DISABLE;
							RI <= `ENABLE;
							CR_Read <= `DISABLE;
							CR_Write <= `DISABLE;
							end
					endcase
					end
				default:		// Reserved Instruction 异常
					begin
					RegDst <= 2'b0;
					RegWrite <= `DISABLE;
					ALUSrcA <= 2'b0;
					ALUSrcB <= 3'b0;
					ALUOp <= 6'b0;
					ChangeType <= 2'b0;
					MemRead <= `DISABLE;
					MemWrite <= `DISABLE;
					MemtoReg <= 2'b0;
					StoreType <= 2'b0;
					LoadType <= 3'b0;
					Reverse <= `DISABLE;
					IMPC_Mux_select <= `DISABLE;
					syscall <= `DISABLE;
					eret <= `DISABLE;
					RI <= `ENABLE;
					CR_Read <= `DISABLE;
					CR_Write <= `DISABLE;
					end
			endcase
			end
		end
		
	always@(*)
		begin
		$display("RI = 0x%8X", RI);
		end
endmodule