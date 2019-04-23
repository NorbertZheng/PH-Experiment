`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
`timescale 1ns/100ps
module Hazard_detection_unit(branch_Or_Jump, ID_EX_MemRead, ID_EX_Rt, IF_ID_Rs, IF_ID_Rt, IF_ID_Stall, PC_Write, PC_Mux_select, IF_ID_Flush, ID_EX_Flush);
	input [1:0] branch_Or_Jump;
	input ID_EX_MemRead;
	input [4:0] ID_EX_Rt;
	input [4:0] IF_ID_Rs;
	input [4:0] IF_ID_Rt;
	output reg IF_ID_Stall;
	output reg PC_Write;
	output reg [1:0] PC_Mux_select;
	output reg IF_ID_Flush;
	output reg ID_EX_Flush;
	
	always@(*)
		begin
		if(ID_EX_MemRead && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt)))
			begin
			$display("LW stall!");
			PC_Write <= 1'b0;
			IF_ID_Stall <= `ENABLE;
			ID_EX_Flush <= `ENABLE;
			end
		else
			begin
			case(branch_Or_Jump)
				`Sequence:
					begin
					$display("Sequence!");
					PC_Write <= 1'b1;
					IF_ID_Stall <= `DISABLE;
					PC_Mux_select <= 2'b00;
					IF_ID_Flush <= `DISABLE;
					ID_EX_Flush <= `DISABLE;
					end
				`Branch:
					begin
					$display("Branch!");
					PC_Write <= 1'b1;
					IF_ID_Stall <= `DISABLE;
					PC_Mux_select <= 2'b00;
					IF_ID_Flush <= `DISABLE;
					ID_EX_Flush <= `DISABLE;
					end
				`NotBranch:
					begin
					$display("NotBranch!");
					PC_Write <= 1'b1;
					IF_ID_Stall <= `DISABLE;
					PC_Mux_select <= 2'b01;
					IF_ID_Flush <= `ENABLE;
					ID_EX_Flush <= `ENABLE;
					end
				`Jump:
					begin
					$display("Jump!");
					PC_Write <= 1'b1;
					IF_ID_Stall <= `DISABLE;
					PC_Mux_select <= 2'b10;
					IF_ID_Flush <= `ENABLE;
					ID_EX_Flush <= `ENABLE;
					end
				default:
					begin
					PC_Write <= 1'b0;
					IF_ID_Stall <= `ENABLE;
					PC_Mux_select <= 2'b00;
					IF_ID_Flush <= `DISABLE;
					ID_EX_Flush <= `DISABLE;
					$display("Undefined next PC state ---- %x!", branch_Or_Jump);
					end
			endcase
			end
		end
endmodule