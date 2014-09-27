//Tässä välilehdessä luetaan iPadilta touchOSC-ohjelman inputti

int multixy1_value;
int multixy1_value_old;
int multixy1_value_offset;

boolean fullOn; //Muuttuja, joka kertoo onko fullOn päällä
int[] valueOfDimBeforeFullOn = new int[channels]; //Muuttuja johon kirjoitetaan kanavien arvot ennen kun ne laitetaan täysille
boolean blackOutButtonWasReleased;
int masterValueBeforeBlackout;
String addr = "";
void oscEvent(OscMessage theOscMessage) {
  
  addr = theOscMessage.addrPattern(); //Luetaan touchOSCin elementin osoite
  float val = theOscMessage.get(0).floatValue(); //Luetaan touchOSCin elementin arvo

  int digitalValue = int(val); //muutetaan float intiksi

  
  for(int i = 1; i <= touchOSCchannels; i++) { //Käydään kaikki touchOSCin kanavat (faderit) läpi
    String nimi = "/1/fader" + str(i);
    String nimi1 = "/1/push" + str(i);
    String nimi2 = "/5/fader" + str(i-24);
    String nimi3 = "/5/push" + str(i-24);
    String nimi4 = "/6/fader" + str(i-36);
    String nimi5 = "/6/push" + str(i-36);
    if(addr.equals(nimi) || addr.equals(nimi2)) {
      touchOSCchannel[i] = digitalValue;
    }
    if(addr.equals(nimi1) || addr.equals(nimi3)) {
      touchOSCchannel[i] = round(map(digitalValue, 0, 1, 1, 255));
    }
    if(addr.equals(nimi4)) {
      touchOSCchannel[i] = digitalValue;
    }
    if(addr.equals(nimi5)) {
      touchOSCchannel[i] = round(map(digitalValue, 0, 1, 1, 255));
    }
  
  }
  
  
  
  
     /*
       Blackout toimintaperiaate:
       laitetaan grandMaster nollaan
     */
  
   if(addr.equals("/blackout")) { //Jos blackout nappia painetaan
       if(digitalValue == 1) {
         if(blackOut == true) { //Jos blackout on päällä otetaan se pois päältä, eli palautetaan kanaville entiset arvot
            blackOut = false;
            memory(1, masterValueBeforeBlackout);
            valueOfMemory[1] = masterValueBeforeBlackout;
            memoryValue[1] = masterValueBeforeBlackout;
         }
         else { //Jos blackout ei ole päällä laitetaan se päälle eli laitetaan kanavat nolliin
           masterValueBeforeBlackout = grandMaster;
           blackOut = true;
           grandMaster = 0;
           valueOfMemory[1] = 0;
           memoryValue[1] = 0;
           memory(1, 0);
          
         }
       }
     }
     
     if(addr.equals("/strobenow")) {
       if(digitalValue == 1) {
         memory(soloMemory, 255);
       }
       else {
         memory(soloMemory, 0);
       }
     }
     
     
     if(addr.equals("/nextstep")) {
       if(digitalValue == 1) {
        nextStepPressed = true;
       }
       else {
        nextStepPressed = false;
       }
     }
     if(addr.equals("/revstep")) {
       if(digitalValue == 1) {
        revStepPressed = true;
       }
       else {
         revStepPressed = false;
       }
     }
     
     
     
     
     if(addr.equals("/6/waveLength")) {
       cf.waveLength = digitalValue;
     }
     
     
     
     if(addr.equals("/chaseModeUp")) {
       if(digitalValue == 1) {
           chaseMode++;
          if(chaseMode > 5) {
            chaseMode = 1;
          }
          sendDataToIpad("/chaseMode", chaseMode);
       }
     }
     
     if(addr.equals("/chaseModeDown")) {
       if(digitalValue == 1) {
           chaseMode--;
          if(chaseMode < 1) {
            chaseMode = 5;
          }
          sendDataToIpad("/chaseMode", chaseMode);
       }
     }
     
     
   
     /*
       Fullon toimintaperiaate:
       fullon on toiminto, joka laittaa kaikkien kanavien arvot täysille.
       Tämä tehdään myös pääloopissa (draw) niin pitkään kun fullOn = true,
       jotta arvoja ei ylikirjoiteta. Ennen kuin kaikki arvot laitetaan täysille
       kirjoitetaan niiden arvot muuttujaan (valueOfDimBeforeSolo[]), jotta
       ne voidaan palauttaa fullOnin päätyttyä. Fullon-nappi toimii
       go-tyyppisesti, eli sitä painettaessa fullOn menee päälle ja kun
       se päästetään irti fullOn sammuu.
     */
     
    
     
     if(addr.equals("/fullon")) {
       if(digitalValue == 0) {
          fullOn = false;
         for(int ii = 0; ii < channels; ii++) {
            dimInput[ii] = valueOfDimBeforeFullOn[ii];
          }
     
     }
     else {
       fullOn = true;
      for(int ii = 0; ii < channels; ii++) {
       valueOfDimBeforeFullOn[ii] = dim[ii];
        dimInput[ii] = 255;
      }
      
     }
       }
     
    
    /*
      Moving head toimintaperiaate:
      Moving headin ohjaamista varten on oma sivu touchOSCissa,
      jossa on sekä xy-pädi että faderi, jolla säädetään kirkkautta.
      Moving headin oikea kanava tarkistetaan käymällä läpi kaikki kanavat
      ja katsomalla minkä kanavan fixtuurityyppi on moving head.
      Sama tehdään siis dimmin, panin ja tiltin kanssa. Kun se ollaan
      saatu selville oikealle dim-muuttujalle annetaan touchOSCista 
      tullut arvo ja sen jälkeen se lähetetään DMX:ään aivan kuten muutkin
      dim-arvot. Kuitenkin yksi ero on huomattava. Moving headin pan
      ja tilt dim-muuttujat vaikuttavat sekä 2D- että 3D-visualisaatiossa
      moving headina asentoon.
    */
    
    
   if(addr.equals("/4/fader25")) {
      movingHeadDim = digitalValue;
       for(int iii = 0; iii < channels; iii++) {
     if(fixtureType1[iii] == 13) {
       dim[iii+1] = digitalValue;
     }
   }
   }
  
   
  if(addr.equals("/4/xy1")){
   movingHeadTilt = int(theOscMessage.get(0).floatValue());
   movingHeadPan = int(theOscMessage.get(1).floatValue());
   for(int iii = 0; iii < channels; iii++) {
     if(fixtureType1[iii] == 14) {
       dim[iii+1] = int(theOscMessage.get(1).floatValue());
       rotTaka[iii] = int(theOscMessage.get(1).floatValue());
     }
     if(fixtureType1[iii] == 15) {
       dim[iii+1] = int(theOscMessage.get(0).floatValue());
       rotX[iii] = int(theOscMessage.get(0).floatValue());
     }
   }
  }
  
  
}
