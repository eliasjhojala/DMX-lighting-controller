


class fixture {
  //Variables---------------------------------------------------------------------------------
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt; //rotation values
  int x_location, y_location; //location in visualisation
  int gobo, prism, focus, shutter, strobe; //special values fot moving heads etc.
  
  String fixtureType;
  int fixtureTypeId;
  
  //Initialization----------------------------------------------------------------------------
  
  //Type in string
  fixture(int dim, int r, int g, int b, int x, int y, String fixtType) {
   initFixtureObj(dim, r, g, b, x, y, getFixtureTypeId(fixtureType));
   fixtureType = fixtType;
   fixtureTypeId = getFixtureTypeId(fixtureType);
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
  
}


int getFixtureTypeId(String fixtType) {
  int toReturn = 0;
  if(fixtType == "par64") { toReturn = 1; }
  if(fixtType == "linssi") { toReturn = 2; }
  return toReturn;
}
