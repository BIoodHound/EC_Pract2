.global _start

_start:
    movia r2, 0x10000020 # Initialize r2 the hex3-0
    movia r3, 0x10000050 # Initialize r3 with the push keys
    movia r4, 0x3F # Initializes the register r3 to the hex value of 0x3F which will display a cero
    stwio r4, 0(r2) # Initializes the mapped register on the address that signals r2 with the pattern of bits registered on the register r3
    movia r16, 0x06 # 1
    movia r17, 0x5B # 2
    movia r18, 0x4F # 3
    movia r19, 0x2
    movia r20, 0x4
    movia r21, 0x8
wait:

    ldwio r5, 0(r3) #initializes r5 with the push button value
    beq r5, r19, key1
    beq r5, r20, key2
    beq r5, r21, key3
    br wait
key1:
    stwio r16, 0(r2)
    br wait
key2:
    stwio r17, 0(r2)
    br wait
key3:
    stwio r18, 0(r2)
    br wait
.end
