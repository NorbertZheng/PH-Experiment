`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Define//instruction_def.v"
`timescale  1ns/1ps
module ctrl(OP, Funct, Zero, BSel, WDSel, RFWr, DMWr, NPCOp, EXTOp, ALUOp, PCWr, IRWr, GPRSel);
	//input clk;
	//input rst_n;
	input [5:0] OP, Funct;
	input Zero;
	output reg BSel, RFWr, DMWr, PCWr, IRWr;
	output reg [1:0] WDSel, NPCOp, EXTOp, ALUOp, GPRSel;
	
	always@(*)
		begin
		/*if(rst_n)
			begin
			BSel = 1'b0;
			RFWr = 1'b0;
			DMWr = 1'b0;
			PCWr = 1'b1;
			IRWr = 1'b1;
			WDSel = 2'b00;
			NPCOp = 2'b00;
			EXTOp = 2'b00;
			ALUOp = 2'b00;
			GPRSel = 2'b00;
			end
		else
			begin*/
		case(OP)
			`R_opcode:
				begin
				case(Funct)
					`addu_funct:
						begin
						BSel = 1'b0;
						RFWr = 1'b1;
						DMWr = 1'b0;
						PCWr = 1'b1;
						IRWr = 1'b1;
						WDSel = 2'b00;
						NPCOp = 2'b00;
						EXTOp = 2'bxx;
						ALUOp = 2'b00;
						GPRSel = 2'b00;
						end
					`subu_funct:
						begin
						BSel = 1'b0;
						RFWr = 1'b1;
						DMWr = 1'b0;
						PCWr = 1'b1;
						IRWr = 1'b1;
						WDSel = 2'b00;
						NPCOp = 2'b00;
						EXTOp = 2'bxx;
						ALUOp = 2'b01;
						GPRSel = 2'b00;
						end
				endcase
				end
			`ori_opcode:
				begin
				BSel = 1'b1;
				RFWr = 1'b1;
				DMWr = 1'b0;
				PCWr = 1'b1;
				IRWr = 1'b1;
				WDSel = 2'b00;
				NPCOp = 2'b00;
				EXTOp = 2'b01;
				ALUOp = 2'b10;
				GPRSel = 2'b01;
				end
			`lw_opcode:
				begin
				BSel = 1'b1;
				RFWr = 1'b1;
				DMWr = 1'b0;
				PCWr = 1'b1;
				IRWr = 1'b1;
				WDSel = 2'b01;
				NPCOp = 2'b00;
				EXTOp = 2'b01;
				ALUOp = 2'b00;
				GPRSel = 2'b01;
				end
			`sw_opcode:
				begin
				BSel = 1'b1;
				RFWr = 1'b0;
				DMWr = 1'b1;
				PCWr = 1'b1;
				IRWr = 1'b1;
				WDSel = 2'bxx;
				NPCOp = 2'b00;
				EXTOp = 2'b01;
				ALUOp = 2'b00;
				GPRSel = 2'bxx;
				end
			`beq_opcode:
				begin
				BSel = 1'b0;
				RFWr = 1'b0;
				DMWr = 1'b0;
				PCWr = 1'b1;
				IRWr = 1'b1;
				WDSel = 2'bxx;
				NPCOp = 2'b01;
				EXTOp = 2'b01;
				ALUOp = 2'b01;
				GPRSel = 2'bxx;
				end
			`jal_opcode:
				begin
				BSel = 1'bx;
				RFWr = 1'b1;
				DMWr = 1'b0;
				PCWr = 1'b1;
				IRWr = 1'b1;
				WDSel = 2'b10;
				NPCOp = 2'b10;
				EXTOp = 2'bxx;
				ALUOp = 2'bxx;
				GPRSel = 2'b10;
				end
		endcase
		//end
		end
endmodule