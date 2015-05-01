// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.
#include <SoftwareSerial.h>
#include <Servo.h> 

Servo myservoHor; 
Servo myservoVer;  

int posLDR1 = 0,
    posLDR2 = 0, 
    posLDR3 = 0;   

void setup() 
{ 
  Serial.begin(9600);
  Serial.println("Servos:");

  myservoHor.attach(8);  
  myservoVer.attach(9);  

  posLDR1 = 0;   
  posLDR2 = 0;   
  posLDR3 = 0;   

  myservoHor.write(90);
  myservoVer.write(90); 

} 


void loop() 
{ 
  
  posLDR1 = analogRead(A0);
  posLDR2 = analogRead(A1);
  posLDR3 = analogRead(A2);
   
   
  Serial.print("LDR 1: ");
  Serial.print(posLDR1, DEC);  
  Serial.print(' ');

  Serial.print('LDR 2: ');
  Serial.print(posLDR2);
  Serial.print(' ');

  Serial.print('LDR 3: ');
  Serial.print(posLDR3);
 
 
  delay(2000);

}





