//Tässä välilehdessä piirretään ylävalikko, ja käsitellään sen nappuloiden komentoja 

void ylavalikko() {
  if(move == false && mouseY < height - 200 && mouseY > 50 && mouseX < width-120 && (!mouseLocked || mouseLocker == "main")) { //Tarkistetaan mm. ettei hiiri ole lukittuna jollekin muulle alueelle
    mouseLocked = true;
    mouseLocker = "main";
    if(mouseClicked) {    
      movePage();
    }
  }
  if(!move) {
    oldMouseX = mouseX;
    oldMouseY = mouseY;
  }
  stroke(255, 255, 255); 
  if(mouseX > 0 && mouseX < width/4 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    fill(0, 0, 255);
    if(move == true) {
      move = false;
      delay(100);
    }
    else {
      move = true;
      delay(100);
    }
    mouseReleased = false;
  }
  else {
    fill(255, 0, 0);
  }
  rect(0, 0, width/4, 50);
  fill(255, 255, 255);
  if(move == true) {
    text("Now: Move and edit fixtures", 30, 20);
    text("Next: Move and zoom area", 30, 35);
  }
  else {
    text("Now: Move and zoom area", 30, 20);
    text("Next: Move and edit fixtures", 30, 35);
  }
  
  if(mouseX > width/4 && mouseX < width/4*2 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    if(mouseReleased == true) {
      mouseReleased = false;
      fill(0, 0, 255);
      for(int i = 0; i < numberOfMemories; i++) {
      if(memoryType[i] != 0) {
        presetNumero = i+1;
      }
    }
      makingPreset = true;
    }
  }
  else {
    fill(255, 0, 0);
  }
  
  
  rect(width/4*1, 0, width/4, 50);
  fill(255, 255, 255);
  text("Make preset from active fixtures", width/4+30, 30);
  if(mouseX > width/4*2 && mouseX < width/4*3 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    fill(0, 0, 255);
    for(int i = 0; i < numberOfMemories; i++) {
      if(memoryType[i] != 0) {
        presetNumero = i+1;
      }
    }
    makingSoundToLightFromPreset = true;
  }
  else {
    fill(255, 0, 0);
  }
  rect(width/4*2, 0, width/4, 50);
  fill(255, 255, 255);
  text("Make SoundToLight from active presets", width/4*2+30, 30);
  if(mouseX > width/4*3 && mouseX < width/4*4 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    fill(0, 0, 255);
    chaseMode++;
    if(chaseMode > 5) {
      chaseMode = 1;
    }
    mouseReleased = false;
  }
  else {
    fill(255, 0, 0);
  }
  rect(width/4*3, 0, width/4, 50);
  fill(255, 255, 255);
  text("chaseMode: " + str(chaseMode), width/4*3+30, 30);
  
  
  if(makingPreset == true) {
    fill(0, 0, 255);
    rect(width/2-300, height/2-200, 500, 200);
    fill(255, 255, 255);
    text("Valitse nuolinäppäimillä haluamasi memorypaikka", width/2-300+20, height/2-200+50);
    text("ja paina välilyöntiä (UP +1, DOWN -1, RIGHT +10, LEFT -10)", width/2-300+20, height/2-200+70);
    if(keyPressed == true && keyReleased == true) {
      keyReleased = false;
    if(keyCode == UP) {
      presetNumero++;
    }
    if(keyCode == DOWN) {
      presetNumero--;
    }
    if(keyCode == LEFT) {
      presetNumero = presetNumero - 10;
    }
    if(keyCode == RIGHT) {
      presetNumero = presetNumero + 10;
    }
    if(key == ' ') {
      makePreset(presetNumero);
      makingPreset = false;
    }
    if(key == 'x') {
      makingPreset = false;
      presetNumero--;
    }
    delay(100);
    }
    else {
      keyReleased = true;
    }
    fill(255, 255, 255);
    text("Valintasi: ",  width/2-300+20, height/2-200+90);
    text(str(presetNumero),  width/2-300+130, height/2-200+90);
  }
  
  if(makingSoundToLightFromPreset == true) {
    fill(0, 0, 255);
    rect(width/2-300, height/2-200, 500, 200);
    fill(255, 255, 255);
    text("Valitse nuolinäppäimillä haluamasi memorypaikka", width/2-300+20, height/2-200+50);
    text("ja paina välilyöntiä (UP +1, DOWN -1, RIGHT +10, LEFT -10)", width/2-300+20, height/2-200+70);
    if(keyPressed == true && keyReleased == true) {
    keyReleased = false;
    if(keyCode == UP) {
      presetNumero++;
    }
    if(keyCode == DOWN) {
      presetNumero--;
    }
    if(keyCode == LEFT) {
      presetNumero = presetNumero - 10;
    }
    if(keyCode == RIGHT) {
      presetNumero = presetNumero + 10;
    }
    if(key == ' ') {
      soundToLightFromPreset(presetNumero);
      makingSoundToLightFromPreset = false;
    }
    if(key == 'x') {
      makingSoundToLightFromPreset = false;
      presetNumero--;
    }
    delay(100);
    }
    else {
      keyReleased = true;
    }
    fill(255, 255, 255);
    text("Valintasi: ",  width/2-300+20, height/2-200+90);
    text(str(presetNumero),  width/2-300+130, height/2-200+90);
  }
  
  if(presetMenu == true) {
    fill(255, 255, 255);
    rect(width/2-200, 100, 500, 400);
    fill(0, 0, 255);
    stroke(0, 0, 0);
    for(int i = 0; i < 20; i++) {
      if(mouseX > width/2-200 && mouseX < width/2+200 && mouseY > 100+20*i && mouseY < 100+20*(i+1) && mouseClicked == true) {
        if(i == 1) { selectingSoundToLight = true; presetMenu = false; }
        fill(100, 100, 255);
      }
      else {
        fill(0, 0, 255);
      }
      rect(width/2-200, 100+20*i, 500, 20);
      fill(255, 255, 255);
      String teksti = "teksti";
      if(i == 1) { teksti = "Sound to lightin valinta"; }
      text(teksti, width/2-200+10, 100+20*(i+1)-2);
    }
    if(keyPressed == true) {
    if(key == 'x') {
      presetMenu = false;
    }
    }
    
  }
  
  if(selectingSoundToLight == true) {
    fill(0, 0, 255);
    rect(width/2-300, height/2-200, 500, 200);
    fill(255, 255, 255);
    text("Valitse nuolinäppäimillä haluamasi memorypaikka", width/2-300+20, height/2-200+50);
    text("ja paina välilyöntiä (UP +1, DOWN -1, RIGHT +10, LEFT -10)", width/2-300+20, height/2-200+70);
    text("0 on taajuuksiin perustuva Sound To Light", width/2-300+20, height/2-200+90);
    text("Muut ovat biitteihin perustuvia", width/2-300+20, height/2-200+110);
    if(keyPressed == true && keyReleased == true) {
    keyReleased = false;
    if(keyCode == UP) {
      soundToLightNumero++;
    }
    if(keyCode == DOWN) {
      soundToLightNumero--;
    }
    if(key == ' ') {
      selectingSoundToLight = false;
      
    }
    if(key == 'x') {
      selectingSoundToLight = false;
    }
    delay(100);
    }
    else {
      keyReleased = true;
    }
    fill(255, 255, 255);
    text("Valintasi: ",  width/2-300+20, height/2-200+130);
    text(str(soundToLightNumero),  width/2-300+130, height/2-200+130);
  }
}
