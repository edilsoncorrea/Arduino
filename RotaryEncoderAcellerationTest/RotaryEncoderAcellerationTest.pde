#include <WProgram.h>  // This include should go first, otherwise does not compile.
#include <TicksPerSecond.h>
#include <RotaryEncoderAcelleration.h>

static const int rotorPinA = 2;	// One quadrature pin
static const int rotorPinB = 3;	// the other quadrature pin

static RotaryEncoderAcelleration rotor;

void UpdateRotor() 
{
  rotor.update();
}

void setup() 
{
  rotor.initialize(rotorPinA, rotorPinB);
  rotor.setMinMax(0, 50000);
  rotor.setPosition(500);
  attachInterrupt(0, UpdateRotor, CHANGE);
  Serial.begin(9600);
}

long lastRotor = 0;
long pos;

void loop() 
{
  pos = rotor.getPosition();

  if (lastRotor != pos) 
  {
		float tps = rotor.tps.getTPS();
		Serial.print(pos);
		Serial.print(" ");
		Serial.println(tps);
	}
	lastRotor = pos;
}

