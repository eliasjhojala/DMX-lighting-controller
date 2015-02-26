//Tässä välilehdessä luetaan iPadilta touchOSC-ohjelman inputti
 
 int sensity;
 
int multixy1_value;
int multixy1_value_old; 
int multixy1_value_offset;

boolean fullOn; //Muuttuja, joka kertoo onko fullOn päällä
int[] valueOfDimBeforeFullOn = new int[channels]; //Muuttuja johon kirjoitetaan kanavien arvot ennen kun ne laitetaan täysille
boolean blackOutButtonWasReleased;
int masterValueBeforeBlackout;
String addr = "";
int[] valueOfDimBeforeStrobe = new int[fixtures.size()];
void oscEvent(OscMessage theOscMessage) {
  
  addr = theOscMessage.addrPattern(); //Luetaan touchOSCin elementin osoite
  
  
  float val = theOscMessage.get(0).floatValue(); //Luetaan touchOSCin elementin arvo

  int digitalValue = round(val); //round original val to place it into int
  int digitalValue2 = 0;
  if(addr.equals("/7/xy1") || addr.equals("/7/xy2") || addr.equals("/8/xy1") || addr.equals("/8/xy2")) {
    digitalValue2 = int(theOscMessage.get(1).floatValue());
  }
  
  oscHandler.sendMessage(addr, digitalValue);
  
  
 // fixtureInputs[0].receiveOSC(digitalValue, digitalValue2, addr);
  
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
      touchOSCchannel[i] = round(map(digitalValue, 0, 1, 0, 255));
    }
    if(addr.equals(nimi4)) {
      touchOSCchannel[i] = digitalValue;
    }
    if(addr.equals(nimi5)) {
      touchOSCchannel[i] = round(map(digitalValue, 0, 1, 0, 255));
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
         for(int i = 0; i < fixtures.size(); i++) {
           valueOfDimBeforeStrobe[i] = fixtures.get(i).in.getUniDMX(DMX_DIMMER);
           fixtures.get(i).setDimmer(0);
         }
         for(int i = 0; i < fixtures.size(); i++) {
           if(getFixtureNameByType(fixtures.get(i).fixtureTypeId) == "strobe") {
             fixtures.get(i).in.setUniDMX(DMX_DIMMER, 200);
             fixtures.get(i).in.setUniDMX(DMX_FREQUENCY, 200);
           }
         }
       }
       else {
         for(int i = 0; i < fixtures.size(); i++) {
           fixtures.get(i).setDimmer(valueOfDimBeforeStrobe[i]);
         }
         for(int i = 0; i < fixtures.size(); i++) {
           if(getFixtureNameByType(fixtures.get(i).fixtureTypeId) == "strobe") {
             fixtures.get(i).in.setUniDMX(DMX_DIMMER, 0);
             fixtures.get(i).in.setUniDMX(DMX_FREQUENCY, 0);
           }
         }
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
     
     
     if(addr.equals("/chaseModeUp")) {
       if(digitalValue == 1) {
           nextChaseMode();
       }
     }
     
     if(addr.equals("/chaseModeDown")) {
       if(digitalValue == 1) {
          reverseChaseMode();
       }
     }

  
     if(addr.equals("/fullon")) {
     }
     
     
     { //Functions to move fixtures in visualisatioon
     
           
           if(addr.equals("/fixtureSettings/a")) {
             for(int i = 0; i < fixtures.size(); i++) {
               if(fixtures.get(i).selected) {
                 fixtures.get(i).rotationX += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fixtures.get(i).in.setUniversalDMX(1, 255);
               }
             }
           }
      
           if(addr.equals("/fixtureSettings/c")) {
             for(int i = 0; i < fixtures.size(); i++) {
               if(fixtures.get(i).selected) {
                 fixtures.get(i).rotationZ += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fixtures.get(i).in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/d")) {
             for(int i = 0; i < fixtures.size(); i++) {
               if(fixtures.get(i).selected) {
                 fixtures.get(i).x_location += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fixtures.get(i).in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/e")) {
             for(int i = 0; i < fixtures.size(); i++) {
               if(fixtures.get(i).selected) {
                 fixtures.get(i).y_location += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fixtures.get(i).in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/f")) {
             for(int i = 0; i < fixtures.size(); i++) {
               if(fixtures.get(i).selected) {
                 fixtures.get(i).z_location += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fixtures.get(i).in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/fader1")) {
             sensity = digitalValue;
           }
     
     } //End of functions to move fixtures in visualisation
     
     
     if(addr.equals("/trussSettings/down") && digitalValue == 1) {
       selectedTruss--;
       selectedTruss = constrain(selectedTruss, 0, numberOfAnsas);
       oscHandler.sendMessage("/trussSettings/selected", selectedTruss);
       oscHandler.sendMessage("/trussSettings/type", ansaType[constrain(selectedTruss, 0, ansaType.length-1)]);
     }
     if(addr.equals("/trussSettings/up") && digitalValue == 1) {
       selectedTruss++;
       selectedTruss = constrain(selectedTruss, 0, numberOfAnsas);
       oscHandler.sendMessage("/trussSettings/selected", selectedTruss);
       oscHandler.sendMessage("/trussSettings/type", ansaType[constrain(selectedTruss, 0, ansaType.length-1)]);
     }
     if(addr.equals("/trussSettings/z")) {
       ansaZ[constrain(selectedTruss, 0, ansaZ.length-1)] = digitalValue*10;
     }
     if(addr.equals("/trussSettings/y")) {
       ansaY[constrain(selectedTruss, 0, ansaY.length-1)] = digitalValue*10;
     }
     
     
     if(digitalValue == 1) {
     if(addr.equals("/trussSettings/typeUp")) {
       ansaType[constrain(selectedTruss, 0, ansaType.length-1)]++;
       oscHandler.sendMessage("/trussSettings/type", ansaType[constrain(selectedTruss, 0, ansaType.length-1)]);
     }
     if(addr.equals("/trussSettings/typeDown")) {
       ansaType[constrain(selectedTruss, 0, ansaType.length-1)]--;
       oscHandler.sendMessage("/trussSettings/type", ansaType[constrain(selectedTruss, 0, ansaType.length-1)]);
     }
     }
     
     if(addr.equals("/trussSettings/parentFixtures") && digitalValue == 1) {
        for(int i = 0; i < fixtures.size(); i++) {
         if(fixtures.get(i).selected) {
           fixtures.get(i).parentAnsa = selectedTruss;
         }
       }
     }
     
     if(addr.equals("/fixtureSettings/chUp") && digitalValue == 1) {
       activeChannel++;
       oscHandler.sendMessage("/fixtureSettings/channel", activeChannel);
     }
     if(addr.equals("/fixtureSettings/chDown") && digitalValue == 1) {
       activeChannel--;
       oscHandler.sendMessage("/fixtureSettings/channel", activeChannel);
     }
     if(addr.equals("/fixtureSettings/chSet") && digitalValue == 1) {
       for(int i = 0; i < fixtures.size(); i++) {
         if(fixtures.get(i).selected) {
           fixtures.get(i).channelStart = activeChannel;
         }
       }
     }
     
     if(addr.equals("/fixtureSettings/r")) {
       for(int i = 0; i < fixtures.size(); i++) {
         if(fixtures.get(i).selected) {
           fixtures.get(i).red = digitalValue;
         }
       }
     }
     if(addr.equals("/fixtureSettings/g")) {
       for(int i = 0; i < fixtures.size(); i++) {
         if(fixtures.get(i).selected) {
           fixtures.get(i).green = digitalValue;
         }
       }
     }
     if(addr.equals("/fixtureSettings/b")) {
       for(int i = 0; i < fixtures.size(); i++) {
         if(fixtures.get(i).selected) {
           fixtures.get(i).blue = digitalValue;
         }
       }
     }
     
     
}
int selectedTruss = 0;
int activeChannel = 0;

