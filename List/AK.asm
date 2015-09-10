
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _flagtancong=R4
	.DEF _offsetphongthu=R6
	.DEF _goctancong=R8
	.DEF _cmdCtrlRobot=R10
	.DEF _idRobot=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  _timer2_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_ASCII:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x10,0x8
	.DB  0x8,0x10,0x8,0x78,0x46,0x41,0x46,0x78

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7
_0x4:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7
_0x20006:
	.DB  0x1
_0x20007:
	.DB  0xA
_0x20008:
	.DB  0x1
_0x20009:
	.DB  0xA
_0x2000A:
	.DB  0x1
_0x20053:
	.DB  0x1
_0x201F9:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x20348:
	.DB  0x1,0x0,0x0,0x0,0x0,0x0
_0x20000:
	.DB  0x25,0x64,0x0,0x25,0x30,0x2E,0x32,0x66
	.DB  0x0,0x20,0x3C,0x41,0x4B,0x42,0x4F,0x54
	.DB  0x4B,0x49,0x54,0x3E,0x0,0x44,0x69,0x73
	.DB  0x74,0x61,0x6E,0x63,0x65,0x20,0x53,0x71
	.DB  0x75,0x61,0x72,0x65,0x3A,0x20,0x25,0x66
	.DB  0x20,0xA,0xD,0x0,0x52,0x6F,0x62,0x6F
	.DB  0x74,0x2E,0x78,0x3A,0x20,0x25,0x64,0x20
	.DB  0xA,0xD,0x0,0x52,0x6F,0x62,0x6F,0x74
	.DB  0x2E,0x79,0x3A,0x20,0x25,0x64,0x20,0xA
	.DB  0xD,0x0,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x20,0xA,0xD,0x0,0x52,0x4F,0x42
	.DB  0x4F,0x54,0x20,0x57,0x41,0x4C,0x4C,0x0
	.DB  0x57,0x48,0x49,0x54,0x45,0x20,0x4C,0x49
	.DB  0x4E,0x45,0x0,0x46,0x4F,0x4C,0x4F,0x57
	.DB  0x45,0x52,0x0,0x42,0x4C,0x41,0x43,0x4B
	.DB  0x20,0x4C,0x49,0x4E,0x45,0x0,0x42,0x4C
	.DB  0x55,0x45,0x54,0x4F,0x4F,0x54,0x48,0x0
	.DB  0x44,0x52,0x49,0x56,0x45,0x0,0x54,0x45
	.DB  0x53,0x54,0x20,0x4D,0x4F,0x54,0x4F,0x52
	.DB  0x0,0x4D,0x6F,0x74,0x6F,0x72,0x4C,0x0
	.DB  0x4D,0x6F,0x74,0x6F,0x72,0x52,0x0,0x54
	.DB  0x45,0x53,0x54,0x20,0x55,0x41,0x52,0x54
	.DB  0x0,0x54,0x45,0x53,0x54,0x20,0x49,0x52
	.DB  0x0,0x30,0x2E,0x0,0x31,0x2E,0x0,0x32
	.DB  0x2E,0x0,0x33,0x2E,0x0,0x34,0x2E,0x0
	.DB  0x35,0x2E,0x0,0x36,0x2E,0x0,0x37,0x2E
	.DB  0x0,0x3C,0x53,0x45,0x4C,0x46,0x20,0x54
	.DB  0x45,0x53,0x54,0x3E,0x0,0x2A,0x2A,0x2A
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x0,0x52,0x43,0x20,0x53,0x45,0x52
	.DB  0x56,0x4F,0x0,0x31,0x2E,0x52,0x4F,0x42
	.DB  0x4F,0x54,0x20,0x57,0x41,0x4C,0x4C,0x0
	.DB  0x32,0x2E,0x42,0x4C,0x55,0x45,0x54,0x4F
	.DB  0x4F,0x54,0x48,0x20,0x0,0x33,0x2E,0x57
	.DB  0x48,0x49,0x54,0x45,0x20,0x4C,0x49,0x4E
	.DB  0x45,0x0,0x34,0x2E,0x42,0x4C,0x41,0x43
	.DB  0x4B,0x20,0x4C,0x49,0x4E,0x45,0x0,0x35
	.DB  0x2E,0x54,0x45,0x53,0x54,0x20,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x0,0x36,0x2E,0x54,0x45
	.DB  0x53,0x54,0x20,0x49,0x52,0x20,0x20,0x20
	.DB  0x0,0x37,0x2E,0x54,0x45,0x53,0x54,0x20
	.DB  0x52,0x46,0x20,0x20,0x20,0x0,0x38,0x2E
	.DB  0x54,0x45,0x53,0x54,0x20,0x55,0x41,0x52
	.DB  0x54,0x20,0x0,0x39,0x2E,0x52,0x43,0x20
	.DB  0x53,0x45,0x52,0x56,0x4F,0x20,0x0,0x31
	.DB  0x30,0x2E,0x55,0x50,0x44,0x41,0x54,0x45
	.DB  0x20,0x52,0x42,0x0,0x4D,0x41,0x49,0x4E
	.DB  0x20,0x50,0x52,0x4F,0x47,0x52,0x41,0x4D
	.DB  0x0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _TX_ADDRESS
	.DW  _0x3*2

	.DW  0x05
	.DW  _RX_ADDRESS
	.DW  _0x4*2

	.DW  0x01
	.DW  _id
	.DW  _0x20006*2

	.DW  0x01
	.DW  _KpR
	.DW  _0x20007*2

	.DW  0x01
	.DW  _KiR
	.DW  _0x20008*2

	.DW  0x01
	.DW  _KpL
	.DW  _0x20009*2

	.DW  0x01
	.DW  _KiL
	.DW  _0x2000A*2

	.DW  0x0C
	.DW  _0x2008F
	.DW  _0x20000*2+9

	.DW  0x0B
	.DW  _0x201B2
	.DW  _0x20000*2+93

	.DW  0x0B
	.DW  _0x201C7
	.DW  _0x20000*2+104

	.DW  0x08
	.DW  _0x201C7+11
	.DW  _0x20000*2+115

	.DW  0x0B
	.DW  _0x201FA
	.DW  _0x20000*2+123

	.DW  0x08
	.DW  _0x201FA+11
	.DW  _0x20000*2+115

	.DW  0x0A
	.DW  _0x20248
	.DW  _0x20000*2+134

	.DW  0x06
	.DW  _0x20248+10
	.DW  _0x20000*2+144

	.DW  0x0B
	.DW  _0x2025F
	.DW  _0x20000*2+150

	.DW  0x07
	.DW  _0x2025F+11
	.DW  _0x20000*2+161

	.DW  0x07
	.DW  _0x2025F+18
	.DW  _0x20000*2+168

	.DW  0x0A
	.DW  _0x20264
	.DW  _0x20000*2+175

	.DW  0x08
	.DW  _0x20265
	.DW  _0x20000*2+185

	.DW  0x03
	.DW  _0x20265+8
	.DW  _0x20000*2+193

	.DW  0x03
	.DW  _0x20265+11
	.DW  _0x20000*2+196

	.DW  0x03
	.DW  _0x20265+14
	.DW  _0x20000*2+199

	.DW  0x03
	.DW  _0x20265+17
	.DW  _0x20000*2+202

	.DW  0x03
	.DW  _0x20265+20
	.DW  _0x20000*2+205

	.DW  0x03
	.DW  _0x20265+23
	.DW  _0x20000*2+208

	.DW  0x03
	.DW  _0x20265+26
	.DW  _0x20000*2+211

	.DW  0x03
	.DW  _0x20265+29
	.DW  _0x20000*2+214

	.DW  0x0C
	.DW  _0x20269
	.DW  _0x20000*2+217

	.DW  0x0D
	.DW  _0x20269+12
	.DW  _0x20000*2+229

	.DW  0x09
	.DW  _0x202D2
	.DW  _0x20000*2+242

	.DW  0x0D
	.DW  _0x202DE
	.DW  _0x20000*2+251

	.DW  0x0D
	.DW  _0x202DE+13
	.DW  _0x20000*2+251

	.DW  0x0D
	.DW  _0x202DE+26
	.DW  _0x20000*2+264

	.DW  0x0D
	.DW  _0x202DE+39
	.DW  _0x20000*2+277

	.DW  0x0D
	.DW  _0x202DE+52
	.DW  _0x20000*2+290

	.DW  0x0D
	.DW  _0x202DE+65
	.DW  _0x20000*2+303

	.DW  0x0D
	.DW  _0x202DE+78
	.DW  _0x20000*2+316

	.DW  0x0D
	.DW  _0x202DE+91
	.DW  _0x20000*2+329

	.DW  0x0D
	.DW  _0x202DE+104
	.DW  _0x20000*2+342

	.DW  0x0C
	.DW  _0x202DE+117
	.DW  _0x20000*2+355

	.DW  0x0D
	.DW  _0x202DE+129
	.DW  _0x20000*2+367

	.DW  0x0B
	.DW  _0x2031F
	.DW  _0x20000*2+10

	.DW  0x0D
	.DW  _0x2031F+11
	.DW  _0x20000*2+229

	.DW  0x0D
	.DW  _0x2031F+24
	.DW  _0x20000*2+380

	.DW  0x06
	.DW  0x04
	.DW  _0x20348*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <nRF24L01/nRF24L01.h>
;#include <delay.h>
;#include <spi.h>
;
;#define CSN    PORTC.2
;#define CE     PORTC.3
;#define SCK    PORTB.7
;#define MISO   PINB.6
;#define MOSI   PORTB.5
;//********************************************************************************
;//unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
;//unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
;unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi phat du lieu

	.DSEG
;unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi nhan du lieu
;//****************************************************************************************
;//*NRF24L01
;//***************************************************************************************/
;void init_NRF24L01(void)
; 0000 0015 {

	.CSEG
_init_NRF24L01:
; 0000 0016     //init SPI
; 0000 0017     SPCR=0x51; //set this to 0x50 for 1 mbits
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 0018     SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0019 
; 0000 001A     //inerDelay_us(100);
; 0000 001B     delay_us(100);
	__DELAY_USW 200
; 0000 001C  	CE=0;    // chip enable
	CBI  0x15,3
; 0000 001D  	CSN=1;   // Spi disable
	SBI  0x15,2
; 0000 001E  	//SCK=0;   // Spi clock line init high
; 0000 001F 	SPI_Write_Buf(WRITE_REG + TX_ADDR, TX_ADDRESS, TX_ADR_WIDTH);    //
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(_TX_ADDRESS)
	LDI  R31,HIGH(_TX_ADDRESS)
	CALL SUBOPT_0x0
; 0000 0020 	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, RX_ADDRESS, RX_ADR_WIDTH); //
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(_RX_ADDRESS)
	LDI  R31,HIGH(_RX_ADDRESS)
	CALL SUBOPT_0x0
; 0000 0021 	SPI_RW_Reg(WRITE_REG + EN_AA, 0x00);      // EN P0, 2-->P1
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0022 	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x01);  //Enable data P0
	LDI  R30,LOW(34)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0023 	SPI_RW_Reg(WRITE_REG + RF_CH, 2);        // Chanel 0 RF = 2400 + RF_CH* (1or 2 M)
	LDI  R30,LOW(37)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0024 	SPI_RW_Reg(WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH); // Do rong data truyen 32 byte
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0025 	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x07);   		// 1M, 0dbm
	LDI  R30,LOW(38)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0026 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Enable CRC, 2 byte CRC, Send
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0027 
; 0000 0028 }
	RET
;/****************************************************************************************************/
;//unsigned char SPI_RW(unsigned char Buff)
;//NRF24L01
;/****************************************************************************************************/
;unsigned char SPI_RW(unsigned char Buff)
; 0000 002E {
_SPI_RW:
; 0000 002F    return spi(Buff);
;	Buff -> Y+0
	LD   R30,Y
	ST   -Y,R30
	CALL _spi
	JMP  _0x20C0010
; 0000 0030 }
;/****************************************************************************************************/
;//unsigned char SPI_Read(unsigned char reg)
;//NRF24L01
;/****************************************************************************************************/
;unsigned char SPI_Read(unsigned char reg)
; 0000 0036 {
_SPI_Read:
; 0000 0037 	unsigned char reg_val;
; 0000 0038 
; 0000 0039 	CSN = 0;                // CSN low, initialize SPI communication...
	ST   -Y,R17
;	reg -> Y+1
;	reg_val -> R17
	CBI  0x15,2
; 0000 003A 	SPI_RW(reg);            // Select register to read from..
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_RW
; 0000 003B 	reg_val = SPI_RW(0);    // ..then read registervalue
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 003C 	CSN = 1;                // CSN high, terminate SPI communication
	SBI  0x15,2
; 0000 003D 
; 0000 003E 	return(reg_val);        // return register value
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0011
; 0000 003F }
;/****************************************************************************************************/
;//unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
;/****************************************************************************************************/
;unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
; 0000 0044 {
_SPI_RW_Reg:
; 0000 0045 	unsigned char status;
; 0000 0046 
; 0000 0047 	CSN = 0;                   // CSN low, init SPI transaction
	ST   -Y,R17
;	reg -> Y+2
;	value -> Y+1
;	status -> R17
	CBI  0x15,2
; 0000 0048 	status = SPI_RW(reg);      // select register
	LDD  R30,Y+2
	CALL SUBOPT_0x1
; 0000 0049 	SPI_RW(value);             // ..and write value to it..
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_RW
; 0000 004A 	CSN = 1;                   // CSN high again
	SBI  0x15,2
; 0000 004B 
; 0000 004C 	return(status);            // return nRF24L01 status uchar
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0015
; 0000 004D }
;/****************************************************************************************************/
;//unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
;//
;/****************************************************************************************************/
;unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
; 0000 0053 {
_SPI_Read_Buf:
; 0000 0054 	unsigned char status,uchar_ctr;
; 0000 0055 
; 0000 0056 	CSN = 0;                    		// Set CSN low, init SPI tranaction
	ST   -Y,R17
	ST   -Y,R16
;	reg -> Y+5
;	*pBuf -> Y+3
;	uchars -> Y+2
;	status -> R17
;	uchar_ctr -> R16
	CBI  0x15,2
; 0000 0057 	status = SPI_RW(reg);       		// Select register to write to and read status uchar
	LDD  R30,Y+5
	CALL SUBOPT_0x1
; 0000 0058 
; 0000 0059 	for(uchar_ctr=0;uchar_ctr<uchars;uchar_ctr++)
	LDI  R16,LOW(0)
_0x14:
	LDD  R30,Y+2
	CP   R16,R30
	BRSH _0x15
; 0000 005A 		pBuf[uchar_ctr] = SPI_RW(0);    //
	MOV  R30,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_RW
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0x14
_0x15:
; 0000 005C PORTC.2 = 1;
	SBI  0x15,2
; 0000 005D 
; 0000 005E 	return(status);                    // return nRF24L01 status uchar
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 005F }
;/*********************************************************************************************************/
;//uint SPI_Write_Buf(uchar reg, uchar *pBuf, uchar uchars)
;/*****************************************************************************************************/
;unsigned char SPI_Write_Buf(unsigned char reg, unsigned char *pBuf, unsigned uchars)
; 0000 0064 {
_SPI_Write_Buf:
; 0000 0065 	unsigned char status,uchar_ctr;
; 0000 0066 	CSN = 0;            //SPI
	ST   -Y,R17
	ST   -Y,R16
;	reg -> Y+6
;	*pBuf -> Y+4
;	uchars -> Y+2
;	status -> R17
;	uchar_ctr -> R16
	CBI  0x15,2
; 0000 0067 	status = SPI_RW(reg);
	LDD  R30,Y+6
	CALL SUBOPT_0x1
; 0000 0068 	for(uchar_ctr=0; uchar_ctr<uchars; uchar_ctr++) //
	LDI  R16,LOW(0)
_0x1B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1C
; 0000 0069 	SPI_RW(*pBuf++);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
	ST   -Y,R30
	RCALL _SPI_RW
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
; 0000 006A PORTC.2 = 1;
	SBI  0x15,2
; 0000 006B 	return(status);    //
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; 0000 006C }
;/****************************************************************************************************/
;//void SetRX_Mode(void)
;//
;/****************************************************************************************************/
;void SetRX_Mode(void)
; 0000 0072 {
_SetRX_Mode:
; 0000 0073 	CE=0;
	CBI  0x15,3
; 0000 0074 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x07);   		// enable power up and prx
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0075 	CE = 1;
	SBI  0x15,3
; 0000 0076 	delay_us(130);    //
	__DELAY_USW 260
; 0000 0077 }
	RET
;/****************************************************************************************************/
;//void SetTX_Mode(void)
;//
;/****************************************************************************************************/
;void SetTX_Mode(void)
; 0000 007D {
; 0000 007E 	CE=0;
; 0000 007F 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		// Enable CRC, 2 byte CRC, Send
; 0000 0080 	CE = 1;
; 0000 0081 	delay_us(130);    //
; 0000 0082 }
;
;/******************************************************************************************************/
;//unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
;/******************************************************************************************************/
;unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
; 0000 0088 {
_nRF24L01_RxPacket:
; 0000 0089     unsigned char revale=0;
; 0000 008A     unsigned char sta;
; 0000 008B 	sta=SPI_Read(STATUS);	// Read Status
	ST   -Y,R17
	ST   -Y,R16
;	*rx_buf -> Y+2
;	revale -> R17
;	sta -> R16
	LDI  R17,0
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_Read
	MOV  R16,R30
; 0000 008C 	//if(RX_DR)				// Data in RX FIFO
; 0000 008D     if((sta&0x40)!=0)		// Data in RX FIFO
	SBRS R16,6
	RJMP _0x27
; 0000 008E 	{
; 0000 008F 	    CE = 0; 			//SPI
	CBI  0x15,3
; 0000 0090 		SPI_Read_Buf(RD_RX_PLOAD,rx_buf,TX_PLOAD_WIDTH);// read receive payload from RX_FIFO buffer
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _SPI_Read_Buf
; 0000 0091 		revale =1;
	LDI  R17,LOW(1)
; 0000 0092 	}
; 0000 0093 	SPI_RW_Reg(WRITE_REG+STATUS,sta);
_0x27:
	LDI  R30,LOW(39)
	ST   -Y,R30
	ST   -Y,R16
	RCALL _SPI_RW_Reg
; 0000 0094     CE = 1; 			//SPI
	SBI  0x15,3
; 0000 0095 	return revale;
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C000E
; 0000 0096 }
;/***********************************************************************************************************/
;//void nRF24L01_TxPacket(unsigned char * tx_buf)
;//
;/**********************************************************************************************************/
;void nRF24L01_TxPacket(unsigned char * tx_buf)
; 0000 009C {
; 0000 009D 	CE=0;
;	*tx_buf -> Y+0
; 0000 009E 	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, TX_ADDRESS, TX_ADR_WIDTH); // Send Address
; 0000 009F 	SPI_Write_Buf(WR_TX_PLOAD, tx_buf, TX_PLOAD_WIDTH); 			 //send data
; 0000 00A0 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Send Out
; 0000 00A1 	CE=1;
; 0000 00A2 }
;
;// --------------------END OF FILE------------------------
;// -------------------------------------------------------
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Evaluation
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/4/2015
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <stdio.h>
;#include <string.h>
;#include <stdarg.h>
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <spi.h>
;#include <nRF24L01/nRF24L01.h>
;#include <math.h>
;
;/* Debug mode definition */
;#define DEBUG_MODE 1    // USE OUR CODE, ask Phat for more details
;#define DEBUG_EN 1      // Blue tooth mode
;
;/* PIN DEFINITION */
;// PIN LED ROBO KIT
;
;//Hung comment a xamlin thing
;
;#define LEDL	PORTC.4
;#define LEDR	PORTC.5
;#define LEDFL   PORTA.4
;#define LEDFR   PORTA.5
;#define LEDBL   PORTA.6
;#define LEDBR   PORTA.7
;#define keyKT   PINC.0 // Nut ben trai
;#define keyKP   PINC.1 // Nut ben phai
;#define S0  PINA.0
;#define S1  PINA.1
;#define S2  PINA.2
;#define S3  PINA.3
;#define S4  PINA.7
;#define MLdir   PORTC.6
;#define MRdir   PORTC.7
;// PIN NOKIA 5110
;#define RST    PORTB.0
;#define SCE    PORTB.1
;#define DC     PORTB.2
;#define DIN    PORTB.5
;#define SCK    PORTB.7
;#define LCD_C     0
;#define LCD_D     1
;#define LCD_X     84
;#define LCD_Y     48
;#define Black 1
;#define White 0
;#define Filled 1
;#define NotFilled 0
;// VARIABLES FOR ROBOT CONTROL
;#define CtrVelocity    //uncomment de chon chay pid dieu khien van toc, va su dung cac ham vMLtoi,vMLlui,....
;#define ROBOT_ID 5
;#define SAN_ID 1  //CHON HUONG TAN CONG LA X >0;
;#define M_PI    3.14159265358979323846    /* pi */
;
;typedef   signed          char int8_t;
;typedef   signed           int int16_t;
;typedef   signed  long    int int32_t;
;typedef   unsigned         char uint8_t;
;typedef   unsigned        int  uint16_t;
;typedef   unsigned long    int  uint32_t;
;typedef   float            float32_t;
;typedef struct   {
;	float x;
;	float y;
;} Ball;
;typedef struct {
;	int x;
;	int y;
;} IntBall;
;typedef struct   {
;	float id;
;	float x;
;	float y;
;	float ox;
;	float oy;
;	Ball ball;
;} Robot;
;typedef struct {
;	int id;
;	int x;
;	int y;
;	int ox;
;	int oy;
;	IntBall ball;
;} IntRobot;
;
;// Nguyen move here
;
;#ifdef DEBUG_EN
;char debugMsgBuff[32];
;#endif
;void debug_out(char *pMsg, unsigned char len)
; 0001 0073 {

	.CSEG
_debug_out:
; 0001 0074 #ifdef DEBUG_EN
; 0001 0075 	char i = 0;
; 0001 0076 	for (i = 0; i < len; i++)
	ST   -Y,R17
;	*pMsg -> Y+2
;	len -> Y+1
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x20004:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x20005
; 0001 0077 	{
; 0001 0078 		putchar(*pMsg++);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	ST   -Y,R30
	RCALL _putchar
; 0001 0079 		delay_us(300);
	__DELAY_USW 600
; 0001 007A 	}
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 007B #endif
; 0001 007C 	return;
	LDD  R17,Y+0
	RJMP _0x20C000E
; 0001 007D }
;
;// FUNCTION DECLARATION
;IntRobot convertRobot2IntRobot(Robot robot);
;unsigned char readposition();
;void runEscBlindSpot();
;void ctrrobot();// can phai luon luon chay de dieu khien robot
;void rb_move(float x, float y);
;int rb_wait(unsigned long int time);
;void rb_rotate(int angle);     // goc xoay so voi truc x cua toa do
;void calcvitri(float x, float y);
;int calcVangle(int angle);
;
;// VARIABLES DECLARATION
;Robot rb;
;IntRobot robot11, robot12, robot13, robot21, robot22, robot23, robotctrl;
;float errangle = 0, distance = 0, orientation = 0;
;int flagtancong = 1;
;int offsetphongthu = 0;
;int goctancong = 0;
;unsigned char RxBuf[32];
;float setRobotX = 0;
;float setRobotY = 0;
;float setRobotXmin = 0;
;float setRobotXmax = 0;
;float setRobotAngleX = 0;
;float setRobotAngleY = 0;
;float offestsanco = 0;
;float rbctrlHomeX = 0;
;float rbctrlHomeY = 0;
;float rbctrlPenaltyX = 0;
;float rbctrlPenaltyY = 0;
;float rbctrlPenaltyAngle = 0;
;float rbctrlHomeAngle = 0;
;unsigned int cmdCtrlRobot, idRobot;
;unsigned int cntsethomeRB = 0;
;unsigned int cntstuckRB = 0;
;unsigned int cntunlookRB = 0;
;unsigned int flagunlookRB = 0;
;unsigned int cntunsignalRF = 0;
;unsigned int flagunsignalRF = 0;
;unsigned int flagsethome = 0;
;unsigned int flagselftest = 0;
;unsigned int cntselftest = 0;
;int leftSpeed = 0;
;int rightSpeed = 0;
;
;//======USER VARIABLES=========
;unsigned char id = 1;

	.DSEG
