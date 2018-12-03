module Mux(s, y, d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15);
	parameter width = 32, signWidth = 4;
	
	input [signWidth - 1:0] s;
	input [width - 1:0] d0;
	input [width - 1:0] d1;
	input [width - 1:0] d2;
	input [width - 1:0] d3;
	input [width - 1:0] d4;
	input [width - 1:0] d5;
	input [width - 1:0] d6;
	input [width - 1:0] d7;
	input [width - 1:0] d8;
	input [width - 1:0] d9;
	input [width - 1:0] d10;
	input [width - 1:0] d11;
	input [width - 1:0] d12;
	input [width - 1:0] d13;
	input [width - 1:0] d14;
	input [width - 1:0] d15;
	output reg [width - 1:0] y;
	
	initial
		begin
		y = 0;
		end
	
	always@(*)
		begin
		case(s)
			0:
				begin
				y = d0;
				end
			1:
				begin
				y = d1;
				end
			2:
				begin
				y = d2;
				end
			3:
				begin
				y = d3;
				end
			4:
				begin
				y = d4;
				end
			5:
				begin
				y = d5;
				end
			6:
				begin
				y = d6;
				end
			7:
				begin
				y = d7;
				end
			8:
				begin
				y = d8;
				end
			9:
				begin
				y = d9;
				end
			10:
				begin
				y = d10;
				end
			11:
				begin
				y = d11;
				end
			12:
				begin
				y = d12;
				end
			13:
				begin
				y = d13;
				end
			14:
				begin
				y = d14;
				end
			15:
				begin
				y = d15;
				end
			default:
				begin
				y = 0;
				end
		endcase
		end
endmodule