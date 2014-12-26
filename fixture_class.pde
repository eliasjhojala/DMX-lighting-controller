boolean invokeFixturesDrawFinished = true;
void invokeFixturesDraw() {
  invokeFixturesDrawFinished = false;
  for (fixture temp : fixtures) temp.draw();
  invokeFixturesDrawFinished = true;
}

 
class fixture {
  //Variables---------------------------------------------------------------------------------
  boolean selected = false;
  
  boolean DMXChanged = false;
  
  int dimmer; //dimmer value
  int dimmerPresetTarget = 0; //Used for preset calculations
  int lastDimmerPresetTarget = 0; // /\
  int red, green, blue; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int x_location, y_location, z_location; //location in visualisation
  int locationOnScreenX, locationOnScreenY;
  int rotationX, rotationZ;
  int parameter;
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
  int frequency; //Strobe freq value
  int preFadeSpeed = 0;
  int postFadeSpeed = 0;
 
  void setDimmerDirectly(int val) { dimmer = defaultConstrain(val); DMXChanged = true;}
  void setDimmer(int val) { 
    setDimmerWithFade(val, preFadeSpeed, postFadeSpeed);
  }
  
  void toggle(boolean down) {
    if(down) {
      if(fixtureTypeId == 20) { if(haze < 255 || fan < 255) { haze = 255; fan = 255; } else { haze = 0; fan = 0; } DMXChanged = true; }
      if(fixtureTypeId == 21) { if(fog < 255) { fog = 255; } else { fog = 0; } DMXChanged = true; }
      if(fixtureTypeId != 20 && fixtureTypeId != 21) { if(dimmer < 255) { setDimmer(255); } else { setDimmer(0); } }
    }
  }
  void push(boolean down) {
    if(down) {
      if(fixtureTypeId == 20) { haze = 255; fan = 255; DMXChanged = true; }
      if(fixtureTypeId == 21) { fog = 255; DMXChanged = true; }
      if(fixtureTypeId != 20 && fixtureTypeId != 21) { setDimmer(255); }
    }
    else {
      if(fixtureTypeId == 20) { haze = 0; fan = 0; DMXChanged = true; }
      if(fixtureTypeId == 21) { fog = 0; DMXChanged = true; }
      if(fixtureTypeId != 20 && fixtureTypeId != 21) { setDimmer(0); }
    }
  }
  
  long fadeStartMillis;
  int fadeTarget = 0;
  int preFade;
  int postFade;
  int originalDimmer;
  
  boolean fadeComplete = true;
  
  boolean pushWithFadeDown = false;
  
  void setDimmerWithFade(int val, int pre, int post) {
    if(val != fadeTarget) {
      fadeTarget = val;
      preFade = pre;
      postFade = post;
      fadeStartMillis = millis();
      originalDimmer = dimmer;
      fadeComplete = false;
    }
    
  }
  
  void setDimmerWithFadeInEveryLoop() {
    if(!fadeComplete) {
      int timer = round(millis()-fadeStartMillis);
      if(dimmer < fadeTarget && dimmer < 255) {
        setDimmerDirectly(iMap(timer, 0, preFade, originalDimmer, fadeTarget));
      } else
      if(dimmer > fadeTarget && dimmer > 0) {
        setDimmerDirectly(iMap(timer, 0, postFade, originalDimmer, fadeTarget));
      } else fadeComplete = true;
    }
  }
  
  String fixtureType;
  int fixtureTypeId;
  int channelStart;
  
  fixtureSize size;
  
  int parentAnsa;
  

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
  void visualisationSettingsFromMovingHeadData() {
    if(fixtureTypeId == 16 || fixtureTypeId == 17) {
      slowRotationForMovingHead();
    }
  }

