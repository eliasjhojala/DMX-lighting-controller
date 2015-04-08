//Tässä välilehdessä luetaan iPadilta touchOSC-ohjelman inputti
 
 int sensity;
 
int multixy1_value;
int multixy1_value_old;
int multixy1_value_offset;

boolean fullOn; //Muuttuja, joka kertoo onko fullOn päällä
boolean strobeNow;
boolean fogNow;
boolean blackOutButtonWasReleased;
String addr = "";

boolean reverseStepPressed;

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
      touchOSCchannel[i] = round(map(digitalValue, 0, 1, -1, 255));
    }
    if(addr.equals(nimi4)) {
      touchOSCchannel[i] = digitalValue;
    }
    if(addr.equals(nimi5)) {
      touchOSCchannel[i] = round(map(digitalValue, 0, 1, 0, 255));
    }
  
  }
  


   if(addr.equals("/blackout")) { //Jos blackout nappia painetaan
     if(digitalValue == 1) {
         blackOut = !blackOut;
     }
   }
     
     if(addr.equals("/strobenow")) {
       strobeNow = boolean(digitalValue);
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
        reverseStepPressed = true;
       }
       else {
         reverseStepPressed = false;
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
       fullOn = boolean(digitalValue);
     }
     if(addr.equals("/fognow")) {
       fogNow = boolean(digitalValue);
     }
     
     
     { //Functions to move fixtures in visualisatioon
     
           
           if(addr.equals("/fixtureSettings/a")) {
             for(fixture fix : fixtures.iterate()) {
               if(fix.selected) {
                 fix.rotationX += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fix.in.setUniversalDMX(1, 255);
               }
             }
           }
      
           if(addr.equals("/fixtureSettings/c")) {
             for(fixture fix : fixtures.iterate()) {
               if(fix.selected) {
                 fix.rotationZ += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fix.in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/d")) {
             for(fixture fix : fixtures.iterate()) {
               if(fix.selected) {
                 fix.x_location += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fix.in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/e")) {
             for(fixture fix : fixtures.iterate()) {
               if(fix.selected) {
                 fix.y_location += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fix.in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/f")) {
             for(fixture fix : fixtures) {
               if(fix.selected) {
                 fix.z_location += round(map(digitalValue, 0, 1, -sensity, sensity));
                 fix.in.setUniversalDMX(1, 255);
               }
             }
           }
           
           if(addr.equals("/fixtureSettings/fader1")) {
             sensity = digitalValue;
           }
     
     } //End of functions to move fixtures in visualisation
     
     
     if(addr.equals("/trussSettings/down") && digitalValue == 1) {
       selectedTruss--;
       selectedTruss = constrain(selectedTruss, 0, trusses.length-1);
       oscHandler.sendMessage("/trussSettings/selected", selectedTruss);
       oscHandler.sendMessage("/trussSettings/type", trusses[constrain(selectedTruss, 0, trusses.length-1)].type);
     }
     if(addr.equals("/trussSettings/up") && digitalValue == 1) {
       selectedTruss++;
       selectedTruss = constrain(selectedTruss, 0, trusses.length-1);
       oscHandler.sendMessage("/trussSettings/selected", selectedTruss);
       oscHandler.sendMessage("/trussSettings/type", trusses[constrain(selectedTruss, 0, trusses.length-1)].type);
     }
     if(addr.equals("/trussSettings/z")) {
       trusses[constrain(selectedTruss, 0, trusses.length-1)].location.z = digitalValue*10;
     }
     if(addr.equals("/trussSettings/y")) {
       trusses[constrain(selectedTruss, 0, trusses.length-1)].location.y = digitalValue*10;
     }
     
     
     if(digitalValue == 1) {
     if(addr.equals("/trussSettings/typeUp")) {
       trusses[constrain(selectedTruss, 0, trusses.length-1)].type++;
       oscHandler.sendMessage("/trussSettings/type", trusses[constrain(selectedTruss, 0, trusses.length-1)].type);
     }
     if(addr.equals("/trussSettings/typeDown")) {
       trusses[constrain(selectedTruss, 0, trusses.length-1)].type--;
       oscHandler.sendMessage("/trussSettings/type", trusses[constrain(selectedTruss, 0, trusses.length-1)].type);
     }
     }
     
     if(addr.equals("/trussSettings/parentFixtures") && digitalValue == 1) {
        for(fixture fix : fixtures.iterate()) {
         if(fix.selected) {
           fix.parentAnsa = selectedTruss;
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
       for(fixture fix : fixtures.iterate()) {
         if(fix.selected) {
           fix.channelStart = activeChannel;
         }
       }
     }
     
     if(addr.equals("/fixtureSettings/r")) {
       for(fixture fix : fixtures.iterate()) {
         if(fix.selected) {
           fix.red = digitalValue;
         }
       }
     }
     if(addr.equals("/fixtureSettings/g")) {
       for(fixture fix : fixtures.iterate()) {
         if(fix.selected) {
           fix.green = digitalValue;
         }
       }
     }
     if(addr.equals("/fixtureSettings/b")) {
       for(fixture fix : fixtures.iterate()) {
         if(fix.selected) {
           fix.blue = digitalValue;
         }
       }
     }
     
     
}
int selectedTruss = 0;
int activeChannel = 0;
