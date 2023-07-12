LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x05
start:	bcf STATUS, RP0    ;Bank memory 0 
		bcf STATUS, RP1
		movlw 0x08
		movwf 0x41 		;devider
		movlw 0x02
		movwf 0x40		;devided by
		movlw 0x08
		movwf 0x20		;Number of bits
		clrf  0x21		;M
		goto div

div: 	bcf STATUS,C
		rlf 0x41
		rlf 0x21
		btfsc STATUS,C
		bsf 0x21,0
		nop
		movf 0x40,w
		subwf 0x21,w
		btfss STATUS,C
		goto no
		goto yes

yes: 	movf 0x40,w
		subwf 0x21
		bsf 0x41,0
		goto no

no: 	decfsz 0x20
		goto div
		end




		
		
		
		