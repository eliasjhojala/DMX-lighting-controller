


class fixture {
  //Variables---------------------------------------------------------------------------------
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt; //rotation values
  int x_location, y_location; //location in visualisation
  int gobo, prism, focus, shutter, strobe; //special values for moving heads etc.
  
  String fixtureType;
  int fixtureTypeId;
  
<<<<<<< HEAD
  fixtureSize size;
  
  int parentAnsa;
  
=======
>>>>>>> origin/fixture-class
  //Initialization----------------------------------------------------------------------------
  
  //Type in string
  fixture(int dim, int r, int g, int b, int x, int y, String fixtType) {
   initFixtureObj(dim, r, g, b, x, y, getFixtureTypeId());
   fixtureType = fixtType;
   fixtureTypeId = getFixtureTypeId();
  }
  
  //Type in int
  fixture(int dim, int r, int g, int b, int x, int y, int fixtTypeId) {
    initFixtureObj(dim, r, g, b, x, y, fixtTypeId);
    fixtureType = getFixtureName(fixtTypeId);
  }
  
  
  void initFixtureObj(int dim, int r, int g, int b, int x, int y, int fixtTypeId) {
   dimmer = dim;
   red = r;
   green = g;
   blue = b;
   x_location = x;
   y_location = y;
<<<<<<< HEAD
   z_location = z;
   pan = p; tilt = t;
   parentAnsa = parentA;
   
   size = new fixtureSize(fixtTypeId);
   
=======
>>>>>>> origin/fixture-class
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
      case 1: case 2: case 3: case 4: case 5: case 6: dmxChannels = new int[1]; dmxChannels[1] = dimmer; break;
    }
    return dmxChannels;
  }
  
}


<<<<<<< HEAD
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
=======
>>>>>>> origin/fixture-class
