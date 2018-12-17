`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-1//Define//Fragment_Define.v"

module BE(StoreType, ALUOut, be);
	input [1:0] StoreType;
	input [1:0] ALUOut;
	output reg [3:0] be;
	
	initial
		begin
		be = 4'b0;
		end
	
	always@(*)
		begin
		case(StoreType)
			`StoreWord:
				begin
				be = 4'b1111;
				end
			`StoreHalfWord:
				begin
				case(ALUOut)
					2'b00,
					2'b01:
						begin
						be = 4'b0011;
						end
					2'b10,
					2'b11:
						begin
						be = 4'b1100;
						end
					default:
						begin
						be = be;
						end
				endcase
				end
			`StoreByte:
				begin
				case(ALUOut)
					2'b00:
						begin
						be = 4'b0001;
						end
					2'b01:
						begin
						be = 4'b0010;
						end
					2'b10:
						begin
						be = 4'b0100;
						end
					2'b11:
						begin
						be = 4'b1000;
						end
					default:
						begin
						be = be;
						end
				endcase
				end
			default:
				begin
				be = 4'b0000;
				end
		endcase
		//$display("BE = %b", be);
		end
endmodule