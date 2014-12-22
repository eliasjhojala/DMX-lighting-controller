void saveFixtureMemory(int number) {
  memories[number] = new memory();
  memories[number].savePreset();
}

void loadFixtureMemory(int number, int value) {
  try {
    memories[number].value = value;
    memories[number].loadPreset();
  }
  catch(Exception e) {
    println("Can't load memory");
  }
}

  soundDetect s2l;
  memory[] memories = new memory[100];
void createMemoryObjects() {
  s2l = new soundDetect();
  for (memory temp : memories) temp = new memory();
}


class memory { //Begin of memory class--------------------------------------------------------------------------------------------------------------------------------------
  //chase variables
  int value; //memorys value
  int type; //memorys type (preset, chase, master, fade etc) (TODO: expalanations for different memory type numbers here)
  boolean[] whatToSave = new boolean[saveOptionButtonVariables.length];
  
  
  fixture[] repOfFixtures = new fixture[fixtures.length];
  
  chase myChase;
  
  memory() {
    myChase = new chase(this);
  }

  
  String getText() {
    String toReturn = "";
    switch(type) {
      case 1: toReturn = "prst"; break;
      case 2: toReturn = "chs"; break;
      default: toReturn = "unkn"; break;
    }
    return toReturn;
  }
  
  void draw() {
    switch(type) {
      case 1: preset(); break;
      case 2: chase(); break;
      default: unknown(); break;
    }
  }
  
  void preset() {
    loadPreset();
  }
  void chase() {
  }
  void unknown() {
  }
  
  
  void savePreset() {
      for(int i = 0; i < fixtures.length; i++) {
      repOfFixtures[i] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }
    for (int i = 0; i < fixtures.length; i++) {
      if(whatToSave[0]) {
       repOfFixtures[i].dimmer = fixtures[i].dimmer;
      }
      if(whatToSave[7]) {
       repOfFixtures[i].haze = fixtures[i].haze;
      }
      if(whatToSave[8]) {
       repOfFixtures[i].fan = fixtures[i].fan;
      }
      if(whatToSave[9]) {
       repOfFixtures[i].fog = fixtures[i].fog;
      }
    }
    type = 1;
  }



  void loadPreset() {
    
    for (int i = 0; i < fixtures.length; i++) {
      
      if(whatToSave[0] && repOfFixtures[i] != null) {
        int val = int(map(repOfFixtures[i].dimmer, 0, 255, 0, value));
        if(val > fixtures[i].dimmerPresetTarget) {
          fixtures[i].dimmerPresetTarget = val;
        }
      }
      if(whatToSave[7] && repOfFixtures[i] != null) {
        fixtures[i].haze = int(map(repOfFixtures[i].haze, 0, 255, 0, value)); fixtures[i].DMXChanged = true;
      }
      if(whatToSave[8] && repOfFixtures[i] != null) {
        fixtures[i].fan = int(map(repOfFixtures[i].fan, 0, 255, 0, value)); fixtures[i].DMXChanged = true;
      }
      if(whatToSave[9] && repOfFixtures[i] != null) {
        fixtures[i].fog = int(map(repOfFixtures[i].fog, 0, 255, 0, value)); fixtures[i].DMXChanged = true;
      }
    }
  }

  
  
} //end of memory class-----------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------









class chase { //Begin of chase class--------------------------------------------------------------------------------------------------------------------------------------
  int inputMode, outputMode; //What is input and what will output look like
  
  memory parent;
  //You need to supply a memory parent for this to work properly
  chase(memory parent) {
    this.parent = parent;
  }
  
    
  int[] getPresets() {
     //here function which returns all the presets in this chase
     int[] toReturn = new int[1];
     return toReturn;
  }
  
  void beatToLight() { //This function turns all the lights in chase on if there is beat, else it turns all the lights off
    boolean next; //boolean which tells do we want to go to next step
    next = ((inputMode == 1 && s2l.beat(1)) || (inputMode == 2 && nextStepPressed));
    if(next) {
      for(int i = 0; i < getPresets().length; i++) {
          memory(getPresets()[i], 255);
      }
    }
    else {
      for(int i = 0; i < getPresets().length; i++) {
         memory(getPresets()[i], 0);
      }
    }
    
  }
  
  
  void beatToMoving() {
    //This function goes through all the presets. When there is beat this goes to next preset
    
  }
  
  void freqToLight() { //This function gives frequence values to chase presets
    for(int i = 0; i < getPresets().length; i++) {
      memory(getPresets()[i], s2l.freq(int(map(i, 0, getPresets().length, 0, s2l.getFreqMax()))));
    }
  }
} //end of chase class-----------------------------------------------------------------------------------------------------------------------------------------------------












class soundDetect { //----------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  //init all the variables
  float[] bands;
  //end initing variables
  
  
  soundDetect() {
    fft.forward( in.mix );
    bands = new float[fft.specSize()];
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
    toReturn = round(fft.getBand(i));
    return toReturn;
    //command to get  right freq from fft or something like it. 
    //This functions should be done now.
  }
  
  
  int getFreqMax() {
    int toReturn = fft.specSize();
    return toReturn;
    //command which tells how many frequencies there is available. 
    //This function should be done now.
  }
  
  
} //en of soundDetect class-----------------------------------------------------------------------------------------------------------------------------------------------------


