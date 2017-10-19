# EC_Pract2

| Base Address | End Address | I/O Peripheral                             |
|-------------|-------------|--------------------------------------------|
| 0x00000000  | 0x007FFFFF  | SDRAM (8 MB)                               |}
| 0x08000000  | 0x0807FFFF  | SRAM (512 KB)                              |)  Memory
| 0x09000000  | 0x09001FFF  | On-chip Memory (Variable, max = 4 KB)      |}
|                           						 |
| 0x10000000  | 0x1000000F  | Red LED parallel port                      |}
| 0x10000010  | 0x1000001F  | Green LED parallel port (16)               |)
| 0x10000020  | 0x1000002F  | 7-segment HEX3-HEX0 displays parallel port |)
| 0x10000030  | 0x1000003F  | 7-segment HEX7-HEX4 displays parallel port |)
| 0x10000040  | 0x1000004F  | Slider switch parallel port                |)
| 0x10000050  | 0x1000005F  | Pushbutton parallel port                   |)  I/O
| 0x10000060  | 0x1000006F  | JP1 Expansion parallel port                |)
| 0x10000070  | 0x1000007F  | JP2 Expansion parallel port                |)
| 0x10001000  | 0x10001007  | JTAG UART port                             |)
| 0x10001010  | 0x10001017  | Serial port (7)                            |)
| 0x10002000  | 0x1000201F  | Interval timer                             |)
| 0x10002020  | 0x10002027  | System ID                                  |}

