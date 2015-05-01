#include <avr/interrupt.h>
#include <avr/io.h>

unsigned int clock1 = 0; //Clock to count the pulse length
int ch1_position    = 0; //This variable stores the raw position of channel 1
byte ch1_state_flag = 0; //Something used to messure the pulse length...

void setup()
{
  pinMode(2, INPUT);
  Serial.begin(9600);
  
  attachInterrupt(0, rxISR, CHANGE);
   
   /*Activating Timer2, we use it to count only useconds, is the same timer used to pulse the servo, can't be used at the same time*/
  TCCR1A = 0x00;
  TCCR1B = 0x00 |(1 CS11)|(1WGM12) ; // using prescaler 8 =), page 134
  OCR1A  = 10; //prescaler 8/8mhz= 1 us resolution, so the interrupt will be execute every 10us...                       
  TIMSK1 |=(1 OCIE1A); //See page 136, Enabling timer interrupt  
  
  interrupts();
}

void loop()
{
  Serial.println(ch1_position, DEC);
  delay(10);
}

ISR(TIMER1_COMPA_vect)//This is a 
timer interrupt, executed every 10us 
{
  clock1++;//Just a counter that increments every 10us... 
}

void rxISR() 
{
  /****This part is for channel 1****/
  if((ch1_state_flag==0)) //if read_ch1 goes high, and if the flag is equal to 0 
    {
      clock1=0; //restart the clock 
      ch1_state_flag=1;//and change the flag to avoid undesired restart of the clock1.. 
    }
  else //if((ch1_state_flag==1))//check if the pin is low, and also check if the flag was activated...
    {
    ch1_position=clock1; //pass the value of clock1 to ch1_position... 
    ch1_state_flag=0; //Reset the flag.... and that's all... 
    }
}
