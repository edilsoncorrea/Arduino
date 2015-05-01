int  ENA = 2; //Habilita Motor1
int  ENB = 7; //Habilita Motor2

// Initialize
int PWM1 = 3; // PWM Pin Motor 1
int PoM1 = 4; // Polarity Pin Motor 1
int PWM2 = 5; // PWM Pin Motor 2  
int PoM2 = 6; // Polarity Pin Motor 2
   
int pinThrotle = 8;
int pinAileron = 9;
int pinElevon  = 10;

volatile int RCvalorThrotle;  // store RC signal pulse length
int lastgoodThrotle;
int adjvalorThrotle;  // mapped value to be between 0-254
int adjvalorAntThrotle = 0;  // mapped value to be between 0-254

int vlMinDeadZoneThrotle = 254;
int vlMaxDeadZoneThrotle =   0;

volatile int RCvalorAileron;  // store RC signal pulse length
int lastgoodAileron;
int adjvalorAileron;  // mapped value to be between 0-511
int adjvalorAntAileron = 0;  // mapped value to be between 0-511

int vlMinDeadZoneAileron = 511;
int vlMaxDeadZoneAileron =   0;
int vlMidDeadZoneAileron =   0;

volatile int RCvalorElevon;  // store RC signal pulse length
int lastgoodElevon;
int adjvalorElevon;  // mapped value to be between 0-511
int adjvalorAntElevon = 0;  // mapped value to be between 0-511

int vlMinDeadZoneElevon = 511;
int vlMaxDeadZoneElevon =   0;
int vlMidDeadZoneElevon =   0;

int vlMotor1 = 0;
int vlMotor2 = 0;

void setup() 
{
  InicializaConfPinos();

  Serial.begin(9600);

  for (int i = 0; i < 20; i++)
  {
    ReadThrotle();

    if (adjvalorThrotle < vlMinDeadZoneThrotle)
      vlMinDeadZoneThrotle = adjvalorThrotle - 1;

    if (adjvalorThrotle > vlMaxDeadZoneThrotle)
      vlMaxDeadZoneThrotle = adjvalorThrotle + 1;
  
    ReadAileron();
  
    if (adjvalorAileron < vlMinDeadZoneAileron)
      vlMinDeadZoneAileron = adjvalorAileron - 1;

    if (adjvalorAileron > vlMaxDeadZoneAileron)
      vlMaxDeadZoneAileron = adjvalorAileron + 1;
      
    ReadElevon();

    if (adjvalorElevon < vlMinDeadZoneElevon)
      vlMinDeadZoneElevon = adjvalorElevon - 2;

    if (adjvalorElevon > vlMaxDeadZoneElevon)
      vlMaxDeadZoneElevon = adjvalorElevon + 2;
      

    Serial.print("adj Elevon:  ");
    Serial.print(adjvalorElevon);
    Serial.println("        ");        

    delay(200);
  }
  
  vlMidDeadZoneAileron =  vlMinDeadZoneAileron + ((vlMaxDeadZoneAileron - vlMinDeadZoneAileron) / 2); 
  vlMidDeadZoneElevon  =  vlMinDeadZoneElevon + ((vlMaxDeadZoneElevon - vlMinDeadZoneElevon) / 2);  

  Serial.print("Min Elevon:  ");
  Serial.print(vlMinDeadZoneElevon);
  Serial.print("        ");  
   
  Serial.print("Max Elevon:  ");
  Serial.print(vlMaxDeadZoneElevon);
  Serial.print("        ");        
  
  Serial.print("Mid Elevon:  ");
  Serial.print(vlMidDeadZoneElevon);
  Serial.println("        ");  
}

void loop() 
{ 
  ReadThrotle();

  ReadAileron();
  
  ReadElevon();
  
  ProcessaDadosElevon();
  
  if ((vlMotor1 == 0) || (vlMotor2 == 0))
    ProcessaDadosAileron();

  analogWrite(PWM1, vlMotor1 * (511 / (adjvalorThrotle + 1)));
  analogWrite(PWM2, vlMotor2 * (511 / (adjvalorThrotle + 1)));
   
  MostraValores();
 
  adjvalorAntThrotle = adjvalorThrotle;
  adjvalorAntAileron = adjvalorAileron;
  adjvalorAntElevon  = adjvalorElevon;
  
  delay(100);
}

