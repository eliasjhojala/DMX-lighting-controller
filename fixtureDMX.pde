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
  int DMXlength = 28+1;
  
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
      switch(parent.fixtureTypeId) {
           /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dimmer = dmxChannels[0]; break; //dimmers
           /* MH-X50 14-channel mode */        case 16: pan = dmxChannels[0]; tilt = dmxChannels[1]; panFine = dmxChannels[2]; tiltFine = dmxChannels[3]; responseSpeed = dmxChannels[4]; colorWheel = dmxChannels[5]; shutter = dmxChannels[6]; dimmer = dmxChannels[7]; goboWheel = dmxChannels[8]; goboRotation = dmxChannels[9]; specialFunctions = dmxChannels[10]; autoPrograms = dmxChannels[11]; prism = dmxChannels[12]; focus = dmxChannels[13]; parent.setColorValuesFromDmxValue(colorWheel); break; //MH-X50
           /* MH-X50 8-channel mode */         case 17: pan = dmxChannels[0]; tilt = dmxChannels[1]; colorWheel = dmxChannels[2]; shutter = dmxChannels[3]; dimmer = shutter; goboWheel = dmxChannels[4]; goboRotation = dmxChannels[5]; prism = dmxChannels[6]; focus = dmxChannels[7]; parent.setColorValuesFromDmxValue(colorWheel); break; //MH-X50 8-ch mode
           /* simple rgb led par */            case 18: red = dmxChannels[0]; green = dmxChannels[1]; blue = dmxChannels[2]; break; //Simple rgb led par
           /* simple rgb led par with dim */   case 19: dimmer = dmxChannels[0]; red = dmxChannels[1]; green = dmxChannels[2]; blue = dmxChannels[3]; break; //Simple rgb led par with dim
           /* 2ch hazer */                     case 20: haze = dmxChannels[0]; fan = dmxChannels[1]; dimmer = (haze + fan) / 2; break; //2ch hazer
           /* 1ch fog */                       case 21: fog = dmxChannels[0]; dimmer = fog; break; //1ch fog
           /* rgbw led par */                  case 24: red = dmxChannels[0]; green = dmxChannels[1]; blue = dmxChannels[2]; white = dmxChannels[3]; break; //rgbw led par
           /* rgbwd led par */                 case 25: red = dmxChannels[0]; green = dmxChannels[1]; blue = dmxChannels[2]; white = dmxChannels[3]; dimmer = dmxChannels[4]; break; //rgbwd led par
        }
      } catch(Exception e) { e.printStackTrace(); return false; }
      DMXChanged = true;
      return true;
      
  }
  
  int[] getDMX() {
   int[] dmxChannels = new int[30];
      switch(parent.fixtureTypeId) {
       /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dmxChannels = new int[1]; dmxChannels[0] = dimmer; break; //dimmers
       /* MH-X50 14-channel mode */        case 16: dmxChannels = new int[14]; dmxChannels[0] = pan; dmxChannels[1] = tilt; dmxChannels[2] = panFine; dmxChannels[3] = tiltFine; dmxChannels[4] = responseSpeed; dmxChannels[5] = colorWheel; dmxChannels[6] = shutter; dmxChannels[7] = dimmer; dmxChannels[8] = goboWheel; dmxChannels[9] = goboRotation; dmxChannels[10] = specialFunctions; dmxChannels[11] = autoPrograms; dmxChannels[12] = prism; dmxChannels[13] = focus; break; //MH-X50
       /* MH-X50 8-channel mode */         case 17: dmxChannels = new int[8]; dmxChannels[0] = pan; dmxChannels[1] = tilt; dmxChannels[2] = colorWheel; dmxChannels[3] = shutter; dmxChannels[4] = goboWheel; dmxChannels[5] = goboRotation; dmxChannels[6] = prism; dmxChannels[7] = focus; break; //MH-X50 8-ch mode
       /* simple rgb led par */            case 18: dmxChannels = new int[3]; dmxChannels[0] = red; dmxChannels[1] = green; dmxChannels[2] = blue; break; //Simple rgb led par
       /* simple rgb led par with dim */   case 19: dmxChannels = new int[4]; dmxChannels[0] = dimmer; dmxChannels[1] = red; dmxChannels[2] = green; dmxChannels[3] = blue; break; //Simple rgb led par with dim
       /* 2ch hazer */                     case 20: dmxChannels = new int[2]; dmxChannels[0] = haze; dmxChannels[1] = fan; break; //2ch hazer
       /* 1ch fog */                       case 21: dmxChannels = new int[1]; dmxChannels[0] = fog; break; //1ch fog
       /* 2ch strobe */                    case 22: dmxChannels = new int[2]; dmxChannels[0] = dimmer; dmxChannels[1] = frequency; break; //2ch strobe
       /* 1ch relay */                     case 23: dmxChannels = new int[1]; if(dimmer > 100) { dmxChannels[0] = 255; } else { dmxChannels[0] = 0; } break; //1ch relay
       /* rgbw led par */                  case 24: dmxChannels = new int[4]; dmxChannels[0] = red; dmxChannels[1] = green; dmxChannels[2] = blue; dmxChannels[3] = white; break; //rgbw
       /* rgbwd led par */                 case 25: dmxChannels = new int[5]; dmxChannels[0] = red; dmxChannels[1] = green; dmxChannels[2] = blue; dmxChannels[3] = white; dmxChannels[4] = dimmer; break; //rgbwd
      }
    return dmxChannels; 
  }
 
 
}

boolean valueHasChanged(int i, int[] cur, int[] old) {
  return valueHasChanged(cur[i], old[i]);
}
boolean valueHasChanged(int cur, int old) {
  return cur != old;
}
