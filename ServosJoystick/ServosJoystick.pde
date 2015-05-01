// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.
#include <Servo.h> 
#include <AcceleroMMA7361.h>

AcceleroMMA7361 accelero;
int x;
int y;
int z;
 
Servo myservoHorizontal; 
Servo myservoVertical;  
 
int posHorizontal         = 0;   
int posHorizontalAnterior = 0;   
 
int posVertical           = 0;   
int posVerticalAnterior   = 0;   
 
void setup() 
{ 
  Serial.begin(9600);
  Serial.println("Servos");

  accelero.begin(13, 12, 11, A0, A1, A2);
  accelero.callibrate();

  myservoHorizontal.attach(9);  
  myservoVertical.attach(8);  

  x = accelero.getXAccel() / 5.68888;
  y = accelero.getYAccel() / 5.68888;
  z = accelero.getZAccel();
     
  posHorizontal          = 90 + x;
  posHorizontalAnterior  = 90 + x;

  posVertical            = 90 + y;
  posVerticalAnterior    = 90 + y;
  
  myservoHorizontal.write(posHorizontal);
  myservoVertical.write(posVertical);  
} 
 
 
void loop() 
{ 
  x = accelero.getXAccel() / 5.68888;
  y = accelero.getYAccel() / 5.68888;
  z = accelero.getZAccel();
  
  posHorizontal          = 90 + x;
  posVertical            = 90 + y;
  
  //posHorizontal = (analogRead(A0) / 11.378) + 45;   
  //posVertical   = (analogRead(A1) / 11.378) + 45;

   
  if (posHorizontal != posHorizontalAnterior)
  {
    myservoHorizontal.write(posHorizontal);  
  } 
 
  if (posVertical != posVerticalAnterior)
  {
    myservoVertical.write(posVertical); 
  } 
  
  
  //if ((posHorizontal != posHorizontalAnterior) || (posVertical != posVerticalAnterior))
  {
    Serial.print("Hor D: ");
    Serial.print(posHorizontal, DEC);
    
    Serial.print("     Vert D: ");
    Serial.println(posVertical, DEC);
  }
  
  delay(200);
  
  posHorizontalAnterior = posHorizontal;
  posVerticalAnterior   = posVertical;
   
}




