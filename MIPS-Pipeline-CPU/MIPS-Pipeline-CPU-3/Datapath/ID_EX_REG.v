`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//flopr.v"
module ID_EX_REG(clk, reset, ID_EX_Stall, ID_EX_Flush, Instruction, ID_EX_Instruction_data, PCplus4, ID_EX_PCplus4_data, Read_data1, ID_EX_Read_data1_data, Read_data2, ID_EX_Read_data2_data, Sign_Extend, ID_EX_Sign_Extend_data, Logic_Extend, ID_EX_Logic_Extend_data, RegDst, ID_EX_RegDst_data, RegWrite, ID_EX_RegWrite_data, ALUSrcA, ID_EX_ALUSrcA_data, ALUSrcB, ID_EX_ALUSrcB_data, ALUOp, ID_EX_ALUOp_data, ChangeType, ID_EX_ChangeType_data, MemRead, ID_EX_MemRead_data, MemWrite, ID_EX_MemWrite_data, MemtoReg, ID_EX_MemtoReg_data, StoreType, ID_EX_StoreType_data, LoadType, ID_EX_LoadType_data, Reverse, ID_EX_Reverse_data, syscall, ID_EX_syscall_data, eret, ID_EX_eret_data, RI, ID_EX_RI_data, CR_Read, ID_EX_CR_Read_data, CR_Write, ID_EX_CR_Write_data);
	input clk;
	input reset;
	input ID_EX_Stall;
	input ID_EX_Flush;
	input [31:0] Instruction;
	output [31:0] ID_EX_Instruction_data;
	input [31:0] PCplus4;
	output [31:0] ID_EX_PCplus4_data;
	input [31:0] Read_data1;
	output [31:0] ID_EX_Read_data1_data;
	input [31:0] Read_data2;
	output [31:0] ID_EX_Read_data2_data;
	input [31:0] Sign_Extend;
	output [31:0] ID_EX_Sign_Extend_data;
	input [31:0] Logic_Extend;
	output [31:0] ID_EX_Logic_Extend_data;
	input [1:0] RegDst;
	output [1:0] ID_EX_RegDst_data;
	input RegWrite;
	output ID_EX_RegWrite_data;
	input [1:0] ALUSrcA;
	output [1:0] ID_EX_ALUSrcA_data;
	input [2:0] ALUSrcB;
	output [2:0] ID_EX_ALUSrcB_data;
	input [5:0] ALUOp;
	output [5:0] ID_EX_ALUOp_data;
	input [1:0] ChangeType;
	output [1:0] ID_EX_ChangeType_data;
	input MemRead;
	output ID_EX_MemRead_data;
	input MemWrite;
	output ID_EX_MemWrite_data;
	input [1:0] MemtoReg;
	output [1:0] ID_EX_MemtoReg_data;
	input [1:0] StoreType;
	output [1:0] ID_EX_StoreType_data;
	input [2:0] LoadType;
	output [2:0] ID_EX_LoadType_data;
	input Reverse;
	output ID_EX_Reverse_data;
	input syscall;
	output ID_EX_syscall_data;
	input eret;
	output ID_EX_eret_data;
	input RI;
	output ID_EX_RI_data;
	input CR_Read;
	output ID_EX_CR_Read_data;
	input CR_Write;
	output ID_EX_CR_Write_data;

	// ID_EX_Instruction
	flopr #(32) m_ID_EX_Instruction(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(Instruction), .q(ID_EX_Instruction_data));
	
	// ID_EX_PCplus4
	flopr #(32) m_ID_EX_PCplus4(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(PCplus4), .q(ID_EX_PCplus4_data));
	
	// ID_EX_Read_data1
	flopr #(32) m_ID_EX_Read_data1(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(Read_data1), .q(ID_EX_Read_data1_data));
	
	// ID_EX_Read_data2
	flopr #(32) m_ID_EX_Read_data2(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(Read_data2), .q(ID_EX_Read_data2_data));
	
	// ID_EX_Sign_Extend
	flopr #(32) m_ID_EX_Sign_Extend(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(Sign_Extend), .q(ID_EX_Sign_Extend_data));
	
	// ID_EX_Logic_Extend
	flopr #(32) m_ID_EX_Logic_Extend(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(Logic_Extend), .q(ID_EX_Logic_Extend_data));
	
	// ID_EX_RegDst
	flopr #(2) m_ID_EX_RegDst(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(RegDst), .q(ID_EX_RegDst_data));
	
	// ID_EX_RegWrite
	flopr #(1) m_ID_EX_RegWrite(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(RegWrite), .q(ID_EX_RegWrite_data));
	
	// ID_EX_ALUSrcA
	flopr #(2) m_ID_EX_ALUSrcA(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(ALUSrcA), .q(ID_EX_ALUSrcA_data));
	
	// ID_EX_ALUSrcB
	flopr #(3) m_ID_EX_ALUSrcB(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(ALUSrcB), .q(ID_EX_ALUSrcB_data));
	
	// ID_EX_ALUOp
	flopr #(6) m_ID_EX_ALUOp(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(ALUOp), .q(ID_EX_ALUOp_data));
	
	// ID_EX_ChangeType
	flopr #(2) m_ID_EX_ChangeType(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(ChangeType), .q(ID_EX_ChangeType_data));
	
	// ID_EX_MemRead
	flopr #(1) m_ID_EX_MemRead(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(MemRead), .q(ID_EX_MemRead_data));
	
	// ID_EX_MemWrite
	flopr #(1) m_ID_EX_MemWrite(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(MemWrite), .q(ID_EX_MemWrite_data));
	
	// ID_EX_MemtoReg
	flopr #(2) m_ID_EX_MemtoReg(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(MemtoReg), .q(ID_EX_MemtoReg_data));
	
	// ID_EX_StoreType
	flopr #(2) m_ID_EX_StoreType(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(StoreType), .q(ID_EX_StoreType_data));
	
	// ID_EX_LoadType
	flopr #(3) m_ID_EX_LoadType(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(LoadType), .q(ID_EX_LoadType_data));
	
	// ID_EX_Reverse
	flopr #(1) m_ID_EX_Reverse(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(Reverse), .q(ID_EX_Reverse_data));
	
	// ID_EX_syscall
	flopr #(1) m_ID_EX_syscall(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(syscall), .q(ID_EX_syscall_data));
	
	// ID_EX_eret
	flopr #(1) m_ID_EX_eret(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(eret), .q(ID_EX_eret_data));
	
	// ID_EX_RI
	flopr #(1) m_ID_EX_RI(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(RI), .q(ID_EX_RI_data));
	
	// ID_EX_CR_Read
	flopr #(1) m_ID_EX_CR_Read(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(CR_Read), .q(ID_EX_CR_Read_data));
	
	// ID_EX_CR_Write
	flopr #(1) m_ID_EX_CR_Write(.clk(clk), .reset(reset), .stall(ID_EX_Stall), .flush(ID_EX_Flush), .d(CR_Write), .q(ID_EX_CR_Write_data));
endmodule