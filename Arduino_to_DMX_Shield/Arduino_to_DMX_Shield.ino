//(Based on:)DMX communication protocol for Processing ---> Arduino
//Made by Roope Salmi

#include <DmxSimple.h>

void setup() {
  Serial.begin(115200);
}

byte message[3];
byte pointer = 0;

void loop() {
  
  
  if(Serial.available() > 0) {
    if(Serial.peek() >= 250) {
      pointer = 0;
      parseMessage(message);
    }
    message[pointer] = Serial.read();
    pointer++;
  }
  
  
}

void parseMessage(byte* mesg) {
  if(mesg[0] == 255 && mesg[2] > 5) {
    //Configuration command
    configurationCommand(mesg[2], mesg[1]);
  } else
  switch(mesg[0]) {
    case 250:
      execute(mesg[1]+1, mesg[2]);
    break;
    case 251:
      execute(mesg[1]+1, mesg[2] + 250);
    break;
    case 252:
      execute(mesg[1]+1 + 250, mesg[2]);
    break;
    case 253:
      execute(mesg[1]+1 + 250, mesg[2] + 250);
    break;
    case 254:
      execute(mesg[1]+1 + 262, mesg[2]);
    break;
    case 255:
      execute(mesg[1]+1 + 262, mesg[2] + 250);
    break;
  }
}

void execute(int channel, int data) {
  //Now you can do whatever you like with this data
  DmxSimple.write(channel, data);
}

void configurationCommand(byte type, byte data) {
  switch(type) {
    case 6:
      DmxSimple.maxChannel((data+1)*2);
    break;
    case 7:
      DmxSimple.maxChannel((data+1+250)*2);
    break;
  }
}

