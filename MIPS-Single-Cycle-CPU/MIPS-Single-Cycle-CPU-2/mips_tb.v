`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//mips.v"
`timescale  1ns/1ps
module mips_tb();
	integer i;
	reg clk, rst_n;
	
	mips m_mips(.clk(clk), .rst_n(rst_n));
    
	initial
		begin
		$readmemh( "code.txt" , m_mips.m_Instruction_memory.InstructionMemory);
		$display("=================================================================");
		for(i = 0;i < 1024;i = i + 1)
			begin
			$display("%x %x", i, m_mips.m_Instruction_memory.InstructionMemory[i]);
			end
		$monitor("PC_i = 0x%8X, PC = 0x%8X, IR = 0x%8X", m_mips.m_PC.PC_i, m_mips.m_PC.PC_o, m_mips.Instruction); 
		clk = 1 ;
		rst_n = 0 ;
		#5 ;
		rst_n = 1 ;
		#20 ;
		rst_n = 0 ;
		end

	always
		#(50) clk = ~clk;
endmodule