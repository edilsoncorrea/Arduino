#include "WProgram.h"
#include <arduino2lego.h>
#include <a2lsymbols.h>

//components (globals)
void setup();
void loop();
void out();
NXTMotor  ml = NXTMotor(9, 6, 3);   //has encoder!
NXTMotor  mr = NXTMotor(10, 11, 0); //no encoder!
TwoNXTMotors  m = TwoNXTMotors(&ml, &mr);
EpsonGyro gyro = EpsonGyro();
LED l = LED(13);

//matrixes
const float matr_K2[ROW_A] = {    -51.5059,  -28.7684,  -56.4789,   -5.0665 };
const float matr_K[ROW_A] = {    -51.5059,  -28.7684,  -56.4789,   -5.0665 };
const float matr_Kold[ROW_A] = {    -43.2519,  -24.3372,  -48.2722,   -4.1822 };
                       
float state[4] = {0, 0, 0, 0};   //state vector
float force = 0;

//time variables
long now = 0;
long last = 0;

//position variables
float posnow = 0;
float poslast = 0;
float lin_speed = 0;


void setup() {
  Serial.begin(9600);
  
  //setup encoder
  attachInterrupt(SENSEPIN-2, out, CHANGE);

  //setup sensor
  gyro.calibrate();
  pinMode(BUTTONPIN, INPUT);
  
  //wait push of a button
  l.on();
  while(digitalRead(BUTTONPIN) == LOW) delay(50);
  l.off();
}

void loop() {
    /* 
     * ARDUWAY MAIN CYCLE
     */
    
    // time deal
    now = millis();
    while( now - last < mTs ) {   //wait until 4 microseconds elapse
      now = millis();
    }
    last = now;
    
    /* 
     * STATE VARIABLES UPDATE
     */
    // speed update
    posnow = m.getMetres();
    lin_speed = ( posnow - poslast )*1000 / mTs;  // m/s
    poslast = posnow;
    
    // variables update
    state[0] = m.getMetres();     //two sensors (x and theta')
    state[1] = lin_speed; 
    state[2] = gyro.getRad();
    state[3] = gyro.updateAngSpeed();
    if(state[1]<0.05 && state[1]>-0.05) l.off();
    else l.on();
   
    /* 
     *  CONTROLLER ACTION
     */
    force = 0;
    for(int i = 0; i < 4; i++) { //controller action
      force =  force + matr_K[i]*state[i];
    }
    force = (-1)*force*30; //TODO check motor gain, 27=ok
    //if(force < 170 && force > -170) l.on();
    //else l.off();
    m.setSpeed((int) (force));
    
}


void out() {
  int val2 = digitalRead(2);
  int val3 = digitalRead(3);
  if ((val2==LOW && val3==HIGH) || (val2==HIGH && val3==LOW)) { 
    m.decreasePos();
    //l.off();
  }
  else {
    m.increasePos();
    //l.on();
  }
} 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

