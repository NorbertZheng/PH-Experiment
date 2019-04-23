`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//CoPR0_Define.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
module CoPR0(clk, reset, INT, INT_ACK, CR_Read, CR_Write, CR_Addr, syscall, eret, ExcCode, PCPluse4, CR_Write_Data, CR_Read_Data, EPC_Selected, Data_Selected, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush, MEM_WB_Flush);
	input clk;
	input reset;
	input INT;
	output reg INT_ACK;
	input CR_Read;
	input CR_Write;
	input [4:0] CR_Addr;
	input syscall;
	input eret;
	input [1:0] ExcCode;
	input [31:0] PCPluse4;
	input [31:0] CR_Write_Data;
	output reg [31:0] CR_Read_Data;
	output reg EPC_Selected;
	output reg Data_Selected;
	output reg IF_ID_Flush;
	output reg ID_EX_Flush;
	output reg EX_MEM_Flush;
	output reg MEM_WB_Flush;
	
	reg [1:0] CR_Cause;
	reg [3:0] CR_Status;
	reg [3:0] CR_Pre_Status;
	reg [31:0] CR_EPC;
	reg [31:0] CR_Exc_Vector = 32'h0000_0004;
	
	always@(*)
		begin
		$display("CR_Cause = 0x%1X, CR_Status = 0x%1X, CR_Pre_Status = 0x%1X, CR_EPC = 0x%8X, CR_Exc_Vector = 0x%8X", CR_Cause, CR_Status, CR_Pre_Status, CR_EPC, CR_Exc_Vector);
		end
	
	always@(posedge clk or negedge reset)
		begin
		if(!reset)
			begin
			CR_Cause <= `Int;
			CR_Status <= `None_MASK;
			CR_Pre_Status <= `None_MASK;
			CR_EPC <= 32'b0;
			CR_Read_Data <= 32'b0;
			INT_ACK <= `DISABLE;
			EPC_Selected <= `DISABLE;
			Data_Selected <= `DISABLE;
			IF_ID_Flush <= `DISABLE;
			ID_EX_Flush <= `DISABLE;
			EX_MEM_Flush <= `DISABLE;
			MEM_WB_Flush <= `DISABLE;
			end
		else
			begin
			if((ExcCode != `Int) && (((4'b1 << ExcCode) & CR_Status) !=4'b0))		// 说明从 EX_MEM_REG 传来的ExcCode是属于异常的，且此Excp是被允许的
				begin
				CR_EPC <= PCPluse4 - 32'd4;
				CR_Pre_Status <= CR_Status;
				CR_Status <= `All_MASK;
				CR_Cause <= ExcCode;
				INT_ACK <= `DISABLE;
				CR_Read_Data <= CR_Exc_Vector;
				EPC_Selected <= `ENABLE;
				Data_Selected <= `DISABLE;
				if(ExcCode != `Sys)
					begin
					IF_ID_Flush <= `ENABLE;
					ID_EX_Flush <= `ENABLE;
					EX_MEM_Flush <= `ENABLE;
					MEM_WB_Flush <= `ENABLE;			// 只要发生异常，不是 syscall 该条指令及其之后的指令全部 flush 掉
					end
				end
			else if(syscall && ((CR_Status & ~(`Sys_MASK)) != 4'b0))	// syscall虽然和ExcCode同属于一类，但是返回时会回到 syscall 指令的下一条指令，与其他Excp不同，我们认定其由 ID_EX_REG 阶段过来
				begin										// 注意！！！这里也要判定它没有被屏蔽！！！
				CR_EPC <= PCPluse4;
				CR_Pre_Status <= CR_Status;
				CR_Status <= `All_MASK;
				CR_Cause <= `Sys;
				INT_ACK <= `DISABLE;
				CR_Read_Data <= CR_Exc_Vector;
				EPC_Selected <= `ENABLE;
				Data_Selected <= `DISABLE;
				IF_ID_Flush <= `ENABLE;
				ID_EX_Flush <= `ENABLE;
				EX_MEM_Flush <= `DISABLE;
				MEM_WB_Flush <= `DISABLE;		// 之所以相比其他异常Flush少了两个，是因为它来自的阶段比它们晚一个周期，且写入EPC的是PCPluse4，没有-4
				end
			else if(eret)		// 确定从 EX_MEM_REG 阶段没有传来ExcCode 或者说是被屏蔽掉了之后，就可以探查恰在其之前 ID_EX_REG 阶段的eret信号，确定是否刷新 IF_ID_REG 和 ID_EX_REG
				begin
				CR_EPC <= 32'b0;
				CR_Pre_Status <= 4'b0;
				CR_Status <= CR_Pre_Status;
				CR_Cause <= `Int;
				INT_ACK <= `DISABLE;
				CR_Read_Data <= CR_EPC;
				EPC_Selected <= `ENABLE;
				Data_Selected <= `DISABLE;
				IF_ID_Flush <= `ENABLE;
				ID_EX_Flush <= `ENABLE;		// 因为要return了，PC会改变，eret之后的指令全部作废
				EX_MEM_Flush <= `DISABLE;
				MEM_WB_Flush <= `DISABLE;
				end
			else if(INT && ((CR_Status & ~(`Int_MASK)) != 4'b0))		// 我们认为 INT 的优先级比特权指令mtc0、mfc0更高。因为参考x86的设计，在没有使用cli进行禁止中断的时候，即使使用类似于POPFD等指令，皆会被中断
				begin
				CR_Pre_Status <= CR_Status;
				CR_Status <= `All_MASK;
				CR_Cause <= `Int;
				INT_ACK <= `ENABLE;
				CR_Read_Data <= CR_Exc_Vector;
				EPC_Selected <= `ENABLE;
				Data_Selected <= `DISABLE;
				IF_ID_Flush <= `ENABLE;
				ID_EX_Flush <= `ENABLE;
				if(!CR_Write)
					begin
					CR_EPC <= PCPluse4;		// INT的时候这条指令并没有错，不影响它的正常执行，只是它之后的两条指令会被刷新，IF的PC被在 negedge clk 写入Exc_Vector
					EX_MEM_Flush <= `DISABLE;
					end
				else
					begin
					CR_EPC <= PCPluse4 - 4;	// INT刚好碰上了特权指令，由于INT优先级高，特权指令没有得到实质的执行，需要将其所处阶段 flush
					EX_MEM_Flush <= `ENABLE;
					end
				MEM_WB_Flush <= `DISABLE;
				end
			else if(CR_Write)		// mtc0 写入CR
				begin
				case(CR_Addr)
					`CR_Addr_Cause:
						begin
						CR_Cause <= CR_Write_Data[3:2];
						end
					`CR_Addr_Status:
						begin
						CR_Pre_Status <= CR_Write_Data[7:4];
						CR_Status <= CR_Write_Data[3:0];
						end
					`CR_Addr_EPC:
						begin
						CR_EPC <= CR_Write_Data;
						end
					default:;
				endcase
				INT_ACK <= `DISABLE;
				CR_Read_Data <= 32'b0;
				EPC_Selected <= `DISABLE;
				Data_Selected <= `DISABLE;
				IF_ID_Flush <= `DISABLE;
				ID_EX_Flush <= `DISABLE;
				EX_MEM_Flush <= `DISABLE;
				MEM_WB_Flush <= `DISABLE;
				end
			else if(CR_Read)		// mfc0 读出CR
				begin
				case(CR_Addr)
					`CR_Addr_Cause:
						begin
						CR_Read_Data <= {28'b0, CR_Cause, 2'b0};
						end
					`CR_Addr_Status:
						begin
						CR_Read_Data <= {24'b0, CR_Pre_Status, CR_Status};
						end
					`CR_Addr_EPC:
						begin
						CR_Read_Data <= CR_EPC;
						end
					default:
						begin
						CR_Read_Data <= 32'b0;
						end
				endcase
				INT_ACK <= `DISABLE;
				EPC_Selected <= `DISABLE;
				Data_Selected <= `ENABLE;
				IF_ID_Flush <= `DISABLE;
				ID_EX_Flush <= `DISABLE;
				EX_MEM_Flush <= `DISABLE;
				MEM_WB_Flush <= `DISABLE;
				end
			else
				begin
				CR_Cause <= CR_Cause;
				CR_Status <= CR_Status;
				CR_Pre_Status <= CR_Pre_Status;
				CR_EPC <= CR_EPC;
				CR_Read_Data <= 32'b0;
				INT_ACK <= `DISABLE;
				EPC_Selected <= `DISABLE;
				Data_Selected <= `DISABLE;
				IF_ID_Flush <= `DISABLE;
				ID_EX_Flush <= `DISABLE;
				EX_MEM_Flush <= `DISABLE;
				MEM_WB_Flush <= `DISABLE;
				end
			end
		end
endmodule