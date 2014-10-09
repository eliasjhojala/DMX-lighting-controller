



//Maschine Mikro MK2 Interfacing


void maschineNote(int pitch, int velocity) {
  println("Maschine noteOn PITCH|" + pitch + "/VEL|" + velocity);
  
  //If velocity is not zero, the pad has been pressed down
  boolean down = velocity != 0;
  switch (pitch) {
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
    
    //Step back
    case 105: 
      maschineStepDirectionIsNext = false; 
      nextStepPressed = false; 
      Maschine.sendControllerChange(10, 105, 127);
      Maschine.sendControllerChange(10, 106, 0);
    break;
    //Step forward
    case 106: 
      maschineStepDirectionIsNext = true; 
      revStepPressed = false; 
      Maschine.sendControllerChange(10, 105, 0);
      Maschine.sendControllerChange(10, 106, 127);
    break;
    
    //BlackOut
    case 119: blackOut = value == 127; break;
  }
  
}
