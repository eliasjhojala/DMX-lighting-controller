//In this file should be all the functions related to fixture profiles located


//Gets dimensions of fixture #id
//0 = width, 1 = height, 2 = (0 or 1) render fixture?
int[] getFixtureSizeByType(int type) { 
  //Default to this
  int[] toReturn = {30, 40, 1};
  
  switch(type) {
    case 1: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break; //Par64
    case 2: toReturn[0] = 25; toReturn[1] = 30; toReturn[2] = 1; break; //Small fressnel
    case 3: toReturn[0] = 35; toReturn[1] = 40; toReturn[2] = 1; break; //Middle fressnel
    case 4: toReturn[0] = 40; toReturn[1] = 50; toReturn[2] = 1; break; //Big fressnel
    case 5: toReturn[0] = 40; toReturn[1] = 20; toReturn[2] = 1; break; //Flood
    case 6: toReturn[0] = 20; toReturn[1] = 60; toReturn[2] = 1; break; //Zoom lens
    case 7: toReturn[0] = 40; toReturn[1] = 25; toReturn[2] = 1; break; //Strobe
    case 8: toReturn[0] = 40; toReturn[1] = 45; toReturn[2] = 1; break; //Haze
    case 9: toReturn[0] = 40; toReturn[1] = 55; toReturn[2] = 1; break; //Fog
    case 10: case 11: case 12: case 13: case 14: case 15: case 16: //Leds
      toReturn[0] = 30; toReturn[1] = 40; toReturn[2] = 1; break; //Leds
    case 17: case 18: //Moving heads
      toReturn[0] = 30; toReturn[1] = 35; toReturn[2] = 1; break; //Moving heads
  }
  return toReturn;
  
}

int[] getFixtureSize(int id) {
  return getFixtureSizeByType(fixtures.get(id).fixtureTypeId);
}

String[] getChNamesByFixType(int fT) {
  String[] tR = { "Default" };
    switch(fT) {
      case 1: case 2: case 3: case 4: case 5: case 6: String[] tR1 = { "Dimmer" }; tR = new String[tR1.length]; arrayCopy(tR1, tR); break;
     
      case 17: //mhX50 14ch
        String[] tR16 = {"Pan", "Tilt", "Fine Pan", "Fine Tilt", "Resp. Speed", "Color Wheel", "Shutter", "Dimmer", "Gobo", "Gobo Rotation", "S. Function", "Auto Program", "Prism", "Focus"}; 
        tR = new String[tR16.length]; arrayCopy(tR16, tR); 
      break;
      
      case 18: //mhX50 8ch
        String[] tR17 = {"Pan", "Tilt", "Color Wheel", "Shutter", "Gobo", "Gobo Rotation", "Prism", "Focus"}; 
        tR = new String[tR17.length]; arrayCopy(tR17, tR); 
      break; 
      
      case 10: tR = new String[3]; arrayCopy(returnRGB(), tR); break; //RGB.par
      case 11: tR = new String[4]; arrayCopy(returnRGB(), tR); tR[3] = "Dimmer"; break; //RGBD.par
      case 20: String[] tR20 = {"Haze", "Fan"}; tR = new String[tR20.length]; arrayCopy(tR20, tR); break; //Hazer
      case 21: String[] tR21 = {"Fog"}; tR = new String[tR21.length]; arrayCopy(tR21, tR); break; //Fog machine
      case 12: case 14: tR = new String[4]; arrayCopy(returnRGB(), tR); tR[3] = "White"; break; //RGBW.par and also Stairville RGBW 4ch
      case 13: tR = new String[5]; arrayCopy(returnRGB(), tR); tR[3] = "White"; tR[4] = "Dimmer"; break; //RGBWD.par
      case 15: String[] tR27 = {"Mode", "Red", "Green", "Blue", "White", "Effect"}; tR = new String[tR27.length]; arrayCopy(tR27, tR); break; //Stairville RGBW 6ch
      case 16: String[] tR28 = {"Red", "Green", "Blue", "White", "Color", "Strobe", "Mode", "Dimmer"}; tR = new String[tR28.length]; arrayCopy(tR28, tR); break; //Stairville RGBW 8ch
    }
  return tR;
}

