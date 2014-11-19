//Tässä välilehdessä luetaan tietokoneen omia syöttölaitteita, eli näppäimistöä ja hiirtä

void keyReleased() {
  keyReleased = true;
  if(key == 'r') { revStepPressed = false; }
}
void keyPressed() {
  if(key==27) { key=0; } //Otetaan esc-näppäin pois käytöstä. on kumminkin huomioitava, että tämä toimii vain pääikkunassa
  if(key == 'm') {
    if(move == true) { move = false; moveLamp = false; delay(10); }
    else { zoom = 100; x_siirto = 0; y_siirto = 0; move = true; delay(10); }
  }
  if(key == 'p') { chasePause = !chasePause; }
  if(key == 'r') { revStepPressed = true; }
  if(key == '1') { lampToMove = 1; }
  if(key == 's') { thread("saveAllData"); }
  if(key == 'l') { thread("loadAllData"); }
  if(key == 'c') {
    for(int i = 0; i < channels; i++) {
      valueOfDimBeforeBlackout[i] = 0;
      valueOfDimBeforeFullOn[i] = 0;
    }
  }

  if(key == 'u') {
      if(upper == true) { enttecDMXplace = enttecDMXplace - 1; upper = false; }
      else { enttecDMXplace = enttecDMXplace + 1; upper = true; }
  } 
  
  if(keyCode == RIGHT) {
   bottomMenuOrder[changeColorFixtureId] = constrain(bottomMenuOrder[changeColorFixtureId] + 1, 0, 1000);
  }
  if(keyCode == LEFT) {
   bottomMenuOrder[changeColorFixtureId] = constrain(bottomMenuOrder[changeColorFixtureId] - 1, 0, 1000);
  }
}


void mousePressed() {
  mouseClicked = true;
}
void mouseReleased() {
  mouseClicked = false;
  mouseReleased = true;
}
