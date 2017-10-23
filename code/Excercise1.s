#Assembly program that turns on repeatedly the red LEDs in a DE2 basic computer in a odd and even order.

.global_start

start:
	movia r2, 0x10000000 #Initializes the register r2 with the base address of the parallel port
	movia r3, odd 
	movia r4, even
	addi r5, r0, 500000

odd: 
	stwio r2, 0(r3)
	subi r5, r5, 1
	bne r5, r0, odd
	addi r5, r0, 500000
even: 
	stwio r2, 0(r4)
	subi r5, r5, 1
	bne r5, r0, even
	addi r5, r0, 500000
	br impar
	
.data 
even:
.word 0x00015555
odd:
.word 0x0000aaaa 
.end
