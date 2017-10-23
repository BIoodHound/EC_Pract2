.global _start

start:
    movia r2, 0x10000020 #Hex3-Hex0 
    movia r3, 0c10000030 #Hex7-Hex4
    addi r4, r0, 500000
    movia r16, cero
    ldwio r5, 0(r16)
    addi  r6, r0, 4
    
loop:
    addi r4, r4, -1
    bne r4, r0, loop
    stwio r5, 0(r2)
    rol r5, r5, 7
    addi r6, r0, -1
    addi r4, r0, 500000
    bne r6, r0 loop
    ldwio r5, 0(r16)
    br loop
    
.data
cero: 
.word 0x0000001f

.end
