#include <string.h>
#include <ctype.h>
#include <SoftwareSerial.h>

#define rxPin 8
#define txPin 9

 int byteGPS=-1;
 char linea[300] = "";
 char comandoGPR[7] = "$GPRMC";
 int cont=0;
 int bien=0;
 int conta=0;
 int indices[13];

 void setup() 
 {
   Serial1.begin(38400);
   Serial.begin(38400);

   for (int i = 0; i < 300; i++)
   {       // Initialize a buffer for received data
     linea[i]=' ';
   }  
 }

 void loop() 
 {
   byteGPS = Serial1.read(); // Read a byte of the serial port

   if (byteGPS == -1) // See if the port is empty yet
     {           
       delay(100);
     }   
   else 
     {
       linea[conta] = byteGPS;        // If there is serial port data, it is put in the buffer
       conta++;                      

       Serial.print(byteGPS, BYTE);
       
       if (byteGPS == 13) // If the received byte is = to 13, end of transmission
       {            
         cont =0;
         bien =0;
         
         for (int i = 1; i < 7; i++) // Verifies if the received command starts with $GPR
         {     
           if (linea[i] == comandoGPR[i-1])
           {
           bien++;
           }
         }
       
         conta=0;                    // Reset the buffer
         for (int i=0; i < 300; i++)
         {    //  
           linea[i] = ' ';            
         }                
       }
     }
}
 
