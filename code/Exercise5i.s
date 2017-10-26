.text
.global _start

_start:
    movia sp, 0x007FFFFC
    movia r2, 0x00000050 #Initialize r2 with the push button parallel port
    movia r3, 
