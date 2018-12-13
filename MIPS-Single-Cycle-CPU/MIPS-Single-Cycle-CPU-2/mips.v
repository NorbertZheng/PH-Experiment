`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Datapath//ALU.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Datapath//DM.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Datapath//EXT.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Datapath//IM.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Datapath//PC.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Datapath//RF.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Generatic//mux.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Generatic//flopr.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Define//instruction_def.v"
`include "C://Users//Think//Desktop//MIPS-Single-Cycle-CPU-2//Control//ctrl.v"
module mips(clk, rst_n);
	input clk;
	input rst_n;
	
	//PC
	wire [31:0] PC_i;
	wire [31:0] PC_o;
	wire PCWr;
	PC m_PC(.clk(clk), .PCWr(PCWr), .PC_i(PC_i), .PC_o(PC_o));
	
	//PC_plus4
	wire [31:0] PC_plus4;
	ALU m_PC_plus4(.aluop_i(2'b00), .src0_i(PC_o), .src1_i(32'd4), .zero_o(), .aluout_o(PC_plus4));
	
	//Instruction_memory
	wire [31:0] Instruction;
	IM m_Instruction_memory(.addr_i(PC_o[13:2]), .dout_o(Instruction));
	
	//Control
	wire Zero;
	wire Bsel;
	wire RFWr;
	wire DMWr;
	wire IRWr;
	wire [1:0] WDSel;
	wire [1:0] NPCOp;
	wire [1:0] EXTOp;
	wire [1:0] ALUOp;
	wire [1:0] GPRSel;
	ctrl m_Control(.OP(Instruction[31:26]), .Funct(Instruction[5:0]), .Zero(Zero), .BSel(BSel), .WDSel(WDSel), .RFWr(RFWr), .DMWr(DMWr), .NPCOp(NPCOp), .EXTOp(EXTOp), .ALUOp(ALUOp), .PCWr(PCWr), .IRWr(IRWr), .GPRSel(GPRSel));
	
	
	//GPRSel_Mux
	wire [4:0] Write_register;
	mux #(2, 5) m_GPRSel_Mux(.s(GPRSel), .y(Write_register), .d0(Instruction[15:11]), .d1(Instruction[20:16]), .d2(5'h1F), .d3(5'b0));
	
	//Registers
	wire [31:0] Write_data;
	wire [31:0] Read_data1;
	wire [31:0] Read_data2;
	RF m_Registers(.clk(clk), .we(RFWr), .ra0_i(Instruction[25:21]), .ra1_i(Instruction[20:16]), .wa_i(Write_register), .wd_i(Write_data), .rd0_o(Read_data1), .rd1_o(Read_data2));
	
	//EXT
	wire [31:0] extendedImm;
	EXT m_EXT(.EXTOp(EXTOp), .Imm16(Instruction[15:0]), .Imm32(extendedImm));
	
	//Bsel_Mux
	wire [31:0] src1_i;
	mux #(1, 32) m_BSel_Mux(.s(BSel), .y(src1_i), .d0(Read_data2), .d1(extendedImm), .d2(32'b0), .d3(32'b0));
	
	//ALU
	wire [31:0] ALU_result;
	ALU m_ALU(.aluop_i(ALUOp), .src0_i(Read_data1), .src1_i(src1_i), .zero_o(Zero), .aluout_o(ALU_result));
	
	//Data_memory
	wire [31:0] Read_data;
	DM m_Data_memory(.clk(clk), .DMWr(DMWr), .addr_i(ALU_result[11:2]), .din_i(Read_data2), .dout_o(Read_data));
	
	//WDSel_Mux
	mux #(2, 32) m_WDSel_Mux(.s(WDSel), .y(Write_data), .d0(ALU_result), .d1(Read_data), .d2(PC_plus4), .d3(32'b0));
	
	//PC_branch
	wire [31:0] PC_branch;
	ALU m_PC_branch(.aluop_i(2'b00), .src0_i(PC_plus4), .src1_i(extendedImm << 2), .zero_o(), .aluout_o(PC_branch));
	
	//PC_jump
	wire [31:0] PC_jump;
	assign PC_jump = {PC_plus4[31:28], Instruction[25:0], 2'b00};
	
	//NPCOp_Mux
	wire [1:0] isBranch;
	assign isBranch = (NPCOp == 2'b01) ? (NPCOp & Zero) : NPCOp;
	always@(Zero)
		$display("Zero  %x", Zero);
	mux #(2, 32) m_NPCOp_Mux(.s(isBranch), .y(PC_i), .d0(PC_plus4), .d1(PC_branch), .d2(PC_jump), .d3(32'b0));
endmodule