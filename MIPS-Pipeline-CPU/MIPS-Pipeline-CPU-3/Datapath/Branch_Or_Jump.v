`include "C://Users//Think//Desktop//MIPS-Pipeline-CPU-3//Define//Fragment_Define.v"
module Branch_Or_Jump(Reverse, branchZero, ChangeType, branch_Or_Jump);
	input Reverse;
	input branchZero;
	input [1:0] ChangeType;
	output reg [1:0] branch_Or_Jump;
	
	always@(*)
		begin
		case(ChangeType)
			`Sequence:
				begin
				branch_Or_Jump <= `Sequence;
				end
			`Branch:
				begin
				$display("branchZero = %x    Reverse = %x", branchZero, Reverse);
				if(Reverse ^ branchZero)
					begin
					branch_Or_Jump <= `Branch;
					end
				else
					begin
					branch_Or_Jump <= `NotBranch;
					end
				end
			`Jump:
				begin
				branch_Or_Jump <= `Jump;
				end
			default:
				begin
				branch_Or_Jump <= `Sequence;
				end
		endcase
		end
endmodule