		j	start
		add	$zero, $zero, $zero
		add	$zero, $zero, $zero
		add	$zero, $zero, $zero
		add	$zero, $zero, $zero
		add	$zero, $zero, $zero
		add	$zero, $zero, $zero
		add	$zero, $zero, $zero
start:	nor	$1,$0,$0	#r1=0xFFFFFFFF
		add	$3,$1,$1	#r3=0xFFFFFFFE
		add	$3,$3,$3	#r3=0xFFFFFFFC
		add	$3,$3,$3	#r3=0xFFFFFFF8
		add	$3,$3,$3	#r3=0xFFFFFFF0
		add	$3,$3,$3	#r3=0xFFFFFFE0
		add	$3,$3,$3	#r3=0xFFFFFFC0
		nor	$20,$3,$0	#r20=0x0000003F
		add	$3,$3,$3	#r3=0xFFFFFF80
		add	$3,$3,$3	#r3=0xFFFFFF00
		add	$3,$3,$3	#r3=0xFFFFFE00
		add	$3,$3,$3	#r3=0xFFFFFC00
		add	$3,$3,$3	#r3=0xFFFFF800
		add	$3,$3,$3	#r3=0xFFFFF000
		add	$3,$3,$3	#r3=0xFFFFE000
		add	$3,$3,$3	#r3=0xFFFFC000
		add	$3,$3,$3	#r3=0xFFFF8000
		add	$3,$3,$3	#r3=0xFFFF0000
		add	$3,$3,$3	#r3=0xFFFE0000
		add	$3,$3,$3	#r3=0xFFFC0000
		add	$3,$3,$3	#r3=0xFFF80000
		add	$3,$3,$3	#r3=0xFFF00000
		add	$3,$3,$3	#r3=0xFFE00000
		add	$3,$3,$3	#r3=0xFFC00000
		add	$3,$3,$3	#r3=0xFF800000
		add	$3,$3,$3	#r3=0xFF000000
		add	$3,$3,$3	#r3=0xFE000000
		add	$3,$3,$3	#r3=0xFC000000
		add	$6,$3,$3	#r6=0xF8000000
		add	$3,$6,$6	#r3=0xF0000000
		add	$4,$3,$3	#r4=0xE0000000
		add	$13,$4,$4	#r13=0xC0000000
		add	$8,$13,$13	#r8=0x80000000
		slt	$2,$0,$1	#r2=0x00000001 unsigned slt
		add	$14,$2,$2	#r14=0x2
		add	$14,$14,$14	#r14=0x4
		nor	$10,$0,$0	#r10=0xFFFFFFFF
		add	$10,$10,$10	#r10=0xFFFFFFFE
		sw	$6,4($3)	#counter port:f0000004,r6=0xF8000000
		lw	$5,0($3)	#{counter0_out,counter1_out,counter2_out,led_out[12:0], SW};
		add	$5,$5,$5
		add	$5,$5,$5
		sw	$5,0($3)	#{GPIOf0[13:0],LED,counter_set}, port:f0000000
		add	$9,$9,$2	#r9 uninitilized, r9 = 1
		sw	$9,0($4)	#r9送r4=0xE0000000七段码端口
		lw	$13,0x14($0)	#r13=0xFFF7000
loop:	lw	$5,0($3)	#{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
		add	$5,$5,$5
		add	$5,$5,$5
		sw 	$5,0($3)	#{GPIOf0[13:0],LED,counter_set}, port:f0000000
		lw 	$5,0($3)	#{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
		and	$11,$5,$8	#取r5最高位
		add	$13,$13,$2	#r13=0xFFF7001
		beq	$13,$0,next
Disp:	lw 	$5,0($3)
		add	$18,$14,$14
		add	$22,$18,$18	#r22=0x10
		add	$18,$18,$22	#r18=0x18
		and	$11,$5,$18
		beq	$11,$0,L00	#SW[4:3]=0x00,移位
		beq	$11,$18,L11	#SW[4:3]=0x11，显示七段图形
		add	$18,$14,$14	#r18=0x8
		beq	$11,$18,L01	#SW[4:3]=0x01,显示7段预置数字
		sw	$9,0($4)	#SW[4:3]=0x10，显示r9
		j	loop
L00:	beq $10,$1,L4	#r1=0xFFFFFFFF
		j	L3
L4:		nor	$10,$0,$0	#r10=0xFFFFFFFF
		add	$10,$10,$10	#r10=0xFFFFFFFE
L3:		sw	$10,0($4)	#7段图形显示r10
		j	loop
L11:	lw	$9,0x60($17)
		sw	$9,0($4)	#7段图形显示$9
		j	loop
L01:	lw	$9,0x20($17)
		sw	$9,0($4)	#7段文本显示S9
		j	loop
next:	lw	$13,0x14($0)	#r13=0xFFF7000
		add	$10, $10, $10
		or	$10, $10, $2
		add	$17, $17, $14	#访存地址加4
		and	$17, $17, $20	#r20=0x0000003F
		add	$9, $9, $2	#r9=r9+1
		beq	$9, $1, L2	#r1=0xFFFFFFFF
		j	L5
L2:		add	$9, $0, $14	#r9=0x4
		add $9, $9, $2	#r9=0x5
L5:		lw  $5, 0($3)	#{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
		add $11, $5, $5
		add $11, $11, $11
		sw	$11, 0($3)	#{GPIOf0[13:0],LED,counter_set}, port:f0000000
		sw  $6, 4($3)	#counter port:f0000004,r6=0xF8000000
		lw	$5, 0($3)	#{counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
		and $11, $5, $8	#取r5最高位
		j	Disp