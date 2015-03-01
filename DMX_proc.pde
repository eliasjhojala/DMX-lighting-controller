//DMX values between fixtures and output are mainly processed in this tab

boolean dimCheckFinished = true;

final int DMX_CHAN_LENGTH = 512;


//__________________IMPORTANT VARIABLE(s)
int[] DMX = new int[DMX_CHAN_LENGTH+1];
int[] DMXforOutput = new int[DMX_CHAN_LENGTH+1];
int[] DMXforCrossFixtureOld = new int[DMX_CHAN_LENGTH+1];
//------------------ SO VERY IMPORTANT


int dmxTriedTimes = 0;
boolean dmxIsWorking = false;



void setDimAndMemoryValuesAtEveryDraw() {
  dimCheckFinished = false;
  
  
  boolean DMXChangedOverall = false;
  for(int ai = 0; ai < fixtures.size(); ai++) {
    fixture fix = fixtures.get(ai);
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
    for(int ai = 0; ai < fixtures.size(); ai++) {
      fixture fix = fixtures.get(ai);
      int[] toFixture = new int[fix.getDMXLength()];
      int[] fromFixture = fix.getDMX();
      for (int i = 0; i < toFixture.length; i++) {
        if(DMX[constrain(fix.channelStart + i, 1, DMX_CHAN_LENGTH)] != DMXforCrossFixtureOld[constrain(fix.channelStart + i, 1, DMX_CHAN_LENGTH)]) {
          toFixture[i] = DMX[constrain(fix.channelStart + i, 1, DMX_CHAN_LENGTH)];
          //channelValuesOld[constrain(fix.channelStart + i, 1, DMX_CHAN_LENGTH)] = toFixture[i];
        } else {
          toFixture[constrain(i, 0, toFixture.length-1)] = fromFixture[constrain(i, 0, fromFixture.length-1)];
        }
      }
      fix.in.receiveDMX(toFixture);
      fix.DMXChanged = false;
    }
  }
  
  arrayCopy(DMX, DMXforCrossFixtureOld);

  { // Memory checks --->   
      
      
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      tryDmxCheck();
      dmxToDim(); //Set input to dimInput variable 
      
      //---------------------------------------------------------blackOut and blackOut-------------------------------------------------------
        //TODO: fullOn and blackOut here if needed
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
