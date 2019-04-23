`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//flopr.v"
module IF_ID_REG(clk, reset, IF_ID_Stall, IF_ID_Flush, PCplus4, IF_ID_PCplus4_data, Instruction, IF_ID_Instruction_data);
	input clk;
	input reset;
	input IF_ID_Stall;
	input IF_ID_Flush;
	input [31:0] PCplus4;
	output [31:0] IF_ID_PCplus4_data;
	input [31:0] Instruction;
	output [31:0] IF_ID_Instruction_data;
	
	// IF_ID_PCplus4
	flopr #(32) m_IF_ID_PCplus4(.clk(clk), .reset(reset), .stall(IF_ID_Stall), .flush(IF_ID_Flush), .d(PCplus4), .q(IF_ID_PCplus4_data));
	
	// IF_ID_Instruction
	flopr #(32) m_IF_ID_Instruction(.clk(clk), .reset(reset), .stall(IF_ID_Stall), .flush(IF_ID_Flush), .d(Instruction), .q(IF_ID_Instruction_data));
	
	always@(*)
		begin
		$display("IF_ID_REG: IF_ID_Stall = 0x%1X, IF_ID_Flush = 0x%1X, IF_ID_Instruction_data = 0x%8X, IF_ID_PCplus4_data = 0x%8X", IF_ID_Stall, IF_ID_Flush, IF_ID_Instruction_data, IF_ID_PCplus4_data);
		end
endmodule