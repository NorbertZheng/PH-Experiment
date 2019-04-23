/****************************************/
/*                                      */
/*            Load & Store              */
/*                                      */
/****************************************/
//lb
`define lb_opcode 6'h20

//lbu
`define lbu_opcode 6'h24

//lh
`define lh_opcode 6'h21

//lhu
`define lhu_opcode 6'h25

//lw
`define lw_opcode 6'h23

//sb
`define sb_opcode 6'h28

//sh
`define sh_opcode 6'h29

//sw
`define sw_opcode 6'h2b

/****************************************/
/*                                      */
/*               R型指令                */
/*                                      */
/****************************************/
//R-type
`define R_opcode 6'h0

//add
`define add_funct 6'h20

//addu
`define addu_funct 6'h21

//sub
`define sub_funct 6'h22

//subu
`define subu_funct 6'h23

//sll
`define sll_funct 6'h0

//sllv
`define sllv_funct 6'h4

//sra
`define sra_funct 6'h3

//srav
`define srav_funct 6'h7

//srl
`define srl_funct 6'h2

//srlv
`define srlv_funct 6'h6

//and
`define and_funct 6'h24

//or
`define or_funct 6'h25

//xor
`define xor_funct 6'h26

//nor
`define nor_funct 6'h27

//slt
`define slt_funct 6'h2a

//sltu
`define sltu_funct 6'h2b

/****************************************/
/*                                      */
/*               I型指令                */
/*                                      */
/****************************************/
//addi
`define addi_opcode 6'h8

//addiu
`define addiu_opcode 6'h9

//andi
`define andi_opcode 6'hc

//ori
`define ori_opcode 6'hd

//xori
`define xori_opcode 6'he

//lui
`define lui_opcode 6'hf

//slti
`define slti_opcode 6'ha

//sltiu
`define sltiu_opcode 6'hb

//beq
`define beq_opcode 6'h4

//bgez
`define bgez_opcode 6'h1

//bgtz
`define bgtz_opcode 6'h7

//blez
`define blez_opcode 6'h6

//bltz
`define bltz_opcode 6'h1

//bne
`define bne_opcode 6'h5

/****************************************/
/*                                      */
/*               J型指令                */
/*                                      */
/****************************************/
//j
`define j_opcode 6'h2

//jal
`define jal_opcode 6'h3

//jalr
`define jalr_opcode 6'h0
`define jalr_funct 6'h9

//jr
`define jr_opcode 6'h0
`define jr_funct 6'h8

/****************************************/
/*                                      */
/*              Excp指令                */
/*                                      */
/****************************************/
//syscall
`define syscall_opcode 6'h0
`define syscall_funct 6'hc

//eret
`define eret_opcode 6'h10
`define eret_rs 5'h10
`define eret_funct 6'h18

//mtc0
`define mtc0_opcode 6'h10
`define mtc0_rs 5'h4

//mfc0
`define mfc0_opcode 6'h10
`define mfc0_rs 5'h0