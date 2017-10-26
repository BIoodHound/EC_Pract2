#   Diseñar un programa ensamblador que encienda alternativamente cada uno de los leds verdes de la placa DE2. 

# Yet to test on board possible overflow error

.text
_start:
    movia r2, 0x10000010 # Green LED
    movia r3, 0x1 # Initialize a bit to the r3 register
    movia r4, 0x500000
    addi r5, r0, 7
    stwio r0, 0(r2) # just in case reset the green leds 
    
alter:
    stwio r3, 0(r2) 
    roli r3, r3, 1
    addi r5, r5, -1
    call loop
    stwio r0, 0(r2)
    bne r5, r0, alter
    addi r5, r0, 7
    movia r3, 0x1 #reposition bit to prevent overflow
    br alter
    
loop:
    addi r4, r4, -1
    bne r4, r0, loop
    ret
.end
