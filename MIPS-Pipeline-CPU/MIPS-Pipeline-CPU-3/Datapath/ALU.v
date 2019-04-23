`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//ALUOP_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
module ALU(clk, reset, ALU_control, src0, src1, Zero, ALU_result, Ov);
	input clk;
	input reset;
	input [5:0] ALU_control;
	input [31:0] src0;
	input [31:0] src1;
	output Zero;
	output reg [31:0] ALU_result;
	output reg Ov;
	
	wire signed [31:0] src0_s = $signed(src0);
	wire signed [31:0] src1_s = $signed(src1);
	wire signed [31:0] ALU_result_s = $signed(ALU_result);
	
	assign Zero = (ALU_result == 32'b0) ? 1'b1 : 1'b0;
	
	always@(posedge clk or negedge reset)
		begin
		//$display("src0 = %x    src1 = %x", src0, src1);
		if(!reset)
			begin
			ALU_result <= 32'b0;
			end
		else
			begin
			case(ALU_control)
				// Arithmetic 运算
				`ALUOP_ADD,
				`ALUOP_ADDU:
					begin
					ALU_result <= src0 + src1;
					end
				`ALUOP_SUB,
				`ALUOP_SUBU:
					begin
					ALU_result <= src0 - src1;
					end
				// Logic 运算
				`ALUOP_SLL,
				`ALUOP_SLLV:
					begin
					ALU_result <= src1 << (src0 % 32);
					end
				`ALUOP_SRA,
				`ALUOP_SRAV:
					begin
					ALU_result <= $signed(src1) >> (src0 % 32);
					end
				`ALUOP_SRL,
				`ALUOP_SRLV:
					begin
					ALU_result <= src1 >> (src0 % 32);
					end
				`ALUOP_AND:
					begin
					ALU_result <= src0 & src1;
					end
				`ALUOP_OR:
					begin
					ALU_result <= src0 | src1;
					end
				`ALUOP_XOR:
					begin
					ALU_result <= src0 ^ src1;
					end
				`ALUOP_NOR:
					begin
					ALU_result <= ~(src0 | src1);
					end
				`ALUOP_SLT:
					begin
					ALU_result <= (((src0 >= src1) && (src0[31] == src1[31])) || (src0[31] < src1[31])) ? 32'd0 : 32'd1;
					end
				`ALUOP_SLTU:
					begin
					ALU_result <= (src0 >= src1) ? 32'd0 : 32'd1;
					end
				`ALUOP_SGT:
					begin
					ALU_result <= (((src1 >= src0) && (src1[31] == src0[31])) || (src1[31] < src0[31])) ? 32'd0 : 32'd1;
					end
				`ALUOP_SGTU:
					begin
					ALU_result <= (src1 >= src0) ? 32'd0 : 32'd1;
					end
				`ALUOP_LUI:
					begin
					ALU_result <= {src1[15:0], 16'd0};
					end
				// JUMP 特殊运算
				`ALUOP_JUMP:
					begin
					ALU_result <= {src0[31:28], src1[27:0]};
					end
				default:
					begin
					ALU_result <= 32'b0;
					end
			endcase
			end
		//$display("ALU_result = %x", ALU_result);
		end
		
	always@(posedge clk or negedge reset)
		begin
		if(!reset)
			begin
			Ov <= `DISABLE;
			end
		else
			begin
			case(ALU_control)
				`ALUOP_ADD:
					begin
					if(((src0_s < 32'b0) && (src1_s < 32'b0) && (ALU_result_s > 32'b0)) || ((src0_s > 32'b0) && (src1_s > 32'b0) && (ALU_result_s < 32'b0)))
						begin
						Ov <= `ENABLE;
						end
					else
						begin
						Ov <= `DISABLE;
						end
					end
				`ALUOP_SUB:
					begin
					if(((src0_s < 32'b0) && (src1_s > 32'b0) && (ALU_result_s > 32'b0)) || ((src0_s > 32'b0) && (src1_s < 32'b0) && (ALU_result_s < 32'b0)))
						begin
						Ov <= `ENABLE;
						end
					else
						begin
						Ov <= `DISABLE;
						end
					end
				default:
					begin
					Ov <= `DISABLE;
					end
			endcase
			end
		end
endmodule