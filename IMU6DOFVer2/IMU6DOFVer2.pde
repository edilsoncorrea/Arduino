#include <Wire.h>
#include <ADXL345.h>
#include <L3G4200D.h>

#define RAD_TO_DEG 57.295779513082320876798154814105

L3G4200D gyro;
ADXL345 acc;

//gyros
int gyroZeroX;//x-axis
float gyroXadc;
float gyroXrate;
float gyroXangle;

int gyroZeroY;//y-axis
float gyroYadc;
float gyroYrate;
float gyroYangle;

int gyroZeroZ;//z-axis
float gyroZadc;
float gyroZrate;
float gyroZangle;


//accelerometers
int accZeroX;//x-axis
float accXadc;
float accXval;
float accXangle;

int accZeroY;//y-axis
float accYadc;
float accYval;
float accYangle;

int accZeroZ;//z-axis
float accZadc;
float accZval;
float accZangle;

//Results
float xAngle;
float yAngle;
float compAngleX;
float compAngleY;

float R;//force vector
//Used for timing
unsigned long timer=0;
unsigned long dtime=0;

void setup()
{
  acc.begin();
  gyro.begin();
  
  analogReference(EXTERNAL); //3.3V
  Serial.begin(115200);
  delay(100);//wait for the sensor to get ready

  
  //calibrate all sensors in horizontal position
  gyroZeroX = calibrateGyroX();
  gyroZeroY = calibrateGyroY();  
  gyroZeroZ = calibrateGyroZ();
  
  accZeroX = calibrateAccX();
  accZeroY = calibrateAccY();
  accZeroZ = calibrateAccZ();
  
  timer=millis();//start timing
}

void loop()
{ 
  gyroXadc   = gyro.getX();
  gyroXrate  = (gyroXadc - gyroZeroX) / 1.0323; //(gyroXadc-gryoZeroX)/Sensitivity - in quids              Sensitivity = 0.00333/3.3*1023=1.0323
  gyroXangle = gyroXangle + gyroXrate * dtime / 1000;//Without any filter
  
  gyroYadc   = gyro.getY();
  gyroYrate  = (gyroYadc - gyroZeroY) / 1.0323;//(gyroYadc-gryoZeroX)/Sensitivity - in quids              Sensitivity = 0.00333/3.3*1023=1.0323
  gyroYangle = gyroYangle + gyroYrate * dtime / 1000;//Without any filter
  
  gyroZadc   = gyro.getZ();
  gyroZrate  = (gyroZadc - gyroZeroZ) / 1.0323;//(gyroZadc-gryoZeroX)/Sensitivity - in quids              Sensitivity = 0.00333/3.3*1023=1.0323
  gyroZangle = gyroZangle + gyroZrate * dtime / 1000;//Without any filter
  
  acc.read();
  
  accXadc = acc.getGX();
  accXval = (accXadc - accZeroX) / 102.3;//(accXadc-accZeroX)/Sensitivity - in quids              Sensitivity = 0.33/3.3*1023=102,3
  
  accYadc = acc.getGY();
  accYval = (accYadc-accZeroY) / 102.3;//(accXadc-accZeroX)/Sensitivity - in quids              Sensitivity = 0.33/3.3*1023=102,3
  
  accZadc = acc.getGZ();
  accZval = (accZadc-accZeroZ)/102.3;//(accXadc-accZeroX)/Sensitivity - in quids              Sensitivity = 0.33/3.3*1023=102,3
  accZval++;//1g in horizontal position
  
  R = sqrt(pow(accXval, 2) + pow(accYval, 2) + pow(accZval, 2)); //the force vector
  
  accXangle = acos(accXval / R) * RAD_TO_DEG - 90;
  accYangle = acos(accYval / R) * RAD_TO_DEG - 90;
  accZangle = acos(accZval / R) * RAD_TO_DEG;
  
/*  //used for debugging
  Serial.print(gyroZrate,0);Serial.print("\t");
  Serial.print(gyroZrate,0);Serial.print("\t");
  Serial.print(gyroZrate,0);Serial.print("\t");

  Serial.print(gyroXangle,0);Serial.print("\t");
  Serial.print(gyroYangle,0);Serial.print("\t");
  Serial.print(gyroZangle,0);Serial.print("\t");

  Serial.print(accXval,2);Serial.print("\t");
  Serial.print(accYval,2);Serial.print("\t");
  Serial.print(accZval,2);Serial.print("\t");

  Serial.print(accXangle,0);Serial.print("\t");
  Serial.print(accYangle,0);Serial.print("\t");
  //Serial.print(accZangle,0);Serial.print("\t");
*/
  
  dtime = millis() - timer;
  timer = millis();
  
  compAngleX = (0.02 * (compAngleX + (gyroXrate * dtime / 1000))) + (0.98 * (accXangle));
  compAngleY = (0.02 * (compAngleY + (gyroYrate * dtime / 1000))) + (0.98 * (accYangle));
 
  xAngle = kalmanCalculateX(accXangle, gyroXrate, dtime);
  yAngle = kalmanCalculateY(accYangle, gyroYrate, dtime);
  

  Serial.print(compAngleX, 0);Serial.print("\t");
  Serial.print(compAngleY, 0);Serial.print("\t");


  //Serial.print(xAngle,0);Serial.print("\t");
  //Serial.print(yAngle,0);Serial.print("\t");


  Serial.println("");

  //processing();  
}
