.text
.global _start

_start:
    movia r2, 0x10000020 #Hex3-Hex0 
    movia r4, 500000
    movia r3, 0x3F
    addi  r6, r0, 4


loop:
    stwio r3, 0(r2)
    call counter
    roli r3, r3, 8
    addi r6, r6, -1
    bne r6, r0, loop
    addi  r6, r0, 4
    br loop
counter: 
	addi r4, r4, -1
    bne r4, r0, counter
    movia r4, 500000
    ret
    
.end
