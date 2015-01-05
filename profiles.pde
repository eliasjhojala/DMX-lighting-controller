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
    switch(fT) {
         /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: toReturn[DMX_DIMMER] = dmxChannels[0]; break; //dimmers
         
         /* 2ch strobe */                    case 7: break; //2ch strobe
         /* 2ch hazer */                     case 8: toReturn[DMX_HAZE] = dmxChannels[0]; toReturn[DMX_FAN] = dmxChannels[1]; toReturn[DMX_DIMMER] = (toReturn[DMX_HAZE] + toReturn[DMX_FAN]) / 2; break; //2ch hazer
         /* 1ch fog */                       case 9: toReturn[DMX_FOG] = dmxChannels[0]; toReturn[DMX_DIMMER] = toReturn[DMX_FOG]; break; //1ch fog
         
         /* simple rgb led par */            case 10: toReturn[DMX_RED] = dmxChannels[0]; toReturn[DMX_GREEN] = dmxChannels[1]; toReturn[DMX_HAZE] = dmxChannels[2]; break; //Simple rgb led par
         /* simple rgb led par with dim */   case 11: toReturn[DMX_DIMMER] = dmxChannels[3]; toReturn[DMX_RED] = dmxChannels[0]; toReturn[DMX_GREEN] = dmxChannels[1]; toReturn[DMX_BLUE] = dmxChannels[2]; break; //Simple rgb led par with dim
         /* rgbw led par */                  case 12: toReturn[DMX_RED] = dmxChannels[0]; toReturn[DMX_GREEN] = dmxChannels[1]; toReturn[DMX_BLUE] = dmxChannels[2]; toReturn[DMX_WHITE] = dmxChannels[3]; break; //rgbw led par
         /* rgbwd led par */                 case 13: toReturn[DMX_RED] = dmxChannels[0]; toReturn[DMX_GREEN] = dmxChannels[1]; toReturn[DMX_BLUE] = dmxChannels[2]; toReturn[DMX_WHITE] = dmxChannels[3]; toReturn[DMX_DIMMER] = dmxChannels[4]; break; //rgbwd led par
         /* stairville rgbwd led par 4ch */  case 14: toReturn[DMX_RED] = dmxChannels[0]; toReturn[DMX_GREEN] = dmxChannels[1]; toReturn[DMX_BLUE] = dmxChannels[2]; toReturn[DMX_WHITE] = dmxChannels[3]; break; //stairville rgbwd led par 4ch
         /* stairville rgbwd led par 6ch */  case 15: toReturn[DMX_SPECIAL1] = dmxChannels[0]; toReturn[DMX_RED] = dmxChannels[1]; toReturn[DMX_GREEN] = dmxChannels[2]; toReturn[DMX_BLUE] = dmxChannels[3]; toReturn[DMX_WHITE] = dmxChannels[4]; toReturn[DMX_SPECIAL2] = dmxChannels[5]; break; //stairville rgbwd led par 6ch
         /* stairville rgbwd led par 8ch */  case 16: toReturn[DMX_RED] = dmxChannels[0]; toReturn[DMX_GREEN] = dmxChannels[1]; toReturn[DMX_BLUE] = dmxChannels[2]; toReturn[DMX_WHITE] = dmxChannels[3]; toReturn[DMX_SPECIAL2] = dmxChannels[4]; toReturn[DMX_STROBE] = dmxChannels[5]; toReturn[DMX_SPECIAL1] = dmxChannels[6]; toReturn[DMX_DIMMER] = dmxChannels[7]; break; //stairville rgbwd led par 8ch
         
         /* MH-X50 14-channel mode */        case 17: toReturn[DMX_PAN] = dmxChannels[0]; toReturn[DMX_TILT] = dmxChannels[1]; toReturn[DMX_PANFINE] = dmxChannels[2]; toReturn[DMX_TILTFINE] = dmxChannels[3]; toReturn[DMX_RESPONSESPEED] = dmxChannels[4]; toReturn[DMX_COLORWHEEL] = dmxChannels[5]; toReturn[DMX_SHUTTER] = dmxChannels[6]; toReturn[DMX_DIMMER] = dmxChannels[7]; toReturn[DMX_GOBOWHEEL] = dmxChannels[8]; toReturn[DMX_GOBOROTATION] = dmxChannels[9]; toReturn[DMX_SPECIALFUNCTIONS] = dmxChannels[10]; toReturn[DMX_AUTOPROGRAMS] = dmxChannels[11]; toReturn[DMX_PRISM] = dmxChannels[12]; toReturn[DMX_FOCUS] = dmxChannels[13]; break; //MH-X50
         /* MH-X50 8-channel mode */         case 18: toReturn[DMX_PAN] = dmxChannels[0]; toReturn[DMX_TILT] = dmxChannels[1]; toReturn[DMX_COLORWHEEL] = dmxChannels[2]; toReturn[DMX_SHUTTER] = dmxChannels[3]; toReturn[DMX_DIMMER] = toReturn[DMX_SHUTTER]; toReturn[DMX_GOBOWHEEL] = dmxChannels[4]; toReturn[DMX_GOBOROTATION] = dmxChannels[5]; toReturn[DMX_PRISM] = dmxChannels[6]; toReturn[DMX_FOCUS] = dmxChannels[7]; break; //MH-X50 8-ch mode
         
      }
    } catch(Exception e) { e.printStackTrace(); }
    return toReturn;
    
}

