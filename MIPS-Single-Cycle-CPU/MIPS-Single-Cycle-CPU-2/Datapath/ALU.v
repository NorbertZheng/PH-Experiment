module ALU(aluop_i, src0_i, src1_i, zero_o, aluout_o);
	input [1:0] aluop_i;
	input [31:0] src0_i, src1_i;
	output zero_o;
	output reg [31:0] aluout_o;
	
	assign zero_o = (aluout_o == 0) ? 1'b1 : 1'b0;
	
	always@(*)
		begin
		case(aluop_i)
			2'b00:
				begin
				aluout_o = src0_i + src1_i;
				end
			2'b01:
				begin
				aluout_o = src0_i - src1_i;
				end
			2'b10:
				begin
				aluout_o = src0_i | src1_i;
				end
		endcase
		end
endmodule