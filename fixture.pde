boolean invokeFixturesDrawFinished = true;
void invokeFixturesDraw() {
  invokeFixturesDrawFinished = false;
  for (int ai = 0; ai < fixtures.size(); ai++) if(memoriesFinished) fixtures.get(ai).draw();
    else { while(!memoriesFinished){} ai--; }
  invokeFixturesDrawFinished = true;
}


ArrayList<Integer> idLookupTable;

class FixtureArray {
  
  
 
  FixtureArray() {
    array = new ArrayList<fixture>();
    if(idLookupTable == null) idLookupTable = new ArrayList<Integer>();
    //dummyFixture = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    
  }
  
  ArrayList<fixture> array;
  
  fixture dummyFixture;
  
  void add(fixture newFix) {
    int newId = array.size();
    array.add(newFix);
    
    if(idLookupTable.indexOf(newId) == -1) {
      //Add to first empty place, if none found, add to new place
      int newIndex = idLookupTable.indexOf(-1);
      if(newIndex != -1) {
        idLookupTable.set(newIndex, newId);
      } else idLookupTable.add(newId);
    }
  }
  
  void set(int id, fixture newFix) {
    int newId = array.size();
    array.add(newFix);
    if(idLookupTable.indexOf(newId) == -1) {
      idLookupTable.add(id, newId);
    }
  }
  
  
  void remove(int id) {
    int idi = getArrayId(id);
    array.remove(idi);
    for(int i = 0; i < idLookupTable.size(); i++) {
      if(idLookupTable.get(i) == idi) {
        idLookupTable.set(i, -1);
      }
    }
    for(int i = 0; i < idLookupTable.size(); i++) {
      if(getArrayId(i) > idi) {
        idLookupTable.set(i, getArrayId(i)-1);
      }
    }
    
    if(currentBottomMenuControlBoxOwner == id) bottomMenuControlBoxOpen = false;
  }
  
  
  int getArrayId(int fid) {
    if(fid < idLookupTable.size() && fid >= 0)
      return idLookupTable.get(fid);
    else return -1;
  }
  
  fixture get(int fid) {
    int result = getArrayId(fid);
    if(result != -1 && result < array.size()) return array.get(result);
      else {
        if(dummyFixture == null) dummyFixture = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        dummyFixture.size.isDrawn = false;
        return dummyFixture;
      }
    
  }
  
  
  int size() {
    return idLookupTable.size();
  }
  
  void clearThis() {
    for(fixture fix : array) fix = null;
  }
  
  void clear() {
    array.clear();
    idLookupTable.clear();
  }
  
}


void createNewFixtureAt00() {
  fixtures.add(new fixture(0, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 1));
}

 
class fixture {
  //Variables---------------------------------------------------------------------------------
  boolean selected = false;
  
  boolean DMXChanged = false;

  //int dimmer;
  

  PVector getLocation() {
    return new PVector(x_location, y_location, z_location);
  }
  PVector getLocationOnScreen() {
    return new PVector(locationOnScreenX, locationOnScreenY, 0);
  }
  PVector getRotation() {
    return new PVector(rotationX, 0, rotationZ);
  }
  LocationData getLocationData() {
    return new LocationData(getLocation(), getRotation());
  }
  RGBWD getRGBWD() {
    return new RGBWD(getRawColor(), out.getUniversalDMX(DMX_DIMMER));
  }
  
  int x_location, y_location, z_location; //location in visualisation
  int locationOnScreenX, locationOnScreenY;
  int rotationX, rotationZ;
  int parameter;
  int preFadeSpeed = 1000;
  int postFadeSpeed = 5000;
  
  int red, green, blue; //color values
  
  String fixtureType;
  int fixtureTypeId;
  int channelStart;
  
  fixtureSize size;
  
  int parentAnsa;
  
  boolean soloInThisFixture;
  
  FixtureDMX in;
  FixtureDMX process;
  FixtureDMX out;
  FixtureDMX preset;
  FixtureDMX bottomMenu;
  FixtureDMX fade;
  FixtureDMX presetReady;
  
  Fade[] fades = new Fade[universalDMXlength];
  

  //End of initing variables
  
