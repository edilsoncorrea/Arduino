#include <SerialLCD.h>
#include <BlueToothM5.h>

String readString;

SerialLCD LCD;

typedef struct 
{
  byte tamanho;
  byte NrSerial[4];
  int leituras[6];
} adcReport;



void setup() 
{
  LCD.init();  
  LCD.clear();
  
  
  
  
  Serial.begin(9600);
  Serial2.begin(9600);
  
  Serial.println("serial test 0021"); // so I can keep track of what is loaded
 
 
  //BlueTooth.setRoleMaster();
 
  delay(200);
 
 
  //BlueTooth.setBind("0015,4B,12435E"); 
  //BlueTooth.setBind("00:15:4B:12:43:5E"); 
 
  //BlueTooth.setDeviceName("ArduinoBT"); 
 
  LCD.clear();
  LCD.setCursor(2, 1);
  
  //readString = BlueTooth.getBind();
  //Serial.println(readString);
  
  delay(200);
  
  //BlueTooth.setRoleMaster();

  
  //readString = BlueTooth.getPassword();
  
  
  //Serial.println(readString);
  
  //LCD.write(readString);
  
  //delay(2000);

  //LCD.setCursor(3, 1);
  //readString = BlueTooth.getRemoteDeviceName("0015,4B,12435E");


}

void loop() 
{
  while (Serial2.available()) 
  {
    delay(10);

    if (Serial2.available() > 0) 
    {
      byte c = Serial2.read();
      readString += c;
    }
  }

  if (readString.length() > 0) 
  {
    Serial.println(readString);

    LCD.clear();
    LCD.setCursor(2, 1);
    
    //LCD.write(readString);
    
    readString = "";
  }
}

