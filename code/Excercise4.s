#Diseñar un programa ensamblador que encienda en la placa DE2 los leds rojos
#correspondientes a los interruptores que no estén activados.
.text
.global _start
_start:
    movia r2, 0x10000040 #Switch
    movia r3, 0x10000000 #LED Rojo

loop:
    ldwio r6, 0(r2) #Load input from the slider switch
    
    stwio r6, 0(r3) #write to red LEDs
    br loop
        
.end    
