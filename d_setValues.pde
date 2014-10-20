int[] dimInputOld = new int[dimInput.length];
void setDimAndMemoryValuesAtEveryDraw() {
  for(int i = 0; i < fixtures.length; i++) {
        fixtures[i].dimmer = int(map(dimInput[fixtures[i].channelStart], 0, 255, 0, grandMaster));
        dim[fixtures[i].channelStart] = fixtures[i].dimmer;
        dimInputOld[i] = dimInput[i];
        for(int ij = 0; ij < fixtures[i].getDMX().length; ij++) {
          valueToDmx[fixtures[i].channelStart+ij] = fixtures[i].getDMX()[ij];
        }
   
   //TODO: Now this for loop overwrites some data, but if there is dimInputOldcheck then no light is turned on
    
  }
  
  memoryType[1] = 4; //Ensimmäisessä memorypaikassa on grandMaster - there is grandMaster in a first memory place
  memoryType[2] = 5; //Toisessa memorypaikassa on fade - there is fade in second memory place
  
  
  
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  dmxCheck(); //Read dmx input from enttec
  dmxToDim(); //Set input to dimInput variable
  
  
  //-------------------------Set memories to their values. If solomemory is on all the others will be of-------------------------
  
  memoryData = new int[channels];
  for(int i = 0; i < numberOfMemories; i++) {
    if(useSolo == true) {
      if(valueOfMemory[soloMemory] < 10) {
        if(soloWasHere == true) {
          memory(i, valueOfMemoryBeforeSolo[i]);
          dimInput[i] = valueOfChannelBeforeSolo[i];
          soloWasHere = false;
        }
        else {
          if(valueOfMemory[i] > 0) {
            memory(i, valueOfMemory[i]);
          }
        }
      }
      else {
        soloWasHere = true;
        if(soloWasHere == false) {
          if(i == soloMemory && valueOfMemory[i] != 0) {
            memory(i, valueOfMemory[i]);
          }
          else {
            if(valueOfMemory[i] != 0 || dim[i] != 0) {
              valueOfMemoryBeforeSolo[i] = valueOfMemory[i];
              valueOfChannelBeforeSolo[i] = dim[i];
            }
            memory(i, 0);
            dimInput[i] = 0; 
          }
        }
        else {
          if(i == soloMemory && valueOfMemory[i] != 0) {
            memory(i, valueOfMemory[i]);
          }
        }
        
      }
    }
    else {
      if(valueOfMemory[i] > 0) {
        memory(i, valueOfMemory[i]);
      }
    }
  }
  
  
  
  for (int i = 0; i < channels; i++) {
    if (memoryData[i] != 0 || memoryIsZero[i] == false) {
      dimInput[i] = memoryData[i];
      if (memoryData[i] == 0) {memoryIsZero[i] = true;} else {memoryIsZero[i] = false;}
    }
  }
  
  //----------------------------------------------------------------------------------------------------------------------------
  
  
  //---------------------------------------------------------blackOut and-------------------------------------------------------
  
  if(blackOut == true)  { //Tarkistetaan onko blackout päällä - check if blackout is on
     grandMaster = 0; //if blackout is on then grandMaster will be zero
  }
  
   if(fullOn == true)  { //Tarkistetaan onko fullon päällä - check if fullOn is on
     for(int i = 0; i < channels; i++) { //Käydään kaikki kanavat läpi
       dimInput[i] = 255; //Asetetaan kanavan arvoksi nolla - set all of the channels to zero
     }
  }
}
