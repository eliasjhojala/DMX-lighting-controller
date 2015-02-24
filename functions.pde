//Tässä välilehdessä on paljon lyhyitä voideja

boolean scrolledDown = false;
boolean scrolledUp = false;

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

int[] valueToDmxOld = new int[DMX_CHAN_LENGTH+1];

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
  }
  arduinoFinished = true;
}

int trussToMove = -1;
boolean movingTruss = false;

void ansat(PVector mouseRotated) {
  
    for(int i = 0; i < ansaY.length; i++) {
      pushMatrix();
      switch(ansaType[i]) {
        case 1:
          translate(ansaX[i], ansaY[i]+25);
          fill(20);
          stroke(255);
          rect(0, 0, ansaWidth, 5);
          doTrussMoving(i, mouseRotated);
        break;
        case 0:
          translate(ansaX[i], ansaY[i]);
          doTrussMoving(i, mouseRotated);
        break;
        
      }
      popMatrix();
    }
    oldMouseXtr = int(mouseRotated.x);
    oldMouseYtr = int(mouseRotated.y);
}

int oldMouseXtr = 0;
int oldMouseYtr = 0;

void doTrussMoving(int i, PVector mouseRotated) {
  if(!showMode) {
    fill(topMenuTheme);
    rect(ansaWidth-5, -5, 15, 15, 3);
    if(isHover(ansaWidth-5, -5, 15, 15) && mouse.elmIsHover("main:fixtures") && !mouse.captured && mousePressed) {
      mouse.capture(mouse.getElementByName("main:fixtures"));
      trussToMove = i;
      movingTruss = true;
    }
    if(movingTruss && trussToMove == i) {
      if(mouseButton == LEFT) {
        if(!(key == 'y' && keyPressed)) ansaX[i] += int((mouseRotated.x - oldMouseXtr) * 100 / zoom);
        if(!(key == 'x' && keyPressed)) ansaY[i] += int((mouseRotated.y - oldMouseYtr) * 100 / zoom);
      } else if(mouseButton == RIGHT && mouse.firstCaptureFrame) {
        if(lastRMBc > millis() - 1000) {
          if(!(key == 'y' && keyPressed)) ansaX[i] = 0;
            else                          ansaY[i] = 0;
          
        } else lastRMBc = millis();
      }
    }
    
    if(!mousePressed && movingTruss) movingTruss = false;
  }
}

void kalvo(color c) {
  fill(c);
}





void mouseWheel(MouseEvent event) {
  if(mouse.elmIsHover("main:move")) { //Jos hiiri ei ole sivuvalikon päällä sen skrollaus vaikuttaa visualisaation zoomaukseen
    float e = event.getCount();
    if(e < 0) { zoom -= zoom/30; }
    else if(e > 0) { zoom += zoom/30; }
  }
  else if(mouse.elmIsHover("rearMenu:presetcontrols")) {
    float e = event.getCount();
    if(e < 0) { if(memoryMenu > 0) { memoryMenu--; } }
    else if(e > 0) { if(memoryMenu < numberOfMemories) { memoryMenu++; } }
  }
  float e = event.getCount();
  if(e < 0) { scrolledDown = true; }
  if(e > 0) { scrolledUp = true; }
}




//Is pointer hovering over a rectangle's bounding box?
boolean isHover(int offsetX, int offsetY, int w, int h) {
  return isHoverAB(offsetX, offsetY, offsetX + w, offsetY + h);
}

boolean isHoverAB(int obj1X, int obj1Y, int obj2X, int obj2Y) {
  return isHoverAB(obj1X, obj1Y, obj2X, obj2Y, mouseX, mouseY, g);
}

boolean isHoverAB(int obj1X, int obj1Y, int obj2X, int obj2Y, float moX, float moY, PGraphics g){
  //The x and y coordinates of all the dots in the simulated rectangle
  int[] x = new int[4];
  int[] y = new int[4];
  
  x[0] = iScreenX(obj1X, obj1Y, g);
  y[0] = iScreenY(obj1X, obj1Y, g);
  x[1] = iScreenX(obj2X, obj1Y, g);
  y[1] = iScreenY(obj2X, obj1Y, g);
  x[2] = iScreenX(obj1X, obj2Y, g);
  y[2] = iScreenY(obj1X, obj2Y, g);
  x[3] = iScreenX(obj2X, obj2Y, g);
  y[3] = iScreenY(obj2X, obj2Y, g);
  
  return inBds2D(moX, moY, min(x), min(y), max(x), max(y));
}


