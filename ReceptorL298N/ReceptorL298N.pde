#include <EasyTransfer.h>
#include <Servo.h> 

//create two objects
EasyTransfer Receptor; 

Servo ServoThrotle; 
Servo ServoRudd;  
Servo ServoEleron;  
Servo ServoAilevon;

struct RECEIVE_DATA_STRUCTURE
{
  int Throtle;
  int Rudd;
  int Eleron;
  int Ailevon;
  int Button;
  int Sequencial; 
};

//give a name to the group of data
RECEIVE_DATA_STRUCTURE rxdata;

int  ENA = 2; //Habilita Motor1
int  ENB = 7; //Habilita Motor2

// Initialize
int PWM1 = 3; // PWM Pin Motor 1
int PoM1 = 4; // Polarity Pin Motor 1
int PWM2 = 5; // PWM Pin Motor 2  
int PoM2 = 6; // Polarity Pin Motor 2

int lastgoodThrotle;
int adjvalorThrotle;  // mapped value to be between 0-254
int adjvalorAntThrotle = 0;  // mapped value to be between 0-254

int vlMinDeadZoneThrotle = 254;
int vlMaxDeadZoneThrotle =   0;

int lastgoodAileron;
int adjvalorAileron;  // mapped value to be between 0-511
int adjvalorAntAileron = 0;  // mapped value to be between 0-511

int vlMinDeadZoneAileron = 120;
int vlMaxDeadZoneAileron =   0;
int vlMidDeadZoneAileron =   0;

int lastgoodElevon;
int adjvalorElevon;  // mapped value to be between 0-511
int adjvalorAntElevon = 0;  // mapped value to be between 0-511

int vlMinDeadZoneElevon = 254;
int vlMaxDeadZoneElevon =   0;
int vlMidDeadZoneElevon =   0;

int vlMotor1 = 0;
int vlMotor2 = 0;

int contador = 0;

void setup() 
{
  InicializaConfPinos();

  delay(20);
  
  Serial1.begin(115200);
  
  delay(20);
  
  Receptor.begin(details(rxdata), &Serial1);
  
  delay(20);
  
  ServoAilevon.attach(11);
  
  Serial.begin(9600);

  for (int i = 0; i < 50; i++)
  {
    Receptor.receiveData();
    
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
    Serial.print(adjvalorAileron);
    Serial.print("        ");        
      
    Serial.print("adj Elevon:  ");
    Serial.print(adjvalorElevon);
    Serial.println("        ");        

    delay(10);
  }
  
  vlMidDeadZoneAileron =  vlMinDeadZoneAileron + ((vlMaxDeadZoneAileron - vlMinDeadZoneAileron) / 2); 
  vlMidDeadZoneElevon  =  vlMinDeadZoneElevon + ((vlMaxDeadZoneElevon - vlMinDeadZoneElevon) / 2);  

  Serial.print("Min Aileron:  ");
  Serial.print(vlMinDeadZoneAileron);
  Serial.print("        ");  
   
  Serial.print("Max Aileron:  ");
  Serial.print(vlMaxDeadZoneAileron);
  Serial.print("        ");        
  
  Serial.print("Mid Aileron:  ");
  Serial.print(vlMidDeadZoneAileron);
  Serial.println("        ");  
}

void loop() 
{ 
  Receptor.receiveData();
  
  ReadThrotle();

  ReadAileron();
  
  ReadElevon();
  
  ProcessaDadosElevon();
    
  analogWrite(PWM1, vlMotor1);
  analogWrite(PWM2, vlMotor2);
    
  if (adjvalorAileron != adjvalorAntAileron)
    ServoAilevon.write(adjvalorAileron);
   
  //MostraValores();
 
  adjvalorAntThrotle = adjvalorThrotle;
  adjvalorAntAileron = adjvalorAileron;
  adjvalorAntElevon  = adjvalorElevon;
  
  delay(10);
}

void MostraValores()
{
  //print values
  Serial.print("Elevon:  ");
  Serial.print(adjvalorElevon);
  Serial.print("        ");    
  
  Serial.print("Motor:  ");
  Serial.print(vlMotor1);
  Serial.print("        ");  


  Serial.print("Aileron:  ");
  Serial.print(adjvalorAileron);
  Serial.println("        ");  


//  Serial.print("adjvalorThrotle:  ");
//  Serial.print(adjvalorThrotle);
//  Serial.println("        ");    
}

void InicializaConfPinos()
{
  
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
  adjvalorThrotle = map(rxdata.Throtle, 0, 1023, 0, 511); 
  constrain (adjvalorThrotle, 0, 511);
}  

void ReadAileron()
{
  adjvalorAileron = map(rxdata.Ailevon, 0, 1023, 120, 60);
  constrain(adjvalorAileron, 60, 120);
}

void ReadElevon()
{
  adjvalorElevon  = map(rxdata.Throtle,  0, 1023, 0, 511); 
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
          
          vlMotor1 = 264 - vlMotor1;
          vlMotor2 = 264 - vlMotor2; 
        } 
    }
}

