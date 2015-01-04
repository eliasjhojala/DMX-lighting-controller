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

String[] getChNamesByFixType(int fT) {
  String[] tR = { "Default" };
    switch(fT) {
      case 1: case 2: case 3: case 4: case 5: case 6: String[] tR1 = { "Dimmer" }; tR = new String[tR1.length]; arrayCopy(tR1, tR); break;
     
      case 16: //mhX50 14ch
        String[] tR16 = {"Pan", "Tilt", "Fine Pan", "Fine Tilt", "Resp. Speed", "Color Wheel", "Shutter", "Dimmer", "Gobo", "Gobo Rotation", "S. Function", "Auto Program", "Prism", "Focus"}; 
        tR = new String[tR16.length]; arrayCopy(tR16, tR); 
      break;
      
      case 17: //mhX50 8ch
        String[] tR17 = {"Pan", "Tilt", "Color Wheel", "Shutter", "Gobo", "Gobo Rotation", "Prism", "Focus"}; 
        tR = new String[tR17.length]; arrayCopy(tR17, tR); 
      break; 
      
      case 18: tR = new String[3]; arrayCopy(returnRGB(), tR); break; //RGB.par
      case 19: tR = new String[4]; arrayCopy(returnRGB(), tR); tR[3] = "Dimmer"; break; //RGBD.par
      case 20: String[] tR20 = {"Haze", "Fan"}; tR = new String[tR20.length]; arrayCopy(tR20, tR); break; //Hazer
      case 21: String[] tR21 = {"Fog"}; tR = new String[tR21.length]; arrayCopy(tR21, tR); break; //Fog machine
      case 24: tR = new String[4]; arrayCopy(returnRGB(), tR); tR[3] = "White"; break; //RGBW.par
//      case 25: case 26: tR = new String[5]; arrayCopy(returnRGB(), tR); tR[3] = "White"; tR[4] = "Dimmer"; break; //RGBWD.par and also Stairville RGBW 4ch
//      case 27: String[] tR26 = {"Mode", "Red", "Green", "Blue", "White", "Effect"}; tR = new String[tR26.length]; arrayCopy(tR26, tR); break; //Stairville RGBW 6ch
//      case 28: String[] tR28 = {"Red", "Green", "Blue", "White", "Effect", "Color", "Strobe", "Mode", "Dimmer"}; tR = new String[tR28.length]; arrayCopy(tR28, tR); break; //Stairville RGBW 8ch
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
  "lhaze", //7
  "lfan", //8
  "strobe", //9
  "freq", //10
  "lfog", //11
  "pinspot", //12
  "", //13
  "", //14
  "", //15
  "MX50.14ch", //16
  "MX50.8ch", //17
  "RGB.par", //18
  "RGBD.par", //19
  "hazer", //20
  "fog", //21
  "", //22
  "", //23
  "RGBW.par", //24
  "RGBWD.par", //25
  "PAR64 CX-3 RGBW 4CH", //26
  "PAR64 CX-3 RGBW 6CH", //27
  "PAR64 CX-3 RGBW 8CH" //28
  
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


