

 

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
  if(!chasePause) Maschine.sendControllerChange(10, 108, 127); else Maschine.sendControllerChange(10, 108, 0);
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
      chasePause = !chasePause;
      //Turn the play button light on according to current pause status
      if(!chasePause) Maschine.sendControllerChange(10, 108, 127); else Maschine.sendControllerChange(10, 108, 0);
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
  //If there is a beat, put the GRID button light on.
  if (biitti) Maschine.sendControllerChange(10, 107, 127); else Maschine.sendControllerChange(10, 107, 0);
  
  //Add to moving head values if associated pads are pressed down
  /*if (maschineManualMHadjustButtons[0] && mhx50_panValue[0] != 0) { mhx50_panValue[0]--; midiPositionButtonPressed = true; }
  if (maschineManualMHadjustButtons[0] && mhx50_panValue[1] != 0) { mhx50_panValue[1]--; midiPositionButtonPressed = true; }
  
  if (maschineManualMHadjustButtons[2] && mhx50_panValue[0] != 255) { mhx50_panValue[0]++; midiPositionButtonPressed = true; }
  if (maschineManualMHadjustButtons[2] && mhx50_panValue[1] != 255) { mhx50_panValue[1]++; midiPositionButtonPressed = true; }
  
  if (maschineManualMHadjustButtons[1] && mhx50_tiltValue[0] != 0) { mhx50_tiltValue[0]--; midiPositionButtonPressed = true; }
  if (maschineManualMHadjustButtons[1] && mhx50_tiltValue[1] != 0) { mhx50_tiltValue[1]--; midiPositionButtonPressed = true; }
  
  if (maschineManualMHadjustButtons[3] && mhx50_tiltValue[0] != 255) { mhx50_tiltValue[0]++; midiPositionButtonPressed = true; }
  if (maschineManualMHadjustButtons[3] && mhx50_tiltValue[1] != 255) { mhx50_tiltValue[1]++; midiPositionButtonPressed = true; }*/

  
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
