module regfile(
		input clk,
		input rst_n,
		input regwrite_i,
  		input [4:0]wa_i, //rt or rd , write address
  		input [4:0]ra0_i,//rs ,read address 0
  		input [4:0]ra1_i,//rt ,read address 1
  		input [31:0]wd_i,//write  data
  		output [31:0]rd0_o,  //rs,read data
  		output [31:0]rd1_o   //rt,read data
  	);
	
	reg [31:0]registers[31:0];
	integer i;
	
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				for(i = 0;i <= 31;i = i + 1)
					registers[i] <= 32'd0;
			else
				begin
				if(regwrite_i == 1)
					registers[wa_i] <= (wa_i != 0) ? wd_i : 32'd0;
				end
		end
		
	assign rd0_o = registers[ra0_i];
	assign rd1_o = registers[ra1_i];
endmodule