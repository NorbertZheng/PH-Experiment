module WriteNext(Reverse, Zero, PCWriteCond, PCWrite, write_next);
	input Reverse;
	input Zero;
	input PCWriteCond;
	input PCWrite;
	output write_next;
	
	assign write_next = ((Reverse ^ Zero) && PCWriteCond) || PCWrite;
	always@(*)
		begin
		$display("PCWrite = %x", PCWrite);
		$display("write_next = %x", write_next);
		end
endmodule