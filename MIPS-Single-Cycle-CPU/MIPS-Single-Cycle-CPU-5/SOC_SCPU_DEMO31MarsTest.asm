			j	start
			add	$zero, $zero, $zero
			add	$zero, $zero, $zero
			add	$zero, $zero, $zero
			add	$zero, $zero, $zero
			add	$zero, $zero, $zero
			add	$zero, $zero, $zero
			add	$zero, $zero, $zero
start:		lui	$v1, 0xf000			#r3=0xF0000000
			lui	$a0, 0xe000			#r4=0xE0000000
			lui	$t0, 0x8000			#r8=0x80000000
			addi $s4, $zero, 0x003f	#r20=0x0000003F
			lui	$a2, 0xf800			#r6=0xf8000000
			nor	$at, $zero, $zero	#r1=0xFFFFFFFF
			slt	$v0, $zero, $at		#r2=0x00000001 unsigned slt
			addi	$t2, $at, -1	#r10=0xFFFFFFFE
			sw	$a2, 0x104($zero)			#计数器端口:F0000004，送计数常数r6=0xf8000000
			lw	$a1, 0x100($zero)			#读GPIO端口F0000000状态:{counter0_out,counter1_out,counter2_out,led_out[12:0], SW} 
			add	$a1, $a1, $a1		#左移
			add	$a1, $a1, $a1		#左移2位将SW与LED对齐，同时D1D0置00，选择计数器通道0
			sw	$a1, 0x100($zero)			#r5输出到GPIO端口0xF0000000，设置计数器通道counter_set=00端口、LED=SW{GPIOf0[13:0],LED,counter_set}
			addi	$t1, $t1, 1		#r9=r9+1 
			sw	$t1, 0x200($zero)			#r9送r4=0xE0000000七段码端口
			lw	$t5, 20($zero)		#取存储器20单元预存数据至r13(5号字),程序计数延时常数
Loop:		lw	$a1, 0x100($zero)		#读GPIO端口F0000000状态:{counter0_out,counter1_out,counter2_out,led_out[12:0], SW} 
			add	$a1, $a1, $a1		#左移
			add	$a1, $a1, $a1		#左移2位将SW与LED对齐，同时D1D0置00，选择计数器通道0
			sw	$a1, 0x100($zero)			#r5输出到GPIO端口0xF0000000，计数器通道counter_set=00端口不变、LED=SW： {GPIOf0[13:0],LED,counter_set}
			lw	$a1, 0x100($zero)			#再读GPIO端口0xF0000000状态
			and	$t3,$a1,$t0			#取最高位=out0，屏蔽其余位送r11
			addi	$t5, $t5,1		#程序计数延时
			bne	$t5, $zero, Disp
			jal	Next
Disp:		lw	$a1, 0x100($zero)			#读GPIO端口F0000000状态:{counter0_out,counter1_out,counter2_out,led_out[12:0], SW} 
			addi	$s2, $zero, 0x0008	#r18=0x00000008
			add	$s6, $s2, $s2		#r22=0x00000010
			add	$s2, $s2, $s6		#r18=0x00000018(00011000b)
			and	$t3, $a1, $s2		#取SW[4:3]
			beq	$t3, $zero, L00		#SW[4:3]=00,7段显示"点"循环移位：L00，SW0=0
			beq	$t3, $s2, L11		#SW[4:3]=11,7段显示显示七段图形：L11，SW0=0
			addi	$s2, $zero, 0x0008	#r18=8
			beq	$t3, $s2, L01		#SW[4:3]=01,七段显示预置数字，L01，SW0=1
			sw	$t1, 0x200($zero)			#SW[4:3]=10，显示r9，SW0=1
			j	Loop
L00:		bne	$t2, $at, L3		#r10！=r1,转移L3
			nor $t2, $zero, $zero	#r10=0xffffffff
			add $t2, $t2, $t2		#r10=0xfffffffe
L3:			sw	$t2, 0x200($zero)			#SW[4:3]=00,7段显示点移位后显示
			j	Loop
L11:		lw  $t1, 0x60($s1)		#SW[4:3]=11，从内存取预存七段图形
			sw	$t1, 0x200($zero)			#SW[4:3]=11，显示七段图形
			j	Loop
L01:		lw	$t1, 0x20($s1)		#SW[4:3]=01，从内存取预存数字
			sw	$t1, 0x200($zero)			#SW[4:3]=01,七段显示预置数字
			j	Loop
Next:		lw	$t5, 20($zero)		#取存储器20单元预存数据至r13,程序计数延时常数
			add	$t2, $t2, $t2		#r10=fffffffc，7段图形点左移
			ori	$t2, $t2,1		#r10末位置1，对应右上角不显示
			addi	$s1, $s1,4		#r17=r17+00000004，LED图形访存地址+4
			and	$s1, $s1, $s4		#r17=000000XX，屏蔽地址高位，只取6位
			add	$t1, $t1, $v0		#r9=r9+1
			bne	$t1, $at, L4		#r9=ffffffff,重置r9=5
			addi	$t1, $t1, 5
L4:			lw	$a1, 0x100($zero)			#读GPIO端口F0000000状态:{counter0_out,counter1_out,counter2_out,led_out[12:0], SW} 
			add	$t3,$a1,$a1			#左移
			add	$t3,$t3,$t3			#左移2位将SW与LED对齐，同时D1D0置00，选择计数器通道0
			sw	$t3, 0x100($zero)			#r5输出到GPIO端口0xF0000000，计数器通道counter_set=00端口不变、LED=SW： {GPIOf0[13:0],LED,counter_set}
			sw	$a2, 0x104($zero)			#计数器端口:F0000004，送计数常数r6=0xf8000000
			jr	$ra