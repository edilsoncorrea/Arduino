/****************************************************************************************************************
 * acceleroMMA7361.h - Library for retrieving data from the MMA7361 accelerometer. Only tested with Duemilanove *
 * Following functions need improving. I asumed the output to be linear (it is nearly linear but not really).   *
 * I also asumed the Arduino input to be scaled 0-5V I also 'hard pinned' the G-Selector pin to 6G mode (HIGH)  *
 * so nothing can be found here about 1.5G sensitivity (it gave too much noise imho after easy filtering)       *
 * begin variables                                                                                              *
 *  -int sleepPin: number indicating to which pin the sleep port is attached.       DIGITAL OUT                 *
 *  -int selfTestPin: number indicating to which pin the selftest port is attached. DIGITAL OUT                 *
 *  -int zeroGPin: number indicating to which pin the ZeroGpin is connected to.     DIGITAL IN                  *
 *  -int xPin: number indicating to which pin the x-axis pin is connected to.       ANALOG IN                   *
 *  -int yPin: number indicating to which pin the y-axis  pin is connected to.      ANALOG IN                   *
 *  -int zPin: number indicating to which pin the z-axis  pin is connected to.      ANALOG IN                   *
 *  -int offset: array indicating the G offset on the x,y and z-axis                                            *
 * When you use begin() without variables standard values are loaded:A0,A1,A2 as input for X,Y,Z                *
 *                                                 and digital pins 13,12,11 for sleep, selftest and zeroG      *
 * Functions currently present:                                                                                 *
 *  -getXRaw(): Returns the raw data from the X-axis analog I/O port of the Arduino as an integer               *
 *  -getYRaw(): Returns the raw data from the Y-axis analog I/O port of the Arduino as an integer               *
 *  -getZRaw(): Returns the raw data from the Z-axis analog I/O port of the Arduino as an integer               *
 *  -getXVolt(): Returns the voltage in miliVolts from the X-axis analog I/O port of the Arduino as a integer   *
 *  -getYVolt(): Returns the voltage in miliVolts from the Y-axis analog I/O port of the Arduino as a integer   *
 *  -getZVolt(): Returns the voltage in miliVolts from the Z-axis analog I/O port of the Arduino as a integer   *
 *  -getXAccel(): Returns the acceleration of the X-axis as a int (1G = 100.00)                                 *
 *  -getYAccel(): Returns the acceleration of the Y-axis as a int (1G = 100.00)                                 *
 *  -getXAccel(): Returns the acceleration of the Z-axis as a int (1G = 100.00)                                 *
 *  -setOffSets( int offSetX, int offSetY, int offSetZ): Sets the offset values for the x,y & z  axxis.         *
 *    The parameters are the offsets expressed in G-force (100 = 1G) offsets are added to the raw datafunctions *
 *  -callibrate(): Sets X and Y values via setOffsets to zero. The Z axis will be set to 100 = 1G               *
 *    WARNING WHEN CALLIBRATED YOU HAVE TO SEE THE Z-AXIS IS PERPEnDICULAR WITH THE EARTHS SURFACE              *
 *  -setARefVoltage(double _refV): Sets the AREF voltage to external, ( now only takes 3.3 or 5 as parameter)   *
 *    default is 5 when no AREF is used. When you want to use 3.3 AREF, put a wire between the AREF pin and the *
 *    3.3V VCC pin. This increases accuracy                                                                     *
 *  -setAveraging(int avg): Sets how many samples have to be averaged in getAccel default is 10                 *
 ****************************************************************************************************************
 * Version History:                                                                                             *
 *  Version 0.1: -get raw values                                                                                *
 *  Version 0.2: -get voltages and G forces                                                                     *
 *  Version 0.3: -removed begin parameters offset                                                               *
 *               -added public function setOffSets(int,int,int)                                                 *
 *               -added a private variable _offSets[3] containing the offset on each axis                       *
 *               -changed long and double return values of private and public functions to int                  *
 *  Version 0.4: -added callibrate                                                                              *
 *  Version 0.5: -added setARefVoltage                                                                          *
 *               -added setAveraging                                                                            *
 *               -added a default begin function                                                                *
 ****************************************************************************************************************
 * Created by Jef Neefs: Suggestions, questions or comments please contact me                                   *
 *  -mail: neefsj at gmail dot com                                                                              *
 *  -skype: studioj                                                                                             *
 ***************************************************************************************************************/
#include <WProgram.h>
#include <AcceleroMMA7361.h>

AcceleroMMA7361::AcceleroMMA7361()
{
}

void AcceleroMMA7361::begin()
{
  begin(13, 12, 11, A0, A1, A2);
}