  void saveFixtureDMXDataToXML(ManageXML XMLObject) {
    XMLObject.addBlockAndIncrease("FixtureDMXdata");
      if(in != null) { in.saveToXML("in", XMLObject); }
      if(process != null) { process.saveToXML("process", XMLObject); }
      if(out != null) { out.saveToXML("out", XMLObject); }
      if(preset != null) { preset.saveToXML("preset", XMLObject); }
      if(bottomMenu != null) { bottomMenu.saveToXML("bottomMenu", XMLObject); }
      if(fade != null) { fade.saveToXML("fade", XMLObject); }
    XMLObject.goBack();
  }
  
  void saveFixtureDataToXML(ManageXML XMLObject, int id) {
    XMLObject.addBlock("id", id);
    XMLObject.addBlock("StartChannel", channelStart);
    XMLObject.addBlock("fixtureTypeId", fixtureTypeId);
    XMLObject.addBlockAndIncrease("Location");
      XMLObject.addData("x", x_location);
      XMLObject.addData("y", y_location);
      XMLObject.addData("z", z_location);
      XMLObject.addBlockAndIncrease("OnScreen");
        XMLObject.addData("x", locationOnScreenX);
        XMLObject.addData("y", locationOnScreenY);
      XMLObject.goBack();
      XMLObject.addBlockAndIncrease("Rotation");
        XMLObject.addData("x", rotationX);
        XMLObject.addData("z", rotationZ);
    XMLObject.goBack(2);
    XMLObject.addBlock("parameter", parameter);
    XMLObject.addBlock("preFadeSpeed", preFadeSpeed);
    XMLObject.addBlock("postFadeSpeed", postFadeSpeed);
    XMLObject.addBlockAndIncrease("Color");
      XMLObject.addData("r", red);
      XMLObject.addData("g", green);
      XMLObject.addData("b", blue);
    XMLObject.goBack();
    XMLObject.addBlock("parentAnsa", parentAnsa);
    saveFixtureDMXDataToXML(XMLObject);
  }
  
  void loadFixtureData(ManageXML XMLObject) {
    channelStart = int(XMLObject.getBlock("StartChannel"));
    fixtureTypeId = int(XMLObject.getBlock("fixtureTypeId"));
    XMLObject.goToChild("Location");
      x_location = XMLObject.getDataInt("x");
      y_location = XMLObject.getDataInt("y");
      z_location = XMLObject.getDataInt("z");
      XMLObject.goToChild("OnScreen");
        locationOnScreenX = XMLObject.getDataInt("x");
        locationOnScreenY = XMLObject.getDataInt("y");
      XMLObject.goBack();
      XMLObject.goToChild("Rotation");
        rotationX = XMLObject.getDataInt("x");
        rotationZ = XMLObject.getDataInt("z");
    XMLObject.goBack(2);
    parameter = int(XMLObject.getBlock("parameter"));
    preFadeSpeed = int(XMLObject.getBlock("preFadeSpeed"));
    postFadeSpeed = int(XMLObject.getBlock("postFadeSpeed"));
    XMLObject.goToChild("Color");
      red = XMLObject.getDataInt("r");
      green = XMLObject.getDataInt("g");
      blue = XMLObject.getDataInt("b");
    XMLObject.goBack();
    parentAnsa = int(XMLObject.getBlock("parentAnsa"));
  }
  
 
  void setDimmer(int val) {
    in.setDimmer(val);
  }
  
   float soloFade = 255;
   float afterSoloFade = 0;
   boolean thisFixtureWasOffBySolo = false;
   
