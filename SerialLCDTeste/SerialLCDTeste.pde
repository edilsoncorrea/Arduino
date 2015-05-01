#include <SerialLCD.h>

SerialLCD LCD;

void setup()
{
  Serial.begin(9600);
  
  
  delay(2000);
  LCD.clear();
  
}

void loop()
{
 int byteGPS=-1;
 char linea[300] = "";
 int conta=0;
 
 byteGPS = Serial.read();         // Read a byte of the serial port
 
 if (byteGPS == -1) 
   {           // See if the port is empty yet
     delay(100); 
   } 
 else 
   {
     linea[conta] = byteGPS;        // If there is serial port data, it is put in the buffer
   
     conta++;
     
     if (byteGPS == 13)
       {            // If the received byte is = to 13, end of transmission
       
           LCD.clear();
           LCD.setCursor(2, 1);
           LCD.write(linea);
       } 
     } 
   } 

