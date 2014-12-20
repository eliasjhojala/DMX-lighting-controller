int[] dimInputOld = new int[fixtures.length];
int[] dimInputWithMasterOld = new int[fixtures.length];
int[] dimFixturesOld = new int[fixtures.length];
boolean dimCheckFinished = true;
//int[][] valueToDmxTemp = new int[fixtures.length][fixtures.length];

//__________________IMPORTANT VARIABLE(s)
int[] DMX = new int[512];
int[] DMXforOutput = new int[512];
//------------------ SO VERY IMPORTANT

int dmxTriedTimes = 0;
boolean dmxIsWorking = false;

void setDimAndMemoryValuesAtEveryDraw() {
  dimCheckFinished = false;
  
  boolean DMXChangedOverall = false;
  for(fixture fix : fixtures) {
    if(fix.DMXChanged) {
      DMXChangedOverall = true;
      int[] dmxFromFixture = fix.getDMX();
      for(int ij = 0; ij < dmxFromFixture.length; ij++) {
        DMX[fix.channelStart + ij] = dmxFromFixture[ij];
      }
      fix.DMXChanged = false;
    }
  }
  if(/*DMXChangedOverall*/ true) {
    for(fixture fix : fixtures) {
       int[] toFixture = new int[fix.getDMXLength()];
       for (int i = 0; i < toFixture.length; i++) {
         toFixture[i] = DMX[fix.channelStart + i];
       }
       fix.receiveDMX(toFixture);
       fix.DMXChanged = false;
       
       int[] dmxFromFixtureFO = fix.getDMXforOutput();
       for(int ij = 0; ij < dmxFromFixtureFO.length; ij++) {
         DMXforOutput[fix.channelStart + ij] = dmxFromFixtureFO[ij];
       }
       
    }
  }
  
  
  
  { // Memory checks --->
  
      memoryType[1] = 4; //Ensimmäisessä memorypaikassa on grandMaster - there is grandMaster in a first memory place
      memoryType[2] = 5; //Toisessa memorypaikassa on fade - there is fade in second memory place
      
      
      
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      tryDmxCheck();
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
                } //EndIf: (valueOfMemory[i] != ...)
                memory(i, 0);
                dimInput[i] = 0; 
              } //EndElse
            } //EndIf: (soloWasHere)
            else {
              if(i == soloMemory && valueOfMemory[i] != 0) {
                memory(i, valueOfMemory[i]);
              }
            }//EndElse
            
          }
        } //EndIf: (useSolo == true)
        else {
          if(valueOfMemory[i] > 0) {
            memory(i, valueOfMemory[i]);
          }
        } //EndElse: (useSolo == true)
      } //EndFor: (i < numberOfMemories)
      

      if(grandMaster != oldGrandMaster) { for(fixture fix : fixtures) fix.DMXChanged = true; oldGrandMaster = grandMaster; }
      
      //----------------------------------------------------------------------------------------------------------------------------
      
  
      
      //-------------------------------------blackOut---------------------------------------------//|
                                                                                                  //|
      if(blackOut == true)  { //Tarkistetaan onko blackout päällä - check if blackout is on       //|
         grandMaster = 0; //if blackout is on then grandMaster will be zero                       //|
      }                                                                                           //|
      //------------------------------------------------------------------------------------------//|
  }
  dimCheckFinished = false;
}

void tryDmxCheck() {
  if(!dmxIsWorking) {
      try {
        dmxCheck(); //Read dmx input from enttec
        dmxIsWorking = true;
      }
      catch(Exception e) {
        if(dmxTriedTimes > 4) {
          dmxTriedTimes++;
          tryDmxCheck();
          println("Error with DMX input");
        }
      }
  }
  else {
    dmxCheck();
  }
}
