boolean sendOscToAnotherPc = true;
boolean sendOscToIpad = true;
boolean sendMemoryToIpad = true;


void sendOscToAnotherPc(int ch, int val) {
  if(sendOscToAnotherPc == true) {
    OscMessage myMessage1 = new OscMessage(str(ch));
    myMessage1.add(val); // add an int to the osc message
    oscP51.send(myMessage1, myRemoteLocation1); 
  }
}

void sendOscToIpad(int ch, int val) {
  if(sendOscToIpad == true) {
    OscMessage myMessage2 = new OscMessage("/1/fader" + str(ch));
    myMessage2.add(val); // add an int to the osc message
    oscP52.send(myMessage2, myRemoteLocation2); 
  }
}

void sendMemoryToIpad(int ch, int val) {
  if(sendMemoryToIpad == true) {
    OscMessage myMessage2 = new OscMessage("/5/fader" + str(ch));
    myMessage2.add(val); // add an int to the osc message
    oscP52.send(myMessage2, myRemoteLocation2); 
  }
}
