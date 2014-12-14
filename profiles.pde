
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
  }
  return toReturn;
  
}

int[] getFixtureSize(int id) {
  return getFixtureSizeByType(fixtures[id].fixtureTypeId);
}

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
  switch(type) {
    case 1: toReturn = "par64"; break;
    case 2: toReturn = "p.fresu"; break;
    case 3: toReturn = "k.fresu"; break;
    case 4: toReturn = "i.fresu"; break;
    case 5: toReturn = "flood"; break;
    case 6: toReturn = "linssi"; break;
    case 7: toReturn = "lhaze"; break;
    case 8: toReturn = "lfan"; break;
    case 9: toReturn = "strobe"; break;
    case 10: toReturn = "freq"; break;
    case 11: toReturn = "lfog"; break;
    case 12: toReturn = "pinspot"; break;
    case 16: toReturn = "MX50.14ch"; break;
    case 17: toReturn = "MX50.8ch"; break;
    case 18: toReturn = "RGB.par"; break;
    case 19: toReturn = "RGBD.par"; break;
    case 20: toReturn = "hazer"; break;
    case 21: toReturn = "fog"; break;
  }
  return toReturn;
}

int getNumberOfFixtureTypes() {
  return 21;
}




int getFixtureTypeId1(String fixtureType) {
  int toReturn = 0;
  if(fixtureType == "par64") { toReturn = 1; }
  if(fixtureType == "p.fresu") { toReturn = 2; }
  if(fixtureType == "k.fresu") { toReturn = 3; }
  if(fixtureType == "i.fresu") { toReturn = 4; }
  if(fixtureType == "flood") { toReturn = 5; }
  if(fixtureType == "linssi") { toReturn = 6; }
  if(fixtureType == "haze") { toReturn = 20; }
  if(fixtureType == "fog") { toReturn = 21; }
  //Muita: hazer, strobe, fog, pinspot, moving head, ledstrip, led par
  return toReturn;
}





String getFixtureName(int id) {
  return getFixtureNameByType(fixtures[id].fixtureTypeId);
}