boolean isHoverSimple(int offsetX, int offsetY, int w, int h) {
  return isHoverSimple(offsetX, offsetY, w, h, mouseX, mouseY, g);
} 

boolean isHoverSimple(int ofX, int ofY, int w, int h, PGraphics g, Mouse mouse) {
  return isHoverSimple(ofX, ofY, w, h, mouse.getBridgedMouseX(), mouse.getBridgedMouseY(), g);
}

//A simpler version of isHover. Doesn't make a bounding box, only regards the two corners and checks a rectangle between them. (Useful with non-rotated scenarios)
boolean isHoverSimple(int offsetX, int offsetY, int w, int h, int moX, int moY, PGraphics g){
  return inBds2D(moX, moY, int(g.screenX(offsetX, offsetY)), int(g.screenY(offsetX, offsetY)), int(g.screenX(offsetX + w, offsetY + h)), int(g.screenY(offsetX + w, offsetY + h)));
}

//Automatically takes mouseX and mouseY as pointer
boolean inBdsMouse(int x1, int y1, int x2, int y2) {
  return inBds2D(mouseX, mouseY, x1, y1, x2, y2);
}

boolean inBdsMouseOffst(int x, int y, int w, int h) {
  return inBdsMouse(x, y, x+w, y+h);
}

boolean inBds2D(float pointerX, float pointerY, float x1, float y1, float x2, float y2){
  return inBds1D(pointerX, x1, x2) && inBds1D(pointerY, y1, y2);
}

boolean inBds1D(float pointer, float x1, float x2){
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
  x_siirto -= (pmouseX - mouseX) / (zoom/100 +0.001);
  y_siirto -= (pmouseY - mouseY) / (zoom/100 +0.001);
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
    for(int ii = 0; ii < fixtures.size(); ii++) {
       fixtures.get(ii).setDimmer(valueOfDimBeforeFullOn[ii]);
    }
    fullOn = false;
  }
  if(!fullOn && state) {
    //Turn on full on
    for(int ii = 0; ii < fixtures.size(); ii++) {
       valueOfDimBeforeFullOn[ii] = fixtures.get(ii).in.getUniDMX(DMX_DIMMER);
       fixtures.get(ii).setDimmer(255);
    }
    fullOn = true;
  }
  
}

void blackOut(boolean state) {
  if(!state) {
    //Turn off blackout
    blackOut = false;
    changeGrandMasterValue(masterValueBeforeBlackout);
  }
  if(state) {
    //Turn on blackout
    masterValueBeforeBlackout = grandMaster;
    blackOut = true;
    changeGrandMasterValue(0);
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
    for(int i = 0; i < fixtures.size(); i++) {
      if(fixtures.get(i).selected) {
        for(int j = 0; j < fixtures.get(i).in.DMXlength; j++) {
          fixtures.get(i).bottomMenu.setUniversalDMX(j, fixtureForSelected[a].bottomMenu.getUniversalDMX(j));
        }
      }
    }
  }
}


void changeGrandMasterValue(int val) {
  memories[1].setValue(val);
}
void changeCrossFadeValue(int val) {
  memories[2].setValue(val);
}


//Get ScreenX (or Y) and convert to int
int iScreenX(float x, float y, PGraphics g) {
  return int(g.screenX(x, y));
}

int iScreenY(float x, float y, PGraphics g) {
  return int(g.screenY(x, y));
}

int iScreenX(float x, float y) {
  return iScreenX(x, y, g);
}

int iScreenY(float x, float y) {
  return iScreenY(x, y, g);
}



//returns new value
int quickSlider(String mouseLockID, int mousePriority, int value, PGraphics g, Mouse mouse) {
    //Draw slider
    drawBottomMenuChControllerSlider(value, g);
    //Handle mouse
    mouse.declareUpdateElementRelative(mouseLockID, mousePriority, 0, 0, 20, 100, g);
    mouse.getElementByName(mouseLockID).expires = 2;
    
    //Check for drag
    boolean valueChanged = false;
    if (mouse.isCaptured(mouseLockID)) {
      value -= (mouseY - pmouseY);
      value = constrain(value, 0, 255);
    }
    
    return value;
}