;//======IR READER VARIABLES====
;unsigned int IRFL = 0;
;unsigned int IRFR = 0;
;unsigned int IRBL = 0;
;unsigned int IRLINE[5];
;//======MOTOR CONTROL========
;//------VELOCITY CONTROL=====
;unsigned int timerstick = 0, timerstickdis = 0, timerstickang = 0, timerstickctr = 0;
;unsigned int vQEL = 0;  //do (xung/250ms)
;unsigned int vQER = 0;  //do (xung/250ms)
;unsigned int oldQEL = 0;
;unsigned int oldQER = 0;
;unsigned int svQEL = 0;  //dat (xung/250ms) (range: 0-22)
;unsigned int svQER = 0;  //dat (xung/250ms) (range: 0-22)
;static int seRki = 0, seLki = 0;
;int uL = 0;
;int uR = 0;
;int KpR = 10;
;int KiR = 1;
;int KpL = 10;
;int KiL = 1;
;#define LDIVR 1
;
;// Robot Control Algorithm
;// The idea is simple. There are two vectors: robot direction (vrb) and robot to target (vdes).
;// The vector vrb will rotate at an  angle of 'delta' which is equal to the  angle between 2 vectors.
;// So that two vectors will be on a same line and the robot can reach its destination.
;// However, in order to achieve robot's arrival with desired orientation, a new vector (vgoal), which
;// shows the desired orientation, is introduced and added to vrb before the rotation.
;
;// Return the absolute value
;int absolute(int a) {
; 0001 00CD int absolute(int a) {

	.CSEG
; 0001 00CE 	if (a > 0) return a;
;	a -> Y+0
; 0001 00CF 	return (-a);
; 0001 00D0 }
;
;float fabsolute(float a) {
; 0001 00D2 float fabsolute(float a) {
; 0001 00D3 	if (a > 0) return a;
;	a -> Y+0
; 0001 00D4 	return (-a);
; 0001 00D5 }
;float min3(float a, float b, float c){
; 0001 00D6 float min3(float a, float b, float c){
; 0001 00D7 	float m = a;
; 0001 00D8 	if (m > b) m = b;
;	a -> Y+12
;	b -> Y+8
;	c -> Y+4
;	m -> Y+0
; 0001 00D9 	if (m > c) m = c;
; 0001 00DA 	return m;
; 0001 00DB }
;float max3(float a, float b, float c){
; 0001 00DC float max3(float a, float b, float c){
; 0001 00DD 	float m = a;
; 0001 00DE 	if (m < b) m = b;
;	a -> Y+12
;	b -> Y+8
;	c -> Y+4
;	m -> Y+0
; 0001 00DF 	if (m < c) m = c;
; 0001 00E0 	return m;
; 0001 00E1 }
;
;void setSpeed(int leftSpeed, int rightSpeed) {
; 0001 00E3 void setSpeed(int leftSpeed, int rightSpeed) {
; 0001 00E4 	// Reset I of both wheel
; 0001 00E5 	seRki = 0;//reset thanh phan I
;	leftSpeed -> Y+2
;	rightSpeed -> Y+0
; 0001 00E6 	seLki = 0;//reset thanh phan I
; 0001 00E7 
; 0001 00E8 	// Left speed control
; 0001 00E9 	if (leftSpeed > 0) { // forward
; 0001 00EA 		MLdir = 1;
; 0001 00EB 	}
; 0001 00EC 	else {
; 0001 00ED 		MLdir = 0;
; 0001 00EE 		leftSpeed = -leftSpeed;
; 0001 00EF 	}
; 0001 00F0 	svQEL = leftSpeed; // Don't know this
; 0001 00F1 
; 0001 00F2 	// Right speed control
; 0001 00F3 	if (rightSpeed > 0) { // forward
; 0001 00F4 		MRdir = 1;
; 0001 00F5 	}
; 0001 00F6 	else {
; 0001 00F7 		MRdir = 0;
; 0001 00F8 		rightSpeed = -rightSpeed;
; 0001 00F9 	}
; 0001 00FA 	svQER = rightSpeed;
; 0001 00FB }
;
;/* For Dat */
;#define VBASE 15
;#define KMOVE 25
;
;int map(int x, int in_min, int in_max, int out_min, int out_max)
; 0001 0102 {
; 0001 0103   return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
;	x -> Y+8
;	in_min -> Y+6
;	in_max -> Y+4
;	out_min -> Y+2
;	out_max -> Y+0
; 0001 0104 }
;void kick(int x_des, int y_des, int x_goal, int y_goal, char mode){
; 0001 0105 void kick(int x_des, int y_des, int x_goal, int y_goal, char mode){
; 0001 0106 
; 0001 0107 	int vx_des, vy_des, vx_goal, vy_goal;                    // vdes & vgoal coordinates
; 0001 0108 	int rb_angle, des_angle, goal_angle, new_angle;       // angles of vrb, vdes, vgoal & (vdes + vgoal) to x-axis
; 0001 0109 	int rotation_angle;                           // this is needed to calculate motor velocity
; 0001 010A 	int minimum, maximum;                       //  this is needed to check whether vector a is between vector b and c
; 0001 010B 	int wl, wr;
; 0001 010C 	int vx_rb, vy_rb;
; 0001 010D 
; 0001 010E 	vx_des = x_des - robotctrl.x;            // vdes calculation
;	x_des -> Y+37
;	y_des -> Y+35
;	x_goal -> Y+33
;	y_goal -> Y+31
;	mode -> Y+30
;	vx_des -> R16,R17
;	vy_des -> R18,R19
;	vx_goal -> R20,R21
;	vy_goal -> Y+28
;	rb_angle -> Y+26
;	des_angle -> Y+24
;	goal_angle -> Y+22
;	new_angle -> Y+20
;	rotation_angle -> Y+18
;	minimum -> Y+16
;	maximum -> Y+14
;	wl -> Y+12
;	wr -> Y+10
;	vx_rb -> Y+8
;	vy_rb -> Y+6
; 0001 010F 	vy_des = y_des - robotctrl.y;
; 0001 0110 
; 0001 0111 	vx_goal = x_goal - x_des;            //vgoal calculation
; 0001 0112 	vy_goal = y_goal - y_des;
; 0001 0113 
; 0001 0114 	// Conversion to unit vector
; 0001 0115 	if (x_goal == 0)
; 0001 0116 		y_goal = y_goal / absolute(y_goal);
; 0001 0117 	else if (y_goal == 0)
; 0001 0118 		x_goal = x_goal / absolute(x_goal);
; 0001 0119 	else {
; 0001 011A 		y_goal = y_goal / absolute(x_goal);
; 0001 011B 		x_goal = x_goal / absolute(x_goal);
; 0001 011C 	}
; 0001 011D 
; 0001 011E 	// Angle calculation
; 0001 011F 	goal_angle = atan2(vy_goal, vx_goal);
; 0001 0120 	rb_angle = atan2(robotctrl.ox, robotctrl.oy);			// done
; 0001 0121 	des_angle = atan2(vy_des, vx_des);
; 0001 0122 
; 0001 0123 	// Adding vgoal to vrb
; 0001 0124 	// NEED TESTING
; 0001 0125 	vx_rb = robotctrl.ox + vx_goal;
; 0001 0126 	vy_rb = robotctrl.oy + vy_goal;
; 0001 0127 
; 0001 0128 	new_angle = atan2(vx_rb, vy_rb);
; 0001 0129 	rotation_angle = new_angle - des_angle;
; 0001 012A 
; 0001 012B 	//  *rotation_angle > 180* counter-measure
; 0001 012C 	if (rotation_angle < -PI) {
; 0001 012D 		rotation_angle = 2 * PI + rotation_angle;
; 0001 012E 		if (new_angle > des_angle)
; 0001 012F 			rotation_angle = -rotation_angle;
; 0001 0130 	}
; 0001 0131 
; 0001 0132 	if (rotation_angle > PI) {
; 0001 0133 		rotation_angle = 2 * PI - rotation_angle;
; 0001 0134 		if (new_angle > des_angle)
; 0001 0135 			rotation_angle = -rotation_angle;
; 0001 0136 	}
; 0001 0137 
; 0001 0138 	// *Spiral* counter-measure: Spiral happens when vdes is between the new vector and vrb
; 0001 0139 	minimum = min3(rb_angle, des_angle, new_angle);
; 0001 013A 	maximum = max3(rb_angle, des_angle, new_angle);
; 0001 013B 
; 0001 013C 	if (absolute(rb_angle - new_angle) > PI) {
; 0001 013D 		if (des_angle == maximum || des_angle == minimum)
; 0001 013E 			rotation_angle = rotation_angle / 15;
; 0001 013F 		else if (minimum < des_angle && des_angle < maximum)
; 0001 0140 			rotation_angle = rotation_angle / 15;
; 0001 0141 	}
; 0001 0142 
; 0001 0143 	// Motor speed calculation
; 0001 0144 	switch (mode) {
; 0001 0145 	case 'f': // Going forward
; 0001 0146 		wl = 30 + rotation_angle * 50;
; 0001 0147 		wr = 30 - rotation_angle * 50;
; 0001 0148 		break;
; 0001 0149 	case 'b': // Going backward
; 0001 014A 		rotation_angle = -rotation_angle;
; 0001 014B 		wl = 30 - rotation_angle * 50;
; 0001 014C 		wr = 30 + rotation_angle * 50;
; 0001 014D 		break;
; 0001 014E 	}
; 0001 014F 
; 0001 0150 	// Set the speed immediately
; 0001 0151 	leftSpeed = wl;
; 0001 0152 	rightSpeed = wr;
; 0001 0153 }
;//DAT
;int xrb_last=0;
;int yrb_last=0;
;float angle_last = 0;
;
;#define V_THRESHOLD 10
;
;float get_angle(){
; 0001 015B float get_angle(){
; 0001 015C 	int vx, vy;
; 0001 015D 	vx = (robotctrl.x - xrb_last);
;	vx -> R16,R17
;	vy -> R18,R19
; 0001 015E 	vy = (robotctrl.y - yrb_last);
; 0001 015F 	if ((fabsolute(vx) > V_THRESHOLD) || (fabsolute(vy) > V_THRESHOLD)) {
; 0001 0160 		xrb_last = robotctrl.x;
; 0001 0161 		yrb_last = robotctrl.y;
; 0001 0162 		angle_last = atan2(vy, vx);
; 0001 0163 	}
; 0001 0164 	return angle_last;
; 0001 0165 }
;void movePoint(IntRobot rbctrl, int x_des, int y_des, int angle, char mode){
; 0001 0166 void movePoint(IntRobot rbctrl, int x_des, int y_des, int angle, char mode){
; 0001 0167 
; 0001 0168 	int vx_des, vy_des, vx_goal, vy_goal;	                // vdes & vgoal coordinates
; 0001 0169 	float rb_angle, des_angle, goal_angle, new_angle;       // angles of vrb, vdes, vgoal & (vdes + vgoal) to x-axis
; 0001 016A 	int rotation_angle;
; 0001 016B 	int minimum, maximum;
; 0001 016C 	int wl, wr;
; 0001 016D 	int vx_rb, vy_rb;
; 0001 016E 	int dirx, diry;
; 0001 016F 
; 0001 0170 	vx_des = x_des - rbctrl.x;			// vdes calculation
;	rbctrl -> Y+49
;	x_des -> Y+47
;	y_des -> Y+45
;	angle -> Y+43
;	mode -> Y+42
;	vx_des -> R16,R17
;	vy_des -> R18,R19
;	vx_goal -> R20,R21
;	vy_goal -> Y+40
;	rb_angle -> Y+36
;	des_angle -> Y+32
;	goal_angle -> Y+28
;	new_angle -> Y+24
;	rotation_angle -> Y+22
;	minimum -> Y+20
;	maximum -> Y+18
;	wl -> Y+16
;	wr -> Y+14
;	vx_rb -> Y+12
;	vy_rb -> Y+10
;	dirx -> Y+8
;	diry -> Y+6
; 0001 0171 	vy_des = y_des - rbctrl.y;
; 0001 0172 
; 0001 0173 //	dirx = robotctrl.ox - robotctrl.x;
; 0001 0174 //	diry = robotctrl.oy - robotctrl.y;
; 0001 0175 
; 0001 0176 	switch (angle) { // vgoal calculation
; 0001 0177 	case 0: 	vx_goal = 1; vy_goal = 0; break;
; 0001 0178 	case 90: 	vx_goal = 0; vy_goal = 1; break;
; 0001 0179 	case 180: vx_goal = -1; vy_goal = 0; break;
; 0001 017A 	case -90: vx_goal = 0; vy_goal = -1; break;
; 0001 017B 	default:	vx_goal = 1; vy_goal = vx_goal * tan(angle); break;
; 0001 017C 	}
; 0001 017D 
; 0001 017E 	// Angle calculation
; 0001 017F 	//rb_angle = get_angle();
; 0001 0180 	rb_angle = orientation;
; 0001 0181 	des_angle = atan2(vy_des, vx_des);
; 0001 0182 
; 0001 0183 	// Adding vgoal to vrb
; 0001 0184 	vx_rb = dirx + vx_goal;
; 0001 0185 	vy_rb = diry + vy_goal;
; 0001 0186 
; 0001 0187 	new_angle = atan2(vy_rb, vx_rb);
; 0001 0188 	rotation_angle = new_angle - des_angle;
; 0001 0189 
; 0001 018A 	//  *rotation_angle > 180* counter-measure
; 0001 018B 	if (rotation_angle < -PI) {
; 0001 018C 		rotation_angle = 2 * PI + rotation_angle;
; 0001 018D 		if (new_angle > des_angle)               rotation_angle = -rotation_angle;
; 0001 018E 	}
; 0001 018F 	if (rotation_angle > PI) {
; 0001 0190 		rotation_angle = 2 * PI - rotation_angle;
; 0001 0191 		if (new_angle > des_angle)                rotation_angle = -rotation_angle;
; 0001 0192 	}
; 0001 0193 
; 0001 0194 	// *SPIral* counter-measure: SPIral happens when vdes is between the new vector and vrb
; 0001 0195 	minimum = min3(rb_angle, des_angle, new_angle);
; 0001 0196 	maximum = max3(rb_angle, des_angle, new_angle);
; 0001 0197 
; 0001 0198 	if (absolute(rb_angle - new_angle) > PI) {
; 0001 0199 		if (des_angle == maximum || des_angle == minimum)                rotation_angle = rotation_angle / 15;
; 0001 019A 		else
; 0001 019B 			if (minimum < des_angle && des_angle < maximum)               rotation_angle = rotation_angle / 15;
; 0001 019C 	}
; 0001 019D 
; 0001 019E 	// Motor speed calculation
; 0001 019F 	switch (mode) {
; 0001 01A0 	case 'f': // Going forward
; 0001 01A1 		wl = VBASE + rotation_angle * KMOVE;
; 0001 01A2 		wr = VBASE - rotation_angle * KMOVE;
; 0001 01A3 		break;
; 0001 01A4 	case 'b': // Going backward
; 0001 01A5 		rotation_angle = -rotation_angle;
; 0001 01A6 		wl = VBASE - rotation_angle * KMOVE;
; 0001 01A7 		wr = VBASE + rotation_angle * KMOVE;
; 0001 01A8 		break;
; 0001 01A9 	}
; 0001 01AA 	// Set speed for motor
; 0001 01AB     /*if (wl > 15){
; 0001 01AC         wl = map(wl,0,82,5,22);}
; 0001 01AD     else{
; 0001 01AE         wl = map(-wl,0,82,5,22);
; 0001 01AF         wl = -wl;
; 0001 01B0     }
; 0001 01B1     if (wr > 0){
; 0001 01B2         wr = map(wr,0,82,5,22);}
; 0001 01B3     else{
; 0001 01B4         wr = map(-wr,0,82,5,22);
; 0001 01B5         wr = -wr;
; 0001 01B6     } */
; 0001 01B7 
; 0001 01B8 	if (wl>15){
; 0001 01B9 		wl = map(wl, 15, 82, 5, 22);
; 0001 01BA 	}
; 0001 01BB 	else{
; 0001 01BC 		wl = map(wl, 15, -60, 5, 22);
; 0001 01BD 
; 0001 01BE 	}
; 0001 01BF 	if (wl>15){
; 0001 01C0 		wr = map(wl, 15, 82, 5, 22);
; 0001 01C1 	}
; 0001 01C2 	else{
; 0001 01C3 		wr = map(wl, 15, -60, 5, 22);
; 0001 01C4 	}
; 0001 01C5 
; 0001 01C6 	if (wl == wr){
; 0001 01C7 		wl = 11;
; 0001 01C8 		wr = 11;
; 0001 01C9 	}
; 0001 01CA 
; 0001 01CB 	leftSpeed = wl;
; 0001 01CC 	rightSpeed = wr;
; 0001 01CD 
; 0001 01CE #ifdef DEBUG_EN
; 0001 01CF     {
; 0001 01D0 	    /*char dbgLen;
; 0001 01D1 
; 0001 01D2         dbgLen = sprintf(debugMsgBuff, "ID: %d \n\r", robotctrl.id);
; 0001 01D3 		debug_out(debugMsgBuff, dbgLen);
; 0001 01D4 
; 0001 01D5         dbgLen = sprintf(debugMsgBuff, "x: %d \n\r", robotctrl.x);
; 0001 01D6 		debug_out(debugMsgBuff, dbgLen);
; 0001 01D7 
; 0001 01D8         dbgLen = sprintf(debugMsgBuff, "y: %d \n\r", robotctrl.y);
; 0001 01D9 		debug_out(debugMsgBuff, dbgLen);
; 0001 01DA 
; 0001 01DB         dbgLen = sprintf(debugMsgBuff, "Angles: %d \n\r", rb_angle*180/PI);
; 0001 01DC 		debug_out(debugMsgBuff, dbgLen);
; 0001 01DD 
; 0001 01DE 		dbgLen = sprintf(debugMsgBuff, "Left Speed: %d \n\r", leftSpeed);
; 0001 01DF 		debug_out(debugMsgBuff, dbgLen);
; 0001 01E0 
; 0001 01E1 		dbgLen = sprintf(debugMsgBuff, "Right Speed: %d \n\n\r", rightSpeed);
; 0001 01E2 		debug_out(debugMsgBuff, dbgLen);*/
; 0001 01E3 	}
; 0001 01E4 #endif
; 0001 01E5 }
;
;int squareDistance(int aX, int aY, int bX, int bY) {
; 0001 01E7 int squareDistance(int aX, int aY, int bX, int bY) {
; 0001 01E8 	return (bX - aX) * (bX - aX) + (bY - bX) * (bY - bX);
;	aX -> Y+6
;	aY -> Y+4
;	bX -> Y+2
;	bY -> Y+0
; 0001 01E9 }
;
;// some function to set speed = 0
;void stop() {
; 0001 01EC void stop() {
; 0001 01ED 
; 0001 01EE }
;
;void rotate(int angle){
; 0001 01F0 void rotate(int angle){
; 0001 01F1 	angle = angle * LDIVR * 0.5;
;	angle -> Y+0
; 0001 01F2 	setSpeed(angle, -angle);
; 0001 01F3 }
;
;// [ PHAT ]
;
;float getOrientation(){
; 0001 01F7 float getOrientation(){
; 0001 01F8 
; 0001 01F9 }
;
;
;//------POSITION CONTROL-----
;unsigned int sd = 0;// dat khoang cach  di chuyen (xung)
;unsigned int oldd = 0;// bien luu gia tri vi tri cu
;unsigned char flagwaitctrRobot = 0;
;//-----ANGLES CONTROL----
;unsigned int sa = 0;// dat goc quay (xung) ( 54 xung/vong quay)
;unsigned int olda = 0;// bien luu gia tri goc cu
;unsigned char  flagwaitctrAngle = 0;
;//-----ROBOT BEHAVIOR CONTROL-----
;unsigned int flagtask = 0;
;unsigned int flagtaskold = 0;
;unsigned int flaghuongtrue = 0;
;int verranglekisum = 0;
;//=====ENCODER======
;unsigned int QEL = 0;
;unsigned int QER = 0;
;//=====LCD=========
;unsigned char menu = 0, test = 0, ok = 0, runing_test = 0, run_robot = 0, ft = 1, timer = 0;

	.DSEG
;flash unsigned char ASCII[][5] = {
;	{ 0x00, 0x00, 0x00, 0x00, 0x00 } // 20
;	, { 0x00, 0x00, 0x5f, 0x00, 0x00 } // 21 !
;	, { 0x00, 0x07, 0x00, 0x07, 0x00 } // 22 "
;	, { 0x14, 0x7f, 0x14, 0x7f, 0x14 } // 23 #
;	, { 0x24, 0x2a, 0x7f, 0x2a, 0x12 } // 24 $
;	, { 0x23, 0x13, 0x08, 0x64, 0x62 } // 25 %
;	, { 0x36, 0x49, 0x55, 0x22, 0x50 } // 26 &
;	, { 0x00, 0x05, 0x03, 0x00, 0x00 } // 27 '
;	, { 0x00, 0x1c, 0x22, 0x41, 0x00 } // 28 (
;	, { 0x00, 0x41, 0x22, 0x1c, 0x00 } // 29 )
;	, { 0x14, 0x08, 0x3e, 0x08, 0x14 } // 2a *
;	, { 0x08, 0x08, 0x3e, 0x08, 0x08 } // 2b +
;	, { 0x00, 0x50, 0x30, 0x00, 0x00 } // 2c ,
;	, { 0x08, 0x08, 0x08, 0x08, 0x08 } // 2d -
;	, { 0x00, 0x60, 0x60, 0x00, 0x00 } // 2e .
;	, { 0x20, 0x10, 0x08, 0x04, 0x02 } // 2f /
;	, { 0x3e, 0x51, 0x49, 0x45, 0x3e } // 30 0
;	, { 0x00, 0x42, 0x7f, 0x40, 0x00 } // 31 1
;	, { 0x42, 0x61, 0x51, 0x49, 0x46 } // 32 2
;	, { 0x21, 0x41, 0x45, 0x4b, 0x31 } // 33 3
;	, { 0x18, 0x14, 0x12, 0x7f, 0x10 } // 34 4
;	, { 0x27, 0x45, 0x45, 0x45, 0x39 } // 35 5
;	, { 0x3c, 0x4a, 0x49, 0x49, 0x30 } // 36 6
;	, { 0x01, 0x71, 0x09, 0x05, 0x03 } // 37 7
;	, { 0x36, 0x49, 0x49, 0x49, 0x36 } // 38 8
;	, { 0x06, 0x49, 0x49, 0x29, 0x1e } // 39 9
;	, { 0x00, 0x36, 0x36, 0x00, 0x00 } // 3a :
;	, { 0x00, 0x56, 0x36, 0x00, 0x00 } // 3b ;
;	, { 0x08, 0x14, 0x22, 0x41, 0x00 } // 3c <
;	, { 0x14, 0x14, 0x14, 0x14, 0x14 } // 3d =
;	, { 0x00, 0x41, 0x22, 0x14, 0x08 } // 3e >
;	, { 0x02, 0x01, 0x51, 0x09, 0x06 } // 3f ?
;	, { 0x32, 0x49, 0x79, 0x41, 0x3e } // 40 @
;	, { 0x7e, 0x11, 0x11, 0x11, 0x7e } // 41 A
;	, { 0x7f, 0x49, 0x49, 0x49, 0x36 } // 42 B
;	, { 0x3e, 0x41, 0x41, 0x41, 0x22 } // 43 C
;	, { 0x7f, 0x41, 0x41, 0x22, 0x1c } // 44 D
;	, { 0x7f, 0x49, 0x49, 0x49, 0x41 } // 45 E
;	, { 0x7f, 0x09, 0x09, 0x09, 0x01 } // 46 F
;	, { 0x3e, 0x41, 0x49, 0x49, 0x7a } // 47 G
;	, { 0x7f, 0x08, 0x08, 0x08, 0x7f } // 48 H
;	, { 0x00, 0x41, 0x7f, 0x41, 0x00 } // 49 I
;	, { 0x20, 0x40, 0x41, 0x3f, 0x01 } // 4a J
;	, { 0x7f, 0x08, 0x14, 0x22, 0x41 } // 4b K
;	, { 0x7f, 0x40, 0x40, 0x40, 0x40 } // 4c L
;	, { 0x7f, 0x02, 0x0c, 0x02, 0x7f } // 4d M
;	, { 0x7f, 0x04, 0x08, 0x10, 0x7f } // 4e N
;	, { 0x3e, 0x41, 0x41, 0x41, 0x3e } // 4f O
;	, { 0x7f, 0x09, 0x09, 0x09, 0x06 } // 50 P
;	, { 0x3e, 0x41, 0x51, 0x21, 0x5e } // 51 Q
;	, { 0x7f, 0x09, 0x19, 0x29, 0x46 } // 52 R
;	, { 0x46, 0x49, 0x49, 0x49, 0x31 } // 53 S
;	, { 0x01, 0x01, 0x7f, 0x01, 0x01 } // 54 T
;	, { 0x3f, 0x40, 0x40, 0x40, 0x3f } // 55 U
;	, { 0x1f, 0x20, 0x40, 0x20, 0x1f } // 56 V
;	, { 0x3f, 0x40, 0x38, 0x40, 0x3f } // 57 W
;	, { 0x63, 0x14, 0x08, 0x14, 0x63 } // 58 X
;	, { 0x07, 0x08, 0x70, 0x08, 0x07 } // 59 Y
;	, { 0x61, 0x51, 0x49, 0x45, 0x43 } // 5a Z
;	, { 0x00, 0x7f, 0x41, 0x41, 0x00 } // 5b [
;	, { 0x02, 0x04, 0x08, 0x10, 0x20 } // 5c �
;	, { 0x00, 0x41, 0x41, 0x7f, 0x00 } // 5d ]
;	, { 0x04, 0x02, 0x01, 0x02, 0x04 } // 5e ^
;	, { 0x40, 0x40, 0x40, 0x40, 0x40 } // 5f _
;	, { 0x00, 0x01, 0x02, 0x04, 0x00 } // 60 `
;	, { 0x20, 0x54, 0x54, 0x54, 0x78 } // 61 a
;	, { 0x7f, 0x48, 0x44, 0x44, 0x38 } // 62 b
;	, { 0x38, 0x44, 0x44, 0x44, 0x20 } // 63 c
;	, { 0x38, 0x44, 0x44, 0x48, 0x7f } // 64 d
;	, { 0x38, 0x54, 0x54, 0x54, 0x18 } // 65 e
;	, { 0x08, 0x7e, 0x09, 0x01, 0x02 } // 66 f
;	, { 0x0c, 0x52, 0x52, 0x52, 0x3e } // 67 g
;	, { 0x7f, 0x08, 0x04, 0x04, 0x78 } // 68 h
;	, { 0x00, 0x44, 0x7d, 0x40, 0x00 } // 69 i
;	, { 0x20, 0x40, 0x44, 0x3d, 0x00 } // 6a j
;	, { 0x7f, 0x10, 0x28, 0x44, 0x00 } // 6b k
;	, { 0x00, 0x41, 0x7f, 0x40, 0x00 } // 6c l
;	, { 0x7c, 0x04, 0x18, 0x04, 0x78 } // 6d m
;	, { 0x7c, 0x08, 0x04, 0x04, 0x78 } // 6e n
;	, { 0x38, 0x44, 0x44, 0x44, 0x38 } // 6f o
;	, { 0x7c, 0x14, 0x14, 0x14, 0x08 } // 70 p
;	, { 0x08, 0x14, 0x14, 0x18, 0x7c } // 71 q
;	, { 0x7c, 0x08, 0x04, 0x04, 0x08 } // 72 r
;	, { 0x48, 0x54, 0x54, 0x54, 0x20 } // 73 s
;	, { 0x04, 0x3f, 0x44, 0x40, 0x20 } // 74 t
;	, { 0x3c, 0x40, 0x40, 0x20, 0x7c } // 75 u
;	, { 0x1c, 0x20, 0x40, 0x20, 0x1c } // 76 v
;	, { 0x3c, 0x40, 0x30, 0x40, 0x3c } // 77 w
;	, { 0x44, 0x28, 0x10, 0x28, 0x44 } // 78 x
;	, { 0x0c, 0x50, 0x50, 0x50, 0x3c } // 79 y
;	, { 0x44, 0x64, 0x54, 0x4c, 0x44 } // 7a z
;	, { 0x00, 0x08, 0x36, 0x41, 0x00 } // 7b {
;	, { 0x00, 0x00, 0x7f, 0x00, 0x00 } // 7c |
;	, { 0x00, 0x41, 0x36, 0x08, 0x00 } // 7d }
;	, { 0x10, 0x08, 0x08, 0x10, 0x08 } // 7e ?
;	, { 0x78, 0x46, 0x41, 0x46, 0x78 } // 7f ?
;};
;
;/* LED FUNCTIONS */
;void LEDLtoggle()
; 0001 0273 {

	.CSEG
_LEDLtoggle:
; 0001 0274 	if (LEDL == 0){ LEDL = 1; }
	SBIC 0x15,4
	RJMP _0x20054
	SBI  0x15,4
; 0001 0275 	else{ LEDL = 0; }
	RJMP _0x20057
_0x20054:
	CBI  0x15,4
_0x20057:
; 0001 0276 }
	RET
;
;void LEDRtoggle()
; 0001 0279 {
_LEDRtoggle:
; 0001 027A 	if (LEDR == 0){ LEDR = 1; }
	SBIC 0x15,5
	RJMP _0x2005A
	SBI  0x15,5
; 0001 027B 	else{ LEDR = 0; }
	RJMP _0x2005D
_0x2005A:
	CBI  0x15,5
_0x2005D:
; 0001 027C }
	RET
;
;/* SPI */
;void sPItx(unsigned char temtx)
; 0001 0280 {
_sPItx:
; 0001 0281 	// unsigned char transPI;
; 0001 0282 	SPDR = temtx;
;	temtx -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0001 0283 	while (!(SPSR & 0x80));
_0x20060:
	SBIS 0xE,7
	RJMP _0x20060
; 0001 0284 }
	RJMP _0x20C0010
;
;/* LCD FUNCTIONS */
;void LcdWrite(unsigned char dc, unsigned char data)
; 0001 0288 {
_LcdWrite:
; 0001 0289 	DC = dc;
;	dc -> Y+1
;	data -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x20063
	CBI  0x18,2
	RJMP _0x20064
_0x20063:
	SBI  0x18,2
_0x20064:
; 0001 028A 	SCE = 1;
	SBI  0x18,1
; 0001 028B 	SCE = 0;
	CBI  0x18,1
; 0001 028C 	sPItx(data);
	LD   R30,Y
	ST   -Y,R30
	RCALL _sPItx
; 0001 028D 	SCE = 1;
	SBI  0x18,1
; 0001 028E }
	RJMP _0x20C0011
;//This takes a large array of bits and sends them to the LCD
;void LcdBitmap(char my_array[]){
; 0001 0290 void LcdBitmap(char my_array[]){
; 0001 0291 	int index = 0;
; 0001 0292 	for (index = 0; index < (LCD_X * LCD_Y / 8); index++)
;	my_array -> Y+2
;	index -> R16,R17
; 0001 0293 		LcdWrite(LCD_D, my_array[index]);
; 0001 0294 }
;
;void hc(int x, int y) {
; 0001 0296 void hc(int x, int y) {
_hc:
; 0001 0297 	LcdWrite(0, 0x40 | x);  // Row.  ?
;	x -> Y+2
;	y -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+3
	ORI  R30,0x40
	CALL SUBOPT_0x2
; 0001 0298 	LcdWrite(0, 0x80 | y);  // Column.
	LDD  R30,Y+1
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 0299 }
	RJMP _0x20C000E
;
;void LcdCharacter(unsigned char character)
; 0001 029C {
_LcdCharacter:
; 0001 029D 	int index = 0;
; 0001 029E 	LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x3
;	character -> Y+2
;	index -> R16,R17
; 0001 029F 	for (index = 0; index < 5; index++)
_0x2006F:
	__CPWRN 16,17,5
	BRGE _0x20070
; 0001 02A0 	{
; 0001 02A1 		LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x4
; 0001 02A2 	}
	__ADDWRN 16,17,1
	RJMP _0x2006F
_0x20070:
; 0001 02A3 	LcdWrite(LCD_D, 0x00);
	RJMP _0x20C0014
; 0001 02A4 }
;
;void wc(unsigned char character)
; 0001 02A7 {
_wc:
; 0001 02A8 	int index = 0;
; 0001 02A9 	LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x3
;	character -> Y+2
;	index -> R16,R17
; 0001 02AA 	for (index = 0; index < 5; index++)
_0x20072:
	__CPWRN 16,17,5
	BRGE _0x20073
; 0001 02AB 	{
; 0001 02AC 		LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x4
; 0001 02AD 	}
	__ADDWRN 16,17,1
	RJMP _0x20072
_0x20073:
; 0001 02AE 	LcdWrite(LCD_D, 0x00);
_0x20C0014:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 02AF }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0015:
	ADIW R28,3
	RET
;
;void ws(unsigned char *characters)
; 0001 02B2 {
_ws:
; 0001 02B3 	while (*characters)
;	*characters -> Y+0
_0x20074:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x20076
; 0001 02B4 	{
; 0001 02B5 		LcdCharacter(*characters++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 02B6 	}
	RJMP _0x20074
_0x20076:
; 0001 02B7 }
	RJMP _0x20C0011
;
;void LcdClear(void)
; 0001 02BA {
_LcdClear:
; 0001 02BB 	int index = 0;
; 0001 02BC 	for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x6
;	index -> R16,R17
_0x20078:
	__CPWRN 16,17,504
	BRGE _0x20079
; 0001 02BD 	{
; 0001 02BE 		LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 02BF 	}
	__ADDWRN 16,17,1
	RJMP _0x20078
_0x20079:
; 0001 02C0 	hc(0, 0); //After we clear the display, return to the home position
	RJMP _0x20C0013
; 0001 02C1 }
;
;void clear(void)
; 0001 02C4 {
_clear:
; 0001 02C5 	int index = 0;
; 0001 02C6 	for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x6
;	index -> R16,R17
_0x2007B:
	__CPWRN 16,17,504
	BRGE _0x2007C
; 0001 02C7 	{
; 0001 02C8 		LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 02C9 	}
	__ADDWRN 16,17,1
	RJMP _0x2007B
_0x2007C:
; 0001 02CA 	hc(0, 0); //After we clear the display, return to the home position
_0x20C0013:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x7
; 0001 02CB }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void wn164(unsigned int so)
; 0001 02CE {
_wn164:
; 0001 02CF 	unsigned char a[5], i;
; 0001 02D0 	for (i = 0; i < 5; i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x2007E:
	CPI  R17,5
	BRSH _0x2007F
; 0001 02D1 	{
; 0001 02D2 		a[i] = so % 10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0001 02D3 		so = so / 10;
; 0001 02D4 	}
	SUBI R17,-1
	RJMP _0x2007E
_0x2007F:
; 0001 02D5 	for (i = 1; i < 5; i++)
	LDI  R17,LOW(1)
_0x20081:
	CPI  R17,5
	BRSH _0x20082
; 0001 02D6 	{
; 0001 02D7 		wc(a[4 - i] + 0x30);
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	RCALL _wc
; 0001 02D8 	}
	SUBI R17,-1
	RJMP _0x20081
_0x20082:
; 0001 02D9 }
	RJMP _0x20C0012
;
;void LcdInitialise()
; 0001 02DC {
_LcdInitialise:
; 0001 02DD 	//reset
; 0001 02DE 	RST = 0;
	CBI  0x18,0
; 0001 02DF 	delay_us(10);
	__DELAY_USB 27
; 0001 02E0 	RST = 1;
	SBI  0x18,0
; 0001 02E1 
; 0001 02E2 	delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 02E3 	//khoi dong
; 0001 02E4 	LcdWrite(LCD_C, 0x21);  //Tell LCD that extended commands follow
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0x2
; 0001 02E5 	LcdWrite(LCD_C, 0xBF);  //Set LCD Vop (Contrast): Try 0xB1(good @ 3.3V) or 0xBF = Dam nhat
	LDI  R30,LOW(191)
	CALL SUBOPT_0x2
; 0001 02E6 	LcdWrite(LCD_C, 0x06);  // Set Temp coefficent. //0x04
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0001 02E7 	LcdWrite(LCD_C, 0x13);  //LCD bias mode 1:48: Try 0x13 or 0x14
	LDI  R30,LOW(19)
	CALL SUBOPT_0x2
; 0001 02E8 	LcdWrite(LCD_C, 0x20);  //We must send 0x20 before modifying the display control mode
	LDI  R30,LOW(32)
	CALL SUBOPT_0x2
; 0001 02E9 	LcdWrite(LCD_C, 0x0C);  //Set display control, normal mode. 0x0D for inverse, 0x0C normal
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 02EA }
	RET
;// Hien thi so 16 bits
;void wn16(unsigned int so)
; 0001 02ED {
_wn16:
; 0001 02EE 	unsigned char a[5], i;
; 0001 02EF 	for (i = 0; i < 5; i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20088:
	CPI  R17,5
	BRSH _0x20089
; 0001 02F0 	{
; 0001 02F1 		a[i] = so % 10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0001 02F2 		so = so / 10;
; 0001 02F3 	}
	SUBI R17,-1
	RJMP _0x20088
_0x20089:
; 0001 02F4 	for (i = 0; i < 5; i++)
	LDI  R17,LOW(0)
_0x2008B:
	CPI  R17,5
	BRSH _0x2008C
; 0001 02F5 	{
; 0001 02F6 		LcdCharacter(a[4 - i] + 0x30);
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	RCALL _LcdCharacter
; 0001 02F7 	}
	SUBI R17,-1
	RJMP _0x2008B
_0x2008C:
; 0001 02F8 }
_0x20C0012:
	LDD  R17,Y+0
	ADIW R28,8
	RET
;// Hien thi so 16 bits co dau
;void wn16s(int so)
; 0001 02FB {
_wn16s:
; 0001 02FC 	if (so < 0){ so = 0 - so; LcdCharacter('-'); }
;	so -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRPL _0x2008D
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xC
	LDI  R30,LOW(45)
	RJMP _0x20330
; 0001 02FD 	else{ LcdCharacter(' '); }
_0x2008D:
	LDI  R30,LOW(32)
_0x20330:
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 02FE 	wn16(so);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xD
; 0001 02FF }
_0x20C0011:
	ADIW R28,2
	RET
;// hien thi so 32bit co dau
;void wn32s(int so)
; 0001 0302 {
; 0001 0303 	char tmp[20];
; 0001 0304 	sprintf(tmp, "%d", so);
;	so -> Y+20
;	tmp -> Y+0
; 0001 0305 	ws(tmp);
; 0001 0306 }
;// Hien thi so 32bit co dau
;void wnf(float so)
; 0001 0309 {
; 0001 030A 	char tmp[30];
; 0001 030B 	sprintf(tmp, "%0.2f", so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 030C 	ws(tmp);
; 0001 030D }
;// Hien thi so 32bit co dau
;void wfmt(float so)
; 0001 0310 {
; 0001 0311 	char tmp[30];
; 0001 0312 	sprintf(tmp, "%0.2f", so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 0313 	ws(tmp);
; 0001 0314 }
;/* SPI & LCD INIT */
;void SPIinit()
; 0001 0317 {
_SPIinit:
; 0001 0318 	SPCR |= 1 << SPE | 1 << MSTR;                                         //if sPI is used, uncomment this section out
	IN   R30,0xD
	ORI  R30,LOW(0x50)
	OUT  0xD,R30
; 0001 0319 	SPSR |= 1 << SPI2X;
	SBI  0xE,0
; 0001 031A }
	RET
;void LCDinit()
; 0001 031C {
_LCDinit:
; 0001 031D 	LcdInitialise();
	RCALL _LcdInitialise
; 0001 031E 	LcdClear();
	RCALL _LcdClear
; 0001 031F 	ws(" <AKBOTKIT>");
	__POINTW1MN _0x2008F,0
	CALL SUBOPT_0xE
; 0001 0320 }
	RET

	.DSEG
_0x2008F:
	.BYTE 0xC
;
;
;/* ADC */
;#define ADC_VREF_TYPE 0x40
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0001 0327 {

	.CSEG
_read_adc:
; 0001 0328 	ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0001 0329 	// Delay needed for the stabilization of the ADC input voltage
; 0001 032A 	delay_us(10);
	__DELAY_USB 27
; 0001 032B 	// Start the AD conversion
; 0001 032C 	ADCSRA |= 0x40;
	SBI  0x6,6
; 0001 032D 	// Wait for the AD conversion to complete
; 0001 032E 	while ((ADCSRA & 0x10) == 0);
_0x20090:
	SBIS 0x6,4
	RJMP _0x20090
; 0001 032F 	ADCSRA |= 0x10;
	SBI  0x6,4
; 0001 0330 	return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C0010
; 0001 0331 }
;
;/* UART BLUETOOTH */
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index, rx_rd_index, rx_counter;
;#else
;unsigned int rx_wr_index, rx_rd_index, rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt[USART_RXC] void usart_rx_isr(void)
; 0001 0365 {
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 0366 	char status, data;
; 0001 0367 	status = UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0001 0368 	data = UDR;
	IN   R16,12
; 0001 0369 	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x20093
; 0001 036A 	{
; 0001 036B 		rx_buffer[rx_wr_index++] = data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	CALL SUBOPT_0xF
	ST   Z,R16
; 0001 036C #if RX_BUFFER_SIZE == 256
; 0001 036D 		// special case for receiver buffer size=256
; 0001 036E 		if (++rx_counter == 0) {
; 0001 036F #else
; 0001 0370 		if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index = 0;
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20094
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0001 0371 		if (++rx_counter == RX_BUFFER_SIZE) {
_0x20094:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x20095
; 0001 0372 			rx_counter = 0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0001 0373 #endif
; 0001 0374 			rx_buffer_overflow = 1;
	SET
	BLD  R2,0
; 0001 0375 		}
; 0001 0376 		}
_0x20095:
; 0001 0377 	}
_0x20093:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x20347
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0001 037E {
_getchar:
; 0001 037F 	char data;
; 0001 0380 	while (rx_counter == 0);
	ST   -Y,R17
;	data -> R17
_0x20096:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20096
; 0001 0381 	data = rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	CALL SUBOPT_0xF
	LD   R17,Z
; 0001 0382 #if RX_BUFFER_SIZE != 256
; 0001 0383 	if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index = 0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x20099
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0001 0384 #endif
; 0001 0385 	#asm("cli")
_0x20099:
	cli
; 0001 0386 	--rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0001 0387 	#asm("sei")
	sei
; 0001 0388 	return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0001 0389 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index, tx_rd_index, tx_counter;
;#else
;unsigned int tx_wr_index, tx_rd_index, tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt[USART_TXC] void usart_tx_isr(void)
; 0001 0399 {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 039A 	if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0x2009A
; 0001 039B 	{
; 0001 039C 		--tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0001 039D 		UDR = tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	CALL SUBOPT_0x10
	LD   R30,Z
	OUT  0xC,R30
; 0001 039E #if TX_BUFFER_SIZE != 256
; 0001 039F 		if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index = 0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x2009B
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0001 03A0 #endif
; 0001 03A1 	}
_0x2009B:
; 0001 03A2 }
_0x2009A:
_0x20347:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0001 03A9 {
_putchar:
; 0001 03AA 	while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0x2009C:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0x2009C
; 0001 03AB 	#asm("cli")
	cli
; 0001 03AC 	if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY) == 0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x200A0
	SBIC 0xB,5
	RJMP _0x2009F
_0x200A0:
; 0001 03AD 	{
; 0001 03AE 		tx_buffer[tx_wr_index++] = c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	CALL SUBOPT_0x10
	LD   R26,Y
	STD  Z+0,R26
; 0001 03AF #if TX_BUFFER_SIZE != 256
; 0001 03B0 		if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index = 0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x200A2
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0001 03B1 #endif
; 0001 03B2 		++tx_counter;
_0x200A2:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0001 03B3 	}
; 0001 03B4 	else
	RJMP _0x200A3
_0x2009F:
; 0001 03B5 		UDR = c;
	LD   R30,Y
	OUT  0xC,R30
; 0001 03B6 	#asm("sei")
_0x200A3:
	sei
; 0001 03B7 }
	RJMP _0x20C0010
;#pragma used-
;#endif
;void inituart()
; 0001 03BB {
_inituart:
; 0001 03BC 	// USART initialization
; 0001 03BD 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 03BE 	// USART Receiver: On
; 0001 03BF 	// USART Transmitter: On
; 0001 03C0 	// USART Mode: Asynchronous
; 0001 03C1 	// USART Baud Rate: 38400
; 0001 03C2 	UCSRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 03C3 	UCSRB = 0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 03C4 	UCSRC = 0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0001 03C5 	UBRRH = 0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 03C6 	UBRRL = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0001 03C7 }
	RET
;
;//========================================================
;// External Interrupt 0 service routine
;interrupt[EXT_INT0] void ext_int0_isr(void)
; 0001 03CC {
_ext_int0_isr:
	CALL SUBOPT_0x11
; 0001 03CD 	QEL++;
	LDI  R26,LOW(_QEL)
	LDI  R27,HIGH(_QEL)
	RJMP _0x20346
; 0001 03CE }
;
;// External Interrupt 1 service routine
;interrupt[EXT_INT1] void ext_int1_isr(void)
; 0001 03D2 {
_ext_int1_isr:
	CALL SUBOPT_0x11
; 0001 03D3 	QER++;
	LDI  R26,LOW(_QER)
	LDI  R27,HIGH(_QER)
_0x20346:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 03D4 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;//========================================================
;//khoi tao encoder
;void initencoder()
; 0001 03D8 {
_initencoder:
; 0001 03D9 	// Dem 24 xung / 1 vong banh xe
; 0001 03DA 	// External Interrupt(s) initialization
; 0001 03DB 	// INT0: On
; 0001 03DC 	// INT0 Mode: Any change
; 0001 03DD 	// INT1: On
; 0001 03DE 	// INT1 Mode: Any change
; 0001 03DF 	// INT2: Off
; 0001 03E0 	GICR |= 0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0001 03E1 	MCUCR = 0x05;
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0001 03E2 	MCUCSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 03E3 	GIFR = 0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0001 03E4 	// Global enable interrupts
; 0001 03E5 
; 0001 03E6 	//OCR1A=0-255; MOTOR LEFT
; 0001 03E7 	//OCR1B=0-255; MOTOR RIGHT
; 0001 03E8 }
	RET
;
;//========================================================
;//control velocity motor
;void vMLtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 03ED {
_vMLtoi:
; 0001 03EE 	seRki = 0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 03EF 	seLki = 0;//reset thanh phan I
; 0001 03F0 	//uRold=0;
; 0001 03F1 	MLdir = 1;
	SBI  0x15,6
; 0001 03F2 	svQEL = v;
	CALL SUBOPT_0x13
; 0001 03F3 }
	RJMP _0x20C0010
;//========================================================
;void vMLlui(unsigned char v) //congsuat=0-22 (%)
; 0001 03F6 {
_vMLlui:
; 0001 03F7 	seRki = 0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 03F8 	seLki = 0;//reset thanh phan I
; 0001 03F9 
; 0001 03FA 	//uRold=0;
; 0001 03FB 	MLdir = 0;
	CBI  0x15,6
; 0001 03FC 	svQEL = v;
	CALL SUBOPT_0x13
; 0001 03FD }
	RJMP _0x20C0010
;//========================================================
;void vMLstop()
; 0001 0400 {
_vMLstop:
; 0001 0401 	seRki = 0;//reset thanh phan I
	CALL SUBOPT_0x12
; 0001 0402 	seLki = 0;//reset thanh phan I
; 0001 0403 	MLdir = 1;
	SBI  0x15,6
; 0001 0404 	OCR1A = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 0405 	svQEL = 0;
	STS  _svQEL,R30
	STS  _svQEL+1,R30
; 0001 0406 }
	RET
;//========================================================
;//========================================================
;void vMRtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 040A {
_vMRtoi:
; 0001 040B 	seRki = 0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 040C 	seLki = 0;//reset thanh phan I
; 0001 040D 	MRdir = 1;
	SBI  0x15,7
; 0001 040E 	svQER = v;
	RJMP _0x20C000F
; 0001 040F }
;//========================================================
;void vMRlui(unsigned char v) //congsuat=0-22 (%)
; 0001 0412 {
_vMRlui:
; 0001 0413 	seRki = 0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 0414 	seLki = 0;//reset thanh phan I
; 0001 0415 	MRdir = 0;
	CBI  0x15,7
; 0001 0416 	svQER = v;
_0x20C000F:
	LD   R30,Y
	LDI  R31,0
	STS  _svQER,R30
	STS  _svQER+1,R31
; 0001 0417 }
_0x20C0010:
	ADIW R28,1
	RET
;//========================================================
;void vMRstop()
; 0001 041A {
_vMRstop:
; 0001 041B 	seRki = 0;//reset thanh phan I
	CALL SUBOPT_0x12
; 0001 041C 	seLki = 0;//reset thanh phan I
; 0001 041D 	MRdir = 1;
	SBI  0x15,7
; 0001 041E 	OCR1B = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 041F 	svQER = 0;
	STS  _svQER,R30
	STS  _svQER+1,R30
; 0001 0420 }
	RET
;//========================================================
;// ham dieu khien vi tri
;void ctrRobottoi(unsigned int d, unsigned int v)  //v:0-22
; 0001 0424 {
_ctrRobottoi:
; 0001 0425 	flagwaitctrAngle = 0;
;	d -> Y+2
;	v -> Y+0
	LDI  R30,LOW(0)
	STS  _flagwaitctrAngle,R30
; 0001 0426 	flagwaitctrRobot = 1;
	LDI  R30,LOW(1)
	STS  _flagwaitctrRobot,R30
; 0001 0427 	sd = d;// set gia tri khoang cach di chuyen
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	STS  _sd,R30
	STS  _sd+1,R31
; 0001 0428 	oldd = (QEL + QER) / 2; // luu gia tri vi tri hien tai
	CALL SUBOPT_0x14
	LDS  R26,_QEL
	LDS  R27,_QEL+1
	CALL SUBOPT_0x15
	STS  _oldd,R30
	STS  _oldd+1,R31
; 0001 0429 	vMRtoi(v);
	LD   R30,Y
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 042A 	vMLtoi(v);
	LD   R30,Y
	ST   -Y,R30
	RCALL _vMLtoi
; 0001 042B }
_0x20C000E:
	ADIW R28,4
	RET
;// ham dieu khien vi tri
;void ctrRobotlui(unsigned int d, unsigned int v)  //v:0-22
; 0001 042E {
; 0001 042F 	flagwaitctrAngle = 0;
;	d -> Y+2
;	v -> Y+0
; 0001 0430 	flagwaitctrRobot = 1;
; 0001 0431 	sd = d;// set gia tri khoang cach di chuyen
; 0001 0432 	oldd = (QEL + QER) / 2; // luu gia tri vi tri hien tai
; 0001 0433 	vMRlui(v);
; 0001 0434 	vMLlui(v);
; 0001 0435 }
;// ham dieu khien goc quay
;void ctrRobotXoay(int angle, unsigned int v)  //v:0-22
; 0001 0438 {
; 0001 0439 	float fangle = 0;
; 0001 043A 	flagwaitctrRobot = 0;
;	angle -> Y+6
;	v -> Y+4
;	fangle -> Y+0
; 0001 043B 	if (angle > 0)  { //xoay trai
; 0001 043C 		if (angle > 1) vMRtoi(v);
; 0001 043D 		else vMRtoi(0);
; 0001 043E 		if (angle > 1) vMLlui(v);
; 0001 043F 		else vMLlui(0);
; 0001 0440 	}
; 0001 0441 	else  //xoay phai
; 0001 0442 	{
; 0001 0443 		angle = -angle;
; 0001 0444 		if (angle > 1) vMRlui(v);
; 0001 0445 		else vMRlui(0);
; 0001 0446 		if (angle > 1) vMLtoi(v);
; 0001 0447 		else vMLtoi(0);
; 0001 0448 	}
; 0001 0449 	flagwaitctrAngle = 1;
; 0001 044A 	fangle = angle*0.35;// nhan chia so float
; 0001 044B 	sa = fangle;
; 0001 044C 	olda = QEL; // luu gia tri vi tri hien tai
; 0001 044D }
;
;
;//============Phat==============
;IntRobot convertRobot2IntRobot(Robot robot)
; 0001 0452 {
_convertRobot2IntRobot:
; 0001 0453 	IntRobot intRb;
; 0001 0454 	intRb.id = (int)robot.id;
	SBIW R28,28
;	robot -> Y+28
;	intRb -> Y+0
	__GETD1S 28
	CALL __CFD1
	ST   Y,R30
	STD  Y+1,R31
; 0001 0455 	intRb.x = (int)robot.x;
	CALL SUBOPT_0x16
	CALL __CFD1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0456 	intRb.y = (int)robot.y;
	CALL SUBOPT_0x17
	CALL __CFD1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 0457 	intRb.ox = (int)robot.ox;
	CALL SUBOPT_0x18
	CALL __CFD1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0458 	intRb.oy = (int)robot.oy;
	__GETD1S 44
	CALL __CFD1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0459 	intRb.ball.x = (int)robot.ball.x;
	CALL SUBOPT_0x19
	CALL __CFD1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 045A 	intRb.ball.y = (int)robot.ball.y;
	__GETD1S 52
	CALL __CFD1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 045B 	return intRb;
	MOVW R30,R28
	MOVW R26,R28
	ADIW R26,14
	LDI  R24,14
	CALL __COPYMML
	MOVW R30,R28
	ADIW R30,14
	LDI  R24,14
	IN   R1,SREG
	CLI
	RJMP _0x20C000D
; 0001 045C }
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;/* Comment to return
;unsigned char readposition()
;{
;unsigned char  i=0;
;unsigned flagstatus=0;
;
;if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
;{
;for( i=0;i<28;i++)
;{
;*(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
;}
;
;idRobot = fmod(rb.id,10); // doc id
;cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
;
;switch (idRobot)
;{
;case 1:
;robot11=convertRobot2IntRobot(rb);
;break;
;case 2:
;robot12=convertRobot2IntRobot(rb);
;break;
;case 3:
;robot13=convertRobot2IntRobot(rb);
;break;
;case 4:
;robot21=convertRobot2IntRobot(rb);
;break;
;case 5:
;robot22=convertRobot2IntRobot(rb);
;break;
;case 6:
;robot23=convertRobot2IntRobot(rb);
;break;
;}
;
;if(idRobot==ROBOT_ID)
;{
;LEDL=!LEDL;
;cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
;flagstatus=1;
;robotctrl=convertRobot2IntRobot(rb);
;}
;}
;return flagstatus;
;}     */
;//========================================================
;// calc  vi tri robot   so voi mot diem (x,y)        PHUC
;// return goclenh va khoang cach, HUONG TAN CONG
;//========================================================
;
;
;#define LP_O_C 0.5
;float oldOrientation = 0;
;
;void calcvitri(float x, float y)
; 0001 049B {
_calcvitri:
; 0001 049C 	float ahx, ahy, aox, aoy, dah, dao, ahay, cosgoc, anpla0, anpla1, detaanpla, newOrientation;
; 0001 049D 	ahx = robotctrl.ox - robotctrl.x;
	SBIW R28,48
;	x -> Y+52
;	y -> Y+48
;	ahx -> Y+44
;	ahy -> Y+40
;	aox -> Y+36
;	aoy -> Y+32
;	dah -> Y+28
;	dao -> Y+24
;	ahay -> Y+20
;	cosgoc -> Y+16
;	anpla0 -> Y+12
;	anpla1 -> Y+8
;	detaanpla -> Y+4
;	newOrientation -> Y+0
	__GETW1MN _robotctrl,6
	__GETW2MN _robotctrl,2
	CALL SUBOPT_0x1A
	__PUTD1S 44
; 0001 049E 	ahy = robotctrl.oy - robotctrl.y;
	__GETW1MN _robotctrl,8
	__GETW2MN _robotctrl,4
	CALL SUBOPT_0x1A
	__PUTD1S 40
; 0001 049F 	aox = x - robotctrl.x;
	CALL SUBOPT_0x1B
	__GETD2S 52
	CALL SUBOPT_0x1C
	__PUTD1S 36
; 0001 04A0 	aoy = y - robotctrl.y;
	CALL SUBOPT_0x1D
	__GETD2S 48
	CALL SUBOPT_0x1C
	__PUTD1S 32
; 0001 04A1 	dah = sqrt(ahx*ahx + ahy*ahy);
	__GETD1S 44
	CALL SUBOPT_0x1E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x20
	__PUTD1S 28
; 0001 04A2 	dao = sqrt(aox*aox + aoy*aoy);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x21
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x22
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x20
	__PUTD1S 24
; 0001 04A3 	ahay = ahx*aox + ahy*aoy;
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
; 0001 04A4 	cosgoc = ahay / (dah*dao);
	__GETD1S 24
	__GETD2S 28
	CALL __MULF12
	CALL SUBOPT_0x24
	CALL __DIVF21
	CALL SUBOPT_0x25
; 0001 04A5 
; 0001 04A6 	anpla0 = atan2(ahy, ahx);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0001 04A7 	anpla1 = atan2(aoy, aox);
	CALL SUBOPT_0x16
	CALL __PUTPARD1
	CALL SUBOPT_0x26
	CALL _atan2
	CALL SUBOPT_0x29
; 0001 04A8 	detaanpla = anpla0 - anpla1;
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
; 0001 04A9 
; 0001 04AA 	errangle = acos(cosgoc) * 180 / 3.14;
	CALL SUBOPT_0x2C
	CALL __PUTPARD1
	CALL _acos
	CALL SUBOPT_0x2D
	__GETD1N 0x4048F5C3
	CALL __DIVF21
	STS  _errangle,R30
	STS  _errangle+1,R31
	STS  _errangle+2,R22
	STS  _errangle+3,R23
; 0001 04AB 	if (((detaanpla > 0) && (detaanpla < M_PI)) || (detaanpla < -M_PI))  // xet truong hop goc ben phai
	CALL SUBOPT_0x2E
	CALL __CPD02
	BRGE _0x200BB
	CALL SUBOPT_0x2E
	__GETD1N 0x40490FDB
	CALL __CMPF12
	BRLO _0x200BD
_0x200BB:
	CALL SUBOPT_0x2E
	__GETD1N 0xC0490FDB
	CALL __CMPF12
	BRSH _0x200BA
_0x200BD:
; 0001 04AC 	{
; 0001 04AD 		errangle = -errangle; // ben phai
	CALL SUBOPT_0x2F
	CALL __ANEGF1
	RJMP _0x20335
; 0001 04AE 	}
; 0001 04AF 	else
_0x200BA:
; 0001 04B0 	{
; 0001 04B1 		errangle = errangle;   // ben trai
	CALL SUBOPT_0x2F
_0x20335:
	STS  _errangle,R30
	STS  _errangle+1,R31
	STS  _errangle+2,R22
	STS  _errangle+3,R23
; 0001 04B2 
; 0001 04B3 	}
; 0001 04B4 	distance = sqrt(aox*3.48*aox*3.48 + aoy*2.89*aoy*2.89); //tinh khoang cach
	CALL SUBOPT_0x21
	__GETD1N 0x405EB852
	CALL __MULF12
	CALL SUBOPT_0x21
	CALL __MULF12
	__GETD2N 0x405EB852
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	__GETD1N 0x4038F5C3
	CALL __MULF12
	CALL SUBOPT_0x22
	CALL __MULF12
	__GETD2N 0x4038F5C3
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x20
	STS  _distance,R30
	STS  _distance+1,R31
	STS  _distance+2,R22
	STS  _distance+3,R23
; 0001 04B5 	newOrientation = atan2(ahy, ahx) * 180 / M_PI + offestsanco;//tinh huong ra goc
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2D
	__GETD1N 0x40490FDB
	CALL __DIVF21
	LDS  R26,_offestsanco
	LDS  R27,_offestsanco+1
	LDS  R24,_offestsanco+2
	LDS  R25,_offestsanco+3
	CALL __ADDF12
	CALL SUBOPT_0x30
; 0001 04B6 	orientation = newOrientation * LP_O_C + oldOrientation * (1 - LP_O_C);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_oldOrientation
	LDS  R27,_oldOrientation+1
	LDS  R24,_oldOrientation+2
	LDS  R25,_oldOrientation+3
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _orientation,R30
	STS  _orientation+1,R31
	STS  _orientation+2,R22
	STS  _orientation+3,R23
; 0001 04B7 	if ((0 < orientation && orientation < 74) || (0 > orientation && orientation > -80))
	CALL __CPD01
	BRGE _0x200C1
	CALL SUBOPT_0x33
	__GETD1N 0x42940000
	CALL __CMPF12
	BRLO _0x200C3
_0x200C1:
	LDS  R30,_orientation+3
	TST  R30
	BRPL _0x200C4
	CALL SUBOPT_0x33
	__GETD1N 0xC2A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x200C4
	RJMP _0x200C3
_0x200C4:
	RJMP _0x200C0
_0x200C3:
; 0001 04B8 	{
; 0001 04B9 		if (SAN_ID == 1)// phan san duong
; 0001 04BA 		{
; 0001 04BB 			flagtancong = 0;
	CLR  R4
	CLR  R5
; 0001 04BC 			offsetphongthu = 70;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	MOVW R6,R30
; 0001 04BD 			goctancong = 180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	MOVW R8,R30
; 0001 04BE 		}
; 0001 04BF 		else // phan san am
; 0001 04C0 		{
; 0001 04C1 			flagtancong = 1;
; 0001 04C2 
; 0001 04C3 		}
; 0001 04C4 	}
; 0001 04C5 	else
	RJMP _0x200C9
_0x200C0:
; 0001 04C6 	{
; 0001 04C7 		if (SAN_ID == 1)
; 0001 04C8 		{
; 0001 04C9 			flagtancong = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0001 04CA 		}
; 0001 04CB 		else
; 0001 04CC 		{
; 0001 04CD 			flagtancong = 0;
; 0001 04CE 			offsetphongthu = -70;
; 0001 04CF 			goctancong = 0;
; 0001 04D0 		}
; 0001 04D1 	}
_0x200C9:
; 0001 04D2 }
_0x20C000D:
	ADIW R28,56
	RET
;void runEscStuck()
; 0001 04D4 {
; 0001 04D5 	while (cmdCtrlRobot == 4)
; 0001 04D6 	{
; 0001 04D7 
; 0001 04D8 		DDRA = 0x00;
; 0001 04D9 		PORTA = 0x00;
; 0001 04DA 		IRFL = read_adc(4);
; 0001 04DB 		IRFR = read_adc(5);
; 0001 04DC 
; 0001 04DD 		if ((IRFL < 300) && (IRFR < 300))
; 0001 04DE 		{
; 0001 04DF 			vMLtoi(22); vMRlui(22);
; 0001 04E0 			delay_ms(100);
; 0001 04E1 		}
; 0001 04E2 		if (IRFL > 300 && IRFR < 300)
; 0001 04E3 		{
; 0001 04E4 			vMLlui(0); vMRlui(25); delay_ms(100);
; 0001 04E5 		}
; 0001 04E6 		if (IRFR>300 && IRFL < 300)
; 0001 04E7 		{
; 0001 04E8 			vMLlui(25); vMRlui(0); delay_ms(100);
; 0001 04E9 		}
; 0001 04EA 		LEDBR = !LEDBR;
; 0001 04EB 		readposition();//doc RF cap nhat ai robot
; 0001 04EC 	}
; 0001 04ED }
;void runEscStucksethome()
; 0001 04EF {
; 0001 04F0 	while (cmdCtrlRobot == 7)
; 0001 04F1 	{
; 0001 04F2 		DDRA = 0x00;
; 0001 04F3 		PORTA = 0x00;
; 0001 04F4 		readposition();//doc RF cap nhat ai robot
; 0001 04F5 		IRFL = read_adc(4);
; 0001 04F6 		IRFR = read_adc(5);
; 0001 04F7 
; 0001 04F8 		if ((IRFL < 300) && (IRFR < 300))
; 0001 04F9 		{
; 0001 04FA 			vMLtoi(22); vMRlui(22);
; 0001 04FB 			delay_ms(100);
; 0001 04FC 		}
; 0001 04FD 
; 0001 04FE 		if (IRFL > 300 && IRFR < 300)
; 0001 04FF 		{
; 0001 0500 			vMLlui(0); vMRlui(22); delay_ms(300);
; 0001 0501 		}
; 0001 0502 		if (IRFR>300 && IRFL < 300)
; 0001 0503 		{
; 0001 0504 			vMLlui(22); vMRlui(0); delay_ms(300);
; 0001 0505 		}
; 0001 0506 
; 0001 0507 		LEDBR = !LEDBR;
; 0001 0508 	}
; 0001 0509 }
;void runEscBlindSpot()
; 0001 050B {
; 0001 050C 	while (cmdCtrlRobot == 3)
; 0001 050D 	{
; 0001 050E 		DDRA = 0x00;
; 0001 050F 		PORTA = 0x00;
; 0001 0510 		readposition();//doc RF cap nhat ai robot
; 0001 0511 		IRFL = read_adc(4);
; 0001 0512 		IRFR = read_adc(5);
; 0001 0513 		if (IRFL>300 && IRFR < 300)
; 0001 0514 		{
; 0001 0515 			vMLlui(0); vMRlui(22); delay_ms(300);
; 0001 0516 		}
; 0001 0517 		if (IRFR>300 && IRFL < 300)
; 0001 0518 		{
; 0001 0519 			vMLlui(22); vMRlui(0); delay_ms(300);
; 0001 051A 		}
; 0001 051B 
; 0001 051C 		if ((IRFL < 300) && (IRFR < 300))
; 0001 051D 		{
; 0001 051E 			vMLtoi(20); vMRtoi(20);
; 0001 051F 			delay_ms(20);
; 0001 0520 		}
; 0001 0521 
; 0001 0522 		LEDR = !LEDR;
; 0001 0523 	}
; 0001 0524 }
;
;void runEscBlindSpotsethome()
; 0001 0527 {
; 0001 0528 	while (cmdCtrlRobot == 6)
; 0001 0529 	{
; 0001 052A 		DDRA = 0x00;
; 0001 052B 		PORTA = 0x00;
; 0001 052C 		readposition();
; 0001 052D 		IRFL = read_adc(4);
; 0001 052E 		IRFR = read_adc(5);
; 0001 052F 		if (IRFL > 300 && IRFR < 300)
; 0001 0530 		{
; 0001 0531 			vMLlui(0); vMRlui(22); delay_ms(300);
; 0001 0532 		}
; 0001 0533 		if (IRFR>300 && IRFL < 300)
; 0001 0534 		{
; 0001 0535 			vMLlui(22); vMRlui(0); delay_ms(300);
; 0001 0536 		}
; 0001 0537 
; 0001 0538 		if ((IRFL < 300) && (IRFR < 300))
; 0001 0539 		{
; 0001 053A 			vMLtoi(20); vMRtoi(20);
; 0001 053B 			delay_ms(10);
; 0001 053C 		}
; 0001 053D 
; 0001 053E 		LEDR = !LEDR;
; 0001 053F 	}
; 0001 0540 }
;
;//========================================================
;// SET HOME  vi tri robot, de chuan bi cho tran dau       PHUC//
;//========================================================
;int sethomeRB()
; 0001 0546 {
; 0001 0547 	while (flagsethome == 0)
; 0001 0548 	{
; 0001 0549 		LEDL = !LEDL;
; 0001 054A 		//PHUC SH
; 0001 054B 		if (readposition() == 1)//co du lieu moi
; 0001 054C 		{
; 0001 054D 			//hc(3,40);wn16s(cmdCtrlRobot);
; 0001 054E 			if (cmdCtrlRobot == 1)      // dung ma lenh stop chuong trinh
; 0001 054F 			{
; 0001 0550 				flagsethome = 0;
; 0001 0551 				return 0;
; 0001 0552 			}
; 0001 0553 
; 0001 0554 			if (cmdCtrlRobot == 2 || cmdCtrlRobot == 3 || cmdCtrlRobot == 4)      // dung ma lenh stop chuong trinh
; 0001 0555 			{
; 0001 0556 				flagsethome = 0;
; 0001 0557 				return 0;
; 0001 0558 			}
; 0001 0559 
; 0001 055A 			if (cmdCtrlRobot == 5)  //sethome robot
; 0001 055B 			{
; 0001 055C 
; 0001 055D 				calcvitri(rbctrlHomeX, rbctrlHomeY);
; 0001 055E 				if (distance > 100) //chay den vi tri
; 0001 055F 				{
; 0001 0560 					if (errangle > 18 || errangle < -18)
; 0001 0561 					{
; 0001 0562 						int nv = errangle * 27 / 180;
; 0001 0563 						int verrangle = calcVangle(errangle);
; 0001 0564 						ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0565 						delay_ms(1);
; 0001 0566 					}
; 0001 0567 					else
; 0001 0568 					{
; 0001 0569 						//1xung = 3.14 * 40/24 =5.22
; 0001 056A 						ctrRobottoi(distance / 5.22, 15);
; 0001 056B 						// verranglekisum=0;//RESET I.
; 0001 056C 					}
; 0001 056D 				}
; 0001 056E 				else //XOAY DUNG HUONG
; 0001 056F 				{
; 0001 0570 					setRobotAngleX = 10 * cos(rbctrlHomeAngle*M_PI / 180);
; 0001 0571 					setRobotAngleY = 10 * sin(rbctrlHomeAngle*M_PI / 180);;
; 0001 0572 					calcvitri(robotctrl.x + setRobotAngleX, robotctrl.y + setRobotAngleY);
; 0001 0573 					if (errangle>90 || errangle < -90)
; 0001 0574 					{
; 0001 0575 
; 0001 0576 						int nv = errangle * 27 / 180;
; 0001 0577 						int verrangle = calcVangle(errangle);
; 0001 0578 						ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0579 						delay_ms(1);
; 0001 057A 					}
; 0001 057B 					else
; 0001 057C 					{
; 0001 057D 
; 0001 057E 						verranglekisum = 0;//RESET I.
; 0001 057F 						flaghuongtrue = 0;
; 0001 0580 						flagsethome = 1;  // bao da set home khong can set nua
; 0001 0581 						vMRstop();
; 0001 0582 						vMLstop();
; 0001 0583 						return 0;
; 0001 0584 
; 0001 0585 					}
; 0001 0586 				}
; 0001 0587 
; 0001 0588 			}
; 0001 0589 
; 0001 058A 			if (cmdCtrlRobot == 7)  //sethome IS STUCKED
; 0001 058B 			{
; 0001 058C 
; 0001 058D 				cntstuckRB++;
; 0001 058E 				if (cntstuckRB > 2)
; 0001 058F 				{
; 0001 0590 					runEscStucksethome();
; 0001 0591 					cntstuckRB = 0;
; 0001 0592 				}
; 0001 0593 			}
; 0001 0594 
; 0001 0595 			if (cmdCtrlRobot == 6) //sethome IS //roi vao diem mu (blind spot) , mat vi tri hay huong
; 0001 0596 			{
; 0001 0597 				LEDBL = 1;
; 0001 0598 				cntunlookRB++;
; 0001 0599 				if (cntunlookRB > 2)
; 0001 059A 				{
; 0001 059B 					runEscBlindSpotsethome();
; 0001 059C 					cntunlookRB = 0;
; 0001 059D 
; 0001 059E 				}
; 0001 059F 
; 0001 05A0 			}
; 0001 05A1 
; 0001 05A2 
; 0001 05A3 		}
; 0001 05A4 
; 0001 05A5 		LEDR = !LEDR;
; 0001 05A6 
; 0001 05A7 	}
; 0001 05A8 	return 0;
; 0001 05A9 
; 0001 05AA }
;
;int codePenalty()
; 0001 05AD {
; 0001 05AE 	// chay den vi tri duoc dat truoc, sau do da banh 1 lan
; 0001 05AF 	//PHUC SH
; 0001 05B0 	if (readposition() == 1)//co du lieu moi
; 0001 05B1 	{
; 0001 05B2 		if (cmdCtrlRobot == 8)  //set vi tri penalty robot
; 0001 05B3 		{
; 0001 05B4 			calcvitri(rbctrlPenaltyX, rbctrlPenaltyY);
; 0001 05B5 			if (distance > 50) //chay den vi tri
; 0001 05B6 			{
; 0001 05B7 				if (errangle > 18 || errangle < -18)
; 0001 05B8 				{
; 0001 05B9 					int nv = errangle * 27 / 180;
; 0001 05BA 					int verrangle = calcVangle(errangle);
; 0001 05BB 					ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 05BC 					delay_ms(1);
; 0001 05BD 				}
; 0001 05BE 				else
; 0001 05BF 				{
; 0001 05C0 					//1xung = 3.14 * 40/24 =5.22
; 0001 05C1 					ctrRobottoi(distance / 5.22, 15);
; 0001 05C2 					// verranglekisum=0;//RESET I.
; 0001 05C3 				}
; 0001 05C4 			}
; 0001 05C5 			else //XOAY DUNG HUONG
; 0001 05C6 			{
; 0001 05C7 				setRobotAngleX = 10 * cos(rbctrlPenaltyAngle*M_PI / 180);
; 0001 05C8 				setRobotAngleY = 10 * sin(rbctrlPenaltyAngle*M_PI / 180);;
; 0001 05C9 				calcvitri(robotctrl.x + setRobotAngleX, robotctrl.y + setRobotAngleY);
; 0001 05CA 				if (errangle>10 || errangle < -10)
; 0001 05CB 				{
; 0001 05CC 
; 0001 05CD 					int nv = errangle * 27 / 180;
; 0001 05CE 					int verrangle = calcVangle(errangle);
; 0001 05CF 					ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 05D0 					delay_ms(1);
; 0001 05D1 				}
; 0001 05D2 				else
; 0001 05D3 				{
; 0001 05D4 
; 0001 05D5 					verranglekisum = 0;//RESET I.
; 0001 05D6 					flaghuongtrue = 0;
; 0001 05D7 					flagsethome = 1;  // bao da set vitri penalty
; 0001 05D8 					while (cmdCtrlRobot != 2) //cho nhan nut start
; 0001 05D9 					{
; 0001 05DA 						readposition();
; 0001 05DB 					}
; 0001 05DC 					// da banh
; 0001 05DD 					vMRtoi(22);
; 0001 05DE 					vMLtoi(22);
; 0001 05DF 					delay_ms(1000);
; 0001 05E0 					vMRlui(10);
; 0001 05E1 					vMLlui(10);
; 0001 05E2 					delay_ms(1000);
; 0001 05E3 					vMRstop();
; 0001 05E4 					vMLstop();
; 0001 05E5 					return 0;
; 0001 05E6 
; 0001 05E7 				}
; 0001 05E8 			}
; 0001 05E9 
; 0001 05EA 		}
; 0001 05EB 	}
; 0001 05EC 
; 0001 05ED }
;void settoadoHomRB()
; 0001 05EF {
_settoadoHomRB:
; 0001 05F0 	switch (ROBOT_ID)
	LDI  R30,LOW(5)
; 0001 05F1 	{
; 0001 05F2 		//PHUC
; 0001 05F3 	case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x20133
; 0001 05F4 
; 0001 05F5 
; 0001 05F6 		rbctrlPenaltyX = 0;
	CALL SUBOPT_0x34
; 0001 05F7 		rbctrlPenaltyY = 0;
; 0001 05F8 
; 0001 05F9 		if (SAN_ID == 1)
; 0001 05FA 		{
; 0001 05FB 			rbctrlPenaltyAngle = 179;
; 0001 05FC 			rbctrlHomeAngle = 179;
; 0001 05FD 			rbctrlHomeX = 269.7;
	CALL SUBOPT_0x35
; 0001 05FE 			rbctrlHomeY = 1.7;
; 0001 05FF 			setRobotXmin = 80;
; 0001 0600 			setRobotXmax = 260;
; 0001 0601 		}
; 0001 0602 		else
; 0001 0603 		{
; 0001 0604 			rbctrlPenaltyAngle = -15;
; 0001 0605 			rbctrlHomeAngle = -15;
; 0001 0606 			rbctrlHomeX = -226.1;
; 0001 0607 			rbctrlHomeY = 1.6;
; 0001 0608 			setRobotXmin = -260;
; 0001 0609 			setRobotXmax = -80;
_0x20336:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 060A 		}
; 0001 060B 		break;
	RJMP _0x20132
; 0001 060C 	case 2:
_0x20133:
	CPI  R30,LOW(0x2)
	BRNE _0x20136
; 0001 060D 
; 0001 060E 
; 0001 060F 		rbctrlPenaltyX = 0;
	CALL SUBOPT_0x34
; 0001 0610 		rbctrlPenaltyY = 0;
; 0001 0611 
; 0001 0612 		if (SAN_ID == 1)
; 0001 0613 		{
; 0001 0614 			rbctrlPenaltyAngle = 179;
; 0001 0615 			rbctrlHomeAngle = 179;
; 0001 0616 			rbctrlHomeX = 66.0;
	CALL SUBOPT_0x36
; 0001 0617 			rbctrlHomeY = 79.4;
; 0001 0618 			setRobotXmin = -270;
; 0001 0619 			setRobotXmax = 270;
; 0001 061A 		}
; 0001 061B 		else
; 0001 061C 		{
; 0001 061D 			rbctrlPenaltyAngle = -15;
; 0001 061E 			rbctrlHomeAngle = -15;
; 0001 061F 			rbctrlHomeX = -44.3;
; 0001 0620 			rbctrlHomeY = 82.7;
_0x20337:
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
; 0001 0621 			setRobotXmin = -270;
	CALL SUBOPT_0x37
; 0001 0622 			setRobotXmax = 270;
	CALL SUBOPT_0x38
; 0001 0623 		}
; 0001 0624 		break;
	RJMP _0x20132
; 0001 0625 	case 3:
_0x20136:
	CPI  R30,LOW(0x3)
	BRNE _0x20139
; 0001 0626 
; 0001 0627 
; 0001 0628 		rbctrlPenaltyX = 0;
	LDI  R30,LOW(0)
	STS  _rbctrlPenaltyX,R30
	STS  _rbctrlPenaltyX+1,R30
	STS  _rbctrlPenaltyX+2,R30
	STS  _rbctrlPenaltyX+3,R30
; 0001 0629 		rbctrlPenaltyY = 0;
	STS  _rbctrlPenaltyY,R30
	STS  _rbctrlPenaltyY+1,R30
	STS  _rbctrlPenaltyY+2,R30
	STS  _rbctrlPenaltyY+3,R30
; 0001 062A 		rbctrlPenaltyAngle = -15;
	__GETD1N 0xC1700000
	CALL SUBOPT_0x39
; 0001 062B 		if (SAN_ID == 1)
; 0001 062C 		{
; 0001 062D 			rbctrlPenaltyAngle = 179;
	CALL SUBOPT_0x39
; 0001 062E 			rbctrlHomeAngle = 179;
	STS  _rbctrlHomeAngle,R30
	STS  _rbctrlHomeAngle+1,R31
	STS  _rbctrlHomeAngle+2,R22
	STS  _rbctrlHomeAngle+3,R23
; 0001 062F 			rbctrlHomeX = 54.1;
	CALL SUBOPT_0x3A
; 0001 0630 			rbctrlHomeY = -99.9;
; 0001 0631 			setRobotXmin = -270;
; 0001 0632 			setRobotXmax = 20;
	__GETD1N 0x41A00000
; 0001 0633 		}
; 0001 0634 		else
; 0001 0635 		{
; 0001 0636 			rbctrlPenaltyAngle = -15;
; 0001 0637 			rbctrlHomeAngle = -15;
; 0001 0638 			rbctrlHomeX = -53.5;
; 0001 0639 			rbctrlHomeY = -93.8;
; 0001 063A 			setRobotXmin = -20;
; 0001 063B 			setRobotXmax = 270;
_0x20338:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 063C 		}
; 0001 063D 		break;
	RJMP _0x20132
; 0001 063E 	case 4:
_0x20139:
	CPI  R30,LOW(0x4)
	BRNE _0x2013C
; 0001 063F 
; 0001 0640 		rbctrlPenaltyX = 0;
	CALL SUBOPT_0x34
; 0001 0641 		rbctrlPenaltyY = 0;
; 0001 0642 
; 0001 0643 		if (SAN_ID == 1)
; 0001 0644 		{
; 0001 0645 			rbctrlPenaltyAngle = 179;
; 0001 0646 			rbctrlHomeAngle = 179;
; 0001 0647 			rbctrlHomeX = 269.7;
	CALL SUBOPT_0x35
; 0001 0648 			rbctrlHomeY = 1.7;
; 0001 0649 			setRobotXmin = 80;
; 0001 064A 			setRobotXmax = 260;
; 0001 064B 		}
; 0001 064C 		else
; 0001 064D 		{
; 0001 064E 			rbctrlPenaltyAngle = -15;
; 0001 064F 			rbctrlHomeAngle = -15;
; 0001 0650 			rbctrlHomeX = -226.1;
; 0001 0651 			rbctrlHomeY = 1.6;
; 0001 0652 			setRobotXmin = -260;
; 0001 0653 			setRobotXmax = -80;
_0x20339:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 0654 		}
; 0001 0655 		break;
	RJMP _0x20132
; 0001 0656 	case 5:
_0x2013C:
	CPI  R30,LOW(0x5)
	BRNE _0x2013F
; 0001 0657 
; 0001 0658 		rbctrlPenaltyX = 0;
	CALL SUBOPT_0x34
; 0001 0659 		rbctrlPenaltyY = 0;
; 0001 065A 		if (SAN_ID == 1)
; 0001 065B 		{
; 0001 065C 			rbctrlPenaltyAngle = 179;
; 0001 065D 			rbctrlHomeAngle = 179;
; 0001 065E 			rbctrlHomeX = 66.0;
	CALL SUBOPT_0x36
; 0001 065F 			rbctrlHomeY = 79.4;
; 0001 0660 			setRobotXmin = -270;
; 0001 0661 			setRobotXmax = 270;
; 0001 0662 		}
; 0001 0663 		else
; 0001 0664 		{
; 0001 0665 			rbctrlPenaltyAngle = -15;
; 0001 0666 			rbctrlHomeAngle = -15;
; 0001 0667 			rbctrlHomeX = -44.3;
; 0001 0668 			rbctrlHomeY = 82.7;
_0x2033A:
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
; 0001 0669 			setRobotXmin = -270;
	CALL SUBOPT_0x37
; 0001 066A 			setRobotXmax = 270;
	CALL SUBOPT_0x38
; 0001 066B 		}
; 0001 066C 		break;
	RJMP _0x20132
; 0001 066D 	case 6:
_0x2013F:
	CPI  R30,LOW(0x6)
	BRNE _0x20132
; 0001 066E 
; 0001 066F 
; 0001 0670 		rbctrlPenaltyX = 0;
	CALL SUBOPT_0x34
; 0001 0671 		rbctrlPenaltyY = 0;
; 0001 0672 		if (SAN_ID == 1)
; 0001 0673 		{
; 0001 0674 			rbctrlPenaltyAngle = 179;
; 0001 0675 			rbctrlHomeAngle = 179;
; 0001 0676 			rbctrlHomeX = 54.1;
	CALL SUBOPT_0x3A
; 0001 0677 			rbctrlHomeY = -99.9;
; 0001 0678 			setRobotXmin = -270;
; 0001 0679 			setRobotXmax = 20;
	__GETD1N 0x41A00000
; 0001 067A 		}
; 0001 067B 		else
; 0001 067C 		{
; 0001 067D 			rbctrlPenaltyAngle = -15;
; 0001 067E 			rbctrlHomeAngle = -15;
; 0001 067F 			rbctrlHomeX = -53.5;
; 0001 0680 			rbctrlHomeY = -93.8;
; 0001 0681 			setRobotXmin = -20;
; 0001 0682 			setRobotXmax = 270;
_0x2033B:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 0683 		}
; 0001 0684 		break;
; 0001 0685 
; 0001 0686 
; 0001 0687 	}
_0x20132:
; 0001 0688 }
	RET
;//=======================================================
;// Tinh luc theo goc quay de dieu khien robot
;int calcVangle(int angle)
; 0001 068C {
; 0001 068D 	int verrangle = 0;
; 0001 068E 	//tinh thanh phan I
; 0001 068F 	verranglekisum = verranglekisum + angle / 20;
;	angle -> Y+2
;	verrangle -> R16,R17
; 0001 0690 	if (verranglekisum > 15)verranglekisum = 15;
; 0001 0691 	if (verranglekisum < -15)verranglekisum = -15;
; 0001 0692 	//tinh thanh phan dieu khien
; 0001 0693 	verrangle = 10 + angle / 12 + verranglekisum;
; 0001 0694 	//gioi han bao hoa
; 0001 0695 	if (verrangle < 0) verrangle = -verrangle;//lay tri tuyet doi cua van toc v dieu khien
; 0001 0696 	if (verrangle > 20) verrangle = 20;
; 0001 0697 	if (verrangle < 8) verrangle = 8;
; 0001 0698 	return  verrangle;
; 0001 0699 }
;//ctrl robot
;void ctrrobot()
; 0001 069C {
; 0001 069D 	if (readposition() == 1)//co du lieu moi
; 0001 069E 	{
; 0001 069F 		//          hc(3,40);wn16s(cmdCtrlRobot);
; 0001 06A0 		//        hc(4,40);wn16s(idRobot);
; 0001 06A1 		//-------------------------------------------------
; 0001 06A2 		if (cmdCtrlRobot == 8)      // dung ma lenh stop chuong trinh
; 0001 06A3 		{
; 0001 06A4 			flagsethome = 0; //cho phep sethome
; 0001 06A5 			while (cmdCtrlRobot == 8)
; 0001 06A6 			{
; 0001 06A7 				codePenalty();
; 0001 06A8 			}
; 0001 06A9 		}
; 0001 06AA 
; 0001 06AB 		if (cmdCtrlRobot == 1)      // dung ma lenh stop chuong trinh
; 0001 06AC 		{
; 0001 06AD 			flagsethome = 0; //cho phep sethome
; 0001 06AE 			while (cmdCtrlRobot == 1)
; 0001 06AF 			{
; 0001 06B0 				readposition();
; 0001 06B1 			}
; 0001 06B2 		}
; 0001 06B3 
; 0001 06B4 		if (cmdCtrlRobot == 5)  //sethome robot
; 0001 06B5 		{
; 0001 06B6 
; 0001 06B7 			cntsethomeRB++;
; 0001 06B8 			if (cntsethomeRB > 2)
; 0001 06B9 			{
; 0001 06BA 				LEDBR = 1;
; 0001 06BB 				if (flagsethome == 0)sethomeRB();
; 0001 06BC 				cntsethomeRB = 0;
; 0001 06BD 			}
; 0001 06BE 
; 0001 06BF 		}
; 0001 06C0 
; 0001 06C1 		if (cmdCtrlRobot == 4)  //sethome robot
; 0001 06C2 		{
; 0001 06C3 			flagsethome = 0; //cho phep sethome
; 0001 06C4 			cntstuckRB++;
; 0001 06C5 			if (cntstuckRB > 2)
; 0001 06C6 			{
; 0001 06C7 				runEscStuck();
; 0001 06C8 				cntstuckRB = 0;
; 0001 06C9 			}
; 0001 06CA 		}
; 0001 06CB 
; 0001 06CC 		if (cmdCtrlRobot == 3)  //roi vao diem mu (blind spot) , mat vi tri hay huong
; 0001 06CD 		{
; 0001 06CE 			flagsethome = 0; //cho phep sethome
; 0001 06CF 			cntunlookRB++;
; 0001 06D0 			if (cntunlookRB > 2)
; 0001 06D1 			{
; 0001 06D2 				runEscBlindSpot();
; 0001 06D3 				cntunlookRB = 0;
; 0001 06D4 			}
; 0001 06D5 
; 0001 06D6 		}
; 0001 06D7 
; 0001 06D8 
; 0001 06D9 		//------------------------------------------------
; 0001 06DA 		if (cmdCtrlRobot == 2) {// run chuong trinh
; 0001 06DB 			flagsethome = 0; //cho phep sethome
; 0001 06DC 			switch (flagtask)
; 0001 06DD 			{
; 0001 06DE 				// chay den vi tri duoc set boi nguoi dieu khien
; 0001 06DF 			case 0:
; 0001 06E0 				if (setRobotX < setRobotXmin)   setRobotX = setRobotXmin;
; 0001 06E1 				if (setRobotX > setRobotXmax)    setRobotX = setRobotXmax;
; 0001 06E2 				calcvitri(setRobotX, setRobotY);
; 0001 06E3 				if (distance > 80) //chay den vi tri
; 0001 06E4 				{
; 0001 06E5 					if (errangle > 18 || errangle < -18)
; 0001 06E6 					{
; 0001 06E7 						int nv = errangle * 27 / 180;
; 0001 06E8 						int verrangle = calcVangle(errangle);
; 0001 06E9 						ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 06EA 						delay_ms(1);
; 0001 06EB 					}
; 0001 06EC 					else
; 0001 06ED 					{
; 0001 06EE 						//1xung = 3.14 * 40/24 =5.22
; 0001 06EF 						ctrRobottoi(distance / 5.22, 15);
; 0001 06F0 						// verranglekisum=0;//RESET I.
; 0001 06F1 					}
; 0001 06F2 				}
; 0001 06F3 				else
; 0001 06F4 				{
; 0001 06F5 					flagtask = 10;
; 0001 06F6 				}
; 0001 06F7 				break;
; 0001 06F8 				// quay dung huong duoc set boi nguoi dieu khien
; 0001 06F9 			case 1:
; 0001 06FA 
; 0001 06FB 				calcvitri(robotctrl.x + setRobotAngleX, robotctrl.y + setRobotAngleY);
; 0001 06FC 				if (errangle > 18 || errangle < -18)
; 0001 06FD 				{
; 0001 06FE 
; 0001 06FF 					int nv = errangle * 27 / 180;
; 0001 0700 					int verrangle = calcVangle(errangle);
; 0001 0701 					ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0702 					// ctrRobotXoay(nv,10);
; 0001 0703 					delay_ms(1);
; 0001 0704 				}
; 0001 0705 				else
; 0001 0706 				{
; 0001 0707 					flaghuongtrue++;
; 0001 0708 					if (flaghuongtrue > 3)
; 0001 0709 					{
; 0001 070A 						//verranglekisum=0;//RESET I.
; 0001 070B 						flaghuongtrue = 0;
; 0001 070C 						flagtask = 10;
; 0001 070D 					}
; 0001 070E 
; 0001 070F 				}
; 0001 0710 				break;
; 0001 0711 				// chay den vi tri bong
; 0001 0712 			case 2:
; 0001 0713 
; 0001 0714 				//PHUC test    rb1 ,s1
; 0001 0715 				if (robotctrl.ball.x < setRobotXmin)   robotctrl.ball.x = setRobotXmin;
; 0001 0716 				if (robotctrl.ball.x > setRobotXmax)    robotctrl.ball.x = setRobotXmax;
; 0001 0717 				calcvitri(robotctrl.ball.x, robotctrl.ball.y);
; 0001 0718 
; 0001 0719 				if (errangle > 18 || errangle < -18)
; 0001 071A 				{
; 0001 071B 					int nv = errangle * 27 / 180;
; 0001 071C 					int verrangle = calcVangle(errangle);
; 0001 071D 					ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 071E 					delay_ms(1);
; 0001 071F 				}
; 0001 0720 				else
; 0001 0721 				{
; 0001 0722 					//1xung = 3.14 * 40/24 =5.22
; 0001 0723 					if (distance > 10) //chay den vi tri
; 0001 0724 					{
; 0001 0725 						ctrRobottoi(distance / 5.22, 15);
; 0001 0726 						delay_ms(5);
; 0001 0727 					}
; 0001 0728 					else
; 0001 0729 					{
; 0001 072A 						flagtask = 10;
; 0001 072B 					}
; 0001 072C 					// verranglekisum=0;//RESET I.
; 0001 072D 				}
; 0001 072E 
; 0001 072F 				break;
; 0001 0730 				// da bong
; 0001 0731 			case 3:
; 0001 0732 				ctrRobottoi(40, 22);
; 0001 0733 				delay_ms(400);
; 0001 0734 				ctrRobotlui(40, 15);
; 0001 0735 				delay_ms(400);
; 0001 0736 				flagtask = 10;
; 0001 0737 				break;
; 0001 0738 			case 10:
; 0001 0739 				vMRtoi(0);
; 0001 073A 				vMLtoi(0);
; 0001 073B 				break;
; 0001 073C 				//chay theo bong co dinh huong
; 0001 073D 			case 4:
; 0001 073E 				calcvitri(robotctrl.ball.x, robotctrl.ball.y);
; 0001 073F 				if (errangle > 18 || errangle < -18)
; 0001 0740 				{
; 0001 0741 
; 0001 0742 					int nv = errangle * 27 / 180;
; 0001 0743 					int verrangle = calcVangle(errangle);
; 0001 0744 					ctrRobotXoay(nv, verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0745 					// ctrRobotXoay(nv,10);
; 0001 0746 					delay_ms(1);
; 0001 0747 				}
; 0001 0748 				else
; 0001 0749 				{
; 0001 074A 					flaghuongtrue++;
; 0001 074B 					if (flaghuongtrue > 3)
; 0001 074C 					{
; 0001 074D 						//verranglekisum=0;//RESET I.
; 0001 074E 						flaghuongtrue = 0;
; 0001 074F 						flagtask = 10;
; 0001 0750 					}
; 0001 0751 
; 0001 0752 				}
; 0001 0753 				break;
; 0001 0754 			}
; 0001 0755 		}//end if(cmdCtrlRobot==2)
; 0001 0756 	}
; 0001 0757 	else   //khong co tin hieu RF hay khong thay robot
; 0001 0758 	{
; 0001 0759 		//if(flagunlookRB==1) runEscBlindSpot();
; 0001 075A 
; 0001 075B 	}
; 0001 075C 
; 0001 075D 
; 0001 075E }
;
;void rb_move(float x, float y)
; 0001 0761 {
; 0001 0762 	flagtask = 0;
;	x -> Y+4
;	y -> Y+0
; 0001 0763 	flagtaskold = flagtask;
; 0001 0764 	setRobotX = x;
; 0001 0765 	setRobotY = y;
; 0001 0766 }
;void rb_rotate(int angle)     // goc xoay so voi truc x cua toa do
; 0001 0768 {
; 0001 0769 	flagtask = 1;
;	angle -> Y+0
; 0001 076A 	flagtaskold = flagtask;
; 0001 076B 	setRobotAngleX = 10 * cos(angle*M_PI / 180);
; 0001 076C 	setRobotAngleY = 10 * sin(angle*M_PI / 180);;
; 0001 076D }
;
;void rb_goball()
; 0001 0770 {
; 0001 0771 	flagtask = 2;
; 0001 0772 	flagtaskold = flagtask;
; 0001 0773 }
;void rb_kick()
; 0001 0775 {
; 0001 0776 	flagtask = 3;
; 0001 0777 	flagtaskold = flagtask;
; 0001 0778 }
;int rb_wait(unsigned long int time)
; 0001 077A {
; 0001 077B 	time = time * 10;
;	time -> Y+0
; 0001 077C 	while (time--)
; 0001 077D 	{
; 0001 077E 		ctrrobot();
; 0001 077F 		if (flagtask == 10) return 1;// thuc hien xong nhiem vu
; 0001 0780 	}
; 0001 0781 	return 0;
; 0001 0782 }
;//========================================================
;// Timer1 overflow interrupt service routine
;// period =1/2khz= 0.5ms
;interrupt[TIM1_OVF] void timer1_ovf_isr(void)
; 0001 0787 {
_timer1_ovf_isr:
	CALL SUBOPT_0x3B
; 0001 0788 	// Place your code here
; 0001 0789 	timerstick++;
	LDI  R26,LOW(_timerstick)
	LDI  R27,HIGH(_timerstick)
	CALL SUBOPT_0x3C
; 0001 078A 	timerstickdis++;
	LDI  R26,LOW(_timerstickdis)
	LDI  R27,HIGH(_timerstickdis)
	CALL SUBOPT_0x3C
; 0001 078B 	timerstickang++;
	LDI  R26,LOW(_timerstickang)
	LDI  R27,HIGH(_timerstickang)
	CALL SUBOPT_0x3C
; 0001 078C 	timerstickctr++;
	LDI  R26,LOW(_timerstickctr)
	LDI  R27,HIGH(_timerstickctr)
	CALL SUBOPT_0x3C
; 0001 078D #ifdef CtrVelocity
; 0001 078E 	// dieu khien van toc
; 0001 078F 	if (timerstick > 250)    // 125ms/0.5ms=250 : dung chu ki lay mau = 125 ms
	LDS  R26,_timerstick
	LDS  R27,_timerstick+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x20185
; 0001 0790 	{
; 0001 0791 		int eR = 0, eL = 0;
; 0001 0792 
; 0001 0793 		//-------------------------------------------
; 0001 0794 		//cap nhat van toc
; 0001 0795 		vQER = (QER - oldQER);     //(xung / 10ms)
	CALL SUBOPT_0x3D
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
;	eR -> Y+2
;	eL -> Y+0
	LDS  R26,_oldQER
	LDS  R27,_oldQER+1
	CALL SUBOPT_0x14
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQER,R30
	STS  _vQER+1,R31
; 0001 0796 		vQEL = (QEL - oldQEL);     //(xung /10ms)
	LDS  R26,_oldQEL
	LDS  R27,_oldQEL+1
	CALL SUBOPT_0x3E
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQEL,R30
	STS  _vQEL+1,R31
; 0001 0797 		oldQEL = QEL;
	CALL SUBOPT_0x3E
	STS  _oldQEL,R30
	STS  _oldQEL+1,R31
; 0001 0798 		oldQER = QER;
	CALL SUBOPT_0x14
	STS  _oldQER,R30
	STS  _oldQER+1,R31
; 0001 0799 		timerstick = 0;
	LDI  R30,LOW(0)
	STS  _timerstick,R30
	STS  _timerstick+1,R30
; 0001 079A 
; 0001 079B 		//--------------------------------------------
; 0001 079C 		//tinh PID van toc
; 0001 079D 		//--------------------------------------------
; 0001 079E 		eR = svQER - vQER;
	LDS  R26,_vQER
	LDS  R27,_vQER+1
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 079F 		//tinh thanh phan I
; 0001 07A0 		seRki = seRki + KiR*eR;
	LDS  R26,_KiR
	LDS  R27,_KiR+1
	CALL __MULW12
	CALL SUBOPT_0x3F
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x40
; 0001 07A1 		if (seRki > 100) seRki = 100;
	CALL SUBOPT_0x3F
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x20186
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x40
; 0001 07A2 		if (seRki < -100) seRki = -100;
_0x20186:
	CALL SUBOPT_0x3F
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x20187
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x40
; 0001 07A3 		//tinh them thanh phan P
; 0001 07A4 		uR = 100 + KpR*eR + seRki;
_0x20187:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_KpR
	LDS  R27,_KpR+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x3F
	ADD  R30,R26
	ADC  R31,R27
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 07A5 		if (uR > 255) uR = 255;
	LDS  R26,_uR
	LDS  R27,_uR+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x20188
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 07A6 		if (uR < 0) uR = 0;
_0x20188:
	LDS  R26,_uR+1
	TST  R26
	BRPL _0x20189
	LDI  R30,LOW(0)
	STS  _uR,R30
	STS  _uR+1,R30
; 0001 07A7 
; 0001 07A8 		eL = svQEL - vQEL;
_0x20189:
	LDS  R26,_vQEL
	LDS  R27,_vQEL+1
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	CALL SUBOPT_0xC
; 0001 07A9 		//tinh thanh phan I
; 0001 07AA 		seLki = seLki + KiL*eL;
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KiL
	LDS  R27,_KiL+1
	CALL __MULW12
	CALL SUBOPT_0x41
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x42
; 0001 07AB 		if (seLki > 100) seLki = 100;
	CALL SUBOPT_0x41
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x2018A
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x42
; 0001 07AC 		if (seLki < -100) seLki = -100;
_0x2018A:
	CALL SUBOPT_0x41
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x2018B
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x42
; 0001 07AD 		//tinh them thanh phan P
; 0001 07AE 		uL = 100 + KpL*eL + seLki;
_0x2018B:
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KpL
	LDS  R27,_KpL+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x41
	ADD  R30,R26
	ADC  R31,R27
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 07AF 		if (uL > 255) uL = 255;
	LDS  R26,_uL
	LDS  R27,_uL+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2018C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 07B0 		if (uL < 0) uL = 0;
_0x2018C:
	LDS  R26,_uL+1
	TST  R26
	BRPL _0x2018D
	LDI  R30,LOW(0)
	STS  _uL,R30
	STS  _uL+1,R30
; 0001 07B1 
; 0001 07B2 		if (svQER != 0)OCR1B = uR;
_0x2018D:
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SBIW R30,0
	BREQ _0x2018E
	LDS  R30,_uR
	LDS  R31,_uR+1
	RJMP _0x2033D
; 0001 07B3 		else  OCR1B = 0;
_0x2018E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2033D:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 07B4 
; 0001 07B5 		if (svQEL != 0) OCR1A = uL;
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	SBIW R30,0
	BREQ _0x20190
	LDS  R30,_uL
	LDS  R31,_uL+1
	RJMP _0x2033E
; 0001 07B6 		else  OCR1A = 0;
_0x20190:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2033E:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 07B7 
; 0001 07B8 	}
	ADIW R28,4
; 0001 07B9 	// dieu khien khoang cach
; 0001 07BA 	if (timerstickdis > 10 && (flagwaitctrRobot == 1))
_0x20185:
	LDS  R26,_timerstickdis
	LDS  R27,_timerstickdis+1
	SBIW R26,11
	BRLO _0x20193
	LDS  R26,_flagwaitctrRobot
	CPI  R26,LOW(0x1)
	BREQ _0x20194
_0x20193:
	RJMP _0x20192
_0x20194:
; 0001 07BB 	{
; 0001 07BC 		unsigned int deltad1 = 0;
; 0001 07BD 		deltad1 = (QER + QEL) / 2 - oldd;
	SBIW R28,2
	CALL SUBOPT_0x43
;	deltad1 -> Y+0
	CALL SUBOPT_0x44
	LDS  R26,_oldd
	LDS  R27,_oldd+1
	CALL SUBOPT_0xC
; 0001 07BE 		//if(deltad1<0) deltad1=0;// co the am do kieu so
; 0001 07BF 		//hc(3,0);ws("            ");
; 0001 07C0 		//hc(3,0);wn16s(deltad1);
; 0001 07C1 		if (deltad1 > sd)
	LDS  R30,_sd
	LDS  R31,_sd+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x20195
; 0001 07C2 		{
; 0001 07C3 
; 0001 07C4 			vMLstop();
	RCALL _vMLstop
; 0001 07C5 			vMRstop();
	RCALL _vMRstop
; 0001 07C6 			flagwaitctrRobot = 0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrRobot,R30
; 0001 07C7 			oldd = (QER + QEL) / 2;
	CALL SUBOPT_0x44
	STS  _oldd,R30
	STS  _oldd+1,R31
; 0001 07C8 
; 0001 07C9 		}
; 0001 07CA 		timerstickdis = 0;
_0x20195:
	LDI  R30,LOW(0)
	STS  _timerstickdis,R30
	STS  _timerstickdis+1,R30
; 0001 07CB 
; 0001 07CC 	}
	ADIW R28,2
; 0001 07CD 	// dieu khien  vi tri goc quay
; 0001 07CE 	if (timerstickang > 10 && (flagwaitctrAngle == 1))
_0x20192:
	LDS  R26,_timerstickang
	LDS  R27,_timerstickang+1
	SBIW R26,11
	BRLO _0x20197
	LDS  R26,_flagwaitctrAngle
	CPI  R26,LOW(0x1)
	BREQ _0x20198
_0x20197:
	RJMP _0x20196
_0x20198:
; 0001 07CF 	{
; 0001 07D0 		unsigned int deltaa = 0;
; 0001 07D1 		deltaa = (QEL)-olda;
	SBIW R28,2
	CALL SUBOPT_0x43
;	deltaa -> Y+0
	LDS  R26,_olda
	LDS  R27,_olda+1
	CALL SUBOPT_0x3E
	CALL SUBOPT_0xC
; 0001 07D2 		//    hc(4,0);ws("            ");
; 0001 07D3 		//    hc(4,0);wn16s(deltaa);
; 0001 07D4 		if (deltaa > sa)
	LDS  R30,_sa
	LDS  R31,_sa+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x20199
; 0001 07D5 		{
; 0001 07D6 			vMLstop();
	RCALL _vMLstop
; 0001 07D7 			vMRstop();
	RCALL _vMRstop
; 0001 07D8 			flagwaitctrAngle = 0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrAngle,R30
; 0001 07D9 			olda = QEL;
	CALL SUBOPT_0x3E
	STS  _olda,R30
	STS  _olda+1,R31
; 0001 07DA 		}
; 0001 07DB 		timerstickang = 0;
_0x20199:
	LDI  R30,LOW(0)
	STS  _timerstickang,R30
	STS  _timerstickang+1,R30
; 0001 07DC 	}
	ADIW R28,2
; 0001 07DD 	// dieu khien robot robot
; 0001 07DE 	if (timerstickctr > 1)
_0x20196:
	LDS  R26,_timerstickctr
	LDS  R27,_timerstickctr+1
	SBIW R26,2
	BRLO _0x2019A
; 0001 07DF 	{
; 0001 07E0 		timerstickctr = 0;
	LDI  R30,LOW(0)
	STS  _timerstickctr,R30
	STS  _timerstickctr+1,R30
; 0001 07E1 	}
; 0001 07E2 #endif
; 0001 07E3 }
_0x2019A:
	CALL SUBOPT_0x45
	RETI
;
;// vl and vr is the speed of the encoder
;void Velocity(int vl, int vr) {
; 0001 07E6 void Velocity(int vl, int vr) {
; 0001 07E7 	if (vl > 0) {
;	vl -> Y+2
;	vr -> Y+0
; 0001 07E8 		vMLtoi(vl);
; 0001 07E9 	}
; 0001 07EA 	else if (vl < 0) {
; 0001 07EB 		vMLlui(-vl);
; 0001 07EC 	}
; 0001 07ED 	else {
; 0001 07EE 		vMLstop();
; 0001 07EF 	}
; 0001 07F0 
; 0001 07F1 	if (vr > 0) {
; 0001 07F2 		vMRtoi(vr);
; 0001 07F3 	}
; 0001 07F4 	else if (vr < 0) {
; 0001 07F5 		vMLlui(-vr);
; 0001 07F6 	}
; 0001 07F7 	else {
; 0001 07F8 		vMRstop();
; 0001 07F9 	}
; 0001 07FA }
;
;void Angle(int theta_d)
; 0001 07FD {
; 0001 07FE 	int theta_e, vl, vr;
; 0001 07FF 
; 0001 0800 	theta_e = theta_d - (int)orientation;
;	theta_d -> Y+6
;	theta_e -> R16,R17
;	vl -> R18,R19
;	vr -> R20,R21
; 0001 0801 
; 0001 0802 	while (theta_e > 180) theta_e -= 360;
; 0001 0803 while (theta_e <= -180) theta_e += 360;
; 0001 0805 if (theta_e < -90) {
; 0001 0806 		theta_e += 180;
; 0001 0807 	} if (theta_e > 90) {
; 0001 0808 		theta_e -= 180;
; 0001 0809 	}
; 0001 080A 
; 0001 080B 	if (absolute(theta_e) > 50) {
; 0001 080C 
; 0001 080D 	}
; 0001 080E }
;
;void MoveToOrigin() {
; 0001 0810 void MoveToOrigin() {
_MoveToOrigin:
; 0001 0811 	float dist, newX, newY;
; 0001 0812 
; 0001 0813 	newX = robotctrl.x * 0.0333;
	SBIW R28,12
;	dist -> Y+8
;	newX -> Y+4
;	newY -> Y+0
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x46
	CALL SUBOPT_0x2B
; 0001 0814 	newY = robotctrl.y * 0.0333;
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x46
	CALL SUBOPT_0x30
; 0001 0815 
; 0001 0816 
; 0001 0817 	dist = sqrt((newX + 1) * (newX + 1) + (newY - 1) * (newY - 1));
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x49
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x49
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x20
	CALL SUBOPT_0x29
; 0001 0818 
; 0001 0819 	if (dist < 2) {
	__GETD1N 0x40000000
	CALL __CMPF12
	BRSH _0x201AC
; 0001 081A 		vMRstop();
	RCALL _vMRstop
; 0001 081B 		vMLstop();
	RCALL _vMLstop
; 0001 081C 	}
; 0001 081D 	else {
	RJMP _0x201AD
_0x201AC:
; 0001 081E 		ctrRobottoi((int)(dist * 12 * 2), 20);
	CALL SUBOPT_0x4A
	__GETD1N 0x41400000
	CALL __MULF12
	__GETD2N 0x40000000
	CALL __MULF12
	CALL __CFD1
	CALL SUBOPT_0x4B
	RCALL _ctrRobottoi
; 0001 081F 	}
_0x201AD:
; 0001 0820 
; 0001 0821 #ifdef DEBUG_EN
; 0001 0822 	{
; 0001 0823 		char dbgLen;
; 0001 0824 
; 0001 0825 		dbgLen = sprintf(debugMsgBuff, "Distance Square: %f \n\r", dist);
	SBIW R28,1
;	dist -> Y+9
;	newX -> Y+5
;	newY -> Y+1
;	dbgLen -> Y+0
	CALL SUBOPT_0x4C
	__POINTW1FN _0x20000,21
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 13
	CALL SUBOPT_0x4D
; 0001 0826 		debug_out(debugMsgBuff, dbgLen);
	CALL SUBOPT_0x4E
; 0001 0827 
; 0001 0828 		dbgLen = sprintf(debugMsgBuff, "Robot.x: %d \n\r", robotctrl.x);
	__POINTW1FN _0x20000,44
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1B
	CALL __CWD1
	CALL SUBOPT_0x4D
; 0001 0829 		debug_out(debugMsgBuff, dbgLen);
	CALL SUBOPT_0x4E
; 0001 082A 
; 0001 082B 		dbgLen = sprintf(debugMsgBuff, "Robot.y: %d \n\r", robotctrl.y);
	__POINTW1FN _0x20000,59
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1D
	CALL __CWD1
	CALL SUBOPT_0x4D
; 0001 082C 		debug_out(debugMsgBuff, dbgLen);
	CALL SUBOPT_0x4E
; 0001 082D 
; 0001 082E 		dbgLen = sprintf(debugMsgBuff, "--------------- \n\r");
	__POINTW1FN _0x20000,74
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	ST   Y,R30
; 0001 082F 		debug_out(debugMsgBuff, dbgLen);
	CALL SUBOPT_0x4C
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _debug_out
; 0001 0830 	}
	ADIW R28,1
; 0001 0831 #endif
; 0001 0832 }
	RJMP _0x20C000C
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;unsigned char testposition()
; 0001 0838 {
_testposition:
; 0001 0839 	unsigned char  i = 0;
; 0001 083A 	unsigned flagstatus = 0;
; 0001 083B 
; 0001 083C 	while (keyKT != 0)
	CALL __SAVELOCR4
;	i -> R17
;	flagstatus -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x201AE:
	SBIS 0x13,0
	RJMP _0x201B0
; 0001 083D 	{
; 0001 083E 		readposition();
	CALL _readposition
; 0001 083F 
; 0001 0840 		if (idRobot == ROBOT_ID)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x201B1
; 0001 0841 		{
; 0001 0842 			hc(5, 40); wn16s(robotctrl.ball.y);
	CALL SUBOPT_0x4F
	__GETW1MN _robotctrl,12
	CALL SUBOPT_0x50
; 0001 0843 			hc(4, 40); wn16s(robotctrl.ball.x);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x4F
	__GETW1MN _robotctrl,10
	CALL SUBOPT_0x50
; 0001 0844 			hc(3, 20); wn16s(robotctrl.x);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x4B
	RCALL _hc
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x50
; 0001 0845 			hc(2, 20); wn16s(robotctrl.y);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x4B
	RCALL _hc
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x50
; 0001 0846 			hc(1, 1); wn16s(robotctrl.ox);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x51
	RCALL _hc
	__GETW1MN _robotctrl,6
	CALL SUBOPT_0x50
; 0001 0847 			hc(0, 1); wn16s(robotctrl.oy);
	CALL SUBOPT_0x52
	CALL SUBOPT_0x51
	RCALL _hc
	__GETW1MN _robotctrl,8
	CALL SUBOPT_0x50
; 0001 0848 			delay_ms(200);
	CALL SUBOPT_0x53
; 0001 0849 		}
; 0001 084A 
; 0001 084B 	}
_0x201B1:
	RJMP _0x201AE
_0x201B0:
; 0001 084C 	return flagstatus;
	MOV  R30,R18
	RJMP _0x20C000B
; 0001 084D }
;//========================================================
;void robotwall()
; 0001 0850 {
_robotwall:
; 0001 0851 	unsigned int demled;
; 0001 0852 	DDRA = 0x00;
	ST   -Y,R17
	ST   -Y,R16
;	demled -> R16,R17
	CALL SUBOPT_0x54
; 0001 0853 	PORTA = 0x00;
; 0001 0854 
; 0001 0855 	LcdClear();
; 0001 0856 	hc(0, 10);
	CALL SUBOPT_0x55
; 0001 0857 	ws("ROBOT WALL");
	__POINTW1MN _0x201B2,0
	CALL SUBOPT_0xE
; 0001 0858 	LEDL = 1; LEDR = 1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0859 
; 0001 085A 	while (keyKT != 0)
_0x201B7:
	SBIS 0x13,0
	RJMP _0x201B9
; 0001 085B 	{
; 0001 085C 		IRFL = read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STS  _IRFL,R30
	STS  _IRFL+1,R31
; 0001 085D 		IRFR = read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STS  _IRFR,R30
	STS  _IRFR+1,R31
; 0001 085E 		hc(1, 0); wn16(IRFL);
	CALL SUBOPT_0x56
	LDS  R30,_IRFL
	LDS  R31,_IRFL+1
	CALL SUBOPT_0xD
; 0001 085F 		hc(1, 42); wn16(IRFR);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x57
	LDS  R30,_IRFR
	LDS  R31,_IRFR+1
	CALL SUBOPT_0xD
; 0001 0860 
; 0001 0861 		if (IRFL > 250)
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x201BA
; 0001 0862 		{
; 0001 0863 			vMLlui(22); vMRlui(10); delay_ms(600);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(10)
	CALL SUBOPT_0x58
; 0001 0864 		}
; 0001 0865 		if (IRFR > 250)
_0x201BA:
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x201BB
; 0001 0866 		{
; 0001 0867 			vMLlui(10); vMRlui(22); delay_ms(600);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(22)
	CALL SUBOPT_0x58
; 0001 0868 		}
; 0001 0869 		if ((IRFL < 300)&(IRFR < 300))
_0x201BB:
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __LTW12U
	MOV  R0,R30
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0x201BC
; 0001 086A 		{
; 0001 086B 			vMLtoi(22); vMRtoi(22);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 086C 		}
; 0001 086D 
; 0001 086E 		demled++;
_0x201BC:
	__ADDWRN 16,17,1
; 0001 086F 		if (demled > 50){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	__CPWRN 16,17,51
	BRLO _0x201BD
	__GETWRN 16,17,0
	CALL SUBOPT_0x59
; 0001 0870 	}
_0x201BD:
	RJMP _0x201B7
_0x201B9:
; 0001 0871 
; 0001 0872 }
	LD   R16,Y+
	LD   R17,Y+
	RET

	.DSEG
_0x201B2:
	.BYTE 0xB
;////========================================================
;//void robotline() //DIGITAL I/O
;//{
;//    unsigned char status=2;
;//    unsigned char prestatus=2;
;//
;//    DDRA =0x00;
;//    PORTA=0xFF;
;////#define S0  PINA.0 status 0
;////#define S1  PINA.1 status 1
;////#define S2  PINA.2 status 2
;////#define S3  PINA.3 status 3
;////#define S4  PINA.7 status 4
;//        LcdClear();
;//        hc(0,1);
;//        ws ("LINE FOLOWER");
;//        hc(1,20);
;//        ws (" ROBOT");
;//        LEDL=1;LEDR=1;
;//
;//   while(keyKT!=0)
;//   {
;//      if (S2==0)
;//      {
;//          status=2;
;//          vMLtoi(80);vMRtoi(80);
;//      }
;//      //===========================
;//      if ((prestatus==2)&(S1==0))
;//      {
;//          status=1;
;//          vMLtoi(80);vMRtoi(50);
;//      }
;//      if ((prestatus==2)&(S0==0))
;//      {
;//          status=0;
;//          vMLtoi(80);vMRtoi(30);
;//      }
;//       //===========================
;//      if ((prestatus==2)&(S3==0))
;//      {
;//          status=1;
;//          vMLtoi(50);vMRtoi(80);
;//      }
;//      if ((prestatus==2)&(S4==0))
;//      {
;//          status=0;
;//          vMLtoi(30);vMRtoi(80);
;//      }
;//       //===========================
;//      if ((prestatus==1)&(S0==0))
;//      {
;//          status=1;
;//          vMLtoi(80);vMRtoi(40);
;//      }
;//      if ((prestatus==3)&(S4==0))
;//      {
;//          status=0;
;//          vMLtoi(40);vMRtoi(80);
;//      }
;//
;//      prestatus=status;
;//      delay_ms(200);LEDLtoggle();LEDRtoggle();
;//
;//  }
;// }
;
;
;//========================================================
;void readline()
; 0001 08B9 {

	.CSEG
_readline:
; 0001 08BA 	int i = 0, j = 0;
; 0001 08BB 	// reset the values
; 0001 08BC 	for (i = 0; i < 5; i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x201BF:
	__CPWRN 16,17,5
	BRGE _0x201C0
; 0001 08BD 		IRLINE[i] = 0;
	CALL SUBOPT_0x5A
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x201BF
_0x201C0:
; 0001 08BF for (j = 0; j < 50; j++)
	__GETWRN 18,19,0
_0x201C2:
	__CPWRN 18,19,50
	BRLT PC+3
	JMP _0x201C3
; 0001 08C0 	{
; 0001 08C1 		IRLINE[0] = IRLINE[0] + read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDS  R26,_IRLINE
	LDS  R27,_IRLINE+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _IRLINE,R30
	STS  _IRLINE+1,R31
; 0001 08C2 		IRLINE[1] = IRLINE[1] + read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,2
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,2
; 0001 08C3 		IRLINE[2] = IRLINE[2] + read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x5B
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,4
; 0001 08C4 		IRLINE[3] = IRLINE[3] + read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,6
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,6
; 0001 08C5 		IRLINE[4] = IRLINE[4] + read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _read_adc
	__GETW2MN _IRLINE,8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,8
; 0001 08C6 	}
	__ADDWRN 18,19,1
	RJMP _0x201C2
_0x201C3:
; 0001 08C7 	// get the rounded average of the readings for each sensor
; 0001 08C8 	for (i = 0; i < 5; i++)
	__GETWRN 16,17,0
_0x201C5:
	__CPWRN 16,17,5
	BRGE _0x201C6
; 0001 08C9 		IRLINE[i] = (IRLINE[i] + (50 >> 1)) / 50;
	CALL SUBOPT_0x5A
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	ADIW R30,25
	MOVW R26,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x201C5
_0x201C6:
; 0001 08CA }
	RJMP _0x20C000B
;//========================================================
;void robotwhiteline() //ANALOG OK
; 0001 08CD {
_robotwhiteline:
; 0001 08CE 	unsigned char i = 0, imax;
; 0001 08CF 	int imaxlast = 0;
; 0001 08D0 	unsigned int  admax;
; 0001 08D1 	unsigned int  demled = 0;
; 0001 08D2 	unsigned int flagblindT = 0;
; 0001 08D3 	unsigned int flagblindP = 0;
; 0001 08D4 	DDRA = 0x00;
	SBIW R28,6
	CALL SUBOPT_0x43
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	CALL __SAVELOCR6
;	i -> R17
;	imax -> R16
;	imaxlast -> R18,R19
;	admax -> R20,R21
;	demled -> Y+10
;	flagblindT -> Y+8
;	flagblindP -> Y+6
	LDI  R17,0
	__GETWRN 18,19,0
	CALL SUBOPT_0x54
; 0001 08D5 	PORTA = 0x00;
; 0001 08D6 
; 0001 08D7 	LcdClear();
; 0001 08D8 	hc(0, 1);
	CALL SUBOPT_0x51
	CALL _hc
; 0001 08D9 	ws("WHITE LINE");
	__POINTW1MN _0x201C7,0
	CALL SUBOPT_0xE
; 0001 08DA 	hc(1, 10);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x55
; 0001 08DB 	ws("FOLOWER");
	__POINTW1MN _0x201C7,11
	CALL SUBOPT_0xE
; 0001 08DC 	LEDL = 1; LEDR = 1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 08DD 	//doc va khoi dong gia tri cho imaxlast
; 0001 08DE 	readline();
	CALL SUBOPT_0x5D
; 0001 08DF 	admax = IRLINE[0]; imax = 0;
; 0001 08E0 	for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
_0x201CD:
	CPI  R17,5
	BRSH _0x201CE
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5C
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201CF
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
_0x201CF:
	SUBI R17,-1
	RJMP _0x201CD
_0x201CE:
; 0001 08E1 	imaxlast = imax;
	MOV  R18,R16
	CLR  R19
; 0001 08E2 	while (keyKT != 0)
_0x201D0:
	SBIS 0x13,0
	RJMP _0x201D2
; 0001 08E3 	{
; 0001 08E4 		//doc gia tri cam bien
; 0001 08E5 		readline();
	CALL SUBOPT_0x5D
; 0001 08E6 		admax = IRLINE[0]; imax = 0;
; 0001 08E7 		for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
_0x201D4:
	CPI  R17,5
	BRSH _0x201D5
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5C
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201D6
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
_0x201D6:
	SUBI R17,-1
	RJMP _0x201D4
_0x201D5:
; 0001 08E8 		//imax=2;
; 0001 08E9 		if ((imax - imaxlast > 1) || (imax - imaxlast < -1))  //tranh truong hop nhay bo trang thai
	CALL SUBOPT_0x60
	SUB  R30,R18
	SBC  R31,R19
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x201D8
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x201D7
_0x201D8:
; 0001 08EA 		{
; 0001 08EB 		}
; 0001 08EC 		else
	RJMP _0x201DA
_0x201D7:
; 0001 08ED 		{
; 0001 08EE 			switch (imax)
	CALL SUBOPT_0x60
; 0001 08EF 			{
; 0001 08F0 			case 0:
	SBIW R30,0
	BRNE _0x201DE
; 0001 08F1 				vMLtoi(1); vMRtoi(20);
	CALL SUBOPT_0x61
	CALL SUBOPT_0x62
; 0001 08F2 				//flagblindT = 0;
; 0001 08F3 				flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 08F4 				break;
	RJMP _0x201DD
; 0001 08F5 			case 1:
_0x201DE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x201DF
; 0001 08F6 				vMLtoi(1); vMRtoi(15);
	CALL SUBOPT_0x61
	CALL SUBOPT_0x63
; 0001 08F7 				break;
	RJMP _0x201DD
; 0001 08F8 			case 2:
_0x201DF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x201E0
; 0001 08F9 				vMLtoi(15); vMRtoi(15);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x63
; 0001 08FA 				break;
	RJMP _0x201DD
; 0001 08FB 			case 3:
_0x201E0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x201E1
; 0001 08FC 				vMLtoi(15); vMRtoi(1);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
; 0001 08FD 				break;
	RJMP _0x201DD
; 0001 08FE 			case 4:
_0x201E1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x201E3
; 0001 08FF 				vMLtoi(20); vMRtoi(1);
	CALL SUBOPT_0x66
; 0001 0900 				flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0901 				//flagblindP = 0;
; 0001 0902 				break;
; 0001 0903 			default:
_0x201E3:
; 0001 0904 				// vMLtoi(5); vMRtoi(5) ;
; 0001 0905 				break;
; 0001 0906 			}
_0x201DD:
; 0001 0907 			imaxlast = imax;
	MOV  R18,R16
	CLR  R19
; 0001 0908 		}
_0x201DA:
; 0001 0909 
; 0001 090A 		while (flagblindT == 1 && keyKT != 0) //lac duong ben trai
_0x201E4:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x201E7
	CALL SUBOPT_0x67
	BRNE _0x201E8
_0x201E7:
	RJMP _0x201E6
_0x201E8:
; 0001 090B 		{
; 0001 090C 			vMLtoi(20); vMRtoi(1);
	CALL SUBOPT_0x66
; 0001 090D 			readline();
	CALL SUBOPT_0x5D
; 0001 090E 			admax = IRLINE[0]; imax = 0;
; 0001 090F 			for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
_0x201EA:
	CPI  R17,5
	BRSH _0x201EB
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5C
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201EC
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
_0x201EC:
	SUBI R17,-1
	RJMP _0x201EA
_0x201EB:
; 0001 0910 			imaxlast = imax;
	MOV  R18,R16
	CLR  R19
; 0001 0911 			if (IRLINE[2] > 500)  flagblindT = 0;
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201ED
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0001 0912 
; 0001 0913 
; 0001 0914 		}
_0x201ED:
	RJMP _0x201E4
_0x201E6:
; 0001 0915 		while (flagblindP == 1 && keyKT != 0) //lac duong ben phai
_0x201EE:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x201F1
	CALL SUBOPT_0x67
	BRNE _0x201F2
_0x201F1:
	RJMP _0x201F0
_0x201F2:
; 0001 0916 		{
; 0001 0917 			vMLtoi(1); vMRtoi(20);
	CALL SUBOPT_0x61
	CALL SUBOPT_0x62
; 0001 0918 			readline();
	CALL SUBOPT_0x5D
; 0001 0919 			admax = IRLINE[0]; imax = 0;
; 0001 091A 			for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
_0x201F4:
	CPI  R17,5
	BRSH _0x201F5
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5C
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201F6
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
_0x201F6:
	SUBI R17,-1
	RJMP _0x201F4
_0x201F5:
; 0001 091B 			imaxlast = imax;
	MOV  R18,R16
	CLR  R19
; 0001 091C 			if (IRLINE[2] > 500)  flagblindP = 0;
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201F7
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0001 091D 
; 0001 091E 		}
_0x201F7:
	RJMP _0x201EE
_0x201F0:
; 0001 091F 		hc(3, 10); wn16s(imax);
	CALL SUBOPT_0x68
	CALL SUBOPT_0x60
	CALL SUBOPT_0x50
; 0001 0920 		hc(4, 10); wn16s(admax);
	CALL SUBOPT_0x69
	ST   -Y,R21
	ST   -Y,R20
	CALL _wn16s
; 0001 0921 
; 0001 0922 		demled++;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0923 		if (demled > 30){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,31
	BRLO _0x201F8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	CALL SUBOPT_0x59
; 0001 0924 	}
_0x201F8:
	RJMP _0x201D0
_0x201D2:
; 0001 0925 }
	CALL __LOADLOCR6
_0x20C000C:
	ADIW R28,12
	RET

	.DSEG
_0x201C7:
	.BYTE 0x13
;
;//========================================================
;void robotblackline() //ANALOG OK
; 0001 0929 {

	.CSEG
_robotblackline:
; 0001 092A 	long int lastvalueline = 0, valueline = 0, value = 0, online = 0;
; 0001 092B 	int i = 0, j = 0
; 0001 092C 		, imin = 0;
; 0001 092D 	long int avrg = 0, sum = 0;
; 0001 092E 	unsigned int admin;
; 0001 092F 	unsigned char imax;
; 0001 0930 	int imaxlast = 0;
; 0001 0931 	unsigned int  admax;
; 0001 0932 	unsigned int demled = 0;
; 0001 0933 	unsigned int flagblindT = 0;
; 0001 0934 	unsigned int flagblindP = 0;
; 0001 0935 	float udk, sumi = 0, err, lasterr;
; 0001 0936 
; 0001 0937 	int iminlast = 0;
; 0001 0938 	DDRA = 0x00;
	SBIW R28,55
	LDI  R24,55
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x201F9*2)
	LDI  R31,HIGH(_0x201F9*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	lastvalueline -> Y+57
;	valueline -> Y+53
;	value -> Y+49
;	online -> Y+45
;	i -> R16,R17
;	j -> R18,R19
;	imin -> R20,R21
;	avrg -> Y+41
;	sum -> Y+37
;	admin -> Y+35
;	imax -> Y+34
;	imaxlast -> Y+32
;	admax -> Y+30
;	demled -> Y+28
;	flagblindT -> Y+26
;	flagblindP -> Y+24
;	udk -> Y+20
;	sumi -> Y+16
;	err -> Y+12
;	lasterr -> Y+8
;	iminlast -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x54
; 0001 0939 	PORTA = 0x00;
; 0001 093A 
; 0001 093B 	LcdClear();
; 0001 093C 	hc(0, 1);
	CALL SUBOPT_0x51
	CALL _hc
; 0001 093D 	ws("BLACK LINE");
	__POINTW1MN _0x201FA,0
	CALL SUBOPT_0xE
; 0001 093E 	hc(1, 10);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x55
; 0001 093F 	ws("FOLOWER");
	__POINTW1MN _0x201FA,11
	CALL SUBOPT_0xE
; 0001 0940 	LEDL = 1; LEDR = 1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0941 
; 0001 0942 	//doc lan dau tien  de khoi dong gia tri iminlast;
; 0001 0943 	readline();
	CALL SUBOPT_0x6A
; 0001 0944 	admin = IRLINE[0]; imin = 0;
; 0001 0945 	for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
_0x20200:
	__CPWRN 16,17,5
	BRGE _0x20201
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x6B
	BRSH _0x20202
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20202:
	__ADDWRN 16,17,1
	RJMP _0x20200
_0x20201:
; 0001 0946 	iminlast = imin;
	__PUTWSR 20,21,6
; 0001 0947 	admin = 1024;
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	STD  Y+35,R30
	STD  Y+35+1,R31
; 0001 0948 	admax = 0;
	STD  Y+30,R30
	STD  Y+30+1,R30
; 0001 0949 	//calib
; 0001 094A 	while (keyKT != 0)
_0x20203:
	SBIS 0x13,0
	RJMP _0x20205
; 0001 094B 	{
; 0001 094C 		//doc gia tri cam bien
; 0001 094D 		readline();
	RCALL _readline
; 0001 094E 
; 0001 094F 		for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
	__GETWRN 16,17,1
_0x20207:
	__CPWRN 16,17,5
	BRGE _0x20208
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x6B
	BRSH _0x20209
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20209:
	__ADDWRN 16,17,1
	RJMP _0x20207
_0x20208:
; 0001 0950 		//hc(3,10);wn16s(admin);
; 0001 0951 		hc(3, 10); wn16s(admin);
	CALL SUBOPT_0x68
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x50
; 0001 0952 
; 0001 0953 		for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
	__GETWRN 16,17,1
_0x2020B:
	__CPWRN 16,17,5
	BRGE _0x2020C
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2020D
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	STD  Y+30,R30
	STD  Y+30+1,R31
	__PUTBSR 16,34
_0x2020D:
	__ADDWRN 16,17,1
	RJMP _0x2020B
_0x2020C:
; 0001 0954 		hc(4, 10); wn16s(admax);
	CALL SUBOPT_0x69
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	CALL SUBOPT_0x50
; 0001 0955 	}
	RJMP _0x20203
_0x20205:
; 0001 0956 	//test gia tri doc line
; 0001 0957 	online = 0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 0958 	while (1)
_0x2020E:
; 0001 0959 	{
; 0001 095A 		//doc gia tri cam bien
; 0001 095B 		readline();
	RCALL _readline
; 0001 095C 		for (i = 0; i < 5; i++)
	__GETWRN 16,17,0
_0x20212:
	__CPWRN 16,17,5
	BRLT PC+3
	JMP _0x20213
; 0001 095D 		{
; 0001 095E 			value = IRLINE[i];
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CLR  R22
	CLR  R23
	__PUTD1S 49
; 0001 095F 			if (value < 280) online = 1;
	__GETD2S 49
	__CPD2N 0x118
	BRGE _0x20214
	__GETD1N 0x1
	__PUTD1S 45
; 0001 0960 			avrg = avrg + i * 1000 * value;
_0x20214:
	MOVW R30,R16
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R26,R30
	__GETD1S 49
	CALL __CWD2
	CALL __MULD12
	__GETD2S 41
	CALL __ADDD12
	__PUTD1S 41
; 0001 0961 			sum = sum + value;
	__GETD1S 49
	__GETD2S 37
	CALL __ADDD12
	__PUTD1S 37
; 0001 0962 		}
	__ADDWRN 16,17,1
	RJMP _0x20212
_0x20213:
; 0001 0963 		//hc(1,10);wn16s(online);
; 0001 0964 		if (online == 1)
	__GETD2S 45
	CALL SUBOPT_0x6C
	BRNE _0x20215
; 0001 0965 		{
; 0001 0966 			valueline = (int)(avrg / sum);
	__GETD1S 37
	__GETD2S 41
	CALL __DIVD21
	CLR  R22
	CLR  R23
	CALL __CWD1
	__PUTD1S 53
; 0001 0967 			// hc(2,10);wn16s(valueline);
; 0001 0968 			online = 0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 0969 			avrg = 0;
	__CLRD1S 41
; 0001 096A 			sum = 0;
	__CLRD1S 37
; 0001 096B 		}
; 0001 096C 		else
	RJMP _0x20216
_0x20215:
; 0001 096D 		{
; 0001 096E 			if (lastvalueline > 1935)
	__GETD2S 57
	__CPD2N 0x790
	BRLT _0x20217
; 0001 096F 				valueline = 2000;
	__GETD1N 0x7D0
	RJMP _0x2033F
; 0001 0970 			else
_0x20217:
; 0001 0971 				valueline = 1800;
	__GETD1N 0x708
_0x2033F:
	__PUTD1S 53
; 0001 0972 		}
_0x20216:
; 0001 0973 		err = 1935 - valueline;
	__GETD2S 53
	__GETD1N 0x78F
	CALL __SUBD12
	CALL __CDF1
	CALL SUBOPT_0x28
; 0001 0974 		if (err > 100) err = 100;
	CALL SUBOPT_0x6D
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20219
	CALL SUBOPT_0x28
; 0001 0975 		if (err < -100) err = -100;
_0x20219:
	CALL SUBOPT_0x6D
	__GETD1N 0xC2C80000
	CALL __CMPF12
	BRSH _0x2021A
	CALL SUBOPT_0x28
; 0001 0976 		sumi = sumi + err / 35;
_0x2021A:
	CALL SUBOPT_0x6D
	__GETD1N 0x420C0000
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x25
; 0001 0977 		if (sumi > 6) sumi = 6;
	CALL SUBOPT_0x6F
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2021B
	CALL SUBOPT_0x25
; 0001 0978 		if (sumi < -6) sumi = -6;
_0x2021B:
	CALL SUBOPT_0x6F
	__GETD1N 0xC0C00000
	CALL __CMPF12
	BRSH _0x2021C
	CALL SUBOPT_0x25
; 0001 0979 		udk = err / 7 + sumi + (err - lasterr) / 30;
_0x2021C:
	CALL SUBOPT_0x6D
	__GETD1N 0x40E00000
	CALL SUBOPT_0x6E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x2A
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41F00000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
; 0001 097A 		if (udk > 10) { udk = 9; sumi = 0; }
	CALL SUBOPT_0x70
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2021D
	__GETD1N 0x41100000
	CALL SUBOPT_0x71
; 0001 097B 		if (udk < -10){ udk = -9; sumi = 0; }
_0x2021D:
	CALL SUBOPT_0x24
	__GETD1N 0xC1200000
	CALL __CMPF12
	BRSH _0x2021E
	__GETD1N 0xC1100000
	CALL SUBOPT_0x71
; 0001 097C 		//hc(5,10);wn16s(udk);
; 0001 097D 		vMLtoi(10 + udk); vMRtoi(10 - udk);
_0x2021E:
	__GETD1S 20
	__GETD2N 0x41200000
	CALL __ADDF12
	CALL __CFD1U
	ST   -Y,R30
	CALL _vMLtoi
	CALL SUBOPT_0x70
	CALL __SUBF12
	CALL __CFD1U
	ST   -Y,R30
	CALL _vMRtoi
; 0001 097E 
; 0001 097F 		lastvalueline = valueline;
	__GETD1S 53
	__PUTD1S 57
; 0001 0980 		lasterr = err;
	CALL SUBOPT_0x72
	__PUTD1S 8
; 0001 0981 	}
	RJMP _0x2020E
; 0001 0982 
; 0001 0983 	while (keyKT != 0)
_0x2021F:
	SBIS 0x13,0
	RJMP _0x20221
; 0001 0984 	{
; 0001 0985 		//doc gia tri cam bien
; 0001 0986 		readline();
	CALL SUBOPT_0x6A
; 0001 0987 		admin = IRLINE[0]; imin = 0;
; 0001 0988 		for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
_0x20223:
	__CPWRN 16,17,5
	BRGE _0x20224
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x6B
	BRSH _0x20225
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20225:
	__ADDWRN 16,17,1
	RJMP _0x20223
_0x20224:
; 0001 0989 		hc(2, 10); wn16s(iminlast);
	CALL SUBOPT_0x73
	CALL SUBOPT_0x55
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x50
; 0001 098A 		hc(3, 10); wn16s(imin);
	CALL SUBOPT_0x68
	ST   -Y,R21
	ST   -Y,R20
	CALL _wn16s
; 0001 098B 		hc(4, 10); wn16s(admin);
	CALL SUBOPT_0x69
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x50
; 0001 098C 
; 0001 098D 		if ((imin - iminlast > 1) || (imin - iminlast < -1))  //tranh truong hop nhay bo trang thai
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x20227
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x20226
_0x20227:
; 0001 098E 		{
; 0001 098F 		}
; 0001 0990 		else
	RJMP _0x20229
_0x20226:
; 0001 0991 		{
; 0001 0992 			switch (imin)
	MOVW R30,R20
; 0001 0993 			{
; 0001 0994 			case 0:
	SBIW R30,0
	BRNE _0x2022D
; 0001 0995 				vMLtoi(1); vMRtoi(15);
	CALL SUBOPT_0x61
	CALL SUBOPT_0x63
; 0001 0996 				//flagblindT = 0;
; 0001 0997 				flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0001 0998 				break;
	RJMP _0x2022C
; 0001 0999 			case 1:
_0x2022D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2022E
; 0001 099A 				vMLtoi(2); vMRtoi(8);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 099B 				break;
	RJMP _0x2022C
; 0001 099C 			case 2:
_0x2022E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2022F
; 0001 099D 				vMLtoi(10); vMRtoi(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 099E 				break;
	RJMP _0x2022C
; 0001 099F 			case 3:
_0x2022F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20230
; 0001 09A0 				vMLtoi(8); vMRtoi(2);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x74
; 0001 09A1 				break;
	RJMP _0x2022C
; 0001 09A2 			case 4:
_0x20230:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20232
; 0001 09A3 				vMLtoi(15); vMRtoi(1);
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
; 0001 09A4 				flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0001 09A5 				//flagblindP = 0;
; 0001 09A6 				break;
; 0001 09A7 			default:
_0x20232:
; 0001 09A8 				// vMLtoi(5); vMRtoi(5) ;
; 0001 09A9 				break;
; 0001 09AA 			}
_0x2022C:
; 0001 09AB 
; 0001 09AC 			iminlast = imin;
	__PUTWSR 20,21,6
; 0001 09AD 		}
_0x20229:
; 0001 09AE 
; 0001 09AF 
; 0001 09B0 		while (flagblindT == 1 && keyKT != 0) //lac duong ben trai
_0x20233:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	SBIW R26,1
	BRNE _0x20236
	CALL SUBOPT_0x67
	BRNE _0x20237
_0x20236:
	RJMP _0x20235
_0x20237:
; 0001 09B1 		{
; 0001 09B2 			vMLtoi(20); vMRtoi(2);
	LDI  R30,LOW(20)
	CALL SUBOPT_0x74
; 0001 09B3 			readline();
	CALL SUBOPT_0x6A
; 0001 09B4 			admin = IRLINE[0]; imin = 0;
; 0001 09B5 			for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
_0x20239:
	__CPWRN 16,17,5
	BRGE _0x2023A
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x6B
	BRSH _0x2023B
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x2023B:
	__ADDWRN 16,17,1
	RJMP _0x20239
_0x2023A:
; 0001 09B6 			iminlast = imin;
	__PUTWSR 20,21,6
; 0001 09B7 			if (IRLINE[2] < 310)  flagblindT = 0;
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x2023C
	LDI  R30,LOW(0)
	STD  Y+26,R30
	STD  Y+26+1,R30
; 0001 09B8 
; 0001 09B9 		}
_0x2023C:
	RJMP _0x20233
_0x20235:
; 0001 09BA 		while (flagblindP == 1 && keyKT != 0) //lac duong ben phai
_0x2023D:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,1
	BRNE _0x20240
	CALL SUBOPT_0x67
	BRNE _0x20241
_0x20240:
	RJMP _0x2023F
_0x20241:
; 0001 09BB 		{
; 0001 09BC 			vMLtoi(2); vMRtoi(20);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _vMLtoi
	CALL SUBOPT_0x62
; 0001 09BD 			readline();
	CALL SUBOPT_0x6A
; 0001 09BE 			admin = IRLINE[0]; imin = 0;
; 0001 09BF 			for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
_0x20243:
	__CPWRN 16,17,5
	BRGE _0x20244
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x6B
	BRSH _0x20245
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20245:
	__ADDWRN 16,17,1
	RJMP _0x20243
_0x20244:
; 0001 09C0 			iminlast = imin;
	__PUTWSR 20,21,6
; 0001 09C1 			if (IRLINE[2] < 310)  flagblindP = 0;
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x20246
	LDI  R30,LOW(0)
	STD  Y+24,R30
	STD  Y+24+1,R30
; 0001 09C2 
; 0001 09C3 		}
_0x20246:
	RJMP _0x2023D
_0x2023F:
; 0001 09C4 
; 0001 09C5 
; 0001 09C6 		demled++;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ADIW R30,1
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0001 09C7 		if (demled > 30){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	SBIW R26,31
	BRLO _0x20247
	LDI  R30,LOW(0)
	STD  Y+28,R30
	STD  Y+28+1,R30
	CALL SUBOPT_0x59
; 0001 09C8 	}
_0x20247:
	RJMP _0x2021F
_0x20221:
; 0001 09C9 }
	CALL __LOADLOCR6
	ADIW R28,61
	RET

	.DSEG
_0x201FA:
	.BYTE 0x13
;//========================================================
;void bluetooth()
; 0001 09CC {

	.CSEG
_bluetooth:
; 0001 09CD 	unsigned char kytu;
; 0001 09CE 	unsigned int demled;
; 0001 09CF 
; 0001 09D0 	LcdClear();
	CALL __SAVELOCR4
;	kytu -> R17
;	demled -> R18,R19
	CALL SUBOPT_0x75
; 0001 09D1 	hc(0, 10);
	CALL SUBOPT_0x55
; 0001 09D2 	ws("BLUETOOTH");
	__POINTW1MN _0x20248,0
	CALL SUBOPT_0xE
; 0001 09D3 	hc(1, 25);
	CALL SUBOPT_0x51
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x76
; 0001 09D4 	ws("DRIVE");
	__POINTW1MN _0x20248,10
	CALL SUBOPT_0xE
; 0001 09D5 
; 0001 09D6 	LEDL = 1; LEDR = 1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 09D7 
; 0001 09D8 	while (keyKT != 0)
_0x2024D:
	SBIS 0x13,0
	RJMP _0x2024F
; 0001 09D9 	{
; 0001 09DA 		LEDL = 1; LEDR = 1;
	CALL SUBOPT_0x77
; 0001 09DB 		delay_ms(100);
; 0001 09DC 		LEDL = 0; LEDR = 0;
; 0001 09DD 		delay_ms(100);
; 0001 09DE 
; 0001 09DF 		if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20258
; 0001 09E0 		{
; 0001 09E1 			//LcdClear();
; 0001 09E2 			hc(2, 42);
	CALL SUBOPT_0x73
	CALL SUBOPT_0x57
; 0001 09E3 			kytu = getchar();
	CALL _getchar
	MOV  R17,R30
; 0001 09E4 			LcdCharacter(kytu);
	ST   -Y,R17
	CALL _LcdCharacter
; 0001 09E5 			//putchar(getchar());
; 0001 09E6 			if (kytu == 'S'){ vMLtoi(0); vMRtoi(0); }
	CPI  R17,83
	BRNE _0x20259
	LDI  R30,LOW(0)
	CALL SUBOPT_0x78
; 0001 09E7 			if (kytu == 'F'){ vMLtoi(100); vMRtoi(100); }
_0x20259:
	CPI  R17,70
	BRNE _0x2025A
	LDI  R30,LOW(100)
	CALL SUBOPT_0x79
; 0001 09E8 			if (kytu == 'B'){ vMLlui(100); vMRlui(100); }
_0x2025A:
	CPI  R17,66
	BRNE _0x2025B
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMLlui
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMRlui
; 0001 09E9 			if (kytu == 'R'){ vMLtoi(100); vMRtoi(0); }
_0x2025B:
	CPI  R17,82
	BRNE _0x2025C
	LDI  R30,LOW(100)
	CALL SUBOPT_0x78
; 0001 09EA 			if (kytu == 'L'){ vMLtoi(0); vMRtoi(100); }
_0x2025C:
	CPI  R17,76
	BRNE _0x2025D
	LDI  R30,LOW(0)
	CALL SUBOPT_0x79
; 0001 09EB 
; 0001 09EC 			demled++;
_0x2025D:
	__ADDWRN 18,19,1
; 0001 09ED 			if (demled > 1000){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	__CPWRN 18,19,1001
	BRLO _0x2025E
	__GETWRN 18,19,0
	CALL SUBOPT_0x59
; 0001 09EE 		}
_0x2025E:
; 0001 09EF 	}
_0x20258:
	RJMP _0x2024D
_0x2024F:
; 0001 09F0 }
_0x20C000B:
	CALL __LOADLOCR4
	ADIW R28,4
	RET

	.DSEG
_0x20248:
	.BYTE 0x10
;//========================================================
;
;//Chuong trinh test robot
;void testmotor()
; 0001 09F5 {

	.CSEG
_testmotor:
; 0001 09F6 	LcdClear();
	CALL SUBOPT_0x75
; 0001 09F7 	hc(0, 10);
	CALL SUBOPT_0x55
; 0001 09F8 	ws("TEST MOTOR");
	__POINTW1MN _0x2025F,0
	CALL SUBOPT_0xE
; 0001 09F9 
; 0001 09FA 	vMRtoi(20);
	CALL SUBOPT_0x62
; 0001 09FB 	vMLtoi(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
; 0001 09FC 	while (keyKT != 0)
_0x20260:
	SBIS 0x13,0
	RJMP _0x20262
; 0001 09FD 	{
; 0001 09FE 		hc(2, 0);
	CALL SUBOPT_0x7A
; 0001 09FF 		ws("MotorL");
	__POINTW1MN _0x2025F,11
	CALL SUBOPT_0xE
; 0001 0A00 		hc(2, 45);
	CALL SUBOPT_0x73
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x76
; 0001 0A01 		wn16(QEL);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0xD
; 0001 0A02 		hc(3, 0);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7
; 0001 0A03 		ws("MotorR");
	__POINTW1MN _0x2025F,18
	CALL SUBOPT_0xE
; 0001 0A04 		hc(3, 45);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x76
; 0001 0A05 		wn16(QER);
	CALL SUBOPT_0x14
	CALL SUBOPT_0xD
; 0001 0A06 		delay_ms(10);
	CALL SUBOPT_0x7B
; 0001 0A07 	}
	RJMP _0x20260
_0x20262:
; 0001 0A08 
; 0001 0A09 	vMRstop();
	CALL _vMRstop
; 0001 0A0A 	vMLstop();
	CALL _vMLstop
; 0001 0A0B }
	RET

	.DSEG
_0x2025F:
	.BYTE 0x19
;//========================================================
;// UART TEST
;void testuart()
; 0001 0A0F {

	.CSEG
_testuart:
; 0001 0A10 	if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20263
; 0001 0A11 	{
; 0001 0A12 		LcdClear();
	CALL SUBOPT_0x75
; 0001 0A13 		hc(0, 10);
	CALL SUBOPT_0x55
; 0001 0A14 		ws("TEST UART");
	__POINTW1MN _0x20264,0
	CALL SUBOPT_0xE
; 0001 0A15 		putchar(getchar());
	CALL _getchar
	ST   -Y,R30
	CALL _putchar
; 0001 0A16 	}
; 0001 0A17 
; 0001 0A18 }
_0x20263:
	RET

	.DSEG
_0x20264:
	.BYTE 0xA
;//========================================================
;// UART TEST
;void testrf()
; 0001 0A1C {

	.CSEG
_testrf:
; 0001 0A1D 
; 0001 0A1E 
; 0001 0A1F }
	RET
;
;//========================================================
;void testir()
; 0001 0A23 {
_testir:
; 0001 0A24 	unsigned int AD[8];
; 0001 0A25 
; 0001 0A26 	DDRA = 0x00;
	SBIW R28,16
;	AD -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0001 0A27 	PORTA = 0x00;
	OUT  0x1B,R30
; 0001 0A28 
; 0001 0A29 	clear();
	CALL _clear
; 0001 0A2A 	hc(0, 10);
	CALL SUBOPT_0x52
	CALL SUBOPT_0x55
; 0001 0A2B 	ws("TEST IR");
	__POINTW1MN _0x20265,0
	CALL SUBOPT_0xE
; 0001 0A2C 
; 0001 0A2D 	while (keyKT != 0)
_0x20266:
	SBIS 0x13,0
	RJMP _0x20268
; 0001 0A2E 	{
; 0001 0A2F 
; 0001 0A30 		AD[0] = read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	ST   Y,R30
	STD  Y+1,R31
; 0001 0A31 		AD[1] = read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0A32 		AD[2] = read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 0A33 		AD[3] = read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0A34 		AD[4] = read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0A35 		AD[5] = read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0A36 		AD[6] = read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 0A37 		AD[7] = read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 0A38 
; 0001 0A39 		hc(1, 0); ws("0."); wn164(AD[0]);
	CALL SUBOPT_0x56
	__POINTW1MN _0x20265,8
	CALL SUBOPT_0xE
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x7C
; 0001 0A3A 		hc(1, 43); ws("1."); wn164(AD[1]);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x7D
	__POINTW1MN _0x20265,11
	CALL SUBOPT_0xE
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x7C
; 0001 0A3B 		hc(2, 0); ws("2."); wn164(AD[2]);
	CALL SUBOPT_0x7A
	__POINTW1MN _0x20265,14
	CALL SUBOPT_0xE
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x7C
; 0001 0A3C 		hc(2, 43); ws("3."); wn164(AD[3]);
	CALL SUBOPT_0x73
	CALL SUBOPT_0x7D
	__POINTW1MN _0x20265,17
	CALL SUBOPT_0xE
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x7C
; 0001 0A3D 		hc(3, 0); ws("4."); wn164(AD[4]);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7
	__POINTW1MN _0x20265,20
	CALL SUBOPT_0xE
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x7C
; 0001 0A3E 		hc(3, 43); ws("5."); wn164(AD[5]);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7D
	__POINTW1MN _0x20265,23
	CALL SUBOPT_0xE
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0x7C
; 0001 0A3F 		hc(4, 0); ws("6."); wn164(AD[6]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7
	__POINTW1MN _0x20265,26
	CALL SUBOPT_0xE
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x7C
; 0001 0A40 		hc(4, 43); ws("7."); wn164(AD[7]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7D
	__POINTW1MN _0x20265,29
	CALL SUBOPT_0xE
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL SUBOPT_0x7C
; 0001 0A41 
; 0001 0A42 		delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 0A43 	}
	RJMP _0x20266
_0x20268:
; 0001 0A44 
; 0001 0A45 }
	JMP  _0x20C000A

	.DSEG
_0x20265:
	.BYTE 0x20
;
;//========================================================
;void outlcd1()
; 0001 0A49 {

	.CSEG
_outlcd1:
; 0001 0A4A 	LcdClear();
	CALL SUBOPT_0x75
; 0001 0A4B 	hc(0, 5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x76
; 0001 0A4C 	ws("<SELF TEST>");
	__POINTW1MN _0x20269,0
	CALL SUBOPT_0xE
; 0001 0A4D 	hc(1, 0);
	CALL SUBOPT_0x56
; 0001 0A4E 	ws("************");
	__POINTW1MN _0x20269,12
	CALL SUBOPT_0xE
; 0001 0A4F }
	RET

	.DSEG
_0x20269:
	.BYTE 0x19
;//========================================================
;void chopledtheoid()
; 0001 0A52 {

	.CSEG
_chopledtheoid:
; 0001 0A53 	unsigned char i;
; 0001 0A54 	DDRA = 0xFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0A55 
; 0001 0A56 	switch (id)
	CALL SUBOPT_0x7E
; 0001 0A57 	{
; 0001 0A58 	case 1:
	BRNE _0x2026D
; 0001 0A59 		LEDR = 1;
	SBI  0x15,5
; 0001 0A5A 		LEDL = 1; PORTA.4 = 1; delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,4
	CALL SUBOPT_0x7B
; 0001 0A5B 		LEDL = 0; PORTA.4 = 0; delay_ms(30);
	CBI  0x15,4
	RJMP _0x20340
; 0001 0A5C 		break;
; 0001 0A5D 	case 2:
_0x2026D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20278
; 0001 0A5E 		LEDR = 1;
	SBI  0x15,5
; 0001 0A5F 		LEDL = 1; PORTA.6 = 1; delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,6
	CALL SUBOPT_0x7B
; 0001 0A60 		LEDL = 0; PORTA.6 = 0; delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,6
	RJMP _0x20341
; 0001 0A61 		break;
; 0001 0A62 	case 3:
_0x20278:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20283
; 0001 0A63 		LEDR = 1;
	SBI  0x15,5
; 0001 0A64 		LEDL = 1; PORTA.7 = 1; delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,7
	CALL SUBOPT_0x7B
; 0001 0A65 		LEDL = 0; PORTA.7 = 0; delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,7
	RJMP _0x20341
; 0001 0A66 		break;
; 0001 0A67 	case 4:
_0x20283:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2028E
; 0001 0A68 		LEDR = 1;
	SBI  0x15,5
; 0001 0A69 		LEDL = 1; PORTA.5 = 1; delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,5
	CALL SUBOPT_0x7B
; 0001 0A6A 		LEDL = 0; PORTA.5 = 0; delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,5
	RJMP _0x20341
; 0001 0A6B 		break;
; 0001 0A6C 	case 5:
_0x2028E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20299
; 0001 0A6D 		LEDL = 1;
	SBI  0x15,4
; 0001 0A6E 		LEDR = 1; PORTA.4 = 1; delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x7B
; 0001 0A6F 		LEDR = 0; PORTA.4 = 0; delay_ms(30);
	RJMP _0x20342
; 0001 0A70 		break;
; 0001 0A71 	case 6:
_0x20299:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202A4
; 0001 0A72 		LEDL = 1;
	SBI  0x15,4
; 0001 0A73 		LEDR = 1; PORTA.6 = 1; delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,6
	CALL SUBOPT_0x7B
; 0001 0A74 		LEDR = 0; PORTA.6 = 0; delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,6
	RJMP _0x20341
; 0001 0A75 		break;
; 0001 0A76 	case 7:
_0x202A4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202AF
; 0001 0A77 		LEDL = 1;
	SBI  0x15,4
; 0001 0A78 		LEDR = 1; PORTA.7 = 1; delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,7
	CALL SUBOPT_0x7B
; 0001 0A79 		LEDR = 0; PORTA.7 = 0; delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,7
	RJMP _0x20341
; 0001 0A7A 		break;
; 0001 0A7B 	case 8:
_0x202AF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202BA
; 0001 0A7C 		LEDL = 1;
	SBI  0x15,4
; 0001 0A7D 		LEDR = 1; PORTA.5 = 1; delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,5
	CALL SUBOPT_0x7B
; 0001 0A7E 		LEDR = 0; PORTA.5 = 0; delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,5
	RJMP _0x20341
; 0001 0A7F 		break;
; 0001 0A80 	case 9:
_0x202BA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2026C
; 0001 0A81 		LEDL = 1; LEDR = 1; PORTA.4 = 1; delay_ms(10);
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x7B
; 0001 0A82 		LEDL = 0; LEDR = 0; PORTA.4 = 0; delay_ms(30);
	CBI  0x15,4
_0x20342:
	CBI  0x15,5
_0x20340:
	CBI  0x1B,4
_0x20341:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x7F
; 0001 0A83 		break;
; 0001 0A84 	};
_0x2026C:
; 0001 0A85 	//LEDL=1;delay_ms(100);
; 0001 0A86 	//LEDL=0;delay_ms(100);
; 0001 0A87 	//for(i=0;i<id;i++)
; 0001 0A88 	//{
; 0001 0A89 	//    LEDR=1;delay_ms(150);
; 0001 0A8A 	//    LEDR=0;delay_ms(150);
; 0001 0A8B 	//}
; 0001 0A8C }
	LD   R17,Y+
	RET
;//========================================================
;//========================================================
;void testRCservo()
; 0001 0A90 {
_testRCservo:
; 0001 0A91 	clear();
	CALL _clear
; 0001 0A92 	hc(0, 10);
	CALL SUBOPT_0x52
	CALL SUBOPT_0x55
; 0001 0A93 	ws("RC SERVO");
	__POINTW1MN _0x202D2,0
	CALL SUBOPT_0xE
; 0001 0A94 	// Timer/Counter 0 initialization
; 0001 0A95 	// Clock source: System Clock
; 0001 0A96 	// Clock value: 7.813 kHz
; 0001 0A97 	// Mode: Phase correct PWM top=0xFF
; 0001 0A98 	// OC0 output: Non-Inverted PWM
; 0001 0A99 	TCCR0 = 0x65;     //15.32Hz
	LDI  R30,LOW(101)
	CALL SUBOPT_0x80
; 0001 0A9A 	TCNT0 = 0x00;
; 0001 0A9B 	OCR0 = 0x00;
; 0001 0A9C 
; 0001 0A9D 	// Timer/Counter 2 initialization
; 0001 0A9E 	// Clock source: System Clock
; 0001 0A9F 	// Clock value: 7.813 kHz
; 0001 0AA0 	// Mode: Phase correct PWM top=0xFF
; 0001 0AA1 	// OC2 output: Non-Inverted PWM
; 0001 0AA2 	ASSR = 0x00;      //15.32Hz
; 0001 0AA3 	TCCR2 = 0x67;
	LDI  R30,LOW(103)
	OUT  0x25,R30
; 0001 0AA4 	TCNT2 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 0AA5 	OCR2 = 0x00;
	OUT  0x23,R30
; 0001 0AA6 
; 0001 0AA7 	while (keyKT != 0)
_0x202D3:
	SBIS 0x13,0
	RJMP _0x202D5
; 0001 0AA8 	{
; 0001 0AA9 		LEDL = 1; LEDR = 1;//PORTB.3=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0AAA 		OCR0 = 2; OCR2 = 2;
	LDI  R30,LOW(2)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 0AAB 		delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x7F
; 0001 0AAC 
; 0001 0AAD 		LEDL = 0; LEDR = 0;//PORTB.3=1;
	CBI  0x15,4
	CBI  0x15,5
; 0001 0AAE 		OCR0 = 10; OCR2 = 10;
	LDI  R30,LOW(10)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 0AAF 		delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x7F
; 0001 0AB0 	}
	RJMP _0x202D3
_0x202D5:
; 0001 0AB1 	// Timer/Counter 0 initialization
; 0001 0AB2 	// Clock source: System Clock
; 0001 0AB3 	// Clock value: Timer 0 Stopped
; 0001 0AB4 	// Mode: Normal top=0xFF
; 0001 0AB5 	// OC0 output: Disconnected
; 0001 0AB6 	TCCR0 = 0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x80
; 0001 0AB7 	TCNT0 = 0x00;
; 0001 0AB8 	OCR0 = 0x00;
; 0001 0AB9 
; 0001 0ABA 	// Timer/Counter 2 initialization
; 0001 0ABB 	// Clock source: System Clock
; 0001 0ABC 	// Clock value: Timer2 Stopped
; 0001 0ABD 	// Mode: Normal top=0xFF
; 0001 0ABE 	// OC2 output: Disconnected
; 0001 0ABF 	ASSR = 0x00;
; 0001 0AC0 	TCCR2 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0001 0AC1 	TCNT2 = 0x00;
	OUT  0x24,R30
; 0001 0AC2 	OCR2 = 0x00;
	OUT  0x23,R30
; 0001 0AC3 
; 0001 0AC4 }
	RET

	.DSEG
_0x202D2:
	.BYTE 0x9
;
;void selftest()
; 0001 0AC7 {

	.CSEG
_selftest:
; 0001 0AC8 	outlcd1();
	CALL SUBOPT_0x81
; 0001 0AC9 	hc(2, 0);
; 0001 0ACA 	ws("1.ROBOT WALL"); delay_ms(200);
	__POINTW1MN _0x202DE,0
	CALL SUBOPT_0xE
	CALL SUBOPT_0x53
; 0001 0ACB 	while (flagselftest == 1)
_0x202DF:
	LDS  R26,_flagselftest
	LDS  R27,_flagselftest+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x202E1
; 0001 0ACC 	{
; 0001 0ACD 		//------------------------------------------------------------------------
; 0001 0ACE 		//test menu kiem tra  robot
; 0001 0ACF 		chopledtheoid();
	RCALL _chopledtheoid
; 0001 0AD0 		if (keyKT == 0)
	SBIC 0x13,0
	RJMP _0x202E2
; 0001 0AD1 		{
; 0001 0AD2 			id++;
	LDS  R30,_id
	SUBI R30,-LOW(1)
	STS  _id,R30
; 0001 0AD3 			if (id > 11){ id = 1; }
	LDS  R26,_id
	CPI  R26,LOW(0xC)
	BRLO _0x202E3
	LDI  R30,LOW(1)
	STS  _id,R30
; 0001 0AD4 			switch (id)
_0x202E3:
	CALL SUBOPT_0x7E
; 0001 0AD5 			{
; 0001 0AD6 
; 0001 0AD7 			case 1:
	BRNE _0x202E7
; 0001 0AD8 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AD9 				hc(2, 0);
; 0001 0ADA 				ws("1.ROBOT WALL"); delay_ms(200);
	__POINTW1MN _0x202DE,13
	RJMP _0x20343
; 0001 0ADB 				break;
; 0001 0ADC 			case 2:
_0x202E7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202E8
; 0001 0ADD 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0ADE 				hc(2, 0);
; 0001 0ADF 				ws("2.BLUETOOTH "); delay_ms(200);
	__POINTW1MN _0x202DE,26
	RJMP _0x20343
; 0001 0AE0 				break;
; 0001 0AE1 			case 3:
_0x202E8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202E9
; 0001 0AE2 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AE3 				hc(2, 0);
; 0001 0AE4 				ws("3.WHITE LINE"); delay_ms(200);
	__POINTW1MN _0x202DE,39
	RJMP _0x20343
; 0001 0AE5 				break;
; 0001 0AE6 			case 4:
_0x202E9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202EA
; 0001 0AE7 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AE8 				hc(2, 0);
; 0001 0AE9 				ws("4.BLACK LINE"); delay_ms(200);
	__POINTW1MN _0x202DE,52
	RJMP _0x20343
; 0001 0AEA 				break;
; 0001 0AEB 			case 5:
_0x202EA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202EB
; 0001 0AEC 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AED 				hc(2, 0);
; 0001 0AEE 				ws("5.TEST MOTOR"); delay_ms(200);
	__POINTW1MN _0x202DE,65
	RJMP _0x20343
; 0001 0AEF 				break;
; 0001 0AF0 			case 6:
_0x202EB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202EC
; 0001 0AF1 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AF2 				hc(2, 0);
; 0001 0AF3 				ws("6.TEST IR   "); delay_ms(200);
	__POINTW1MN _0x202DE,78
	RJMP _0x20343
; 0001 0AF4 				break;
; 0001 0AF5 			case 7:
_0x202EC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202ED
; 0001 0AF6 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AF7 				hc(2, 0);
; 0001 0AF8 				ws("7.TEST RF   "); delay_ms(200);
	__POINTW1MN _0x202DE,91
	RJMP _0x20343
; 0001 0AF9 				break;
; 0001 0AFA 			case 8:
_0x202ED:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202EE
; 0001 0AFB 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0AFC 				hc(2, 0);
; 0001 0AFD 				ws("8.TEST UART "); delay_ms(200);
	__POINTW1MN _0x202DE,104
	RJMP _0x20343
; 0001 0AFE 				break;
; 0001 0AFF 			case 9:
_0x202EE:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202EF
; 0001 0B00 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0B01 				hc(2, 0);
; 0001 0B02 				ws("9.RC SERVO "); delay_ms(200);
	__POINTW1MN _0x202DE,117
	RJMP _0x20343
; 0001 0B03 				break;
; 0001 0B04 			case 10:
_0x202EF:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202E6
; 0001 0B05 				outlcd1();
	CALL SUBOPT_0x81
; 0001 0B06 				hc(2, 0);
; 0001 0B07 				ws("10.UPDATE RB"); delay_ms(200);
	__POINTW1MN _0x202DE,129
_0x20343:
	ST   -Y,R31
	ST   -Y,R30
	CALL _ws
	CALL SUBOPT_0x53
; 0001 0B08 				break;
; 0001 0B09 			};
_0x202E6:
; 0001 0B0A 		}
; 0001 0B0B 		if (keyKP == 0)
_0x202E2:
	SBIC 0x13,1
	RJMP _0x202F1
; 0001 0B0C 		{
; 0001 0B0D 			switch (id)
	CALL SUBOPT_0x7E
; 0001 0B0E 			{
; 0001 0B0F 			case 1:
	BRNE _0x202F5
; 0001 0B10 				robotwall();
	RCALL _robotwall
; 0001 0B11 				break;
	RJMP _0x202F4
; 0001 0B12 			case 2:
_0x202F5:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202F6
; 0001 0B13 				bluetooth();
	RCALL _bluetooth
; 0001 0B14 				break;
	RJMP _0x202F4
; 0001 0B15 			case 3:
_0x202F6:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202F7
; 0001 0B16 				robotwhiteline();
	RCALL _robotwhiteline
; 0001 0B17 				break;
	RJMP _0x202F4
; 0001 0B18 			case 4:
_0x202F7:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202F8
; 0001 0B19 				robotblackline();
	RCALL _robotblackline
; 0001 0B1A 				break;
	RJMP _0x202F4
; 0001 0B1B 			case 5:
_0x202F8:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202F9
; 0001 0B1C 				testmotor();
	RCALL _testmotor
; 0001 0B1D 				break;
	RJMP _0x202F4
; 0001 0B1E 			case 6:
_0x202F9:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202FA
; 0001 0B1F 				testir();
	RCALL _testir
; 0001 0B20 				break;
	RJMP _0x202F4
; 0001 0B21 			case 7:
_0x202FA:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202FB
; 0001 0B22 				testrf();
	RCALL _testrf
; 0001 0B23 				break;
	RJMP _0x202F4
; 0001 0B24 			case 8:
_0x202FB:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202FC
; 0001 0B25 				testuart();
	RCALL _testuart
; 0001 0B26 				break;
	RJMP _0x202F4
; 0001 0B27 			case 9:
_0x202FC:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202FD
; 0001 0B28 				testRCservo();
	RCALL _testRCservo
; 0001 0B29 				break;
	RJMP _0x202F4
; 0001 0B2A 			case 10:
_0x202FD:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202F4
; 0001 0B2B 				testposition();
	RCALL _testposition
; 0001 0B2C 				break;
; 0001 0B2D 
; 0001 0B2E 			};
_0x202F4:
; 0001 0B2F 
; 0001 0B30 		}
; 0001 0B31 
; 0001 0B32 
; 0001 0B33 	}//end while(1)
_0x202F1:
	RJMP _0x202DF
_0x202E1:
; 0001 0B34 }
	RET

	.DSEG
_0x202DE:
	.BYTE 0x8E
;//[NGUYEN]Set bit and clear bit
;#define setBit(p,n) ((p) |= (1 << (n)))
;#define clrBit(p,n) ((p) &= (~(1) << (n)))
;
;//[NGUYEN] Update position. 64ms/frame
;//call setUpdateRate() in MAIN to init.
;char timer2Count = 0;
;char posUpdateFlag = 0;
;#define distThresh 100
;
;IntBall oldPos;
;void initPos()
; 0001 0B41 {

	.CSEG
_initPos:
; 0001 0B42 	oldPos.x = rbctrlHomeX;
	LDS  R30,_rbctrlHomeX
	LDS  R31,_rbctrlHomeX+1
	LDS  R22,_rbctrlHomeX+2
	LDS  R23,_rbctrlHomeX+3
	LDI  R26,LOW(_oldPos)
	LDI  R27,HIGH(_oldPos)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0001 0B43 	oldPos.y = rbctrlHomeY;
	__POINTW2MN _oldPos,2
	LDS  R30,_rbctrlHomeY
	LDS  R31,_rbctrlHomeY+1
	LDS  R22,_rbctrlHomeY+2
	LDS  R23,_rbctrlHomeY+3
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0001 0B44 }
	RET
;
;IntBall estimatePos(IntBall curPos)
; 0001 0B47 {
_estimatePos:
; 0001 0B48 	return curPos;
	SBIW R28,4
;	curPos -> Y+4
	MOVW R30,R28
	ADIW R30,4
	MOVW R26,R28
	LDI  R24,4
	CALL __COPYMML
	MOVW R30,R28
	LDI  R24,4
	IN   R1,SREG
	CLI
	ADIW R28,8
	RET
; 0001 0B49 }
;
;void updatePosInit()
; 0001 0B4C {
_updatePosInit:
; 0001 0B4D 	// Timer/Counter 2 initialization
; 0001 0B4E 	// Clock source: System Clock
; 0001 0B4F 	// Clock value: 7.813 kHz
; 0001 0B50 	// Mode: CTC top=OCR2
; 0001 0B51 	// OC2 output: Disconnected
; 0001 0B52 	ASSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0001 0B53 	TCCR2 = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x25,R30
; 0001 0B54 	TCNT2 = 0x12;
	LDI  R30,LOW(18)
	OUT  0x24,R30
; 0001 0B55 	OCR2 = 254;
	LDI  R30,LOW(254)
	OUT  0x23,R30
; 0001 0B56 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0B57 	setBit(TIMSK, OCIE2);
	IN   R30,0x39
	ORI  R30,0x80
	OUT  0x39,R30
; 0001 0B58 }
	RET
;//[NGUYEN]
;
;interrupt[TIM2_COMP] void timer2_comp_isr(void)
; 0001 0B5C {
_timer2_comp_isr:
	CALL SUBOPT_0x3B
; 0001 0B5D 	unsigned char i = 0;
; 0001 0B5E 	LEDRtoggle();
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	CALL _LEDRtoggle
; 0001 0B5F 	if (timer2Count++ < 2)
	LDS  R26,_timer2Count
	SUBI R26,-LOW(1)
	STS  _timer2Count,R26
	SUBI R26,LOW(1)
	CPI  R26,LOW(0x2)
	BRSH _0x202FF
; 0001 0B60 		return;
	RJMP _0x20345
; 0001 0B61 	else
_0x202FF:
; 0001 0B62 	{
; 0001 0B63 		timer2Count = 0;
	LDI  R30,LOW(0)
	STS  _timer2Count,R30
; 0001 0B64 	}
; 0001 0B65 
; 0001 0B66 
; 0001 0B67 	if (nRF24L01_RxPacket(RxBuf) == 1)         // Neu nhan duoc du lieu
	LDI  R30,LOW(_RxBuf)
	LDI  R31,HIGH(_RxBuf)
	ST   -Y,R31
	ST   -Y,R30
	CALL _nRF24L01_RxPacket
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x20301
; 0001 0B68 	{
; 0001 0B69 		IntRobot intRb;
; 0001 0B6A 		for (i = 0; i < 28; i++)
	SBIW R28,14
;	intRb -> Y+0
	LDI  R17,LOW(0)
_0x20303:
	CPI  R17,28
	BRSH _0x20304
; 0001 0B6B 		{
; 0001 0B6C 			*(uint8_t *)((uint8_t *)&rb + i) = RxBuf[i];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_rb)
	SBCI R27,HIGH(-_rb)
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_RxBuf)
	SBCI R31,HIGH(-_RxBuf)
	LD   R30,Z
	ST   X,R30
; 0001 0B6D 		}
	SUBI R17,-1
	RJMP _0x20303
_0x20304:
; 0001 0B6E 
; 0001 0B6F 
; 0001 0B70 		idRobot = fmod(rb.id, 10); // doc id
	CALL SUBOPT_0x82
	CALL __PUTPARD1
	CALL SUBOPT_0x83
	CALL __PUTPARD1
	CALL _fmod
	CALL __CFD1U
	MOVW R12,R30
; 0001 0B71 		cmdCtrlRobot = (int)rb.id / 10; // doc ma lenh
	CALL SUBOPT_0x84
; 0001 0B72 
; 0001 0B73 		intRb = convertRobot2IntRobot(rb);
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,28
	CALL __PUTPARL
	CALL _convertRobot2IntRobot
	MOVW R26,R28
	CALL __COPYMML
	OUT  SREG,R1
; 0001 0B74 
; 0001 0B75 		switch (idRobot)
	MOVW R30,R12
; 0001 0B76 		{
; 0001 0B77 		case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20308
; 0001 0B78 			robot11 = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot11)
	LDI  R27,HIGH(_robot11)
	RJMP _0x20344
; 0001 0B79 			break;
; 0001 0B7A 		case 2:
_0x20308:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20309
; 0001 0B7B 			robot12 = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot12)
	LDI  R27,HIGH(_robot12)
	RJMP _0x20344
; 0001 0B7C 			break;
; 0001 0B7D 		case 3:
_0x20309:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2030A
; 0001 0B7E 			robot13 = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot13)
	LDI  R27,HIGH(_robot13)
	RJMP _0x20344
; 0001 0B7F 			break;
; 0001 0B80 		case 4:
_0x2030A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2030B
; 0001 0B81 			robot21 = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot21)
	LDI  R27,HIGH(_robot21)
	RJMP _0x20344
; 0001 0B82 			break;
; 0001 0B83 		case 5:
_0x2030B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2030C
; 0001 0B84 			robot22 = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot22)
	LDI  R27,HIGH(_robot22)
	RJMP _0x20344
; 0001 0B85 			break;
; 0001 0B86 		case 6:
_0x2030C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20307
; 0001 0B87 			robot23 = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot23)
	LDI  R27,HIGH(_robot23)
_0x20344:
	LDI  R24,14
	CALL __COPYMML
; 0001 0B88 			break;
; 0001 0B89 
; 0001 0B8A 		}
_0x20307:
; 0001 0B8B 		if (idRobot == ROBOT_ID)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+3
	JMP _0x2030E
; 0001 0B8C 		{
; 0001 0B8D 			LEDL = !LEDL;
	SBIS 0x15,4
	RJMP _0x2030F
	CBI  0x15,4
	RJMP _0x20310
_0x2030F:
	SBI  0x15,4
_0x20310:
; 0001 0B8E 			cmdCtrlRobot = (int)rb.id / 10; // doc ma lenh
	CALL SUBOPT_0x84
; 0001 0B8F 			posUpdateFlag = 1;
	LDI  R30,LOW(1)
	STS  _posUpdateFlag,R30
; 0001 0B90 			robotctrl = intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robotctrl)
	LDI  R27,HIGH(_robotctrl)
	LDI  R24,14
	CALL __COPYMML
; 0001 0B91 			if ((robotctrl.x - oldPos.x >= distThresh) || (robotctrl.y - oldPos.y >= distThresh))
	__GETW2MN _robotctrl,2
	LDS  R30,_oldPos
	LDS  R31,_oldPos+1
	SUB  R26,R30
	SBC  R27,R31
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x20312
	__GETW2MN _robotctrl,4
	__GETW1MN _oldPos,2
	SUB  R26,R30
	SBC  R27,R31
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x20311
_0x20312:
; 0001 0B92 			{
; 0001 0B93 				IntBall estPos;
; 0001 0B94 				IntBall curPos;
; 0001 0B95 				curPos.x = robotctrl.x;
	SBIW R28,8
;	intRb -> Y+8
;	estPos -> Y+4
;	curPos -> Y+0
	CALL SUBOPT_0x1B
	ST   Y,R30
	STD  Y+1,R31
; 0001 0B96 				curPos.y = robotctrl.y;
	CALL SUBOPT_0x1D
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0B97 				estPos = estimatePos(curPos);
	MOVW R30,R28
	LDI  R26,4
	CALL __PUTPARL
	RCALL _estimatePos
	MOVW R26,R28
	ADIW R26,4
	CALL __COPYMML
	OUT  SREG,R1
; 0001 0B98 				robotctrl.x = estPos.x;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTW1MN _robotctrl,2
; 0001 0B99 				robotctrl.y = estPos.y;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1MN _robotctrl,4
; 0001 0B9A 
; 0001 0B9B 			}
	ADIW R28,8
; 0001 0B9C 			oldPos.x = robotctrl.x;
_0x20311:
	CALL SUBOPT_0x1B
	STS  _oldPos,R30
	STS  _oldPos+1,R31
; 0001 0B9D 			oldPos.y = robotctrl.y;
	CALL SUBOPT_0x1D
	__PUTW1MN _oldPos,2
; 0001 0B9E 		}
; 0001 0B9F 
; 0001 0BA0 	}
_0x2030E:
	ADIW R28,14
; 0001 0BA1 }
_0x20301:
_0x20345:
	LD   R17,Y+
	CALL SUBOPT_0x45
	RETI
;unsigned char readposition()
; 0001 0BA3 {
_readposition:
; 0001 0BA4 	return;
	LDI  R30,LOW(0)
	RET
; 0001 0BA5 }
;
;//========================================================
;//          HAM MAIN
;//========================================================
;void main(void)
; 0001 0BAB {
_main:
; 0001 0BAC 	// For Testing purpose only, creating a fake robot
; 0001 0BAD 	IntRobot rbFake;
; 0001 0BAE 	unsigned char flagreadrb;
; 0001 0BAF 	unsigned int adctest;
; 0001 0BB0 	unsigned char i;
; 0001 0BB1 	float PIdl, PIdr, pl, il, pr, ir, ur, ul;
; 0001 0BB2 
; 0001 0BB3 	// Testing robot declaration
; 0001 0BB4 	rbFake.id = 4;
	SBIW R28,46
;	rbFake -> Y+32
;	flagreadrb -> R17
;	adctest -> R18,R19
;	i -> R16
;	PIdl -> Y+28
;	PIdr -> Y+24
;	pl -> Y+20
;	il -> Y+16
;	pr -> Y+12
;	ir -> Y+8
;	ur -> Y+4
;	ul -> Y+0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+32,R30
	STD  Y+32+1,R31
; 0001 0BB5 	rbFake.x = -42;
	LDI  R30,LOW(65494)
	LDI  R31,HIGH(65494)
	STD  Y+34,R30
	STD  Y+34+1,R31
; 0001 0BB6 	rbFake.y = 48;
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	STD  Y+36,R30
	STD  Y+36+1,R31
; 0001 0BB7 	rbFake.ox = -35;
	LDI  R30,LOW(65501)
	LDI  R31,HIGH(65501)
	STD  Y+38,R30
	STD  Y+38+1,R31
; 0001 0BB8 	rbFake.oy = -50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	STD  Y+40,R30
	STD  Y+40+1,R31
; 0001 0BB9 	rbFake.ball.x = 0;
	LDI  R30,LOW(0)
	STD  Y+42,R30
	STD  Y+42+1,R30
; 0001 0BBA 	rbFake.ball.y = 0;
	STD  Y+44,R30
	STD  Y+44+1,R30
; 0001 0BBB 
; 0001 0BBC 	//------------- khai  bao chuc nang in out cua cac port
; 0001 0BBD 	DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0BBE 	DDRB = 0b10111111;
	LDI  R30,LOW(191)
	OUT  0x17,R30
; 0001 0BBF 	DDRC = 0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0001 0BC0 	DDRD = 0b11110010;
	LDI  R30,LOW(242)
	OUT  0x11,R30
; 0001 0BC1 
; 0001 0BC2 	//------------- khai  bao chuc nang cua adc
; 0001 0BC3 	// ADC initialization
; 0001 0BC4 	// ADC Clock frequency: 1000.000 kHz
; 0001 0BC5 	// ADC Voltage Reference: AVCC pin
; 0001 0BC6 	ADMUX = ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0001 0BC7 	ADCSRA = 0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0001 0BC8 	//---------------------------------------------------------------------
; 0001 0BC9 	//------------- khai  bao chuc nang cua bo timer dung lam PWM cho 2 dong co
; 0001 0BCA 	// Timer/Counter 1 initialization
; 0001 0BCB 	// Clock source: System Clock
; 0001 0BCC 	// Clock value: 1000.000 kHz   //PWM 2KHz
; 0001 0BCD 	// Mode: Ph. correct PWM top=0x00FF
; 0001 0BCE 	// OC1A output: Non-Inv.
; 0001 0BCF 	// OC1B output: Non-Inv.
; 0001 0BD0 	// Noise Canceler: Off
; 0001 0BD1 	// Input Capture on Falling Edge
; 0001 0BD2 	// Timer1 Overflow Interrupt: On  // voi period =1/2khz= 0.5ms
; 0001 0BD3 	// Input Capture Interrupt: Off
; 0001 0BD4 	// Compare A Match Interrupt: Off
; 0001 0BD5 	// Compare B Match Interrupt: Off
; 0001 0BD6 	TCCR1A = 0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0001 0BD7 	TCCR1B = 0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0001 0BD8 	TCNT1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0001 0BD9 	TCNT1L = 0x00;
	OUT  0x2C,R30
; 0001 0BDA 	ICR1H = 0x00;
	OUT  0x27,R30
; 0001 0BDB 	ICR1L = 0x00;
	OUT  0x26,R30
; 0001 0BDC 	OCR1AH = 0x00;
	OUT  0x2B,R30
; 0001 0BDD 	OCR1AL = 0x00;
	OUT  0x2A,R30
; 0001 0BDE 	OCR1BH = 0x00;
	OUT  0x29,R30
; 0001 0BDF 	OCR1BL = 0x00;
	OUT  0x28,R30
; 0001 0BE0 	// Timer(s)/Counter(s) Interrupt(s) initialization  timer0
; 0001 0BE1 	TIMSK = 0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0001 0BE2 
; 0001 0BE3 	//OCR1A=0-255; MOTOR LEFT
; 0001 0BE4 	//OCR1B=0-255; MOTOR RIGHT
; 0001 0BE5 	for (i = 0; i < 1; i++)
	LDI  R16,LOW(0)
_0x20315:
	CPI  R16,1
	BRSH _0x20316
; 0001 0BE6 	{
; 0001 0BE7 		LEDL = 1; LEDR = 1;
	CALL SUBOPT_0x77
; 0001 0BE8 		delay_ms(100);
; 0001 0BE9 		LEDL = 0; LEDR = 0;
; 0001 0BEA 		delay_ms(100);
; 0001 0BEB 	}
	SUBI R16,-1
	RJMP _0x20315
_0x20316:
; 0001 0BEC 
; 0001 0BED 	//khai  bao su dung cua glcd
; 0001 0BEE 	SPIinit();
	CALL _SPIinit
; 0001 0BEF 	LCDinit();
	CALL _LCDinit
; 0001 0BF0 
; 0001 0BF1 	// khai  bao su dung rf dung de cap nhat gia tri vi tri cua robot
; 0001 0BF2 	init_NRF24L01();
	CALL _init_NRF24L01
; 0001 0BF3 	SetRX_Mode();  // chon kenh tan so phat, va dia chi phat trong file nRF14l01.c
	CALL _SetRX_Mode
; 0001 0BF4 	// khai bao su dung encoder
; 0001 0BF5 	initencoder(); //lay 2 canh len  xuong
	CALL _initencoder
; 0001 0BF6 	// khai bao su dung uart
; 0001 0BF7 	inituart();
	CALL _inituart
; 0001 0BF8 
; 0001 0BF9 	// Set interrupt timer 2
; 0001 0BFA 	updatePosInit();
	RCALL _updatePosInit
; 0001 0BFB 	// Set for oldPos variable
; 0001 0BFC 	initPos();
	RCALL _initPos
; 0001 0BFD 
; 0001 0BFE 	#asm("sei")
	sei
; 0001 0BFF 
; 0001 0C00 	//man hinh khoi dong robokit
; 0001 0C01 	hc(0, 10);
	CALL SUBOPT_0x52
	CALL SUBOPT_0x55
; 0001 0C02 	ws("<AKBOTKIT>");
	__POINTW1MN _0x2031F,0
	CALL SUBOPT_0xE
; 0001 0C03 	hc(1, 0);
	CALL SUBOPT_0x56
; 0001 0C04 	ws("************");
	__POINTW1MN _0x2031F,11
	CALL SUBOPT_0xE
; 0001 0C05 
; 0001 0C06 	//robotwhiteline();
; 0001 0C07 	//robotblackline();
; 0001 0C08 	//kiem tra neu nhan va giu nut trai se vao chuong trinh selftest (kiem tra hoat dong cua robot)
; 0001 0C09 	while (keyKT == 0)
_0x20320:
	SBIC 0x13,0
	RJMP _0x20322
; 0001 0C0A 	{
; 0001 0C0B 		cntselftest++;
	LDI  R26,LOW(_cntselftest)
	LDI  R27,HIGH(_cntselftest)
	CALL SUBOPT_0x3C
; 0001 0C0C 		if (cntselftest > 10)
	LDS  R26,_cntselftest
	LDS  R27,_cntselftest+1
	SBIW R26,11
	BRLO _0x20323
; 0001 0C0D 		{
; 0001 0C0E 			while (keyKT == 0);//CHO NHA NUT AN
_0x20324:
	SBIS 0x13,0
	RJMP _0x20324
; 0001 0C0F 			cntselftest = 0;
	LDI  R30,LOW(0)
	STS  _cntselftest,R30
	STS  _cntselftest+1,R30
; 0001 0C10 			flagselftest = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagselftest,R30
	STS  _flagselftest+1,R31
; 0001 0C11 			selftest();
	RCALL _selftest
; 0001 0C12 		}
; 0001 0C13 		delay_ms(100);
_0x20323:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x7F
; 0001 0C14 	}
	RJMP _0x20320
_0x20322:
; 0001 0C15 
; 0001 0C16 	// vao chuong trinh chinh sau khi bo qua phan selftest
; 0001 0C17 	hc(2, 0);
	CALL SUBOPT_0x7A
; 0001 0C18 	ws("MAIN PROGRAM");
	__POINTW1MN _0x2031F,24
	CALL SUBOPT_0xE
; 0001 0C19 	settoadoHomRB();
	CALL _settoadoHomRB
; 0001 0C1A 
; 0001 0C1B 
; 0001 0C1C 	//ctrRobottoi(1000, 22);
; 0001 0C1D 	//MoveToOrigin();
; 0001 0C1E 	// code you here
; 0001 0C1F 
; 0001 0C20 	while (1)
_0x20327:
; 0001 0C21 	{
; 0001 0C22 #ifdef !DEBUG_MODE
; 0001 0C23 		{
; 0001 0C24 			//LEDR=!LEDR;
; 0001 0C25 			//PHUC
; 0001 0C26 			////     //=========================================================   PHUC ID
; 0001 0C27 			//         chay theo banh co dinh huong tan cong
; 0001 0C28 			readposition();
; 0001 0C29 			calcvitri(0, 0);    // de xac dinh huong tan cong
; 0001 0C2A 
; 0001 0C2B 			//flagtancong=1;
; 0001 0C2C 			if (flagtancong == 1)
; 0001 0C2D 			{
; 0001 0C2E 				flagtask = 2;
; 0001 0C2F 				rb_wait(50);
; 0001 0C30 
; 0001 0C31 			}
; 0001 0C32 			else
; 0001 0C33 			{
; 0001 0C34 				if (offsetphongthu < 0)    offsetphongthu = -offsetphongthu;//lay do lon
; 0001 0C35 				if (robotctrl.ball.y <= 0)
; 0001 0C36 				{
; 0001 0C37 					setRobotX = robotctrl.ball.x;
; 0001 0C38 					setRobotY = robotctrl.ball.y + offsetphongthu;
; 0001 0C39 
; 0001 0C3A 					flagtask = 0;
; 0001 0C3B 					rb_wait(200);
; 0001 0C3C 
; 0001 0C3D 				}
; 0001 0C3E 				else
; 0001 0C3F 				{
; 0001 0C40 					setRobotX = robotctrl.ball.x;
; 0001 0C41 					setRobotY = robotctrl.ball.y - offsetphongthu;
; 0001 0C42 
; 0001 0C43 					flagtask = 0;
; 0001 0C44 					rb_wait(200);
; 0001 0C45 
; 0001 0C46 				}
; 0001 0C47 
; 0001 0C48 				setRobotX = robotctrl.ball.x + offsetphongthu;
; 0001 0C49 				setRobotY = robotctrl.ball.y;
; 0001 0C4A 				rb_wait(200);
; 0001 0C4B 				rb_goball();
; 0001 0C4C 				rb_wait(200);
; 0001 0C4D 			}
; 0001 0C4E 			ctrrobot();// can phai luon luon chay de dieu khien robot
; 0001 0C4F 		}
; 0001 0C50 #else
; 0001 0C51 		{
; 0001 0C52 			calcvitri(0, 0);
	CALL SUBOPT_0x85
	CALL SUBOPT_0x85
	CALL _calcvitri
; 0001 0C53 #ifdef DEBUG_EN
; 0001 0C54 			{
; 0001 0C55 			}
; 0001 0C56 #endif
; 0001 0C57 			MoveToOrigin();
	CALL _MoveToOrigin
; 0001 0C58 			//movePoint(robotctrl, 0, 0, 0, 'f');
; 0001 0C59 			//setSpeed(leftSpeed, rightSpeed);
; 0001 0C5A 
; 0001 0C5B 		}
; 0001 0C5C #endif
; 0001 0C5D 	} //end while(1)
	RJMP _0x20327
; 0001 0C5E }
_0x2032A:
	RJMP _0x2032A

	.DSEG
_0x2031F:
	.BYTE 0x25
;

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x3C
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x3C
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G102:
	CALL SUBOPT_0x3D
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2040000,0
	CALL SUBOPT_0x86
	RJMP _0x20C0009
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2040000,1
	CALL SUBOPT_0x86
	RJMP _0x20C0009
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x87
	RJMP _0x204001C
_0x204001E:
	CALL SUBOPT_0x72
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x87
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x88
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x87
_0x2040022:
	CALL SUBOPT_0x88
	BRLO _0x2040024
	CALL SUBOPT_0x89
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x88
	BRSH _0x2040028
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x28
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x87
_0x2040025:
	CALL SUBOPT_0x72
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x28
	CALL SUBOPT_0x88
	BRLO _0x2040029
	CALL SUBOPT_0x89
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x47
	CALL SUBOPT_0x6D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x8E
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x28
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x8E
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x91
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x204010E
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x204010E:
	ST   X,R30
	CALL SUBOPT_0x91
	CALL SUBOPT_0x91
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x91
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0009:
	CALL __LOADLOCR4
_0x20C000A:
	ADIW R28,16
	RET
__print_G102:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x3C
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x92
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x92
	RJMP _0x204010F
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
	CALL SUBOPT_0x93
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x95
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x96
	CALL __GETD1P
	CALL SUBOPT_0x97
	CALL SUBOPT_0x98
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	RJMP _0x204005E
_0x204005B:
	CALL SUBOPT_0x99
	CALL __ANEGF1
	CALL SUBOPT_0x97
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x204005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x95
	RJMP _0x2040060
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040060:
_0x204005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040062
	CALL SUBOPT_0x99
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2040063
_0x2040062:
	CALL SUBOPT_0x99
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G102
_0x2040063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x9A
	RJMP _0x2040064
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040066
	CALL SUBOPT_0x98
	CALL SUBOPT_0x9B
	CALL SUBOPT_0x9A
	RJMP _0x2040067
_0x2040066:
	CPI  R30,LOW(0x70)
	BRNE _0x2040069
	CALL SUBOPT_0x98
	CALL SUBOPT_0x9B
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006B
	CP   R20,R17
	BRLO _0x204006C
_0x204006B:
	RJMP _0x204006A
_0x204006C:
	MOV  R17,R20
_0x204006A:
_0x2040064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006D
_0x2040069:
	CPI  R30,LOW(0x64)
	BREQ _0x2040070
	CPI  R30,LOW(0x69)
	BRNE _0x2040071
_0x2040070:
	ORI  R16,LOW(4)
	RJMP _0x2040072
_0x2040071:
	CPI  R30,LOW(0x75)
	BRNE _0x2040073
_0x2040072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x25
	LDI  R17,LOW(10)
	RJMP _0x2040075
_0x2040074:
	__GETD1N 0x2710
	CALL SUBOPT_0x25
	LDI  R17,LOW(5)
	RJMP _0x2040075
_0x2040073:
	CPI  R30,LOW(0x58)
	BRNE _0x2040077
	ORI  R16,LOW(8)
	RJMP _0x2040078
_0x2040077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20400B6
_0x2040078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x25
	LDI  R17,LOW(8)
	RJMP _0x2040075
_0x204007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x25
	LDI  R17,LOW(4)
_0x2040075:
	CPI  R20,0
	BREQ _0x204007B
	ANDI R16,LOW(127)
	RJMP _0x204007C
_0x204007B:
	LDI  R20,LOW(1)
_0x204007C:
	SBRS R16,1
	RJMP _0x204007D
	CALL SUBOPT_0x98
	CALL SUBOPT_0x96
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040110
_0x204007D:
	SBRS R16,2
	RJMP _0x204007F
	CALL SUBOPT_0x98
	CALL SUBOPT_0x9B
	CALL __CWD1
	RJMP _0x2040110
_0x204007F:
	CALL SUBOPT_0x98
	CALL SUBOPT_0x9B
	CLR  R22
	CLR  R23
_0x2040110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040082
	CALL SUBOPT_0x99
	CALL __ANEGD1
	CALL SUBOPT_0x97
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040084
_0x2040083:
	ANDI R16,LOW(251)
_0x2040084:
_0x2040081:
	MOV  R19,R20
_0x204006D:
	SBRC R16,0
	RJMP _0x2040085
_0x2040086:
	CP   R17,R21
	BRSH _0x2040089
	CP   R19,R21
	BRLO _0x204008A
_0x2040089:
	RJMP _0x2040088
_0x204008A:
	SBRS R16,7
	RJMP _0x204008B
	SBRS R16,2
	RJMP _0x204008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008D
_0x204008C:
	LDI  R18,LOW(48)
_0x204008D:
	RJMP _0x204008E
_0x204008B:
	LDI  R18,LOW(32)
_0x204008E:
	CALL SUBOPT_0x92
	SUBI R21,LOW(1)
	RJMP _0x2040086
_0x2040088:
_0x2040085:
_0x204008F:
	CP   R17,R20
	BRSH _0x2040091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040092
	CALL SUBOPT_0x9C
	BREQ _0x2040093
	SUBI R21,LOW(1)
_0x2040093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x95
	CPI  R21,0
	BREQ _0x2040094
	SUBI R21,LOW(1)
_0x2040094:
	SUBI R20,LOW(1)
	RJMP _0x204008F
_0x2040091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040095
_0x2040096:
	CPI  R19,0
	BREQ _0x2040098
	SBRS R16,3
	RJMP _0x2040099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009A
_0x2040099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009A:
	CALL SUBOPT_0x92
	CPI  R21,0
	BREQ _0x204009B
	SUBI R21,LOW(1)
_0x204009B:
	SUBI R19,LOW(1)
	RJMP _0x2040096
_0x2040098:
	RJMP _0x204009C
_0x2040095:
_0x204009E:
	CALL SUBOPT_0x9D
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A0
	SBRS R16,3
	RJMP _0x20400A1
	SUBI R18,-LOW(55)
	RJMP _0x20400A2
_0x20400A1:
	SUBI R18,-LOW(87)
_0x20400A2:
	RJMP _0x20400A3
_0x20400A0:
	SUBI R18,-LOW(48)
_0x20400A3:
	SBRC R16,4
	RJMP _0x20400A5
	CPI  R18,49
	BRSH _0x20400A7
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6C
	BRNE _0x20400A6
_0x20400A7:
	RJMP _0x20400A9
_0x20400A6:
	CP   R20,R19
	BRSH _0x2040111
	CP   R21,R19
	BRLO _0x20400AC
	SBRS R16,0
	RJMP _0x20400AD
_0x20400AC:
	RJMP _0x20400AB
_0x20400AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400AE
_0x2040111:
	LDI  R18,LOW(48)
_0x20400A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400AF
	CALL SUBOPT_0x9C
	BREQ _0x20400B0
	SUBI R21,LOW(1)
_0x20400B0:
_0x20400AF:
_0x20400AE:
_0x20400A5:
	CALL SUBOPT_0x92
	CPI  R21,0
	BREQ _0x20400B1
	SUBI R21,LOW(1)
_0x20400B1:
_0x20400AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x9D
	CALL __MODD21U
	CALL SUBOPT_0x97
	LDD  R30,Y+20
	CALL SUBOPT_0x6F
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2C
	CALL __CPD10
	BREQ _0x204009F
	RJMP _0x204009E
_0x204009F:
_0x204009C:
	SBRS R16,0
	RJMP _0x20400B2
_0x20400B3:
	CPI  R21,0
	BREQ _0x20400B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x95
	RJMP _0x20400B3
_0x20400B5:
_0x20400B2:
_0x20400B6:
_0x2040054:
_0x204010F:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x9E
	SBIW R30,0
	BRNE _0x20400B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0008
_0x20400B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x9E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0008:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA0
    brne __floor1
__floor0:
	CALL SUBOPT_0x9F
	RJMP _0x20C0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0xA1
	RJMP _0x20C0006
_ceil:
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA0
    brne __ceil1
__ceil0:
	CALL SUBOPT_0x9F
	RJMP _0x20C0004
__ceil1:
    brts __ceil0
	CALL SUBOPT_0xA1
	CALL __ADDF12
	RJMP _0x20C0004
_fmod:
	SBIW R28,4
	CALL SUBOPT_0x47
	CALL __CPD10
	BRNE _0x2060005
	__GETD1N 0x0
	RJMP _0x20C0003
_0x2060005:
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x9F
	CALL __CPD10
	BRNE _0x2060006
	__GETD1N 0x0
	RJMP _0x20C0003
_0x2060006:
	CALL SUBOPT_0x31
	CALL __CPD02
	BRGE _0x2060007
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x8D
	RJMP _0x2060033
_0x2060007:
	CALL SUBOPT_0xA3
	RCALL _ceil
_0x2060033:
	CALL __PUTD1S0
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x90
	RJMP _0x20C0003
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x47
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x9F
	__GETD2N 0x40CBD065
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x8F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9F
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x31
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2060020
	CALL SUBOPT_0xA3
	RCALL _xatan
	RJMP _0x20C0004
_0x2060020:
	CALL SUBOPT_0x31
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060021
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA5
	RJMP _0x20C0005
_0x2060021:
	CALL SUBOPT_0x49
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA1
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xA5
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20C0004
_asin:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xA7
	BRLO _0x2060023
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xA8
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2060023
	RJMP _0x2060022
_0x2060023:
	CALL SUBOPT_0xA9
	RJMP _0x20C0007
_0x2060022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2060025
	CALL SUBOPT_0xAA
	CALL __ANEGF1
	__PUTD1S 5
	LDI  R17,LOW(1)
_0x2060025:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xA6
	CALL __MULF12
	CALL SUBOPT_0x48
	CALL SUBOPT_0x90
	CALL __PUTPARD1
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0xA6
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060026
	CALL SUBOPT_0xAA
	__GETD2S 1
	CALL SUBOPT_0xAB
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x90
	RJMP _0x2060035
_0x2060026:
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xAB
_0x2060035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2060028
	CALL SUBOPT_0xAC
	CALL __ANEGF1
	RJMP _0x20C0007
_0x2060028:
	CALL SUBOPT_0xAC
_0x20C0007:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_acos:
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA7
	BRLO _0x206002A
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA8
	BREQ PC+4
	BRCS PC+3
	JMP  _0x206002A
	RJMP _0x2060029
_0x206002A:
	CALL SUBOPT_0xA9
	RJMP _0x20C0004
_0x2060029:
	CALL SUBOPT_0xA3
	RCALL _asin
_0x20C0005:
	__GETD2N 0x3FC90FDB
	CALL __SWAPD12
_0x20C0006:
	CALL __SUBF12
_0x20C0004:
	ADIW R28,4
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x47
	CALL __CPD10
	BRNE _0x206002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x206002E
	CALL SUBOPT_0xA9
	RJMP _0x20C0003
_0x206002E:
	CALL SUBOPT_0x4A
	CALL __CPD02
	BRGE _0x206002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0003
_0x206002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0003
_0x206002D:
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x2E
	CALL __CPD02
	BRGE _0x2060030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2060031
	CALL SUBOPT_0xA3
	RCALL _yatan
	RJMP _0x20C0003
_0x2060031:
	CALL SUBOPT_0xAD
	CALL __ANEGF1
	RJMP _0x20C0003
_0x2060030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2060032
	CALL SUBOPT_0xAD
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x90
	RJMP _0x20C0003
_0x2060032:
	CALL SUBOPT_0xA3
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20C0003:
	ADIW R28,12
	RET

	.CSEG

	.CSEG
_ftoa:
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	RCALL SUBOPT_0xAE
	__POINTW1FN _0x20A0000,0
	RCALL SUBOPT_0x86
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0xAE
	__POINTW1FN _0x20A0000,1
	RCALL SUBOPT_0x86
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0xAF
	RCALL SUBOPT_0xB0
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	RCALL SUBOPT_0xB1
	RCALL SUBOPT_0x8C
	RCALL SUBOPT_0xB2
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0xB3
	CALL __ADDF12
	RCALL SUBOPT_0xAF
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0xB2
_0x20A0014:
	RCALL SUBOPT_0xB3
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0xB1
	RCALL SUBOPT_0x8A
	RCALL SUBOPT_0xB2
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0xAE
	__POINTW1FN _0x20A0000,5
	RCALL SUBOPT_0x86
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0xB0
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001C
	RCALL SUBOPT_0xB1
	RCALL SUBOPT_0x8C
	RCALL SUBOPT_0x8B
	RCALL SUBOPT_0x8D
	RCALL SUBOPT_0xB2
	RCALL SUBOPT_0xB3
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0xB0
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0xB1
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0xB4
	RCALL SUBOPT_0x90
	RCALL SUBOPT_0xAF
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0xB0
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0xB4
	RCALL SUBOPT_0x8A
	RCALL SUBOPT_0xAF
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0xB0
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0xB4
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0xAF
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
_TX_ADDRESS:
	.BYTE 0x5
_RX_ADDRESS:
	.BYTE 0x5
_debugMsgBuff:
	.BYTE 0x20
_rb:
	.BYTE 0x1C
_robot11:
	.BYTE 0xE
_robot12:
	.BYTE 0xE
_robot13:
	.BYTE 0xE
_robot21:
	.BYTE 0xE
_robot22:
	.BYTE 0xE
_robot23:
	.BYTE 0xE
_robotctrl:
	.BYTE 0xE
_errangle:
	.BYTE 0x4
_distance:
	.BYTE 0x4
_orientation:
	.BYTE 0x4
_RxBuf:
	.BYTE 0x20
_setRobotX:
	.BYTE 0x4
_setRobotY:
	.BYTE 0x4
_setRobotXmin:
	.BYTE 0x4
_setRobotXmax:
	.BYTE 0x4
_setRobotAngleX:
	.BYTE 0x4
_setRobotAngleY:
	.BYTE 0x4
_offestsanco:
	.BYTE 0x4
_rbctrlHomeX:
	.BYTE 0x4
_rbctrlHomeY:
	.BYTE 0x4
_rbctrlPenaltyX:
	.BYTE 0x4
_rbctrlPenaltyY:
	.BYTE 0x4
_rbctrlPenaltyAngle:
	.BYTE 0x4
_rbctrlHomeAngle:
	.BYTE 0x4
_cntsethomeRB:
	.BYTE 0x2
_cntstuckRB:
	.BYTE 0x2
_cntunlookRB:
	.BYTE 0x2
_flagsethome:
	.BYTE 0x2
_flagselftest:
	.BYTE 0x2
_cntselftest:
	.BYTE 0x2
_leftSpeed:
	.BYTE 0x2
_rightSpeed:
	.BYTE 0x2
_id:
	.BYTE 0x1
_IRFL:
	.BYTE 0x2
_IRFR:
	.BYTE 0x2
_IRLINE:
	.BYTE 0xA
_timerstick:
	.BYTE 0x2
_timerstickdis:
	.BYTE 0x2
_timerstickang:
	.BYTE 0x2
_timerstickctr:
	.BYTE 0x2
_vQEL:
	.BYTE 0x2
_vQER:
	.BYTE 0x2
_oldQEL:
	.BYTE 0x2
_oldQER:
	.BYTE 0x2
_svQEL:
	.BYTE 0x2
_svQER:
	.BYTE 0x2
_seRki_G001:
	.BYTE 0x2
_seLki_G001:
	.BYTE 0x2
_uL:
	.BYTE 0x2
_uR:
	.BYTE 0x2
_KpR:
	.BYTE 0x2
_KiR:
	.BYTE 0x2
_KpL:
	.BYTE 0x2
_KiL:
	.BYTE 0x2
_xrb_last:
	.BYTE 0x2
_yrb_last:
	.BYTE 0x2
_angle_last:
	.BYTE 0x4
_sd:
	.BYTE 0x2
_oldd:
	.BYTE 0x2
_flagwaitctrRobot:
	.BYTE 0x1
_sa:
	.BYTE 0x2
_olda:
	.BYTE 0x2
_flagwaitctrAngle:
	.BYTE 0x1
_flagtask:
	.BYTE 0x2
_flagtaskold:
	.BYTE 0x2
_flaghuongtrue:
	.BYTE 0x2
_verranglekisum:
	.BYTE 0x2
_QEL:
	.BYTE 0x2
_QER:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x8
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
_oldOrientation:
	.BYTE 0x4
_timer2Count:
	.BYTE 0x1
_posUpdateFlag:
	.BYTE 0x1
_oldPos:
	.BYTE 0x4
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SPI_Write_Buf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL _SPI_RW
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	CALL _LcdWrite
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _LcdWrite
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,32
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12U
	SUBI R30,LOW(-_ASCII*2)
	SBCI R31,HIGH(-_ASCII*2)
	ADD  R30,R16
	ADC  R31,R17
	LPM  R30,Z
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ws

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R30
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R30,Y
	LDI  R31,0
	STS  _svQEL,R30
	STS  _svQEL+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R30,_QER
	LDS  R31,_QER+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	__GETD1S 32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETD1S 36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	__GETD1S 40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__GETD1S 48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	__GETW1MN _robotctrl,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	CALL __CWD1
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	__GETW1MN _robotctrl,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETD2S 44
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD2S 40
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__GETD2S 36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__GETD2S 32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL __ADDF12
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__GETD2S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x18
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x19
	CALL __PUTPARD1
	JMP  _atan2

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	__PUTD1S 8
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	__GETD1S 12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	__GETD2N 0x43340000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDS  R30,_errangle
	LDS  R31,_errangle+1
	LDS  R22,_errangle+2
	LDS  R23,_errangle+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__GETD1N 0x3F000000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDS  R26,_orientation
	LDS  R27,_orientation+1
	LDS  R24,_orientation+2
	LDS  R25,_orientation+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:157 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	STS  _rbctrlPenaltyX,R30
	STS  _rbctrlPenaltyX+1,R30
	STS  _rbctrlPenaltyX+2,R30
	STS  _rbctrlPenaltyX+3,R30
	STS  _rbctrlPenaltyY,R30
	STS  _rbctrlPenaltyY+1,R30
	STS  _rbctrlPenaltyY+2,R30
	STS  _rbctrlPenaltyY+3,R30
	__GETD1N 0x43330000
	STS  _rbctrlPenaltyAngle,R30
	STS  _rbctrlPenaltyAngle+1,R31
	STS  _rbctrlPenaltyAngle+2,R22
	STS  _rbctrlPenaltyAngle+3,R23
	STS  _rbctrlHomeAngle,R30
	STS  _rbctrlHomeAngle+1,R31
	STS  _rbctrlHomeAngle+2,R22
	STS  _rbctrlHomeAngle+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x35:
	__GETD1N 0x4386D99A
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0x3FD9999A
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
	__GETD1N 0x42A00000
	STS  _setRobotXmin,R30
	STS  _setRobotXmin+1,R31
	STS  _setRobotXmin+2,R22
	STS  _setRobotXmin+3,R23
	__GETD1N 0x43820000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x36:
	__GETD1N 0x42840000
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0x429ECCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x37:
	__GETD1N 0xC3870000
	STS  _setRobotXmin,R30
	STS  _setRobotXmin+1,R31
	STS  _setRobotXmin+2,R22
	STS  _setRobotXmin+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x38:
	__GETD1N 0x43870000
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x39:
	STS  _rbctrlPenaltyAngle,R30
	STS  _rbctrlPenaltyAngle+1,R31
	STS  _rbctrlPenaltyAngle+2,R22
	STS  _rbctrlPenaltyAngle+3,R23
	__GETD1N 0x43330000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3A:
	__GETD1N 0x42586666
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0xC2C7CCCD
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3B:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	LDS  R30,_QEL
	LDS  R31,_QEL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDS  R26,_seRki_G001
	LDS  R27,_seRki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDS  R26,_seLki_G001
	LDS  R27,_seLki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x3E
	LDS  R26,_QER
	LDS  R27,_QER+1
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x45:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3D086595
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x47:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x48:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	CALL __GETD1S0
	RCALL SUBOPT_0x48
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4A:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(_debugMsgBuff)
	LDI  R31,HIGH(_debugMsgBuff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4D:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	ST   Y,R30
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _debug_out
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x50:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16s

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x52:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	OUT  0x1B,R30
	CALL _LcdClear
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x58:
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	CALL _LEDLtoggle
	JMP  _LEDRtoggle

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x5A:
	MOVW R30,R16
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5B:
	__GETW2MN _IRLINE,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x5C:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5D:
	CALL _readline
	__GETWRMN 20,21,0,_IRLINE
	LDI  R16,LOW(0)
	LDI  R17,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x5E:
	MOV  R30,R17
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5F:
	ADD  R26,R30
	ADC  R27,R31
	LD   R20,X+
	LD   R21,X
	MOV  R16,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x60:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	LDI  R30,LOW(20)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
	RJMP SUBOPT_0x65

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x69:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x6A:
	CALL _readline
	LDS  R30,_IRLINE
	LDS  R31,_IRLINE+1
	STD  Y+35,R30
	STD  Y+35+1,R31
	__GETWRN 20,21,0
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6B:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6C:
	__CPD2N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6D:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	CALL __DIVF21
	__GETD2S 16
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	RCALL SUBOPT_0x24
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x71:
	__PUTD1S 20
	LDI  R30,LOW(0)
	__CLRD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x74:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	CALL _LcdClear
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x76:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x77:
	SBI  0x15,4
	SBI  0x15,5
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x15,4
	CBI  0x15,5
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x78:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x79:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(100)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x7A:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7C:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn164

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	RJMP SUBOPT_0x76

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7E:
	LDS  R30,_id
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7F:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x80:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x81:
	CALL _outlcd1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x82:
	LDS  R30,_rb
	LDS  R31,_rb+1
	LDS  R22,_rb+2
	LDS  R23,_rb+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x83:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x84:
	RCALL SUBOPT_0x82
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x85:
	__GETD1N 0x0
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x87:
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x83
	CALL __MULF12
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x88:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x6D
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x89:
	RCALL SUBOPT_0x6D
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RCALL SUBOPT_0x28
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	RCALL SUBOPT_0x83
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8B:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8C:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x2E
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x90:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x91:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x92:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x93:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x94:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x95:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x96:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x97:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x98:
	RCALL SUBOPT_0x93
	RJMP SUBOPT_0x94

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x99:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9A:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9B:
	RCALL SUBOPT_0x96
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x9C:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	RCALL SUBOPT_0x2C
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x9F:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA0:
	CALL __PUTPARD1
	CALL _ftrunc
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA1:
	RCALL SUBOPT_0x9F
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA2:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x4A
	CALL __DIVF21
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA3:
	RCALL SUBOPT_0x9F
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA4:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA5:
	CALL __DIVF21
	CALL __PUTPARD1
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA6:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA7:
	__GETD1N 0xBF800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA8:
	__GETD1N 0x3F800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA9:
	__GETD1N 0x7F7FFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAA:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAB:
	CALL __DIVF21
	CALL __PUTPARD1
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAC:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAD:
	RCALL SUBOPT_0x9F
	CALL __ANEGF1
	CALL __PUTPARD1
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAE:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xAF:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB0:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB1:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB2:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB3:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB4:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

__CPD01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	CPC  R0,R22
	CPC  R0,R23
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
