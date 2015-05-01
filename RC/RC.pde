#include <avr/io.h>
#include <avr/eeprom.h>
#include <math.h>/

**************************************************************
* Function to initialize the R/C mode.. 
***************************************************************/
#define read_ch2 (PINB & (1 << 6))//Port B, pin 6 as channel 1;
#define read_ch1 (PINB & (1 << 7))//Port B, pin 7 as channel 2;

unsigned int clock1=0;//Clock to count the pulse length
unsigned int clock2=0;
int ch1_position=0;  //This variable stores the raw position of channel 1
int ch2_position=0; //The same as above but for ch2. 
byte ch1_state_flag=0;//Something used to messure the pulse length... 
byte ch2_state_flag=0;
int rc_ch1_central; //The central position of the control
int rc_ch2_central;
int MAX_RC=20;   //Normally is 40, but is auto adjustable... 

void setup()
{
  Serial.begin(38400);
  
  Serial.print("Starting System... ");
  //Init_RC();

  Serial.println("OK!!!");
  
}

void loop()
{  
    Serial.print("Reading startup altitude... ");
    delay(1000); // wait one second
    Serial.println("Checking RC connection...");
//
//    if(RC_detector()==1)//RC_detector return 1 if it detects a receiver attached to the board. 
//    {
//      Serial.println("RC detected, activating PWM settings...");
//    }
//   else
//   {
//      Serial.println("No RC detected, starting normally...");
 //     Serial.println("Starting timer1 Fast PWM, to pulse vector servo...");
//   }
//    delay(400);
  
}






void Init_RC(void)
{
  
  DDRB&= ~(0x03 << 6); //We change only bits 6 and 7 to 0 (input).
  
  /*Activating External interrupts for pins 6 and 7 of port B*/ 
  PCICR= 0x00|(1<<PCIE0); //Enable interrupt, read page 70 of Atmega168 datasheet to know more .
  PCMSK0= 0x00|(1<<PCINT7)|(1<<PCINT6); //Interrupt mask, read page 71 of datasheet to know more .
  
  /*Activating Timer2, we use it to count only useconds, is the same timer used to pulse the servo, can't be used at the same time*/
  TCCR1A=0x00;
  TCCR1B = 0x00 |(1 << CS11)|(1<<WGM12) ; // using prescaler 8 =), page 134
  OCR1A  = 10; //prescaler 8/8mhz= 1 us resolution, so the interrupt will be execute every 10us...                       
  TIMSK1 |=(1 << OCIE1A); //See page 136, Enabling timer interrupt  
  
  sei(); //Enabling all interrupts, this interrupt is at the end of the code. The functions are called "ISR(TIMER1_COMPA_vect)" and "ISR(PCINT0_vect)"
}
    /**************************************************************
    * Function to know if there is anything attached to the board.
    ***************************************************************/
byte RC_detector(void)
{
float average_ch1=0;

delay(1000); //wait a second for RC receivers that take a second to boot up
for(int c=0; c<=10; c++)
{
   average_ch1=(average_ch1*.50)+(ch1_position*.50);//Just average the input ch1
}

  if(average_ch1>1)//If the average is greater than 1, a RC receiver is attached to the board.. 
  {
  Serial.println ("Keep the sticks centered for a few seconds");  
  rc_ch1_central=ch1_position;//Then it stores the central position of the sticks
  rc_ch2_central=ch2_position;//You must keep the sticks centered during this part... 
  return 1; 
  }
return 0;
}
    /**************************************************************
    * Function to mix the thruster with two input channels..
    ***************************************************************/
    

    /**************************************************************
    * Timer interrupt function
    ***************************************************************/
    
ISR(TIMER1_COMPA_vect)//This is a timer interrupt, executed every 10us 
{
  clock1++;//Just a counter that increments every 10us... 
  clock2++;
}

    /**************************************************************
    * External interrupt function 
    ***************************************************************/
   
ISR(PCINT0_vect)//This interrupt is executed every time the PIN 6 and 7 of portB changes state. 
{
  /****This part is for channel 1****/
  if((read_ch1)&&(ch1_state_flag==0)) //if read_ch1 goes high, and if the flag is equal to 0 
  {
    clock1=0; //restart the clock 
    ch1_state_flag=1;//and change the flag to avoid undesired restart of the clock1.. 
  }
  if((read_ch1==0)&&(ch1_state_flag==1))//check if the pin is low, and also check if the flag was activated...
  {
    ch1_position=clock1; //pass the value of clock1 to ch1_position... 
    ch1_state_flag=0; //Reset the flag.... and that's all... 
  }
  /****This part is for channel 2, the same as above***/
    if((read_ch2)&&(ch2_state_flag==0))
  {
    clock2=0;
    ch2_state_flag=2;
  }
  if((read_ch2==0)&&(ch2_state_flag==2))
  {
    ch2_position=clock2;
    ch2_state_flag=0;
  }
}

