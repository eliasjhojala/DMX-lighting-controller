//DMX communication protocol for Processing ---> Arduino
//Made by Roope Salmi



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
  Serial.write(channel);
  //Now you can do whatever you like with this data
}

