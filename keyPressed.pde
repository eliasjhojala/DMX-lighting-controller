//Tässä välilehdessä luetaan tietokoneen omia syöttölaitteita, eli näppäimistöä ja hiirtä

boolean ctrlDown = false;
boolean shftDown = false;

void keyReleased() {
  keyReleased = true;
  if(key == 'r') { revStepPressed = false; }

}
void keyPressed() {
  
  if(key==27) { key=0; } //Otetaan esc-näppäin pois käytöstä. on kumminkin huomioitava, että tämä toimii vain pääikkunassa
  if(key == 'm') {
    showMode = !showMode;
  }
  if(key == 'p') { chasePause = !chasePause; }
  if(key == 'r') { revStepPressed = true; }
  if(key == '1') { lampToMove = 1; }
  if(key == 'l') { thread("loadAllData"); }
  if(key == 'c') {
    for(int i = 0; i < channels; i++) {
      valueOfDimBeforeBlackout[i] = 0;
      valueOfDimBeforeFullOn[i] = 0;
    }
  }
  
  if(keyCode == 17) { ctrlDown = true; }
  if(keyCode == 16) { shftDown = true; println("toimii"); }
  if(key == 'o') { fileDialogInput(); ctrlDown = false; }
  if(key == 's') {
    if(shftDown) {
      fileDialogOutput();
      shftDown = false; println("TOIMII");
    }
    else {
      saveAllData();
    }
  }

  if(key == 'u') {
      if(upper == true) { enttecDMXplace = enttecDMXplace - 1; upper = false; }
      else { enttecDMXplace = enttecDMXplace + 1; upper = true; }
  } 
}


void mousePressed() {
  mouseClicked = true;
}
void mouseReleased() {
  mouseClicked = false;
  mouseReleased = true;
}
