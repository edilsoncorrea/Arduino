#include <AcceleroMMA7361.h>

AcceleroMMA7361 accelero;
int x;
int y;
int z;

void setup()
{
  Serial.begin(9600);
  accelero.begin(13, 12, 11, A0, A1, A2);
  accelero.callibrate();
  accelero.setARefVoltage(3.3); //sets the AREF voltage to 3.3V
}

void loop()
{
  x = accelero.getXAccel();
  y = accelero.getYAccel();
  z = accelero.getZAccel();
  Serial.print("\nx: ");
  Serial.print(x);  
  Serial.print(" \ty: ");
  Serial.print(y);  
  Serial.print(" \tz: ");
  Serial.print(z);
  Serial.print("\tG*10^-2");
  delay(100);
}