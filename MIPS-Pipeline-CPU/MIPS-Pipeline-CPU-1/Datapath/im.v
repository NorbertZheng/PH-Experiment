module im_4k(addr, dout);
	parameter width = 32, AddrWidth = 10, num = 1024, initAddress = 32'h0000_0c00;
	
	input [AddrWidth + 2 - 1:2] addr;
	output [width - 1:0] dout;
	
	reg [width - 1:0] instructionMemory[num - 1:0];
	integer i, fp, count, reger;
	
	initial
		begin
		for(i = 0;i < num;i = i + 1)
			instructionMemory[i] = 0;
		fp = $fopen("C://Users//Think//Desktop//MIPS-Pipeline-CPU-1//code.txt", "r");
		i = 0;
		while(!$feof(fp))
			begin
			count = $fscanf(fp, "%h", reger);
			if(count == 1)
				begin
				instructionMemory[i] = reger;
				$display("%x %x", i, reger);
				i = i + 1;
				end
			end
		$fclose(fp);		
		$display("=================================================================");
		for(i = 0;i <= 32'h55;i = i + 1)
			begin
			$display("%x %x", i, instructionMemory[i]);
			end
		end
	
	assign dout = instructionMemory[addr];
endmodule