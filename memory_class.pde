/*void saveFixtureMemory(int number) {
  memories[number] = new memory();
  memories[number].savePreset();
}*/

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
  for(int i = 0; i < memories.length; i++) {
    memories[i] = new memory();
  }
}


class memory { //Begin of memory class--------------------------------------------------------------------------------------------------------------------------------------
  
  //-----------CODER MANUAL----------------//|
  // when you use memory, please use       //|
  // command memories[i].setValue(value)   //|
  // Never use value = ;                   //|
  // You can also use loadPreset(value);   //|
  // or setValue(value);                   //|
  //---------------------------------------//|
  
  //--Memory types--//|
  // 1: preset      //|
  // 2: chase       //|
  // 3: -           //|
  // 4: master      //|
  // 5: fade        //|
  //----------------//|
  
  
  //chase variables
  int value; //memorys value
  int type; //memorys type (preset, chase, master, fade etc) (TODO: expalanations for different memory type numbers here)

  
  boolean[] whatToSave = new boolean[saveOptionButtonVariables.length+10];
  
  
  fixture[] repOfFixtures = new fixture[fixtures.length];
  
  chase myChase;
  
  memory() {
    myChase = new chase(this);
    for(int i = 0; i < fixtures.length; i++) {
      repOfFixtures[i] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    }
  }

  boolean thisIsChase() {
    return type == 2;
  }

  
  String getText() {
    String toReturn = "";
    switch(type) {
      case 0: toReturn = ""; break;
      case 1: toReturn = "prst"; break;
      case 2: toReturn = "chs"; break;
      case 4: toReturn = "mstr"; break;
      case 5: toReturn = "fade"; break;
      default: toReturn = "unkn"; break;
    }
    return toReturn;
  }
  
  void draw() {
    switch(type) {
      case 0: empty(); break;
      case 1: preset(); break;
      case 2: chase(); break;
      case 4: grandMaster(); break;
      case 5: fade(); break;
      default: unknown(); break;
    }
  }
  
  void preset() {
    if(type == 1) {
      loadPreset();
    }
  }
  void chase() {
    if(value > 0) {
       myChase.draw();
    }
  }
  void grandMaster() {
    //function to adjust grandMaster
    grandMaster = value;
  }
  void fade() {
    chaseFade = value;
  }
  void unknown() {
  }
  void empty() {
  }
  void setValue(int val) {
    value = val;
    draw();
  }
  int getValue() {
    return value;
  }
  
  
  void savePreset(boolean[] newWhatToSave) {
    arrayCopy(newWhatToSave, whatToSave);
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
    if(type == 1) {
    
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
  }

  
  
} //end of memory class-----------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------










class chase { //Begin of chase class--------------------------------------------------------------------------------------------------------------------------------------
  //---------------------init all the variables--------------------------------
  int inputMode, outputMode; //What is input and what will output look like
  int beatModeId; //1, 2 or 3
  String beatMode; //kick, snare or hat
  
  
  int inputModeDownLimit = 0; //not so useful
  int outputModeDownLimit = 0; //not useful
  int inputModeUpLimit = 2; //what is the biggest inputMode which we can use
  int outputModeUpLimit = 2; //what is the biggest outputMode which we can use
  
  int fadeMode; //1 = from own, 2 = from own*master, 3 = from master
  
  int[] presets; //all the presets in chase
  
  int step;
  int brightness;
  int brightness1;
  boolean stepHasChanged;
  int fade;
  int finalFade;
  
  
  //----------------------end declaring variables--------------------------------
  
  
  
  memory parent;
  //You need to supply a memory parent for this to work properly
  chase(memory parent) {
    this.parent = parent;
  }
  
  int value;
  
  
  String getInputModeDesc() {
    String toReturn = "";
    switch(inputMode) {
      case 0: toReturn = "inherit"; break;
      case 1: toReturn = "beat"; break;
      case 2: toReturn = "manual"; break;
    }
    return toReturn;
  }
  
  String getOutputModeDesc() {
    String toReturn = "";
    switch(outputMode) {
      case 0: toReturn = "inherit"; break;
      case 1: toReturn = "steps"; break;
      case 2: toReturn = "eq"; break;
    }
    return toReturn;
  }
  
