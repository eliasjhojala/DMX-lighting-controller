//In this file should be all the functions related to fixture profiles located


//Gets dimensions of fixture #id
//0 = width, 1 = height, 2 = (0 or 1) render fixture?
int[] getFixtureSizeByType(int type) { 
  //Default to this
  int[] toReturn = {30, 40, 1};
  int n = constrain(type, 0, fixtureProfiles.length-1);
  if(fixtureProfiles[n] != null) {
    toReturn[0] = fixtureProfiles[n].size.w;
    toReturn[1] = fixtureProfiles[n].size.h;
    toReturn[2] = int(fixtureProfiles[n].size.isDrawn);
  }
  return toReturn;
  
}

int[] getFixtureSize(int id) {
  return getFixtureSizeByType(fixtures.get(id).fixtureTypeId);
}

String[] getChNamesByFixType(int fT) {
  return fixtureProfiles[fT].channelNames;
}

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

int[] receiveDMXtoUniversal(int fT, int[] dmxChannels) {
  int[] toReturn = new int[universalDMXlength];
  for(int i = 0; i < toReturn.length; i++) { toReturn[i] = -2; }
  try {
     if(fT < fixtureProfiles.length)
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
   if(fixtureProfiles.length > fT)
     if(fixtureProfiles[fT] != null) {
       dmxChannels = new int[fixtureProfiles[fT].channelTypes.length];
       for(int j = 0; j < fixtureProfiles[fT].channelTypes.length; j++) {
         dmxChannels[j] = universal[fixtureProfiles[fT].channelTypes[j]];
       }
     }
   return dmxChannels; 
}
 


fixtureSize toFixtureSize(int w, int h, boolean tdrwn) {
  fixtureSize fS = new fixtureSize(w, h, tdrwn);
  return fS;
}
fixtureSize toFixtureSize(int w, int h) {
  fixtureSize fS = new fixtureSize(w, h, true);
  return fS;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////PROFILE CLASS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class FixtureProfile {
  String fixtureName;
  String[] channelNames;
  int[] channelTypes;
  fixtureSize size;
  
  FixtureProfile(String fN, String[] cN, int[] cT, fixtureSize s) {
    fixtureName = fN;
    channelNames = cN;
    channelTypes = cT;
    size = s;
  }
  
   FixtureProfile(String fN, String[] cN, int[] cT) {
    fixtureName = fN;
    channelNames = cN;
    channelTypes = cT;
    size = new fixtureSize(30, 40, true);
  }
}



FixtureProfile[] fixtureProfiles = new FixtureProfile[19]; 
void createFixtureProfiles() {
  fixtureProfiles[0] = new FixtureProfile("", new String[] { }, new int[] { }, toFixtureSize(50, 50, false) );
  fixtureProfiles[1] = new FixtureProfile("par64", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(30, 50) );
  fixtureProfiles[2] = new FixtureProfile("p.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(25, 30) );
  fixtureProfiles[3] = new FixtureProfile("k.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(35, 40) );
  fixtureProfiles[4] = new FixtureProfile("i.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(40, 50) );
  fixtureProfiles[5] = new FixtureProfile("flood", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(40, 20) );
  fixtureProfiles[6] = new FixtureProfile("linssi", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(20, 60) );
  
  fixtureProfiles[7] = new FixtureProfile("Strobe", new String[] {"Dimmer", "Frequency"}, new int[] {DMX_DIMMER, DMX_FREQUENCY}, toFixtureSize(40, 25) );
  fixtureProfiles[8] = new FixtureProfile("Hazer", new String[] {"Haze", "Fan"}, new int[] {DMX_HAZE, DMX_FAN}, toFixtureSize(40, 45) );
  fixtureProfiles[9] = new FixtureProfile("Fog", new String[] {"Fog"}, new int[] {DMX_FOG}, toFixtureSize(40, 55) );
 
  fixtureProfiles[16] = new FixtureProfile("strv 8ch", 
    new String[] {"Red", "Green", "Blue", "White", "Color", "Strobe", "Mode", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2, DMX_STROBE, DMX_SPECIAL1, DMX_DIMMER} );
    
  fixtureProfiles[15] = new FixtureProfile("strv 6ch", 
    new String[] {"Mode", "Red", "Green", "Blue", "White", "Effect"}, 
    new int[] {DMX_SPECIAL1, DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2} );
    
  fixtureProfiles[14] = new FixtureProfile("strv 4ch", 
    new String[] {"Red", "Green", "Blue", "White"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
    
  fixtureProfiles[13] = new FixtureProfile("RGBWD", new String[] {"Red", "Green", "Blue", "White", "Dimmer"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_DIMMER} );
  fixtureProfiles[12] = new FixtureProfile("RGBW", new String[] {"Red", "Green", "Blue", "White"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
  fixtureProfiles[11] = new FixtureProfile("RGBD", new String[] {"Red", "Green", "Blue", "Dimmer"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_DIMMER} );
  fixtureProfiles[10] = new FixtureProfile("RGB", new String[] {"Red", "Green", "Blue"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE} );
    
  fixtureProfiles[17] = new FixtureProfile("MHX50", 
    new String[] {"Pan", "Tilt", "Pan fine", "Tilt fine", "Responsespeed", "Colorwheel", "Shutter", "Dimmer", "Gobowheel", "Goborotation", "Specialfunctions", "Autoprograms", "Prism", "Focus" }, 
    new int[] { DMX_PAN, DMX_TILT, DMX_PANFINE, DMX_TILTFINE, DMX_RESPONSESPEED, DMX_COLORWHEEL, DMX_SHUTTER, DMX_DIMMER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_SPECIALFUNCTIONS, DMX_AUTOPROGRAMS, DMX_PRISM, DMX_FOCUS } );
    
  fixtureProfiles[18] = new FixtureProfile("MHX50", 
    new String[] {"Pan", "Tilt", "Colorwheel", "Shutter", "Gobowheel", "Gobo rotation", "Prism", "Focus" }, 
    new int[] {DMX_PAN, DMX_TILT, DMX_COLORWHEEL, DMX_SHUTTER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_PRISM, DMX_FOCUS} );
    
}
