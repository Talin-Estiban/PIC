# code done by Talin Estiban + Binyamin Gluskin
LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org			0x00
reset:	goto		start

		org	0x10
start:	bcf	STATUS,RP0
		bcf	STATUS,RP1			;Bank0
		clrf PORTD				;clear any previous data
		clrf PORTE
		clrf PORTB
		clrf 0x27				;number of clicks
		clrf 0x21				;A
		clrf 0x30				;B
		clrf 0x40				;operation
		clrf 0x60				;result
		clrf 0x22				;placement register
		clrf 0x61				;first result register (bcd)
		clrf 0x62				;second result register (bcd)
		clrf 0x63				;third resukt register (bcd)
		clrf 0x51				; register for rotating for BCD
		clrf 0x71				;registers for printing each bit of the result
		clrf 0x72
		clrf 0x73
		clrf 0x74
		clrf 0x75
		clrf 0x76
		clrf 0x77
		clrf 0x78	
		bsf	STATUS,RP0			;Bank1
		bcf	INTCON,GIE			;No interrupt
		movlw 0x0F
		movwf TRISB
		bcf	OPTION_REG,0x7		;Enable PortB Pull-Up
		movlw 0x06			; configure all pins as digital
		movwf ADCON1
		clrf TRISD			;set ports D and E as outputs 
		clrf TRISE
		bcf	STATUS,RP0			;Bank0
		call init 	

scan:	
		bcf			PORTB,0x4			;scan Row 1
		bsf			PORTB,0x5
		bsf			PORTB,0x6
		bsf			PORTB,0x7
		btfss		PORTB,0
		goto		kb01
		btfss		PORTB,0x1
		goto		kb02
		btfss		PORTB,0x2
		goto		kb03
		btfss		PORTB,0x3
		goto		kb0a

		bsf			PORTB,0x4
		bcf			PORTB,0x5			;scan Row 2
		btfss		PORTB,0x3
		goto		kb0b
		goto		scan

kb01:	incf 0x27						;writing 1
		movlw 0x01
		movwf 0x29
		call mdel
		goto place

kb02:	incf 0x27						;writing 0
		clrw
		movwf 0x29
		call mdel
		goto place

kb03:	movlw 0x8A						;writing C
		movwf 0x22
		movlw 0x03
		movwf 0x28
		call mdel
		goto scan 

kb0a: 	movlw 0x80						;writing A
		movwf 0x22
		movlw 0x01
		movwf 0x28
		call mdel
		goto scan 

kb0b:	movlw 0x85						;writing B
		movwf 0x22
		movlw 0x02
		movwf 0x28
		call mdel
		goto scan 

;########### check type of operation ################
check:	bcf STATUS,Z
		movlw 0x02						; substraction
		subwf 0x40,W
		btfsc STATUS,Z
		goto sub
		movlw 0x04						; multiplication
		subwf 0x40,W
		btfsc STATUS,Z
		goto mul
		movlw 0x06						; devision
		subwf 0x40,W
		btfsc STATUS,Z
		goto div
		movlw 0x08						; power
		subwf 0x40,W
		btfsc STATUS,Z
		goto pow
		movlw 0x0A						; number of one in A
		subwf 0x40,W
		btfsc STATUS,Z
		goto ones
		movlw 0x0C						; number of zeros in B
		subwf 0x40,W
		btfsc STATUS,Z
		goto zeros
		movlw 0x0B						; number of ones pairs in B 
		subwf 0x40,W
		btfsc STATUS,Z
		goto pair
		goto err
;########### substraction #################
sub: 	movf 0x30,W
		subwf 0x21,W
		movwf 0x60
		goto result
;########### multiplication #################
mul: 	movlw 0x08
		movwf 0x32					;counter
		clrf 0x61					; mulH
		movf 0x30,W
		movwf 0x60					;mulL
test:	bcf STATUS,C
		btfss 0x60,0
		goto no

yes:	movf 0x21,W
  	  	addwf 0x61

