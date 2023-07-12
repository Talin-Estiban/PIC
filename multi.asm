LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x05
start:	bcf STATUS, RP0    ;Bank memory 0 
		bcf STATUS, RP1
		movlw 0x05
		movwf 0x40			;X
		movlw 0x02
		movwf 0x41			;Y
		movlw 0x08 
		movwf 0x20			;counter
		clrf 0x43			;mulH
		movf 0x41,w
		movwf 0x42			;mulL
		goto test

test:	bcf STATUS,C
		btfss 0x42,0
		goto no
		goto yes

yes:	movf 0x40,w
  	  	addwf 0x43
    	goto no

no: 	rrf 0x43
		rrf 0x42
		decfsz 0x20
		goto test
		end
		