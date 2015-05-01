//We always have to include the library
#include "LedControl.h"

/*
 Now we need a LedControl to work with.
 ***** These pin numbers will probably not work with your hardware *****
 pin 12 is connected to the DataIn 
 pin 11 is connected to the CLK 
 pin 10 is connected to LOAD 
 We have only a single MAX72XX.
 */
LedControl lc=LedControl(12,11,10,1);

/* we always wait a bit between updates of the display */
unsigned long delaytime=1000;

void setup() 
{
  /*
   The MAX72XX is in power-saving mode on startup,
   we have to do a wakeup call
   */
  lc.shutdown(0,false);
  /* Set the brightness to a medium values */
  lc.setIntensity(0, 5);
  /* and clear the display */
  lc.clearDisplay(0);
}


/*
 This method will display the characters for the
 word "Arduino" one after the other on digit 0. 
 */
void writeArduinoOn7Segment() {
  lc.setChar(0,0,'a',false); 
  delay(delaytime);
  lc.setRow(0,0,0x05);
  delay(delaytime);
  lc.setChar(0,0,'d',false); 
  delay(delaytime);
  lc.setRow(0,0,0x1c);
  delay(delaytime);
  lc.setRow(0,0,B00010000);
  delay(delaytime);
  lc.setRow(0,0,0x15);
  delay(delaytime);
  lc.setRow(0,0,0x1D);
  delay(delaytime);
  lc.clearDisplay(0);
  delay(delaytime);
} 


/*
  This method will scroll all the hexa-decimal
 numbers and letters on the display. You will need at least
 four 7-Segment digits. otherwise it won't really look that good.
 */
void scrollDigits() {
  for(int i=0;i<13;i++) {
    lc.setDigit(0, 3, i,     false);
    lc.setDigit(0, 2, i + 1, false);
    lc.setDigit(0, 1, i + 2, false);
    lc.setDigit(0, 0, i + 3, false);
    delay(delaytime);
  }
  
  lc.clearDisplay(0);
  delay(delaytime);
}

void Contador() 
{
  for (int i=0; i < 100000; i++) 
  {

    if ((((i / 1000000) % 10) > 0) || (((i / 1000000) % 10) > 0))
     lc.setDigit(0, 6, (i / 1000000) % 10, false);
   
    if ((((i / 100000) % 10) > 0) || (((i / 100000) % 10) > 0))
     lc.setDigit(0, 5, (i / 100000) % 10, false);

    if ((((i / 10000) % 10) > 0) || (((i / 10000) % 10) > 0))
     lc.setDigit(0, 4, (i / 10000) % 10, false);
   
    if  ((((i / 1000) % 10) > 0) || (((i / 10000) % 10) > 0))  
      lc.setDigit(0, 3, (i / 1000) % 10, false);
   
    if ((((i / 100) % 10) > 0) || (((i / 1000) % 10) > 0)) 
      lc.setDigit(0, 2, (i / 100) % 10, false);
  
    if ((((i / 10) % 10) > 0) || (((i / 100) % 10) > 0))
      lc.setDigit(0, 1, (i / 10) % 10, false);
   
    lc.setDigit(0, 0, i % 10, false);
   
    delay(delaytime);
  }
  
  lc.clearDisplay(0);
  delay(delaytime);
}


void writeEdilsonOn7Segment() 
{
  lc.setRow(0, 7, B01001111);  //E
  lc.setRow(0, 6, B00111101);  //d 
  lc.setRow(0, 5, B00000100); //i 
  lc.setRow(0, 4, B00000110); //l
  lc.setRow(0, 3, B01011011); //S 
  lc.setRow(0, 2, B00011101); //o
  lc.setRow(0, 1, B00010101);  //n
  delay(delaytime);

  lc.clearDisplay(0);

  lc.setRow(0, 7, B01001110);  //C
  lc.setRow(0, 6, B00011101);  //o 
  lc.setRow(0, 5, B00000101); //r 
  lc.setRow(0, 4, B00000101); //r
  lc.setRow(0, 3, B01001111); //E 
  lc.setRow(0, 2, B01110111); //A

  delay(delaytime);
  lc.clearDisplay(0);

  lc.setRow(0, 7, B01001111);  //E
  lc.setRow(0, 6, B00010111);  //h

  lc.setRow(0, 4, B01000111); //F
  lc.setRow(0, 3, B00011101); //o 
  lc.setRow(0, 2, B00111101); //d
  lc.setRow(0, 1, B01110111); //A
  
  
  

  delay(delaytime);
  
  lc.clearDisplay(0);
  delay(delaytime);
} 

