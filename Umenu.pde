/*
In this tab are located
  - left bubbles
       - clock viewer
       - fps viewer
       - tell if loading
       - settings button
  - left buttons
       - actually only colorWash
*/

PShape settingsIcon;

color topMenuTheme = color(222, 0, 0);
color topMenuTheme2 = color(200, 0, 0);
color topMenuAccent = color(150, 0, 0);

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
  mouse.declareUpdateElementRelative("uppMenu:openSettings", "main:move", bubS/2, 0, 60, 60, g);
  boolean settingsHover = mouse.getElementByName("uppMenu:openSettings").isHovered;
  
  if(mouse.isCaptured("uppMenu:openSettings")) {
    settingsWindow.open();
  }
  
  noFill();
  stroke(0, 120); strokeWeight(6);
  arc(bubS/2, 0, 120, 120, 0, HALF_PI + QUARTER_PI);
  fill(themes.bubbleColor.neutral);
  stroke(multiplyColor(themes.bubbleColor.neutral, 0.7));
  strokeWeight(2);
  arc(bubS/2, 0, 120, 120, 0, HALF_PI + QUARTER_PI);
  
  
  pushMatrix();
    pushStyle();
      strokeWeight(10);
      if(settingsHover) stroke(250); else stroke(multiplyColor(themes.bubbleColor.neutral, 0.7));
      if(settingsHover) fill(250); else fill(multiplyColor(themes.bubbleColor.neutral, 0.7));
      translate(bubS/2 + 4, 4);
      scale(0.08);
      if (settingsIcon != null) shape(settingsIcon); // The asset might have not loaded yet
    popStyle();
  popMatrix();
  
  
  
  
  //Main bubble itself
  pushStyle();
    themes.bubbleColor.fillColor(inBoundsCircle(0, 0, bubS/2, mouseX, mouseY), false);
    stroke(multiplyColor(themes.bubbleColor.neutral, 0.7));
    strokeWeight(2);
    arc(0, 0, bubS, bubS, 0, HALF_PI);
  popStyle();
  
  
  
  
  //Time display
  fill(255);
  textSize(25);
  text(getTimeAsString(), 3, 28);
  textSize(12);
  
  
  text(avgFrameRate + " fps", 3, 28, 125, 125);
  avgFrameRate = (avgFrameRate + int(frameRate)) / 2;
  
  pushMatrix();
    if(loadingDataRecently()) {
      if(loadingDataAtTheTime()) { text("Loading...", 3, 28+15, 125, 125); }
      else { text("Load taked " + str(round(float(wholeLoadTimeAsMilliSeconds)/1000)) + "s", 3, 28+15, 125, 125); translate(0, 15); }
    }
    
    if(savingDataRecently()) {
      if(savingDataAtTheTime()) { text("Saving...", 3, 28+15, 125, 125); }
      else { text("Save taked " + str(round(float(wholeSaveTimeAsMilliSeconds)/1000)) + "s", 3, 28+15, 125, 125); }
    }
  popMatrix();
  
  { //Here you can place buttons to left side 
  pushMatrix();
    int round = 20;
    if(drawLeftSideButton(round, "Wash")) colorWashMenu.open = !colorWashMenu.open;
    translate(0, 120);
    if(drawLeftSideButton(round, "Help")) help.open = !help.open;
    translate(0, 120);
    if(drawLeftSideButton(round, "Control")) lowerMenu.open = !lowerMenu.open;
//    translate(0, 120);
//    if(drawLeftSideButton(round, "OSC")) oscSettings.open = !oscSettings.open;
//    translate(0, 120);
//    if(drawLeftSideButton(round, "MIDI")) midiWindow.open = !midiWindow.open;
  popMatrix();
  } //End of buttons placed to left side       
  //settingsWindow.draw();
  popStyle();
  
}


boolean drawLeftSideButton(int round, String text) {
  pushMatrix();
    translate(-2, 150);
    
    pushStyle();
      fill(themes.bubbleColor.neutral);
      rect(0, 0, 40, 100, 0, round, round, 0);
      mouse.declareUpdateElementRelative("UpperMenu:"+text, "main:move", 0, 0, 40, 100);
      boolean isHovered = isHover(0, 0, 40, 100);
      boolean isClicked = mouse.isCaptured("UpperMenu:"+text) && mouse.firstCaptureFrame;
    popStyle();
    pushMatrix();
      translate(13, 50);
      rotate(radians(90));
      pushStyle();
        if(isHovered) {
          fill(250);
        }
        else {
          fill(multiplyColor(themes.bubbleColor.neutral, 0.7));
        }
        textSize(20);
        textAlign(CENTER);
        text(text, 0, 0);
      popStyle();
    popMatrix();
  popMatrix();
  
  return isClicked;
}



void nextChaseMode() {
  chaseMode++;
  if(chaseMode > 8) {
    chaseMode = 1;
  }
  oscHandler.sendMessage("/chaseMode", chaseMode);
}

void reverseChaseMode() {
  chaseMode--;
  if(chaseMode < 1) {
    chaseMode = 8;
  }
  oscHandler.sendMessage("/chaseMode", chaseMode);
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


