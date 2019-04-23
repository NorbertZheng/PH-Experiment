`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Instruction_Define.v"
module Forwarding_unit(ID_EX_Instruction, EX_MEM_Instruction, MEM_WB_Instruction, ForwardA, ForwardB, ForwardC, ForwardD);
	input [31:0] ID_EX_Instruction;
	input [31:0] EX_MEM_Instruction;
	input [31:0] MEM_WB_Instruction;
	output reg [1:0] ForwardA;
	output reg [1:0] ForwardB;
	output reg [1:0] ForwardC;
	output reg [1:0] ForwardD;
	
	always@(*)		// ForwardA ALU_src0的旁路信号，只要操作ALU，该信号就必不可少，除了lui
		begin
		case(ID_EX_Instruction[31:26])
			`R_opcode,
			`jalr_opcode,
			`jr_opcode:
				begin
				case(ID_EX_Instruction[5:0])
					`sll_funct,
					`sra_funct,
					`srl_funct:
						begin
						ForwardA = 2'b00;
						end
					default:
						begin
						case(EX_MEM_Instruction[31:26])
							`R_opcode,
							`jalr_opcode,
							`jr_opcode:
								begin
								case(EX_MEM_Instruction[5:0])
									`jr_funct:
										begin
										ForwardA = 2'b00;		
										end
									default:
										begin
										if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b10;
											end
										else
											begin
											case(MEM_WB_Instruction[31:26])
												`R_opcode,
												`jalr_opcode,
												`jr_opcode:
													begin
													case(MEM_WB_Instruction[5:0])
														`jr_funct:
															begin
															ForwardA = 2'b00;
															end
														default:
															begin
															if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
																begin
																ForwardA = 2'b01;
																end
															else
																begin
																ForwardA = 2'b00;
																end
															end
													endcase
													end
												`addi_opcode,
												`addiu_opcode,
												`andi_opcode,
												`ori_opcode,
												`xori_opcode,
												`lui_opcode,
												`slti_opcode,
												`sltiu_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												`lb_opcode,
												`lbu_opcode,
												`lh_opcode,
												`lhu_opcode,
												`lw_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												`mfc0_opcode:
													begin
													case(MEM_WB_Instruction[25:21])
														`mfc0_rs:
															begin
															if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
																begin
																ForwardA = 2'b01;
																end
															else
																begin
																ForwardA = 2'b00;
																end
															end
														default:
															begin
															ForwardA = 2'b00;
															end
													endcase
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										end
								endcase
								end
							`addi_opcode,
							`addiu_opcode,
							`andi_opcode,
							`ori_opcode,
							`xori_opcode,
							`lui_opcode,
							`slti_opcode,
							`sltiu_opcode:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardA = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								end
							`mfc0_opcode:
								begin
								case(EX_MEM_Instruction[25:21])
									`mfc0_rs:
										begin
										if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b10;
											end
										else
											begin
											case(MEM_WB_Instruction[31:26])
												`R_opcode,
												`jalr_opcode,
												`jr_opcode:
													begin
													case(MEM_WB_Instruction[5:0])
														`jr_funct:
															begin
															ForwardA = 2'b00;
															end
														default:
															begin
															if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
																begin
																ForwardA = 2'b01;
																end
															else
																begin
																ForwardA = 2'b00;
																end
															end
													endcase
													end
												`addi_opcode,
												`addiu_opcode,
												`andi_opcode,
												`ori_opcode,
												`xori_opcode,
												`lui_opcode,
												`slti_opcode,
												`sltiu_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												`lb_opcode,
												`lbu_opcode,
												`lh_opcode,
												`lhu_opcode,
												`lw_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												`mfc0_opcode:
													begin
													case(MEM_WB_Instruction[25:21])
														`mfc0_rs:
															begin
															if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
																begin
																ForwardA = 2'b01;
																end
															else
																begin
																ForwardA = 2'b00;
																end
															end
														default:
															begin
															ForwardA = 2'b00;
															end
													endcase
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										end
									default:
										begin
										case(MEM_WB_Instruction[31:26])
											`R_opcode,
											`jalr_opcode,
											`jr_opcode:
												begin
												case(MEM_WB_Instruction[5:0])
													`jr_funct:
														begin
														ForwardA = 2'b00;
														end
													default:
														begin
														if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
															begin
															ForwardA = 2'b01;
															end
														else
															begin
															ForwardA = 2'b00;
															end
														end
												endcase
												end
											`addi_opcode,
											`addiu_opcode,
											`andi_opcode,
											`ori_opcode,
											`xori_opcode,
											`lui_opcode,
											`slti_opcode,
											`sltiu_opcode:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
											`lb_opcode,
											`lbu_opcode,
											`lh_opcode,
											`lhu_opcode,
											`lw_opcode:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
											`mfc0_opcode:
												begin
												case(MEM_WB_Instruction[25:21])
													`mfc0_rs:
														begin
														if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
															begin
															ForwardA = 2'b01;
															end
														else
															begin
															ForwardA = 2'b00;
															end
														end
													default:
														begin
														ForwardA = 2'b00;
														end
												endcase
												end
											default:
												begin
												ForwardA = 2'b00;
												end
										endcase
										end
								endcase
								end
							default:
								begin
								case(MEM_WB_Instruction[31:26])
									`R_opcode,
									`jalr_opcode,
									`jr_opcode:
										begin
										case(MEM_WB_Instruction[5:0])
											`jr_funct:
												begin
												ForwardA = 2'b00;
												end
											default:
												begin
												if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
										endcase
										end
									`addi_opcode,
									`addiu_opcode,
									`andi_opcode,
									`ori_opcode,
									`xori_opcode,
									`lui_opcode,
									`slti_opcode,
									`sltiu_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									`lb_opcode,
									`lbu_opcode,
									`lh_opcode,
									`lhu_opcode,
									`lw_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									`mfc0_opcode:
										begin
										case(MEM_WB_Instruction[25:21])
											`mfc0_rs:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
											default:
												begin
												ForwardA = 2'b00;
												end
										endcase
										end
									default:
										begin
										ForwardA = 2'b00;
										end
								endcase
								end
						endcase
						end
				endcase
				end
			`addi_opcode,
			`addiu_opcode,
			`andi_opcode,
			`ori_opcode,
			`xori_opcode,
			`lui_opcode,
			`slti_opcode,
			`sltiu_opcode,
			`beq_opcode,
			`bgez_opcode,
			`bgtz_opcode,
			`blez_opcode,
			`bltz_opcode,
			`bne_opcode:
				begin
				case(EX_MEM_Instruction[31:26])
					`R_opcode,
					`jalr_opcode,
					`jr_opcode:
						begin
						case(EX_MEM_Instruction[5:0])
							`jr_funct:
								begin
								ForwardA = 2'b00;
								end
							default:
								begin
								if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardA = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								end
						endcase
						end
					`addi_opcode,
					`addiu_opcode,
					`andi_opcode,
					`ori_opcode,
					`xori_opcode,
					`lui_opcode,
					`slti_opcode,
					`sltiu_opcode:
						begin
						if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[25:21]))
							begin
							ForwardA = 2'b10;
							end
						else
							begin
							$display("I'm in MEM_WB (ForwardA)!");
							case(MEM_WB_Instruction[31:26])
								`R_opcode,
								`jalr_opcode,
								`jr_opcode:
									begin
									$display("I'm in MEM_WB -- R-type (ForwardA)!");
									case(MEM_WB_Instruction[5:0])
										`jr_funct:
											begin
											ForwardA = 2'b00;
											end
										default:
											begin
											if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
									endcase
									end
								`addi_opcode,
								`addiu_opcode,
								`andi_opcode,
								`ori_opcode,
								`xori_opcode,
								`lui_opcode,
								`slti_opcode,
								`sltiu_opcode:
									begin
									$display("I'm in MEM_WB -- I-type (ForwardA)!");
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
										begin
										ForwardA = 2'b01;
										end
									else
										begin
										ForwardA = 2'b00;
										end
									end
								`lb_opcode,
								`lbu_opcode,
								`lh_opcode,
								`lhu_opcode,
								`lw_opcode:
									begin
									$display("I'm in MEM_WB -- Load-type (ForwardA)!");
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
										begin
										ForwardA = 2'b01;
										end
									else
										begin
										ForwardA = 2'b00;
										end
									end
								`mfc0_opcode:
									begin
									case(MEM_WB_Instruction[25:21])
										`mfc0_rs:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								default:
									begin
									ForwardA = 2'b00;
									end
							endcase
							end
						end
					`mfc0_opcode:
						begin
						case(EX_MEM_Instruction[25:21])
							`mfc0_rs:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardA = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								end
							default:
								begin
								case(MEM_WB_Instruction[31:26])
									`R_opcode,
									`jalr_opcode,
									`jr_opcode:
										begin
										case(MEM_WB_Instruction[5:0])
											`jr_funct:
												begin
												ForwardA = 2'b00;
												end
											default:
												begin
												if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
										endcase
										end
									`addi_opcode,
									`addiu_opcode,
									`andi_opcode,
									`ori_opcode,
									`xori_opcode,
									`lui_opcode,
									`slti_opcode,
									`sltiu_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									`lb_opcode,
									`lbu_opcode,
									`lh_opcode,
									`lhu_opcode,
									`lw_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									`mfc0_opcode:
										begin
										case(MEM_WB_Instruction[25:21])
											`mfc0_rs:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
											default:
												begin
												ForwardA = 2'b00;
												end
										endcase
										end
									default:
										begin
										ForwardA = 2'b00;
										end
								endcase
								end
						endcase
						end
					default:
						begin
						case(MEM_WB_Instruction[31:26])
							`R_opcode,
							`jalr_opcode,
							`jr_opcode:
								begin
								case(MEM_WB_Instruction[5:0])
									`jr_funct:
										begin
										ForwardA = 2'b00;
										end
									default:
										begin
										if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
								endcase
								end
							`addi_opcode,
							`addiu_opcode,
							`andi_opcode,
							`ori_opcode,
							`xori_opcode,
							`lui_opcode,
							`slti_opcode,
							`sltiu_opcode:
								begin
								if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b01;
									end
								else
									begin
									ForwardA = 2'b00;
									end
								end
							`lb_opcode,
							`lbu_opcode,
							`lh_opcode,
							`lhu_opcode,
							`lw_opcode:
								begin
								if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b01;
									end
								else
									begin
									ForwardA = 2'b00;
									end
								end
							`mfc0_opcode:
								begin
								case(MEM_WB_Instruction[25:21])
									`mfc0_rs:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									default:
										begin
										ForwardA = 2'b00;
										end
								endcase
								end
							default:
								begin
								ForwardA = 2'b00;
								end
						endcase
						end
				endcase
				end
			`lb_opcode,
			`lbu_opcode,
			`lh_opcode,
			`lhu_opcode,
			`lw_opcode,
			`sb_opcode,
			`sh_opcode,
			`sw_opcode:
				begin
				case(EX_MEM_Instruction[31:26])
					`R_opcode,
					`jalr_opcode,
					`jr_opcode:
						begin
						case(EX_MEM_Instruction[5:0])
							`jr_funct:
								begin
								ForwardA = 2'b00;
								end
							default:
								begin
								if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardA = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								end
						endcase
						end
					`addi_opcode,
					`addiu_opcode,
					`andi_opcode,
					`ori_opcode,
					`xori_opcode,
					`lui_opcode,
					`slti_opcode,
					`sltiu_opcode:
						begin
						if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[25:21]))
							begin
							ForwardA = 2'b10;
							end
						else
							begin
							case(MEM_WB_Instruction[31:26])
								`R_opcode,
								`jalr_opcode,
								`jr_opcode:
									begin
									case(MEM_WB_Instruction[5:0])
										`jr_funct:
											begin
											ForwardA = 2'b00;
											end
										default:
											begin
											if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
									endcase
									end
								`addi_opcode,
								`addiu_opcode,
								`andi_opcode,
								`ori_opcode,
								`xori_opcode,
								`lui_opcode,
								`slti_opcode,
								`sltiu_opcode:
									begin
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
										begin
										ForwardA = 2'b01;
										end
									else
										begin
										ForwardA = 2'b00;
										end
									end
								`lb_opcode,
								`lbu_opcode,
								`lh_opcode,
								`lhu_opcode,
								`lw_opcode:
									begin
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
										begin
										ForwardA = 2'b01;
										end
									else
										begin
										ForwardA = 2'b00;
										end
									end
								`mfc0_opcode:
									begin
									case(MEM_WB_Instruction[25:21])
										`mfc0_rs:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								default:
									begin
									ForwardA = 2'b00;
									end
							endcase
							end
						end
					`mfc0_opcode:
						begin
						case(EX_MEM_Instruction[25:21])
							`mfc0_rs:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardA = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
												begin
												ForwardA = 2'b01;
												end
											else
												begin
												ForwardA = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
														begin
														ForwardA = 2'b01;
														end
													else
														begin
														ForwardA = 2'b00;
														end
													end
												default:
													begin
													ForwardA = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardA = 2'b00;
											end
									endcase
									end
								end
							default:
								begin
								case(MEM_WB_Instruction[31:26])
									`R_opcode,
									`jalr_opcode,
									`jr_opcode:
										begin
										case(MEM_WB_Instruction[5:0])
											`jr_funct:
												begin
												ForwardA = 2'b00;
												end
											default:
												begin
												if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
										endcase
										end
									`addi_opcode,
									`addiu_opcode,
									`andi_opcode,
									`ori_opcode,
									`xori_opcode,
									`lui_opcode,
									`slti_opcode,
									`sltiu_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									`lb_opcode,
									`lbu_opcode,
									`lh_opcode,
									`lhu_opcode,
									`lw_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									`mfc0_opcode:
										begin
										case(MEM_WB_Instruction[25:21])
											`mfc0_rs:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
													begin
													ForwardA = 2'b01;
													end
												else
													begin
													ForwardA = 2'b00;
													end
												end
											default:
												begin
												ForwardA = 2'b00;
												end
										endcase
										end
									default:
										begin
										ForwardA = 2'b00;
										end
								endcase
								end
						endcase
						end
					default:
						begin
						case(MEM_WB_Instruction[31:26])
							`R_opcode,
							`jalr_opcode,
							`jr_opcode:
								begin
								case(MEM_WB_Instruction[5:0])
									`jr_funct:
										begin
										ForwardA = 2'b00;
										end
									default:
										begin
										if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
								endcase
								end
							`addi_opcode,
							`addiu_opcode,
							`andi_opcode,
							`ori_opcode,
							`xori_opcode,
							`lui_opcode,
							`slti_opcode,
							`sltiu_opcode:
								begin
								if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b01;
									end
								else
									begin
									ForwardA = 2'b00;
									end
								end
							`lb_opcode,
							`lbu_opcode,
							`lh_opcode,
							`lhu_opcode,
							`lw_opcode:
								begin
								if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
									begin
									ForwardA = 2'b01;
									end
								else
									begin
									ForwardA = 2'b00;
									end
								end
							`mfc0_opcode:
								begin
								case(MEM_WB_Instruction[25:21])
									`mfc0_rs:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[25:21]))
											begin
											ForwardA = 2'b01;
											end
										else
											begin
											ForwardA = 2'b00;
											end
										end
									default:
										begin
										ForwardA = 2'b00;
										end
								endcase
								end
							default:
								begin
								ForwardA = 2'b00;
								end
						endcase
						end
				endcase
				end
			default:
				begin
				ForwardA = 2'b00;
				end
		endcase
		//$display("ForwardA = %x", ForwardA);
		end
				
	always@(*)		// ForwardB ALU_src1的旁路信号，有些指令会使用imm来作为ALU_src1，则在这里不用管它们
		begin
		case(ID_EX_Instruction[31:26])
			`R_opcode,
			`jalr_opcode,
			`jr_opcode:
				begin
				case(ID_EX_Instruction[5:0])
					`jr_funct,
					`jalr_funct:
						begin
						ForwardB = 2'b00;
						end
					default:
						begin
						case(EX_MEM_Instruction[31:26])
							`R_opcode,
							`jalr_opcode,
							`jr_opcode:
								begin
								case(EX_MEM_Instruction[5:0])
									`jr_funct:
										begin
										ForwardB = 2'b00;
										end
									default:
										begin
										if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[20:16]))
											begin
											ForwardB = 2'b10;
											end
										else
											begin
											case(MEM_WB_Instruction[31:26])
												`R_opcode,
												`jalr_opcode,
												`jr_opcode:
													begin
													case(MEM_WB_Instruction[5:0])
														`jr_funct:
															begin
															ForwardB = 2'b00;
															end
														default:
															begin
															if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
													endcase
													end
												`addi_opcode,
												`addiu_opcode,
												`andi_opcode,
												`ori_opcode,
												`xori_opcode,
												`lui_opcode,
												`slti_opcode,
												`sltiu_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`lb_opcode,
												`lbu_opcode,
												`lh_opcode,
												`lhu_opcode,
												`lw_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`mfc0_opcode:
													begin
													case(MEM_WB_Instruction[25:21])
														`mfc0_rs:
															begin
															if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
														default:
															begin
															ForwardB = 2'b00;
															end
													endcase
													end
												default:
													begin
													ForwardB = 2'b00;
													end
											endcase
											end
										end
								endcase
								end
							`addi_opcode,
							`addiu_opcode,
							`andi_opcode,
							`ori_opcode,
							`xori_opcode,
							`lui_opcode,
							`slti_opcode,
							`sltiu_opcode:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
									begin
									ForwardB = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardB = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardB = 2'b01;
												end
											else
												begin
												ForwardB = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardB = 2'b01;
												end
											else
												begin
												ForwardB = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												default:
													begin
													ForwardB = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardB = 2'b00;
											end
									endcase
									end
								end
							`mfc0_opcode:
								begin
								case(EX_MEM_Instruction[25:21])
									`mfc0_rs:
										begin
										if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardB = 2'b10;
											end
										else
											begin
											case(MEM_WB_Instruction[31:26])
												`R_opcode,
												`jalr_opcode,
												`jr_opcode:
													begin
													case(MEM_WB_Instruction[5:0])
														`jr_funct:
															begin
															ForwardB = 2'b00;
															end
														default:
															begin
															if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
													endcase
													end
												`addi_opcode,
												`addiu_opcode,
												`andi_opcode,
												`ori_opcode,
												`xori_opcode,
												`lui_opcode,
												`slti_opcode,
												`sltiu_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`lb_opcode,
												`lbu_opcode,
												`lh_opcode,
												`lhu_opcode,
												`lw_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`mfc0_opcode:
													begin
													case(MEM_WB_Instruction[25:21])
														`mfc0_rs:
															begin
															if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
														default:
															begin
															ForwardB = 2'b00;
															end
													endcase
													end
												default:
													begin
													ForwardB = 2'b00;
													end
											endcase
											end
										end
									default:
										begin
										case(MEM_WB_Instruction[31:26])
											`R_opcode,
											`jalr_opcode,
											`jr_opcode:
												begin
												case(MEM_WB_Instruction[5:0])
													`jr_funct:
														begin
														ForwardB = 2'b00;
														end
													default:
														begin
														if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
															begin
															ForwardB = 2'b01;
															end
														else
															begin
															ForwardB = 2'b00;
															end
														end
												endcase
												end
											`addi_opcode,
											`addiu_opcode,
											`andi_opcode,
											`ori_opcode,
											`xori_opcode,
											`lui_opcode,
											`slti_opcode,
											`sltiu_opcode:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
													begin
													ForwardB = 2'b01;
													end
												else
													begin
													ForwardB = 2'b00;
													end
												end
											`lb_opcode,
											`lbu_opcode,
											`lh_opcode,
											`lhu_opcode,
											`lw_opcode:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
													begin
													ForwardB = 2'b01;
													end
												else
													begin
													ForwardB = 2'b00;
													end
												end
											`mfc0_opcode:
												begin
												case(MEM_WB_Instruction[25:21])
													`mfc0_rs:
														begin
														if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
															begin
															ForwardB = 2'b01;
															end
														else
															begin
															ForwardB = 2'b00;
															end
														end
													default:
														begin
														ForwardB = 2'b00;
														end
												endcase
												end
											default:
												begin
												ForwardB = 2'b00;
												end
										endcase
										end
								endcase
								end
							default:
								begin
								ForwardB = 2'b00;
								end
						endcase
						end
				endcase
				end
			`beq_opcode,
			`bne_opcode:
				begin
				case(ID_EX_Instruction[5:0])
					`jr_funct,
					`jalr_funct:
						begin
						ForwardB = 2'b00;
						end
					default:
						begin
						case(EX_MEM_Instruction[31:26])
							`R_opcode,
							`jalr_opcode,
							`jr_opcode:
								begin
								case(EX_MEM_Instruction[5:0])
									`jr_funct:
										begin
										ForwardB = 2'b00;
										end
									default:
										begin
										if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[20:16]))
											begin
											ForwardB = 2'b10;
											end
										else
											begin
											case(MEM_WB_Instruction[31:26])
												`R_opcode,
												`jalr_opcode,
												`jr_opcode:
													begin
													case(MEM_WB_Instruction[5:0])
														`jr_funct:
															begin
															ForwardB = 2'b00;
															end
														default:
															begin
															if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
													endcase
													end
												`addi_opcode,
												`addiu_opcode,
												`andi_opcode,
												`ori_opcode,
												`xori_opcode,
												`lui_opcode,
												`slti_opcode,
												`sltiu_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`lb_opcode,
												`lbu_opcode,
												`lh_opcode,
												`lhu_opcode,
												`lw_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`mfc0_opcode:
													begin
													case(MEM_WB_Instruction[25:21])
														`mfc0_rs:
															begin
															if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
														default:
															begin
															ForwardB = 2'b00;
															end
													endcase
													end
												default:
													begin
													ForwardB = 2'b00;
													end
											endcase
											end
										end
								endcase
								end
							`addi_opcode,
							`addiu_opcode,
							`andi_opcode,
							`ori_opcode,
							`xori_opcode,
							`lui_opcode,
							`slti_opcode,
							`sltiu_opcode:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
									begin
									ForwardB = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardB = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardB = 2'b01;
												end
											else
												begin
												ForwardB = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardB = 2'b01;
												end
											else
												begin
												ForwardB = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												default:
													begin
													ForwardB = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardB = 2'b00;
											end
									endcase
									end
								end
							`mfc0_opcode:
								begin
								case(EX_MEM_Instruction[25:21])
									`mfc0_rs:
										begin
										if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardB = 2'b10;
											end
										else
											begin
											case(MEM_WB_Instruction[31:26])
												`R_opcode,
												`jalr_opcode,
												`jr_opcode:
													begin
													case(MEM_WB_Instruction[5:0])
														`jr_funct:
															begin
															ForwardB = 2'b00;
															end
														default:
															begin
															if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
													endcase
													end
												`addi_opcode,
												`addiu_opcode,
												`andi_opcode,
												`ori_opcode,
												`xori_opcode,
												`lui_opcode,
												`slti_opcode,
												`sltiu_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`lb_opcode,
												`lbu_opcode,
												`lh_opcode,
												`lhu_opcode,
												`lw_opcode:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardB = 2'b01;
														end
													else
														begin
														ForwardB = 2'b00;
														end
													end
												`mfc0_opcode:
													begin
													case(MEM_WB_Instruction[25:21])
														`mfc0_rs:
															begin
															if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
																begin
																ForwardB = 2'b01;
																end
															else
																begin
																ForwardB = 2'b00;
																end
															end
														default:
															begin
															ForwardB = 2'b00;
															end
													endcase
													end
												default:
													begin
													ForwardB = 2'b00;
													end
											endcase
											end
										end
									default:
										begin
										case(MEM_WB_Instruction[31:26])
											`R_opcode,
											`jalr_opcode,
											`jr_opcode:
												begin
												case(MEM_WB_Instruction[5:0])
													`jr_funct:
														begin
														ForwardB = 2'b00;
														end
													default:
														begin
														if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
															begin
															ForwardB = 2'b01;
															end
														else
															begin
															ForwardB = 2'b00;
															end
														end
												endcase
												end
											`addi_opcode,
											`addiu_opcode,
											`andi_opcode,
											`ori_opcode,
											`xori_opcode,
											`lui_opcode,
											`slti_opcode,
											`sltiu_opcode:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
													begin
													ForwardB = 2'b01;
													end
												else
													begin
													ForwardB = 2'b00;
													end
												end
											`lb_opcode,
											`lbu_opcode,
											`lh_opcode,
											`lhu_opcode,
											`lw_opcode:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
													begin
													ForwardB = 2'b01;
													end
												else
													begin
													ForwardB = 2'b00;
													end
												end
											`mfc0_opcode:
												begin
												case(MEM_WB_Instruction[25:21])
													`mfc0_rs:
														begin
														if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
															begin
															ForwardB = 2'b01;
															end
														else
															begin
															ForwardB = 2'b00;
															end
														end
													default:
														begin
														ForwardB = 2'b00;
														end
												endcase
												end
											default:
												begin
												ForwardB = 2'b00;
												end
										endcase
										end
								endcase
								end
							default:
								begin
								ForwardB = 2'b00;
								end
						endcase
						end
				endcase
				end
			`addi_opcode,
			`addiu_opcode,
			`andi_opcode,
			`ori_opcode,
			`xori_opcode,
			`lui_opcode,
			`slti_opcode,
			`sltiu_opcode:
				begin
				ForwardB = 2'b00;
				end
			`lb_opcode,
			`lbu_opcode,
			`lh_opcode,
			`lhu_opcode,
			`lw_opcode,
			`sb_opcode,
			`sh_opcode,
			`sw_opcode:
				begin
				ForwardB = 2'b00;
				end
			default:
				begin
				ForwardB = 2'b00;
				end
		endcase
		//$display("ForwardB = %x", ForwardB);
		end
		
	always@(*)		// ForwardC store指令的专用旁路信号
		begin
		case(ID_EX_Instruction[31:26])
			`sb_opcode,
			`sh_opcode,
			`sw_opcode:
				begin
				case(EX_MEM_Instruction[31:26])
					`R_opcode,
					`jalr_opcode,
					`jr_opcode:
						begin
						case(EX_MEM_Instruction[5:0])
							`jr_funct:
								begin
								ForwardC = 2'b00;
								end
							default:
								begin
								if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[20:16]))
									begin
									ForwardC = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardC = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
														begin
														ForwardC = 2'b01;
														end
													else
														begin
														ForwardC = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardC = 2'b01;
												end
											else
												begin
												ForwardC = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardC = 2'b01;
												end
											else
												begin
												ForwardC = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardC = 2'b01;
														end
													else
														begin
														ForwardC = 2'b00;
														end
													end
												default:
													begin
													ForwardC = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardC = 2'b00;
											end
									endcase
									end
								end
						endcase
						end
					`addi_opcode,
					`addiu_opcode,
					`andi_opcode,
					`ori_opcode,
					`xori_opcode,
					`lui_opcode,
					`slti_opcode,
					`sltiu_opcode:
						begin
						if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
							begin
							ForwardC = 2'b10;
							end
						else
							begin
							case(MEM_WB_Instruction[31:26])
								`R_opcode,
								`jalr_opcode,
								`jr_opcode:
								begin
									case(MEM_WB_Instruction[5:0])
										`jr_funct:
											begin
											ForwardC = 2'b00;
											end
										default:
											begin
											if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
												begin
												ForwardC = 2'b01;
												end
											else
												begin
												ForwardC = 2'b00;
												end
											end
									endcase
									end
								`addi_opcode,
								`addiu_opcode,
								`andi_opcode,
								`ori_opcode,
								`xori_opcode,
								`lui_opcode,
								`slti_opcode,
								`sltiu_opcode:
									begin
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
										begin
										ForwardC = 2'b01;
										end
									else
										begin
										ForwardC = 2'b00;
										end
									end
								`lb_opcode,
								`lbu_opcode,
								`lh_opcode,
								`lhu_opcode,
								`lw_opcode:
									begin
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
										begin
										ForwardC = 2'b01;
										end
									else
										begin
										ForwardC = 2'b00;
										end
									end
								`mfc0_opcode:
									begin
									case(MEM_WB_Instruction[25:21])
										`mfc0_rs:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardC = 2'b01;
												end
											else
												begin
												ForwardC = 2'b00;
												end
											end
										default:
											begin
											ForwardC = 2'b00;
											end
									endcase
									end
								default:
									begin
									ForwardC = 2'b00;
									end
							endcase
							end
						end
					`mfc0_opcode:
						begin
						case(EX_MEM_Instruction[25:21])
							`mfc0_rs:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
									begin
									ForwardC = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
										begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardC = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
														begin
														ForwardC = 2'b01;
														end
													else
														begin
														ForwardC = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardC = 2'b01;
												end
											else
												begin
												ForwardC = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardC = 2'b01;
												end
											else
												begin
												ForwardC = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardC = 2'b01;
														end
													else
														begin
														ForwardC = 2'b00;
														end
													end
												default:
													begin
													ForwardC = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardC = 2'b00;
											end
									endcase
									end
								end
							default:
								begin
								case(MEM_WB_Instruction[31:26])
									`R_opcode,
									`jalr_opcode,
									`jr_opcode:
									begin
										case(MEM_WB_Instruction[5:0])
											`jr_funct:
												begin
												ForwardC = 2'b00;
												end
											default:
												begin
												if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
													begin
													ForwardC = 2'b01;
													end
												else
													begin
													ForwardC = 2'b00;
													end
												end
										endcase
										end
									`addi_opcode,
									`addiu_opcode,
									`andi_opcode,
									`ori_opcode,
									`xori_opcode,
									`lui_opcode,
									`slti_opcode,
									`sltiu_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardC = 2'b01;
											end
										else
											begin
											ForwardC = 2'b00;
											end
										end
									`lb_opcode,
									`lbu_opcode,
									`lh_opcode,
									`lhu_opcode,
									`lw_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardC = 2'b01;
											end
										else
											begin
											ForwardC = 2'b00;
											end
										end
									`mfc0_opcode:
										begin
										case(MEM_WB_Instruction[25:21])
											`mfc0_rs:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
													begin
													ForwardC = 2'b01;
													end
												else
													begin
													ForwardC = 2'b00;
													end
												end
											default:
												begin
												ForwardC = 2'b00;
												end
										endcase
										end
									default:
										begin
										ForwardC = 2'b00;
										end
								endcase
								end
						endcase
						end
					default:
						begin
						ForwardC = 2'b00;
						end
				endcase
				end
			default:
				begin
				ForwardC = 2'b00;
				end
		endcase
		end
		
	always@(*)		// ForwardD mtc0指令的专用旁路信号，类似ForwardA，但是不经过ALU，而只是对CoPR0_Write_data进行了挑选
		begin
		case(ID_EX_Instruction[31:26])
			`mtc0_opcode:
				begin
				case(EX_MEM_Instruction[31:26])
					`R_opcode,
					`jalr_opcode,
					`jr_opcode:
						begin
						case(EX_MEM_Instruction[5:0])
							`jr_funct:
								begin
								ForwardD = 2'b00;
								end
							default:
								begin
								if((EX_MEM_Instruction[15:11] != 5'd0) && (EX_MEM_Instruction[15:11] == ID_EX_Instruction[20:16]))
									begin
									ForwardD = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardD = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
														begin
														ForwardD = 2'b01;
														end
													else
														begin
														ForwardD = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardD = 2'b01;
												end
											else
												begin
												ForwardD = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardD = 2'b01;
												end
											else
												begin
												ForwardD = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardD = 2'b01;
														end
													else
														begin
														ForwardD = 2'b00;
														end
													end
												default:
													begin
													ForwardD = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardD = 2'b00;
											end
									endcase
									end
								end
						endcase
						end
					`addi_opcode,
					`addiu_opcode,
					`andi_opcode,
					`ori_opcode,
					`xori_opcode,
					`lui_opcode,
					`slti_opcode,
					`sltiu_opcode:
						begin
						if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
							begin
							ForwardD = 2'b10;
							end
						else
							begin
							$display("I'm in MEM_WB (ForwardD)!");
							case(MEM_WB_Instruction[31:26])
								`R_opcode,
								`jalr_opcode,
								`jr_opcode:
									begin
									$display("I'm in MEM_WB -- R-type (ForwardD)!");
									case(MEM_WB_Instruction[5:0])
										`jr_funct:
											begin
											ForwardD = 2'b00;
											end
										default:
											begin
											if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
												begin
												ForwardD = 2'b01;
												end
											else
												begin
												ForwardD = 2'b00;
												end
											end
									endcase
									end
								`addi_opcode,
								`addiu_opcode,
								`andi_opcode,
								`ori_opcode,
								`xori_opcode,
								`lui_opcode,
								`slti_opcode,
								`sltiu_opcode:
									begin
									$display("I'm in MEM_WB -- I-type (ForwardD)!");
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
										begin
										ForwardD = 2'b01;
										end
									else
										begin
										ForwardD = 2'b00;
										end
									end
								`lb_opcode,
								`lbu_opcode,
								`lh_opcode,
								`lhu_opcode,
								`lw_opcode:
									begin
									$display("I'm in MEM_WB -- Load-type (ForwardD)!");
									if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
										begin
										ForwardD = 2'b01;
										end
									else
										begin
										ForwardD = 2'b00;
										end
									end
								`mfc0_opcode:
									begin
									case(MEM_WB_Instruction[25:21])
										`mfc0_rs:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardD = 2'b01;
												end
											else
												begin
												ForwardD = 2'b00;
												end
											end
										default:
											begin
											ForwardD = 2'b00;
											end
									endcase
									end
								default:
									begin
									ForwardD = 2'b00;
									end
							endcase
							end
						end
					`mfc0_opcode:
						begin
						case(EX_MEM_Instruction[25:21])
							`mfc0_rs:
								begin
								if((EX_MEM_Instruction[20:16] != 5'd0) && (EX_MEM_Instruction[20:16] == ID_EX_Instruction[20:16]))
									begin
									ForwardD = 2'b10;
									end
								else
									begin
									case(MEM_WB_Instruction[31:26])
										`R_opcode,
										`jalr_opcode,
										`jr_opcode:
											begin
											case(MEM_WB_Instruction[5:0])
												`jr_funct:
													begin
													ForwardD = 2'b00;
													end
												default:
													begin
													if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
														begin
														ForwardD = 2'b01;
														end
													else
														begin
														ForwardD = 2'b00;
														end
													end
											endcase
											end
										`addi_opcode,
										`addiu_opcode,
										`andi_opcode,
										`ori_opcode,
										`xori_opcode,
										`lui_opcode,
										`slti_opcode,
										`sltiu_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardD = 2'b01;
												end
											else
												begin
												ForwardD = 2'b00;
												end
											end
										`lb_opcode,
										`lbu_opcode,
										`lh_opcode,
										`lhu_opcode,
										`lw_opcode:
											begin
											if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
												begin
												ForwardD = 2'b01;
												end
											else
												begin
												ForwardD = 2'b00;
												end
											end
										`mfc0_opcode:
											begin
											case(MEM_WB_Instruction[25:21])
												`mfc0_rs:
													begin
													if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
														begin
														ForwardD = 2'b01;
														end
													else
														begin
														ForwardD = 2'b00;
														end
													end
												default:
													begin
													ForwardD = 2'b00;
													end
											endcase
											end
										default:
											begin
											ForwardD = 2'b00;
											end
									endcase
									end
								end
							default:
								begin
								case(MEM_WB_Instruction[31:26])
									`R_opcode,
									`jalr_opcode,
									`jr_opcode:
										begin
										case(MEM_WB_Instruction[5:0])
											`jr_funct:
												begin
												ForwardD = 2'b00;
												end
											default:
												begin
												if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
													begin
													ForwardD = 2'b01;
													end
												else
													begin
													ForwardD = 2'b00;
													end
												end
										endcase
										end
									`addi_opcode,
									`addiu_opcode,
									`andi_opcode,
									`ori_opcode,
									`xori_opcode,
									`lui_opcode,
									`slti_opcode,
									`sltiu_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardD = 2'b01;
											end
										else
											begin
											ForwardD = 2'b00;
											end
										end
									`lb_opcode,
									`lbu_opcode,
									`lh_opcode,
									`lhu_opcode,
									`lw_opcode:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardD = 2'b01;
											end
										else
											begin
											ForwardD = 2'b00;
											end
										end
									`mfc0_opcode:
										begin
										case(MEM_WB_Instruction[25:21])
											`mfc0_rs:
												begin
												if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
													begin
													ForwardD = 2'b01;
													end
												else
													begin
													ForwardD = 2'b00;
													end
												end
											default:
												begin
												ForwardD = 2'b00;
												end
										endcase
										end
									default:
										begin
										ForwardD = 2'b00;
										end
								endcase
								end
						endcase
						end
					default:
						begin
						case(MEM_WB_Instruction[31:26])
							`R_opcode,
							`jalr_opcode,
							`jr_opcode:
								begin
								case(MEM_WB_Instruction[5:0])
									`jr_funct:
										begin
										ForwardD = 2'b00;
										end
									default:
										begin
										if((MEM_WB_Instruction[15:11] != 5'd0) && (MEM_WB_Instruction[15:11] == ID_EX_Instruction[20:16]))
											begin
											ForwardD = 2'b01;
											end
										else
											begin
											ForwardD = 2'b00;
											end
										end
								endcase
								end
							`addi_opcode,
							`addiu_opcode,
							`andi_opcode,
							`ori_opcode,
							`xori_opcode,
							`lui_opcode,
							`slti_opcode,
							`sltiu_opcode:
								begin
								if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
									begin
									ForwardD = 2'b01;
									end
								else
									begin
									ForwardD = 2'b00;
									end
								end
							`lb_opcode,
							`lbu_opcode,
							`lh_opcode,
							`lhu_opcode,
							`lw_opcode:
								begin
								if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
									begin
									ForwardD = 2'b01;
									end
								else
									begin
									ForwardD = 2'b00;
									end
								end
							`mfc0_opcode:
								begin
								case(MEM_WB_Instruction[25:21])
									`mfc0_rs:
										begin
										if((MEM_WB_Instruction[20:16] != 5'd0) && (MEM_WB_Instruction[20:16] == ID_EX_Instruction[20:16]))
											begin
											ForwardD = 2'b01;
											end
										else
											begin
											ForwardD = 2'b00;
											end
										end
									default:
										begin
										ForwardD = 2'b00;
										end
								endcase
								end
							default:
								begin
								ForwardD = 2'b00;
								end
						endcase
						end
				endcase
				end
			default:
				begin
				ForwardD = 2'b00;
				end
		endcase
		end
endmodule		