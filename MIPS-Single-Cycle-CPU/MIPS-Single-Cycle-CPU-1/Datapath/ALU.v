module ALU(ALU_control, src0, src1, Zero, ALU_result);
	input [3:0] ALU_control;
	input [31:0] src0;
	input [31:0] src1;
	output Zero;
	output reg [31:0] ALU_result;
	
	initial
		begin
		ALU_result = 0;
		end
		
	assign Zero = (ALU_result == 32'b0) ? 1'b1 : 1'b0;
	
	always@(*)
		begin
		case(ALU_control)
			4'b0010:
				begin
				ALU_result = src0 + src1;
				end
			4'b0110:
				begin
				ALU_result = src0 - src1;
				end
			4'b0001:
				begin
				ALU_result = src0 | src1;
				end
		endcase
		end
endmodule