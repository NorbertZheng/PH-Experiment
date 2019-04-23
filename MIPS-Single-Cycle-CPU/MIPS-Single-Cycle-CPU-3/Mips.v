`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//ALU.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//BranchPC.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//PC.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//PCIncrement.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//Registers.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//SignExtend.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//TargetPC.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//DataMemory.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Datapath//InstructionMemory.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Control//Control.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Generatic//Mux.v"
module Mips(clk, reset);
	input clk;
	input reset;
	
	//PC
	wire [31:0] PC_i;
	wire [31:0] PC_o;
	PC m_PC(.clk(clk), .reset(reset), .PC_i(PC_i), .PC_o(PC_o));
	
	//PCIncrement
	wire [31:0] nextPC;
	PCIncrement m_PCIncrement(.currentPC(PC_o), .nextPC(nextPC));
	
	//InstructionMemory
	wire [31:0] Instruction;
	InstructionMemory m_InstructionMemory(.Read_address(PC_o), .Instruction(Instruction));
	
	//Control
	wire RegDst;
	wire Jump;
	wire Branch;
	wire MemRead;
	wire MemtoReg;
	wire [5:0] ALUOp;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	Control m_Control(.Op(Instruction[31:26]), .Funct(Instruction[5:0]), .RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));
	
	//RegDst_Mux
	wire [4:0] tempWriteReg;
	Mux #(5, 1) m_RegDst_Mux(.s(RegDst), .y(tempWriteReg), .d0(Instruction[20:16]), .d1(Instruction[15:11]), .d2(5'b0), .d3(5'b0), .d4(5'b0), .d5(5'b0), .d6(5'b0), .d7(5'b0), .d8(5'b0), .d9(5'b0), .d10(5'b0), .d11(5'b0), .d12(5'b0), .d13(5'b0), .d14(5'b0), .d15(5'b0));
	
	//Jump_RegDst_Mux
	wire [4:0] writeReg;
	Mux #(5, 1) m_Jump_RegDst_Mux(.s(Jump), .y(writeReg), .d0(tempWriteReg), .d1(5'b11111), .d2(5'b0), .d3(5'b0), .d4(5'b0), .d5(5'b0), .d6(5'b0), .d7(5'b0), .d8(5'b0), .d9(5'b0), .d10(5'b0), .d11(5'b0), .d12(5'b0), .d13(5'b0), .d14(5'b0), .d15(5'b0));
	
	//Registers
	wire [31:0] writeData;
	wire [31:0] readData1;
	wire [31:0] readData2;
	Registers m_Registers(.clk(clk), .RegWrite(RegWrite), .readReg1(Instruction[25:21]), .readReg2(Instruction[20:16]), .writeReg(writeReg), .writeData(writeData), .readData1(readData1), .readData2(readData2));
	
	//SignExtend
	wire [31:0] extendedOffset;
	SignExtend m_SignExtend(.offset(Instruction[15:0]), .extendedOffset(extendedOffset));
	
	//ALUSrc_Mux
	wire [31:0] src1;
	Mux #(32, 1) m_ALUSrc_Mux(.s(ALUSrc), .y(src1), .d0(readData2), .d1(extendedOffset), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ALU
	wire Zero;
	wire [31:0] ALU_result;
	ALU m_ALU(.ALU_control(ALUOp), .src0(readData1), .src1(src1), .Zero(Zero), .ALU_result(ALU_result));
	
	//DataMemory
	wire [31:0] Read_data;
	DataMemory m_DataMemory(.clk(clk), .MemWrite(MemWrite), .MemRead(MemRead), .Address(ALU_result), .Write_data(readData2), .Read_data(Read_data));
	
	//MemtoReg_Mux
	wire [31:0] tempWriteData;
	Mux #(32, 1) m_MemtoReg_Mux(.s(MemtoReg), .y(tempWriteData), .d0(ALU_result), .d1(Read_data), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//Jump_MemtoReg_Mux
	wire [31:0] targetPC;
	Mux #(32, 1) m_Jump_MemtoReg_Mux(.s(Jump), .y(writeData), .d0(tempWriteData), .d1(nextPC), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//TargetPC
	TargetPC m_TargetPC(.clk(clk), .nextPC(nextPC), .target(Instruction[25:0]), .targetPC(targetPC));
	
	//BranchPC
	wire [31:0] branchPC;
	BranchPC m_BranchPC(.nextPC(nextPC), .extendedOffset(extendedOffset), .branchPC(branchPC));
	
	//Branch_Mux
	wire branchSignal;
	wire [31:0] selectedPC1;
	assign branchSignal = Branch & Zero;
	Mux #(32, 1) m_Branch_Mux(.s(branchSignal), .y(selectedPC1), .d0(nextPC), .d1(branchPC), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//Jump_Mux
	Mux #(32, 1) m_Jump_Mux(.s(Jump), .y(PC_i), .d0(selectedPC1), .d1(targetPC), .d2(32'b0), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
endmodule