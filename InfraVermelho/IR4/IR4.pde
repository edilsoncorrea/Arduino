#undef int
#undef abs
#undef double
#undef float
#undef round

#include <WProgram.h>
#include <NECIRrcv.h>
#define IRPIN 4

NECIRrcv ir(IRPIN);

void setup()
{
  Serial.begin(9600);
  Serial1.begin(9600);

  Serial.println("NEC IR code reception");
  ir.begin();

  pinMode(13, OUTPUT);     
  pinMode(12, OUTPUT);     

  delay(1000);

  Serial1.print("[\a]");
  
  delay(8);


  Serial1.print("@");
  Serial1.print(2, BYTE);
  Serial1.print(2, BYTE);
  
  delay(8);

  Serial1.print("[ Inicializado ]");
}

void loop()
{
  unsigned long ircode;

  while (ir.available()) 
  {
    ircode = ir.read();
    Serial.print("got code: 0x");
    Serial.println(ircode, HEX);

    if (ircode == 4228120320) 
    {
      digitalWrite(13, ! digitalRead(13));   // set the LED on

      Serial1.print("[\a]");

      delay(8);
    }  

    if (ircode == 4010868480)
    {
      digitalWrite(12, ! digitalRead(12));   // set the LED on

      Serial1.print("[\a]");

      delay(8);

      Serial1.print("[ Edilson Correa]");

      delay(8);

      Serial1.print("@");
      Serial1.print(6, BYTE);
      Serial1.print(2, BYTE);

      delay(8);

      Serial1.print("[rules]");
    }
  }
}