no: 	rrf 0x61
		rrf 0x60
		decfsz 0x32
		goto test
		goto result
;########### division #################
div:	movlw 0x08
		movwf 0x32		;counter
		clrf  0x33		;division remainder

test1: 	bcf STATUS,C
		rlf 0x21
		rlf 0x33
		btfsc STATUS,C
		bsf 0x33,0
		nop
		movf 0x30,w
		subwf 0x33,w
		btfss STATUS,C
		goto no1

yes1: 	movf 0x30,w
		subwf 0x33
		bsf 0x21,0

no1: 	decfsz 0x32
		goto test1
		movf 0x33,W
		movwf 0x60
		goto result
;########### power #################
pow0:	movlw 0x01
		movwf 0x60
		goto result
pow1:	movf 0x21,W
		movwf 0x60
		goto result 
pow: 	bcf STATUS,Z
		clrw						; to the power 0 
		subwf 0x30,W
		btfsc STATUS,Z
		goto pow0
		movlw 0x01					; to the power 1 
		subwf 0x30,W
		btfsc STATUS,Z
		goto pow1
		
pow2:	movf 0x21,W
		movwf 0x60					;mulL
		decf 0x30
pow2.1:	movlw 0x08
		movwf 0x32					;counter
		clrf 0x61					; mulH

	
test2:	bcf STATUS,C
		btfss 0x60,0
		goto no2

yes2:	movf 0x21,W
  	  	addwf 0x61

no2: 	bcf STATUS,C
		rrf 0x61
		rrf 0x60
 		decfsz 0x32
		goto test2
		decfsz 0x30
		goto pow2.1
		goto result
;########### number of ones in A #################
ones:	clrf 0x60
		btfsc 0x21,0
		incf 0x60
		btfsc 0x21,1
		incf 0x60
		btfsc 0x21,2
		incf 0x60
		btfsc 0x21,3
		incf 0x60
		goto result 
;########### number of zeros in B #################
zeros:	clrf 0x60
		btfss 0x30,0
		incf 0x60
		btfss 0x30,1
		incf 0x60
		btfss 0x30,2
		incf 0x60
		btfss 0x30,3
		incf 0x60
		goto result
;########### number of ones pairs in B #################
pair:	clrf 0x60
pair01:	btfsc 0x30,0
		goto pair12
		btfss 0x30,1
		incf 0x60
pair12:	btfsc 0x30,1
		goto pair23
		btfss 0x30,2
		incf 0x60
pair23:	btfsc 0x30,2
		goto result
		btfss 0x30,3
		incf 0x60
		goto result 
;########### printing error message #################
err:	call clear
		movlw 0x80		; printing E
		movwf 0x20
		call inst
		movlw 0x45
		movwf 0x20 
		call chara 
		movlw 0x81		; printing R
		movwf 0x20
		call inst
		movlw 0x52
		movwf 0x20 
		call chara
		movlw 0x82		; printing R
		movwf 0x20
		call inst
		movlw 0x52
		movwf 0x20 
		call chara  
		movlw 0x83		; printing O
		movwf 0x20
		call inst
		movlw 0x4F
		movwf 0x20
		call chara 
		movlw 0x84		; printing R
		movwf 0x20
		call inst
		movlw 0x52
		movwf 0x20 
		call chara  
		
		call delay
		call clear
		goto start
