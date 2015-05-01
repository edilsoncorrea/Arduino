String readString;

void setup() 
{
  Serial1.begin(38400);
  Serial.begin(38400);
  Serial.println("serial test 0021"); // so I can keep track of what is loaded
}

void loop() 
{
  while (Serial1.available()) 
  {
    delay(10);
    
    if (Serial1.available() > 0) 
    {
      byte c = Serial1.read();
      readString += c;
    }
  }
  
  if (readString.length() > 0) 
  {
    Serial.println(readString);
    
    readString = "";
  }
}
 
