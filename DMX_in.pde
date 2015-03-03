//Tässä välilehdessä luetaan dmx-inputti, sekä järjestetään myös muut inputit oikeaan järjestykseen mm. dimInput[]-muuttujaan

int numberOfAllChannelsFirstDimensions = 5; // allChannels[numberOfAllChannelsFirstDimensions][];
 
boolean dmxCheckFinished = false;
boolean dmxToDimFinished = false;



void dmxCheck() {
  try {
  dmxCheckFinished = false;
  enttecDMXchannels = 512;
  if(useEnttec == true) {
       while (myPort.available() > 0) {
          if (cycleStart == true) {
            if (counter <= 6+enttecDMXchannels) {
              int inBuffer = myPort.read();
              if(counter > 4) { if(vals[counter-5] == 126 && vals[counter-4] == 5 && vals[counter] == 0) { counter = 0; cycleStart = true; } } //This if checks that checkvalues are right
                vals[counter] = inBuffer;
                counter++;
            }
            else {
              cycleStart = false;
            }
          } //cycleStart end
          
          
          else {
            //Here is better function to check all the check values, but for some reason it doesn't work
            for(int i = 0; i <= 5; i++) {
              if(vals[i] == check[i]) {
                if(error == false) {
                  error = false;
                }
              }
            }
            if(error == false) {
              for(int i = 0; i < 6+enttecDMXchannels; i++) {
                if(i < 30) { ch[i] = vals[i]; } //if channel is not over 30 then value is placed in ch array
              }
              counter = 0; //Reset counter
              cycleStart = true; //Now we can start new cycle
            }
           } //!cycleStart end
 
      } //while (myPort.available() > 0) END
  }
  dmxCheckFinished = true;
  }
  catch(Exception e) { 
    println("ERROR WITH DMX INPUT");
  }
}
void dmxToDim() {
  dmxToDimFinished = false;
  //This function places all the values from ch array to enttecDMXchannel array
  for(int i = 1; i < 25; i++) {
      enttecDMXchannel[i] = ch[i];
  }
  channelsToDim();
  dmxToDimFinished = true;
}
void channelsToDim() { 
  
  
  //Place data from different arrays to allChannels array if it is changed---------------------------------------------------------------------------------------
  
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
      allChannels[1][i] = touchOSCchannel[i];
      touchOSCchannelOld[i] = touchOSCchannel[i];
    }   
  }

  
  //End placing data to allChannels array------------------------------------------------------------------------------------------------------------------------


  //Place data from allChannels array to DMX and memory arrays----------------------------------------------------------------------------------------------------------
    
 for(int i = 24; i < allChannels[1].length; i++) {
   if(allChannels[1][i] != allChannelsOld[1][i]) {
     memories[i-24].setValue(allChannels[1][i]);
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
    
    if(allChannelsOld[5][i] != allChannels[5][i]) {
        memories[i].setValue(allChannels[1][i]);
        allChannelsOld[5][i] = allChannels[5][i];
    }
    
    if(allChannelsOld[3][i] != allChannels[3][i]) {
        memories[i].setValue(allChannels[3][i]);
        allChannelsOld[3][i] = allChannels[3][i];
    }
    
    if(allChannelsOld[4][i] != allChannels[4][i]) {
      memories[i+12].setValue(allChannels[4][i]);
      allChannelsOld[4][i] = allChannels[4][i];
    }
    
    //End placing data to DMX and memory arrays------------------------------------------------------------------------------------------------------------------------

  }
}