  void processDMXvalues() {
    preset.presetProcess();
    
    
    
    int[] newIn  = in.getUniversalDMX();
    int[] oldOut = out.getUniversalDMX();
    //Keep old dimmer value if it hasn't changed more than 5 and this fixture is a halogen
    if(isHalogen() && abs(newIn[DMX_DIMMER] - oldOut[DMX_DIMMER]) <= 5)
      newIn[DMX_DIMMER] = oldOut[DMX_DIMMER];
      newIn[DMX_DIMMER] = masterize(newIn[DMX_DIMMER]); //PROBLEM this is causing some masterloop problemes! If master isn't 255 all the lights fade off PROBLEM!!!!!!!!!!
    
   
//   
//    for(int i = 0; i < universalDMXlength; i++) {
//      if(presetReady != null) {
//        if(presetReady.fades[i] != null) {
//          presetReady.fades[i].startFade(in.getUniversalDMX(i), preset.getUniversalDMX(i), 500, 500);
//          presetReady.fades[i].countActualValue();
//          int fadeVal = presetReady.fades[i].getActualValue();
//          newIn[i] = fadeVal;
//        }
//        else {
//          presetReady.fades[i] = new Fade(in.getUniversalDMX(i), preset.getUniversalDMX(i), 500, 500);
//          presetReady.fades[i].countActualValue();
//          int fadeVal = presetReady.fades[i].getActualValue();
//          newIn[i] = fadeVal;
//        }
//      }
//    }
    
    
    if(soloIsOn && !soloInThisFixture) {
      newIn[DMX_DIMMER] = round(map(newIn[DMX_DIMMER], 0, 255, 0, soloFade));
      if(soloFade > 0) { soloFade-=(float(60)/frameRate)*20; soloFade = constrain(soloFade, 0, 255); }
      thisFixtureWasOffBySolo = true;
      afterSoloFade = 0;
    }
    if(!soloIsOn && !soloInThisFixture && thisFixtureWasOffBySolo) {
      newIn[DMX_DIMMER] = round(map(newIn[DMX_DIMMER], 0, 255, 0, afterSoloFade));
      if(afterSoloFade < 255) { afterSoloFade+=(float(60)/frameRate)*20; afterSoloFade = constrain(afterSoloFade, 0, 255); }
      if(afterSoloFade == 255) { thisFixtureWasOffBySolo = false;  soloFade = 255;}
    }
    
    if(fullOn) {
      newIn[DMX_DIMMER] = 255;
      if((newIn[DMX_RED] + newIn[DMX_GREEN] + newIn[DMX_BLUE] + newIn[DMX_WHITE])  == 0) { newIn[DMX_RED] = 255; newIn[DMX_GREEN] = 255; newIn[DMX_BLUE] = 255; newIn[DMX_WHITE] = 255; }
      else {
        int maxValueOfColors = max(max(newIn[DMX_RED], newIn[DMX_GREEN]), newIn[DMX_BLUE], newIn[DMX_WHITE]);
        newIn[DMX_RED] = round(map(newIn[DMX_RED], 0, maxValueOfColors, 0, 255));
        newIn[DMX_GREEN] = round(map(newIn[DMX_GREEN], 0, maxValueOfColors, 0, 255));
        newIn[DMX_BLUE] = round(map(newIn[DMX_BLUE], 0, maxValueOfColors, 0, 255));
        newIn[DMX_WHITE] = round(map(newIn[DMX_WHITE], 0, maxValueOfColors, 0, 255));
      }
    }
    if(strobeNow) {
      if(fixtureProfiles[fixtureTypeId].isStrobe) {
        newIn[DMX_DIMMER] = 255;
        newIn[DMX_FREQUENCY] = 255;
        newIn[DMX_STROBE] = 255;
        newIn[DMX_RED] = 255;
        newIn[DMX_GREEN] = 255;
        newIn[DMX_BLUE] = 255;
        newIn[DMX_WHITE] = 255;
      }
      else {
        newIn[DMX_DIMMER] = 0;
      }
    }
    if(fogNow) {
      if(fixtureProfiles[fixtureTypeId].isFog) {
        newIn[DMX_FOG] = 255;
      }
    }
    if(blackOut) { newIn[DMX_DIMMER] = 0; }
    int[] oldDMX = out.getUniversalDMX();
    for(int i = 0; i < newIn.length; i++) {
      if(newIn[i] != oldDMX[i]) {
        DMXChanged = true;
      }
    }
    out.setUniversalDMX(newIn);
    processFade();
    
    for(int i = 0; i < bottomMenu.DMXlength; i++) {
      if(bottomMenu.DMX[i] != bottomMenu.DMXold[i]) {
        in.DMX[i] = bottomMenu.DMX[i];
        DMXChanged = true;
        bottomMenu.DMXold[i] = bottomMenu.DMX[i];
      }
    }
  }
  
