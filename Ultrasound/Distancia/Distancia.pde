#include <SerialLCD.h>
#include <Ultrasonic.h>

SerialLCD LCD;

Ultrasonic ultrasonic(8, 9);

// Example 45.1 - tronixstuff.wordpress.com - CC by-sa-nc
// Connect Ping))) signal pin to Arduino digital 8
int signal = 8;
int signalIn = 9;

int distance;
unsigned long pulseduration=0;

void setup()
{
  Serial.begin(9600);
  
  LCD.init();
  
  delay(2000);

  LCD.clear();

  //pinMode(signal, OUTPUT);
  //pinMode(signalIn, INPUT);

}

void measureDistance()
{
  // set output to LOW
  digitalWrite(signal, LOW);

  delayMicroseconds(5);

  // now send the 5uS pulse out to activate Ping)))
  digitalWrite(signal, HIGH);
  delayMicroseconds(5);
  digitalWrite(signal, LOW);

  // finally, measure the length of the incoming pulse
  pulseduration = pulseIn(signalIn, HIGH);
}
void loop()
{
  // get the raw measurement data from Ping)))
  //measureDistance();

  // divide the pulse length by half
  //pulseduration = pulseduration / 2; 

  // now convert to centimetres. We're metric here people...
  //distance = int(pulseduration / 29);

  // Display on serial monitor
  //Serial.print("Distancia - ");
  //Serial.print(distance);
  //Serial.print(" cm");
  
  distance = ultrasonic.Ranging(); 

  LCD.clear();

  LCD.setCursor(2, 4);
  LCD.write("Distancia");

  LCD.setCursor(3, 9); 
  LCD.write(distance);
  
  LCD.setCursor(4, 8);
  LCD.write("cm");
  
  delay(500);
  
  
}

