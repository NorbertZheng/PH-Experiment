            j       start
            mfc0    $26,$13
            beq     $26,$6,Change
            beq     $26,$0,Next
            eret

start:      
            lui     $11,0x0000
            lui     $15, 0x0010             #$15=0xFFF70000
            lui	    $3, 0xf000			    #$3=0xF0000000
            lui     $8, 0xe000              #$8=0xE0000000
            lui     $29,0xFFF7
            addi    $4,$0, 0x0001           #$4=0x00000001
            addi    $6,$0, 0x0004           #$6=0x00000004
            nor     $1,$0,$0                #$1=0xFFFFFFFF
            addi    $10,$1,-1               #$10=0xFFFFFFFE
            lw      $5,0($3)                #load to $5{SW}
            add     $5,$5,$5                #left
            add     $5,$5,$5                #left
            sw      $5,0($3)                #LEDs
            addu    $9,$0,$4                #$9=1
            addi    $20,$0,0x0018           #$20 is mask of SW
            addi    $21,$0,0x0000           #$21 is SW[4:3]=00
            addi    $22,$0,0x0008           #$22 is SW[4:3]=01
            addi    $23,$0,0x0010           #$23 is SW[4:3]=10
            addi    $24,$0,0x0018           #$24 is SW[4:3]=11
            add     $17,$0,$0               #$17 = 0 initially
            sw      $15,4($3)               #save counter 0
            addi    $t9,$0,0x000f           #$25=0x0000000f
            mtc0    $t9,$12                 #set s1us
Loop:
            lw      $5,0($3)                #load to $5{SW}
            addu    $5,$5,$5                #left
            addu    $5,$5,$5                #left
            sw      $5,0($3)                #LEDs
            lw      $5,0($3)                #load to $5{SW}
            and     $5,$5,$20
            syscall
            beq     $11,$21,L00
            beq     $11,$22,L01
            beq     $11,$23,L10
            beq     $11,$24,L11
            j       Loop

L00:		
            bne	    $1, $10, L3		        # r10 L3
            nor     $10, $0, $0	            # r10=0xffffffff
            addu    $10, $10, $10		    # r10=0xfffffffe
L3:			
            sw      $10, 0($8)			    # SW[4:3]=00
            j	    Loop
L11:		
            lw      $9, 0x40($17)
            sw      $9, 0x0($8)				# SW[4:3]=11，显示七段图形
            j       Loop
L01:		
            lw      $9, 0($17)
            sw      $9, 0($8)				# SW[4:3]=01,七段显示预置数字
            j       Loop
L10:        
            sw      $17, 0($8)
            j       Loop



Next:
            sw      $15,4($3)              #save counter 0
            add	    $10, $10, $10
            ori	    $10, $10,1		       #r10末位置1，对应右上角不显示
            addi    $17,$17,4			   # r17=00000004，LED图形访存地址+4
            andi    $17,$17,0x3f           # r17=000000XX，屏蔽地址高位，只取6位
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            eret

Change:
            add     $29,$29,$4
            beq     $29,$0,ChangeL1    
            eret
ChangeL1: 
            lui     $29,0xFFA0
            xori    $11,$11,0x0018
            eret


