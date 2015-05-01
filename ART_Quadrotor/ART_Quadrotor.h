#include <WProgram.h>

#define GRAVITY 408 // 1g on the accelerometer
#define BAUDRATE 38400
#define MAGNETOMETER 0

#define LEDYELLOW 36
#define LEDRED 35
#define LEDGREEN 37
#define SWITCH1 41
#define SWITCH2 40

#define MINTHROTTLE 1200
#define MIDCHANNEL 1500

#define Gyro_Gain_X 0.4  //X axis Gyro gain
#define Gyro_Gain_Y 0.41 //Y axis Gyro gain
#define Gyro_Gain_Z 0.41 //Z axis Gyro gain

// Define macros //
#define ToRad(x) (x*0.01745329252)  // *pi/180
#define ToDeg(x) (x*57.2957795131)  // *180/pi
#define Gyro_Scaled_X(x) x*ToRad(Gyro_Gain_X) //Return the scaled ADC raw data of the gyro in radians for second
#define Gyro_Scaled_Y(x) x*ToRad(Gyro_Gain_Y) //Return the scaled ADC raw data of the gyro in radians for second
#define Gyro_Scaled_Z(x) x*ToRad(Gyro_Gain_Z) //Return the scaled ADC raw data of the gyro in radians for second

// PID constants
float Kproll = 0.8;
float Kiroll = 0.6;
float Kdroll = 0.4;
float Kppitch = 0.8;
float Kipitch = 0.6;
float Kdpitch = 0.4;
float Kpyaw = 2.0;
float Kiyaw = 0.0;
float Kdyaw = 0.0;
float Kpaltitude = 1.6;  //2
float Kialtitude = 0.1;  //0.1
float Kdaltitude = 1.4;  //1.2

// Define vars //
float loopDt = 0.02; // This will be changed per loop
long timer = 0;
long telemetryTimer = 0;
long compassReadTimer = 0;
long sonarTimer = 0;
long otherTimer = 0;

int motorsArmed = 0;
float desiredAltitude = 0;
float sonarAltitude = 0;
int sonarData[8];
float pressureAltitude = 0;
float groundPressureAltitude = 0;
float actualAltitude = 0; // This is used for PID control
byte currentSonarData = 0;
int landingAltitude = 0;
int altitudeThrottle = 0;
bool holdingAltitude = false;
bool isLanding = false;
bool isManualControl = true;
long landingTime = 0;

float controlRoll = 0;
float controlPitch = 0;
float controlYaw = 0;
float controlAltitude = 0;

float rollError;
float rollErrorOld;
float rollI;
float rollD;
float pitchError;
float pitchErrorOld;
float pitchI;
float pitchD;
float yawError;
float yawErrorOld;
float yawI;
float yawD;
float altitudeError;
float altitudeErrorOld;
float altitudeI;
float altitudeD;

// ADC storage
int ADC_Ch[6];
int ADC_Offset[6];

int accelOffset[3] = {2073,2056,2010};
int gyroOffset[3] = {1659,1618,1673};

float Omega[3]= {0,0,0};

// Transmitter Data Storage
int RCInput[8];
int pilotRoll = 0;
int pilotRollOld = 0;
int pilotPitch = 0;
int pilotPitchOld = 0;
int pilotYaw = 0;
int pilotYawOld = 0;
int pilotThrottle = 0;
int throttle = 0;

// DCM PID Values (these will be hard code initialized)
float KpDCM_rollpitch = .002;
float KiDCM_rollpitch = .0000005;
float KpDCM_yaw = 1.5;
float KiDCM_yaw = .00005;

// Vehicle orientation angles
float roll;
float pitch;
float yaw;

int motor[4];

// ROS
ros::NodeHandle nh;

// Should consider switching to quaternion or making custom datatype
geometry_msgs::Vector3 ros_rot;
std_msgs::Int16 ros_alt;
ros::Publisher rotation("/arduino/rotation", &ros_rot);
ros::Publisher altitude("/arduino/altitude", &ros_alt);

// Subscription
ROS_CALLBACK(respondToArmMotors, std_msgs::Bool, new_motors)
  motorsArmed = new_motors.data;
}
ROS_CALLBACK(respondToSetAltitude, std_msgs::Int16, new_altitude)
  desiredAltitude = new_altitude.data;     // Desired Altitude
  if (desiredAltitude <= 0) {
    if ( isManualControl == false ) {
      isLanding = true;
      landingAltitude = sonarAltitude;
      landingTime = millis();
    }
  } 
  else {
    isManualControl = false;
    throttle = 1400;                      
  }
  holdingAltitude = true;
}
ROS_CALLBACK(respondToSetWaypoint, geometry_msgs::Pose2D, new_pose)
  digitalWrite(LEDGREEN, HIGH);
  //delay(200); CANNOT PUT DELAY HERE! DELAYS ARE BLOCKING!
  digitalWrite(LEDGREEN, LOW);
}

ros::Subscriber command_motors("/arduino/arm_motors", &new_motors, respondToArmMotors );
ros::Subscriber command_altitude("/arduino/set_altitude", &new_altitude, respondToSetAltitude );
ros::Subscriber command_waypoint("/arduino/set_waypoint", &new_pose, respondToSetWaypoint );
