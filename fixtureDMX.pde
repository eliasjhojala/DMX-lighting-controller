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
  
  
  int dimmer; //dimmer value
  
  int red, green, blue, white, amber; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
  int frequency; //Strobe freq value
  int special1, special2, special3, special4; //Some special values for strange fixtures
  
  Fade[] fades;
  
  void presetProcess() {
    for(int i = 0; i < DMXlength; i++) {
        int newV = getUniversalDMX(i);
        if (newV != -1 && newV != DMXold[i]) {
          parent.in.setUniversalDMX(i, newV);
          parent.DMXChanged = true;
        }
        DMXold[i] = newV;
        setUniversalDMX(i, -1);
        
        
    }
  }
  
  void setDimmer(int val) {
    dimmer = val; DMXChanged = true;
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
    int[] toReturn = new int[29];
    for(int i = 1; i <= 28; i++) {
      toReturn[i] = getUniversalDMX(i);
    }
    return toReturn;
  }
  
  int getUniversalDMX(int i) {
    int toReturn = 0;
    switch(i) {
      case 1: toReturn = dimmer; break;
      case 2: toReturn = red; break;
      case 3: toReturn = green; break;
      case 4: toReturn = blue; break;
      case 5: toReturn = white; break;
      case 6: toReturn = amber; break;
      case 7: toReturn = pan; break;
      case 8: toReturn = tilt; break;
      case 9: toReturn = panFine; break;
      case 10: toReturn = tiltFine; break;
      case 11: toReturn = colorWheel; break;
      case 12: toReturn = goboWheel; break;
      case 13: toReturn = goboRotation; break;
      case 14: toReturn = prism; break;
      case 15: toReturn = focus; break;
      case 16: toReturn = shutter; break;
      case 17: toReturn = strobe; break;
      case 18: toReturn = frequency; break;
      case 19: toReturn = responseSpeed; break;
      case 20: toReturn = autoPrograms; break;
      case 21: toReturn = specialFunctions; break;
      case 22: toReturn = haze; break;
      case 23: toReturn = fan; break;
      case 24: toReturn = fog; break;
      case 25: toReturn = special1; break;
      case 26: toReturn = special2; break;
      case 27: toReturn = special3; break;
      case 28: toReturn = special4; break;
    }
    return toReturn;
  }
  
  void setUniversalDMX(int[] vals) {
    for(int i = 1; i < vals.length; i++) {
      setUniversalDMX(i, vals[i]);
    }
  }
  
  
  void setUniversalDMX(int i, int val) {
    switch(i) {
      case 1: setDimmer(val); break;
      case 2: red = val; break;
      case 3: green = val; break;
      case 4: blue = val; break;
      case 5: white = val; break;
      case 6: amber = val; break;
      case 7: pan = val; break;
      case 8: tilt = val; break;
      case 9: panFine = val; break;
      case 10: tiltFine = val; break;
      case 11: colorWheel = val; break;
      case 12: goboWheel = val; break;
      case 13: goboRotation = val; break;
      case 14: prism = val; break;
      case 15: focus = val; break;
      case 16: shutter = val; break;
      case 17: strobe = val; break;
      case 18: frequency = val; break;
      case 19: responseSpeed = val; break;
      case 20: autoPrograms = val; break;
      case 21: specialFunctions = val; break;
      case 22: haze = val; break;
      case 23: fan = val; break;
      case 24: fog = val; break;
      case 25: special1 = val; break;
      case 26: special2 = val; break;
      case 27: special3 = val; break;
      case 28: special4 = val; break;
    }
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
