#include <SerialLCD.h>
#include <BlueToothM5.h>

String readString;

SerialLCD LCD;

BTM5 BlueTooth; 

void setup() 
{
  
  LCD.init();  
  LCD.clear();
  
  BlueTooth.init();
  
  Serial.begin(38400);
  
  Serial.println("serial test 0021"); // so I can keep track of what is loaded
 
 
  LCD.clear();
  
  delay(2000);
  
  
  LCD.setCursor(2, 1);
  LCD.write("Edilson");
  
  Serial.print(BlueTooth.getFirmware());

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


