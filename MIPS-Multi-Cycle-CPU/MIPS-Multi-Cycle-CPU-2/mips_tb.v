`include "C://Users//Think//Desktop//MIPS-Multi-Cycle-CPU-2//mips.v"
`timescale  1ns/1ps
module mips_tb();
	reg clk, reset;
	
	mips m_mips(.clk(clk), .rst(reset));
	
	initial
		begin
		//$readmemh("code.txt", m_Mips.m_InstructionMemory.instructionMemory);
		$monitor("PC = 0x%8X, IR = 0x%8X", m_mips.m_PC.PC_o, m_mips.m_Instruction_Register.q);
		clk = 1;
		reset = 1;
		#5;
		reset = 0;
		#20;
		reset = 1;
		end
		
	always
		#(50) clk = ~clk;
endmodule