  void slowRotationForMovingHead() {
    if(rotationZ < round(map(pan, 0, 255, 0, 540))) { rotationZ += constrain(round((map(float(pan), 0, 255, 0, 540) - float(rotationZ))/20+0.6), 1, 10); }
    if(rotationZ > round(map(pan, 0, 255, 0, 540))) { rotationZ -= constrain(round((float(rotationZ) - map(float(pan), 0, 255, 0, 540))/20+0.6), 1, 10); }
    if(rotationX < round(map(tilt, 0, 255, 45, 270+45))) { rotationX += constrain(round((map(float(tilt), 0, 255, 45, 270+45) - float(rotationX))/20+0.6), 1, 10); }
    if(rotationX > round(map(tilt, 0, 255, 45, 270+45))) { rotationX -= constrain(round((float(rotationX) - map(float(tilt), 0, 255, 45, 270+45))/20+0.6), 1, 10); }
  }



  
  //Query-------------------------------------------------------------------------------------
  
  //Returns raw fixture color in type color
  
  color getRawColor() {
    return color(red, green, blue);
  }
  
  //Returns dimmed fixture color in type color
  color getColor_wDim() {
    int dwm = getDimmerWithMaster();
    return color(map(red, 0, 255, 0, dwm), map(green, 0, 255, 0, dwm), map(blue, 0, 255, 0, dwm));
  }
  
  
  int getFixtureTypeId() {
    int toReturn = 0;
    if(fixtureType == "par64") { toReturn = 1; }
    if(fixtureType == "p.fresu") { toReturn = 2; }
    if(fixtureType == "k.fresu") { toReturn = 3; }
    if(fixtureType == "i.fresu") { toReturn = 4; }
    if(fixtureType == "flood") { toReturn = 5; }
    if(fixtureType == "linssi") { toReturn = 6; }
    //Muita: hazer, strobe, fog, pinspot, moving head, ledstrip, led par
    return toReturn;
  }
  
  int[] getDMX() {
    int[] dmxChannels = new int[30];
    switch(fixtureTypeId) {
       /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dmxChannels = new int[1]; dmxChannels[0] = dimmer; break; //dimmers
       /* MH-X50 14-channel mode */        case 16: dmxChannels = new int[14]; dmxChannels[0] = pan; dmxChannels[1] = tilt; dmxChannels[2] = panFine; dmxChannels[3] = tiltFine; dmxChannels[4] = responseSpeed; dmxChannels[5] = colorWheel; dmxChannels[6] = shutter; dmxChannels[7] = dimmer; dmxChannels[8] = goboWheel; dmxChannels[9] = goboRotation; dmxChannels[10] = specialFunctions; dmxChannels[11] = autoPrograms; dmxChannels[12] = prism; dmxChannels[13] = focus; break; //MH-X50
       /* MH-X50 8-channel mode */         case 17: dmxChannels = new int[8]; dmxChannels[0] = pan; dmxChannels[1] = tilt; dmxChannels[2] = colorWheel; dmxChannels[3] = shutter; dmxChannels[4] = goboWheel; dmxChannels[5] = goboRotation; dmxChannels[6] = prism; dmxChannels[7] = focus; break; //MH-X50 8-ch mode
       /* simple rgb led par */            case 18: dmxChannels = new int[3]; dmxChannels[0] = red; dmxChannels[1] = green; dmxChannels[2] = blue; break; //Simple rgb led par
       /* simple rgb led par with dim */   case 19: dmxChannels = new int[4]; dmxChannels[0] = dimmer; dmxChannels[1] = red; dmxChannels[2] = green; dmxChannels[3] = blue; break; //Simple rgb led par with dim
       /* 2ch hazer */                     case 20: dmxChannels = new int[2]; dmxChannels[0] = haze; dmxChannels[1] = fan; break; //2ch hazer
       /* 1ch fog */                       case 21: dmxChannels = new int[1]; dmxChannels[0] = fog; break; //1ch fog
       /* 2ch strobe */                    case 22: dmxChannels = new int[2]; dmxChannels[0] = dimmer; dmxChannels[1] = frequency; break; //2ch strobe
       /* 1ch relay */                     case 23: dmxChannels = new int[1]; if(dimmer > 100) { dmxChannels[0] = 255; } else { dmxChannels[0] = 0; } break; //1ch relay
      }
    return dmxChannels; 
  }
  
