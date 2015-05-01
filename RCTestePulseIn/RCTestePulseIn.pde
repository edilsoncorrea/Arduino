#include <Servo.h> 

Servo myservoHorizontal; 
Servo myservoVertical;  

int pinThrotle = 2;
int pinAileron = 3;
int pinElevon  = 4;

volatile int RCvalorThrotle;  // store RC signal pulse length
int lastgoodThrotle;
int adj_valorThrotle;  // mapped value to be between 0-179
int adj_valorAntThrotle = 0;  // mapped value to be between 0-179

volatile int RCvalorAileron;  // store RC signal pulse length
int lastgoodAileron;
int adj_valorAileron;  // mapped value to be between 0-179
int adj_valorAntAileron = 0;  // mapped value to be between 0-179

volatile int RCvalorElevon;  // store RC signal pulse length
int lastgoodElevon;
int adj_valorElevon;  // mapped value to be between 0-179
int adj_valorAntElevon = 0;  // mapped value to be between 0-179

void setup() {
  //Serial.begin(9600); 
 
  myservoHorizontal.attach(9);  
  myservoVertical.attach(8);   

  //PPM inputs from RC receiver
  pinMode(pinThrotle, INPUT);
  pinMode(pinAileron, INPUT);
  pinMode(pinElevon,  INPUT);

  //attachInterrupt(0, rc1, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  //attachInterrupt(1, rc2, RISING);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()
}

void loop() 
{
  RCvalorThrotle = pulseIn(pinThrotle, HIGH, 20000); //read RC channel 1

  if (RCvalorThrotle == 0) {
    RCvalorThrotle = lastgoodThrotle;
  } 
  else {
    lastgoodThrotle = RCvalorThrotle;
  }
  
  adj_valorThrotle = map(RCvalorThrotle, 1100, 1906, 0, 179);
  constrain (adj_valorThrotle, 0, 179);

  RCvalorAileron = pulseIn(pinAileron, HIGH, 20000); //read RC channel 2
  
  if (RCvalorAileron == 0) 
  {
    RCvalorAileron = lastgoodAileron;
  } 
  else 
  {
    lastgoodAileron = RCvalorAileron;
  }
  
  adj_valorAileron = map(RCvalorAileron, 1030, 1885, 0, 179);  
  constrain(adj_valorAileron, 0, 179);
  
  RCvalorElevon = pulseIn(pinElevon, HIGH, 20000); //read RC channel 2
  
  if (RCvalorElevon == 0) 
  {
    RCvalorElevon = lastgoodElevon;
  } 
  else 
  {
    lastgoodElevon = RCvalorElevon;
  }
  
  adj_valorElevon = map(RCvalorElevon, 1030, 1885, 0, 179);  
  constrain(adj_valorElevon, 0, 179);
  
  if (adj_valorElevon != adj_valorAntElevon)
  {
    myservoHorizontal.write(adj_valorElevon);  
  } 
 
  if (adj_valorAileron != adj_valorAntAileron)
  {
    myservoVertical.write(adj_valorAileron); 
  } 
  
  adj_valorAntAileron = adj_valorAileron;
  adj_valorAntElevon = adj_valorElevon;
  
 
  //print values
  //Serial.print("Throtle:  ");
  //Serial.print(adj_valorThrotle);
  //Serial.print("        ");  

  //Serial.print("Aileron:  ");  
  //Serial.print(adj_valorAileron);
  //Serial.print("        ");
  
  //Serial.print("Elevon:  ");
  //Serial.print(adj_valorElevon);  
  //Serial.println("        ");
  
  
  //Serial.print("Throtle:  ");
  //Serial.print(RCvalorThrotle);
  //Serial.print("        ");  

  //Serial.print("Aileron:  ");  
  //Serial.print(RCvalorAileron);
  //Serial.print("        ");
  
  //Serial.print("Elevon:  ");
  //Serial.print(RCvalorElevon);  
  //Serial.println("        ");
}

