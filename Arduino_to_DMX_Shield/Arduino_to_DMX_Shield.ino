//(Based on:)DMX communication protocol for Processing ---> Arduino
//Made by Roope Salmi


#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(6, 6, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);
  Serial.println("SerialToDMXshield ready for commands");
  Serial.println("Protocol: https://gist.github.com/ollpu/239cc50beb91bfe06189");
  pixels.begin();
}

int value = 0;
int channel;
boolean channelDeclared = false;

void loop() {
  int c;

  while(!Serial.available());
  c = Serial.read();
  if ((c>=0) && (c<=31)) {
    value = 32*value + c;
  } else {
    if (c==0xFE) { channel = value; channelDeclared = true; }
    else if (c==0xFF && channelDeclared) {
      execute(channel+1, value);
      
    }
    value = 0;
  }
}


void execute(int channel, int data) {
  //Now you can do whatever you like with this data
  //DmxSimple.write(channel, data);
  //Serial.write(channel);
  pixels.setPixelColor(channel-1, data, data, data);
  pixels.show();
  Serial.write(data);
}

void configurationCommand(byte type, byte data) {
  switch(type) {
    case 6:
      //DmxSimple.maxChannel((data+1)*2);
    break;
    case 7:
      //DmxSimple.maxChannel((data+1+250)*2);
    break;
  }
}

