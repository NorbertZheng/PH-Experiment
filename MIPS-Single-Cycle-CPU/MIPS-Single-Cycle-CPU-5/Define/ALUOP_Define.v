/****************************************/
/*                                      */
/*                 NOP                  */
/*                                      */
/****************************************/
//nop
`define ALUOP_NOP   6'd0

/****************************************/
/*                                      */
/*               算术运算               */
/*                                      */
/****************************************/
`define ALUOP_ADD	6'd1
`define ALUOP_ADDU	6'd1

`define ALUOP_SUB	6'd2
`define ALUOP_SUBU	6'd2

`define ALUOP_DIV   6'd3
`define ALUOP_DIVU  6'd4

`define ALUOP_MULT  6'd5
`define ALUOP_MULTU 6'd6

/****************************************/
/*                                      */
/*               逻辑运算               */
/*                                      */
/****************************************/
//Shift
`define ALUOP_SLL	6'd7
`define ALUOP_SLLV	6'd7
`define ALUOP_SRA	6'd8
`define ALUOP_SRAV	6'd8
`define ALUOP_SRL	6'd9
`define ALUOP_SRLV	6'd9

//Logic
`define ALUOP_AND	6'd10
`define ALUOP_OR	6'd11
`define ALUOP_XOR	6'd12
`define ALUOP_NOR	6'd13

//Compare
`define ALUOP_SLT	6'd14
`define ALUOP_SLTU	6'd15
`define ALUOP_SGT	6'd16
`define ALUOP_SGTU	6'd17


//Low->High
`define ALUOP_LUI   6'd18