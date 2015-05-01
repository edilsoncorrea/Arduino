#include <EasyTransfer.h>

//create two objects
EasyTransfer Receptor; 

int ThrotleAnt;
int Throtle;

struct RECEIVE_DATA_STRUCTURE
{
  int Throtle;
  int Rudd;
  int Eleron;
  int Ailevon;
  int Button;
  int Sequencial; 
};

//give a name to the group of data
RECEIVE_DATA_STRUCTURE rxdata;

RECEIVE_DATA_STRUCTURE rxdataAnt;

int i;

void setup()
{
  Serial1.begin(115200);
  
  delay(100);
  
  Serial.begin(38400);

  delay(100);
  
  //start the library, pass in the data details and the name of the serial port. Can be Serial, Serial1, Serial2, etc.
  Receptor.begin(details(rxdata), &Serial1);

  delay(100);
    
  //then we will go ahead and send that data out
  Receptor.receiveData();
    
  delay(100);

  rxdata.Throtle = map(rxdata.Throtle, 0, 1023, 0, 511);
  rxdata.Rudd    = map(rxdata.Rudd,    0, 1023, 0, 511);
  rxdata.Eleron  = map(rxdata.Eleron,  0, 1023, 0, 511);
  rxdata.Ailevon = map(rxdata.Ailevon, 0, 1023, 0, 511); 
  
  rxdataAnt.Throtle = rxdata.Throtle;
  rxdataAnt.Rudd    = rxdata.Rudd;
  rxdataAnt.Eleron  = rxdata.Eleron;
  rxdataAnt.Ailevon = rxdata.Ailevon; 
  
}

void loop()
{
  //then we will go ahead and send that data out
  Receptor.receiveData();
  
  rxdata.Throtle = map(rxdata.Throtle, 0, 1023, 0, 511);
  rxdata.Rudd    = map(rxdata.Rudd,    0, 1023, 0, 511);
  rxdata.Eleron  = map(rxdata.Eleron,  0, 1023, 0, 511);
  rxdata.Ailevon = map(rxdata.Ailevon, 0, 1023, 0, 511);
  
  Serial.print("Throtle: ");
  Serial.print(rxdata.Throtle, DEC);
    
  Serial.print("     Rudd: ");
  Serial.println(rxdata.Rudd, DEC);   
  
  ThrotleAnt = Throtle; 
  
  //delay for good measure
  delay(10);
}


