
_Display_RPM:

;DigitalTachometer.c,34 :: 		void Display_RPM(unsigned long num){
;DigitalTachometer.c,35 :: 		RPM[0] = num/10000 + 48;
	MOVF        _RPM+0, 0 
	MOVWF       FLOC__Display_RPM+0 
	MOVF        _RPM+1, 0 
	MOVWF       FLOC__Display_RPM+1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_Display_RPM_num+0, 0 
	MOVWF       R0 
	MOVF        FARG_Display_RPM_num+1, 0 
	MOVWF       R1 
	MOVF        FARG_Display_RPM_num+2, 0 
	MOVWF       R2 
	MOVF        FARG_Display_RPM_num+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__Display_RPM+0, FSR1L
	MOVFF       FLOC__Display_RPM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DigitalTachometer.c,36 :: 		RPM[1] = (num/1000)%10 + 48;
	MOVLW       1
	ADDWF       _RPM+0, 0 
	MOVWF       FLOC__Display_RPM+0 
	MOVLW       0
	ADDWFC      _RPM+1, 0 
	MOVWF       FLOC__Display_RPM+1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_Display_RPM_num+0, 0 
	MOVWF       R0 
	MOVF        FARG_Display_RPM_num+1, 0 
	MOVWF       R1 
	MOVF        FARG_Display_RPM_num+2, 0 
	MOVWF       R2 
	MOVF        FARG_Display_RPM_num+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__Display_RPM+0, FSR1L
	MOVFF       FLOC__Display_RPM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DigitalTachometer.c,37 :: 		RPM[2] = (num/100)%10 + 48;
	MOVLW       2
	ADDWF       _RPM+0, 0 
	MOVWF       FLOC__Display_RPM+0 
	MOVLW       0
	ADDWFC      _RPM+1, 0 
	MOVWF       FLOC__Display_RPM+1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_Display_RPM_num+0, 0 
	MOVWF       R0 
	MOVF        FARG_Display_RPM_num+1, 0 
	MOVWF       R1 
	MOVF        FARG_Display_RPM_num+2, 0 
	MOVWF       R2 
	MOVF        FARG_Display_RPM_num+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__Display_RPM+0, FSR1L
	MOVFF       FLOC__Display_RPM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DigitalTachometer.c,38 :: 		RPM[3] = (num/10)%10 + 48;
	MOVLW       3
	ADDWF       _RPM+0, 0 
	MOVWF       FLOC__Display_RPM+0 
	MOVLW       0
	ADDWFC      _RPM+1, 0 
	MOVWF       FLOC__Display_RPM+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_Display_RPM_num+0, 0 
	MOVWF       R0 
	MOVF        FARG_Display_RPM_num+1, 0 
	MOVWF       R1 
	MOVF        FARG_Display_RPM_num+2, 0 
	MOVWF       R2 
	MOVF        FARG_Display_RPM_num+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__Display_RPM+0, FSR1L
	MOVFF       FLOC__Display_RPM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DigitalTachometer.c,39 :: 		RPM[4] = num%10 + 48;
	MOVLW       4
	ADDWF       _RPM+0, 0 
	MOVWF       FLOC__Display_RPM+0 
	MOVLW       0
	ADDWFC      _RPM+1, 0 
	MOVWF       FLOC__Display_RPM+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_Display_RPM_num+0, 0 
	MOVWF       R0 
	MOVF        FARG_Display_RPM_num+1, 0 
	MOVWF       R1 
	MOVF        FARG_Display_RPM_num+2, 0 
	MOVWF       R2 
	MOVF        FARG_Display_RPM_num+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__Display_RPM+0, FSR1L
	MOVFF       FLOC__Display_RPM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;DigitalTachometer.c,40 :: 		Lcd_Out(2,4,RPM);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        _RPM+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        _RPM+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;DigitalTachometer.c,41 :: 		}
	RETURN      0
; end of _Display_RPM

_main:

;DigitalTachometer.c,43 :: 		void main() {
;DigitalTachometer.c,44 :: 		CMCON = 0x07;   // Disable comparators
	MOVLW       7
	MOVWF       CMCON+0 
;DigitalTachometer.c,45 :: 		ADCON1 = 0x0F;  // Disable Analog functions
	MOVLW       15
	MOVWF       ADCON1+0 
;DigitalTachometer.c,46 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;DigitalTachometer.c,47 :: 		TRISB = 0x00;
	CLRF        TRISB+0 
;DigitalTachometer.c,48 :: 		PORTA = 0x00;
	CLRF        PORTA+0 
;DigitalTachometer.c,49 :: 		TRISA = 0b00010000;
	MOVLW       16
	MOVWF       TRISA+0 
;DigitalTachometer.c,50 :: 		T0CON = 0b01101000; // TMR0 as 16-bit counter
	MOVLW       104
	MOVWF       T0CON+0 
;DigitalTachometer.c,51 :: 		Lcd_Init();        // Initialize LCD
	CALL        _Lcd_Init+0, 0
;DigitalTachometer.c,52 :: 		Lcd_Cmd(_LCD_CLEAR);             // CLEAR display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;DigitalTachometer.c,53 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);        // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;DigitalTachometer.c,54 :: 		Lcd_Out(1,4,message1);            // Write message1 in 1st row
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _message1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_message1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;DigitalTachometer.c,55 :: 		do {
L_main0:
;DigitalTachometer.c,57 :: 		T0CON.TMR0ON = 1;
	BSF         T0CON+0, 7 
;DigitalTachometer.c,58 :: 		TMR0L = 0;
	CLRF        TMR0L+0 
;DigitalTachometer.c,59 :: 		TMR0H = 0;
	CLRF        TMR0H+0 
;DigitalTachometer.c,60 :: 		IR_Tx = 1;
	BSF         RA3_bit+0, 3 
;DigitalTachometer.c,62 :: 		Delay_ms(1000); // Wait for 1 sec
	MOVLW       61
	MOVWF       R11, 0
	MOVLW       225
	MOVWF       R12, 0
	MOVLW       63
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
	NOP
;DigitalTachometer.c,63 :: 		IR_Tx = 0;
	BCF         RA3_bit+0, 3 
;DigitalTachometer.c,64 :: 		T0CON.TMR0ON = 0;    // Stop the timer
	BCF         T0CON+0, 7 
;DigitalTachometer.c,65 :: 		RPM_Value = (256*TMR0H + TMR0L)*60;
	MOVF        TMR0H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        TMR0L+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _RPM_Value+0 
	MOVF        R1, 0 
	MOVWF       _RPM_Value+1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _RPM_Value+2 
	MOVWF       _RPM_Value+3 
;DigitalTachometer.c,66 :: 		Display_RPM(RPM_Value);
	MOVF        _RPM_Value+0, 0 
	MOVWF       FARG_Display_RPM_num+0 
	MOVF        _RPM_Value+1, 0 
	MOVWF       FARG_Display_RPM_num+1 
	MOVF        _RPM_Value+2, 0 
	MOVWF       FARG_Display_RPM_num+2 
	MOVF        _RPM_Value+3, 0 
	MOVWF       FARG_Display_RPM_num+3 
	CALL        _Display_RPM+0, 0
;DigitalTachometer.c,67 :: 		} while(1);             // Infinite Loop
	GOTO        L_main0
;DigitalTachometer.c,68 :: 		}
	GOTO        $+0
; end of _main
