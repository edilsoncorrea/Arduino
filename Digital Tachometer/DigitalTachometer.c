/*
  Project: Contactless digital tachometer
  Description:
    MCU: PIC18F2550 onboard StartUSB for PIC board
    48.0 MHz clock using HS+PLL
    TIMER0 module is used as a 16-bit counter to count external
    pulses arriving at T0CKI input
    
    Copyright @ Rajendra Bhatt
    April 18, 2011
*/

 unsigned long RPM_Value;

// Define LCD module connections.
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
// End LCD module connection definition
 sbit IR_Tx at RA3_bit;

// Define Messages
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
  CMCON = 0x07;   // Disable comparators
  ADCON1 = 0x0F;  // Disable Analog functions
  TRISC = 0x00;
  TRISB = 0x00;
  PORTA = 0x00;
  TRISA = 0b00010000;
  T0CON = 0b01101000; // TMR0 as 16-bit counter
  Lcd_Init();        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);             // CLEAR display
  Lcd_Cmd(_LCD_CURSOR_OFF);        // Cursor off
  Lcd_Out(1,4,message1);            // Write message1 in 1st row
  do {

   T0CON.TMR0ON = 1;
   TMR0L = 0;
   TMR0H = 0;
   IR_Tx = 1;

   Delay_ms(1000); // Wait for 1 sec
   IR_Tx = 0;
   T0CON.TMR0ON = 0;    // Stop the timer
   RPM_Value = (256*TMR0H + TMR0L)*60;
   Display_RPM(RPM_Value);
  } while(1);             // Infinite Loop
 }