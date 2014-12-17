//Tässä välilehdessä on paljon lyhyitä voideja


//Returns the index of the smalles value that ISN'T checked (input.lenght and checked.length MUST be equal!)
//Returns -1 if none found
int indexOfMinCheck(int[] input, boolean[] checked) {
  int toReturn = -1;
  int min = Integer.MAX_VALUE;
  for(int i = 0; i < input.length; i++) {
    if(input[i] < min && !checked[i]) {
      toReturn = i;
      min = input[i];
    }
  }
  return toReturn;
}



int ansaWidth;

boolean arduinoFinished = true;
void arduinoSend() {
  arduinoFinished = false;
  for(int i = 0; i < channels; i++) {
    if(DMXforOutput[i] != valueToDmxOld[i]) {
      if(useCOM == true) {
        setDmxChannel(i, DMXforOutput[i]);
      }
      valueToDmxOld[i] = DMXforOutput[i];
    }
    sendOscToIpad(i, DMX[i]);
  }
  arduinoFinished = true;
}


void ansat() {
    fill(0, 0, 0);
    for(int i = 0; i < ansaY.length; i++) {
      if(ansaType[i] == 1) {
        rect(ansaX[i], (ansaY[i]+25), ansaWidth, 5);
      }
    }
}
void kalvo(color c) {
  fill(c);
}



void drawFixture(int i) {
  kalvo(fixtures[i].getColor_wDim());
  boolean showFixture = true;
  int lampWidth = 30;
  int lampHeight = 40;
  
  String fixtuuriTyyppi = getFixtureName(i);
  
  int fixtureTypeId = fixtures[i].fixtureTypeId;
  
  if(fixtureTypeId >= 1 && fixtureTypeId <= 13) {
    lampWidth = fixtures[i].size.w;
    lampHeight = fixtures[i].size.h;
    showFixture = fixtures[i].size.isDrawn;
  }
  
  boolean selected = fixtures[i].selected && showFixture;
  
  
  if(showFixture == true) {
    int x1 = 0; int y1 = 0;
    fixtures[i].locationOnScreenX = int(screenX(x1 + lampWidth/2, y1 + lampHeight/2));
    fixtures[i].locationOnScreenY = int(screenY(x1 + lampWidth/2, y1 + lampHeight/2));
    if(fixtureTypeId == 13) { rectMode(CENTER); rotate(radians(map(movingHeadPan, 0, 255, 0, 180))); pushMatrix();}
    if(selected) stroke(100, 100, 255); else stroke(255);
    rect(x1, y1, lampWidth, lampHeight, 3);
    if(fixtureTypeId == 13) { rectMode(CENTER); popMatrix(); rectMode(CORNER); }
    if(zoom > 50) {
      if(printMode == false) {
        fill(255, 255, 255);
        text(fixtures[i].getDimmerWithMaster(), x1, y1 + lampHeight + 15);
      }
      else {
        fill(0, 0, 0);
        text(fixtuuriTyyppi, x1, y1 + lampHeight + 15);
      }
    
     text(i + "/" + fixtures[i].channelStart, x1, y1 - 15);
    }
  }
}

void mouseWheel(MouseEvent event) {
  if(mouseX < width-168) { //Jos hiiri ei ole sivuvalikon päällä sen skrollaus vaikuttaa visualisaation zoomaukseen
    float e = event.getCount();
    if(e < 0) { if(zoom < 110) { zoom--; } else { zoom = zoom - int(zoom/30); } }
    else if(e > 0) { if(zoom < 110) { zoom++; } else { zoom = zoom + int(zoom/30); }}
  }
  else {
    float e = event.getCount();
    if(e < 0) { if(memoryMenu > 0) { memoryMenu--; } }
    else if(e > 0) { if(memoryMenu < numberOfMemories) { memoryMenu++; } }
  }
}




//Is pointer hovering over a rectangle's bounding box?
boolean isHover(int offsetX, int offsetY, int w, int h) {
  return isHoverAB(offsetX, offsetY, offsetX + w, offsetY + h);
}

boolean isHoverAB(int obj1X, int obj1Y, int obj2X, int obj2Y){
  //The x and y coordinates of all the dots in the simulated rectangle
  int[] x = new int[4];
  int[] y = new int[4];
  
  x[0] = int(screenX(obj1X, obj1Y));
  y[0] = int(screenY(obj1X, obj1Y));
  x[1] = int(screenX(obj2X, obj1Y));
  y[1] = int(screenY(obj2X, obj1Y));
  x[2] = int(screenX(obj1X, obj2Y));
  y[2] = int(screenY(obj1X, obj2Y));
  x[3] = int(screenX(obj2X, obj2Y));
  y[3] = int(screenY(obj2X, obj2Y));
  
  return inBds2D(mouseX, mouseY, min(x), min(y), max(x), max(y));
}


//A simpler version of isHover. Doesn't make a bounding box, only regards the two corners and checks a rectangle between them. (Useful with non-rotated scenarios)
boolean isHoverSimple(int offsetX, int offsetY, int w, int h){
  return inBds2D(mouseX, mouseY, int(screenX(offsetX, offsetY)), int(screenY(offsetX, offsetY)), int(screenX(offsetX + w, offsetY + h)), int(screenY(offsetX + w, offsetY + h)));
}

