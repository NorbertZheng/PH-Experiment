`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//flopr.v"
module EX_MEM_REG(clk, reset, EX_MEM_Stall, EX_MEM_Flush, Instruction, EX_MEM_Instruction_data, PCplus4, EX_MEM_PCplus4_data, Memory_Write_data, EX_MEM_Memory_Write_data_data, ALU_result, EX_MEM_ALU_result_data, RegDst, EX_MEM_RegDst_data, RegWrite, EX_MEM_RegWrite_data, MemRead, EX_MEM_MemRead_data, MemWrite, EX_MEM_MemWrite_data, MemtoReg, EX_MEM_MemtoReg_data, StoreType, EX_MEM_StoreType_data, LoadType, EX_MEM_LoadType_data, ExcCode, EX_MEM_ExcCode_data);
	input clk;
	input reset;
	input EX_MEM_Stall;
	input EX_MEM_Flush;
	input [31:0] Instruction;
	output [31:0] EX_MEM_Instruction_data;
	input [31:0] PCplus4;
	output [31:0] EX_MEM_PCplus4_data;
	input [31:0] Memory_Write_data;
	output [31:0] EX_MEM_Memory_Write_data_data;
	input [31:0] ALU_result;
	output [31:0] EX_MEM_ALU_result_data;
	input [1:0] RegDst;
	output [1:0] EX_MEM_RegDst_data;
	input RegWrite;
	output EX_MEM_RegWrite_data;
	input MemRead;
	output EX_MEM_MemRead_data;
	input MemWrite;
	output EX_MEM_MemWrite_data;
	input [1:0] MemtoReg;
	output [1:0] EX_MEM_MemtoReg_data;
	input [1:0] StoreType;
	output [1:0] EX_MEM_StoreType_data;
	input [2:0] LoadType;
	output [2:0] EX_MEM_LoadType_data;
	input [1:0] ExcCode;
	output [1:0] EX_MEM_ExcCode_data;

	// EX_MEM_Instruction
	flopr #(32) m_EX_MEM_Instruction(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(Instruction), .q(EX_MEM_Instruction_data));
	
	// EX_MEM_PCplus4
	flopr #(32) m_EX_MEM_PCplus4(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(PCplus4), .q(EX_MEM_PCplus4_data));
	
	// EX_MEM_Memory_Write_data
	flopr #(32) m_EX_MEM_Memory_Write_data(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(Memory_Write_data), .q(EX_MEM_Memory_Write_data_data));
	
	// EX_MEM_ALU_result
	flopr #(32) m_EX_MEM_ALU_result(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(ALU_result), .q(EX_MEM_ALU_result_data));
	
	// EX_MEM_RegDst
	flopr #(2) m_EX_MEM_RegDst(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(RegDst), .q(EX_MEM_RegDst_data));
	
	// EX_MEM_RegWrite
	flopr #(1) m_EX_MEM_RegWrite(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(RegWrite), .q(EX_MEM_RegWrite_data));
	
	// EX_MEM_MemRead
	flopr #(1) m_EX_MEM_MemRead(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(MemRead), .q(EX_MEM_MemRead_data));
	
	// EX_MEM_MemWrite
	flopr #(1) m_EX_MEM_MemWrite(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(MemWrite), .q(EX_MEM_MemWrite_data));
	
	// EX_MEM_MemtoReg
	flopr #(2) m_EX_MEM_MemtoReg(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(MemtoReg), .q(EX_MEM_MemtoReg_data));
	
	// EX_MEM_StoreType
	flopr #(2) m_EX_MEM_StoreType(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(StoreType), .q(EX_MEM_StoreType_data));
	
	// EX_MEM_LoadType
	flopr #(3) m_EX_MEM_LoadType(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(LoadType), .q(EX_MEM_LoadType_data));
	
	// EX_MEM_ExcCode
	flopr #(2) m_EX_MEM_ExcCode(.clk(clk), .reset(reset), .stall(EX_MEM_Stall), .flush(EX_MEM_Flush), .d(ExcCode), .q(EX_MEM_ExcCode_data));
	always@(*)	
		begin
		$display("EX_MEM_ExcCode_data = 0x%1X", EX_MEM_ExcCode_data);
		end
endmodule