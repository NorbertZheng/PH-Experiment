`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//ALU.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//BE.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//Branch_Or_Jump.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//BranchAdd.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//dm.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//im.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//LoadBE.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//PC.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//PCIncrement.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Datapath//Registers.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Generatic//EXT.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Generatic//flopr.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Generatic//Mux.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Control//Control.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Control//Forwarding_unit.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Control//Hazard_detection_unit.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Define//Fragment_Define.v"

module Mips(clk, rst);
	input clk;
	input rst;
	
	//PC
	wire [31:0] PC_i;
	wire [31:0] PC_o;
	wire PC_Write;
	PC m_PC(.clk(clk), .write_next(PC_Write), .PC_i(PC_i), .PC_o(PC_o));
	
	//IMPC_Mux
	wire [31:0] branchPC;
	wire IMPC_Mux_select;
	wire [31:0] IMPC_Mux_data;
	Mux #(32, 1) m_IMPC_Mux(.s(IMPC_Mux_select), .y(IMPC_Mux_data), .d0(PC_o), .d1(branchPC), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//Instruction_Memory
	wire [31:0] Instruction;
	im_4k m_Instruction_Memory(.addr(IMPC_Mux_data[11:2]), .dout(Instruction));
	
	//PCIncrement
	wire [31:0] PCplus4;
	PCIncrement m_PCIncrement(.PC_o(IMPC_Mux_data), .PCplus4(PCplus4));
	
	//PC_Mux
	wire [1:0] PC_Mux_select;
	wire [31:0] ID_EX_PCplus4_data;
	wire [31:0] ALU_result;
	Mux #(32, 2) m_PC_Mux(.s(PC_Mux_select), .y(PC_i), .d0(PCplus4), .d1(ID_EX_PCplus4_data), .d2(ALU_result), .d3(32'd0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	/****************************************/
	/*                                      */
	/*                IF/ID                 */
	/*                                      */
	/****************************************/
	//IF_ID_PCplus4_Mux
	wire IF_ID_Mux_select;
	wire [31:0] IF_ID_PCplus4_Mux_data;
	Mux #(32, 1) m_IF_ID_PCplus4_Mux(.s(IF_ID_Mux_select), .y(IF_ID_PCplus4_Mux_data), .d0(PCplus4), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//IF_ID_PCplus4
	wire IF_ID_Write;
	wire [31:0] IF_ID_PCplus4_data;
	flopr #(32) m_IF_ID_PCplus4(.clk(clk), .update(IF_ID_Write), .d(IF_ID_PCplus4_Mux_data), .q(IF_ID_PCplus4_data));
	
	//IF_ID_Instruction_Mux
	wire [31:0] IF_ID_Instruction_Mux_data;
	Mux #(32, 1) m_IF_ID_Instruction_Mux(.s(IF_ID_Mux_select), .y(IF_ID_Instruction_Mux_data), .d0(Instruction), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//IF_ID_Instruction
	wire [31:0] IF_ID_Instruction_data;
	flopr #(32) m_IF_ID_Instruction(.clk(clk), .update(IF_ID_Write), .d(IF_ID_Instruction_Mux_data), .q(IF_ID_Instruction_data));
	
	//Control
	wire [1:0] RegDst;
	wire RegWrite;
	wire [1:0] ALUSrcA;
	wire [2:0] ALUSrcB;
	wire [5:0] ALUOp;
	wire [1:0] ChangeType;
	wire MemRead;
	wire MemWrite;
	wire [1:0] MemtoReg;
	wire [1:0] StoreType;
	wire [2:0] LoadType;
	wire Reverse;
	Control m_Control(.clk(clk), .reset(rst), .Op(IF_ID_Instruction_data[31:26]), .Funct(IF_ID_Instruction_data[5:0]), .Rt(IF_ID_Instruction_data[20:16]), .RegDst(RegDst), .RegWrite(RegWrite), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUOp(ALUOp), .ChangeType(ChangeType), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .StoreType(StoreType), .LoadType(LoadType), .Reverse(Reverse), .IMPC_Mux_select(IMPC_Mux_select));
	
	//Sign_Extend
	wire [31:0] signExtendedOffset;
	EXT m_Sign_Extend(.EXTOp(`ArithmeticEXT), .Imm16(IF_ID_Instruction_data[15:0]), .Imm32(signExtendedOffset));
	
	//Logic_Extend
	wire [31:0] logicExtendedOffset;
	EXT m_Logic_Extend(.EXTOp(`LogicEXT), .Imm16(IF_ID_Instruction_data[15:0]), .Imm32(logicExtendedOffset));
	
	//BranchAdd
	BranchAdd m_BranchAdd(.PCplus4(IF_ID_PCplus4_data), .signEXTOffset(signExtendedOffset), .branchPC(branchPC));
	
	//Registers
	wire MEM_WB_RegWrite_data;
	wire [4:0] Write_register;
	wire [31:0] Write_data;
	wire [31:0] Read_data1;
	wire [31:0] Read_data2;
	Registers m_Registers(.clk(clk), .RegWrite(MEM_WB_RegWrite_data), .Read_register1(IF_ID_Instruction_data[25:21]), .Read_register2(IF_ID_Instruction_data[20:16]), .Write_register(Write_register), .Write_data(Write_data), .Read_data1(Read_data1), .Read_data2(Read_data2));
	
	//Hazard_detection_unit
	wire [1:0] branch_Or_Jump;
	wire ID_EX_MemRead_data;
	wire [31:0] ID_EX_Instruction_data;
	wire ID_EX_Mux_select;
	Hazard_detection_unit m_Hazard_detection_unit(.branch_Or_Jump(branch_Or_Jump), .ID_EX_MemRead(ID_EX_MemRead_data), .ID_EX_Rt(ID_EX_Instruction_data[20:16]), .IF_ID_Rs(IF_ID_Instruction_data[25:21]), .IF_ID_Rt(IF_ID_Instruction_data[20:16]), .IF_ID_Write(IF_ID_Write), .PC_Write(PC_Write), .PC_Mux_select(PC_Mux_select), .IF_ID_Mux_select(IF_ID_Mux_select), .ID_EX_Mux_select(ID_EX_Mux_select));
	
	/****************************************/
	/*                                      */
	/*                ID/EX                 */
	/*                                      */
	/****************************************/
	//ID_EX_Instruction_Mux
	wire [31:0] ID_EX_Instruction_Mux_data;
	Mux #(32, 1) m_ID_EX_Instruction_Mux(.s(ID_EX_Mux_select), .y(ID_EX_Instruction_Mux_data), .d0(IF_ID_Instruction_data), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ID_EX_Instruction
	flopr #(32) m_ID_EX_Instruction(.clk(clk), .update(1'b1), .d(ID_EX_Instruction_Mux_data), .q(ID_EX_Instruction_data));
	always@(*)
		begin
		$display("ID_EX_Instruction_data = %x", ID_EX_Instruction_data);
		end
	
	//ID_EX_Read_data1_Mux
	wire [31:0] ID_EX_Read_data1_Mux_data;
	Mux #(32, 1) m_ID_EX_Read_data1_Mux(.s(ID_EX_Mux_select), .y(ID_EX_Read_data1_Mux_data), .d0(Read_data1), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ID_EX_Read_data1
	wire [31:0] ID_EX_Read_data1_data;
	flopr #(32) m_ID_EX_Read_data1(.clk(clk), .update(1'b1), .d(ID_EX_Read_data1_Mux_data), .q(ID_EX_Read_data1_data));
	
	//ID_EX_Read_data2_Mux
	wire [31:0] ID_EX_Read_data2_Mux_data;
	Mux #(32, 1) m_ID_EX_Read_data2_Mux(.s(ID_EX_Mux_select), .y(ID_EX_Read_data2_Mux_data), .d0(Read_data2), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ID_EX_Read_data2
	wire [31:0] ID_EX_Read_data2_data;
	flopr #(32) m_ID_EX_Read_data2(.clk(clk), .update(1'b1), .d(ID_EX_Read_data2_Mux_data), .q(ID_EX_Read_data2_data));
	
	//ID_EX_Sign_Extend_Mux
	wire [31:0] ID_EX_Sign_Extend_Mux_data;
	Mux #(32, 1) m_ID_EX_Sign_Extend_Mux(.s(ID_EX_Mux_select), .y(ID_EX_Sign_Extend_Mux_data), .d0(signExtendedOffset), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ID_EX_Sign_Extend
	wire [31:0] ID_EX_Sign_Extend_data;
	flopr #(32) m_ID_EX_Sign_Extend(.clk(clk), .update(1'b1), .d(ID_EX_Sign_Extend_Mux_data), .q(ID_EX_Sign_Extend_data));
	always@(*)
		$display("ID_EX_Sign_Extend_data = %x", ID_EX_Sign_Extend_data);
	
	//ID_EX_Logic_Extend_Mux
	wire [31:0] ID_EX_Logic_Extend_Mux_data;
	Mux #(32, 1) m_ID_EX_Logic_Extend_Mux(.s(ID_EX_Mux_select), .y(ID_EX_Logic_Extend_Mux_data), .d0(logicExtendedOffset), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ID_EX_Logic_Extend
	wire [31:0] ID_EX_Logic_Extend_data;
	flopr #(32) m_ID_EX_Logic_Extend(.clk(clk), .update(1'b1), .d(ID_EX_Logic_Extend_Mux_data), .q(ID_EX_Logic_Extend_data));
	
	//ID_EX_RegDst_Mux
	wire [1:0] ID_EX_RegDst_Mux_data;
	Mux #(2, 1) m_ID_EX_RegDst_Mux(.s(ID_EX_Mux_select), .y(ID_EX_RegDst_Mux_data), .d0(RegDst), .d1(2'b0), .d2(2'b0), .d3(2'b0), .d4(2'b0), .d5(2'b0), .d6(2'b0), .d7(2'b0), .d8(2'b0), .d9(2'b0), .d10(2'b0), .d11(2'b0), .d12(2'b0), .d13(2'b0), .d14(2'b0), .d15(2'b0));
	
	//ID_EX_RegDst
	wire [1:0] ID_EX_RegDst_data;
	flopr #(2) m_ID_EX_RegDst(.clk(clk), .update(1'b1), .d(ID_EX_RegDst_Mux_data), .q(ID_EX_RegDst_data));
	
	//ID_EX_RegWrite_Mux
	wire ID_EX_RegWrite_Mux_data;
	Mux #(1, 1) m_ID_EX_RegWrite_Mux(.s(ID_EX_Mux_select), .y(ID_EX_RegWrite_Mux_data), .d0(RegWrite), .d1(1'b0), .d2(1'b0), .d3(1'b0), .d4(1'b0), .d5(1'b0), .d6(1'b0), .d7(1'b0), .d8(1'b0), .d9(1'b0), .d10(1'b0), .d11(1'b0), .d12(1'b0), .d13(1'b0), .d14(1'b0), .d15(1'b0));
	
	//ID_EX_RegWrite
	wire ID_EX_RegWrite_data;
	flopr #(1) m_ID_EX_RegWrite(.clk(clk), .update(1'b1), .d(ID_EX_RegWrite_Mux_data), .q(ID_EX_RegWrite_data));

	//ID_EX_ALUSrcA_Mux
	wire [1:0] ID_EX_ALUSrcA_Mux_data;
	Mux #(2, 1) m_ID_EX_ALUSrcA_Mux(.s(ID_EX_Mux_select), .y(ID_EX_ALUSrcA_Mux_data), .d0(ALUSrcA), .d1(2'b0), .d2(2'b0), .d3(2'b0), .d4(2'b0), .d5(2'b0), .d6(2'b0), .d7(2'b0), .d8(2'b0), .d9(2'b0), .d10(2'b0), .d11(2'b0), .d12(2'b0), .d13(2'b0), .d14(2'b0), .d15(2'b0));
	
	//ID_EX_ALUSrcA
	wire [1:0] ID_EX_ALUSrcA_data;
	flopr #(2) m_ID_EX_ALUSrcA(.clk(clk), .update(1'b1), .d(ID_EX_ALUSrcA_Mux_data), .q(ID_EX_ALUSrcA_data));
	
	//ID_EX_ALUSrcB_Mux
	wire [2:0] ID_EX_ALUSrcB_Mux_data;
	Mux #(3, 1) m_ID_EX_ALUSrcB_Mux(.s(ID_EX_Mux_select), .y(ID_EX_ALUSrcB_Mux_data), .d0(ALUSrcB), .d1(3'b0), .d2(3'b0), .d3(3'b0), .d4(3'b0), .d5(3'b0), .d6(3'b0), .d7(3'b0), .d8(3'b0), .d9(3'b0), .d10(3'b0), .d11(3'b0), .d12(3'b0), .d13(3'b0), .d14(3'b0), .d15(3'b0));
	
	//ID_EX_ALUSrcB
	wire [2:0] ID_EX_ALUSrcB_data;
	flopr #(3) m_ID_EX_ALUSrcB(.clk(clk), .update(1'b1), .d(ID_EX_ALUSrcB_Mux_data), .q(ID_EX_ALUSrcB_data));

	//ID_EX_ALUOp_Mux
	wire [5:0] ID_EX_ALUOp_Mux_data;
	Mux #(6, 1) m_ID_EX_ALUOp_Mux(.s(ID_EX_Mux_select), .y(ID_EX_ALUOp_Mux_data), .d0(ALUOp), .d1(6'b0), .d2(6'b0), .d3(6'b0), .d4(6'b0), .d5(6'b0), .d6(6'b0), .d7(6'b0), .d8(6'b0), .d9(6'b0), .d10(6'b0), .d11(6'b0), .d12(6'b0), .d13(6'b0), .d14(6'b0), .d15(6'b0));
	
	//ID_EX_ALUOp
	wire [5:0] ID_EX_ALUOp_data;
	flopr #(6) m_ID_EX_ALUOp(.clk(clk), .update(1'b1), .d(ID_EX_ALUOp_Mux_data), .q(ID_EX_ALUOp_data));
	
	//ID_EX_ChangeType_Mux
	wire [1:0] ID_EX_ChangeType_Mux_data;
	Mux #(2, 1) m_ID_EX_ChangeType_Mux(.s(ID_EX_Mux_select), .y(ID_EX_ChangeType_Mux_data), .d0(ChangeType), .d1(2'b0), .d2(2'b0), .d3(2'b0), .d4(2'b0), .d5(2'b0), .d6(2'b0), .d7(2'b0), .d8(2'b0), .d9(2'b0), .d10(2'b0), .d11(2'b0), .d12(2'b0), .d13(2'b0), .d14(2'b0), .d15(2'b0));
	
	//ID_EX_MemtoReg
	wire [1:0] ID_EX_ChangeType_data;
	flopr #(2) m_ID_EX_ChangeType(.clk(clk), .update(1'b1), .d(ID_EX_ChangeType_Mux_data), .q(ID_EX_ChangeType_data));
	
	//ID_EX_MemRead_Mux
	wire ID_EX_MemRead_Mux_data;
	Mux #(1, 1) m_ID_EX_MemRead_Mux(.s(ID_EX_Mux_select), .y(ID_EX_MemRead_Mux_data), .d0(MemRead), .d1(1'b0), .d2(1'b0), .d3(1'b0), .d4(1'b0), .d5(1'b0), .d6(1'b0), .d7(1'b0), .d8(1'b0), .d9(1'b0), .d10(1'b0), .d11(1'b0), .d12(1'b0), .d13(1'b0), .d14(1'b0), .d15(1'b0));
	
	//ID_EX_MemRead
	flopr #(1) m_ID_EX_MemRead(.clk(clk), .update(1'b1), .d(ID_EX_MemRead_Mux_data), .q(ID_EX_MemRead_data));
	
	//ID_EX_MemWrite_Mux
	wire ID_EX_MemWrite_Mux_data;
	Mux #(1, 1) m_ID_EX_MemWrite_Mux(.s(ID_EX_Mux_select), .y(ID_EX_MemWrite_Mux_data), .d0(MemWrite), .d1(1'b0), .d2(1'b0), .d3(1'b0), .d4(1'b0), .d5(1'b0), .d6(1'b0), .d7(1'b0), .d8(1'b0), .d9(1'b0), .d10(1'b0), .d11(1'b0), .d12(1'b0), .d13(1'b0), .d14(1'b0), .d15(1'b0));
	
	//ID_EX_MemWrite
	wire ID_EX_MemWrite_data;
	flopr #(1) m_ID_EX_MemWrite(.clk(clk), .update(1'b1), .d(ID_EX_MemWrite_Mux_data), .q(ID_EX_MemWrite_data));
	
	//ID_EX_MemtoReg_Mux
	wire [1:0] ID_EX_MemtoReg_Mux_data;
	Mux #(2, 1) m_ID_EX_MemtoReg_Mux(.s(ID_EX_Mux_select), .y(ID_EX_MemtoReg_Mux_data), .d0(MemtoReg), .d1(2'b0), .d2(2'b0), .d3(2'b0), .d4(2'b0), .d5(2'b0), .d6(2'b0), .d7(2'b0), .d8(2'b0), .d9(2'b0), .d10(2'b0), .d11(2'b0), .d12(2'b0), .d13(2'b0), .d14(2'b0), .d15(2'b0));
	
	//ID_EX_MemtoReg
	wire [1:0] ID_EX_MemtoReg_data;
	flopr #(2) m_ID_EX_MemtoReg(.clk(clk), .update(1'b1), .d(ID_EX_MemtoReg_Mux_data), .q(ID_EX_MemtoReg_data));

	//ID_EX_StoreType_Mux
	wire [1:0] ID_EX_StoreType_Mux_data;
	Mux #(2, 1) m_ID_EX_StoreType_Mux(.s(ID_EX_Mux_select), .y(ID_EX_StoreType_Mux_data), .d0(StoreType), .d1(2'b0), .d2(2'b0), .d3(2'b0), .d4(2'b0), .d5(2'b0), .d6(2'b0), .d7(2'b0), .d8(2'b0), .d9(2'b0), .d10(2'b0), .d11(2'b0), .d12(2'b0), .d13(2'b0), .d14(2'b0), .d15(2'b0));
	
	//ID_EX_StoreType
	wire [1:0] ID_EX_StoreType_data;
	flopr #(2) m_ID_EX_StoreType(.clk(clk), .update(1'b1), .d(ID_EX_StoreType_Mux_data), .q(ID_EX_StoreType_data));
	
	//ID_EX_LoadType_Mux
	wire [2:0] ID_EX_LoadType_Mux_data;
	Mux #(3, 1) m_ID_EX_LoadType_Mux(.s(ID_EX_Mux_select), .y(ID_EX_LoadType_Mux_data), .d0(LoadType), .d1(3'b0), .d2(3'b0), .d3(3'b0), .d4(3'b0), .d5(3'b0), .d6(3'b0), .d7(3'b0), .d8(3'b0), .d9(3'b0), .d10(3'b0), .d11(3'b0), .d12(3'b0), .d13(3'b0), .d14(3'b0), .d15(3'b0));
	
	//ID_EX_LoadType
	wire [2:0] ID_EX_LoadType_data;
	flopr #(3) m_ID_EX_LoadType(.clk(clk), .update(1'b1), .d(ID_EX_LoadType_Mux_data), .q(ID_EX_LoadType_data));
	
	//ID_EX_Reverse_Mux
	wire ID_EX_Reverse_Mux_data;
	Mux #(1, 1) m_ID_EX_Reverse_Mux(.s(ID_EX_Mux_select), .y(ID_EX_Reverse_Mux_data), .d0(Reverse), .d1(1'b0), .d2(1'b0), .d3(1'b0), .d4(1'b0), .d5(1'b0), .d6(1'b0), .d7(1'b0), .d8(1'b0), .d9(1'b0), .d10(1'b0), .d11(1'b0), .d12(1'b0), .d13(1'b0), .d14(1'b0), .d15(1'b0));
	
	//ID_EX_MemWrite
	wire ID_EX_Reverse_data;
	flopr #(1) m_ID_EX_Reverse(.clk(clk), .update(1'b1), .d(ID_EX_Reverse_Mux_data), .q(ID_EX_Reverse_data));
	
	//ID_EX_PCplus4_Mux
	wire [31:0] ID_EX_PCplus4_Mux_data;
	Mux #(32, 1) m_ID_EX_PCplus4_Mux(.s(ID_EX_Mux_select), .y(ID_EX_PCplus4_Mux_data), .d0(IF_ID_PCplus4_data), .d1(32'b0), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ID_EX_PCplus4
	flopr #(32) m_ID_EX_PCplus4(.clk(clk), .update(1'b1), .d(ID_EX_PCplus4_Mux_data), .q(ID_EX_PCplus4_data));
	
	//ALUSrcA_Mux
	wire [31:0] ALUSrcA_Mux_data;
	Mux #(32, 2) m_ALUSrcA_Mux(.s(ALUSrcA), .y(ALUSrcA_Mux_data), .d0(32'b0), .d1(ID_EX_Read_data1_data), .d2({27'b0, ID_EX_Instruction_data[10:6]}), .d3(ID_EX_PCplus4_data), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ALUSrcB_Mux
	wire [31:0] targetPCPre;
	wire [31:0] ALUSrcB_Mux_data;
	assign targetPCPre = {4'b0, (ID_EX_Instruction_data[25:0] << 2)};
	Mux #(32, 3) m_ALUSrcB_Mux(.s(ALUSrcB), .y(ALUSrcB_Mux_data), .d0(ID_EX_Read_data2_data), .d1(32'd4), .d2(ID_EX_Sign_Extend_data), .d3((ID_EX_Sign_Extend_data << 2)), .d4(ID_EX_Logic_Extend_data), .d5(32'b0), .d6(targetPCPre), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ForwardA_Mux
	wire [1:0] ForwardA;
	wire [31:0] src0;
	wire [31:0] EX_MEM_ALU_result_data;
	Mux #(32, 2) m_ForwardA_Mux(.s(ForwardA), .y(src0), .d0(ALUSrcA_Mux_data), .d1(Write_data), .d2(EX_MEM_ALU_result_data), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//FrowardB_Mux
	wire [1:0] ForwardB;
	wire [31:0] src1;
	Mux #(32, 2) m_ForwardB_Mux(.s(ForwardB), .y(src1), .d0(ALUSrcB_Mux_data), .d1(Write_data), .d2(EX_MEM_ALU_result_data), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//FrowardC_Mux
	wire [1:0] ForwardC;
	wire [31:0] ForwardC_data;
	Mux #(32, 2) m_ForwardC_Mux(.s(ForwardC), .y(ForwardC_data), .d0(ID_EX_Read_data2_data), .d1(Write_data), .d2(EX_MEM_ALU_result_data), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ALU
	wire Zero;
	ALU m_ALU(.clk(clk), .ALU_control(ID_EX_ALUOp_data), .src0(src0), .src1(src1), .Zero(Zero), .ALU_result(ALU_result));
	
	//Branch_Or_Jump
	Branch_Or_Jump m_Branch_Or_Jump(.Reverse(ID_EX_Reverse_data), .branchZero(Zero), .ChangeType(ID_EX_ChangeType_data), .branch_Or_Jump(branch_Or_Jump));
	
	//Forwarding_unit
	wire [1:0] EX_MEM_RegDst_data;
	wire EX_MEM_RegWrite_data;
	wire [1:0] MEM_WB_RegDst_data;
	wire [31:0] EX_MEM_Instruction_data;
	wire [31:0] MEM_WB_Instruction_data;
	Forwarding_unit m_Forwarding_unit(.ID_EX_Instruction(ID_EX_Instruction_data), .EX_MEM_Instruction(EX_MEM_Instruction_data), .MEM_WB_Instruction(MEM_WB_Instruction_data), .ForwardA(ForwardA), .ForwardB(ForwardB), .ForwardC(ForwardC));
	
	/****************************************/
	/*                                      */
	/*               EX/MEM                 */
	/*                                      */
	/****************************************/
	//EX_MEM_Instruction
	flopr #(32) m_EX_MEM_Instruction(.clk(clk), .update(1'b1), .d(ID_EX_Instruction_data), .q(EX_MEM_Instruction_data));
	
	//EX_MEM_Memory_Write_data;
	wire [31:0] EX_MEM_Memory_Write_data_data;
	flopr #(32) m_EX_MEM_Memory_Write_data(.clk(clk), .update(1'b1), .d(ForwardC_data), .q(EX_MEM_Memory_Write_data_data));
	/*always@(*)
		begin
		$display("EX_MEM_Memory_Write_data_data = %x", EX_MEM_Memory_Write_data_data);
		end*/
	
	//EX_MEM_ALU_result
	flopr #(32) m_EX_MEM_ALU_result(.clk(clk), .update(1'b1), .d(ALU_result), .q(EX_MEM_ALU_result_data));
	
	//EX_MEM_PCplus4
	wire [31:0] EX_MEM_PCplus4_data;
	flopr #(32) m_EX_MEM_PCplus4(.clk(clk), .update(1'b1), .d(ID_EX_PCplus4_data), .q(EX_MEM_PCplus4_data));
	
	//EX_MEM_RegDst
	flopr #(2) m_EX_MEM_RegDst(.clk(clk), .update(1'b1), .d(ID_EX_RegDst_data), .q(EX_MEM_RegDst_data));
	
	//EX_MEM_RegWrite
	flopr #(1) m_EX_MEM_RegWrite(.clk(clk), .update(1'b1), .d(ID_EX_RegWrite_data), .q(EX_MEM_RegWrite_data));
	always@(*)
		begin
		//$display("EX_MEM_RegWrite_data = %x", EX_MEM_RegWrite_data);
		$display("EX_MEM_Instruction_data = %x", EX_MEM_Instruction_data);
		end

	//EX_MEM_MemRead
	wire EX_MEM_MemRead_data;
	flopr #(1) m_EX_MEM_MemRead(.clk(clk), .update(1'b1), .d(ID_EX_MemRead_data), .q(EX_MEM_MemRead_data));
	
	//EX_MEM_MemWrite
	wire EX_MEM_MemWrite_data;
	flopr #(1) m_EX_MEM_MemWrite(.clk(clk), .update(1'b1), .d(ID_EX_MemWrite_data), .q(EX_MEM_MemWrite_data));
	
	//EX_MEM_MemtoReg
	wire [1:0] EX_MEM_MemtoReg_data;
	flopr #(2) m_EX_MEM_MemtoReg(.clk(clk), .update(1'b1), .d(ID_EX_MemtoReg_data), .q(EX_MEM_MemtoReg_data));

	//EX_MEM_StoreType
	wire [1:0] EX_MEM_StoreType_data;
	flopr #(2) m_EX_MEM_StoreType(.clk(clk), .update(1'b1), .d(ID_EX_StoreType_data), .q(EX_MEM_StoreType_data));
	
	//EX_MEM_LoadType
	wire [2:0] EX_MEM_LoadType_data;
	flopr #(3) m_EX_MEM_LoadType(.clk(clk), .update(1'b1), .d(ID_EX_LoadType_data), .q(EX_MEM_LoadType_data));
	
	//BE
	wire [3:0] be;
	BE m_BE(.StoreType(EX_MEM_StoreType_data), .ALUOut(EX_MEM_ALU_result_data[1:0]), .be(be));
	
	//Data_Memory
	wire [31:0] MemData;
	dm_4k m_Data_Memory(.addr(EX_MEM_ALU_result_data[11:2]), .be(be), .din(EX_MEM_Memory_Write_data_data), .DMWr(EX_MEM_MemWrite_data), .clk(clk), .dout(MemData));
	
	//LoadBE
	wire [31:0] LoadBE_data;
	LoadBE m_LoadBE(.LoadType(EX_MEM_LoadType_data), .ALUOut(EX_MEM_ALU_result_data[1:0]), .MemData_i(MemData), .MemData_o(LoadBE_data));
	
	/****************************************/
	/*                                      */
	/*               MEM/WB                 */
	/*                                      */
	/****************************************/
	//MEM_WB_Instruction
	flopr #(32) m_MEM_WB_Instruction(.clk(clk), .update(1'b1), .d(EX_MEM_Instruction_data), .q(MEM_WB_Instruction_data));
	
	//MEM_WB_ALU_result
	wire [31:0] MEM_WB_ALU_result_data;
	flopr #(32) m_MEM_WB_ALU_result(.clk(clk), .update(1'b1), .d(EX_MEM_ALU_result_data), .q(MEM_WB_ALU_result_data));
	
	//MEM_WB_PCplus4
	wire [31:0] MEM_WB_PCplus4_data;
	flopr #(32) m_MEM_WB_PCplus4(.clk(clk), .update(1'b1), .d(EX_MEM_PCplus4_data), .q(MEM_WB_PCplus4_data));
	/*always@(*)
		begin
		$display("IF_ID_PCplus4_data = %x    ID_EX_PCplus4_data = %x    EX_MEM_PCplus4_data = %x    MEM_WB_PCplus4_data = %x", IF_ID_PCplus4_data, ID_EX_PCplus4_data, EX_MEM_PCplus4_data, MEM_WB_PCplus4_data);
		end*/
	
	//MEM_WB_MemData
	wire [31:0] MEM_WB_MemData_data;
	flopr #(32) m_MEM_WB_MemData(.clk(clk), .update(1'b1), .d(LoadBE_data), .q(MEM_WB_MemData_data));
	
	//MEM_WB_RegDst
	flopr #(2) m_MEM_WB_RegDst(.clk(clk), .update(1'b1), .d(EX_MEM_RegDst_data), .q(MEM_WB_RegDst_data));
	
	//MEM_WB_RegWrite
	flopr #(1) m_MEM_WB_RegWrite(.clk(clk), .update(1'b1), .d(EX_MEM_RegWrite_data), .q(MEM_WB_RegWrite_data));
	
	//MEM_WB_MemtoReg
	wire [1:0] MEM_WB_MemtoReg_data;
	flopr #(2) m_MEM_WB_MemtoReg(.clk(clk), .update(1'b1), .d(EX_MEM_MemtoReg_data), .q(MEM_WB_MemtoReg_data));
	
	//MemtoReg_Mux
	Mux #(32, 2) m_MemtoReg_Mux(.s(MEM_WB_MemtoReg_data), .y(Write_data), .d0(MEM_WB_ALU_result_data), .d1(MEM_WB_MemData_data), .d2(MEM_WB_PCplus4_data), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	/*always@(*)
		begin
		$display("MEM_WB_MemtoReg_data = %x    Write_data = %x", MEM_WB_MemtoReg_data, Write_data);
		end*/
	
	//RegDst_Mux
	Mux #(5, 2) m_RegDst_Mux(.s(MEM_WB_RegDst_data), .y(Write_register), .d0(MEM_WB_Instruction_data[20:16]), .d1(MEM_WB_Instruction_data[15:11]), .d2(5'b11111), .d3(5'b0), .d4(5'b0), .d5(5'b0), .d6(5'b0), .d7(5'b0), .d8(5'b0), .d9(5'b0), .d10(5'b0), .d11(5'b0), .d12(5'b0), .d13(5'b0), .d14(5'b0), .d15(5'b0));
endmodule