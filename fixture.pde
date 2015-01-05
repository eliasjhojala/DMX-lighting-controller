boolean invokeFixturesDrawFinished = true; 
void invokeFixturesDraw() {
  invokeFixturesDrawFinished = false;
  for (int ai = 0; ai < fixtures.size(); ai++) fixtures.get(ai).draw();
  invokeFixturesDrawFinished = true;
}


ArrayList<Integer> idLookupTable;

class FixtureArray {
  
  
 
  FixtureArray() {
    array = new ArrayList<fixture>();
    if(idLookupTable == null) idLookupTable = new ArrayList<Integer>();
    
  }
  
  ArrayList<fixture> array;
  
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
  
  
  void remove(int id) {
    int idi = getArrayId(id);
    array.remove(idi);
    for(int i = 0; i < idLookupTable.size(); i++) {
      if(getArrayId(i) > idi) {
        idLookupTable.set(i, getArrayId(i)-1);
      }
    }
    idLookupTable.set(id, -1);
  }
  
  
  int getArrayId(int fid) {
    return idLookupTable.get(fid);
  }
  
  fixture get(int fid) {
    int result = getArrayId(fid);
    if(result != -1 && result < array.size()) return array.get(result);
      else {
        fixture newFixture = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        newFixture.size.isDrawn = false;
        return newFixture;
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
  fixtures.add(new fixture(0, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0));
}

 
class fixture {
  //Variables---------------------------------------------------------------------------------
  boolean selected = false;
  
  boolean DMXChanged = false;

  int dimmer;
  int dimmerPresetTarget = 0; //Used for preset calculations
  int lastDimmerPresetTarget = 0; // /\
  

  
  int x_location, y_location, z_location; //location in visualisation
  int locationOnScreenX, locationOnScreenY;
  int rotationX, rotationZ;
  int parameter;
  int preFadeSpeed = 1000;
  int postFadeSpeed = 5000;
  
  int red, green, blue, white, amber; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
  int frequency; //Strobe freq value
  int special1, special2, special3, special4; //Some special values for strange fixtures
  
  FixtureDMX in;
  FixtureDMX process;
  FixtureDMX out;
  FixtureDMX preset;
  

  
  
 
  void setDimmer(int val) { 
    in.setDimmer(val);
  }
  
  
   void processDMXvalues() {
    preset.presetProcess();
    for(int i = 0; i < in.DMXlength; i++) {
      //TODO: overwriteCHECK
        out.setUniversalDMX(i, in.getUniversalDMX(i));
    }
    DMXChanged = true;
  }

  
  void toggle(boolean down) {
    if(down) {
      if(fixtureTypeId == 8) { if(in.haze < 255 || in.fan < 255) { in.setUniversalDMX(DMX_HAZE, 255); in.setUniversalDMX(DMX_FAN, 255); } else { in.setUniversalDMX(DMX_HAZE, 0); in.setUniversalDMX(DMX_FAN, 0); } }
      if(fixtureTypeId == 9) { if(in.fog < 255) { in.setUniversalDMX(DMX_FOG, 255); } else { in.setUniversalDMX(DMX_FOG, 0); } }
      if(fixtureTypeId != 8 && fixtureTypeId != 9) { if(in.dimmer < 255) { in.setDimmer(255); } else { in.setDimmer(0); } }
    }
  }
  void push(boolean down) {
    if(down) {
      if(fixtureTypeId == 8) { in.setUniversalDMX(DMX_HAZE, 255); in.setUniversalDMX(DMX_FAN, 255); }
      if(fixtureTypeId == 9) { in.setUniversalDMX(DMX_FOG, 255); }
      if(fixtureTypeId != 8 && fixtureTypeId != 9) { in.setDimmer(255); }
    }
    else {
      if(fixtureTypeId == 8) { in.setUniversalDMX(DMX_HAZE, 0); in.setUniversalDMX(DMX_FAN, 0); }
      if(fixtureTypeId == 9) { in.setUniversalDMX(DMX_FOG, 0); }
      if(fixtureTypeId != 8 && fixtureTypeId != 9) { in.setDimmer(0); }
    }
  }

 
  
  boolean fixtureUseRgb() {
    int fT = fixtureTypeId;
    return (fT >= 10 && fT <= 16);
  }
    
  boolean fixtureUseDim() {
    int fT = fixtureTypeId;
    return fT == 11 || fT == 13 || fT == 16;
  }
  boolean fixtureUseWhite() {
    int fT = fixtureTypeId;
    return fT >= 12 && fT <= 16;
  }
  
  boolean fixtureIsLed() {
    return fixtureUseRgb();
  }
  
  void setColorForLed(int c) {
    if(fixtureIsLed()) {
      setColor(c);
    }
  }
  
  void setColor(int c) {
    in.red = rRed(c);
    in.green = rGreen(c);
    in.blue = rBlue(c);
    DMXChanged = true;
  }
  
  long fadeStartMillis;
  int fadeTarget = 0;
  int preFade;
  int postFade;
  int originalDimmer;
  
  boolean fadeComplete = true;
  
  boolean pushWithFadeDown = false;


  
  String fixtureType;
  int fixtureTypeId;
  int channelStart;
  
  fixtureSize size;
  
  int parentAnsa;
  
  
  void createDMXobjects() {
    in = new FixtureDMX(this);
    process = new FixtureDMX(this);
    out = new FixtureDMX(this);
    preset = new FixtureDMX(this);
    
    process.fades = new Fade[process.DMXlength];
  }

  //Initialization----------------------------------------------------------------------------
  
  //Type in string
  fixture(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, String fixtType) {
   fixtureType = fixtType;
   initFixtureObj(dim, r, g, b, x, y, z, rZ, rX, ch, parentA, param, getFixtureTypeId());
   createDMXobjects();
  }
  
  //Type in int
  fixture(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, int fixtTypeId) {
    initFixtureObj(dim, r, g, b, x, y, z, rZ, rX, ch, parentA, param, fixtTypeId);
    fixtureType = getFixtureNameByType(fixtTypeId);
    createDMXobjects();
  }
  
  //Empty fixture
  fixture() {}
  
  void initFixtureObj(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, int fixtTypeId) {
   dimmer = dim;
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
  
  
  //Moving head--------------------------------------------------------------------------------
//  void visualisationSettingsFromMovingHeadData() {
//    if(fixtureTypeId == 16 || fixtureTypeId == 17) {
//      slowRotationForMovingHead();
//    }
//  }

//  void slowRotationForMovingHead() {
//    if(rotationZ < round(map(pan, 0, 255, 0, 540))) { rotationZ += constrain(round((map(float(pan), 0, 255, 0, 540) - float(rotationZ))/20+0.6), 1, 10); }
//    if(rotationZ > round(map(pan, 0, 255, 0, 540))) { rotationZ -= constrain(round((float(rotationZ) - map(float(pan), 0, 255, 0, 540))/20+0.6), 1, 10); }
//    if(rotationX < round(map(tilt, 0, 255, 45, 270+45))) { rotationX += constrain(round((map(float(tilt), 0, 255, 45, 270+45) - float(rotationX))/20+0.6), 1, 10); }
//    if(rotationX > round(map(tilt, 0, 255, 45, 270+45))) { rotationX -= constrain(round((float(rotationX) - map(float(tilt), 0, 255, 45, 270+45))/20+0.6), 1, 10); }
//  }



  
  //Query-------------------------------------------------------------------------------------
  
  //Returns raw fixture color in type color
  
  color getRawColor() {
    if(!isHalogen()) {
      return color(out.red, out.green, out.blue);
    }
    else {
      return color(red, green, blue);
    }
  }
  
  //Returns dimmed fixture color in type color
  color getColor_wDim() {
    int dwm = getDimmerWithMaster();
    if(!isHalogen()) {
      if(fixtureUseDim()) {
        return color(map(out.red, 0, 255, 0, dwm), map(out.green, 0, 255, 0, dwm), map(out.blue, 0, 255, 0, dwm));
      }
      else { return color(out.red, out.green, out.blue); }
    }
    else {
      return color(map(red, 0, 255, 0, dwm), map(green, 0, 255, 0, dwm), map(blue, 0, 255, 0, dwm));
    }
  }
  
  
 
  
  int getFixtureTypeId() {
    return getFixtureTypeId1(fixtureType);
  }
  

  
  
  
  int[] getDMX() {
    return out.getDMX(); 
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
    
    int[] dmxChannels = new int[out.getDMX().length];
    for(int i = 0; i < dmxChannels.length; i++) {
      dmxChannels[i] = in.getDMX()[i];
    }
 //   out.dimmer = tempDimmer;
    return dmxChannels; 
  }
  
  boolean isHalogen() {
    switch(fixtureTypeId) {
       case 1: case 2: case 3: case 4: case 5: case 6: return true;
       default: return false;
    }
  }
  
  int getDimmerWithMaster() {
    return int(map(out.dimmer, 0, 255, 0, grandMaster));
  }
  
  int getDMXLength() {
    switch(fixtureTypeId) {
       /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: return 1; //dimmers
       /* MH-X50 14-channel mode */        case 16: return 14; //MH-X50
       /* MH-X50 8-channel mode */         case 17: return 8; //MH-X50 8-ch mode
       /* simple rgb led par */            case 18: return 3; //Simple rgb led par
       /* simple rgb led par with dim */   case 19: return 4; //Simple rgb led par with dim
       /* 2ch hazer */                     case 20: return 2; //2ch hazer
       /* 1ch fog */                       case 21: return 1; //1ch fog
       /* 2ch strobe */                    case 22: return 2; //2ch strobe
       /* 1ch relay */                     case 23: return 1; //1ch relay
       /* rgbw */                          case 24: return 4; //rgbw
       /* rgbwd */                         case 25: return 5; //rgbwd
    }
    return 0;
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
    if (dimmerPresetTarget != -1 && dimmerPresetTarget != lastDimmerPresetTarget) {
      setDimmer(dimmerPresetTarget);
      lastDimmerPresetTarget = dimmerPresetTarget;
    } dimmerPresetTarget = -1;
   
    
//    if (fixtureTypeId == 16 || fixtureTypeId == 17) visualisationSettingsFromMovingHeadData();
    //TODO: implement a function to get dim channel offset (in case dim isn't on the first channel)
    
    if (oldFixtureTypeId != fixtureTypeId) {
      oldFixtureTypeId = fixtureTypeId;
      //Fixture type changed, recalculate certain variables
      size = new fixtureSize(fixtureTypeId);
      fixtureType = getFixtureNameByType(fixtureTypeId);
    }
    if(fixtureTypeId == 16 || fixtureTypeId == 17) {
    }
  }
  
}

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

