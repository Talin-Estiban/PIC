	LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x05
start:	bcf STATUS, RP0
		bcf STATUS, RP1
		bcf STATUS,C
		movlw 0x02
		movwf 0x20 		;first number
		movlw 0x02
		movwf 0x21		;second number
		clrf 0x2A		;sub result
		movlw 0x08 
		movwf 0x22			;counter
		movlw 0x08 
		movwf 0x23			;number of bits
		clrf 0x2C			;mulH
		movf 0x21,w
		movwf 0x2B			;mulL
		clrf  0x2E		;M for division

sub:    movf 0x21,w
		subwf 0x20,w
		movwf 0x2A 		

multi:	bcf STATUS,C
		btfss 0x2B,0
		goto nomul
		goto yesmul

yesmul:	movf 0x20,w
  	  	addwf 0x2C

nomul: 	rrf 0x2C
		rrf 0x2B
		decfsz 0x22
		goto multi


div: 	bcf STATUS,C
		rlf 0x21
		rlf 0x2E
		btfsc STATUS,C
		bsf 0x2E,0
		nop
		movf 0x20,w
		subwf 0x2E,w
		btfss STATUS,C
		goto no
		goto yes

yes: 	movf 0x20,w
		subwf 0x2E
		bsf 0x21,0
		goto no

no: 	decfsz 0x23
		goto div
		movf 0x21,w
		movwf 0x2D
		end

		