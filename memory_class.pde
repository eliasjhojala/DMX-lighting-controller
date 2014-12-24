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
  memory[] memories = new memory[1000];
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
  int value;
  int inputMode, outputMode, beatModeId; //What is input and what will output look like
  String beatMode = new String(); //kick, snare or hat
 
  
  int[] inputModeLimit = { 1, 3 };
  int[] outputModeLimit = { 1, 2 };
  int[] fadeModeLimit = { 1, 3 };
  int[] beatModeLimit = { 2, 4 };
  
  int fadeMode; //1 = from own, 2 = from own*master, 3 = from master
  
  int[] presets; //all the presets in chase
  
  int step, brightness, brightness1;
  boolean stepHasChanged;
  int fade, ownFade;
  
  
  //----------------------end declaring variables--------------------------------
  
  
  
  memory parent;
  //You need to supply a memory parent for this to work properly
  chase(memory parent) {
    this.parent = parent;
  }

  
  void draw() {
    setValue();
    setFade();
    output();
  }
  
  void setValue() {
    value = parent.getValue();
  }

  
  //fadeMode functions
      void changeFade(int val) {
        ownFade = defaultConstrain(val);
      }
      void fadeModeUp() {
        fadeMode = getNext(fadeMode, fadeModeLimit);
      }
      void fadeModeDown() {
        fadeMode = getReverse(fadeMode, fadeModeLimit);
      }
      
        String getFadeModeDesc() {
        String toReturn = "";
        switch(fadeMode) {
          case 1: toReturn = "Own"; break;
          case 2: toReturn = "Scaled Master"; break;
          case 3: toReturn = "Inherit"; break;
        }
        return toReturn;
      }
      
        void setFade() {
          switch(fadeMode) {
            case 1: fade = ownFade; break;
            case 2: fade = (ownFade + chaseFade) / 2; break;
            case 3: fade = chaseFade; break;
            default: fade = chaseFade;
          }
        }
  //End of fadeMode functions
  
 
 
    
   //beatMode functions                                                                                        
        void setBeatMode(String bM) {                                                          
          beatMode = bM;                                                                       
          if(bM.equals("beat")) { beatModeId = 1; }                                            
          if(bM.equals("kick")) { beatModeId = 2; }                                            
          if(bM.equals("snare")) { beatModeId = 3; }                                           
          if(bM.equals("hat")) { beatModeId = 4; }                                             
        }                                                                                      
                                                                                               
        void setBeatModeId(int bM) {                                                           
          beatModeId = bM;                                                                     
          switch(bM) {                                                                         
            case 0: beatMode = "inherit"; break;
            case 1: beatMode = "beat"; break;                                                  
            case 2: beatMode = "kick"; break;                                                  
            case 3: beatMode = "snare"; break;                                                 
            case 4: beatMode = "hat"; break;                                                   
          }                                                                                    
        }                                                                                      
                                                                                               
        String getBeatMode() {                                                                 
          return beatMode;                                                                     
        }                                                                                      
                                                                                               
        int getBeatModeId() {                                                                  
          return beatModeId;                                                                   
        }                                                                                      
                                                                                               
        void beatModeUp() {                                                                    
          setBeatModeId(getNext(getBeatModeId(), beatModeLimit));                                       
        }                                                                                      
        void beatModeDown() {                                                                  
          setBeatModeId(getReverse(getBeatModeId(), beatModeLimit));                                    
        }                                                                                      
   //End of beatMode functions
   
   
   
   //input and output mode functions
        void changeInputMode(int v) {
          inputMode = constrain(v, inputModeLimit[0], inputModeLimit[1]);
        }
        void changeOutputMode(int v) {
          outputMode = constrain(v, outputModeLimit[0], outputModeLimit[1]);
        }
        
        void inputModeUp() {
          inputMode = getNext(inputMode, inputModeLimit);
        }
        void inputModeDown() {
          inputMode = getReverse(inputMode, inputModeLimit);
        }
        void outputModeUp() {
          outputMode = getNext(outputMode, outputModeLimit);
        }
        void outputModeDown() {
          outputMode = getReverse(outputMode, outputModeLimit);
        }
        
        void output() {
          switch(outputMode) {
            case 1: beatToMoving(); break; 
            case 2: freqToLight(); break;
          }
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
        

        String getInputModeDesc() {
          String toReturn = "";
          switch(inputMode) {
            case 0: toReturn = "inherit"; break;
            case 1: toReturn = "beat"; break;
            case 2: toReturn = "manual"; break;
            case 3: toReturn = "auto"; break;
          }
          return toReturn;
        }
        
          boolean trigger() {
            boolean toReturn = false;
            switch(inputMode) {
              case 1: toReturn = s2l.beat(constrain(getBeatModeId(), beatModeLimit[0], beatModeLimit[1])); break;
              case 2: toReturn = (nextStepPressed || (keyPressed && key == ' ')); break;
              case 3: toReturn = true; break;
            }
            return toReturn;
          }
   //End of input and output mode functions
   
  
  
  
  /* This function saves all the presets to presets[] 
  array if they are on (value is over 0) */
  void newChase() {
    createPresetsArray();
    makePresetsArray();
    setParentType(2); 
  }
  
  int getNumberOfActivePresets() {
    int a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1 && memories[i].value > 0) { a++; }
    }
    return a;
  }
  
  void createPresetsArray() {
    presets = new int[getNumberOfActivePresets()];
  }
  
  void makePresetsArray() {
    int a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1 && memories[i].value > 0) {
          presets[a] = i;
          a++;
      }
    }
  }
  
  void setParentType(int t) {
    parent.type = t;
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
    int rS = getReverse(step, 0, getPresets().length-1);
    loadPreset(getPresets()[step], brightness);
    loadPreset(getPresets()[rS], getInvertedValue(brightness, 0, 255));
  }
  
  void freqToLight() { //This function gives frequence values to chase presets
    for(int i = 0; i < getPresets().length; i++) {
      loadPreset(getPresets()[i], s2l.freq(iMap(i, 0, getPresets().length, 0, s2l.getFreqMax())));
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



class quickChase {
  quickChase() {
  }
  
 int[] fixturesInChase;
 
 void create() {
     int a = 0;
     
     for(int i = 0; i < fixtures.length; i++) {
       if(fixtures[i].selected) {
         a++;
       }
     }
     fixturesInChase = new int[a];

     int[] x = new int[a];
     a = 0;
     for(int i = 0; i < fixtures.length; i++) {
       if(fixtures[i].selected) {
         fixturesInChase[a] = i;
         a++;
       }
     }
     for(int i = 0; i < fixturesInChase.length; i++) {
       x[i] = fixtures[fixturesInChase[i]].locationOnScreenX;
     }
     
     
     int[] fixturesInChaseTemp = new int[fixturesInChase.length];
     for(int i = 0; i < fixturesInChase.length; i++) {
       fixturesInChaseTemp[i] = fixturesInChase[i];
     }
     for(int i = 0; i < fixturesInChase.length; i++) {
       fixturesInChase[i] = fixturesInChaseTemp[sortIndex(x)[i]];
     }
     
     println("READY");
     println(fixturesInChase);
     
     

 }
 
      int[] sortIndex(int[] toSort) {
       int[] toReturn = new int[toSort.length];
       int[] sorted = new int[toSort.length];
       boolean[] used = new boolean[toSort.length];
       
       sorted = sort(toSort);
       
       for(int i = 0; i < toSort.length; i++) {
         for(int j = 0; j < sorted.length; j++) {
           if(toSort[i] == sorted[j] && !used[j]) {
             toReturn[j] = i;
             used[j] = true;
             break;
           }
         }
       }
       return toReturn;
     }
 
 
 int ij = 0;
 void load() {
   ij++; 
   if(ij >= fixturesInChase.length) { ij = 0; }
   fixtures[fixturesInChase[ij]].dimmerPresetTarget = 255;
   delay(500);
   fixtures[fixturesInChase[ij]].dimmerPresetTarget = 0;
   
 }
  
}
