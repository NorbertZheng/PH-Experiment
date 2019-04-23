`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-5//Define//ALUOP_Define.v"

module ALU(ALU_control, src0, src1, Zero, ALU_result);
	input [5:0] ALU_control;
	input [31:0] src0;
	input [31:0] src1;
	output Zero;
	output reg [31:0] ALU_result;
	
	integer i;
	
	initial
		begin
		ALU_result = 32'b0;
		end
		
	assign Zero = (ALU_result == 32'b0) ? 1'b1 : 1'b0;
	
	always@(*)
		begin
		case(ALU_control)
			`ALUOP_ADD,
			`ALUOP_ADDU:
				begin
				ALU_result = src0 + src1;
				end
			`ALUOP_SUB,
			`ALUOP_SUBU:
				begin
				ALU_result = src0 - src1;
				end
			`ALUOP_SLL,
			`ALUOP_SLLV:
				begin
				ALU_result = src1 << (src0 % 32);
				end
			`ALUOP_SRA,
			`ALUOP_SRAV:
				begin
				ALU_result = src1 >> (src0 % 32);
				if((src1[31] == 1) && (src0 > 0))
					for(i = 0;i < (src0 % 32);i = i + 1)
						ALU_result[31 - i] = 1;
				end
			`ALUOP_SRL,
			`ALUOP_SRLV:
				begin
				ALU_result = src1 >> (src0 % 32);
				end
			`ALUOP_AND:
				begin
				ALU_result = src0 & src1;
				end
			`ALUOP_OR:
				begin
				ALU_result = src0 | src1;
				end
			`ALUOP_XOR:
				begin
				ALU_result = src0 ^ src1;
				end
			`ALUOP_NOR:
				begin
				ALU_result = ~(src0 | src1);
				end
			`ALUOP_SLT:
				begin
				ALU_result = (((src0 >= src1) && (src0[31] == src1[31])) || (src0[31] < src1[31])) ? 32'd0 : 32'd1;
				end
			`ALUOP_SLTU:
				begin
				ALU_result = (src0 >= src1) ? 32'd0 : 32'd1;
				end
			`ALUOP_SGT:
				begin
				ALU_result = (((src1 >= src0) && (src1[31] == src0[31])) || (src1[31] < src0[31])) ? 32'd0 : 32'd1;
				end
			`ALUOP_SGTU:
				begin
				ALU_result = (src1 >= src0) ? 32'd0 : 32'd1;
				end
			`ALUOP_LUI:
				begin
				ALU_result ={src1[15:0], 16'd0};
				end
			default:
				begin
				ALU_result = 32'b0;
				end
		endcase
		end
endmodule