  void setUniversalDMXwithFade(int i, int val, int pre, int post) {
    if(i >= 0 && i < fades.length) {
      fades[i] = new Fade(in.getUniversalDMX(i), val, pre, post);
    }
  }
  
  void processFade() {
    if(fades != null) {
      
      int[] fadeVal = new int[fades.length];
      for(int i = 0; i < fades.length; i++) {
        if(fades[i] != null) {
          if(!fades[i].isCompleted()) {
            fades[i].countActualValue();
            fadeVal[i] = fades[i].getActualValue();
            in.setUniversalDMX(i, fadeVal[i]);
            DMXChanged = true;
          }
        }
      }
//      int[] oldOut = out.getUniversalDMX();
//      //Keep old dimmer value if it hasn't changed more than 5 and this fixture is a halogen
////      if(isHalogen() && abs(fadeVal[DMX_DIMMER] - oldOut[DMX_DIMMER]) <= 5)
////        fadeVal[DMX_DIMMER] = oldOut[DMX_DIMMER];
////      fadeVal[DMX_DIMMER] = masterize(fadeVal[DMX_DIMMER]);
//      out.setUniversalDMX(fadeVal);
//      DMXChanged = true;
//      out.DMXChanged = true;
    }
  }

  

  

 
  
  boolean thisFixtureUseRgb() {
    return fixtureUseRgbByType(fixtureTypeId);
  }
    
  boolean thisFixtureUseDim() {
    return fixtureUseDimByType(fixtureTypeId);
  }
  boolean thisFixtureUseWhite() {
    return fixtureUseWhiteByType(fixtureTypeId);
  }
  
  boolean thisFixtureIsLed() {
    return thisFixtureUseRgb();
  }
  
  void setColorForLed(int c) {
    if(thisFixtureIsLed()) {
      setColor(c);
    }
  }
  
  void setColorForLedFromPreset(int c) {
    if(thisFixtureIsLed()) {
      setColor(c);
    }
  }
  
  
  void setColor(int c) {
    in.setUniversalDMX(DMX_RED, rRed(c));
    in.setUniversalDMX(DMX_GREEN, rGreen(c));
    in.setUniversalDMX(DMX_BLUE, rBlue(c));
    DMXChanged = true;
  }
  
  color getColor() {
    return color(red, green, blue);
  }


  
  
  void createDMXobjects() {
    in = new FixtureDMX(this);
    process = new FixtureDMX(this);
    out = new FixtureDMX(this);
    preset = new FixtureDMX(this);
    bottomMenu = new FixtureDMX(this);
    presetReady = new FixtureDMX(this);
    
    process.fades = new Fade[process.DMXlength];
    presetReady.fades = new Fade[process.DMXlength];
  }

  //Initialization----------------------------------------------------------------------------
  
  //Type in string
  fixture(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, String fixtType) {
   fixtureType = fixtType;
   initFixtureObj(dim, r, g, b, x, y, z, rZ, rX, ch, parentA, param, getFixtureTypeId());
  }
  
  //Type in int
  fixture(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, int fixtTypeId) {
    initFixtureObj(dim, r, g, b, x, y, z, rZ, rX, ch, parentA, param, fixtTypeId);
    fixtureType = getFixtureNameByType(fixtTypeId);
    
  }
  
  //Empty fixture
  fixture() {}
  
  void initFixtureObj(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, int fixtTypeId) {
   createDMXobjects();
   in.setUniDMX(DMX_DIMMER, dim);
   channelStart = ch;
   red = r;
   green = g;
   blue = b;
   x_location = x;
   y_location = y;
   z_location = z;
   rotationZ = rZ; rotationX = rX;
   parameter = param;
   parentAnsa = parentA;
   
   size = new fixtureSize(fixtTypeId);
   

   fixtureTypeId = fixtTypeId;
  }
  
  
  //Query-------------------------------------------------------------------------------------
  
  //Returns raw fixture color in type color
  
