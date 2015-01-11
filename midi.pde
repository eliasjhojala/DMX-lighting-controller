class behringerLC2412 {
  int[][] faderValue; //[row][number]
  boolean[] buttons; //[number]
  int masterAvalue;
  int masterBvalue;
  int masterValue;
  int speedValue, xFadeValue, chaserValue;
  int bank;
  int chaserNumber;
  boolean stepKey, channelFlashKey, soloKey, special1Key, special2Key, manualKey, chaserModeKey, insertKey, presetKey, memoryKey;
  
  void midiMessageIn(int num, int val) {
    if(isBetween(num, 0, 11)) {
      faderValue[0][num] = midiToDMX(val);
    }
    else if(isBetween(num, 12, 23)) {
      faderValue[1][num-12] = midiToDMX(val);
    }
    else if(isBetween(num, 31, 42)) {
      buttons[num-31] = midiToBoolean(val);
    }
    else {
      switch(num) {
        case 24: speedValue = midiToDMX(val);
        case 25: xFadeValue = midiToDMX(val);
        case 26: chaserValue = midiToDMX(val);
        case 27: masterValue = midiToDMX(val);
        case 28: masterAvalue = midiToDMX(val);
        case 29: masterBvalue = midiToDMX(val);
        case 30: stepKey = midiToBoolean(val);
        case 43: bank = val;
        case 44: chaserNumber = val;
        case 45: channelFlashKey = midiToBoolean(val);
        case 46: soloKey = midiToBoolean(val);
        case 47: special1Key = midiToBoolean(val);
        case 48: special2Key = midiToBoolean(val);
        case 49: manualKey = midiToBoolean(val);
        case 50: chaserModeKey = midiToBoolean(val);
        case 51: insertKey = midiToBoolean(val);
        case 52: presetKey = midiToBoolean(val);
        case 53: memoryKey = midiToBoolean(val);
      }
    }
  }
}

boolean midiToBoolean(int val) {
  return val > 63;
}
int midiToDMX(int val) {
  return rMap(val, 0, 127, 0, 255);
}

class LaunchpadData {
  LaunchpadData() {
  }
  boolean[][] button = new boolean[8][8];
}
 
 void createMidiClasses() {
   LaunchpadData launchpadData = new LaunchpadData();
 }

 LaunchpadData launchpadData;


 
//Maschine Mikro MK2 Interfacing -------------------------------------------------------------------------------------------------------

//This void is executed on program start
void initializeMaschine() {
  //Set left-right buttons so, that only the right one is lit
  Maschine.sendControllerChange(10, 105, 0);
  Maschine.sendControllerChange(10, 106, 127);
  
  //Set mute button's light off
  Maschine.sendControllerChange(10, 119, 0);
  
  //Clear pad selection
  selectMaschinePad(1, false);
  
  //Turn the play button light on according to current pause status

}

//0: panDo, 1: tiltDo, 2: panUp, 3: tiltUp
boolean[] maschineManualMHadjustButtons = new boolean[4];


void maschineNote(int pitch, int velocity) {
  println("Maschine noteOn PITCH|" + pitch + "/VEL|" + velocity);
  
  //If velocity is not zero, the pad has been pressed down
  boolean down = velocity != 0;
  switch (pitch) {
    //Next step according to direction
    case 12: triggerStepFromMaschine(down); break;
    
    //These are tha pads for adjusting the moving heads manually
    case 36: maschineManualMHadjustButtons[0] = down; break;
    case 38: maschineManualMHadjustButtons[1] = down; break;
    case 40: maschineManualMHadjustButtons[2] = down; break;
    case 41: maschineManualMHadjustButtons[3] = down; break;
  }
  //Trigger moving head preset
  if(pitch >= 14 && pitch <= 28 && velocity != 0) {

    selectMaschinePad(pitch - 13, true);
  }
}


void triggerStepFromMaschine(boolean onOrOff) {
  if (maschineStepDirectionIsNext) nextStepPressed = onOrOff; 
        else revStepPressed = onOrOff;
        
  //Toggle step direction, as nextRevAutoChange is true
  if (nextRevAutoChange && !onOrOff) setMaschineStepDirection(!maschineStepDirectionIsNext);
}


//Select a maschine pad and turn all the rest off
//This only affects pads 2-16
//The putOn parameter affects whether the selected pad will be lit on or not (to use for clearing)
void selectMaschinePad(int padId, boolean putOn) {
  //2nd pad is at 14
  Maschine.sendNoteOn(10, padId + 13, 127);
  
  //Turn the rest off 
  for (int i = 1; i <= 16; i++) {
    if (i != padId || !putOn) Maschine.sendNoteOn(10, i + 13, 0); 
  }
}

boolean maschineStepDirectionIsNext = true;

int maschineKnobVal = 0;

