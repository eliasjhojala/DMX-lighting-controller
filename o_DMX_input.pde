//Tässä välilehdessä luetaan dmx-inputti, sekä järjestetään myös muut inputit oikeaan järjestykseen mm. dimInput[]-muuttujaan

int numberOfAllChannelsFirstDimensions = 5; // allChannels[numberOfAllChannelsFirstDimensions][];

void dmxCheck() {
  if(useCOM == true && useEnttec == true) {
       while (myPort.available() > 0) {
          if (cycleStart == true) {
            if (counter <= 6+enttecDMXchannels) {
              int inBuffer = myPort.read();
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
              for(int i = 5; i < 6+enttecDMXchannels; i++) {
                ch[i - 5] = vals[i];
              }
              counter = 0;
              cycleStart = true;    
            }
           } 
      }
  }
}
void dmxToDim() {
  for(int i = 1; i < 13; i++) {
      enttecDMXchannel[i] = ch[i];
  }
  channelsToDim();
}
void channelsToDim() { 
  
  
  for(int i = 1; i <= controlP5channels; i++) {
    if(controlP5channelOld[i] != controlP5channel[i]) {
      allChannels[controlP5place][i] = controlP5channel[i];
    }
  }
  for(int i = 1; i <= enttecDMXchannels; i++) {
    if(enttecDMXchannelOld[i] != enttecDMXchannel[i]) {
      allChannels[enttecDMXplace][i] = enttecDMXchannel[i];
    }
  }
  for(int i = 1; i <= touchOSCchannels; i++) {
    if(touchOSCchannelOld[i] != touchOSCchannel[i]) {         
      for(int ii = 0; ii < numberOfAllChannelsFirstDimensions; ii++) {
        if(i > ii*12 && i <= (ii+1)*12) {
          allChannels[touchOSCplace + ii][i-ii*12] = touchOSCchannel[i];
        }     
      }
    }   
  }
  
  
  for(int i = 1; i < 13; i++) {
    for(int ii = 0; ii < numberOfAllChannelsFirstDimensions; ii++) {
      if(allChannels[ii][i] < 2) {
        allChannels[ii][i] = 0;
      }
    }
  }

    
  for(int i = 1; i < 13; i++) {
    if(allChannelsOld[1][i] != allChannels[1][i]) {
      dimInput[i] = round(map(allChannels[1][i], 0, 255, 0, fixtureMasterValue));
    }
    if(allChannelsOld[2][i] != allChannels[2][i]) {
      dimInput[i+12] = round(map(allChannels[2][i], 0, 255, 0, fixtureMasterValue));
    }
    if(allChannelsOld[5][i] != allChannels[5][i]) {
        memory(i+memoryMenu, round(map(allChannels[5][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+memoryMenu] = round(map(allChannels[5][i], 0, 255, 0, memoryMasterValue));
    }
    if(allChannelsOld[3][i] != allChannels[3][i]) {
        memory(i, round(map(allChannels[3][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i] = round(map(allChannels[3][i], 0, 255, 0, memoryMasterValue));
    }
    
    if(allChannelsOld[4][i] != allChannels[4][i]) {
      if(useMemories == true) {
        memory(i+12, round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+12] = round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue));
      }
      else {
        dimInput[i+12+12] = allChannels[4][i];
      }
    }
    if(enttecDMXchannels > 24) {
      for(int iii = 1; iii < 12; iii++) {
        dmxButtonPressed(iii, enttecDMXchannel[iii+24]);
      }
    }
  }
  for(int i = 1; i < 13; i++) {
    for(int ii = 1; ii < numberOfAllChannelsFirstDimensions; ii++) {
      allChannelsOld[ii][i] = allChannels[ii][i];
    }
  }
  
  for(int i = 1; i < 13; i++) { controlP5channelOld[i] = controlP5channel[i]; }
  for(int i = 1; i < enttecDMXchannels; i++) { enttecDMXchannelOld[i] = enttecDMXchannel[i]; }
  for(int i = 1; i < touchOSCchannels; i++) { touchOSCchannelOld[i] = touchOSCchannel[i]; }
}
