module mux(s, y, d0, d1, d2, d3);
	parameter selectWidth = 1, width = 32;
	
	input [selectWidth - 1:0] s;
	input [width - 1:0] d0, d1, d2, d3;
	output reg [width - 1:0] y;
	
	always@(*)
		begin
		case(s)
			2'b00:
				begin
				y = d0;
				end
			2'b01:
				begin
				y = d1;
				end
			2'b10:
				begin
				y = d2;
				end
			2'b11:
				begin
				y = d3;
				end
		endcase
		end
endmodule