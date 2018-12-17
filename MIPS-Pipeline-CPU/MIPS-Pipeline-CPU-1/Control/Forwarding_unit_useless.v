module Forwarding_unit(ID_EX_ALUSrcA, EX_MEM_RegWrite, ID_EX_ALUSrcB, MEM_WB_RegWrite, EX_MEM_Rt, EX_MEM_Rd, MEM_WB_Rt, MEM_WB_Rd, ID_EX_Rs, ID_EX_Rt, ForwardA, ForwardB);
	input [1:0] ID_EX_ALUSrcA;
	input EX_MEM_RegWrite;
	input [2:0] ID_EX_ALUSrcB;
	input MEM_WB_RegWrite;
	input [4:0] MEM_WB_Rt;
	input [4:0] MEM_WB_Rd;
	input [4:0] EX_MEM_Rt;
	input [4:0] EX_MEM_Rd;
	input [4:0] ID_EX_Rs;
	input [4:0] ID_EX_Rt;
	output reg [1:0] ForwardA;
	output reg [1:0] ForwardB;
	
	always@(*)
		begin
		$display("EX_MEM_RegWrite = %x    ID_EX_ALUSrcA = %x  MEM_WB_RegWrite = %x    EX_MEM_Rt = %x    ID_EX_Rs = %x", EX_MEM_RegWrite, ID_EX_ALUSrcA, MEM_WB_RegWrite, EX_MEM_Rt, ID_EX_Rs);
		if((EX_MEM_RegWrite && (ID_EX_ALUSrcA == 2'b01) && (EX_MEM_Rd != 5'd0) && (EX_MEM_Rd == ID_EX_Rs)) || (EX_MEM_RegWrite && (ID_EX_ALUSrcA == 2'b01) && (EX_MEM_Rt != 5'd0) && (EX_MEM_Rt == ID_EX_Rs)))
			begin
			ForwardA = 2'b10;
			end
		else if((MEM_WB_RegWrite && (ID_EX_ALUSrcA == 2'b01) && (MEM_WB_Rd != 5'd0) && (MEM_WB_Rd == ID_EX_Rs)) || (MEM_WB_RegWrite && (ID_EX_ALUSrcA == 2'b01) && (MEM_WB_Rt != 5'd0) && (MEM_WB_Rt == ID_EX_Rs)))
			begin
			ForwardA = 2'b01;
			end
		else
			begin
			ForwardA = 2'b00;
			end
		$display("ForwardA = %x", ForwardA);
		end
		
	always@(*)
		begin
		$display("EX_MEM_RegWrite = %x    ID_EX_ALUSrcB = %x  MEM_WB_RegWrite = %x    EX_MEM_Rt = %x    EX_MEM_Rd = %x    ID_EX_Rt = %x", EX_MEM_RegWrite, ID_EX_ALUSrcB, MEM_WB_RegWrite, EX_MEM_Rt, EX_MEM_Rd, ID_EX_Rt);
		if((EX_MEM_RegWrite && (ID_EX_ALUSrcB == 3'b00) && (EX_MEM_Rd != 5'd0) && (EX_MEM_Rd == ID_EX_Rt))  || (EX_MEM_RegWrite && (ID_EX_ALUSrcB == 3'b00) && (EX_MEM_Rt != 5'd0) && (EX_MEM_Rt == ID_EX_Rt)))
			begin
			ForwardB = 2'b10;
			end
		else if((MEM_WB_RegWrite && (ID_EX_ALUSrcB == 3'b00) && (MEM_WB_Rd != 5'd0) && (MEM_WB_Rd == ID_EX_Rt)) || (MEM_WB_RegWrite && (ID_EX_ALUSrcB == 3'b00) && (MEM_WB_Rt != 5'd0) && (MEM_WB_Rt == ID_EX_Rt)))
			begin
			ForwardB = 2'b01;
			end
		else
			begin
			ForwardB = 2'b00;
			end
		$display("ForwardB = %x", ForwardB);
		end
endmodule