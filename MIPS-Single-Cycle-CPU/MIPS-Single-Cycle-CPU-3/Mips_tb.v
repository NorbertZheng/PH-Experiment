`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-3//Mips.v"
`timescale  1ns/1ps
module Mips_tb();
	reg clk, reset;
	
	Mips m_Mips(.clk(clk), .reset(reset));
	
	initial
		begin
		//$readmemh("code.txt", m_Mips.m_InstructionMemory.instructionMemory);
		$monitor("PC = 0x%8X, IR = 0x%8X", m_Mips.m_PC.PC_o, m_Mips.Instruction);
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