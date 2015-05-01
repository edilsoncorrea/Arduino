/*

 
 This demo uses a L298N dual H-bridge to operate a
 bi-polar stepper motor. The colors are the actual
 color of the wires on several units removed from
 junk printers. 
 
 Numbers such as PM425-048 and PM35s-048.
 
 This also worked on a unipolor stepper such
 as a Portescape s6mo48 from Ebay leaving the red/green
 wires that went to +12 disconnected and operating at 24 volts.
 
 */


#define CW 3
#define CCW 4

#define ENA 7
#define ENB 8

#define black 9  // IN1
#define brown 10  // IN2
#define orange 11  // IN3
#define yellow 12  // IN4



void setup()  {

  DDRB = 0x3f; // Digital pins 8-13 output
  PORTB = 0x00; // all outputs DP8-13 set to off
  
  pinMode(CW, INPUT);
  pinMode(CCW, INPUT);

  digitalWrite(CW, 1); // pullup on
  digitalWrite(CCW,1); // pullup on
 
  
}



void loop() {

  if (!digitalRead(CW)) forward(240, 0);
  if (!digitalRead(CCW)) reverse(240, 0);


} // end loop


void reverse(int i, int j) {

  // Pin 8 Enable A Pin 13 Enable B on
  digitalWrite(ENA, HIGH);
  digitalWrite(ENB, HIGH);

  j = j + 10;
  while (1)   {

    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(j);  
    i--;
    if (i < 1) break;


    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(j);
    i--;
    if (i < 1) break;


    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(j);  
    i--;
    if (i < 1) break;

    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(j);
    i--;
    if (i < 1) break;
  }

  // all outputs to stepper off
  digitalWrite(ENA, LOW);
  digitalWrite(ENB, LOW);

}  // end reverse()



void forward(int i, int j) {

  // Pin 8 Enable A Pin 13 Enable B on
  digitalWrite(ENA, HIGH);
  digitalWrite(ENB, HIGH);

  j = j + 10;
  while (1)   {

    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(j);
    i--;
    if (i < 1) break; 



    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(j);  
    i--;
    if (i < 1) break;

    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(j);
    i--;
    if (i < 1) break;

    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(j);  
    i--;
    if (i < 1) break;


  }

  // all outputs to stepper off
  digitalWrite(ENA, LOW);
  digitalWrite(ENB, LOW);

}  // end forward()
