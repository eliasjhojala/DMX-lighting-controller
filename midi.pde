



//Maschine Mikro MK2 Interfacing

//This void is executed on program start
void initializeMaschine() {
  //Set left-right buttons so, that only the right one is lit
  Maschine.sendControllerChange(10, 105, 0);
  Maschine.sendControllerChange(10, 106, 127);
  
  //Set mute button's light off
  Maschine.sendControllerChange(10, 119, 0);
  
  //Clear pad selection
  selectMaschinePad(1, false);
}


void maschineNote(int pitch, int velocity) {
  println("Maschine noteOn PITCH|" + pitch + "/VEL|" + velocity);
  
  //If velocity is not zero, the pad has been pressed down
  boolean down = velocity != 0;
  switch (pitch) {
    //Next step according to direction
    case 12: 
      if (maschineStepDirectionIsNext) nextStepPressed = down; 
        else revStepPressed = down;
      break;
  }
  //Trigger moving head preset
  if(pitch >= 14 && pitch <= 28) {
    showPreset(pitch - 14, 0);
    selectMaschinePad(pitch - 13, true);
  }
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

void maschineControllerChange(int number, int value) {
  
  println("Maschine CC NUMBER|" + number + "/VALUE|" + value);
  switch(number) {
    case 22:
      //Knob rotated
      maschineKnobRotated(value == 1);
    break;
    
    //Step direction: back
    case 105: 
      maschineStepDirectionIsNext = false; 
      nextStepPressed = false; 
      Maschine.sendControllerChange(10, 105, 127);
      Maschine.sendControllerChange(10, 106, 0);
    break;
    //Step direction: forward
    case 106: 
      maschineStepDirectionIsNext = true; 
      revStepPressed = false; 
      Maschine.sendControllerChange(10, 105, 0);
      Maschine.sendControllerChange(10, 106, 127);
    break;
    
    //toggle BlackOut
    case 119: 
      blackOut = !blackOut; 
      
      //Turn the mute buttons light on according to current blackout status
      if(blackOut) Maschine.sendControllerChange(10, 119, 127); else Maschine.sendControllerChange(10, 119, 0);
      
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
