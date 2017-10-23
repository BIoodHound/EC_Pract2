.global _start
start:
    movia r2, 0x10000040 #Switch
    movia r3, 0x10000000 #LED Rojo

loop:
    ldwio r4, 0(r2) #Load input from the slider switch
    roli r4, r4, 1
    stwio r4, 0(r3) #write to red LEDs
    br loop
        
.end    