//Automatically takes mouseX and mouseY as pointer
boolean inBdsMouse(int x1, int y1, int x2, int y2) {
  return inBds2D(mouseX, mouseY, x1, y1, x2, y2);
}

boolean inBdsMouseOffst(int x, int y, int w, int h) {
  return inBdsMouse(x, y, x+w, y+h);
}

boolean inBds2D(int pointerX, int pointerY, int x1, int y1, int x2, int y2){
  return inBds1D(pointerX, x1, x2) && inBds1D(pointerY, y1, y2);
}

boolean inBds1D(int pointer, int x1, int x2){
  return pointer > x1 && pointer < x2;
}

boolean isHoverBottomMenu() {
  if (bottomMenuControlBoxOpen) {
    return inBdsMouseOffst(65, height - 260 - bottomMenuControlBoxHeight, bottomMenuControlBoxWidth, bottomMenuControlBoxHeight) && !(mouseLocked && mouseLocker.equals("main"));
  }
  return false;
}

color multiplyColor(color col, float mult) {
  color toReturn = color(
    red(col) * mult,
    green(col) * mult,
    blue(col) * mult
  );
  return toReturn;
}

void movePage() {
  if(mouseReleased) {
    
    mouseReleased = false;
  }
  x_siirto = x_siirto - (pmouseX - mouseX);
  y_siirto = y_siirto - (pmouseY - mouseY);
}

boolean isClicked(int x1, int y1, int x2, int y2) {
  if(mouseClicked) {
    if(mouseX > x1 && mouseX < x2+x1 && mouseY > y1 && mouseY < y2+y1) {
      return true;
    }
    else {
      return false;
    }
  }
  else {
    return false;
  }
}


 /*
 Fullon toimintaperiaate:
 fullon on toiminto, joka laittaa kaikkien kanavien arvot täysille.
 Tämä tehdään myös pääloopissa (draw) niin pitkään kun fullOn = true,
 jotta arvoja ei ylikirjoiteta. Ennen kuin kaikki arvot laitetaan täysille
 kirjoitetaan niiden arvot muuttujaan (valueOfDimBeforeSolo[]), jotta
 ne voidaan palauttaa fullOnin päätyttyä. Fullon-nappi toimii
 go-tyyppisesti, eli sitä painettaessa fullOn menee päälle ja kun
 se päästetään irti fullOn sammuu.
 */

void fullOn(boolean state) {
  if(fullOn && !state) {
    //Turn off full on
    for(int ii = 0; ii < fixtures.length; ii++) {
       fixtures[ii].setDimmer(valueOfDimBeforeFullOn[ii]);
    }
    fullOn = false;
  }
  if(!fullOn && state) {
    //Turn on full on
    for(int ii = 0; ii < fixtures.length; ii++) {
       valueOfDimBeforeFullOn[ii] = fixtures[ii].dimmer;
       fixtures[ii].setDimmer(255);
    }
    fullOn = true;
  }
  
}

void blackOut(boolean state) {
  if(!state) {
    //Turn off blackout
    blackOut = false;
    memory(1, masterValueBeforeBlackout);
    valueOfMemory[1] = masterValueBeforeBlackout;
    memoryValue[1] = masterValueBeforeBlackout;
  }
  if(state) {
    //Turn on blackout
    masterValueBeforeBlackout = grandMaster;
    blackOut = true;
    grandMaster = 0;
    valueOfMemory[1] = 0;
    memoryValue[1] = 0;
    memory(1, 0);
  }
  
}

void fullOnToggle() {
  fullOn(!fullOn);
}

void blackOutToggle() {
  blackOut(!blackOut);
}



boolean inBoundsCircle(int cPosX, int cPosY, int cRadius, int pointerX, int pointerY) {
  //Don't check circle unless mouse is in the bounding box
  if (inBds2D(pointerX, pointerY, cPosX-cRadius, cPosY-cRadius, cPosX+cRadius, cPosY+cRadius)) {
    //Check circle bounding
    PVector mouse = new PVector(pointerX, pointerY);
    PVector circle = new PVector(cPosX, cPosY);
    return cRadius > PVector.dist(mouse, circle);
  } else return false;
}



void setValuesToSelected() {
  
  if (bottomMenuAllFixtures && bottomMenuControlBoxOpen) {
    int a = 0;
    for(int i = 0; i < fixtures.length; i++) {
      if(fixtures[i].selected) {
        fixtures[i].setDimmer(fixtureForSelected[a].dimmer);
        fixtures[i].pan = fixtureForSelected[a].pan;
        fixtures[i].tilt = fixtureForSelected[a].tilt;
        fixtures[i].panFine = fixtureForSelected[a].panFine;
        fixtures[i].tiltFine = fixtureForSelected[a].tiltFine;
        fixtures[i].colorWheel = fixtureForSelected[a].colorWheel;
        fixtures[i].focus = fixtureForSelected[a].focus;
        fixtures[i].prism = fixtureForSelected[a].prism;
        fixtures[i].goboWheel = fixtureForSelected[a].goboWheel;
        fixtures[i].shutter = fixtureForSelected[a].shutter;
      }
    }
  }
}