//Some functions which are really useful tex in chase

    int getNext(int current, int[] lim) {
      int toReturn = 0;
      if(lim.length == 2) { toReturn = getNext(current, lim[0], lim[1]); }
      return toReturn;
    }
    
    int getReverse(int current, int[] lim) {
      int toReturn = 0;
      if(lim.length == 2) { toReturn = getReverse(current, lim[0], lim[1]); }
      return toReturn;
    }

    /*getNext returns always reverse value and checks that 
    if you already are at the smallest value then it goes to biggest value */
    int getReverse(int current, int lim_low, int lim_hi) {
      int toReturn = 0;
      if(current > lim_low) { toReturn = current - 1; }
      if(current == lim_low) { toReturn = lim_hi; }
      toReturn = constrain(toReturn, lim_low, lim_hi);
      return toReturn;
    }
    
    /*getNext returns always next value and checks that 
    if you already are at the biggest value then it goes to smallest value */
    int getNext(int current, int lim_low, int lim_hi) {
      int toReturn = 0;
      if(current < lim_hi) { toReturn = current + 1; }
      if(current == lim_hi) { toReturn = lim_low; }
      toReturn = constrain(toReturn, lim_low, lim_hi);
      return toReturn;
    }
    
    //getInvertedValue returns value inverted (0 -> 255, 255 -> 0)
    int getInvertedValue(int val, int lim_low, int lim_hi) {
      /*int toReturn = 0;
      toReturn = iMap(val, lim_low, lim_hi, lim_hi, lim_low);*/
      return lim_hi + lim_low - val;
    }
  
    
    //defualtConstrain is used to constrain values between 0 and 255, because that is the range used in DMX.
    int defaultConstrain(int val) {
      return constrain(val, 0, 255);
    }
    
    //iMap is function which actually is same as map but it returns value as int
    int iMap(int val, int in_low, int in_hi, int out_low, int out_hi) {
      return int(map(val, in_low, in_hi, out_low, out_hi));
    }
    
    //rMap is function which actually is same as map but it returns rounded value as int
    int rMap(int val, int in_low, int in_hi, int out_low, int out_hi) {
      return round(map(val, in_low, in_hi, out_low, out_hi));
    }
    
    int onlyPositive(int val) {
      return val < 0 ? 0 : val;
    }
    
    float onlyPositive(float val) {
      return val < 0 ? 0 : val;
    }
    
    int overZero(int val) {
      if(val > 0) { return val; }
      else { return 1; }
    }
    
    float overZero(float val) {
      if(val > 0) { return val; }
      else { return 1; }
    }
  
//End of some functions which are really useful tex in chase
  

/* Sorting algorithm which sorts variables like sort() function,
but it returns original array index numbers as sorted arrange */
  int[] sortIndex(int[] toSort) {
    int[] toReturn = new int[toSort.length];
    int[] sorted = new int[toSort.length];
    boolean[] used = new boolean[toSort.length];
     
     sorted = sort(toSort);
     
     for(int i = 0; i < toSort.length; i++) {
       for(int j = 0; j < sorted.length; j++) {
         if(toSort[i] == sorted[j] && !used[j]) {
           toReturn[j] = i;
           used[j] = true;
           break;
         }
       }
     }
     return toReturn;
   } //End of sorting algorithm
   
   
boolean isAbout(int a, int b, int accu) {
  if(abs(a - b) <= a/overZero(accu)) {
    return true;
  }
  return false;
} 

boolean isAbout(float a, float b, int accu) {
  if(abs(a - b) <= a/overZero(accu)) {
    return true;
  }
  return false;
}  

boolean isAbout(int a, int b) {
  return isAbout(a, b, 5);
}  
   
   
boolean isInList(int i, int[] list) {
  if(list != null) {
    for(int j = 0; j < list.length; j++) {
      if(list[j] == i) { return true; }
    }
  }
  return false;
}  

int[] toArray(int a) {
  int[] toReturn = new int[1];
  toReturn[0] = a;
  return toReturn;
}
int[] toArray(int a, int b) {
  int[] toReturn = new int[2];
  toReturn[0] = a;
  toReturn[1] = b;
  return toReturn;
}
int[] toArray(int a, int b, int c) {
  int[] toReturn = new int[3];
  toReturn[0] = a;
  toReturn[1] = b;
  toReturn[2] = c;
  return toReturn;
}
int[] toArray(int a, int b, int c, int d) {
  int[] toReturn = new int[4];
  toReturn[0] = a;
  toReturn[1] = b;
  toReturn[2] = c;
  toReturn[3] = d;
  return toReturn;
}





boolean ctrlDown = false; 
boolean shftDown = false;
boolean rightPressed = false;
boolean leftPressed = false;
boolean enterPressed = false;

void keyReleased() {
  keyReleased = true;
  if(key == 'r') { revStepPressed = false; }

}