  color getRawColor() {
    if(!isHalogen()) {
      if(out.getUniversalDMX(DMX_WHITE) > 0) {
        int[] convertedColor = colorConverter.convertColor(new int[] { out.getUniversalDMX(DMX_RED), out.getUniversalDMX(DMX_GREEN), out.getUniversalDMX(DMX_BLUE), out.getUniversalDMX(DMX_WHITE) }, 3, 1);
        return color(convertedColor[0], convertedColor[1], convertedColor[2]);
      }
      return color(out.getUniversalDMX(DMX_RED), out.getUniversalDMX(DMX_GREEN), out.getUniversalDMX(DMX_BLUE));
    }
    else {
      return color(red, green, blue);
    }
  }
  
  //Returns dimmed fixture color in type color
  color getColor_wDim() {
    int dwm = getDimmerWithMaster();
    color c = getRawColor();
    if(!isHalogen()) {
      if(thisFixtureUseDim()) {
        return color(map(red(c), 0, 255, 0, dwm), map(green(c), 0, 255, 0, dwm), map(blue(c), 0, 255, 0, dwm));
      }
      else { return c; }
    }
    else {
      return color(map(red, 0, 255, 0, dwm), map(green, 0, 255, 0, dwm), map(blue, 0, 255, 0, dwm));
    }
  }
  
  
 
  
  int getFixtureTypeId() {
    return getFixtureTypeId1(fixtureType);
  }
  

  
  
  
  int[] getDMX() {
    return in.getDMX();
  }
  
  int dimmerLast = 0;
  int[] getDMXforOutput() {
    
    //We're going to temporarily modify the dimmer variable to suit our needs
 /*   int tempDimmer = out.dimmer;
    if(abs(out.dimmer - dimmerLast) >= 5) {
      out.dimmer = getDimmerWithMaster();
      if(out.dimmer < 5) out.dimmer = 0;
      if(out.dimmer > 250) out.dimmer = 255;
      dimmerLast = out.dimmer;
    } else if(isHalogen()) { out.dimmer = int(map(dimmerLast, 0, 255, 0, grandMaster)); } */
    
    return out.getDMX();
  }
  
  
  boolean isHalogen() {
    switch(fixtureTypeId) {
       case 1: case 2: case 3: case 4: case 5: case 6: return true;
       default: return false;
    }
  }
  
  int getDimmerWithMaster() {
    return masterize(out.getUniversalDMX(DMX_DIMMER));
  }
  
  int masterize(int val) {
    return int(map(val, 0, 255, 0, grandMaster));
  }
  
  int getDMXLength() {
    return out.getDMX().length;
  }
  
  //Returns true if operation is succesful
  boolean receiveDMX(int[] dmxChannels) {
    //return in.receiveDMX(dmxChannels);
    return true;
  }
  
   void setColorValuesFromDmxValue(int a) {
      for(int i = 0; i < mhx50_color_values.length; i++) {
        if((a >= mhx50_color_values[i] - 5) && (a <= mhx50_color_values[i])) {
          setColorNumber(i);
          return;
        }
      }
    }
  
  int colorNumber;
  void setColorNumber(int value) {
      colorNumber = value;
      red = mhx50_RGB_color_Values[colorNumber][0];
      green = mhx50_RGB_color_Values[colorNumber][1];
      blue = mhx50_RGB_color_Values[colorNumber][2];
//      if(ftIsMhX50()) { colorWheel = mhx50_color_values[colorNumber]; } //Gives right value to moving head color channel
    }
    
    boolean ftIsMhX50() { //This function is only to check is the fixtureType moving head (17 or 16)
      return fixtureTypeId == 16 || fixtureTypeId == 17;
    }
  


  
  int oldFixtureTypeId;
  
  void draw() {
    //setFadeValues();
    processDMXvalues();
    /*if (dimmerPresetTarget != -1 && dimmerPresetTarget != lastDimmerPresetTarget) {
      setDimmer(dimmerPresetTarget);
      lastDimmerPresetTarget = dimmerPresetTarget;
    } dimmerPresetTarget = -1;*/
   

    
    if (oldFixtureTypeId != fixtureTypeId) {
      oldFixtureTypeId = fixtureTypeId;
      //Fixture type changed, recalculate certain variables
      size = new fixtureSize(fixtureTypeId);
      fixtureType = getFixtureNameByType(fixtureTypeId);
    }
    if(fixtureTypeId == 16 || fixtureTypeId == 17) {
    }
  }
  