void MostraValores()
{
  //print values
  Serial.print("Motor1:  ");
  Serial.print(vlMotor1);
  Serial.print("        ");  

  Serial.print("Motor2:  ");
  Serial.print(vlMotor2);
  Serial.print("        ");  

  Serial.print("Elevon:  ");
  Serial.print(adjvalorElevon);
  Serial.println("        ");  
  
//  Serial.print("RCvalorAileron:  ");
//  Serial.print(RCvalorAileron);
//  Serial.print("        ");  
//

//  Serial.print("adjvalorThrotle:  ");
//  Serial.print(adjvalorThrotle);
//  Serial.println("        ");    
}

void InicializaConfPinos()
{
  //PPM inputs from RC receiver
  pinMode(pinThrotle, INPUT);
  pinMode(pinAileron, INPUT);
  pinMode(pinElevon,  INPUT);
  
  pinMode(PWM1, OUTPUT); 
  pinMode(PoM1, OUTPUT); 
  
  pinMode(PWM2, OUTPUT);   
  pinMode(PoM2, OUTPUT);   
  
  digitalWrite(PoM1, LOW) ;   // Both motor with same polarity
  digitalWrite(PoM2, LOW) ;
  
  analogWrite(PWM1, 0);   // Stop both motors => ValMx = 0
  analogWrite(PWM2, 0);    

  digitalWrite(ENA, HIGH);
  digitalWrite(ENB, HIGH);    
}

void ReadThrotle()
{
  RCvalorThrotle = pulseIn(pinThrotle, HIGH, 20000); //read RC channel 1

  if (RCvalorThrotle == 0) 
  {
    RCvalorThrotle = lastgoodThrotle;
  } 
  else 
  {
    lastgoodThrotle = RCvalorThrotle;
  }
  
  adjvalorThrotle = map(RCvalorThrotle, 1060, 1930, 0, 254);
  constrain (adjvalorThrotle, 0, 254);
}  

void ReadAileron()
{
  RCvalorAileron = pulseIn(pinAileron, HIGH, 20000); //read RC channel 2
  
  if (RCvalorAileron == 0) 
  {
    RCvalorAileron = lastgoodAileron;
  } 
  else 
  {
    lastgoodAileron = RCvalorAileron;
  }
  
  adjvalorAileron = map(RCvalorAileron, 1000, 1914, 0, 511);  
  constrain(adjvalorAileron, 0, 511);
}

void ReadElevon()
{
  RCvalorElevon = pulseIn(pinElevon, HIGH, 20000); //read RC channel 2
  
  if (RCvalorElevon == 0) 
  {
    RCvalorElevon = lastgoodElevon;
  } 
  else 
  {
    lastgoodElevon = RCvalorElevon;
  }
  
  adjvalorElevon = map(RCvalorElevon, 1030, 1894, 0, 511);  
  constrain(adjvalorElevon, 0, 511);
}

void ProcessaDadosElevon()
{
  if ((adjvalorElevon > vlMinDeadZoneElevon) && (adjvalorElevon < vlMaxDeadZoneElevon))
    {
      digitalWrite(PoM1, LOW);
      digitalWrite(PoM2, LOW);

      vlMotor1 = 0;
      vlMotor2 = 0;  
    }
  else
    {
      vlMotor1 = abs(vlMinDeadZoneElevon - adjvalorElevon);
      vlMotor2 = vlMotor1; 
           
      if (adjvalorElevon < vlMinDeadZoneElevon)
        {
          digitalWrite(PoM1, LOW);
          digitalWrite(PoM2, LOW);
        } 
      else
        {
          digitalWrite(PoM1, HIGH);
          digitalWrite(PoM2, HIGH);
          
          vlMotor1 = 254 - vlMotor1;
          vlMotor2 = 254 - vlMotor2; 
        } 
    }
}

void ProcessaDadosAileron()
{
  if ((adjvalorAileron > vlMinDeadZoneAileron) && (adjvalorAileron < vlMaxDeadZoneAileron))
    {
      digitalWrite(PoM1, LOW);
      digitalWrite(PoM2, LOW);

      vlMotor1 = 0;
      vlMotor2 = 0;  
    }
  else
    {
      vlMotor1 = abs(vlMinDeadZoneAileron - adjvalorAileron);
      vlMotor2 = vlMotor1; 
           
      if (adjvalorAileron < vlMinDeadZoneAileron)
        {
          digitalWrite(PoM1, LOW);
          digitalWrite(PoM2, HIGH);
          
          vlMotor2 = 254 - vlMotor2; 
        } 
      else
        {
          digitalWrite(PoM1, HIGH);
          digitalWrite(PoM2, LOW);
          
          vlMotor1 = 254 - vlMotor1;
        } 
    }
}
