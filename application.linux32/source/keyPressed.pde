void keyReleased() {
  keyReleased = true;
}
void keyPressed() {
  if(key == 'm') {
    if(move == true) {
      move = false;
      moveLamp = false;
      delay(10);
    }
    else {
      zoom = 100;
      x_siirto = 0;
      y_siirto = 0;
      move = true;
      delay(10);
    }
  }
  if(key == '1') {
    lampToMove = 1;
  }
  if(key == 's') {
    
    saveAllData();
    

    
  }
  if(key == 'l') {
    
    loadAllData();
    

  }
  
  if(key == 'r') {
    if(rec == true) {
      rec = false;

    }
    else {
      rec = true;
    }
  }
  if(key == 'p') {
    if(play == true) {
      play = false;
    }
    else {
      play = true;
    }
  }
  if(key == 'c') {
    if(chase == true) {
      chase = false;
    }
    else {
      chase = true;
    }
  }
//  if(key == 'b') {
//    if(dmxSoundToLight == true) {
//      dmxSoundToLight = false;
//    }
//    else {
//      dmxSoundToLight = true;
//    }
//  }
 if(key == 'u') {
    if(upper == true) {
      enttecDMXplace = enttecDMXplace - 1;
      upper = false;
    }
    else {
      enttecDMXplace = enttecDMXplace + 1;
      upper = true;
    }
  } 
  
}
void mousePressed() {
  mouseClicked = true;
}
void mouseReleased() {
  mouseClicked = false;
  mouseReleased = true;
}
