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
  int digitalValue2 = 0;
  if(addr.equals("/7/xy1") || addr.equals("/7/xy2") || addr.equals("/8/xy1") || addr.equals("/8/xy2")) {
    digitalValue2 = int(theOscMessage.get(1).floatValue());
  }
  
  
   movingHeadOptionsCheck(addr, digitalValue, digitalValue2);
  
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
         blackOutToggle();
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

  
     if(addr.equals("/fullon")) {
       fullOn(boolean(digitalValue));
     }
}
