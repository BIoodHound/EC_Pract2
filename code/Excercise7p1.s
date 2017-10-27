.global _start

_start:
	movia sp, 0x007FFFFC

	movia r2, 0x10000050
	movia r3, 0x10000000

	movia r4, 0b0110
	stwio r4, 8(r2)

	movia r2, 0b011
	wrctl ienable, r2

	movia r2, 1
	wrctl status, r2

IDLE: br IDLE





.section .reset, "ax"
	movia r2, _start
	jmp r2
