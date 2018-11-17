module rf_tb(
  );
  `timescale  1ns/1ps
  reg clk,rst_n;
  reg  regwrite;
  reg  [4:0]wa,ra0,ra1;
  reg  [31:0]wd;
  wire [31:0]rd0,rd1;
  reg  [31:0]tmp_rd0,tmp_rd1;
  reg  [31:0]test_case;
  integer fd,cnt;
  initial
    begin
      fd=$fopen("data.txt","r");
      cnt=0;
      test_case=32'd0;
      regwrite=0;
      wa=5'd0;
      ra0=5'd0;
      ra1=5'd0;
      wd=32'd0;
      tmp_rd0=32'd0;
      tmp_rd1=32'd0;
      clk=0;
      rst_n=1;
      #5  rst_n=0;
      #1  rst_n=1;
    end

  always
    #10 clk<=~clk;

  regfile rf(
    .clk(clk),
    .rst_n(rst_n),

    .regwrite_i(regwrite),
    .wa_i(wa),
    .ra0_i(ra0),
    .ra1_i(ra1),
    .wd_i(wd),
    .rd0_o(rd0),
    .rd1_o(rd1)
  );

  always@(posedge clk)
  begin
    test_case<=test_case+1;
    if (rd0!=tmp_rd0 || rd1!=tmp_rd1)
      begin
        $display("testcase %d fail!",test_case);
        $stop;
      end
      
    cnt=$fscanf(fd,"%x%x%x%x%x%x%x",regwrite,wa,wd,ra0,tmp_rd0,ra1,tmp_rd1);
    $display("%x\t%x\t%x\t%x\t%x\t%x\t%x /cnt:%d",regwrite,wa,wd,ra0,tmp_rd0,ra1,tmp_rd1,cnt);
    if (cnt==-1)
      begin
        $display("pass!");
        $fclose(fd);
        $stop;
      end
  end

endmodule
