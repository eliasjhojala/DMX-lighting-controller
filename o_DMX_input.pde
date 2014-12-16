//Tässä välilehdessä luetaan dmx-inputti, sekä järjestetään myös muut inputit oikeaan järjestykseen mm. dimInput[]-muuttujaan

int numberOfAllChannelsFirstDimensions = 5; // allChannels[numberOfAllChannelsFirstDimensions][];
boolean dmxCheckFinished = false;
boolean dmxToDimFinished = false;


void dmxCheck() {
  dmxCheckFinished = false;
  enttecDMXchannels = 512;
  if(useEnttec == true) {
       while (myPort.available() > 0) {
          if (cycleStart == true) {
            if (counter <= 6+enttecDMXchannels) {
              int inBuffer = myPort.read();
              if(counter > 4) { if(vals[counter-5] == 126 && vals[counter-4] == 5 && vals[counter] == 0) { counter = 0; cycleStart = true; } }
                vals[counter] = inBuffer;
                counter++;
              
            }
            else {
              cycleStart = false;
            }
          }
          else {
            for(int i = 0; i <= 5; i++) {
              if(vals[i] == check[i]) {
                if(error == false) {
                  error = false;
                }
              }
            }
            if(error == false) {
              for(int i = 0; i < 6+enttecDMXchannels; i++) {
                if(i < 30) { ch[i] = vals[i]; }
              }
              counter = 0;
              cycleStart = true;    
            }
           } 
 
      }
  }
  dmxCheckFinished = true;
}
void dmxToDim() {
  dmxToDimFinished = false;
  for(int i = 1; i < 25; i++) {
      enttecDMXchannel[i] = ch[i];
  }
  channelsToDim();
  dmxToDimFinished = true;
}
void channelsToDim() { 
  
  
  for(int i = 1; i <= controlP5channels; i++) {
    if(controlP5channelOld[i] != controlP5channel[i]) {
      allChannels[controlP5place][i] = controlP5channel[i];
      controlP5channelOld[i] = controlP5channel[i];
    }
  }
  for(int i = 1; i <= enttecDMXchannels; i++) {
    if(enttecDMXchannelOld[i] != enttecDMXchannel[i]) {
      allChannels[enttecDMXplace][i] = enttecDMXchannel[i];
      enttecDMXchannelOld[i] = enttecDMXchannel[i];
    }
  }
  for(int i = 1; i <= touchOSCchannels; i++) {
    if(touchOSCchannelOld[i] != touchOSCchannel[i]) {         
      for(int ii = 0; ii < numberOfAllChannelsFirstDimensions; ii++) {
        if(i > ii*12 && i <= (ii+1)*12) {
          allChannels[touchOSCplace + ii][i-ii*12] = touchOSCchannel[i];
        }     
      }
      touchOSCchannelOld[i] = touchOSCchannel[i];
    }   
  }

    
  for(int i = 1; i < 13; i++) {
    if(allChannelsOld[1][i] != allChannels[1][i]) {
      DMX[i] = allChannels[1][i];
      allChannelsOld[1][i] = allChannels[1][i];
    }
    
    if(allChannelsOld[1][i+12] != allChannels[1][i+12]) {
      DMX[i+12] = allChannels[1][i+12];
      allChannelsOld[1][i+12] = allChannels[1][i+12];
    }
    
    if(allChannelsOld[2][i] != allChannels[2][i]) {
      DMX[i+12] = allChannels[2][i];
      allChannelsOld[2][i] = allChannels[2][i];
    }
    
    if(allChannelsOld[5][i] != allChannels[5][i]) {
        memory(i+memoryMenu, round(map(allChannels[5][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+memoryMenu] = round(map(allChannels[5][i], 0, 255, 0, memoryMasterValue));
        allChannelsOld[5][i] = allChannels[5][i];
    }
    
    if(allChannelsOld[3][i] != allChannels[3][i]) {
        memory(i, round(map(allChannels[3][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i] = round(map(allChannels[3][i], 0, 255, 0, memoryMasterValue));
        allChannelsOld[3][i] = allChannels[3][i];
    }
    
    if(allChannelsOld[4][i] != allChannels[4][i]) {
      if(useMemories == true) {
        memory(i+12, round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+12] = round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue));
      }
      else {
        fixtures[i+12+12-1].setDimmer(allChannels[4][i]);
      }
      allChannelsOld[4][i] = allChannels[4][i];
    }
    
    if(enttecDMXchannels > 24) {
      for(int iii = 1; iii < 12; iii++) {
        dmxButtonPressed(iii, enttecDMXchannel[iii+24]);
      }
    }
  }
}
