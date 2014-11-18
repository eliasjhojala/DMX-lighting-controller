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
  if(move == false && inBdsMouse(0, 0, width - 120, height - 225) && !isHoverBottomMenu()) {
    if(mousePressed) {
      if (mouseButton == LEFT) {
        if (!mouseLocked || mouseLocker == "main") {
          mouseLocked = true;
          mouseLocker = "main";
          movePage();
        }
      } else if(mouseButton == RIGHT) {
        //Box select
        
        doBoxSelect();
      }
    }
  }
  if(!mousePressed && boxSelect) endBoxSelect();
}

int boxStartX, boxStartY;
boolean boxSelect = false;
void doBoxSelect() {
  if (!mouseLocked) {
    
    mouseLocked = true;
    mouseLocker = "boxSelect";
    boxSelect = true;
    boxStartX = mouseX;
    boxStartY = mouseY; 
  } else {
    
    pushStyle();
    fill(50, 50, 150, 150);
    stroke(0, 0, 150);
    rectMode(CORNERS);
    rect(mouseX, mouseY, boxStartX, boxStartY);
    popStyle();
  }
}
void endBoxSelect() {
  boxSelect = false;
  
  //Get smallest corners of the box
  int[] cornerX = { boxStartX, mouseX };
  int x1 = min(cornerX);
  int x2 = max(cornerX);
  int[] cornerY = { boxStartY, mouseY };
  int y1 = min(cornerY);
  int y2 = max(cornerY);
  
  for (int i = 0; i < fixtures.length; i++) {
    fixtures[i].selected = inBds2D(
      fixtures[i].locationOnScreenX,
      fixtures[i].locationOnScreenY,
      x1, y1,
      x2, y2
    );
    
   
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



