`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//flopr.v"
module MEM_WB_REG(clk, reset, MEM_WB_Stall, MEM_WB_Flush, Instruction, MEM_WB_Instruction_data, PCplus4, MEM_WB_PCplus4_data, ALU_result, MEM_WB_ALU_result_data, MemData, MEM_WB_MemData_data, RegDst, MEM_WB_RegDst_data, RegWrite, MEM_WB_RegWrite_data, MemtoReg, MEM_WB_MemtoReg_data);
	input clk;
	input reset;
	input MEM_WB_Stall;
	input MEM_WB_Flush;
	input [31:0] Instruction;
	output [31:0] MEM_WB_Instruction_data;
	input [31:0] PCplus4;
	output [31:0] MEM_WB_PCplus4_data;
	input [31:0] ALU_result;
	output [31:0] MEM_WB_ALU_result_data;
	input [31:0] MemData;
	output [31:0] MEM_WB_MemData_data;
	input [1:0] RegDst;
	output [1:0] MEM_WB_RegDst_data;
	input RegWrite;
	output MEM_WB_RegWrite_data;
	input [1:0] MemtoReg;
	output [1:0] MEM_WB_MemtoReg_data;

	// MEM_WB_Instruction
	flopr #(32) m_MEM_WB_Instruction(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(Instruction), .q(MEM_WB_Instruction_data));
	
	// MEM_WB_PCplus4
	flopr #(32) m_MEM_WB_PCplus4(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(PCplus4), .q(MEM_WB_PCplus4_data));
	
	// MEM_WB_ALU_result
	flopr #(32) m_MEM_WB_ALU_result(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(ALU_result), .q(MEM_WB_ALU_result_data));
	
	// MEM_WB_MemData
	flopr #(32) m_MEM_WB_MemData(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(MemData), .q(MEM_WB_MemData_data));
	
	// MEM_WB_RegDst
	flopr #(2) m_MEM_WB_RegDst(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(RegDst), .q(MEM_WB_RegDst_data));
	
	// MEM_WB_RegWrite
	flopr #(1) m_MEM_WB_RegWrite(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(RegWrite), .q(MEM_WB_RegWrite_data));
	
	// MEM_WB_MemtoReg
	flopr #(2) m_MEM_WB_MemtoReg(.clk(clk), .reset(reset), .stall(MEM_WB_Stall), .flush(MEM_WB_Flush), .d(MemtoReg), .q(MEM_WB_MemtoReg_data));
endmodule