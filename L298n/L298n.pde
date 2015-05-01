#define ENA 7
#define ENB 8


// Initialize
int PWM1 = 9; // PWM Pin Motor 1
int PoM1 = 10;   // Polarity Pin Motor 1
int PWM2 = 11; // PWM Pin Motor 2  
int PoM2 = 12;   // Polarity Pin Motor 2
 
int ValM1 = 0; // Initial Value for PWM Motor 1 
int ValM2 = 0; // Initial Value for PWM Motor 2
 
int i = 25;     // increment  
boolean goUp = true ; // Used to detect acceleration or deceleration
 
void setup()
{
  pinMode(PWM1, OUTPUT); 
  pinMode(PoM1, OUTPUT); 
  
  pinMode(PWM2, OUTPUT);   
  pinMode(PoM2, OUTPUT);   
  
  digitalWrite(PoM1, LOW) ;   // Both motor with same polarity
  
  digitalWrite(PoM2, LOW) ;
  
  analogWrite(PWM1, ValM1);   // Stop both motors => ValMx = 0
  analogWrite(PWM2, ValM2);    
  
  Serial.begin(9600);         // Used to check value 
}
 
// Main program
void loop()
{
  digitalWrite(ENA, HIGH);
  digitalWrite(ENB, HIGH);  
  
  delay(500);               // give some time to the motor to adapt to new value
  if ((ValM1  < 250) && goUp) // First phase of acceleration
  {
      ValM1 = ValM1 + i;     // increase PWM value => Acceleration
      ValM2 = ValM2 + i;      
  }
  else
  {
    goUp = false ;            // Acceleration completed
    ValM1 = ValM1 - i;       // Decrease PWM => deceleration
    ValM2 = ValM2 - i;     
    if (ValM1  < 75)          // My motor made fanzy noise below 70 
    {                         // One below 75, I set to 0 = STOP
       ValM1 = 0;
       ValM2 = 0;
       goUp = true;          // deceleration completed
    }
  }
  
  if ((ValM1 > 75) && (ValM1< 255))  // If PWM values are OK, I send to motor controller
  {
    analogWrite(PWM1, ValM1);  
    analogWrite(PWM2, ValM2);
  }  
  
  Serial.print(ValM1);        // Debug. Print Value Motor 1
  Serial.print("\t");         // Print tab
  Serial.println(ValM2);      // Print Value Motor 2 to Serial
  
  delay(5000);
  
  // all outputs to stepper off
  digitalWrite(ENA, LOW);
  digitalWrite(ENB, LOW);  
  
}
