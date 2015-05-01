#line 1 "C:/Documents and Settings/Administrator/Desktop/EmbeddedLab/MikroC/PIC18F2550/Digital Tachometer/DigitalTachometer.c"
#line 13 "C:/Documents and Settings/Administrator/Desktop/EmbeddedLab/MikroC/PIC18F2550/Digital Tachometer/DigitalTachometer.c"
 unsigned long RPM_Value;


 sbit LCD_RS at RC6_bit;
 sbit LCD_EN at RC7_bit;
 sbit LCD_D4 at RB4_bit;
 sbit LCD_D5 at RB5_bit;
 sbit LCD_D6 at RB6_bit;
 sbit LCD_D7 at RB7_bit;
 sbit LCD_RS_Direction at TRISC6_bit;
 sbit LCD_EN_Direction at TRISC7_bit;
 sbit LCD_D4_Direction at TRISB4_bit;
 sbit LCD_D5_Direction at TRISB5_bit;
 sbit LCD_D6_Direction at TRISB6_bit;
 sbit LCD_D7_Direction at TRISB7_bit;

 sbit IR_Tx at RA3_bit;


 char message1[] = "Tachometer";
 char *RPM = "00000 RPM";
 void Display_RPM(unsigned long num){
 RPM[0] = num/10000 + 48;
 RPM[1] = (num/1000)%10 + 48;
 RPM[2] = (num/100)%10 + 48;
 RPM[3] = (num/10)%10 + 48;
 RPM[4] = num%10 + 48;
 Lcd_Out(2,4,RPM);
 }

 void main() {
 CMCON = 0x07;
 ADCON1 = 0x0F;
 TRISC = 0x00;
 TRISB = 0x00;
 PORTA = 0x00;
 TRISA = 0b00010000;
 T0CON = 0b01101000;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,4,message1);
 do {

 T0CON.TMR0ON = 1;
 TMR0L = 0;
 TMR0H = 0;
 IR_Tx = 1;

 Delay_ms(1000);
 IR_Tx = 0;
 T0CON.TMR0ON = 0;
 RPM_Value = (256*TMR0H + TMR0L)*60;
 Display_RPM(RPM_Value);
 } while(1);
 }
