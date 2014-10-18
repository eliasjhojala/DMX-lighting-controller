


class fixture {
  //Variables---------------------------------------------------------------------------------
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int x_location, y_location, z_location; //location in visualisation
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
  
  String fixtureType;
  int fixtureTypeId;
  
  fixtureSize size;
  
  int parentAnsa;
  

  //Initialization----------------------------------------------------------------------------
  
  //Type in string
  fixture(int dim, int r, int g, int b, int x, int y, int z, int p, int t, int parentA, String fixtType) {
   initFixtureObj(dim, r, g, b, x, y, z, p, t, parentA, getFixtureTypeId());
   fixtureType = fixtType;
   fixtureTypeId = getFixtureTypeId();
  }
  
  //Type in int
  fixture(int dim, int r, int g, int b, int x, int y, int z, int p, int t, int parentA, int fixtTypeId) {
    initFixtureObj(dim, r, g, b, x, y, z, p, t, parentA, fixtTypeId);
    fixtureType = getFixtureName(fixtTypeId);
  }
  
  
  void initFixtureObj(int dim, int r, int g, int b, int x, int y, int z, int p, int t, int parentA, int fixtTypeId) {
   dimmer = dim;
   red = r;
   green = g;
   blue = b;
   x_location = x;
   y_location = y;
   z_location = z;
   pan = p; tilt = t;
   parentAnsa = parentA;
   
   size = new fixtureSize(fixtTypeId);
   

   fixtureTypeId = fixtTypeId;
  }
  
  //Query-------------------------------------------------------------------------------------
  
  //Returns raw fixture color in type color
  color getRawColor() {
    return color(red, green, blue);
  }
  
  //Returns dimmed fixture color in type color
  color getColor_wDim() {
    return color(map(red, 0, 255, 0, dimmer), map(green, 0, 255, 0, dimmer), map(blue, 0, 255, 0, dimmer));
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
    int[] dmxChannels = new int[30];
    switch(fixtureTypeId) {
      /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dmxChannels = new int[1]; dmxChannels[0] = dimmer; break; //dimmers
      /* MH-X50 14-channel mode */        case 16: dmxChannels = new int[14]; dmxChannel[0] = pan; dmxChannel[1] = tilt; dmxChannel[2] = panFine; dmxChannel[3] = tiltFine; dmxChannel[4] = responseSpeed; dmxChannel[5] = colorWheel; dmxChannel[6] = shutter; dmxChannel[7] = dimmer; dmxChannel[8] = goboWheel; dmxChannel[9] = goboRotation; dmxChannel[10] = specialFunctions; dmxChannel[11] = autoPrograms; dmxChannel[12] = prism; dmxChannel[13] = focus; break; //MH-X50
      /* MH-X50 8-channel mode */         case 17: dmxChannels = new int[8]; dmxChannel[0] = pan; dmxChannel[1] = tilt; dmxChannel[2] = colorWheel; dmxChannel[3] = shutter; dmxChannel[4] = goboWheel; dmxChannel[5] = goboRotation; dmxChannel[6] = prism; dmxChannel[7] = focus; break; //MH-X50 8-ch mode
      /* simple rgb led par */            case 18: dmxChannels = new int[3]; dmxChannel[0] = red; dmxChannel[1] = green; dmxChannel[2] = blue; break: //Simple rgb led par
      /* simple rgb led par with dim */   case 19: dmxChannels = new int[4]; dmxChannel[0] = dimmer; dmxChannel[1] = red; dmxChannel[2] = green; dmxChannel[3] = blue; break; //Simple rgb led par with dim
      /* 2ch hazer */                     case 20: dmxChannels = new int[2]; dmxChannel[0] = haze; dmxChannel[1] = fan; break; //2ch hazer
      /* 1ch fog */                       case 21: dmxChannels = new int[1]; dmxChannel[0] = fog; break; //1ch fog
      
  }
    return dmxChannels; 
  }
  
}



int getFixtureTypeId(String fixtType) {
  int toReturn = 0;
  if(fixtType == "par64") { toReturn = 1; }
  if(fixtType == "linssi") { toReturn = 2; }
  return toReturn;
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
    int[] siz = getFixtureSize(fixtureTypeId);
    w = siz[0]; h = siz[1];
    isDrawn = siz[2] == 1;
  }
}

