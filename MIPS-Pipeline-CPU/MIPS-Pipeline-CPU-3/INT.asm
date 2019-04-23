		addi $v0, $zero, 0x5
		ori $v1, $zero, 0xc
		subu $at, $v1, $v0
		srl $a3, $at, 0x1
		j Label1				#0x15
		or $a0, $a3, $v0
		and $a1, $v1, $a0
		add $a1, $a1, $a0
		beq $a1, $a3, Label2	#0x18
		sltu $a0, $v1, $a0			
		beq $a0, $zero, Label4	#0x3
		addi $a1, $zero, 0x0
		addi $a1, $zero, 0x0
		addi $a1, $zero, 0x0
Label4:
		slt $a0, $a3, $v0
		addu $a3, $a0, $a1
		sub $a3, $a3, $a2
		sw $a3, 0x44($v1)
		lw $v0, 0x50($zero)
		j Label2				#0x21
		addi $v0, $zero, 0x1
Label1:
		sll $a3, $a3, 0x2
		jal Label3				#0x19
		addi $ra, $zero, 0x3014
		jr $ra
Label3:
		lui $at, 0xffaa
		slt $at, $a3, $at
		bne $at, $zero, Label2	#0x5
		sub $a3, $a3, $v0
		srl $a3, $a3, 0x1
		nor $at, $a3, $at			
		sltu $at, $at, $a3
		jr $ra
Label2:
		sw $v1, 0x54($zero)
		lw $a3, 0x48($v1)
		sw $a3, 0x44($v1)