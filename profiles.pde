//In this file should be all the functions related to fixture profiles located


//Gets dimensions of fixture #id
//0 = width, 1 = height, 2 = (0 or 1) render fixture?
int[] getFixtureSizeByType(int type) { 
  //Default to this
  int[] toReturn = {30, 40, 1};
  
  switch(type) {
    case 1: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break;
    case 2: toReturn[0] = 25; toReturn[1] = 30; toReturn[2] = 1; break;
    case 3: toReturn[0] = 35; toReturn[1] = 40; toReturn[2] = 1; break;
    case 4: toReturn[0] = 40; toReturn[1] = 50; toReturn[2] = 1; break;
    case 5: toReturn[0] = 40; toReturn[1] = 20; toReturn[2] = 1; break;
    case 6: toReturn[0] = 20; toReturn[1] = 60; toReturn[2] = 1; break;
    case 7: toReturn[0] = 50; toReturn[1] = 50; toReturn[2] = 1; break;
    case 8: toReturn[2] = 0; break;
    case 9: toReturn[0] = 40; toReturn[1] = 30; toReturn[2] = 1; break;
    case 10: toReturn[2] = 0; break;
    case 11: toReturn[0] = 50; toReturn[1] = 70; toReturn[2] = 1; break;
    case 12: toReturn[0] = 5; toReturn[1] = 8; toReturn[2] = 1; break;
    case 13: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break;
    case 20: toReturn[0] = 60; toReturn[1] = 70; toReturn[2] = 1; break; //Hazer
    case 21: toReturn[0] = 60; toReturn[1] = 80; toReturn[2] = 1; break; //Fog
  }
  return toReturn;
  
}

int[] getFixtureSize(int id) {
  return getFixtureSizeByType(fixtures.get(id).fixtureTypeId);
}


String[] fixtureNames = { 
  "par64", 
  "p.fresu", 
  "k.fresu", 
  "i.fresu", 
  "flood", 
  "linssi", 
  "lhaze", 
  "lfan", 
  "strobe", 
  "freq", 
  "lfog", 
  "pinspot", 
  "",
  "",
  "",
  "MX50.14ch", 
  "MX50.8ch",
  "RGB.par",
  "RGBD.par",
  "hazer",
  "fog"
};

//Gets type description of fixture #id
String getFixtureNameByType(int type) {
  
  //* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6:  //dimmers
  //* MH-X50 14-channel mode */        case 16:  //MH-X50
  //* MH-X50 8-channel mode */         case 17:  //MH-X50 8-ch mode
  //* simple rgb led par */            case 18:  //Simple rgb led par
  //* simple rgb led par with dim */   case 19:  //Simple rgb led par with dim
  //* 2ch hazer */                     case 20:  //2ch hazer
  //* 1ch fog */                       case 21:  //1ch fog
  
  String toReturn = "-";

  if(type-1 < fixtureNames.length && type-1 >= 0) { toReturn = fixtureNames[type-1]; }
  return toReturn;
}

int getNumberOfFixtureTypes() {
  return 21;
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


