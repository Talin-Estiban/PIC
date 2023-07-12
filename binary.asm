LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x10
start:	bcf STATUS, RP0		;bank 0
		bcf STATUS, RP1
		clrf PORTA
		clrf PORTD
		bsf STATUS,RP0		;bank 1
		movlw 0x06
		movwf ADCON1
		movlw 0x3F
		movwf TRISA
		clrf TRISD
		bcf STATUS,RP0

seven:  clrf 0x30		;PA2
		clrf 0x31		;PA3
	    bcf PORTD,7
		btfsc PORTA,2	;save PA2 inside 0x30 bit 0
		bsf 0x30,0
	    btfsc PORTA,2	;led7 
		bsf PORTD,7

six:    bcf PORTD,6
		btfsc PORTA,3	;save PA3 inside 0x31 bit 0
		bsf 0x31,0
	    btfsc PORTA,3	;led6
		bsf PORTD,6

five:   movf 0x31,W		;XOR
		xorwf 0x30,W
		btfsc W,0
		bsf PORTD,5

four:   movf 0x31,W		;AND
		andwf 0x30,W
		btfsc W,0
		bsf PORTD,4

three:  movf 0x31,W		;OR
		iorwf 0x30,W
		btfsc W,0
		bsf PORTD,3

two:    btfss PORTD,3	;NOR
		bsf PORTD,2

one:	btfss PORTD,4	;NAND
		bsf PORTD,1

zero:   btfss PORTD,5	;NXOR
		bsf PORTD,0
		goto seven
end
		
		