fixture[][] repOfFixtures = new fixture[fixtures.length][numberOfMemories];
void saveFixtureMemory(int fixtureMemoryId) {
      for(int i = 0; i < fixtures.length; i++) {
      repOfFixtures[i][fixtureMemoryId] = new fixture();
  }
  for (int i = 0; i < fixtures.length; i++) {
    if(whatToSave[fixtureMemoryId][0]) {
     repOfFixtures[i][fixtureMemoryId].dimmer = fixtures[i].dimmer;
    }
  }
  memoryType[fixtureMemoryId] = 1;
}



void loadFixtureMemory(int fixtureMemoryId, int value) {
  
  for (int i = 0; i < fixtures.length; i++) {
    if(whatToSave[fixtureMemoryId][0]) {
      int val = int(map(repOfFixtures[i][fixtureMemoryId].dimmer, 0, 255, 0, value));
      println(val);
      if(val > fixtures[i].dimmerPresetTarget) {
        fixtures[i].dimmerPresetTarget = val;
      }
    }
  }
}



void createMemoryObjects() {
  soundDetect s2l = new soundDetect();
  memory[] memories = new memory[100];
  for (memory temp : memories) temp = new memory();
}


class memory { //Begin of memory class--------------------------------------------------------------------------------------------------------------------------------------
  //chase variables
  int value; //memorys value
  int type; //memorys type (preset, chase, master, fade etc) (TODO: expalanations for different memory type numbers here)
  
  
  memory() {
  }

  

  
  
} //en of memory class-----------------------------------------------------------------------------------------------------------------------------------------------------


class chase { //Begin of chase class--------------------------------------------------------------------------------------------------------------------------------------
  int inputMode, outputMode; //What is input and what will output look like
  chase() {
  }
  
    
  int[] getPresets() {
     //here function which returns all the presets in this chase
     int[] toReturn = new int[1];
     return toReturn;
  }
  
  void beatToLight() {
    if(s2l.beat(1) == true) {
      for(int i = 0; i < getPresets().length; i++) {
          memory(getPresets(i), 255);
      }
    }
    else {
      for(int i = 0; i < getPresets().length; i++) {
         memory(getPresets(i), 0);
      }
    }
    
  }
  void beatToMoving() {
  }
  void freqToLight() {
    for(int i = 0; i < getPresets().length; i++) {
    //  memory(getPresets(i), soundDetect.freq(int(map(i, 0, getPresets().length, 0, soundDetect.getFreqMax())));
    }
  }
} //en of chase class-----------------------------------------------------------------------------------------------------------------------------------------------------



class soundDetect { //----------------------------------------------------------------------------------------------------------------------------------------------------------
  soundDetect() {
  }
  boolean beat(int bT) {
    beat.detect(in.mix); //beat detect command of minim library
    boolean toReturn = true;
    switch(bT) {
      case 1: toReturn = beat.isKick(); break;
      case 2: toReturn = beat.isSnare(); break;
      case 3: toReturn = beat.isHat(); break;
    }
    return toReturn;
  }
  int freq(int i) {
    int toReturn = 0;
    //command to get  right freq from fft or something like it
    return toReturn;
  }
} //en of soundDetect class-----------------------------------------------------------------------------------------------------------------------------------------------------