![alt text](https://github.com/BIoodHound/EC_Pract2/blob/master/DE2cap.PNG)

In this example we are going to use the HEX7-HEX4 displays on the left which has an assigned base address of 0x10000030 to represent the number 0 using the following instructions.

```assembly
movia r2, 0x10000030 #Initializes the register r2 with the base address of the parallel port
addi r3, r0, 0x3F #Initializes the register r3 with a bit pattern that matches with the hex value 0x3F = 111111 = 0 on display
stwio r3, 0(r2) #Initializes the mapped register on the address that signals r2 with the pattern of bits registered on the register r3
```
![alt text](https://github.com/BIoodHound/EC_Pract2/blob/master/Salida.PNG)


![alt text](https://github.com/BIoodHound/EC_Pract2/blob/master/DE2cap2.PNG)

Here we will observe another port from the DE2 Basic Computer, that is this case is assigned to the Base Address 0x10000040. It's main function is to register the state of various switches that range from SW17 to SW0 totaling 18 switches with each its own assigned bit. To read the state of any of these switches we read the data register using the instruction "ldwio".

An example of a program that reads the state of the switches is the following.

```assembly
movia r3, 0x10000040 #Initializes the register r3 with the Base Address of the parallel port
ldwio r4, 0(r3) #Initializes the register r4 with a bit pattern given by the parallel port
```

##Ejemplo 1
```assembly

********************************************************************
* This program demonstrates the use of parallel ports in the DE2 Basic
Computer:
* 1. displays the SW switch values on the red LEDR
* 2. displays the KEY[3..1] pushbutton values on the green LEDG
* 3. displays a rotating pattern on the HEX displays
* 4. if KEY[3..1] is pressed, uses the SW switches as the pattern
*********************************************************************/

.text				/* executable code follows */
.global _start
_start:
	/* initialize base addresses of parallel ports */
	movia r15, 0x10000040	/* SW slider switch base address */
	movia r16, 0x10000000	/* red LED base address */
	movia r17, 0x10000050	/* pushbutton KEY base address */
	movia r18, 0x10000010	/* green LED base address */
	movia r20, 0x10000020	/* HEX3_HEX0 base address */
	movia r21, 0x10000030	/* HEX7_HEX4 base address */
	movia r19, HEX_bits
	ldwio r6, 0(r19)	/* load pattern for HEX displays */
DO_DISPLAY:
	ldwio r4, 0(r15)	/* load input from slider switches */
	stwio r4, 0(r16)	/* write to red LEDs */
	ldwio r5, 0(r17)	/* load input from pushbuttons */
	stwio r5, 0(r18)	/* write to green LEDs */
	beq r5, r0, NO_BUTTON
	mov r6, r4		/* copy SW switch values onto HEX displays */
WAIT:
	ldwio r5, 0(r17)	/* load input from pushbuttons */
	bne r5, r0, WAIT	/* wait for button release */
NO_BUTTON:
	stwio r6, 0(r20)	/* store to HEX3 ... HEX0 */
	stwio r6, 0(r21)	/* store to HEX7 ... HEX4 */
	roli r6, r6, 1		/* rotate the displayed pattern */
	movia r7, 500000	/* delay counter */
DELAY:
	subi r7, r7, 1
	bne r7, r0, DELAY
	br DO_DISPLAY

.data				/* data follows */
HEX_bits:
.word 0x0000000F
.end



```

##Ejemplo 2

```assembly
/*********************************************************************
* This program demonstrates use of the JTAG UART port in the DE2 Basic Computer
*
* It performs the following:
* 1. sends a text string to the JTAG UART
* 2. reads character data from the JTAG UART
* 3. echos the character data back to the JTAG UART
*********************************************************************/

.text /* executable code follows */
.global _start
_start:
	/* set up stack pointer */
	movia sp, 0x007FFFFC	/* stack starts from highest memory address in SDRAM */
	movia r6, 0x10001000	/* JTAG UART base address */
	/* print a text string */
	movia r8, TEXT_STRING
LOOP:
	ldb r5, 0(r8)
	beq r5, zero, GET_JTAG	/* string is null-terminated */
	call PUT_JTAG
	addi r8, r8, 1
	br LOOP
	/* read and echo characters */
GET_JTAG:
	ldwio r4, 0(r6)		/* read the JTAG UART Data register */
	andi r8, r4, 0x8000	/* check if there is new data */
	beq r8, r0, GET_JTAG	/* if no data, wait */
	andi r5, r4, 0x00ff	/* the data is in the least significant byte */
	call PUT_JTAG		/* echo character */
	br GET_JTAG
.end



/********************************************************************
* Subroutine to send a character to the JTAG UART
* r5 = character to send
* r6 = JTAG UART base address
*********************************************************************/

.global PUT_JTAG
PUT_JTAG:
	/* save any modified registers */
	subi sp, sp, 4 /* reserve space on the stack */
	stw r4, 0(sp) /* save register */
	ldwio r4, 4(r6) /* read the JTAG UART Control register */
	andhi r4, r4, 0xffff /* check for write space */
	beq r4, r0, END_PUT /* if no space, ignore the character */
	stwio r5, 0(r6) /* send the character */
END_PUT:
	/* restore registers */
	ldw r4, 0(sp)
	addi sp, sp, 4
	ret
.data /* data follows */
.global TEXT_STRING
TEXT_STRING:
.asciz "\nJTAG UART example code\n"
.end
```

##Ejemplo 3a

```assembly

.equ KEY1, 0
.equ KEY2, 1

/*********************************************************************
* This program demonstrates use of interrupts in the DE2 Basic Computer. It first starts the interval timer with 33 msec timeouts, and then enables interrupts from the interval timer and pushbutton KEYs
* The interrupt service routine for the interval timer displays a pattern on the HEX displays, and shifts this pattern either left or right. The shifting direction is set in the pushbutton interrupt service routine, as follows:
* KEY[1]: shifts the displayed pattern to the right
* KEY[2]: shifts the displayed pattern to the left
* KEY[3]: changes the pattern using the settings on the SW switches
*********************************************************************/

.text /* executable code follows */
.global _start
_start:
	/* set up stack pointer */
	movia sp, 0x007FFFFC	/* stack starts from highest memory address in SDRAM */
	movia r16, 0x10002000	/* internal timer base address */
	/* set the interval timer period for scrolling the HEX displays */
	movia r12, 0x190000	/* 1/(50 MHz) � (0x190000) = 33 msec */
	sthio r12, 8(r16)	/* store the low halfword of counter start value */
	srli r12, r12, 16
	sthio r12, 0xC(r16)	/* high halfword of counter start value */
	/* start interval timer, enable its interrupts */
	movi r15, 0b0111	/* START = 1, CONT = 1, ITO = 1 */
	sthio r15, 4(r16)
	/* write to the pushbutton port interrupt mask register */
	movia r15, 0x10000050	/* pushbutton key base address */
	movi r7, 0b01110	/* set 3 interrupt mask bits (bit 0 is Nios II reset) */
	stwio r7, 8(r15)	/* interrupt mask register is (base + 8) */
	/* enable Nios II processor interrupts */
	movi r7, 0b011		/* set interrupt mask bits for levels 0 (interval */
	wrctl ienable, r7	/* timer) and level 1 (pushbuttons) */
	movi r7, 1
	wrctl status, r7	/* turn on Nios II interrupt processing */
IDLE:
	br IDLE			/* main program simply idles */
.data
/* The two global variables used by the interrupt service routines for the interval timer and the pushbutton keys are declared below */
.global PATTERN
PATTERN:
.word 0x0000000F		/* pattern to show on the HEX displays */
.global KEY_PRESSED
KEY_PRESSED:
.word KEY2			/* stores code representing pushbutton key pressed */
.end


```