;########### printing the result #################
result: btfsc 0x60,0
		bsf 0x71,0
		btfsc 0x60,1
		bsf 0x72,0
		btfsc 0x60,2
		bsf 0x73,0
		btfsc 0x60,3
		bsf 0x74,0
		btfsc 0x60,4
		bsf 0x75,0
		btfsc 0x60,5
		bsf 0x76,0
		btfsc 0x60,6
		bsf 0x77,0
		btfsc 0x60,7
		bsf 0x78,0

		movlw 0xC0		; printing plus sign
		movwf 0x20
		call inst
		movlw 0x2B
		movwf 0x20
		call chara  
		movlw 0xC8		; printing the first number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x71,W
		movwf 0x20 
		call chara 
		movlw 0xC7		; printing the second number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x72,W
		movwf 0x20 
		call chara 
		movlw 0xC6		; printing the third number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x73,W
		movwf 0x20 
		call chara 
		movlw 0xC5		; printing the forth number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x74,W
		movwf 0x20 
		call chara 
		movlw 0xC4		; printing the fifth number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x75,W
		movwf 0x20 
		call chara 
		movlw 0xC3		; printing the sixth number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x76,W
		movwf 0x20 
		call chara
		movlw 0xC2		; printing the seventh number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x77,W
		movwf 0x20 
		call chara 
		movlw 0xC1		; printing the eighth number 
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x78,W
		movwf 0x20 
		call chara 

		call delay 
		call clear
		goto start
;###########calling the lcdc and lcdd#################
inst:	call lcdc
		call mdel
		return
chara:	call lcdd
		call mdel
		return
clear:	movlw 0x01 		
		movwf 0x20
		call lcdc
		call mdel
		return
;###########placement of the number#################
place: 	bcf STATUS,Z
		movlw 0x01				; if the counter is 1 
		subwf 0x27,W
		btfsc STATUS,Z
		goto pl1
		movlw 0x02				; if the counter is 2
		subwf 0x27,W
		btfsc STATUS,Z
		goto pl2
		movlw 0x03				; if the counter is 3
		subwf 0x27,W
		btfsc STATUS,Z
		goto pl3
		movlw 0x04				; if the counter is 4
		subwf 0x27,W
		btfsc STATUS,Z
		goto pl4
		clrf 0x27
		goto scan 
		
pl1: 	bcf STATUS,Z
		movlw 0x01				;if the number entered is A
		subwf 0x28,W
		btfsc STATUS,Z
		goto A0
		movlw 0x02				;if the number entered is B
		subwf 0x28,W
		btfsc STATUS,Z
		goto B0
		movlw 0x03				;if the number entered is C
		subwf 0x28,W
		btfsc STATUS,Z
		goto C0
A0:		btfsc 0x29,0
		bsf 0x21,3
		goto write0
B0:		btfsc 0x29,0
		bsf 0x30,3
		goto write0
C0:		btfsc 0x29,0
		bsf 0x40,3
write0:	movf 0x22,W				;first num
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29,W
		movwf 0x20
		call chara
		call del_4.1
		goto scan 

pl2: 	bcf STATUS,Z
		movlw 0x01				;if the number entered is A
		subwf 0x28,W
		btfsc STATUS,Z
		goto A1
		movlw 0x02				;if the number entered is B
		subwf 0x28,W
		btfsc STATUS,Z
		goto B1
		movlw 0x03				;if the number entered is C
		subwf 0x28,W
		btfsc STATUS,Z
		goto C1
A1:		btfsc 0x29,0
		bsf 0x21,2
		goto write1
B1:		btfsc 0x29,0
		bsf 0x30,2
		goto write1
C1:		btfsc 0x29,0
		bsf 0x40,2
write1: movlw 0x01				;second num
		addwf 0x22,W				
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29,W
		movwf 0x20
		call chara
		call del_4.1
		goto scan 

pl3: 	bcf STATUS,Z
		movlw 0x01				;if the number entered is A
		subwf 0x28,W
		btfsc STATUS,Z
		goto A2
		movlw 0x02				;if the number entered is B
		subwf 0x28,W
		btfsc STATUS,Z
		goto B2
		movlw 0x03				;if the number entered is C
		subwf 0x28,W
		btfsc STATUS,Z
		goto C2
A2:		btfsc 0x29,0
		bsf 0x21,1
		goto write2
B2:		btfsc 0x29,0
		bsf 0x30,1
		goto write2
C2:		btfsc 0x29,0
		bsf 0x40,1
write2: movlw 0x02				;third num
		addwf 0x22,W
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29,W
		movwf 0x20
		call chara
		call del_4.1
		goto scan 