boolean keyCapElsewhere = false;
boolean keyCapElseDown = false;


void keyPressed() {
  if(!keyCapElsewhere) {
    if(key == 'b') { boolean b = s2l.blinky; s2l = new soundDetect(); s2l.blinky = !b; }

    if(key==27) { key=0; 
      //Escape from printMode
      printMode = false;
    } //Otetaan esc-näppäin pois käytöstä. on kumminkin huomioitava, että tämä toimii vain pääikkunassa
    if(key == 'm') {
      showMode = !showMode;
      notifier.notify("showMode is now " + (showMode ? "enabled" : "disabled") + ".");
    }
    if(key == 'r') { revStepPressed = true; }
    if(key == 'l') { loadAllData(); }
 
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

    if(keyCode == RIGHT) { rightPressed = true; }
    if(keyCode == LEFT) { leftPressed = true; }
    if(keyCode == ENTER) { enterPressed = true; }
  } else { keyCapElseDown = true; }
}


void mousePressed() {
  mouseClicked = true;
}
void mouseReleased() {
  mouseClicked = false;
  mouseReleased = true;
}


/* Functions to return red, green and blue values 
   from color object as int instead of float */
int rRed(color c) { return round(red(c)); }
int rGreen(color c) { return round(green(c)); }
int rBlue(color c) { return round(blue(c)); }



void checkThemeMode() {
  fill(0, 0, 0);
  if(printMode == true) { //Check if printmode is on 
    background(255, 255, 255); //If printmode is on then background is white
    stroke(0, 0, 0); //If printmode is on then strokes are black 
  }
  else { 
    background(0); //If printmode is off then background is black
    stroke(255, 255, 255); //If printmode is off then strokes are white
  }
} 


class LocationData {
  /*
    This class is made to handle 3D object's rotation and location data
    at the same time, so functions which uses both of them could have
    one LocationData variable instead of two seperate PVectors
  */
  
  PVector location, rotation; //Location and rotation as PVectors
  
  LocationData(PVector loc, PVector rot) {
    /*
      Init function get location and rotation PVectors as input
      and simply saves them to class 
    */
    
    location = loc;
    rotation = rot;
  }
  
  PVector getLocation() { return location; } //Get location as PVector
  PVector getRotation() { return rotation; } //Get location as PVector
  
  void saveToXML(ManageXML xml) {
    xml.addBlockAndIncrease("LocationData");
      savePVectorToXML(xml, "location", location);
      savePVectorToXML(xml, "rotation", rotation);
    xml.goBack();
  }
}


void savePVectorToXML(ManageXML xml, String name, PVector pv) {
  xml.addBlockAndIncrease(name);
    xml.addData("x", pv.x);
    xml.addData("y", pv.y);
    xml.addData("z", pv.z);
  xml.goBack();
}

class RGBWD {
  /*
    This class is made to handle fixture color (RGB) data and dimmer (D) data
    and the mix of them (RGBWD), so functions using both of them could have
    only one RGBWD variable instead two seperate variables
  */
  color rawColor; //Color without dim
  int dimmer; //dimmer value
  color colorWithDim; //color mapped with dim value
  
  RGBWD(color col, int dim) {
    /* 
      Init function get rawColor and dim value as input
      and counts also colorWithDim value from them 
    */
       
    rawColor = col;
    dimmer = dim;
    colorWithDim = color(MCWD(red(col), dim), MCWD(green(col), dim), MCWD(blue(col), dim));
  }
  
  color getCol() { return rawColor; } //Get original color
  color getColWithDim() { return colorWithDim; } //Get color mapped with dimmer value
  int getDim() { return dimmer; } //Get dimmer value
  
  int MCWD(float c, float d) { //Map Color With Dimmer (color, dimmer)
    return round(map(c, 0, 255, 0, d));
  }
  
  void saveToXML(ManageXML xml) {
    xml.addBlockAndIncrease("RGBWD data");
      saveColorToXML(xml, "rawColor", rawColor);
      saveColorToXML(xml, "colorWithDim", colorWithDim);
      xml.addBlockAndIncrease("dimmer");
        xml.addData("val", dimmer);
      xml.goBack();
    xml.goBack();
  }
  
}


void saveColorToXML(ManageXML xml, String name, color c) {
  xml.addBlockAndIncrease(name);
    xml.addData("r", red(c));
    xml.addData("g", green(c));
    xml.addData("b", blue(c));
  xml.goBack();
}

//color getColorFromXML(ManageXML xml, String name) {
//  int r, g, b;
//  
//  return color(r, g, b);
//}
