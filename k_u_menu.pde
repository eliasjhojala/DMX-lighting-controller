//Tässä välilehdessä piirretään ylävalikko, ja käsitellään sen nappuloiden komentoja 

color topMenuTheme = color(222, 0, 0);
color topMenuTheme2 = color(200, 0, 0);
color topMenuAccent = color(150, 0, 0);

PShape settingsIcon;

void ylavalikkoSetup() {
  settingsIcon = loadShape("settingsIcon.svg");
  settingsIcon.disableStyle();
}

void ylavalikko() {
  pushStyle();
  
  //Main bubble size
  int bubS = 250;
  if (inBoundsCircle(0, 0, bubS/2, mouseX, mouseY)) bubS += 10;
  
  //main bubble shadow
  noFill();
  stroke(0, 120); strokeWeight(6);
  arc(0, 0, bubS, bubS, 0, HALF_PI);
  
  //Settings button
  
  //Hover
  boolean settingsHover = isHoverSimple(bubS/2, 0, 60, 60);
  
  noFill();
  stroke(0, 120); strokeWeight(6);
  arc(bubS/2, 0, 120, 120, 0, HALF_PI + QUARTER_PI);
  fill(topMenuTheme2);
  stroke(topMenuAccent); strokeWeight(2);
  arc(bubS/2, 0, 120, 120, 0, HALF_PI + QUARTER_PI);
  
  
  pushMatrix();
  strokeWeight(10);
  stroke(settingsHover ? 255 : 240);
  fill(settingsHover ? 255 : 240);
  translate(bubS/2 + 4, 4);
  scale(0.08);
  shape(settingsIcon);
  popMatrix();
  
  
  
  
  //Main bubble itself
  fill(topMenuTheme);
  stroke(topMenuAccent); strokeWeight(2);
  arc(0, 0, bubS, bubS, 0, HALF_PI);
  
  
  
  
  //Time display
  fill(255);
  textSize(25);
  text(hour() + ":" + minute() + ":" + second(), 3, 28);
  textSize(12);
  
  
  text("Loaded file: ", 3, 28, 125, 125);
  
  popStyle();
  if(move == false && inBdsMouse(0, 0, width - 120, height - 225) && !isHoverBottomMenu() && (!mouseLocked || mouseLocker == "main")) {
    if(mousePressed) {
      mouseLocked = true;
      mouseLocker = "main";
      movePage();
    }
  }
  if(!move) {
    oldMouseX = mouseX;
    oldMouseY = mouseY;
  }
  
}

void nextChaseMode() {
  resetChaseVariables();
  chaseMode++;
  if(chaseMode > 8) {
    chaseMode = 1;
  }
  sendDataToIpad("/chaseMode", chaseMode);
  resetChaseVariables();
}

void reverseChaseMode() {
  resetChaseVariables();
  chaseMode--;
  if(chaseMode < 1) {
    chaseMode = 8;
  }
  sendDataToIpad("/chaseMode", chaseMode);
  resetChaseVariables();
}

void resetChaseVariables() {
  //This void resets all the chase variables, because otherwise chaseModes could make trouble to each others
  chaseStepChanging = new boolean[numberOfMemories];
  chaseStepChangingRev = new boolean[numberOfMemories];
  fallingEdgeChaseStepChangin = new boolean[numberOfMemories];
  
  chaseStep1 = 1;
  chaseStep2 = 1;
  chaseBright1 = new int[numberOfMemories];
  chaseBright2 = new int[numberOfMemories];
  
  
  //These two variables are important to prevent trouble between chaseMode 8 and 3
  steppi = new int[numberOfMemories];
  steppi1 = new int[numberOfMemories];
}