String[] returnRGB() {
  String[] tR = { "Red", "Green", "Blue" };
  return tR;
}


String[] fixtureNames = { 
  "par64", //1
  "p.fresu", //2
  "k.fresu", //3
  "i.fresu", //4
  "flood", //5
  "linssi", //6
  "strobe", //7
  "hazer", //8
  "fog", //9
  "RGB.par", //10
  "RGBD.par", //11
  "RGBW.par", //12
  "RGBWD.par", //13
  "PAR64 CX-3 RGBW 4CH", //14 
  "PAR64 CX-3 RGBW 6CH", //15
  "PAR64 CX-3 RGBW 8CH", //16
  "MX50.14ch", //17
  "MX50.8ch" //18 
};

boolean fixtureUseRgbByType(int fT) { return fT >= 10 && fT <= 16; }
boolean fixtureUseDimByType(int fT) { return fT == 11 || fT == 13 || fT == 16; }
boolean fixtureUseWhiteByType(int fT) { return fT >= 12 && fT <= 16; }
boolean fixtureIsLedByType(int fT) { return fixtureUseRgbByType(fT); }

//Gets type description of fixture #id
String getFixtureNameByType(int type) {
  return fixtureNames[constrain(type-1, 0, fixtureNames.length-1)];
}

int getNumberOfFixtureTypes() {
  return fixtureNames.length;
}


int getFixtureTypeId1(String fixtureType) {
  int toReturn = 0;
  for(int i = 0; i < fixtureNames.length; i++) {
    if(fixtureType == fixtureNames[i]) { toReturn = i+1; break; }
  }
  return toReturn;
}


String getFixtureName(int id) {
  return getFixtureNameByType(fixtures.get(id).fixtureTypeId);
}

int universalDMXlength = 28+1;


int[][] profileChannels = 
{
  { },
  { DMX_DIMMER },
  { DMX_DIMMER },
  { DMX_DIMMER },
  { DMX_DIMMER },
  { DMX_DIMMER },
  { DMX_DIMMER },
  { DMX_DIMMER, DMX_FREQUENCY },
  { DMX_HAZE, DMX_FAN },
  { DMX_FOG },
  { DMX_RED, DMX_GREEN, DMX_BLUE },
  { DMX_RED, DMX_GREEN, DMX_BLUE, DMX_DIMMER },
  { DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE },
  { DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_DIMMER },
  { DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE },
  { DMX_SPECIAL1, DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2 },
  { DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2, DMX_STROBE, DMX_SPECIAL1, DMX_DIMMER },
  { DMX_PAN, DMX_TILT, DMX_PANFINE, DMX_TILTFINE, DMX_RESPONSESPEED, DMX_COLORWHEEL, DMX_SHUTTER, DMX_DIMMER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_SPECIALFUNCTIONS, DMX_AUTOPROGRAMS, DMX_PRISM, DMX_FOCUS },
  { DMX_PAN, DMX_TILT, DMX_COLORWHEEL, DMX_SHUTTER, DMX_DIMMER, DMX_SHUTTER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_PRISM, DMX_FOCUS }
};

int[] receiveDMXtoUniversal(int fT, int[] dmxChannels) {
  int[] toReturn = new int[universalDMXlength];
  for(int i = 0; i < toReturn.length; i++) { toReturn[i] = -2; }
  try {
         for(int i = 0; i < profileChannels.length; i++) {
           if(fT == i) { 
             for(int j = 0; j < profileChannels[i].length; j++) {
               toReturn[profileChannels[i][j]] = dmxChannels[j];
             }
           }
         }
    } catch(Exception e) { e.printStackTrace(); }
    return toReturn;
    
}

int[] getDMXfromUniversal(int fT, int[] universal) {
   int[] dmxChannels = new int[universalDMXlength];
      for(int i = 0; i < profileChannels.length; i++) {
           if(fT == i) { 
             dmxChannels = new int[profileChannels[i].length];
             for(int j = 0; j < profileChannels[i].length; j++) {
               dmxChannels[j] = universal[profileChannels[i][j]];
             }
           }
         }
    return dmxChannels; 
  }
