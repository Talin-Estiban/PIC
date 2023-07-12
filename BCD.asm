LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x05
start:	bcf STATUS, RP0		;bank 0
		bcf STATUS, RP1
		movlw 0xA0
		movwf 0x60	;the binary number we want to convert to decimal
		clrf 0x61	;first result register 
		clrf 0x62	;second result register
		clrf 0x63	;third resukt register
		clrf 0x51	; register for rotating 
		movlw 0x08
		movwf 0x50	;counter
		
BCD:	bcf STATUS,C
		clrf 0x51
		btfsc 0x60,7	;check if last bit in 60 is 1 
		bsf 0x51,0
		btfsc 0x61,3	;check if last bit in 61 is 1 
		bsf 0x51,1
		btfsc 0x62,3	;check if last bit in 62 is 1 
		bsf 0x51,2
		rlf 0x60		;rotate 60
		rlf 0x61		;rotate 61
		goto zero1
rotate1:btfsc 0x51,0
		bsf 0x61,0
		rlf 0x62		;rotate 62
		goto zero2
rotate2:btfsc 0x51,1
		bsf 0x62,0
		rlf 0x63		;rotate 63
		goto zero3
rotate3:btfsc 0x51,2
		bsf 0x63,0
		goto count	

no:		movlw 0x05
		subwf 0x61,W
		btfsc STATUS,C
		goto add1
return1:bcf STATUS,C
		movlw 0x05
		subwf 0x62,W
		btfsc STATUS,C
		goto add2
return2:bcf STATUS,C
		movlw 0x05
		subwf 0x63,W
		btfss STATUS,C
		goto BCD
		movlw 0x03
		addwf 0x63
		goto BCD

add1: 	movlw 0x03
		addwf 0x61
		goto return1

add2:	movlw 0x03
		addwf 0x62
		goto return2

zero1:	bcf 0x61,4
		bcf 0x61,5
		bcf 0x61,6
		bcf 0x61,7
		goto rotate1

zero2:	bcf 0x62,4
		bcf 0x62,5
		bcf 0x62,6
		bcf 0x62,7
		goto rotate2

zero3:	bcf 0x63,4
		bcf 0x63,5
		bcf 0x63,6
		bcf 0x63,7
		goto rotate3
		
count:	decfsz 0x50		;decrease counter
		goto no
		end