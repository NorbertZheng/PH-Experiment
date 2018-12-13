`include "C://Users//Think//Desktop//MIPS-Multi-Cycle-CPU-2//Define//Instruction_Define.v"
`include "C://Users//Think//Desktop//MIPS-Multi-Cycle-CPU-2//Define//ALUOP_Define.v"
`include "C://Users//Think//Desktop//MIPS-Multi-Cycle-CPU-2//Define//Fragment_Define.v"

module Control(clk, reset, Op, Funct, Rt, RegDst, RegWrite, ALUSrcA, ALUSrcB, ALUOp, PCSource, PCWriteCond, PCWrite, MemWrite, MemtoReg, IRWrite, StoreType, LoadType, Reverse);
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
	output reg [2:0] PCSource;
	output reg PCWriteCond;
	output reg PCWrite;
	output reg MemWrite;
	output reg [1:0] MemtoReg;
	output reg IRWrite;
	output reg [1:0] StoreType;
	output reg [2:0] LoadType;
	output reg Reverse;
	
	reg [9:0] state;
	
	parameter	IDLE = 						10'b00_0000_0000,
				Instruction_fetch = 		10'b00_0000_0001,
				Instruction_decode = 		10'b00_0000_0010,
				Memory_address_compution =	10'b00_0000_0100,
				LW_Memory_access = 			10'b00_0000_1000,
				Write_back = 				10'b00_0001_0000,
				SW_Memory_access = 			10'b00_0010_0000,
				Execution = 				10'b00_0100_0000,
				R_type_completion = 		10'b00_1000_0000,
				Branch_completion = 		10'b01_0000_0000,
				Jump_completion = 			10'b10_0000_0000;
	
	initial
		begin
		state <= IDLE;
		RegDst <= 2'b0;
		RegWrite <= 1'b0;
		ALUSrcA <= 2'b0;
		ALUSrcB <= 3'b0;
		ALUOp <= 6'b0;
		PCSource <= 3'b0;
		PCWriteCond <= 1'b0;
		PCWrite <= 1'b0;
		MemWrite <= 1'b0;
		MemtoReg <= 2'b0;
		IRWrite <= 1'b0;
		StoreType <= 2'b0;
		LoadType <= 3'b0;
		Reverse <= 1'b0;
		end
		
	always@(posedge clk)
		begin
		$display("Control_state %x", state);
		case(state)
			IDLE:
				begin
				state <= Instruction_fetch;
				end
			Instruction_fetch:
				begin
				ALUSrcA <= 2'b00;
				IRWrite <= 1'b1;
				ALUSrcB <= 3'b001;
				ALUOp <= `ALUOP_ADD;
				PCWrite <= 1'b1;
				PCSource <= 3'b000;
				RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				MemWrite <= 1'b0;
				state <= Instruction_decode;
				end
			Instruction_decode:
				begin
				ALUSrcA <= 2'b00;
				ALUSrcB <= 3'b011;
				ALUOp <= `ALUOP_ADD;
				RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				case(Op)
					`lb_opcode,
					`lbu_opcode,
					`lh_opcode,
					`lhu_opcode,
					`lw_opcode,
					`sb_opcode,
					`sh_opcode,
					`sw_opcode:
						begin
						state <= Memory_address_compution;
						end
					`R_opcode,
					`jalr_opcode,
					`jr_opcode:
						begin
						case(Funct)
							`jalr_funct,
							`jr_funct:
								begin
								state <= Jump_completion;
								end
							default:
								begin
								state <= Execution;
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
						state <= Execution;
						end
					`beq_opcode,
					`bgez_opcode,
					`bgtz_opcode,
					`blez_opcode,
					`bltz_opcode,
					`bne_opcode:
						begin
						state <= Branch_completion;
						end
					`j_opcode,
					`jal_opcode:
						begin
						state <= Jump_completion;
						end
					default:
						begin
						state <= IDLE;
						end
				endcase
				end
			Memory_address_compution:
				begin
				ALUSrcA <= 2'b01;
				ALUSrcB <= 3'b010;
				ALUOp <= `ALUOP_ADD;
				RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				case(Op)
					`lb_opcode,
					`lbu_opcode,
					`lh_opcode,
					`lhu_opcode,
					`lw_opcode:
						begin
						state <= LW_Memory_access;
						end
					`sb_opcode,
					`sh_opcode,
					`sw_opcode:
						begin
						state <= SW_Memory_access;
						end
					default:
						begin
						state <= IDLE;
						end
				endcase
				end
			LW_Memory_access:
				begin
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
				RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				state <= Write_back;
				end
			Write_back:
				begin
				RegDst <= 2'b00;
				RegWrite <= 1'b1;
				MemtoReg <= 2'b01;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				state <= Instruction_fetch;
				end
			SW_Memory_access:
				begin
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
				RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				IRWrite <= 1'b0;
				state <= Instruction_fetch;
				end
			Execution:
				begin
				case(Op)
					`R_opcode:
						case(Funct)
							`add_funct:
								begin
								ALUOp <= `ALUOP_ADD;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`addu_funct:
								begin
								ALUOp <= `ALUOP_ADDU;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`sub_funct:
								begin
								ALUOp <= `ALUOP_SUB;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`subu_funct:
								begin
								ALUOp <= `ALUOP_SUBU;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`sll_funct:
								begin
								ALUOp <= `ALUOP_SLL;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								end
							`sllv_funct:
								begin
								ALUOp <= `ALUOP_SLLV;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`sra_funct:
								begin
								ALUOp <= `ALUOP_SRA;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								end
							`srav_funct:
								begin
								ALUOp <= `ALUOP_SRAV;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`srl_funct:
								begin
								ALUOp <= `ALUOP_SRL;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								end
							`srlv_funct:
								begin
								ALUOp <= `ALUOP_SRLV;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`and_funct:
								begin
								ALUOp <= `ALUOP_AND;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`or_funct:
								begin
								ALUOp <= `ALUOP_OR;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`xor_funct:
								begin
								ALUOp <= `ALUOP_XOR;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`nor_funct:
								begin
								ALUOp <= `ALUOP_NOR;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`slt_funct:
								begin
								ALUOp <= `ALUOP_SLT;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							`sltu_funct:
								begin
								ALUOp <= `ALUOP_SLTU;
								ALUSrcA <= 2'b01;
								ALUSrcB <= 3'b000;
								end
							default:
								begin
								ALUOp <= `ALUOP_NOP;
								end
						endcase
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
					default:
						begin
						ALUOp <= `ALUOP_NOP;
						end
				endcase
				RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				state <= R_type_completion;
				end
			R_type_completion:
				begin
				case(Op)
					`R_opcode:
						begin
						RegDst <= 2'b01;
						end
					`addi_opcode:
						begin
						RegDst <= 2'b00;
						end
					`addiu_opcode:
						begin
						RegDst <= 2'b00;
						end
					`andi_opcode:
						begin
						RegDst <= 2'b00;
						end
					`ori_opcode:
						begin
						RegDst <= 2'b00;
						end
					`xori_opcode:
						begin
						RegDst <= 2'b00;
						end
					`lui_opcode:
						begin
						RegDst <= 2'b00;
						end
					`slti_opcode:
						begin
						RegDst <= 2'b00;
						end
					`sltiu_opcode:
						begin
						RegDst <= 2'b00;
						end
				endcase
				RegWrite <= 1'b1;
				MemtoReg <= 2'b00;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				state <= Instruction_fetch;
				end
			Branch_completion:
				begin
				ALUSrcA <= 2'b01;
				PCWriteCond <= 1'b1;
				PCSource <= 3'b001;
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
				RegWrite <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				state <= Instruction_fetch;
				end
			Jump_completion:
				begin
				PCWrite <= 1'b1;
				case(Op)
					`j_opcode:
						begin
						PCSource <= 3'b010;
						RegWrite <= 1'b0;
						PCWriteCond <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						end
					`jal_opcode:
						begin
						PCSource <= 3'b010;
						RegDst <= 2'b10;
						MemtoReg <= 2'b10;
						RegWrite <= 1'b1;
						PCWriteCond <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						end
					`jalr_opcode,
					`jr_opcode:
						begin
						case(Funct)
							`jalr_funct:
								begin
								PCSource <= 3'b100;
								RegDst <= 2'b01;
								MemtoReg <= 2'b10;
								RegWrite <= 1'b1;
								PCWriteCond <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								end
							`jr_funct:
								begin
								PCSource <= 3'b100;
								RegWrite <= 1'b0;
								PCWriteCond <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								end
						endcase
						end
				endcase
				state <= Instruction_fetch;
				end
			default:
				begin
				state <= IDLE;
				end
		endcase
		end
endmodule