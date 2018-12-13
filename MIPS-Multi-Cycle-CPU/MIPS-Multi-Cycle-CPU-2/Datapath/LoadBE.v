`include "C://Users//Think//Desktop//MIPS-Multi-Cycle-CPU-2//Define//Fragment_Define.v"

module LoadBE(LoadType, ALUOut, MemData_i, MemData_o);
	input [2:0] LoadType;
	input [1:0] ALUOut;
	input [31:0] MemData_i;
	output reg [31:0] MemData_o;
	
	initial
		begin
		MemData_o = 32'b0;
		end
	
	always@(*)
		begin
		case(LoadType)
			`LoadWord:
				begin
				MemData_o = MemData_i;
				end
			`LoadHalfWord:
				begin
				case(ALUOut)
					2'b00:
						begin
						MemData_o = {{16{MemData_i[15]}}, MemData_i[15:0]};
						end
					2'b10:
						begin
						MemData_o = {{16{MemData_i[31]}}, MemData_i[31:16]};
						end
					default:
						begin
						MemData_o = 32'b0;
						end
				endcase
				end
			`LoadHalfWordU:
				begin
				case(ALUOut)
					2'b00:
						begin
						MemData_o = {16'b0, MemData_i[15:0]};
						end
					2'b10:
						begin
						MemData_o = {16'b0, MemData_i[31:16]};
						end
					default:
						begin
						MemData_o = 32'b0;
						end
				endcase
				end
			`LoadByte:
				begin
				case(ALUOut)
					2'b00:
						begin
						MemData_o = {{24{MemData_i[7]}}, MemData_i[7:0]};
						end
					2'b01:
						begin
						MemData_o = {{24{MemData_i[15]}}, MemData_i[15:8]};
						end
					2'b10:
						begin
						MemData_o = {{24{MemData_i[23]}}, MemData_i[23:16]};
						end
					2'b11:
						begin
						MemData_o = {{24{MemData_i[31]}}, MemData_i[31:24]};
						end
					default:
						begin
						MemData_o = 32'b0;
						end
				endcase
				end
			`LoadByteU:
				begin
				case(ALUOut)
					2'b00:
						begin
						MemData_o = {24'b0, MemData_i[7:0]};
						end
					2'b01:
						begin
						MemData_o = {24'b0, MemData_i[15:8]};
						end
					2'b10:
						begin
						MemData_o = {24'b0, MemData_i[23:16]};
						end
					2'b11:
						begin
						MemData_o = {24'b0, MemData_i[31:24]};
						end
					default:
						begin
						MemData_o = 32'b0;
						end
				endcase
				end
			default:
				begin
				MemData_o = MemData_i;
				end
		endcase
		end
endmodule