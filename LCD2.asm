		LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org			0x00
reset:	goto		start

		org			0x10
start:	bcf			STATUS,RP0
		bcf			STATUS,RP1			;Bank0
		clrf		PORTD				;clear any previous data
		clrf		PORTE
		bsf			STATUS,RP0			;Bank1
		bcf			INTCON,GIE			;No interrupt
		movlw		0x0F
		movwf		TRISB
		bcf			OPTION_REG,0x7		;Enable PortB Pull-Up
		movlw 0x06			; configure all pins as digital
		movwf ADCON1
		clrf TRISD			;set ports D and E as outputs 
		clrf TRISE
		bcf			STATUS,RP0			;Bank0
		call init 
	

scan:	bcf			PORTB,0x4			;scan Row 1
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
		bcf			PORTB,0x7		;scan Row 4
		btfss		PORTB,0x0
		goto		kb0e
		btfss		PORTB,0x1
		goto		kb00
		btfss		PORTB,0x2
		goto		kb0f
		btfss		PORTB,0x3
		goto		kb0d
		goto		scan

kb00:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x30
		movwf 0x20					; 0
		call chara
		call wait
kb01:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		goto inst
		movlw 0x31
		movwf 0x20					; 1
		call chara
		call wait
kb02:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x32
		movwf 0x20					; 2
		call chara
		goto wait
kb03:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x33
		movwf 0x20					; 3
		call chara
		call wait
kb04:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x34
		movwf 0x20					; 4
		call chara
		call wait
kb05:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x35
		movwf 0x20					; 5
		call chara
		call wait
kb06:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x36
		movwf 0x20					; 6
		call chara
		call wait
kb07:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x37
		movwf 0x20					; 7
		call chara
		call wait
kb08:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x38
		movwf 0x20					; 8
		call chara
		call wait
kb09:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x39
		movwf 0x20					; 9
		call chara
		call wait
kb0a:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x41
		movwf 0x20					; A
		call chara
		call wait
kb0b:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x42
		movwf 0x20					; B
		call chara
		call wait
kb0c:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x43
		movwf 0x20					; C
		call chara
		call wait
kb0d:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x44
		movwf 0x20					; D
		call chara
		call wait
kb0e:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x2A
		movwf 0x20					; *
		call chara
		call wait
kb0f:	movlw 0x82					;3 place on 1 line
		movwf 0x20
		call inst
		movlw 0x23
		movwf 0x20					; #
		call chara

wait:	movlw		0x0F			;wait till realese 
		movwf		PORTB
		subwf		PORTB, w
		btfss		STATUS, Z
		goto		wait
		call 		clear
		goto		scan
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
		movwf 0x30
count2:	movlw 0x43
		movwf 0x31
count1: decfsz 0x31
		goto count1
		decfsz 0x30
		goto count2
		return 
;########### delay for 100 micros #################
del_1:  movlw 0xA5			;N=165 
		movwf 0x30
lulua:	decfsz 0x30
		goto lulua
		return
;###### large delay for intializing the LCD #########
mdel:	movlw 0x0b
		movwf 0x30
cont3:	movlw 0x19
		movwf 0x31
cont2:	movlw 0xfa
		movwf 0x32
cont1:	decfsz 0x32
		goto cont1
		decfsz 0x31
		goto cont2
		decfsz 0x30
		goto cont3
		return
;###### small delay for sending data and inst #########
sdel:	movlw 0xFF			;N=255 
		movwf 0x30
loop:	decfsz 0x30
		goto loop
		return
end
