.global _start

start:
    movia r2, 0x10000020 #Initialize r2 the hex7-4
    movia r3, 0x10000050 #Initialize r3 with the push keys
    addi r4, r0, 0x3F #Initializes the register r3 to the hex value of 0x3F which will display a cero
    stwio r4, 0(r2) #Initializes the mapped register on the address that signals r2 with the pattern of bits registered on the register r3
    movia r6, 0x6 #1
    movia r7, 0x5B #2
    movia r8, 0x4F #3
wait:
    ldwio r5, 0(r3)
    beq r5, 0x2, key1
    beq r5, 0x4, key2
    beq r5, 0x8, key3
    bne r5, r0, wait
key1:
    movia r5, r0
    stwio r6, 0(r5)
key2:
    movia r5, r0
    stwio r7, 0(r5)
key3:
    movia r5, r0
    stwio r8, 0(r5)
.end
