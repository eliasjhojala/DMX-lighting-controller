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
  return fixtureProfiles[fT].channelNames;
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
  String toReturn = "";
  if(fixtureProfiles[constrain(type, 0, fixtureProfiles.length-1)] != null) {
    toReturn = fixtureProfiles[constrain(type, 0, fixtureProfiles.length-1)].fixtureName;
  }
  return toReturn;
}

int getNumberOfFixtureTypes() {
  return fixtureProfiles.length;
}


int getFixtureTypeId1(String fixtureType) {
  int toReturn = 0;
  for(int i = 0; i < fixtureProfiles.length; i++) {
    if(fixtureProfiles[i] != null) {
      if(fixtureType == fixtureProfiles[i].fixtureName) { toReturn = i; break; }
    }
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
     if(fixtureProfiles[fT] != null) {
       for(int j = 0; j < fixtureProfiles[fT].channelTypes.length; j++) {
         toReturn[fixtureProfiles[fT].channelTypes[j]] = dmxChannels[j];
       }
     }
    } catch(Exception e) { e.printStackTrace(); }
    return toReturn;
    
}

int[] getDMXfromUniversal(int fT, int[] universal) {
   int[] dmxChannels = new int[universalDMXlength];
   if(fixtureProfiles[fT] != null) {
     dmxChannels = new int[fixtureProfiles[fT].channelTypes.length];
     for(int j = 0; j < fixtureProfiles[fT].channelTypes.length; j++) {
       dmxChannels[j] = universal[fixtureProfiles[fT].channelTypes[j]];
     }
   }
   return dmxChannels; 
}
 
FixtureProfile[] fixtureProfiles = new FixtureProfile[18]; 
void createFixtureProfiles() {
  fixtureProfiles[1] = new FixtureProfile("par64", new String[] {"Dimmer"}, new int[] {DMX_DIMMER} );
  fixtureProfiles[2] = new FixtureProfile("p.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER} );
  fixtureProfiles[3] = new FixtureProfile("k.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER} );
  fixtureProfiles[4] = new FixtureProfile("i.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER} );
  fixtureProfiles[5] = new FixtureProfile("flood", new String[] {"Dimmer"}, new int[] {DMX_DIMMER} );
  fixtureProfiles[6] = new FixtureProfile("linssi", new String[] {"Dimmer"}, new int[] {DMX_DIMMER} );
  
  fixtureProfiles[7] = new FixtureProfile("Strobe", new String[] {"Dimmer", "Frequency"}, new int[] {DMX_DIMMER, DMX_FREQUENCY});
  fixtureProfiles[8] = new FixtureProfile("Hazer", new String[] {"Haze", "Fan"}, new int[] {DMX_HAZE, DMX_FAN});
  fixtureProfiles[9] = new FixtureProfile("Fog", new String[] {"Fog"}, new int[] {DMX_FOG});
  
  fixtureProfiles[16] = new FixtureProfile("strv 8ch", 
    new String[] {"Red", "Green", "Blue", "White", "Color", "Strobe", "Mode", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2, DMX_STROBE, DMX_SPECIAL1, DMX_DIMMER} );
    
  fixtureProfiles[15] = new FixtureProfile("strv 6ch", 
    new String[] {"Mode", "Red", "Green", "Blue", "White", "Effect"}, 
    new int[] {DMX_SPECIAL1, DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2} );
    
  fixtureProfiles[14] = new FixtureProfile("strv 4ch", 
    new String[] {"Red", "Green", "Blue", "White"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
    
  fixtureProfiles[13] = new FixtureProfile("RGBWD", 
    new String[] {"Red", "Green", "Blue", "White", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_DIMMER} );
    
  fixtureProfiles[12] = new FixtureProfile("RGBW", 
    new String[] {"Red", "Green", "Blue", "White"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
    
  fixtureProfiles[11] = new FixtureProfile("RGBD", 
    new String[] {"Red", "Green", "Blue", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_DIMMER} );
    
  fixtureProfiles[10] = new FixtureProfile("RGB", 
    new String[] {"Red", "Green", "Blue"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE} );
    
  fixtureProfiles[10] = new FixtureProfile("RGB", 
    new String[] {"Red", "Green", "Blue", "White", "Color", "Strobe", "Mode", "Dimmer"}, 
    new int[] { DMX_PAN, DMX_TILT, DMX_PANFINE, DMX_TILTFINE, DMX_RESPONSESPEED, DMX_COLORWHEEL, DMX_SHUTTER, DMX_DIMMER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_SPECIALFUNCTIONS, DMX_AUTOPROGRAMS, DMX_PRISM, DMX_FOCUS } );
    
    
}
