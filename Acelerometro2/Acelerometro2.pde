/* MMA7361 Accelerometer Test                                          BroHogan 12/10/10
 * CAUTION! input pins (Sleep, G-Select, Self-Test) are 3.3V max for HIGH 
 * Z should read 1g at rest. The 0g-Detect pin goes high when ALL THREE axes are at 0g.
 * X & Y Bandwidth: 400Hz (Z=300Hz) Output Impedance: 32K
 *   1.5g setting:  Sensitivity: 800 mV/g   -1g = 850mV    0g = 1650mV   1g = 2450mV
 *     6g setting:  Sensitivity: 206 mV/g   -1g = 1444mV   0g = 1650mV   1g = 1856mV
 * mV/analogRead unit = Aref V(3.3) / 1024.0
 * g = [mV/analogRead unit] * ([units] - ([Aref/2]) / [mvPerG]
 * deg. = asin (mVout - 1650mv) / 800mV)  (double asin (double x) ) in radians
 * 0-60 Time = 26.8224 / (g * 9.81) [60MPH = 26.8224 m/s, g = 9.81 m/s/s]
 * Added digitalSmooth by  Paul Badger 2007 - big improvement!
 * (see www.arduino.cc/playground/Main/DigitalSmooth)
 * SETUP: 
 * Best to use the 3.3V pin on the (Moderndevices) MMA7361 for ARef
 * TODO:
 * >1g && <-1g angle calc gets wonky (fixed).
 */

#include "WProgram.h"                   // needed for IDE to understand a "byte"!

#define X_PIN       2                   // X Axis input (analog pin #) 
#define Y_PIN       1                   // Y Axis input (analog pin #) 
#define Z_PIN       3                   // Z Axis input (analog pin #) 
#define GSEL_PIN    14                  // pin on accel for range jmpr - LOW = 1.5 g range
#define ZERO_G_PIN  9                   // HIGH when X,Y,Z = 0 G
#define SLEEP_PIN   4                   // CAUTION 3.3V input pin - LOW to enable Sleep Mode

#define AREF_V      5000  //3280        // Aref voltage in mV BEST TO THE 3.2V ON THE ACCEL
#define LOW_RANGE   800                 // Sensitivity for 1.5 g range in mV/g
#define HIGH_RANGE  206                 // Sensitivity for 6 g range in mV/g
#define SAMPLES     13                  // SAMPLES should  be an odd number, no smaller than 3

int xSmoothArray [SAMPLES];             // array for holding X values for smoothing 
int ySmoothArray [SAMPLES];             // array for holding Y values for smoothing 
int zSmoothArray [SAMPLES];             // array for holding Z values for smoothing 
int xOffset, yOffset, zOffset;          // used to hold calculated offsets

int Acc_X, Acc_Y, Acc_Z;                // raw accel output
float Acc_Xg, Acc_Yg, Acc_Zg;           // accel output expressed in mg's
float Xdeg, Ydeg, Zdeg;                 // angle expressed in degrees
float mVperUnit;                        // calculated mV / analogRead unit
float mvPerG;                           // Sensitivity for current range in mV/g
float zeroTo60;                         // seconds for 0-60MPH acceleration equivalent
boolean lowRange = true;                // 1.5 g max if true - else 6g range 


void setup(){
  Serial.begin(9600);
  pinMode(ZERO_G_PIN,INPUT);            // HIGH when X,Y,Z = 0 G
  pinMode(GSEL_PIN,INPUT);              // LOW = 1.5 g range
  //analogReference(EXTERNAL);            // set if Aref pin wired to 3.3V source
  mVperUnit = AREF_V / 1024.0;          // calc mV / analogRead unit

  Serial.println("Lay flat for calibration!");
  CalAccel();                           // calc offsets
  delay (1000);
}


void loop(){
  //lowRange = !digitalRead(GSEL_PIN);    //  read pin on accel for range jmpr - If LOW set flag true
  lowRange = true;                      // USE THIS IF NOT READING JMPR ON ACCEL
  if (lowRange)mvPerG = LOW_RANGE;      // Set the mV/g based on the current range
  else mvPerG = HIGH_RANGE;

  Read_Accel();                         // read the X,Y,Z values from the MMA7361
  Disp_Vals();                          // display X,Y,Z g values
  delay(3000);
}