void AcceleroMMA7361::begin(int sleepPin, int selfTestPin, int zeroGPin, int xPin, int yPin, int zPin)
{
  pinMode(sleepPin, OUTPUT);
  pinMode(selfTestPin, OUTPUT);
  pinMode(zeroGPin, INPUT);
  pinMode(xPin, INPUT);
  pinMode(yPin, INPUT);
  pinMode(zPin, INPUT);
  digitalWrite(sleepPin,HIGH);
  digitalWrite(selfTestPin,LOW);
  _sleepPin = sleepPin;
  _selfTestPin = selfTestPin;
  _zeroGPin = zeroGPin;
  _xPin = xPin;
  _yPin = yPin;
  _zPin = zPin;
  setOffSets(0,0,0);
  setARefVoltage(5);
  setAveraging(10);
}

void AcceleroMMA7361::setOffSets(int xOffSet, int yOffSet, int zOffSet)
{
  if (_refVoltage==3.3)
  {
    _offSets[0]= map(xOffSet,0,3300,0,1024);
    _offSets[1]= map(yOffSet,0,3300,0,1024);
    _offSets[2]= map(zOffSet,0,3300,0,1024);
  }
 else
 { 
    _offSets[0]= map(xOffSet,0,5000,0,1024);
    _offSets[1]= map(yOffSet,0,5000,0,1024);
    _offSets[2]= map(zOffSet,0,5000,0,1024);
 }
}

void AcceleroMMA7361::setARefVoltage(double refV)
{
  _refVoltage = refV;
  if (refV == 3.3)
  {
    analogReference(EXTERNAL);
  }  
}

void AcceleroMMA7361::setAveraging(int avg)
{
  _average = avg;
}

int AcceleroMMA7361::getXRaw()
{
  return analogRead(_xPin)+_offSets[0];
}

int AcceleroMMA7361::getYRaw()
{
  return analogRead(_yPin)+_offSets[1];
}

int AcceleroMMA7361::getZRaw()
{
  return analogRead(_zPin)+_offSets[2];
}

int AcceleroMMA7361::getXVolt()
{
  return _mapMMA7361V(getXRaw());
}

int AcceleroMMA7361::getYVolt()
{
  return _mapMMA7361V(getYRaw());
}

int AcceleroMMA7361::getZVolt()
{
  return _mapMMA7361V(getZRaw());
}

int AcceleroMMA7361::getXAccel()
{
  int sum = 0;
  for (int i = 0;i<_average;i++)
  {
    sum = sum + _mapMMA7361G(getXRaw());
  }
  return sum/_average;
}

int AcceleroMMA7361::getYAccel()
{
  int sum = 0;
  for (int i = 0;i<_average;i++)
  {
    sum = sum + _mapMMA7361G(getYRaw());
  }
  return sum/_average;
}

int AcceleroMMA7361::getZAccel()
{
  int sum = 0;
  for (int i = 0;i<_average;i++)
  {
    sum = sum + _mapMMA7361G(getZRaw());
  }
  return sum/_average;
}

int AcceleroMMA7361::_mapMMA7361V(int value)
{
  if (_refVoltage==3.3)
  {
    return map(value,0,1024,0,3300);
  }
 else
 { 
   return map(value,0,1024,0,5000);
 }
}

int AcceleroMMA7361::_mapMMA7361G(int value)
{
  if (_refVoltage==3.3)
  {
    return map(value,0,1024,-825,800);
  }
  else
  {
    return map(value,0,1024,-800,1600);
  }
}

void AcceleroMMA7361::callibrate()
{
  Serial.print("\nCallibrating MMA7361011");
  double var = 5000;
  double sumX = 0;
  double sumY = 0;
  double sumZ = 0;
  for (int i = 0;i<var;i++)
  {
    sumX = sumX + getXVolt();
    sumY = sumY + getYVolt();
    sumZ = sumZ + getZVolt();
    if (i%100 == 0)
    {
      Serial.print(".");
    }
  }
  setOffSets(1670 - sumX / var,1670 - sumY / var, + 1876 - sumZ / var);
  Serial.print("\nDONE");
}

//a posibility i was thinking about maybe implemented properly later

/*void AcceleroMMA7361::setPolarity(boolean xPol, boolean yPol, boolean zPol)
{
  for (int i = 0; i<3; i++)
  {
    _polarities[i]=true;
  }
  if (xPol ==  false)
  {
    _polarities[0] = -1;
  } 
  if (yPol ==  false)
  {
    _polarities[1] = -1;
  }
  if (zPol ==  false)
  {
    _polarities[2] = -1;
  }
}*/