  int dimmerLast = 0;
  int[] getDMXforOutput() {
    
    //We're going to temporarily modify the dimmer variable to suit our needs
    int tempDimmer = dimmer;
    if(abs(dimmer - dimmerLast) >= 5) {
      dimmer = getDimmerWithMaster();
      if(dimmer < 5) dimmer = 0;
      if(dimmer > 250) dimmer = 255;
      dimmerLast = dimmer;
    } else if(isHalogen()) { dimmer = int(map(dimmerLast, 0, 255, 0, grandMaster)); }
    
    int[] dmxChannels = getDMX();
    dimmer = tempDimmer;
    return dmxChannels; 
  }
  
  boolean isHalogen() {
    switch(fixtureTypeId) {
       case 1: case 2: case 3: case 4: case 5: case 6: return true;
       default: return false;
    }
  }
  
  int getDimmerWithMaster() {
    return int(map(dimmer, 0, 255, 0, grandMaster));
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
    }
    return 0;
  }
  
  //Returns true if operation is succesful
  boolean receiveDMX(int[] dmxChannels) {
    try {
      switch(fixtureTypeId) {
           /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dimmer = dmxChannels[0]; break; //dimmers
           /* MH-X50 14-channel mode */        case 16: pan = dmxChannels[0]; tilt = dmxChannels[1]; panFine = dmxChannels[2]; tiltFine = dmxChannels[3]; responseSpeed = dmxChannels[4]; colorWheel = dmxChannels[5]; shutter = dmxChannels[6]; dimmer = dmxChannels[7]; goboWheel = dmxChannels[8]; goboRotation = dmxChannels[9]; specialFunctions = dmxChannels[10]; autoPrograms = dmxChannels[11]; prism = dmxChannels[12]; focus = dmxChannels[13]; setColorValuesFromDmxValue(colorWheel); break; //MH-X50
           /* MH-X50 8-channel mode */         case 17: pan = dmxChannels[0]; tilt = dmxChannels[1]; colorWheel = dmxChannels[2]; shutter = dmxChannels[3]; dimmer = shutter; goboWheel = dmxChannels[4]; goboRotation = dmxChannels[5]; prism = dmxChannels[6]; focus = dmxChannels[7]; setColorValuesFromDmxValue(colorWheel); break; //MH-X50 8-ch mode
           /* simple rgb led par */            case 18: red = dmxChannels[0]; green = dmxChannels[1]; blue = dmxChannels[2]; break; //Simple rgb led par
           /* simple rgb led par with dim */   case 19: dimmer = dmxChannels[0]; red = dmxChannels[1]; green = dmxChannels[2]; blue = dmxChannels[3]; break; //Simple rgb led par with dim
           /* 2ch hazer */                     case 20: haze = dmxChannels[0]; fan = dmxChannels[1]; break; //2ch hazer
           /* 1ch fog */                       case 21: fog = dmxChannels[0]; break; //1ch fog
        }
      } catch(Exception e) { e.printStackTrace(); return false; }
      DMXChanged = true;
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
      if(ftIsMhX50()) { colorWheel = mhx50_color_values[colorNumber]; } //Gives right value to moving head color channel
    }
    
    boolean ftIsMhX50() { //This function is only to check is the fixtureType moving head (17 or 16)
      return fixtureTypeId == 16 || fixtureTypeId == 17;
    }
  


  
  int oldFixtureTypeId;
  
  void draw() {
    setDimmerWithFadeInEveryLoop();
    if (dimmerPresetTarget != -1 && dimmerPresetTarget != lastDimmerPresetTarget) {
      setDimmer(dimmerPresetTarget);
      lastDimmerPresetTarget = dimmerPresetTarget;
    } dimmerPresetTarget = -1;
   
    
    if (fixtureTypeId == 16 || fixtureTypeId == 17) visualisationSettingsFromMovingHeadData();
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

