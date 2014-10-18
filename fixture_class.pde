


class fixture {
  int dimmer, red, green, blue, x_location, y_location;
  String fixtureType;
  int fixtureTypeId;
  
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
  
}


int getFixtureTypeId(String fixtType) {
  int toReturn = 0;
  if(fixtType == "par64") { toReturn = 1; }
  if(fixtType == "linssi") { toReturn = 2; }
  return toReturn;
}
