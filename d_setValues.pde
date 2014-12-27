//int[] dimInputOld = new int[fixtures.length];
//int[] dimInputWithMasterOld = new int[fixtures.length];
//int[] dimFixturesOld = new int[fixtures.length];
boolean dimCheckFinished = true;
//int[][] valueToDmxTemp = new int[fixtures.length][fixtures.length];

final int DMX_CHAN_LENGTH = 512;

//__________________IMPORTANT VARIABLE(s)
int[] DMX = new int[DMX_CHAN_LENGTH+1];
int[] DMXforOutput = new int[DMX_CHAN_LENGTH+1];
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
      int[] dmxFromFixtureFO = fix.getDMXforOutput();
      for(int ij = 0; ij < dmxFromFixture.length; ij++) {
        DMX[constrain(fix.channelStart + ij, 1, DMX_CHAN_LENGTH)] = dmxFromFixture[ij];
        DMXforOutput[constrain(fix.channelStart + ij, 1, DMX_CHAN_LENGTH)] = dmxFromFixtureFO[ij];
      }
      fix.DMXChanged = false;
    }
  }
  if(true) {
    for(fixture fix : fixtures) {
       int[] toFixture = new int[fix.getDMXLength()];
       for (int i = 0; i < toFixture.length; i++) {
         toFixture[i] = DMX[constrain(fix.channelStart + i, 1, DMX_CHAN_LENGTH)];
       }
       fix.receiveDMX(toFixture);
       fix.DMXChanged = false;
    }
  }
  
  

  { // Memory checks --->
  
      memoryType[1] = 4; //Ensimmäisessä memorypaikassa on grandMaster - there is grandMaster in a first memory place
      memoryType[2] = 5; //Toisessa memorypaikassa on fade - there is fade in second memory place
      
      
      
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      tryDmxCheck();
      dmxToDim(); //Set input to dimInput variable
      
      
      

      
      
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
