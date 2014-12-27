//Tässä välilehdessä on paljon lyhyitä voideja

int ansaWidth;

void arduinoSend() {
  
  for(int i = 0; i < channels; i++) {
    if((dim[i] < (dimOld[i] - (dimOld[i] / 20))) || (dim[i] > (dimOld[i] + (dimOld[i] / 20))) || dim[i] == 255 || dim[i] == 0) {
      if(useCOM == true) {
        setDmxChannel(i, dim[i]);
      }
      dimOld[i] = dim[i];
      
    }
    sendOscToAnotherPc(i, dim[i]);
    sendOscToIpad(i, dimInput[i]);
  }
}


void ansat() {
    fill(0, 0, 0);
    for(int i = 0; i < ansaY.length; i++) {
      if(ansaType[i] == 1) {
        rect(ansaX[i], (ansaY[i]+25), ansaWidth, 5);
      }
    }
}
void kalvo(int r, int g, int b) {
  fill(r, g, b);
}


//Gets dimensions of fixture #id
//0 = width, 1 = height, 2 = (0 or 1) render fixture?
int[] getFixtureSize(int id) {
  //Default to this
  int[] toReturn = {30, 40, 1};
  
  switch(fixtureType1[id]) {
    case 1: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break;
    case 2: toReturn[0] = 25; toReturn[1] = 30; toReturn[2] = 1; break;
    case 3: toReturn[0] = 35; toReturn[1] = 40; toReturn[2] = 1; break;
    case 4: toReturn[0] = 40; toReturn[1] = 50; toReturn[2] = 1; break;
    case 5: toReturn[0] = 40; toReturn[1] = 20; toReturn[2] = 1; break;
    case 6: toReturn[0] = 20; toReturn[1] = 60; toReturn[2] = 1; break;
    case 7: toReturn[0] = 50; toReturn[1] = 50; toReturn[2] = 1; break;
    case 8: toReturn[2] = 0; break;
    case 9: toReturn[0] = 40; toReturn[1] = 30; toReturn[2] = 1; break;
    case 10: toReturn[2] = 0; break;
    case 11: toReturn[0] = 50; toReturn[1] = 70; toReturn[2] = 1; break;
    case 12: toReturn[0] = 5; toReturn[1] = 8; toReturn[2] = 1; break;
    case 13: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break;
  }
  return toReturn;
  
}

//Gets type description of fixture #id
String getFixtureName(int id) {
  String toReturn = "unknown";
  switch(fixtureType1[id]) {
    case 1: toReturn = "par64"; break;
    case 2: toReturn = "p.fresu"; break;
    case 3: toReturn = "k.fresu"; break;
    case 4: toReturn = "i.fresu"; break;
    case 5: toReturn = "flood"; break;
    case 6: toReturn = "linssi"; break;
    case 7: toReturn = "haze"; break;
    case 8: toReturn = "fan"; break;
    case 9: toReturn = "strobe"; break;
    case 10: toReturn = "freq"; break;
    case 11: toReturn = "fog"; break;
    case 12: toReturn = "pinspot"; break;
    case 13: toReturn = "MHdim"; break;
    case 14: toReturn = "MHpan"; break;
    case 15: toReturn = "MHtilt"; break;
  }
  return toReturn;
}



void drawFixture(int i) {
  boolean showFixture = true;
  int lampWidth = 30;
  int lampHeight = 40;
  String fixtuuriTyyppi = getFixtureName(i);
  
  if(fixtureType1[i] >= 1 && fixtureType1[i] <= 13) {
    int[] siz = getFixtureSize(i);
    lampWidth = siz[0];
    lampHeight = siz[1];
    showFixture = siz[2] == 1;
  }
  if(fixtureType1[i] == 14) { showFixture = false; movingHeadPan = dim[i]; rotTaka[i] = round(map(dim[channel[i]], 0, 255, -90, 90)); }
  if(fixtureType1[i] == 15) { showFixture = false; rotX[i-2] = round(map(dim[channel[i]], 0, 255, 180, 0)); }
  
  if(showFixture == true) {
    int x1 = 0; int y1 = 0;
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate(radians(map(movingHeadPan, 0, 255, 0, 180))); pushMatrix();}
    rect(x1, y1, lampWidth, lampHeight);
    if(fixtureType1[i] == 13) { rectMode(CENTER); popMatrix(); rectMode(CORNER); }
    if(zoom > 50) {
      if(printMode == false) {
        fill(255, 255, 255);
        text(dim[channel[i]], x1, y1 + lampHeight + 15);
      }
      else {
        fill(0, 0, 0);
        text(fixtuuriTyyppi, x1, y1 + lampHeight + 15);
      }
    
     text(channel[i], x1, y1 - 15);
    }
  }
}

void mouseWheel(MouseEvent event) {
  if(mouseX < width-120) { //Jos hiiri ei ole sivuvalikon päällä sen skrollaus vaikuttaa visualisaation zoomaukseen
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


boolean inBds2D(int pointerX, int pointerY, int x1, int y1, int x2, int y2){
  return inBds1D(pointerX, x1, x2) && inBds1D(pointerY, y1, y2);
}

boolean inBds1D(int pointer, int x1, int x2){
  return pointer > x1 && pointer < x2;
}

void movePage() {
  if(mouseReleased) {
    oldMouseX = mouseX;
    oldMouseY = mouseY;
    mouseReleased = false;
  }
  x_siirto = x_siirto - (oldMouseX - mouseX);
  y_siirto = y_siirto - (oldMouseY - mouseY);
  oldMouseX = mouseX;
  oldMouseY = mouseY;
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