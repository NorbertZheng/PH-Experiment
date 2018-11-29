module InstructionMemory(Read_address, Instruction);
	parameter width = 32, AddrWidth = 32, num = 32'h0000_4000;
	
	input [AddrWidth - 1:0] Read_address;
	output reg [width - 1:0] Instruction;
	
	reg [width - 1:0] instructionMemory[num - 1:0];
	integer i, fp, count, reger;
	
	initial
		begin
		for(i = 0;i < num;i = i + 1)
			instructionMemory[i] = 0;
		fp = $fopen("code.txt", "r");
		i = 32'h0000_0c00;
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
		for(i = 32'h0000_0c00;i <= 32'h0000_0c10;i = i + 1)
			begin
			$display("%x %x", i, instructionMemory[i]);
			end
		end
		
	always@(*)
		begin
		Instruction = instructionMemory[Read_address >> 2];
		end
endmodule