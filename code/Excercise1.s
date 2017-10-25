#Assembly program that turns on repeatedly the red LEDs in a DE2 basic computer in a odd and even order.

.global _start

_start:
	movia r2, 0x10000000 #Initializes the register r2 with the base address of the parallel port
	movia r3, 0x0002aaaa 
	movia r4, 0x00015555
	movia r5, 500000
	stwio r0, 0(r2)


odd: 
	stwio r3, 0(r2)
	call counter	
	br even
even: 
	stwio r4, 0(r2)
	call counter	
	br odd

counter: 
	subi r5, r5, 1
	bne r5, r0, counter
	stwio r0, 0(r2)
	movia r5, 500000
	ret
.end
