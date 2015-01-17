final int DMX_DIMMER = 1;
final int DMX_RED = 2;
final int DMX_GREEN = 3;
final int DMX_BLUE = 4;
final int DMX_WHITE = 5;
final int DMX_AMBER = 6;
final int DMX_PAN = 7;
final int DMX_TILT = 8;
final int DMX_PANFINE = 9;
final int DMX_TILTFINE = 10;
final int DMX_COLORWHEEL = 11;
final int DMX_GOBOWHEEL = 12;
final int DMX_GOBOROTATION = 13;
final int DMX_PRISM = 14;
final int DMX_FOCUS = 15;
final int DMX_SHUTTER = 16;
final int DMX_STROBE = 17;
final int DMX_FREQUENCY = 18;
final int DMX_RESPONSESPEED = 19;
final int DMX_AUTOPROGRAMS = 20;
final int DMX_SPECIALFUNCTIONS = 21;
final int DMX_HAZE = 22;
final int DMX_FAN = 23;
final int DMX_FOG = 24;
final int DMX_SPECIAL1 = 25;
final int DMX_SPECIAL2 = 26;
final int DMX_SPECIAL3 = 27;
final int DMX_SPECIAL4 = 28;



class FixtureDMX { //Class containig all the dmx values
  /*
    In this class should be located all the fixture's dmx variables
  */
  int DMXlength = universalDMXlength;
  
  int[] DMX = new int[DMXlength];
  int[] DMXold = new int[DMXlength];
  boolean DMXChanged;
  
  
/*  int dimmer; //dimmer value
  
  int red, green, blue, white, amber; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
  int frequency; //Strobe freq value
  int special1, special2, special3, special4; //Some special values for strange fixtures */
  
  Fade[] fades;
  
  void presetProcess() {
    for(int i = 0; i < DMXlength; i++) {
        int newV = getUniDMX(i);
        if (newV != -1 && newV != DMXold[i]) {
          parent.in.setUniversalDMX(i, newV);
          parent.DMXChanged = true;
          
          
          DMXold[i] = newV;
        }
        
        setUniversalDMX(i, -1);
        
        
    }
  }
  
  void setDimmer(int val) {
    setUniversalDMX(DMX_DIMMER, val);
  }
  
  fixture parent;
  FixtureDMX(fixture parent) {
    this.parent = parent;
  }
  
  FixtureDMX() {
  }

  
 
  //Universal DMX: dimmer, red, green, blue, white, amber, pan, tilt, panFine, tiltFine, 
  //colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, frequency, responseSpeed, 
  //autoPrograms, specialFunctions, haze, fan, fog, special1, special2, special3, special4
  
  int[] getUniversalDMX() {
    int[] toReturn = new int[DMX.length];
    arrayCopy(DMX, toReturn);
    return toReturn;
  }
  
  int getUniversalDMX(int i) {
    return DMX[i];
  }
  
  void setUniDMX(int i, int val) { setUniversalDMX(i, val); }
  int getUniDMX(int i) { return getUniversalDMX(i); }
  void setUniDMX(int[] vals) { setUniversalDMX(vals); }
  int[] getUniDMX() { return getUniversalDMX(); }
  
  void setUniversalDMX(int[] vals) {
    for(int i = 1; i < vals.length; i++) {
      if(vals[i] != -2) {
        setUniversalDMX(i, vals[i]);
      }
    }
  }
  
  
  void setUniversalDMX(int i, int val) {
    DMX[i] = val;
    DMXChanged = true;
  }
 
 
   //Returns true if operation is succesful
  boolean receiveDMX(int[] dmxChannels) {
    try {
      setUniversalDMX(receiveDMXtoUniversal(parent.fixtureTypeId, dmxChannels));
      return true;
    }
    catch(Exception e) { return false; }
  }
  
  int[] getDMX() {
    return getDMXfromUniversal(parent.fixtureTypeId, getUniversalDMX());
  }
 
 
}

boolean valueHasChanged(int i, int[] cur, int[] old) {
  return valueHasChanged(cur[i], old[i]);
}
boolean valueHasChanged(int cur, int old) {
  return cur != old;
}
