



//Maschine Mikro MK2 Interfacing

//This void is executed on program start
void initializeMaschine() {
  //Set left-right buttons so, that only the right one is lit
  Maschine.sendControllerChange(10, 105, 0);
  Maschine.sendControllerChange(10, 106, 127);
  
  //Set mute buttons light off
  Maschine.sendControllerChange(10, 119, 0);
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
}

boolean maschineStepDirectionIsNext = true;

void maschineControllerChange(int number, int value) {
  println("Maschine CC NUMBER|" + number + "/VALUE|" + value);
  switch(number) {
    
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
      int tempVal;
      if(blackOut) tempVal = 127;
      Maschine.sendControllerChange(10, 119, tempVal);
    break;
  }
  
}
