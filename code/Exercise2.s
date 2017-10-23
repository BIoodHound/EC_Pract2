.global _start
_start:
    movia r2, 0x10000010
    movia r3, 0x1
    movia r4, 0x500000
    addi r5, r0, 8
loop:
    addi r4, r4, -1
    bne r4, r0, loop

alter:
    stwio r2, 0(r3)
    roli r3, r3, 1
    addi r5, r5, -1
    bne r5, r0, loop
    addi r5, r0, 8
    br loop

.end
