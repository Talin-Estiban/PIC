	LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x10
start:	bcf STATUS, RP0
		bcf STATUS, RP1
		clrf PORTA
		clrf PORTD
		bsf STATUS,RP0
		movlw 0x06
		movwf ADCON1
		movlw 0x3F
		movwf TRISA
		clrf TRISD
		bcf STATUS,RP0

check:  btfsc PORTA,5
		goto check

inc:    incf PORTD
		movlw 0x07
		movwf 0x30
loop:	decfsz 0x30
		goto loop
		goto check
end
		
		