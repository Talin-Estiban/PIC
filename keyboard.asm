		LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org			0x00
reset:	goto		start

		org			0x10
start:	bcf			STATUS,RP0
		bcf			STATUS,RP1			;Bank0
		clrf		PORTD
		bsf			STATUS,RP0			;Bank1
		bcf			INTCON,GIE			;No interrupt
		movlw		0x0F
		movwf		TRISB
		bcf			OPTION_REG,0x7		;Enable PortB Pull-Up
		clrf		TRISD
		bcf			STATUS,RP0			;Bank0
		clrf		PORTC
		bsf			STATUS,RP0
		clrf		TRISC
		bcf			STATUS,RP0

wkb:	movlw   	0x14                ;  N1=0x20 
	    movwf   	0x20
		clrf		0x21				; (delay) (N2)
		clrf		0x22				; (delay1)(N2)
		clrf		0x40
		clrf 		0x41
		
		bcf			PORTB,0x4			;scan Row 1
		bsf			PORTB,0x5
		bsf			PORTB,0x6
		bsf			PORTB,0x7
		btfss		PORTB,0x0
		goto		kb01
		btfss		PORTB,0x1
		goto		kb02
		btfss		PORTB,0x2
		goto		kb03
		btfss		PORTB,0x3
		goto		kb0a

		bsf			PORTB,0x4
		bcf			PORTB,0x5			;scan Row 2
		btfss		PORTB,0x0
		goto		kb04
		btfss		PORTB,0x1
		goto		kb05
		btfss		PORTB,0x2
		goto		kb06
		btfss		PORTB,0x3
		goto		kb0b

		bsf			PORTB,0x5
		bcf			PORTB,0x6			;scan Row 3
		btfss		PORTB,0x0
		goto		kb07
		btfss		PORTB,0x1
		goto		kb08
		btfss		PORTB,0x2
		goto		kb09
		btfss		PORTB,0x3
		goto		kb0c

		bsf			PORTB,0x6
		bcf			PORTB,0x7			;scan Row 4
		btfss		PORTB,0x0
		goto		kb0e
		btfss		PORTB,0x1
		goto		kb00
		btfss		PORTB,0x2
		goto		kb0f
		btfss		PORTB,0x3
		goto		kb0d

		goto		wkb

kb00:	movlw		0x00
		goto		disp
		
kb01:	movlw   	0x07               ;  N2=0x07 (delay = 0.1ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x49               ;  N2=0x73 (delay1 = 0.9ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x01
		goto		disp
	
kb02:	movlw   	0x0F               ;  N2=0x15 (delay = 0.2ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x41               ;  N2=0x65 (delay1 = 0.8ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x02
		goto		disp
		
kb03:	movlw   	0x18               ;  N2=0x24 (delay = 0.3ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x39               ;  N2=0x57 (delay1 = 0.7ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x03
		goto		disp
		
kb04:	movlw   	0x20               ;  N2=0x32 (delay = 0.4ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x31               ;  N2=0x49 (delay1 = 0.6ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x04
		goto		disp
		
kb05:	movlw   	0x28               ;  N2=0x40 (delay = 0.5ms)
	    movwf   	0x21
		movwf   	0x21
		movlw   	0x28               ;  N2=0x40 (delay1 = 0.5ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x05
		goto		disp
		
kb06:	movlw   	0x31               ;  N2=0x49 (delay = 0.6ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x20               ;  N2=0x32 (delay1 = 0.4ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x06
		goto		disp
		
kb07:	movlw   	0x3B               ;  N2=0x57 (delay = 0.7ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x18               ;  N2=0x24 (delay1 = 0.3ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x07
		goto		disp
		
kb08:	movlw   	0x41               ;  N2=0x65 (delay = 0.8ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x0F               ;  N2=0x15 (delay1 = 0.2ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x08
		goto		disp
		
kb09:	movlw   	0x49               ;  N2=0x73 (delay = 0.9ms)
	    movwf   	0x21
		movwf 		0x40
		movlw   	0x07               ;  N2=0x07 (delay1 = 0.1ms)
	    movwf   	0x22
		movwf 		0x41
		incf		PORTC,1
		call    	delay
	    decf    	PORTC,1
		call    	delay1
		movlw		0x09
		goto		disp
	
kb0a:	movlw		0x0A
		goto		disp
kb0b:	movlw		0x0B
		goto		disp
kb0c:	movlw		0x0C
		goto		disp
kb0d:	movlw		0x0D
		goto		disp
kb0e:	movlw		0x0E
		goto		disp
kb0f:	movlw		0x0F
		goto		disp
		
disp:	movwf		PORTD
		goto		wkb
;########################################################
delay:  movf		0x21,0			;N2
		movwf		0x40
	
cont1:  decfsz  	0x40
	    goto    	cont1
	    decfsz  	0x20
	    goto    	delay
	    return
		



delay1: movf   		0x22,0			;N2
		movwf		0x41					
   	
cont3:  decfsz  	0x41
	    goto    	cont3
	    decfsz  	0x20
	    goto    	delay1
	    return		
		end