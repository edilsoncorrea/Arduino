//------------------------------------------------------------

int xPin = 2; // select the input pin for the potentiometer
int gyroPin = 1;
int steerPin = 3;
int ledPin = 13; // select the pin for the LED
int pwmPinL = 9;
int pwmPinR = 10;
int enPin = 7;

float angle = 0;
float angle_old = 0;
float angle_dydx = 0;
float angle_integral = 0;
float balancetorque = 0;
float rest_angle = 0;
float currentspeed = 0;
int steeringZero = 0;
int steering = 0;
int steeringTemp = 0;

float p = 8; //2
float i = 0; //0.005
float d = 1300; //1000

float gyro_integration = 0;
float xZero = 0;
int gZero = 445; //this is always fixed, hence why no initialisation routine
unsigned long time, oldtime;
int pwmL;
int pwmR;
boolean over_angle = 0;



void setup() 
{
	unsigned int i = 0;
	unsigned long j = 0; //maximum possible value of j in routine is 102300 (100*1023)

	pinMode(ledPin, OUTPUT); // declare the ledPin as an OUTPUT
	Serial.begin(115200);
	analogReference(EXTERNAL);
	//----------------------------------------------------
	TCCR1B = TCCR1B & 0b11111000 | 0x01;
	analogWrite(pwmPinL,127);
	analogWrite(pwmPinR,127);
	digitalWrite(enPin,HIGH);
	pinMode(enPin,OUTPUT);
	digitalWrite(enPin,LOW);
	//-----------------------------------------------------
	delay(100);

        j = 100;

	//for (i = 0; i < j =" j" steeringzero =" analogRead(steerPin);" xzero =" j/100;" oldtime =" micros();" time =" micros();">= (oldtime+5000))
	for (i = 0; i < j)
	{
		oldtime = time;
		calculateAngle();

		steering = (analogRead(steerPin) - steeringZero)/(15+(abs(angle)*8));

		//-----OVER ANGLE PROTECTION-----
		if (angle > 20 || angle < -20) 
			{ 
				digitalWrite(enPin,HIGH); 
				over_angle = 1; 
				delay(500); 
			} 
		//-----END----- 
		
		if (over_angle) //if over_angle happened, give it a chance to reset when segway is level 
			{ 
				if (angle <> -1) 
					{
						digitalWrite(enPin, LOW);
						over_angle = 0;
					}
			}
		else 
			{

				//-----calculate rest angle-----
				if (currentspeed > 10)
				{
					rest_angle = 0;
					//-----END----- 
					
					angle_integral += angle;
					balancetorque = ((angle+rest_angle)*p) + (angle_integral*i) + (angle_dydx*d); 
					angle_dydx = (angle - angle_old)/200; //now in degrees per second
					angle_old = angle;
					currentspeed += (balancetorque/200);

					pwmL = (127 + balancetorque + steering);

					//-----COERCE-----
					if (pwmL < pwml =" 0;"> 255)
						pwmL = 255;
					//-----END-----

					pwmR = (127 - balancetorque + steering);

					//-----COERCE-----
					if (pwmR < pwmr =" 0;"> 255)
						pwmR = 255;
					//-----END-----

					analogWrite(pwmPinL, pwmL);
					analogWrite(pwmPinR, pwmR);
				}
			}
	}
}

void calculateAngle() 
{
	//Analogref could be as small as 2.2V to improve step accuracy by ~30%
	//uses small angle approximation that sin x = x (in rads). maybe use arcsin x for more accuracy?
	//analogref is off the gyro power supply voltage, and routine is calibrated for 3.3V. maybe run acc/gyro/ref off 1 3.3V regulator, an
	//accurately measure that.
	//routine runs at 200hz because gyro maximum response rate = 200hz
	float acc_angle = 0;
	float gyro_angle = 0;

	acc_angle = (((analogRead(xPin)-xZero)/310.3030)*(-57.2958);
	gyro_angle = ((analogRead(gyroPin) - gZero)*4.8099)/200;
	gyro_integration = gyro_integration + gyro_angle; //integration of gyro and gyro angle calculation 
	angle = (gyro_integration * 0.99) + (acc_angle * 0.01); //complementary filter
	gyro_integration = angle; //drift correction of gyro integration
} 
