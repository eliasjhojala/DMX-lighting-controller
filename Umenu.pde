//Tässä välilehdessä piirretään ylävalikko, ja käsitellään sen nappuloiden komentoja 
  
color topMenuTheme = color(222, 0, 0);
color topMenuTheme2 = color(200, 0, 0);
color topMenuAccent = color(150, 0, 0);

PShape settingsIcon;

void ylavalikkoSetup() {
  settingsIcon = loadShape("settingsIcon.svg");
  settingsIcon.disableStyle();
}

int avgFrameRate = 0;

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
  mouse.declareUpdateElementRelative("uppMenu:openSettings", "main:move", bubS/2, 0, 60, 60);
  boolean settingsHover = mouse.getElementByName("uppMenu:openSettings").isHovered;
  
  if(mouse.isCaptured("uppMenu:openSettings")) {
    settingsWindow.open();
  }
  
  noFill();
  stroke(0, 120); strokeWeight(6);
  arc(bubS/2, 0, 120, 120, 0, HALF_PI + QUARTER_PI);
  fill(topMenuTheme2);
  stroke(topMenuAccent); strokeWeight(2);
  arc(bubS/2, 0, 120, 120, 0, HALF_PI + QUARTER_PI);
  
  
  pushMatrix();
    strokeWeight(10);
    if(settingsHover) stroke(250); else stroke(topMenuTheme);
    if(settingsHover) fill(250); else fill(topMenuTheme);
    translate(bubS/2 + 4, 4);
    scale(0.08);
    if (settingsIcon != null) shape(settingsIcon); // The asset might have not loaded yet
  popMatrix();
  
  
  
  
  //Main bubble itself
  fill(topMenuTheme);
  stroke(topMenuAccent); strokeWeight(2);
  arc(0, 0, bubS, bubS, 0, HALF_PI);
  
  
  
  
  //Time display
  fill(255);
  textSize(25);
  text(getTimeAsString(), 3, 28);
  textSize(12);
  
  
  text(avgFrameRate + " fps", 3, 28, 125, 125);
  avgFrameRate = (avgFrameRate + int(frameRate)) / 2;
  
  { //Here you can place buttons to left side
    { //Wash button
      pushMatrix();
        int round = 20;
        translate(-2, 150);
        pushStyle();
          fill(topMenuTheme2);
          rect(0, 0, 40, 100, 0, round, round, 0);
          mouse.declareUpdateElementRelative("washButton", "main:move", 0, 0, 40, 100);
          boolean isHovered = isHover(0, 0, 40, 100);
          boolean isClicked = mouse.isCaptured("washButton") && mouse.firstCaptureFrame;
          if(isClicked) { colorWashMenuOpen = !colorWashMenuOpen; }
        popStyle();
        pushMatrix();
          translate(13, 27);
          rotate(radians(90));
          pushStyle();
            if(isHovered) {
              fill(250);
            }
            else {
              fill(topMenuTheme);
            }
            textSize(20);
            text("Wash", 0, 0);
          popStyle();
        popMatrix();
      popMatrix();
    } //End of wash button
  
  } //End of buttons placed to left side
  settingsWindow.draw();
  popStyle();
  
}



void nextChaseMode() {
  chaseMode++;
  if(chaseMode > 8) {
    chaseMode = 1;
  }
  sendDataToIpad("/chaseMode", chaseMode);
}

void reverseChaseMode() {
  chaseMode--;
  if(chaseMode < 1) {
    chaseMode = 8;
  }
  sendDataToIpad("/chaseMode", chaseMode);
}

String getTimeAsString() {
  return conToStr(hour(), 2) + ":" + conToStr(minute(), 2) + ":" + conToStr(second(), 2);
}

//Converts an int into a string, but if the digits it has is less than mindigits, place zeros in those digits
String conToStr(int val, int mindigits) {
  String toReturn = str(val);
  for(int i = 1; i < mindigits; i++) {
    if(val+1 < (10 ^ i)) toReturn = str(0) + toReturn;
  }
  return toReturn;
}


