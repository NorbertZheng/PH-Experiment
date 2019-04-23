`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//ALU.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//BE.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//Branch_Or_Jump.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//BranchAdd.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//dm.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//im.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//LoadBE.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//PC.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//PCIncrement.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Datapath//Registers.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//EXT.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//flopr.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Generatic//Mux.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Control//Control.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Control//Forwarding_unit.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Control//Hazard_detection_unit.v"
`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
module Mips(clk, reset, INT, INT_ACK);
	input clk;
	input reset;
	input INT;
	output INT_ACK;
	
	// PC_Mux
	wire [1:0] PC_Mux_select;
	wire [31:0] ID_EX_PCplus4_data;
	wire [31:0] ALU_result;
	wire [31:0] PC_Mux_data;
	wire [31:0] PCplus4;
	Mux3T1 #(32, 2) m_PC_Mux(
		.s(PC_Mux_select), 
		.y(PC_Mux_data), 
		.d0(PCplus4), 
		.d1(ID_EX_PCplus4_data), 
		.d2(ALU_result)
	);	// 这里是从PC+4、NotBranchPC和JumpPC中选择即将作为PC_i的地址
	
	// EPC_Mux
	wire [31:0] CR_Read_Data;
	wire EPC_Selected;
	wire [31:0] PC_i;
	Mux2T1 #(32, 1) m_EPC_Mux(
		.s(EPC_Selected), 
		.y(PC_i), 
		.d0(PC_Mux_data), 
		.d1(CR_Read_Data)
	);		// 我们认定EPC_selected具有更高的优先级
	
	// PC
	wire [31:0] PC_o;
	wire PC_Write;
	PC m_PC(
		.clk(clk), 
		.reset(reset), 
		.write_next(PC_Write), 
		.PC_i(PC_i), 
		.PC_o(PC_o)
	);
	
	// IMPC_Mux
	wire [31:0] branchPC;
	wire IMPC_Mux_select;
	wire [31:0] IMPC_Mux_data;
	Mux2T1 #(32, 1) m_IMPC_Mux(
		.s(IMPC_Mux_select), 
		.y(IMPC_Mux_data), 
		.d0(PC_o), 
		.d1(branchPC)
	);	// 如果EX阶段的EPC_selected信号有效，但ID阶段为branch指令，PC_out的实际值会不一样，但是无所谓了，EX阶段已经IF_ID_Flush了
	
	// Instruction_Memory
	wire [31:0] Instruction;
	im_4k m_Instruction_Memory(
		.addr(IMPC_Mux_data[11:2]), 
		.dout(Instruction)
	);
	
	// PCIncrement
	PCIncrement m_PCIncrement(
		.PC_o(IMPC_Mux_data), 
		.PCplus4(PCplus4)
	);
	
	/****************************************/
	/*                                      */
	/*                IF/ID                 */
	/*                                      */
	/****************************************/
	wire IF_ID_Stall_Hazard;
	wire IF_ID_Stall;
	assign IF_ID_Stall = IF_ID_Stall_Hazard;
	wire IF_ID_Flush_Hazard;
	wire IF_ID_Flush;
	wire IF_ID_Flush_CoPR0;
	assign IF_ID_Flush = IF_ID_Flush_Hazard || IF_ID_Flush_CoPR0;
	always@(*)
		begin
		$display("IF_ID_Flush_CoPR0 = 0x%8X, IF_ID_Flush_Hazard = 0x%8X", IF_ID_Flush_CoPR0, IF_ID_Flush_Hazard);
		end
	wire [31:0] IF_ID_PCplus4_data;
	wire [31:0] IF_ID_Instruction_data;
	IF_ID_REG m_IF_ID_REG(
		.clk(clk), 
		.reset(reset), 
		.IF_ID_Stall(IF_ID_Stall), 
		.IF_ID_Flush(IF_ID_Flush), 
		.PCplus4(PCplus4), 
		.IF_ID_PCplus4_data(IF_ID_PCplus4_data), 
		.Instruction(Instruction), 
		.IF_ID_Instruction_data(IF_ID_Instruction_data)
	);
	
	// Control
	wire [1:0] RegDst;
	wire RegWrite;
	wire [1:0] ALUSrcA;
	wire [2:0] ALUSrcB;
	wire [5:0] ALUOp;
	wire [1:0] ChangeType;
	wire MemRead;
	wire MemWrite;
	wire [1:0] MemtoReg;
	wire [1:0] StoreType;
	wire [2:0] LoadType;
	wire Reverse;
	wire syscall;
	wire eret;
	wire RI;
	wire CR_Read;
	wire CR_Write;
	Control m_Control(
		.clk(clk), 
		.reset(reset), 
		.Op(IF_ID_Instruction_data[31:26]), 
		.Funct(IF_ID_Instruction_data[5:0]), 
		.Rs(IF_ID_Instruction_data[25:21]), 
		.Rt(IF_ID_Instruction_data[20:16]), 
		.RegDst(RegDst), 
		.RegWrite(RegWrite), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.ALUOp(ALUOp), 
		.ChangeType(ChangeType),
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.MemtoReg(MemtoReg), 
		.StoreType(StoreType), 
		.LoadType(LoadType), 
		.Reverse(Reverse), 
		.IMPC_Mux_select(IMPC_Mux_select), 
		.syscall(syscall), 
		.eret(eret), 
		.RI(RI),
		.CR_Read(CR_Read),
		.CR_Write(CR_Write)
	);
	
	// Sign_Extend
	wire [31:0] signExtendedOffset;
	EXT m_Sign_Extend(
		.EXTOp(`ArithmeticEXT), 
		.Imm16(IF_ID_Instruction_data[15:0]), 
		.Imm32(signExtendedOffset)
	);
	
	// Logic_Extend
	wire [31:0] logicExtendedOffset;
	EXT m_Logic_Extend(
		.EXTOp(`LogicEXT), 
		.Imm16(IF_ID_Instruction_data[15:0]), 
		.Imm32(logicExtendedOffset)
	);
	
	// BranchAdd
	BranchAdd m_BranchAdd(
		.PCplus4(IF_ID_PCplus4_data), 
		.signEXTOffset(signExtendedOffset), 
		.branchPC(branchPC)
	);
	
	//Registers
	wire MEM_WB_RegWrite_data;
	wire [4:0] Write_register;
	wire [31:0] Write_data;
	wire [31:0] Read_data1;
	wire [31:0] Read_data2;
	Registers m_Registers(
		.clk(clk), 
		.reset(reset),
		.RegWrite(MEM_WB_RegWrite_data), 
		.Read_register1(IF_ID_Instruction_data[25:21]), 
		.Read_register2(IF_ID_Instruction_data[20:16]), 
		.Write_register(Write_register), 
		.Write_data(Write_data), 
		.Read_data1(Read_data1), 
		.Read_data2(Read_data2)
	);
	
	// Hazard_detection_unit
	wire [1:0] branch_Or_Jump;
	wire ID_EX_MemRead_data;
	wire [31:0] ID_EX_Instruction_data;
	wire ID_EX_Flush_Hazard;
	Hazard_detection_unit m_Hazard_detection_unit(
		.branch_Or_Jump(branch_Or_Jump), 
		.ID_EX_MemRead(ID_EX_MemRead_data), 
		.ID_EX_Rt(ID_EX_Instruction_data[20:16]), 
		.IF_ID_Rs(IF_ID_Instruction_data[25:21]), 
		.IF_ID_Rt(IF_ID_Instruction_data[20:16]), 
		.IF_ID_Stall(IF_ID_Stall_Hazard), 
		.PC_Write(PC_Write), 
		.PC_Mux_select(PC_Mux_select), 
		.IF_ID_Flush(IF_ID_Flush_Hazard), 
		.ID_EX_Flush(ID_EX_Flush_Hazard)
	);
	
	/****************************************/
	/*                                      */
	/*                ID/EX                 */
	/*                                      */
	/****************************************/
	wire ID_EX_Stall;
	assign ID_EX_Stall = `DISABLE;
	wire ID_EX_Flush;
	wire ID_EX_Flush_CoPR0;
	assign ID_EX_Flush = (INT) ? `DISABLE : (ID_EX_Flush_Hazard || ID_EX_Flush_CoPR0);
	wire [31:0] ID_EX_Read_data1_data;
	wire [31:0] ID_EX_Read_data2_data;
	wire [31:0] ID_EX_Sign_Extend_data;
	wire [31:0] ID_EX_Logic_Extend_data;
	wire [1:0] ID_EX_RegDst_data;
	wire ID_EX_RegWrite_data;
	wire [1:0] ID_EX_ALUSrcA_data;
	wire [2:0] ID_EX_ALUSrcB_data;
	wire [5:0] ID_EX_ALUOp_data;
	wire [1:0] ID_EX_ChangeType_data;
	wire ID_EX_MemWrite_data;
	wire [1:0] ID_EX_MemtoReg_data;
	wire [1:0] ID_EX_StoreType_data;
	wire [2:0] ID_EX_LoadType_data;
	wire ID_EX_Reverse_data;
	wire ID_EX_syscall_data;
	wire ID_EX_eret_data;
	wire ID_EX_RI_data;
	wire ID_EX_CR_Read_data;
	wire ID_EX_CR_Write_data;
	ID_EX_REG m_ID_EX_REG(
		.clk(clk), 
		.reset(reset), 
		.ID_EX_Stall(ID_EX_Stall), 
		.ID_EX_Flush(ID_EX_Flush), 
		.Instruction(IF_ID_Instruction_data), 
		.ID_EX_Instruction_data(ID_EX_Instruction_data), 
		.PCplus4(IF_ID_PCplus4_data), 
		.ID_EX_PCplus4_data(ID_EX_PCplus4_data), 
		.Read_data1(Read_data1), 
		.ID_EX_Read_data1_data(ID_EX_Read_data1_data), 
		.Read_data2(Read_data2), 
		.ID_EX_Read_data2_data(ID_EX_Read_data2_data), 
		.Sign_Extend(signExtendedOffset), 
		.ID_EX_Sign_Extend_data(ID_EX_Sign_Extend_data), 
		.Logic_Extend(logicExtendedOffset), 
		.ID_EX_Logic_Extend_data(ID_EX_Logic_Extend_data), 
		.RegDst(RegDst), 
		.ID_EX_RegDst_data(ID_EX_RegDst_data), 
		.RegWrite(RegWrite), 
		.ID_EX_RegWrite_data(ID_EX_RegWrite_data), 
		.ALUSrcA(ALUSrcA), 
		.ID_EX_ALUSrcA_data(ID_EX_ALUSrcA_data), 
		.ALUSrcB(ALUSrcB), 
		.ID_EX_ALUSrcB_data(ID_EX_ALUSrcB_data), 
		.ALUOp(ALUOp), 
		.ID_EX_ALUOp_data(ID_EX_ALUOp_data), 
		.ChangeType(ChangeType), 
		.ID_EX_ChangeType_data(ID_EX_ChangeType_data), 
		.MemRead(MemRead), 
		.ID_EX_MemRead_data(ID_EX_MemRead_data), 
		.MemWrite(MemWrite), 
		.ID_EX_MemWrite_data(ID_EX_MemWrite_data), 
		.MemtoReg(MemtoReg), 
		.ID_EX_MemtoReg_data(ID_EX_MemtoReg_data), 
		.StoreType(StoreType), 
		.ID_EX_StoreType_data(ID_EX_StoreType_data), 
		.LoadType(LoadType), 
		.ID_EX_LoadType_data(ID_EX_LoadType_data), 
		.Reverse(Reverse), 
		.ID_EX_Reverse_data(ID_EX_Reverse_data), 
		.syscall(syscall), 
		.ID_EX_syscall_data(ID_EX_syscall_data), 
		.eret(eret), 
		.ID_EX_eret_data(ID_EX_eret_data), 
		.RI(RI), 
		.ID_EX_RI_data(ID_EX_RI_data),
		.CR_Read(CR_Read),
		.ID_EX_CR_Read_data(ID_EX_CR_Read_data),
		.CR_Write(CR_Write),
		.ID_EX_CR_Write_data(ID_EX_CR_Write_data)
	);
	
	// ALUSrcA_Mux
	wire [31:0] ALUSrcA_Mux_data;
	Mux4T1 #(32, 2) m_ALUSrcA_Mux(
		.s(ID_EX_ALUSrcA_data), 
		.y(ALUSrcA_Mux_data), 
		.d0(32'b0), 
		.d1(ID_EX_Read_data1_data), 
		.d2({27'b0, ID_EX_Instruction_data[10:6]}), 
		.d3(ID_EX_PCplus4_data)
	);
	
	// ALUSrcB_Mux
	wire [31:0] targetPCPre;
	wire [31:0] ALUSrcB_Mux_data;
	assign targetPCPre = {4'b0, (ID_EX_Instruction_data[25:0] << 2)};
	Mux8T1 #(32, 3) m_ALUSrcB_Mux(
		.s(ID_EX_ALUSrcB_data), 
		.y(ALUSrcB_Mux_data), 
		.d0(ID_EX_Read_data2_data), 
		.d1(32'd4), 
		.d2(ID_EX_Sign_Extend_data), 
		.d3((ID_EX_Sign_Extend_data << 2)), 
		.d4(ID_EX_Logic_Extend_data), 
		.d5(32'b0), 
		.d6(targetPCPre), 
		.d7(32'b0)
	);
	
	// ForwardA_Mux
	wire [1:0] ForwardA;
	wire [31:0] src0;
	wire [31:0] EX_MEM_ALU_result_data;
	Mux3T1 #(32, 2) m_ForwardA_Mux(
		.s(ForwardA), 
		.y(src0), 
		.d0(ALUSrcA_Mux_data), 
		.d1(Write_data), 
		.d2(EX_MEM_ALU_result_data)
	);
	
	// FrowardB_Mux
	wire [1:0] ForwardB;
	wire [31:0] src1;
	Mux3T1 #(32, 2) m_ForwardB_Mux(
		.s(ForwardB), 
		.y(src1), 
		.d0(ALUSrcB_Mux_data), 
		.d1(Write_data), 
		.d2(EX_MEM_ALU_result_data)
	);
	
	// FrowardC_Mux
	wire [1:0] ForwardC;
	wire [31:0] ForwardC_data;
	Mux3T1 #(32, 2) m_ForwardC_Mux(
		.s(ForwardC), 
		.y(ForwardC_data), 
		.d0(ID_EX_Read_data2_data), 
		.d1(Write_data), 
		.d2(EX_MEM_ALU_result_data)
	);
	
	// FrowardD_Mux
	wire [1:0] ForwardD;
	wire [31:0] ForwardD_data;
	Mux3T1 #(32, 2) m_ForwardD_Mux(
		.s(ForwardD), 
		.y(ForwardD_data), 
		.d0(ID_EX_Read_data2_data), 
		.d1(Write_data), 
		.d2(EX_MEM_ALU_result_data)
	);
	
	// ALU
	wire Ov;
	wire Zero;
	ALU m_ALU(
		.clk(clk), 
		.reset(reset),
		.ALU_control(ID_EX_ALUOp_data), 
		.src0(src0), 
		.src1(src1), 
		.Zero(Zero), 
		.ALU_result(ALU_result), 
		.Ov(Ov)
	);
	
	// Exc_Detector
	wire [1:0] ExcCode;
	Exc_Detector m_Exc_Detector(
		.RI(ID_EX_RI_data), 
		.Ov(Ov), 
		.ExcCode(ExcCode)
	);
	
	//Branch_Or_Jump
	Branch_Or_Jump m_Branch_Or_Jump(
		.Reverse(ID_EX_Reverse_data), 
		.branchZero(Zero), 
		.ChangeType(ID_EX_ChangeType_data), 
		.branch_Or_Jump(branch_Or_Jump)
	);
	
	//Forwarding_unit
	wire [1:0] EX_MEM_RegDst_data;
	wire EX_MEM_RegWrite_data;
	wire [1:0] MEM_WB_RegDst_data;
	wire [31:0] EX_MEM_Instruction_data;
	wire [31:0] MEM_WB_Instruction_data;
	Forwarding_unit m_Forwarding_unit(
		.ID_EX_Instruction(ID_EX_Instruction_data), 
		.EX_MEM_Instruction(EX_MEM_Instruction_data), 
		.MEM_WB_Instruction(MEM_WB_Instruction_data), 
		.ForwardA(ForwardA), 
		.ForwardB(ForwardB), 
		.ForwardC(ForwardC),
		.ForwardD(ForwardD)
	);
	
	// CoPR0
	wire [1:0] EX_MEM_ExcCode_data;
	wire Data_Selected;
	wire EX_MEM_Flush_CoPR0;
	wire MEM_WB_Flush_CoPR0;
	CoPR0 m_CoPR0(
		.clk(clk), 
		.reset(reset), 
		.INT(INT), 
		.INT_ACK(INT_ACK), 
		.CR_Read(ID_EX_CR_Read_data), 
		.CR_Write(ID_EX_CR_Write_data), 
		.CR_Addr(ID_EX_Instruction_data[15:11]), 
		.syscall(syscall), 
		.eret(eret), 
		.ExcCode(EX_MEM_ExcCode_data), 
		.PCPluse4(ID_EX_PCplus4_data), 
		.CR_Write_Data(ForwardD_data), 
		.CR_Read_Data(CR_Read_Data), 
		.EPC_Selected(EPC_Selected), 
		.Data_Selected(Data_Selected), 
		.IF_ID_Flush(IF_ID_Flush_CoPR0), 
		.ID_EX_Flush(ID_EX_Flush_CoPR0), 
		.EX_MEM_Flush(EX_MEM_Flush_CoPR0), 
		.MEM_WB_Flush(MEM_WB_Flush_CoPR0)
	);
	always@(*)
		begin
		$display("ID_EX_PCplus4_data = 0x%8X", ID_EX_PCplus4_data);
		$display("IF_ID_Flush_CoPR0 = 0x%1X, ID_EX_Flush_CoPR0 = 0x%1X, EX_MEM_Flush_CoPR0 = 0x%1X, MEM_WB_Flush_CoPR0 = 0x%1X", IF_ID_Flush_CoPR0, ID_EX_Flush_CoPR0, EX_MEM_Flush_CoPR0, MEM_WB_Flush_CoPR0);
		end
	// CR_Read_data_Mux
	wire [31:0] CR_Read_data_Mux_data;
	Mux2T1 m_CR_Read_data_Mux(
		.s(Data_Selected), 
		.y(CR_Read_data_Mux_data), 
		.d0(ALU_result), 
		.d1(CR_Read_Data)
	);
	
	/****************************************/
	/*                                      */
	/*               EX/MEM                 */
	/*                                      */
	/****************************************/
	wire EX_MEM_Stall;
	assign EX_MEM_Stall = `DISABLE;
	wire EX_MEM_Flush;
	assign EX_MEM_Flush = EX_MEM_Flush_CoPR0;
	wire [31:0] EX_MEM_PCplus4_data;
	wire [31:0] EX_MEM_Memory_Write_data_data;
	wire EX_MEM_MemRead_data;
	wire EX_MEM_MemWrite_data;
	wire [1:0] EX_MEM_MemtoReg_data;
	wire [1:0] EX_MEM_StoreType_data;
	wire [2:0] EX_MEM_LoadType_data;
	EX_MEM_REG m_EX_MEM_REG(
		.clk(clk), 
		.reset(reset), 
		.EX_MEM_Stall(EX_MEM_Stall), 
		.EX_MEM_Flush(EX_MEM_Flush), 
		.Instruction(ID_EX_Instruction_data), 
		.EX_MEM_Instruction_data(EX_MEM_Instruction_data), 
		.PCplus4(ID_EX_PCplus4_data), 
		.EX_MEM_PCplus4_data(EX_MEM_PCplus4_data), 
		.Memory_Write_data(ForwardC_data), 
		.EX_MEM_Memory_Write_data_data(EX_MEM_Memory_Write_data_data), 
		.ALU_result(CR_Read_data_Mux_data),				//.ALU_result(ALU_result), !!!为了与RegDst = 2`b00相对应，采取了这个折中办法
		.EX_MEM_ALU_result_data(EX_MEM_ALU_result_data), 
		.RegDst(ID_EX_RegDst_data), 
		.EX_MEM_RegDst_data(EX_MEM_RegDst_data), 
		.RegWrite(ID_EX_RegWrite_data), 
		.EX_MEM_RegWrite_data(EX_MEM_RegWrite_data), 
		.MemRead(ID_EX_MemRead_data), 
		.EX_MEM_MemRead_data(EX_MEM_MemRead_data), 
		.MemWrite(ID_EX_MemWrite_data), 
		.EX_MEM_MemWrite_data(EX_MEM_MemWrite_data), 
		.MemtoReg(ID_EX_MemtoReg_data), 
		.EX_MEM_MemtoReg_data(EX_MEM_MemtoReg_data), 
		.StoreType(ID_EX_StoreType_data), 
		.EX_MEM_StoreType_data(EX_MEM_StoreType_data), 
		.LoadType(ID_EX_LoadType_data), 
		.EX_MEM_LoadType_data(EX_MEM_LoadType_data), 
		.ExcCode(ExcCode), 
		.EX_MEM_ExcCode_data(EX_MEM_ExcCode_data)
	);
	
	//BE
	wire [3:0] be;
	BE m_BE(
		.StoreType(EX_MEM_StoreType_data), 
		.ALUOut(EX_MEM_ALU_result_data[1:0]), 
		.be(be)
	);
	
	//Data_Memory
	wire [31:0] MemData;
	dm_4k m_Data_Memory(
		.addr(EX_MEM_ALU_result_data[11:2]), 
		.be(be), 
		.din(EX_MEM_Memory_Write_data_data), 
		.DMWr(EX_MEM_MemWrite_data), 
		.clk(clk), 
		.dout(MemData)
	);
	
	//LoadBE
	wire [31:0] LoadBE_data;
	LoadBE m_LoadBE(
		.LoadType(EX_MEM_LoadType_data), 
		.ALUOut(EX_MEM_ALU_result_data[1:0]), 
		.MemData_i(MemData), 
		.MemData_o(LoadBE_data)
	);
	
	/****************************************/
	/*                                      */
	/*               MEM/WB                 */
	/*                                      */
	/****************************************/
	wire MEM_WB_Stall;
	assign MEM_WB_Stall = `DISABLE;
	wire MEM_WB_Flush;
	assign MEM_WB_Flush = MEM_WB_Flush_CoPR0;
	wire [31:0] MEM_WB_PCplus4_data;
	wire [31:0] MEM_WB_ALU_result_data;
	wire [31:0] MEM_WB_MemData_data;
	wire [1:0] MEM_WB_MemtoReg_data;
	MEM_WB_REG m_MEM_WB_REG(
		.clk(clk), 
		.reset(reset), 
		.MEM_WB_Stall(MEM_WB_Stall), 
		.MEM_WB_Flush(MEM_WB_Flush), 
		.Instruction(EX_MEM_Instruction_data), 
		.MEM_WB_Instruction_data(MEM_WB_Instruction_data), 
		.PCplus4(EX_MEM_PCplus4_data), 
		.MEM_WB_PCplus4_data(MEM_WB_PCplus4_data), 
		.ALU_result(EX_MEM_ALU_result_data), 
		.MEM_WB_ALU_result_data(MEM_WB_ALU_result_data), 
		.MemData(MemData), 
		.MEM_WB_MemData_data(MEM_WB_MemData_data), 
		.RegDst(EX_MEM_RegDst_data), 
		.MEM_WB_RegDst_data(MEM_WB_RegDst_data), 
		.RegWrite(EX_MEM_RegWrite_data), 
		.MEM_WB_RegWrite_data(MEM_WB_RegWrite_data), 
		.MemtoReg(EX_MEM_MemtoReg_data), 
		.MEM_WB_MemtoReg_data(MEM_WB_MemtoReg_data)
	);
	
	// MemtoReg_Mux
	Mux3T1 #(32, 2) m_MemtoReg_Mux(
		.s(MEM_WB_MemtoReg_data), 
		.y(Write_data), 
		.d0(MEM_WB_ALU_result_data), 
		.d1(MEM_WB_MemData_data), 
		.d2(MEM_WB_PCplus4_data)
	);
	
	// RegDst_Mux
	Mux3T1 #(5, 2) m_RegDst_Mux(
		.s(MEM_WB_RegDst_data), 
		.y(Write_register), 
		.d0(MEM_WB_Instruction_data[20:16]), 
		.d1(MEM_WB_Instruction_data[15:11]), 
		.d2(5'b11111)
	);
endmodule