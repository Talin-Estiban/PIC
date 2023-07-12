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
		clrf 		0x27
		bsf			STATUS,RP0			;Bank1
		bcf			INTCON,GIE			;No interrupt
		movlw		0x0F
		movwf		TRISB
		bcf			OPTION_REG,0x7		;Enable PortB Pull-Up
		movlw 0x06			; configure all pins as digital
		movwf ADCON1
		clrf TRISD			;set ports D and E as outputs 
		clrf TRISE
		bcf	STATUS,RP0			;Bank0
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


		bsf			PORTB,0x4
		bcf			PORTB,0x5			;scan Row 2
		btfss		PORTB,0x0
		goto		kb04
		btfss		PORTB,0x1
		goto		kb05
		btfss		PORTB,0x2
		goto		kb06


		bsf			PORTB,0x5
		bcf			PORTB,0x6			;scan Row 3
		btfss		PORTB,0x0
		goto		kb07
		btfss		PORTB,0x1
		goto		kb08
		btfss		PORTB,0x2
		goto		kb09

		bsf			PORTB,0x6
		bcf			PORTB,0x7		;scan Row 4
		btfss		PORTB,0x0
		goto		kb0e
		btfss		PORTB,0x1
		goto		kb00
		goto		scan

kb00:	incf 0x27					; inc counter
		clrf W
		movwf 0x29
		goto place

kb01:	incf 0x27
		movlw 0x01
		movwf 0x29
		goto place

kb02:	incf 0x27
		movlw 0x02
		movwf 0x29
		goto place

kb03:	incf 0x27
		movlw 0x03
		movwf 0x29
		goto place

kb04:	incf 0x27
		movlw 0x04
		movwf 0x29
		goto place

kb05:	incf 0x27
		movlw 0x05
		movwf 0x29
		goto place

kb06:	incf 0x27
		movlw 0x06
		movwf 0x29
		goto place

kb07:	incf 0x27
		movlw 0x07
		movwf 0x29
		goto place

kb08:	incf 0x27
		movlw 0x08
		movwf 0x29
		goto place

kb09:	incf 0x27
		movlw 0x09
		movwf 0x29
		goto place
;########### sum of the two numbers #################
kb0e:	call clear
		movf 0x23,W						; sum of first two digits
		addwf 0x26
		movlw 0x0A
		subwf 0x26,W
		btfsc STATUS,C
		call over1
		movlw 0x83
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x26
		movf 0x26,W
		movwf 0x20
		call chara

		movf 0x22,W						; sum of second two digits
		addwf 0x25
		movlw 0x0A
		subwf 0x25,W
		btfsc STATUS,C
		call over2
		movlw 0x82
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x25
		movf 0x25,W
		movwf 0x20
		call chara

		movf 0x21,W						; sum of third two digits
		addwf 0x24
		movlw 0x0A
		subwf 0x24,W
		btfsc STATUS,C
		call over3
		movlw 0x81
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x24
		movf 0x24,W
		movwf 0x20
		call chara
		
		movlw 0x80
		movwf 0x20
		call inst
		movf 0x30,W
		addwf 0x20
		clrf 0x30
		call chara
		call mdel
		;call clear
		;goto scan

over1:	bcf STATUS,C
		movlw 0x0A
		subwf 0x26
		incf 0x25
		return 
over2:	bcf STATUS,C
		movlw 0x0A
		subwf 0x25
		incf 0x24
		return
over3:	bcf STATUS,C
		movlw 0x0A
		subwf 0x24
		incf 0x30
		return

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
		movf 0x27,W
		movwf 0x28
		movlw 0x01				; if the counter is 1 
		subwf 0x28,W
		btfsc STATUS,Z
		goto pl1
		movlw 0x02				; if the counter is 2
		subwf 0x28,W
		btfsc STATUS,Z
		goto pl2
		movlw 0x03				; if the counter is 3
		subwf 0x28,W
		btfsc STATUS,Z
		goto pl3
		movlw 0x04				; if the counter is 4
		subwf 0x28,W
		btfsc STATUS,Z
		goto pl4
		movlw 0x05				; if the counter is 5
		subwf 0x28,W
		btfsc STATUS,Z
		goto pl5
		movlw 0x06				; if the counter is 6
		subwf 0x28,W
		btfsc STATUS,Z
		goto pl6
		goto kb0e

pl1: 	movf 0x29,W				;first num
		movwf 0x21
		movlw 0x80
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29
		movf 0x29,W
		movwf 0x20
		call chara
		goto scan 
pl2: 	movf 0x29,W				;second num
		movwf 0x22
		movlw 0x81
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29
		movf 0x29,W
		movwf 0x20
		call chara
		goto scan 
pl3: 	movf 0x29,W				;third num
		movwf 0x23
		movlw 0x82
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29
		movf 0x29,W
		movwf 0x20
		call chara
		goto scan 
pl4: 	movf 0x29,W				;forth num
		movwf 0x24
		movlw 0xC0
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29
		movf 0x29,W
		movwf 0x20
		call chara
		goto scan 
pl5: 	movf 0x29,W				;fifth num
		movwf 0x25
		movlw 0xC1
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29
		movf 0x29,W
		movwf 0x20
		call chara
		goto scan 
pl6: 	movf 0x29,W				;sixth num
		movwf 0x26
		movlw 0xC2
		movwf 0x20
		call inst
		movlw 0x30
		addwf 0x29
		movf 0x29,W
		movwf 0x20
		call chara
		goto scan
 
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
