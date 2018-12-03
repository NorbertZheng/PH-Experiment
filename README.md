# PH-Experiment

[![Travis](https://img.shields.io/travis/rust-lang/rust/master.svg)](https://github.com/Fassial/RISC-CPU/commits/master)
[![Language](https://img.shields.io/badge/Verilog-HDL-blue.svg)](https://baike.baidu.com/item/Verilog%20HDL/596353?fr=aladdin)
[![GitHub last commit (branch)](https://img.shields.io/badge/last%20commit-november-yellowgreen.svg)](https://github.com/Fassial/RISC-CPU)

大二上学期<b>` 计算机组成与设计 - (PH) `</b>专业课的MIPS_CPU设计实验代码(基于`Verilog`语言).

## 实验一

### 实验要求
&emsp;&emsp;按照教材上的要求，完成寄存器组和ALU的设计，实现寄存器组双端口读单端口写；ALU最少实现5种功能。

### 实验背景
&emsp;&emsp;单周期cpu，为了方便以后将各模块组合成一个完整的单周期cpu，regfile和alu最好按照单周期的规格实现，日后实现流水线的时候这些模块可能要做相应的更改。

### 设计过程

#### 1、registers(寄存器组)
  <p>&emsp;&emsp;这个模块相当于MIPS_CPU中规定的32个固有寄存器。因此，在`regfile.v`模块中内部变量`reg`数组是必须的。由于底存的设计一般都是随机存储方式，因而将registers设置为包含32个`32-bit`reg变量类型的数组。由于在MIPS_CPU的寄存器组中，有一个很特殊的寄存器(即$zero,零号寄存器)，它在registers数组中排在`0`号位置，且是`read-only`类型的(这意味着，一切对于它的写操作，都是不被允许的)。由此，在对registers进行写操作的时候，下面这条语句显得至关重要:<br>
  <pre>registers[wa_i] <= (wa_i != 0) ? wd_i : 32'd0;                 //寄存器 write 操作</pre>
  这样就防止了对于 read-only 寄存器的 write 非法操作。</p>
  
#### 2、ALU(算术逻辑运算器)
  <p>&emsp;&emsp;这个模块就相当于MIPS_CPU中的ALU部件。它的功能就是要实现CPU所需要的所有算术逻辑运算功能，而这里实现了<span> <a href = "https://github.com/Fassial/PH-Experiment/blob/master/regfile%20%26%20ALU/ALU/defines.v"><b>ALU/define.v</b></a> </span>里面定义的15中运算:<br>
  <pre>
  `define ALUOP_NOP   5'd0                    // nop    空操作
  `define ALUOP_ADD   5'd1                    // add    算术加
  `define ALUOP_SUB   5'd2                    // sub    算术减
  `define ALUOP_SLT   5'd3                    // slt    有符号数判定src0_i < src1_i
  `define ALUOP_SLTU  5'd4                    // sltu   无符号数判定src0_i < src1_i
  `define ALUOP_DIV   5'd5                    // div    有符号数除法
  `define ALUOP_DIVU  5'd6                    // divu   无符号数除法
  `define ALUOP_MULT  5'd7                    // mult   有符号数乘法
  `define ALUOP_MULTU 5'd8                    // multu  无符号数乘法
  `define ALUOP_AND   5'd9                    // and    逻辑与
  `define ALUOP_NOR   5'd10                   // nor    逻辑或非
  `define ALUOP_OR    5'd11                   // or     逻辑或
  `define ALUOP_LUI   5'd12                   // lui
  `define ALUOP_SLL   5'd13                   // sll    逻辑左移
  `define ALUOP_SRL   5'd14                   // srl    逻辑右移
  `define ALUOP_SRA   5'd15                   // sra    算术右移
  </pre>
  在这里面除了乘法除法我就不再赘述了，都是可以通过一步运算出结果的，且它们对于aluout_oR的拼接操作也是类似的:<br>
  <pre>aluout_oR = {33'd0, lo};                                       //对aluout_oR的拼接操作</pre>
  没错，这里的aluout_oR是有点特殊——它是一个`65-bit`的寄存器。其实，对于aluout_oR这样设计，是为了合并乘法除法时候的65-bit的<b>product寄存器</b>(或者说<b>余数-商寄存器</b>)。说实在的，运用改进版的乘法器这样虽然有一个 65-bit 的寄存器，和之前相比寄存器的总位数其实减少了。当然，你也不必担心对于`aluout_o`这条wire类型输出的赋值问题，一个assign照样能解决:<br>
  <pre>assign aluout_o = aluout_oR[63:0];                             //只取后64位赋值给aluout_o</pre>
  关于product寄存器被设计成 65-bit 寄存器，我想说一下原因 —— 保证加法器进位不会丢失(这是保证运算结果正确性至关重要的一步).<br><br></p>
  啊！谈了这么多，终于到了乘法器除法器部分！<br><br>
  * 乘法器
  <p>&emsp;&emsp;对于乘法器中实现`MULTU`(无符号数乘法)还是蛮简单的，参照`计算机组成与设计`3.3节的思想很快便写出了该指令的 Verilog 代码。在实现`MULT`(有符号数乘法)的时候，想去将这一部分写成和 MULTU 相近的代码，但是并不可行。最后只能按书上的思想，使用最简单的方法，先将src0_i和src1_i转化为正数:<br>
  <pre>multiplicand_or_divisor = (~src0_i + 1 > src0_i) ? src0_i : (~src0_i + 1);       //将转换成正数的被乘数src0_i放入multiplicand_or_divisor</pre>
  然后，按照 MULTU 的方式，计算出两个正数的 product 。最后，只需要依据src0_i和src1_i的sign位改变一下aluout_oR指定bit的值就OK了:<br>
  <pre>aluout_oR = (src0_i[31] == src1_i[31]) ? aluout_oR[63:0] : (~aluout_oR[63:0] + 1);       //依据sign更新aluout_oR的sign</pre><br>
  * 除法器
  <p>&emsp;&emsp;对于除法器中实现`DIVU`(无符号数除法)基本上可以参照`计算机组成与设计`3.4节的思想:<br>
  <pre>
  for(i = 0;i < 33;i = i + 1)
    begin
    if(aluout_oR[64:32] >= src1_i)                                    //余数 - 除数 >= 0，这时商上1
      begin
      aluout_oR[64:32] = aluout_oR[64:32] - src1_i;
      aluout_oR = aluout_oR << 1;
      aluout_oR[0] = 1;
      end
    else                                                              //不可减，这时商上0
      begin
      aluout_oR = aluout_oR << 1;
      aluout_oR[0] = 0;
      end
    end
  </pre>
  但是由于在那一节中算法是基于没有优化的除法器结构，所以在实现该条指令的时候，有一个小细节是要做改动的，比如循环结尾:<br>
  <pre>
  ...                                                                 	//节选了一部分
    if(i != 32)
	begin
	...
	aluout_oR = aluout_oR << 1;                                     //不是循环结尾，整体左移
     	...
	end
    else
	begin
	...
	aluout_oR[31:0] = aluout_oR[31:0] << 1;                         //循环结尾，只有低 32-bit 左移
	...
	end
  ...
  </pre>
  通过这样一个小小的变动，就可以使除法其在无符号数运算时正常执行。</p>
  <p>&emsp;&emsp;对于除法器中实现`DIV`(有符号数除法)，我的想法还是和之前实现`MULT`一样，转换成正数之后进行类似 DIVU 的运算，最后依据src0_i和src1_i的sign值对aluout_oR进行更新。</p><br>
  * 一些小问题
  <p>&emsp;&emsp;multiplicand_or_divisor寄存器的依赖性:我曾经想把它去掉，毕竟它只是一个中间变量，少一个reg少一点成本，但是本该可行的方案却在仿真时<b>无法pass testbench</b></p>


## 实验二（MIPS单周期处理器）

### 本实验并没有按照实验要求的结构来写，实验思路我明天再写：）