  String currentFadeMode() {
    String toReturn = "";
    switch(fadeMode) {
      case 1: toReturn = "Own"; break;
      case 2: toReturn = "Scaled Master"; break;
      case 3: toReturn = "Inherit"; break;
    }
    return toReturn;
  }
  
  void draw() {
    value = parent.getValue();
    fade = chaseFade;
    finalFade = fade * fade / 255;
    switch(outputMode) {
      case 1: beatToMoving(); break; 
      case 2: freqToLight(); break;
    }
   
  }
  
  
 
  

  
  //-----------------FUNCTIONS TO SET AND GET s2l BEATMODE-------------------------------------//|
                                                                                               //|
        void setBeatMode(String bM) {                                                          //|
          beatMode = bM;                                                                       //|
          if(bM.equals("beat")) { beatModeId = 1; }                                            //|
          if(bM.equals("kick")) { beatModeId = 2; }                                            //|
          if(bM.equals("snare")) { beatModeId = 3; }                                           //|
          if(bM.equals("hat")) { beatModeId = 4; }                                             //|
        }                                                                                      //|
                                                                                               //|
        void setBeatModeId(int bM) {                                                           //|
          beatModeId = bM;                                                                     //|
          switch(bM) {                                                                         //|
            case 0: beatMode = "inherit"; break;
            case 1: beatMode = "beat"; break;                                                  //|
            case 2: beatMode = "kick"; break;                                                  //|
            case 3: beatMode = "snare"; break;                                                 //|
            case 4: beatMode = "hat"; break;                                                   //|
          }                                                                                    //|
        }                                                                                      //|
                                                                                               //|
        String getBeatMode() {                                                                 //|
          return beatMode;                                                                     //|
        }                                                                                      //|
                                                                                               //|
        int getBeatModeId() {                                                                  //|
          return beatModeId;                                                                   //|
        }                                                                                      //|
                                                                                               //|
        void beatModeUp() {                                                                    //|
          setBeatModeId(getNext(getBeatModeId(), 1, 4));                                       //|
        }                                                                                      //|
        void beatModeDown() {                                                                  //|
          setBeatModeId(getReverse(getBeatModeId(), 1, 4));                                    //|
        }                                                                                      //|
                                                                                               //|
  //-----------------FUNCTIONS TO SET AND GET s2l BEATMODE END---------------------------------//|
  
  
  
