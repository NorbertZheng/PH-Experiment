`include "./defines.v"
module alu(
	input   [4:0] aluop_i,
	input   [31:0]src0_i,//rs or shamt
	input   [31:0]src1_i,//rd or transformed imm
	output  [63:0]aluout_o,//32位结果使用低32位,hi为高32位，lo为低32位
  
	output  zero_o
	);

	integer i;
	reg [31:0]logic_rlt;
	reg signed [31:0]src0_iS;
	reg signed [31:0]src1_iS;
	reg [31:0]hi;
	reg [31:0]lo;
	//reg [31:0]temp;
	reg [63:0]aluout_oR;
	reg zero_oR;
	assign aluout_o = aluout_oR;
	assign zero_o = zero_oR;
	//logic
	always@(*)
		begin
		case (aluop_i)
			`ALUOP_AND:
				begin
				logic_rlt = src0_i & src1_i;
				$display("%x", logic_rlt);
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_OR:
				begin
				logic_rlt = src0_i | src1_i;
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_NOR:
				begin
				logic_rlt = ~(src0_i | src1_i);
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_LUI:
				begin
				logic_rlt = {src1_i[15:0], 16'd0};
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_ADD:
				begin
				logic_rlt = src0_i + src1_i;
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_SUB:
				begin
				logic_rlt = src0_i - src1_i;
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_SLT:
				begin
				src0_iS = src0_i;
				src1_iS = src1_i;
				if(src0_iS >= src1_iS)
					begin
					zero_oR = 1'd0;
					aluout_oR = {32'd0, 32'd0};
					end
				else
					begin
					zero_oR = 1'd1;
					aluout_oR = {32'd0, 32'd1};
					end
				end
			`ALUOP_SLTU:
				begin
				if(src0_i >= src1_i)
					begin
					zero_oR = 1'd0;
					aluout_oR = {32'd0, 32'd0};
					end
				else
					begin
					zero_oR = 1'd1;
					aluout_oR = {32'd0, 32'd1};
					end
				end
			`ALUOP_MULT:
				begin
				src0_iS = src0_i;
				src1_iS = src1_i;
				aluout_oR = src0_iS * src1_iS;
				$display("%x %x", aluout_oR[63:32], aluout_oR[31:0]);
				end
			`ALUOP_MULTU:
				begin
				aluout_oR = src0_i * src1_i;
				$display("%x %x", aluout_oR[63:32], aluout_oR[31:0]);
				end
			`ALUOP_DIV:
				begin
				src0_iS = src0_i;
				src1_iS = src1_i;
				lo = src0_iS / src1_iS;
				hi = src0_iS % src1_iS;
				//$display("%x %x", hi, lo);
				aluout_oR = {hi, lo};
				end
			`ALUOP_DIVU:
				begin
				lo = src0_i / src1_i;
				hi = src0_i % src1_i;
				//$display("%x %x", hi, lo);
				aluout_oR = {hi, lo};
				end
			`ALUOP_SLL:
				begin
				logic_rlt = src1_i << src0_i;
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_SRL:
				begin
				logic_rlt = src1_i >> src0_i;
				aluout_oR = {32'd0, logic_rlt};
				end
			`ALUOP_SRA:
				begin
				logic_rlt = src1_i >> src0_i;
				if((src1_i[31] == 1) && (src0_i > 0))
					for(i = 0;i < src0_i;i = i + 1)
						logic_rlt[31 - i] = 1;
				aluout_oR = {32'd0, logic_rlt};
				end
			default:
				aluout_oR = {32'd0, 32'd0};
		endcase
		$display("%x %x", aluout_oR[63:32], aluout_oR[31:0]);
		end  
endmodule