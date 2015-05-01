/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
#include <digitalWriteFast.h>
#define encoder0PinA  3
#define encoder0PinB  4

 int val; 
 int encoder0Pos = 0;
 int encoder0PinALast = LOW;
 int n = LOW;

 void setup() 
 { 
   pinModeFast(encoder0PinA, INPUT);
   pinModeFast(encoder0PinB, INPUT);
   
   Serial.begin(115200);
 } 

 void loop() 
 { 
   n = digitalReadFast(encoder0PinA);
   
   if ((encoder0PinALast == LOW) && (n == HIGH)) 
   {
     if (digitalReadFast(encoder0PinB) == LOW) 
     {
       encoder0Pos--;
     } 
     else 
     {
       encoder0Pos++;
     }
     
     Serial.println(encoder0Pos);
   } 
   
   encoder0PinALast = n;
 } 