boolean nextRevAutoChange = false;

void setMaschineStepDirection(boolean direction) {
  if (direction) {
    maschineStepDirectionIsNext = true;
    Maschine.sendControllerChange(10, 105, 0);
    Maschine.sendControllerChange(10, 106, 127);
  } else {
    maschineStepDirectionIsNext = false;
    Maschine.sendControllerChange(10, 105, 127);
    Maschine.sendControllerChange(10, 106, 0);
  }
  
   
}



void maschineControllerChange(int number, int value) {
  
  println("Maschine CC NUMBER|" + number + "/VALUE|" + value);
  switch(number) {
    case 22:
      //Knob rotated
      maschineKnobRotated(value == 1);
    break;
    
    //CONTROL button, next chase mode
    case 92: nextChaseMode(); break;
    
    //Step direction: back
    case 105: 
      setMaschineStepDirection(false);
    break;
    //Step direction: forward
    case 106: 
      setMaschineStepDirection(true);
    break;
    
    //toggle BlackOut
    case 119: 
      blackOutToggle();
      //Turn the mute button light on according to current blackout status
      if(blackOut) Maschine.sendControllerChange(10, 119, 127); else Maschine.sendControllerChange(10, 119, 0);
    break;
    
    //toggle fullOn
    case 112: 
      fullOnToggle();
      //Turn the mute button light on according to current blackout status
      if(fullOn) Maschine.sendControllerChange(10, 112, 127); else Maschine.sendControllerChange(10, 112, 0);
    break;
    
    
    //toggle chasePause
    case 108: 

      //Turn the play button light on according to current pause status

    break;
    
    //register tempo tap (REC button)
    case 109: registerTempoTapTap(); break;
    //clear automatic temp tapping (ERASE button)
    case 110: clearMaschineAutoTap(); break;
    
    //toggle nextRevAutoChange
    case 117: 
      nextRevAutoChange = !nextRevAutoChange;
      //Turn the select button light on according to current nextRecAutoChange status
      if(nextRevAutoChange) Maschine.sendControllerChange(10, 117, 127); else Maschine.sendControllerChange(10, 117, 0);
    break;
    
  }
  
}

void maschineKnobRotated(boolean positive) {
  if(positive) {
    if (maschineKnobVal < 30) maschineKnobVal++; else maschineKnobVal = 0;
  } else {
    if (maschineKnobVal > 0) maschineKnobVal--; else maschineKnobVal = 30;
  }
  println(maschineKnobVal);
  doByMaschineKnob();
}

void doByMaschineKnob() {
  //Current task: rotate main window view
  pageRotation = int(map(maschineKnobVal, 0, 31, 0, 360));
}


//Tempo tap feature (MAT = Maschine Auto Tap)----------

//How many times the rec button has been pressed (4 is needed to start MAT)
int tempotapTapCount = 0;
int[] tempotapTaps = new int[4];
int tapStartMillis;

boolean MATenable = false;
int MATinterval;

//This is triggered when the rec button is pressed
void registerTempoTapTap() {
  if (!MATenable) {
    //Go to next step
    MATstepTriggered = true; triggerStepFromMaschine(true);
    if (tempotapTapCount < 3) {
      if (tempotapTapCount == 0) tapStartMillis = millis();
      tempotapTaps[tempotapTapCount] = millis() - tapStartMillis;
      
      tempotapTapCount++;
    } else {
      //Tempo tap finished. Calculate interval and begin automatic "tapping"
      tempotapTaps[3] = millis() - tapStartMillis;
      
      //calculate automatic tap interval
      
      //Calculate total sum of intervals between taps
      int total = 0;
      for (int i = 1; i <= 3; i++) {
        total += tempotapTaps[i] - tempotapTaps[i - 1];
      }
      //Take average
      MATinterval = int(total/3);
      MATenable = true;
    }
  }
}

boolean MATstepTriggered = false;
int MATlastStepMillis;
//This function gets triggered every draw, so it can be used for other purposes as well.
void calcMaschineAutoTap() {

  //------AutoTap calculations
  //Always turn off the booleans if they were put to true last time
  if(MATstepTriggered) { MATstepTriggered = false; triggerStepFromMaschine(false); Maschine.sendControllerChange(10, 109, 0); }
  if(MATenable) {
    if(millis() > MATlastStepMillis + MATinterval) {
      MATstepTriggered = true;
      triggerStepFromMaschine(true);
      Maschine.sendControllerChange(10, 109, 127);
      MATlastStepMillis = millis();
    }
  }
  
}

//Clean up MAT variables
void clearMaschineAutoTap() {
  tempotapTapCount = 0;
  tempotapTaps = new int[4];
  tapStartMillis = 0;
  
  MATenable = false;
  MATinterval = 0;
}
