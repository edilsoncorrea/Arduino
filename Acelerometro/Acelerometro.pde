#include <avr/eeprom.h>

#define PITCH_TRIM 0			// deg * 100 : allows you to offset bad IR sensor placement
#define ROLL_TRIM 0				// deg * 100 : allows you to offset bad IR sensor placement
#define IR_MAX_FIX .88
#define EE_IR_MAX 0x3A2
#define AIRSPEED_PIN 3		// Need to correct value
#define AIRSPEED_RATIO 0.1254	// If your airspeed is under-reporting, increase this value to something like .2
#define AIRSPEED_CRUISE 13		// meters/s : Speed to try and maintain - You must set this value even without an airspeed sensor!
#define AIRSPEED_CRUISE 13		// meters/s : Speed to try and maintain - You must set this value even without an airspeed sensor!

long analog0				= 511;		// Thermopiles - Pitch
long analog1				= 511;		// Thermopiles - Roll
long analog2				= 511;		// Thermopiles - Z
int ir_max				= 300;		// used to scale Thermopile output to 511
int ir_max_save				= 300;		// used to scale Thermopile output to 511
long roll_sensor			= 0;		// how much we're turning in deg * 100
long pitch_sensor			= 0;		// our angle of attack in deg * 100

float 	airpressure_raw		= 511;		// Airspeed Sensor - is a float to better handle filtering
int 	airpressure_offset	= 0;		// analog air pressure sensor while still
int 	airpressure		= 0;		// airspeed as a pressure value
float 	airspeed 		= 0; 							// m/s * 100
int	airspeed_cruise		= AIRSPEED_CRUISE * 100;		// m/s * 100 : target airspeed sensor value
float 	airspeed_error		= 0;			// m/s * 100: 

int PinoSleep    = 13;
int PinoSelfTest = 12;
int PinoZeroG    = 11;

long x;
long y;

long MediaX = 0;
long MediaY = 0;

double SomaX = 0;
double SomaY = 0;

int i = 5000;

void setup() 
{ 
  Serial.begin(9600);
  Serial.println("Inicio");

  pinMode(PinoSleep,    OUTPUT);
  pinMode(PinoSelfTest, OUTPUT);
  pinMode(PinoZeroG,    INPUT);
  
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  
  digitalWrite(PinoSleep,    HIGH);
  digitalWrite(PinoSelfTest, LOW);
  
  delay(200);
  
  SomaX = 0;
  SomaY = 0;
  
  for (int j = 0; j < 21; j++)
  {   
    read_XY_sensors();
  
    x = (x_axis() / 100);
    y = (y_axis() / 100);
  
    SomaX = SomaX + x;
    SomaY = SomaY + y;  
    
    delay(100);

  } 
  
  MediaX = SomaX / 20;
  MediaY = SomaY / 20;
  
  SomaX = 0;
  SomaY = 0;
}  


void loop() 
{ 
  i = i + 1;
  
  read_XY_sensors();
  
  x = (x_axis() / 100);
  y = (y_axis() / 100);  
  
  SomaX = SomaX + x;
  SomaY = SomaY + y;  
  
  if ((i % 5) == 0)
  {
    MediaX = SomaX / 5;
    MediaY = SomaY / 5;
    
    SomaX = 0;
    SomaY = 0;    
  }
  
  if (i > 100)
  {
    i = 0;
  }
  
  
  Serial.print("I: ");
  Serial.print(i, DEC);
  
  Serial.print("X: ");
  Serial.print(MediaX, DEC);
    
  Serial.print("     Y: ");
  Serial.println(MediaY, DEC);
  

  delay(50);
}


void read_XY_sensors()
{
  analog0 		= analogRead(0);
  analog1 		= analogRead(1);
  
  roll_sensor  	= getRoll() + ROLL_TRIM;
  pitch_sensor 	= getPitch() + PITCH_TRIM;

  if (analog0 > 511)
  {
    ir_max = max((abs(511 - analog0) * IR_MAX_FIX), ir_max);
    ir_max = constrain(ir_max, 40, 600);
    
    if (ir_max > ir_max_save)
    {
      eeprom_busy_wait();
      eeprom_write_word((uint16_t *)	EE_IR_MAX, ir_max);	// ir_max 
      ir_max_save = ir_max;
    }
  }
}

void read_z_sensor(void)
{
  //Serial.print("ir_max: ");
  //Serial.println(ir_max,DEC);

  //Checks if the roll is less than 10 degrees to read z sensor
  if (abs(roll_sensor) <= 1500)
  {
    analog2 = ((float)analogRead(2) * 0.10) + ((float)analog2 * .90);
    ir_max = abs(511 - analog2) * IR_MAX_FIX;
    ir_max = constrain(ir_max, 40, 600);
  }
}

// in M/S * 100
void read_airspeed(void)
{
  airpressure_raw = ((float)analogRead(AIRSPEED_PIN) * .10) + (airpressure_raw * .90);
  airpressure 	= (int)airpressure_raw - airpressure_offset;
  airpressure 	= max(airpressure, 0);
  airspeed 		= sqrt((float)airpressure / AIRSPEED_RATIO) * 100;

  airspeed_error = airspeed_cruise - airspeed;
}


// returns the sensor values as degrees of roll
//   0 ----- 511  ---- 1023    IR Sensor
// -90Â°       0         90Â°	    degree output * 100
// sensors are limited to +- 60Â° (6000 when you multply by 100)

long getRoll(void)
{
  return constrain((-x_axis() - y_axis()) / 2, -6000, 6000);
}

long getPitch(void)
{
  return constrain((x_axis() - y_axis()) / 2, -6000, 6000);
}

long x_axis(void)// roll
{
  return ((analog1 - 511l) * 9000l) / ir_max;
  //      611 - 511 
  //         100 * 9000 / 100 = 90Â°  low = underestimate  = 36 looks like 90 = flat plane or bouncy plane
  //         100 * 9000 / 250 = 36Â°   				    = 36 looks like 36
  //		   100 * 9000 / 500 = 18Â°  high = over estimate = 36 looks like 18 = crash plane
}

long y_axis(void)// pitch
{
  return ((analog0 - 511l) * 9000l) / ir_max;
}


void zero_airspeed(void)
{
  airpressure_raw = analogRead(AIRSPEED_PIN);
  
  for(int c=0; c < 50; c++)
  {
    delay(20);
    airpressure_raw = (airpressure_raw * .90) + ((float)analogRead(AIRSPEED_PIN) * .10);	
  }
  airpressure_offset = airpressure_raw;

}



/*

 IR sesor looks at the difference of the two readings and gives a value the same = 511
 differnce is +=40Â°
 (temp dif / 40) * 511
 if the top sees the ground its the dif is positive or negative
 
 
 Analog 0 = Pitch sensor
 Analog 0 = Roll sensor - unmarked
 	
 	  					   ^ GROUND
 		285			 	 713
 					 	 P
 			 \			/
 			  \		  /
 				\	/
 				511
 				/	\
 			  /		 \
 			/		  \
 		 P
 	  300				707
 	 			||||
 				||||
 				||||
 			 cable			 
 				
 				
 */

