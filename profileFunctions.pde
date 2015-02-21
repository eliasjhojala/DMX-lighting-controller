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

