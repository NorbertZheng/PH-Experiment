`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Mips.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-2//Define//DEBUG_Define.v"
`timescale  1ns/1ps
module Mips_tb();
	reg clk, reset;
	
	Mips m_Mips(.clk(clk), .rst(reset));
	
	initial
		begin
		//$readmemh("code.txt", m_Mips.m_InstructionMemory.instructionMemory);
		`ifdef DEBUG
		$monitor("PC = 0x%8X, IR = 0x%8X", m_Mips.m_PC.PC_o, m_Mips.Instruction);
		`endif
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