pl4: 	bcf STATUS,Z
		movlw 0x01				;if the number entered is A
		subwf 0x28,W
		btfsc STATUS,Z
		goto A3
		movlw 0x02				;if the number entered is B
		subwf 0x28,W
		btfsc STATUS,Z
		goto B3
		movlw 0x03				;if the number entered is C
		subwf 0x28,W
		btfsc STATUS,Z
		goto C3
A3:		btfsc 0x29,0
		bsf 0x21,0
		call write3
		call del_4.1
		goto scan
B3:		btfsc 0x29,0
		bsf 0x30,0
		call write3
		call del_4.1
		goto scan
C3:		btfsc 0x29,0
		bsf 0x40,0
		call write3
		call del_4.1
		goto check
write3:	movlw 0x03				;forth num
		addwf 0x22,W
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29,W
		movwf 0x20
		call chara
		clrf 0x27
		return
;###########initializing the LCD#################
init:	movlw 0x30 			; 0011 0000 --> function set
		movwf 0x20
		call lcdc
		call del_4.1		

		movlw 0x30 			; 0011 0000 --> function set
		movwf 0x20
		call lcdc
		call del_1

		movlw 0x30 			; 0011 0000 --> function set
		movwf 0x20
		call lcdc
		call mdel


		movlw 0x01 			; 0000 0001 --> clear display
		movwf 0x20
		call lcdc
		call mdel

		movlw 0x06 			; 0000 0110 --> entry mode: move the curser right every R/W
		movwf 0x20
		call lcdc
		call mdel

		movlw 0x0c 			; 0000 1100 --> display on/off: on and no cursor and no blink 
		movwf 0x20
		call lcdc
		call mdel

		movlw 0x38 			; 0011 1000 --> function set:8bit communication,two line, 5x11 points
		movwf 0x20
		call lcdc
		call mdel
		return 
;########### give instruction to lcd #################
lcdc: 	bcf STATUS,RP0		;back to bank 0
		clrf PORTE			;E=0, RS=0
		movf 0x20,W
		movwf PORTD			;entering data bits 
		movlw 0x01			;E=1, RS=0
		movwf PORTE
		call sdel	
		clrf PORTE			;E=0, RS=0	
		return	
;########### write data to lcd #################
lcdd:	bcf STATUS,RP0		;back to bank 0
		movlw 0x02			;E=0, RS=1
		movwf PORTE
		movf 0x20,W
		movwf PORTD
		movlw 0x03
		movwf PORTE			;E=1, RS=1
		call sdel
		movlw 0x02			;E=0, RS=1
		movwf PORTE
		return
;########### delay for 4.1 ms #################
del_4.1:movlw 0x64
		movwf 0x65
count2:	movlw 0x43
		movwf 0x31
count1: decfsz 0x31
		goto count1
		decfsz 0x65
		goto count2
		return 
;########### delay for 100 micros #################
del_1:  movlw 0xA5			;N=165 
		movwf 0x65
lulua:	decfsz 0x65
		goto lulua
		return
;###### large delay for intializing the LCD #########
mdel:	movlw 0x2f
		movwf 0x65
cont3:	movlw 0x19
		movwf 0x31
cont2:	movlw 0xfa
		movwf 0x32
cont1:	decfsz 0x32
		goto cont1
		decfsz 0x31
		goto cont2
		decfsz 0x65
		goto cont3
		return
;###### large delay for reinserting new variables #########
delay:	movlw 0xFF
		movwf 0x65
c3:		movlw 0xFF
		movwf 0x31
c2:		movlw 0xfa
		movwf 0x32
c1:		decfsz 0x32
		goto c1
		decfsz 0x31
		goto c2
		decfsz 0x65
		goto c3
		return
;###### small delay for sending data and inst #########
sdel:	movlw 0xFF			;N=255 
		movwf 0x65
loop:	decfsz 0x65
		goto loop
		return
end