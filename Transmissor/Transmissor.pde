#include <EasyTransfer.h>

//create two objects
EasyTransfer Transmissor; 

struct SEND_DATA_STRUCTURE
{
  int Throtle;
  int Rudd;
  int Eleron;
  int Ailevon;
  int Button;
  int Sequencial; 
};

//give a name to the group of data
SEND_DATA_STRUCTURE txdata;

int i;

void setup()
{
  delay(200);
  Serial.begin(115200);
  
  delay(200);

  //start the library, pass in the data details and the name of the serial port. Can be Serial, Serial1, Serial2, etc.
  Transmissor.begin(details(txdata), &Serial);
  
  delay(200);
 
  i = 0;
}

void loop()
{
  
  txdata.Throtle = 1023 - analogRead(A3);
  txdata.Rudd    = analogRead(A2);
  txdata.Ailevon = analogRead(A0);
  txdata.Eleron  = 1023 - analogRead(A1);

  txdata.Button  = HIGH;
  txdata.Sequencial = i; 
 
  i++;
  
  if (i > 65535) 
    i = 0;
  
  //then we will go ahead and send that data out
  Transmissor.sendData();
  
  
//  Serial.print("Throtle: ");
//  Serial.print(txdata.Throtle, DEC);
//    
//  Serial.print("  Rudd: ");
//  Serial.print(txdata.Rudd, DEC);
//
//  Serial.print("  Eleron: ");
//  Serial.print(txdata.Eleron, DEC);
//  
//  Serial.print("  Ailevon: ");
//  Serial.println(txdata.Ailevon, DEC);
  
  //delay for good measure
  delay(10);
}