int[] getDMXfromUniversal(int fT, int[] universal) {
   int[] dmxChannels = new int[universalDMXlength];
      switch(fT) {
       /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dmxChannels = new int[1]; dmxChannels[0] = universal[DMX_DIMMER]; break; //universal[DMX_DIMMER]s
       
       /* 2ch universal[DMX_STROBE] */     case 7: dmxChannels = new int[2]; dmxChannels[0] = universal[DMX_DIMMER]; dmxChannels[1] = universal[DMX_FREQUENCY]; break; //2ch universal[DMX_STROBE]
       /* 2ch universal[DMX_HAZE]r */      case 8: dmxChannels = new int[2]; dmxChannels[0] = universal[DMX_HAZE]; dmxChannels[1] = universal[DMX_FAN]; break; //2ch universal[DMX_HAZE]r
       /* 1ch universal[DMX_FOG] */       case 9: dmxChannels = new int[1]; dmxChannels[0] = universal[DMX_FOG]; break; //1ch universal[DMX_FOG]
      
       /* simple rgb led par */            case 10: dmxChannels = new int[3]; dmxChannels[0] = universal[DMX_RED]; dmxChannels[1] = universal[DMX_GREEN]; dmxChannels[2] = universal[DMX_BLUE]; break; //Simple rgb led par
       /* simple rgb led par with dim */   case 11: dmxChannels = new int[4]; dmxChannels[3] = universal[DMX_DIMMER]; dmxChannels[0] = universal[DMX_RED]; dmxChannels[1] = universal[DMX_GREEN]; dmxChannels[2] = universal[DMX_BLUE]; break; //Simple rgb led par with dim
       /* rgbw led par */                  case 12: dmxChannels = new int[4]; dmxChannels[0] = universal[DMX_RED]; dmxChannels[1] = universal[DMX_GREEN]; dmxChannels[2] = universal[DMX_BLUE]; dmxChannels[3] = universal[DMX_WHITE]; break; //rgbw
       /* rgbwd led par */                 case 13: dmxChannels = new int[5]; dmxChannels[0] = universal[DMX_RED]; dmxChannels[1] = universal[DMX_GREEN]; dmxChannels[2] = universal[DMX_BLUE]; dmxChannels[3] = universal[DMX_WHITE]; dmxChannels[4] = universal[DMX_DIMMER]; break; //rgbwd
       /* stairville rgbwd led par 4ch */  case 14: dmxChannels = new int[4]; dmxChannels[0] = universal[DMX_RED]; dmxChannels[1] = universal[DMX_GREEN]; dmxChannels[2] = universal[DMX_BLUE]; dmxChannels[3] = universal[DMX_WHITE]; break; //stairville rgbwd led par 4ch
       /* stairville rgbwd led par 6ch */  case 15: dmxChannels = new int[6]; dmxChannels[0] = universal[DMX_SPECIAL1]; dmxChannels[1] = universal[DMX_RED]; dmxChannels[2] = universal[DMX_GREEN]; dmxChannels[3] = universal[DMX_BLUE]; dmxChannels[4] = universal[DMX_WHITE]; dmxChannels[5] = universal[DMX_SPECIAL2]; break; //stairville rgbwd led par 6ch
       /* stairville rgbwd led par 8ch */  case 16: dmxChannels = new int[8]; dmxChannels[0] = universal[DMX_RED]; dmxChannels[1] = universal[DMX_GREEN]; dmxChannels[2] = universal[DMX_BLUE]; dmxChannels[3] = universal[DMX_WHITE]; dmxChannels[4] = universal[DMX_SPECIAL2]; dmxChannels[5] = universal[DMX_STROBE]; dmxChannels[6] = universal[DMX_SPECIAL1]; dmxChannels[7] = universal[DMX_DIMMER]; break; //stairville rgbwd led par 8ch
                
       /* MH-X50 14-channel mode */        case 17: dmxChannels = new int[14]; dmxChannels[0] = universal[DMX_PAN]; dmxChannels[1] = universal[DMX_TILT]; dmxChannels[2] = universal[DMX_PANFINE]; dmxChannels[3] = universal[DMX_TILTFINE]; dmxChannels[4] = universal[DMX_RESPONSESPEED]; dmxChannels[5] = universal[DMX_COLORWHEEL]; dmxChannels[6] = universal[DMX_SHUTTER]; dmxChannels[7] = universal[DMX_DIMMER]; dmxChannels[8] = universal[DMX_GOBOWHEEL]; dmxChannels[9] = universal[DMX_GOBOROTATION]; dmxChannels[10] = universal[DMX_SPECIALFUNCTIONS]; dmxChannels[11] = universal[DMX_AUTOPROGRAMS]; dmxChannels[12] = universal[DMX_PRISM]; dmxChannels[13] = universal[DMX_FOCUS]; break; //MH-X50
       /* MH-X50 8-channel mode */         case 18: dmxChannels = new int[8]; dmxChannels[0] = universal[DMX_PAN]; dmxChannels[1] = universal[DMX_TILT]; dmxChannels[2] = universal[DMX_COLORWHEEL]; dmxChannels[3] = universal[DMX_SHUTTER]; dmxChannels[4] = universal[DMX_GOBOWHEEL]; dmxChannels[5] = universal[DMX_GOBOROTATION]; dmxChannels[6] = universal[DMX_PRISM]; dmxChannels[7] = universal[DMX_FOCUS]; break; //MH-X50 8-ch mode
       
       /* 1ch relay */                     case 23: dmxChannels = new int[1]; if(universal[DMX_DIMMER] > 100) { dmxChannels[0] = 255; } else { dmxChannels[0] = 0; } break; //1ch relay
       
       
    }
    return dmxChannels; 
  }