void Read_Accel(){
  //digitalSmooth(Acc_X,xSmoothArray,true); // reset running average
  for (int i=0; i< SAMPLES +2; i++){    // make a series of samples for smoothing
    Acc_X = analogRead(X_PIN) - xOffset;             // read the X Axis and apply offset
    Acc_X = digitalSmooth(Acc_X,xSmoothArray,false); // smooth X axis
    Acc_Y = analogRead(Y_PIN) - yOffset;             // read the Y Axis and apply offset
    Acc_Y = digitalSmooth(Acc_Y,ySmoothArray,false); // smooth Y axis
    Acc_Z = analogRead(Z_PIN) - zOffset;             // read the Z Axis and apply offset
    Acc_Z = digitalSmooth(Acc_Z,zSmoothArray,false); // smooth Z axis
    delay(5);                           // need this delay for 200Hz max sample rate
  }
  // now calc g's and angle . . .
  if (Acc_X >= 512) Acc_Xg = mVperUnit * (Acc_X - 512) / mvPerG;
  else Acc_Xg = ((512 - Acc_X) * (mVperUnit) / mvPerG) * -1;
  if (Acc_Xg >= -1.0 && Acc_Xg <= 1.0) Xdeg = asin(Acc_Xg) * (180.0/PI);
  else Xdeg = 0;
    zeroTo60 = 26.8224 / (Acc_Xg * 9.81);

  if (Acc_Y >= 512) Acc_Yg = mVperUnit * (Acc_Y - 512) / mvPerG;
  else Acc_Yg = ((512 - Acc_Y) * (mVperUnit) / mvPerG) * -1;
  if (Acc_Yg >= -1.0 && Acc_Yg <= 1.0) Ydeg = asin(Acc_Yg) * (180.0/PI);
  else Ydeg = 0;

  if (Acc_Z >= 512) Acc_Zg = mVperUnit * (Acc_Z - 512) / mvPerG;
  else Acc_Zg = ((512 - Acc_Z) * (mVperUnit) / mvPerG) * -1;
  Acc_Zg += 1.0;                        // add 1 g back into axis
  if (Acc_Zg >= -1.0 && Acc_Zg <= 1.0) Zdeg = asin(Acc_Zg) * (180.0/PI);
  else Zdeg = 0;
}

void Disp_Vals(){
  Serial.print("milli G's");
  Serial.print("\tX:");
  Serial.print(Acc_Xg * 1000,DEC);
  Serial.print("\tY:");
  Serial.print(Acc_Yg * 1000,DEC);
  Serial.print("\tZ:");
  Serial.println(Acc_Zg * 1000,DEC);

  Serial.print("Degrees  ");
  Serial.print("\tX:");
  Serial.print(Xdeg,DEC);
  Serial.print("\tY:");
  Serial.print(Ydeg,DEC);
  Serial.print("\tZ:");
  Serial.println(Zdeg,DEC);
  Serial.println("");

  if (zeroTo60 > 1 && zeroTo60 < 50){   // only use for zeroTo60 to eliminate noise
    // Serial.print("Sec 0-60: ");
    // Serial.println(zeroTo60,DEC); // zeroTo60 or Xdeg
  }
}



int digitalSmooth(int rawIn, int *sensSmoothArray, bool Reset){ 
  // modified from: www.arduino.cc/playground/Main/DigitalSmooth
  int j, k, temp, top, bottom;
  long total;
  static int i;
  static int sorted[SAMPLES];
  boolean done;

  if (Reset) {                    // added to reset running as an option
    for (j=0; j<SAMPLES; j++){
      sensSmoothArray[j] = 0;
      sorted[j] = 0;
    }
    i = 0;
    return 0;
  }

  i = (i + 1) % SAMPLES;    // increment counter and roll over if necc. -  % (modulo operator) rolls over variable
  sensSmoothArray[i] = rawIn;                 // input new data into the oldest slot

  for (j=0; j<SAMPLES; j++){     // transfer data array into anther array for sorting and averaging
    sorted[j] = sensSmoothArray[j];
  }

  done = 0;                // flag to know when we're done sorting              
  while(done != 1){        // simple swap sort, sorts numbers from lowest to highest
    done = 1;
    for (j = 0; j < (SAMPLES - 1); j++){
      if (sorted[j] > sorted[j + 1]){     // numbers are out of order - swap
        temp = sorted[j + 1];
        sorted [j+1] =  sorted[j] ;
        sorted [j] = temp;
        done = 0;
      }
    }
  }

  // throw out top and bottom 15% of samples - limit to throw out at least one from top and bottom
  bottom = max(((SAMPLES * 15)  / 100), 1); 
  top = min((((SAMPLES * 85) / 100) + 1  ), (SAMPLES - 1));   // the + 1 is to make up for asymmetry caused by integer rounding
  k = 0;
  total = 0;
  for ( j = bottom; j< top; j++){
    total += sorted[j];  // total remaining indices
    k++; 
  }
  return total / k;    // divide by number of samples
}

void CalAccel(){ // make 30 iterations, average, and save offset
  //otherwise you get an overflow. But 60 iterations should be fine
  xOffset=0;
  yOffset=0;
  zOffset=0;
  for (int i=1; i <= 30; i++){        
    xOffset += analogRead(X_PIN);    
    yOffset += analogRead(Y_PIN);
    zOffset += analogRead(Z_PIN);
    delay(5);                           // need delay for 200Hz sample rate
  }
  xOffset /=30;                         // get average
  xOffset -= 512;                       // 0g = 512 raw
  yOffset /=30;
  yOffset -= 512;
  zOffset /=30;                         // this also removes the 1g static accel
  zOffset -= 512;                       // added back later
}
