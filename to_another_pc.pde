//in this tab software sends data to other pc and ipad

boolean sendOscToAnotherPc = true;
boolean sendOscToIpad = true;
boolean sendMemoryToIpad = true;

int[] oldChannelValToPc = new int[300];
int[] oldChannelValToIpad = new int[channels];
int[] oldMemoryValToIpad = new int[numberOfMemories];
int[] oldDataValToIpad = new int[100];


void sendOscToAnotherPc(int ch, int val) {
  if(sendOscToAnotherPc == true) {
    if(val != oldChannelValToPc[ch]) {
      OscMessage myMessage1 = new OscMessage(str(ch));
      myMessage1.add(val); // add an int to the osc message
      oscP51.send(myMessage1, myRemoteLocation1); 
      oldChannelValToPc[ch] = val;
    }
  }
}

void sendOscToIpad(int ch, int val) {
  if(sendOscToIpad == true) {
    if((val < (oldChannelValToIpad[ch] - 10)) || (val > (oldChannelValToIpad[ch] + 10)) || (val == 0 && oldChannelValToIpad[ch] != 0) || (val == 255 && oldChannelValToIpad[ch] != 255)) {
      OscMessage myMessage2 = new OscMessage("/1/fader" + str(ch));
      myMessage2.add(val); // add an int to the osc message
      oscP52.send(myMessage2, myRemoteLocation2); 
      oldChannelValToIpad[ch] = val;
    }
  }
}

void sendMemoryToIpad(int ch, int val) {
  if(sendMemoryToIpad == true) {
    if((val < (oldMemoryValToIpad[ch] - 10)) || (val > (oldMemoryValToIpad[ch] + 10)) || (val == 0 && oldMemoryValToIpad[ch] != 0) || (val == 255 && oldMemoryValToIpad[ch] != 255)) {
      OscMessage myMessage2 = new OscMessage("/5/fader" + str(ch));
      myMessage2.add(val); // add an int to the osc message
      oscP52.send(myMessage2, myRemoteLocation2); 
      oldMemoryValToIpad[ch] = val;
    }
  }
}

void sendDataToIpad(String ch, int val) {
    OscMessage myMessage2 = new OscMessage(ch);
    myMessage2.add(val); // add an int to the osc message
    oscP52.send(myMessage2, myRemoteLocation2); 
}