  /* This function saves all the presets to presets[] 
  array if they are on (value is over 0) */
  void newChase() {
    int a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1) {
        if(memories[i].value > 0) {
          
          a++;
        }
      }
    }
    presets = new int[a];
    a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1) {
        if(memories[i].value > 0) {
          presets[a] = i;
          a++;
        }
      }
    }
    
    parent.type = 2;
    inputMode = 1;
    outputMode = 1;
    setBeatModeId(1);
    fade = 30;
  }
  
  /* This function checks that this memory is a chase 
  and the memory we're trying to control is a preset. */
  void loadPreset(int num, int val) {
    if(parent.type == 2) {
        memories[num].setValue(defaultConstrain(rMap(val, 0, 255, 0, value)));
    }
  }
  
      
  int[] getPresets() {
     //here function which returns all the presets in this chase
     return presets;
  }
  

  
  /*getNext returns always reverse value and checks that 
  if you already are at the smallest value then it goes to biggest value */
  int getReverse(int current, int lim_low, int lim_hi) {
    int toReturn = 0;
    if(current > lim_low) { toReturn = current - 1; }
    if(current == lim_low) { toReturn = lim_hi; }
    return toReturn;
  }
  
  /*getNext returns always next value and checks that 
  if you already are at the biggest value then it goes to smallest value */
  int getNext(int current, int lim_low, int lim_hi) {
    int toReturn = 0;
    if(current < lim_hi) { toReturn = current + 1; }
    if(current == lim_hi) { toReturn = lim_low; }
    return toReturn;
  }
  
  //getInvertedValue returns value inverted (0 -> 255, 255 -> 0)
  int getInvertedValue(int val, int lim_low, int lim_hi) {
    int toReturn = 0;
    toReturn = iMap(val, lim_low, lim_hi, lim_hi, lim_low);
    return toReturn;
  }
  
  boolean trigger() {
    boolean toReturn = false;
    if(inputMode == 1) {
      toReturn = s2l.beat(constrain(getBeatModeId(), 1, 3));
    }
    if(inputMode == 2) {
      toReturn = (nextStepPressed || (keyPressed && key == ' '));
    }
    return toReturn;
  }
  
  
  
  void changeFade(int val) {
    fade = defaultConstrain(val);
  }
  
  //defualtConstrain is used to constrain values between 0 and 255, because that is the range used in DMX.
  int defaultConstrain(int val) {
    int toReturn = 0;
    toReturn = constrain(val, 0, 255);
    return toReturn;
  }
  
  //iMap is function which actually is same as map but it returns value as int
  int iMap(int val, int in_low, int in_hi, int out_low, int out_hi) {
    int toReturn = 0;
    toReturn = int(map(val, in_low, in_hi, out_low, out_hi));
    return toReturn;
  }
  
  //rMap is function which actually is same as map but it returns rounded value as int
  int rMap(int val, int in_low, int in_hi, int out_low, int out_hi) {
    int toReturn = 0;
    toReturn = round(map(val, in_low, in_hi, out_low, out_hi));
    return toReturn;
  }
  
  
    
  
  void beatToLight() { //This function turns all the lights in chase on if there is beat, else it turns all the lights off
    boolean next; //boolean which tells do we want to go to next step
    next = trigger();
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
  
  void beatToMoving() {
    //This function goes through all the presets. When there is beat this goes to next preset
    //There is some problems with this function
    boolean next;
    next = trigger() && !stepHasChanged;
    if(next) { 
      step = getNext(step, 0, getPresets().length-1);
      brightness1 = 0;
      stepHasChanged = true;
    }
    if(stepHasChanged) {
      brightness1 += 1;
      if(brightness1 >= fade) {
        brightness1 = fade;
        stepHasChanged = false;
      }
      brightness = defaultConstrain(iMap(brightness1, 0, fade, 0, 255));
    }
    int s = step;
    int b = brightness;
    int rS = getReverse(s, 0, getPresets().length-1);
    loadPreset(getPresets()[s], b);
    loadPreset(getPresets()[rS], getInvertedValue(b, 0, 255));
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
  float[] avgTemp = new float[getFreqMax()];
  float[] avgCounter = new float[getFreqMax()];
  float[] avg = new float[getFreqMax()];
  float[] currentAvgTemp = new float[getFreqMax()];
  float[] currentAvg = new float[getFreqMax()];
  float[] currentAvgCounter = new float[getFreqMax()];
  //end initing variables
  
  
  soundDetect() {
    fft.forward( in.mix );
    bands = new float[fft.specSize()];
  }
  
  
  boolean beat(int bT) {
    beat.detect(in.mix); //beat detect command of minim library
    boolean toReturn = true;
    switch(bT) {
      case 1: toReturn = beat.isOnset(); break;
      case 2: toReturn = beat.isKick(); break;
      case 3: toReturn = beat.isSnare(); break;
      case 4: toReturn = beat.isHat(); break;
    }
    return toReturn;
  }
  
  
  int freq(int i) {
    fft.forward( in.mix );
    int toReturn = 0;
    toReturn = round((map(fft.getBand(i), avg[i], 255, 0, 255))*100);
    avgTemp[i] += fft.getBand(i);
    avgCounter[i]++;
    if(avgCounter[i] > 2000) {
      avg[i] = (avg[i] + (avgTemp[i] / avgCounter[i])) / 2;
      avgTemp[i] = 0;
      avgCounter[i] = 0;
    }
 /* currentAvgTemp[i] += fft.getBand(i);
    currentAvgCounter[i]++;
    if(currentAvgCounter[i] > 2) {
      currentAvg[i] = currentAvgTemp[i] / currentAvgCounter[i];
      currentAvgTemp[i] = 0;
      currentAvgCounter[i] = 0;
    } */
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


