`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Mips.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//DEBUG_Define.v"
`timescale  1ns/1ps
module Mips_tb();
	reg clk, reset, INT;
	wire INT_ACK;
	reg [5:0] cnt;
	
	Mips m_Mips(.clk(clk), .reset(reset), .INT(INT), .INT_ACK(INT_ACK));
	
	initial
		begin
		//$readmemh("code.txt", m_Mips.m_InstructionMemory.instructionMemory);
		`ifdef DEBUG
		$monitor("PC = 0x%8X, IR = 0x%8X", m_Mips.m_PC.PC_o, m_Mips.Instruction);
		`endif
		clk = 1;
		reset = 1;
		INT = 0;
		#5;
		reset = 0;
		#20;
		reset = 1;
		end
		
	always
		#(50) clk = ~clk;
		
	always@(posedge clk or negedge reset)
		begin
		if(!reset)
			begin
			cnt <= 6'b0;
			end
		else
			begin
			if(cnt < 6'h8)
				begin
				cnt <= cnt + 1'b1;
				end
			else
				begin
				cnt <= 6'b0;
				end
			end
		end
		
	always@(*)
		begin
		INT = cnt[3];
		$display("INT = 0x%1X, INT_ACK = 0x%1X", INT, INT_ACK);
		end
endmodule