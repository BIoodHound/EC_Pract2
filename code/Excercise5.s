.global _start

start:
    movia r2, 0x10000030 #Initialize r2 the hex7-4
    movia r3, 0x10000050 #Initialize r3 with the push keys
    addi r4, r0, 0x3F #Initializes the register r3 to the hex value of 0x3F which will display a cero
    stwio r4, 0(r2) #Initializes the mapped register on the address that signals r2 with the pattern of bits registered on the register r3
display:
    
    
wait:
    ldwio r5, 0(r3)
    bne r5, r0, wait
    stwio r4, 0(r5)
    movia r5, r0
    br wait
.end