void writeWaitForItOn7Segment() 
{
  lc.clearDisplay(0);
  
  lc.setChar(0, 4, 'I', false);  
  lc.setChar(0, 3, 'T', false); 

  delay(delaytime);
  lc.clearDisplay(0);

  lc.setChar(0, 5, 'W', false); 
  lc.setChar(0, 4, 'I', false); 
  lc.setChar(0, 3, 'L', false); 
  lc.setChar(0, 2, 'L', false);  

  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 5, 'G', false);  
  lc.setChar(0, 4, 'O', false); 
  lc.setChar(0, 3, 'N', false); 
  lc.setChar(0, 2, 'N', false); 
  lc.setChar(0, 1, 'A', false); 
  
  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 4, 'B', false);  
  lc.setChar(0, 3, 'E', false); 

  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 5, 'L', false);  
  lc.setChar(0, 4, 'E', false); 
  lc.setChar(0, 3, 'G', false); 
  lc.setChar(0, 2, 'E', false); 
  lc.setChar(0, 1, 'N', false); 
  
  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 5, 'W', false);  
  lc.setChar(0, 4, 'A', false); 
  lc.setChar(0, 3, 'I', false); 
  lc.setChar(0, 2, 'T', false); 
  
  delay(delaytime);
  lc.clearDisplay(0);
  
  
  lc.setChar(0, 5, 'F', false); 
  lc.setChar(0, 4, 'O', false);  
  lc.setChar(0, 3, 'R', false);  
  delay(delaytime);

  lc.clearDisplay(0);
  
  lc.setChar(0, 4, 'I', false);  
  lc.setChar(0, 3, 'T', false); 

  delay(delaytime);
  
  lc.clearDisplay(0);
  
  lc.setChar(0, 5, 'W', false);  
  lc.setChar(0, 4, 'A', false); 
  lc.setChar(0, 3, 'I', false); 
  lc.setChar(0, 2, 'T', false); 
  
  delay(delaytime);
  lc.clearDisplay(0);
  
  
  lc.setChar(0, 5, 'F', false); 
  lc.setChar(0, 4, 'O', false);  
  lc.setChar(0, 3, 'R', false);  

  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 4, 'I', false);  
  lc.setChar(0, 3, 'T', false); 

  delay(delaytime);
  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 5, 'D', false); 
  lc.setChar(0, 4, 'A', false);  
  lc.setChar(0, 3, 'R', false);  
  lc.setChar(0, 2, 'Y', false);  
  
  delay(delaytime);
  delay(delaytime);
  
  
  
} 


void writeGenioOn7Segment() 
{
  
  lc.setChar(0, 7, 'E', false);  
  lc.setChar(0, 6, 'D', false); 
  lc.setChar(0, 5, 'I', false); 
  lc.setChar(0, 4, 'L', false); 
  lc.setChar(0, 3, 'S', false); 
  lc.setChar(0, 2, 'O', false); 
  lc.setChar(0, 1, 'N', false);  

  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 4, 'E', false);  
  
  delay(delaytime);
  lc.clearDisplay(0);
  
  lc.setChar(0, 5, 'G', false);  
  lc.setChar(0, 4, 'E', false); 
  lc.setChar(0, 3, 'N', false); 
  lc.setChar(0, 2, 'I', false); 
  lc.setChar(0, 1, 'O', false); 
  
  delay(delaytime);
  delay(delaytime);
  
} 



void Contador2() 
{
  for (int i=0; i < 10000; i++) 
  {
    for (int d = 0; d < 7; d++)
    {
      int digitocorrente = pow(10, d); 
      int digitoseguinte  = pow(10, d + 1); 
      
      if ((((i / digitocorrente) % 10) > 0) || (((i / digitoseguinte) % 10) > 0))
        lc.setDigit(0, d, (i / digitocorrente) % 10, false);
    }
   
    delay(delaytime);
  }
  
  lc.clearDisplay(0);
  delay(delaytime);
}




void loop() 
{ 
//  writeArduinoOn7Segment();
//  scrollDigits();
    
 //Contador2();
 
 //writeWaitForItOn7Segment();
 
 writeGenioOn7Segment();
}
