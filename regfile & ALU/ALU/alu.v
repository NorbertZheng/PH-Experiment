`include "./defines.v"
module alu(
	input   [4:0] aluop_i,
	input   [31:0]src0_i,//rs or shamt
	input   [31:0]src1_i,//rd or transformed imm
	output  [63:0]aluout_o,//32位结果使用低32位,hi为高32位，lo为低32位
  
	output  zero_o
	);

	integer i;
	reg [31:0]lo;
	reg [31:0]multiplicand_or_divisor;
	reg [64:0]aluout_oR;
	reg zero_oR;
	reg signed [31:0]src0_iS;
	reg signed [31:0]src1_iS;
	
	assign aluout_o = aluout_oR[63:0];
	assign zero_o = zero_oR;
	
	always@(*)
		begin
		case (aluop_i)
			`ALUOP_AND:
				begin
				lo = src0_i & src1_i;
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_OR:
				begin
				lo = src0_i | src1_i;
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_NOR:
				begin
				lo = ~(src0_i | src1_i);
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_LUI:
				begin
				lo = {src1_i[15:0], 16'd0};
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_ADD:
				begin
				lo = src0_i + src1_i;
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_SUB:
				begin
				lo = src0_i - src1_i;
				aluout_oR = {33'd0, lo};
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
				multiplicand_or_divisor = (~src0_i + 1 > src0_i) ? src0_i : (~src0_i + 1);
				aluout_oR = {33'd0, (~src1_i + 1 > src1_i) ? src1_i : (~src1_i + 1)};
				for(i = 0;i < 31;i = i + 1)
					begin
					if(aluout_oR[0])
						begin
						aluout_oR[64:32] = aluout_oR[64:32] + multiplicand_or_divisor;
						end
					aluout_oR = aluout_oR >> 1;
					end
				aluout_oR = aluout_oR >> 1;
				aluout_oR = (src0_i[31] == src1_i[31]) ? aluout_oR[63:0] : (~aluout_oR[63:0] + 1);
				end
			`ALUOP_MULTU:
				begin
				aluout_oR = {33'd0, src1_i};
				for(i = 0;i < 32;i = i + 1)
					begin
					if(aluout_oR[0])
						begin
						aluout_oR[64:32] = aluout_oR[64:32] + src0_i;
						end
					aluout_oR = aluout_oR >> 1;
					end
				end
			`ALUOP_DIV:
				begin
				multiplicand_or_divisor = (~src1_i + 1 > src1_i) ? src1_i : (~src1_i + 1);
				aluout_oR = {33'd0, (~src0_i + 1 > src0_i) ? src0_i : (~src0_i + 1)};
				for(i = 0;i < 33;i = i + 1)
					begin
					if(aluout_oR[64:32] >= multiplicand_or_divisor)
						begin
						if(i != 32)
							begin
							aluout_oR[64:32] = aluout_oR[64:32] - multiplicand_or_divisor;
							aluout_oR = aluout_oR << 1;
							aluout_oR[0] = 1;
							end
						else
							begin
							aluout_oR[64:32] = aluout_oR[64:32] - multiplicand_or_divisor;
							aluout_oR[31:0] = aluout_oR[31:0] << 1;
							aluout_oR[0] = 1;
							end
						end
					else
						begin
						if(i != 32)
							begin
							aluout_oR = aluout_oR << 1;
							aluout_oR[0] = 0;
							end
						else
							begin
							aluout_oR[31:0] = aluout_oR[31:0] << 1;
							aluout_oR[0] = 0;
							end
						end
					end
				aluout_oR[63:32] = (src0_i[31]) ? (~aluout_oR[63:32] + 1) : aluout_oR[63:32];
				aluout_oR[31:0] = ((src0_i[31] != src1_i[31])) ? (~aluout_oR[31:0] + 1) : aluout_oR[31:0];
				end
			`ALUOP_DIVU:
				begin
				aluout_oR = {33'd0, src0_i};
				for(i = 0;i < 33;i = i + 1)
					begin
					if(aluout_oR[64:32] >= src1_i)
						begin
						if(i != 32)
							begin
							aluout_oR[64:32] = aluout_oR[64:32] - src1_i;
							aluout_oR = aluout_oR << 1;
							aluout_oR[0] = 1;
							end
						else
							begin
							aluout_oR[64:32] = aluout_oR[64:32] - src1_i;
							aluout_oR[31:0] = aluout_oR[31:0] << 1;
							aluout_oR[0] = 1;
							end
						end
					else
						begin
						if(i != 32)
							begin
							aluout_oR = aluout_oR << 1;
							aluout_oR[0] = 0;
							end
						else
							begin
							aluout_oR[31:0] = aluout_oR[31:0] << 1;
							aluout_oR[0] = 0;
							end
						end
					end
				end
			`ALUOP_SLL:
				begin
				lo = src1_i << src0_i;
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_SRL:
				begin
				lo = src1_i >> src0_i;
				aluout_oR = {33'd0, lo};
				end
			`ALUOP_SRA:
				begin
				lo = src1_i >> src0_i;
				if((src1_i[31] == 1) && (src0_i > 0))
					for(i = 0;i < src0_i;i = i + 1)
						lo[31 - i] = 1;
				aluout_oR = {33'd0, lo};
				end
			default:
				aluout_oR = {33'd0, 32'd0};
		endcase
		$display("%x %x", aluout_oR[63:32], aluout_oR[31:0]);
		end  
endmodule