#include <SerialLCD.h>
#include <BlueToothM5.h>

String readString;

SerialLCD LCD;

void setup() 
{
  LCD.init();  
  LCD.clear();
  
  Serial.begin(38400);
  Serial2.begin(38400);
  
  Serial.println("serial test 0021"); // so I can keep track of what is loaded
 
 
  LCD.setCursor(1, 1);
  LCD.write("Preparado");

  delay(100);
  
  LCD.clear();
  LCD.setCursor(2, 1);
  LCD.write("Nome:"); 
 
  pinMode(12, OUTPUT);   
  digitalWrite(12, HIGH);   
  delay(20);

  Serial2.write("AT+VERSION\r\n");
  delay(10);
  

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
    digitalWrite(12, LOW);   
    Serial.println(readString);

    LCD.setCursor(2, 9);
    
    LCD.write(readString);
    
    readString = "";
  }
}


