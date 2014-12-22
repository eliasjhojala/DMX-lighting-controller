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
  
  //-----------CODER MANUAL----------------//|
  // when you use memory, please use       //|
  // command memories[i].setValue(value)   //|
  // Never use value = ;                   //|
  // You can also use loadPreset(value);   //|
  // or setValue(value);                   //|
  //---------------------------------------//|
  
  
  //chase variables
  int value; //memorys value
  int type; //memorys type (preset, chase, master, fade etc) (TODO: expalanations for different memory type numbers here)

  
  boolean[] whatToSave = new boolean[saveOptionButtonVariables.length+10];
  
  
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
      case 4: grandMaster(); break;
      default: unknown(); break;
    }
  }
  
  void preset() {
    loadPreset();
    println("TOIMII");
  }
  void chase() {
  }
  void grandMaster() {
    grandMaster = value;
  }
  void unknown() {
  }
  void setValue(int v) {
    value = v;
    draw();
  }
  int getValue() {
    return value;
  }
  
  
  void savePreset() {
    println("TOIMII");
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



  void loadPreset(int v) {
    setValue(v);
  }

  void loadPreset() {
    
    for (int i = 0; i < fixtures.length; i++) {
      
      if(whatToSave[0] && repOfFixtures[i] != null) {
//        int val = int(map(repOfFixtures[i].dimmer, 0, 255, 0, value));
//        if(val > fixtures[i].dimmerPresetTarget) {
//          fixtures[i].dimmerPresetTarget = val;
//        }
       fixtures[i].setDimmer(repOfFixtures[i].dimmer);
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










class chase { //Begin of chase class--------------------------------------------------------------------------------------------------------------------------------------
  int inputMode, outputMode; //What is input and what will output look like
  int inputModeDownLimit = 0;
  int outputModeDownLimit = 0;
  int inputModeUpLimit = 2;
  int outputModeUpLimit = 2;
  
  int[] presets;
  
  memory parent;
  //You need to supply a memory parent for this to work properly
  chase(memory parent) {
    this.parent = parent;
  }
  
    
  int[] getPresets() {
     //here function which returns all the presets in this chase
     int[] toReturn = new int[presets.length];
     for(int i = 0; i < toReturn.length; i++) {
       toReturn[i] = presets[i];
     }
     return toReturn;
  }
  
  void newChase() {
    int a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1) {
        if(memories[i].value > 0) {
          presets[a] = i;
          a++;
        }
      }
    }
  }
  
  void loadPreset(int n, int v) {
    if(parent.type == 2) {
      if(memories[n].type == 1) {
        memories[n].loadPreset(v);
      }
    }
  }
  
  void beatToLight() { //This function turns all the lights in chase on if there is beat, else it turns all the lights off
    boolean next; //boolean which tells do we want to go to next step
    next = ((inputMode == 1 && s2l.beat(1)) || (inputMode == 2 && nextStepPressed));
    if(next) {
      for(int i = 0; i < getPresets().length; i++) {
          loadPreset(getPresets()[i], 255);
      }
    }
    else {
      for(int i = 0; i < getPresets().length; i++) {
         loadPreset(getPresets()[i], 0);
      }
    }
    
  }
  
  int getReverse(int act, int dl, int ul) {
    int toReturn = 0;
    if(act > dl) { toReturn = act - 1; }
    if(act == dl) { toReturn = ul; }
    return toReturn;
  }
  int getNext(int act, int dl, int ul) {
    int toReturn = 0;
    if(act < ul) { toReturn = act + 1; }
    if(act == ul) { toReturn = dl; }
    return toReturn;
  }
  int getInvertedValue(int v, int dl, int ul) {
    int toReturn = 0;
    toReturn = iMap(v, dl, ul, ul, dl);
    return toReturn;
  }
  
  int step;
  int brightness;
  boolean stepHasChanged;
  int fade;
  
  void changeFade(int v) {
    fade = defaultConstrain(v);
  }
  
  int defaultConstrain(int v) {
    int toReturn = 0;
    toReturn = constrain(v, 0, 255);
    return toReturn;
  }
  
  int iMap(int v, int iD, int iU, int oD, int oU) {
    int toReturn = 0;
    toReturn = int(map(v, iD, iU, oD, oU));
    return toReturn;
  }
  int rMap(int v, int iD, int iU, int oD, int oU) {
    int toReturn = 0;
    toReturn = round(map(v, iD, iU, oD, oU));
    return toReturn;
  }
  
  void beatToMoving() {
    //This function goes through all the presets. When there is beat this goes to next preset
    boolean next;
    next = ((inputMode == 1 && s2l.beat(1)) || (inputMode == 2 && nextStepPressed));
    if(next) { 
      step = getNext(step, 0, getPresets().length);
      brightness = 0;
      stepHasChanged = true;
    }
    if(stepHasChanged) {
      brightness+=getInvertedValue(fade, 0, 255);
      if(brightness >= 255) {
        brightness = 255;
        stepHasChanged = false;
      }
    }
    int s = step;
    int b = brightness;
    int rS = getReverse(s, 0, getPresets().length);
    loadPreset(s, b);
    loadPreset(rS, getInvertedValue(b, 0, 255));
  }
  
  void freqToLight() { //This function gives frequence values to chase presets
    for(int i = 0; i < getPresets().length; i++) {
      loadPreset(getPresets()[i], s2l.freq(iMap(i, 0, getPresets().length, 0, s2l.getFreqMax())));
    }
  }
  
  
  void changeInputMode(int v) {
    inputMode = constrain(v, inputModeDownLimit, inputModeUpLimit);
  }
  void changeOutputMode(int v) {
    outputMode = constrain(v, outputModeDownLimit, outputModeUpLimit);
  }
  
  void inputModeUp() {
    changeChaseMode(true, true);
  }
  void inputModeDown() {
    changeChaseMode(true, false);
  }
  void outputModeUp() {
    changeChaseMode(false, true);
  }
  void outputModeDown() {
    changeChaseMode(false, false);
  }
  
  void changeChaseMode(boolean input, boolean next) {
    if(input) {
      if(next) { inputMode++; }
      else { inputMode--; }
      if(inputMode > inputModeUpLimit) { inputMode = inputModeDownLimit; }
      if(inputMode < inputModeDownLimit) { inputMode = inputModeUpLimit; }
    }
    else {
      if(next) { outputMode++; }
      else { outputMode--; }
      if(outputMode > outputModeUpLimit) { outputMode = outputModeDownLimit; }
      if(outputMode < outputModeDownLimit) { outputMode = outputModeUpLimit; }
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