  color getFixtureColorFor2D() {
    if(fixtureTypeId < fixtureProfiles.length) {
      FixtureProfile profile = fixtureProfiles[fixtureTypeId];
      if(profile != null) {
        if(profile.hasDimmer) {
          return this.getColor_wDim();
        }
        else if(profile.isFog) {
          int val = in.getUniversalDMX(DMX_FOG);
          color c = color(val, val, val);
          return c;
        }
        else if(profile.isHazer) {
          int val = in.getUniversalDMX(DMX_HAZE);
          color c = color(val, val, val);
          return c;
        }
        else {
          color c = color(0, 0, 0);
          return c;
        }
      }
    }
    color c = color(0, 0, 0);
    return c;
  }
  
  boolean toggleState = false;
  
  void push(boolean down) {
    mainChannelOnOff(down);
  }
  
  void toggle(boolean down) {
    if(down) {
      toggleState = !toggleState;
      mainChannelOnOff(toggleState);
    }
  }
  
  void mainChannelOnOff(boolean state) {
    FixtureProfile profile = fixtureProfiles[fixtureTypeId];
    if(profile.hasDimmer) { in.setUniversalDMX(DMX_DIMMER, state ? 255 : 0); }
    if(profile.isStrobe && profile.channelTypes.length <= 2) { in.setUniversalDMX(DMX_STROBE, state ? 255 : 0); }
    if(profile.isFog) { in.setUniversalDMX(DMX_FOG, state ? 255 : 0); }
    if(profile.isHazer) { in.setUniversalDMX(DMX_HAZE, state ? 255 : 0); in.setUniversalDMX(DMX_FAN, state ? 255 : 0); }
    DMXChanged = true;
  }
  
  //Index is used only to display the id of the fixture
  void draw2D(int index) {
    pushStyle();
    fill(getFixtureColorFor2D());
    boolean showFixture = true;
    int lampWidth = 30;
    int lampHeight = 40;
    
    String fixtuuriTyyppi = getFixtureNameByType(fixtureTypeId);
    
    
    
    if(fixtureTypeId >= 1 && fixtureTypeId <= 13) {
      lampWidth = this.size.w;
      lampHeight = this.size.h;
      showFixture = this.size.isDrawn;
    }
    
    boolean selected = this.selected && showFixture;
    
    
    if(showFixture == true) {
      int x1 = 0; int y1 = 0;
      this.locationOnScreenX = int(screenX(x1 + lampWidth/2, y1 + lampHeight/2));
      this.locationOnScreenY = int(screenY(x1 + lampWidth/2, y1 + lampHeight/2));
      rectMode(CENTER);
      if(fixtureTypeId == 13) {  rotate(radians(map(rotationZ, 0, 255, 0, 180))); pushMatrix();}
      if(selected) stroke(100, 100, 255); else stroke(255);
      rect(x1, y1, lampWidth, lampHeight, 3);
      if(fixtureTypeId == 13) {  popMatrix();  }
      translate(-size.w/2, -size.h/2);
      if(zoom > 50) {
        if(printMode == false) {
          fill(255, 255, 255);
          text(this.getDimmerWithMaster(), x1, y1 + lampHeight + 15);
        }
        else {
          fill(0, 0, 0);
          text(fixtuuriTyyppi, x1, y1 + lampHeight + 15);
        }
      
       text(index + "/" + this.channelStart, x1, y1 - 15);
      }
    }
    popStyle();
  }
  
}//Endof: fixture class

void removeFixtureFromCM() {
  fixtures.remove(contextMenu1.fixtureId);
}

void removeAllSelectedFixtures() {
  for(int i = 0; i < fixtures.size(); i++) {
    if(fixtures.get(i).selected) fixtures.remove(i);
  }
}


class fixtureSize {

  
  int w, h;
  boolean isDrawn;
  
  //Manual parameters
  fixtureSize(int wdt, int hgt, boolean isDrwn) {
    w = wdt; h = hgt;
    isDrawn = isDrwn;
  }
  
  //Parameters through fixture type
  fixtureSize(int fixtureTypeId) {
    int[] siz = getFixtureSizeByType(fixtureTypeId);
    w = siz[0]; h = siz[1];
    isDrawn = siz[2] == 1;
  }
}
