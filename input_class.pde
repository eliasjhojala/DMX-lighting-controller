
boolean createFinalValuesPlease;
boolean saveDimmerValue;

String[] saveOptionButtonVariables = { "dimmer", "color", "gobo", "goboRotation", "shutter", "pan", "tilt" };
boolean[] saveOptionButtonVariableValues = new boolean[saveOptionButtonVariables.length];
boolean[][] whatToSave = new boolean[saveOptionButtonVariables.length][numberOfMemories];

class fixtureInput {
  int fixtureType;
  int channelStart;
  int fixtureTypeId;
  int selectedFixture;
  //Define all the variables
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int rotationX, rotationZ;
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions, frequency; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
 
  int sF = selectedFixture; //This variable tells what is actual fixtureId
  int fT = fixtures[sF].fixtureTypeId; //This variable tells actual fixtureType
  
  //MHX50 personal settins
  int[][] mhx50_RGB_color_Values = { { 255, 255, 255 }, { 255, 255, 0 }, { 255, 100, 255 }, { 0, 100, 0 }, { 255, 0, 255 }, { 0, 0, 255 }, { 0, 255, 0 }, { 255, 30, 0 }, { 0, 0, 100 } };
  int[] mhx50_color_values = { 5, 12, 19, 26, 33, 40, 47, 54, 62 }; //white, yellow, lightpink, green, darkpink, lightblue, lightgreen, red, dark blue
  String[] mhx50_color_names = { "white", "yellow", "lightpink", "green", "darkpink", "lightblue", "lightgreen", "red", "blue" };
  int[] mhx50_gobo_values = { 6, 14, 22, 30, 38, 46, 54, 62 };
  int[] mhx50_autoProgram_values = { 6, 22, 6, 38, 6, 54, 6, 70, 6, 86, 6, 102, 6, 118, 6, 134, 6, 150, 6, 166, 6, 182, 6, 198, 6, 214, 6, 230, 6, 247, 6, 254 };
  
  //MHX50 personal settings end here
  
  int goboNumber;
  int autoProgramNumber;
  int colorNumber;
  
  //Defining variables end here
  

  
  fixtureInput(int d, int r, int g, int b, int p, int t, int pF, int tF, int rX, int rZ, int cW, int gW, int gR, int pr, int foc, int sh, int st, int re, int au, int sp, int ha, int fa, int fo) {
  }

   void updateVariables() {
      sF = selectedFixture; //This variable tells what is actual fixtureId
      fT = fixtures[sF].fixtureTypeId; //This variable tells actual fixtureType
   }
 
   void receiveFromBottomMenu(int[] dmxChannels, int fixtId) {
     setSelectedFixture(0, fixtId);
     receiveDMX(dmxChannels);
   }
 
   void receiveDMX(int[] dmxChannels) {
    switch(fT) {
         /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dimmer = dmxChannels[0]; break; //dimmers
         /* MH-X50 14-channel mode */        case 16: case 17: pan = dmxChannels[0]; tilt = dmxChannels[1]; panFine = dmxChannels[2]; tiltFine = dmxChannels[3]; responseSpeed = dmxChannels[4]; colorWheel = dmxChannels[5]; shutter = dmxChannels[6]; dimmer = dmxChannels[7]; goboWheel = dmxChannels[8]; goboRotation = dmxChannels[9]; specialFunctions = dmxChannels[10]; autoPrograms = dmxChannels[11]; prism = dmxChannels[12]; focus = dmxChannels[13]; setColorValuesFromDmxValue(colorWheel); break; //MH-X50
         /* MH-X50 8-channel mode */         //case 17: pan = dmxChannels[0]; tilt = dmxChannels[1]; colorWheel = dmxChannels[2]; shutter = dmxChannels[3]; goboWheel = dmxChannels[4]; goboRotation = dmxChannels[5]; prism = dmxChannels[6]; focus = dmxChannels[7]; break; //MH-X50 8-ch mode
         /* simple rgb led par */            case 18: red = dmxChannels[0]; green = dmxChannels[1]; blue = dmxChannels[2]; break; //Simple rgb led par
         /* simple rgb led par with dim */   case 19: dimmer = dmxChannels[0]; red = dmxChannels[1]; green = dmxChannels[2]; blue = dmxChannels[3]; break; //Simple rgb led par with dim
         /* 2ch hazer */                     case 20: haze = dmxChannels[0]; fan = dmxChannels[1]; break; //2ch hazer
         /* 1ch fog */                       case 21: fog = dmxChannels[0]; break; //1ch fog
      }
      createFinalValues();
  }
  
    public int[] getDMX() {
    int[] dmxChannels = new int[30];
      switch(fixtureTypeId) {
         /* Dimmer channels */               case 1: case 2: case 3: case 4: case 5: case 6: dmxChannels = new int[1]; dmxChannels[0] = dimmer; break; //dimmers
         /* MH-X50 14-channel mode */        case 16: dmxChannels = new int[14]; dmxChannels[0] = pan; dmxChannels[1] = tilt; dmxChannels[2] = panFine; dmxChannels[3] = tiltFine; dmxChannels[4] = responseSpeed; dmxChannels[5] = colorWheel; dmxChannels[6] = shutter; dmxChannels[7] = dimmer; dmxChannels[8] = goboWheel; dmxChannels[9] = goboRotation; dmxChannels[10] = specialFunctions; dmxChannels[11] = autoPrograms; dmxChannels[12] = prism; dmxChannels[13] = focus; break; //MH-X50
         /* MH-X50 8-channel mode */         case 17: dmxChannels = new int[8]; dmxChannels[0] = pan; dmxChannels[1] = tilt; dmxChannels[2] = colorWheel; dmxChannels[3] = shutter; dmxChannels[4] = goboWheel; dmxChannels[5] = goboRotation; dmxChannels[6] = prism; dmxChannels[7] = focus; break; //MH-X50 8-ch mode
         /* simple rgb led par */            case 18: dmxChannels = new int[3]; dmxChannels[0] = red; dmxChannels[1] = green; dmxChannels[2] = blue; break; //Simple rgb led par
         /* simple rgb led par with dim */   case 19: dmxChannels = new int[4]; dmxChannels[0] = dimmer; dmxChannels[1] = red; dmxChannels[2] = green; dmxChannels[3] = blue; break; //Simple rgb led par with dim
         /* 2ch hazer */                     case 20: dmxChannels = new int[2]; dmxChannels[0] = haze; dmxChannels[1] = fan; break; //2ch hazer
         /* 1ch fog */                       case 21: dmxChannels = new int[1]; dmxChannels[0] = fog; break; //1ch fog
         /* 2ch strobe */                    case 22: dmxChannels = new int[2]; dmxChannels[0] = dimmer; dmxChannels[1] = frequency; break; //2ch strobe
         /* 1ch relay */                     case 23: dmxChannels = new int[1]; if(dimmer > 100) { dmxChannels[0] = 255; } else { dmxChannels[0] = 0; } break; //1ch relay
      }
    return dmxChannels; 
  }
 
    
    //Functions to set right values to object variables
    void dimmer(int value) { dimmer = value; }
    void pan(int value) { pan = value; }
    void tilt(int value) { tilt = value; }
    void panFine(int value) { panFine = value; }
    void tiltFine(int value) { tiltFine = value; }
    void responseSpeed(int value) { if(ftIsMhX50()) { responseSpeed = value; } }
    
    void rainbow(int value) {
      if(ftIsMhX50()) {
        if(value < -5) { colorWheel = round(map(value, 0, -100, 128, 191)); } //Rainbow to negative direction
        else if(value > 5) { colorWheel = round(map(value, 0, 100, 192, 255)); } //Rainbow to positive direction
        else  { colorWheel = 5; } //No rainbow
      }
    }
    
    void noGobo() { if(ftIsMhX50()) { goboWheel = 5; } } //Gobowheel open
    void goboUp() {
      if(ftIsMhX50()) {
        //This void changes gobo to next and counts right value to gobowheel channel
        goboNumber++;
        if(goboNumber >= mhx50_gobo_values.length) {
          goboNumber = 0;
        }
        goboWheel = mhx50_gobo_values[goboNumber];
      }
    }
    void goboDown() {
      if(ftIsMhX50()) {
        //This void changes gobo to previous and counts right value to gobowheel channel
        goboNumber--;
        if(goboNumber < 0) {
          goboNumber = mhx50_gobo_values.length - 1;
        }
        goboWheel = mhx50_gobo_values[goboNumber];
      }
    }
    void goboRainbowUp(int value) { if(ftIsMhX50()) { goboWheel = round(map(value, 0, 100, 128, 191)); } } //This void makes gobowheel rotate positive direction with various speed
    void goboRainbowDown(int value) { if(ftIsMhX50()) { goboWheel = round(map(value, 0, 100, 192, 255)); } } //This void makes gobowheel rotate negative direction with various speed
    
    void goboRotationUp(int value) { if(ftIsMhX50()) { goboRotation = round(map(value, 0, 100, 64, 147)); } }  //This void makes gobo rotate positive direction with various speed
    void goboRotationDown(int value) { if(ftIsMhX50()) { goboRotation = round(map(value, 0, 100, 148, 231)); } } //This void makes gobo rotate negative direction with various speed
    void goboNoRotation() { if(ftIsMhX50()) { goboRotation = 20; } } //This void stops rotating gobo
    void goboBouncing() { if(ftIsMhX50()) { goboRotation = 245; } } //This void makes gobo bouncing
    void autoProgram() {
      if(ftIsMhX50()) {
        //This void counts autoprogram number and sets autoProgram channel to right value
        autoProgramNumber++;
        if(autoProgramNumber >= mhx50_autoProgram_values.length) {
          autoProgramNumber = 0;
        }
        autoPrograms = mhx50_autoProgram_values[autoProgramNumber];
      }
    }
    void prism(int value) { if(ftIsMhX50()) { prism = value; } } //Changes prism value
    void focus(int value) { if(ftIsMhX50()) { focus = value; } } //Changes focus value
    
    void reset(int value) {
      if(ftIsMhX50()) {
        //This void sends reset singnal to moving head
        if(value == 0) { specialFunctions = 0; }
        else { specialFunctions = 154; }
      }
    }
    void blackOut() { if(ftIsMhX50()) { shutter = 1; } } //Blackout with shutter
    void openShutter() { if(ftIsMhX50()) { shutter = 5; } } //Open shutter
    void strobe(int value) { if(ftIsMhX50()) { shutter = round(map(value, 0, 100, 8, 215)); } } //Strobe with shutter
    
    
    
    
    
    
    void setColorValuesFromDmxValue(int a) {
      for(int i = 0; i < mhx50_color_values.length; i++) {
        if((a >= mhx50_color_values[i] - 5) && (a <= mhx50_color_values[i])) {
          setColorNumber(i);
        }
      }
    }
    
    void setColorValues(String address) {
    //This void goes through all the color buttons and gives right color values to mhx50
      for(int i = 0; i < mhx50_color_names.length; i++) {
        if(address != null) {
          if(address.equals("/8/" + mhx50_color_names[i] + str(1))) {
            setColorNumber(i); break; //This is to show right rgb values in visualisation
          }
        }
      }
    }
    
    void setColorNumber(int value) { 
      colorNumber = value; 
      red = mhx50_RGB_color_Values[colorNumber][0];
      green = mhx50_RGB_color_Values[colorNumber][1];
      blue = mhx50_RGB_color_Values[colorNumber][2];
      if(ftIsMhX50()) { colorWheel = mhx50_color_values[colorNumber]; } //Gives right value to moving head color channel
    }
    
    
    
    
    
    //This void set right values to fixtures[] object++
    void createFinalValues() {
      int fogId = 20;
      int hazeId = 21;
       // dimInput[sF] = dimmer;
      if(fT >= 1 && fT <= 6) { fixtures[constrain(sF-1, 0, fixtures.length)].dimmer = dimmer; }
      if(fT == fogId) { fixtures[constrain(sF-1, 0, fixtures.length)].fog = dimmer; }
      if(fT == hazeId) { fixtures[sF].haze = dimmer; fixtures[sF].fan = dimmer; }
      if(ftIsMhX50()) {
        fixtures[constrain(sF-1, 0, fixtures.length)].dimmer = dimmer;
        fixtures[constrain(sF-1, 0, fixtures.length)].pan = pan;
        fixtures[constrain(sF-1, 0, fixtures.length)].tilt = tilt;
        fixtures[constrain(sF-1, 0, fixtures.length)].panFine = panFine;
        fixtures[constrain(sF-1, 0, fixtures.length)].tiltFine = tiltFine;
        fixtures[constrain(sF-1, 0, fixtures.length)].red = red;
        fixtures[constrain(sF-1, 0, fixtures.length)].green = green;
        fixtures[constrain(sF-1, 0, fixtures.length)].blue = blue;
        fixtures[constrain(sF-1, 0, fixtures.length)].goboWheel = goboWheel;
        fixtures[constrain(sF-1, 0, fixtures.length)].goboRotation = goboRotation;
        fixtures[constrain(sF-1, 0, fixtures.length)].colorWheel = colorWheel;
        fixtures[constrain(sF-1, 0, fixtures.length)].specialFunctions = specialFunctions;
        fixtures[constrain(sF-1, 0, fixtures.length)].autoPrograms = autoPrograms;
        fixtures[constrain(sF-1, 0, fixtures.length)].shutter = shutter;
        fixtures[constrain(sF-1, 0, fixtures.length)].prism = prism;
        fixtures[constrain(sF-1, 0, fixtures.length)].focus = focus;
        fixtures[constrain(sF-1, 0, fixtures.length)].responseSpeed = responseSpeed;
      }
    }
    
    boolean ftIsMhX50() { //This function is only to check is the fixtureType moving head (17 or 16)
      return fT == 16 || fT == 17;
    }
    

    void changeSelectedFixtureData(int i, int ij, boolean forward, int steps) {
      setSelectedFixture(i, fixtureInputs[i].selectedFixture + int(map(int(forward), 0, 1, -1, 1))*steps); //If forward is  true then value is positive, else value is negative
      sendDataToIpad("/8/selectedFixture" + str(i + 1), fixtureInputs[i].sF); 
      sendDataToIpad("/saveOptions/selectedFixture", fixtureInputs[ij].sF); 
    }
    void setSelectedFixture(int i, int selF) {
      fixtureInputs[i].selectedFixture = selF;
      fixtureInputs[i].updateVariables(); 
    }
    
    
    
    //This void receives osc data from moving head page which is nowadays used as controller for everything but dimmer channels
 void receiveOSC(int value, int value2, String address) {

            
            createFinalValuesPlease = true; 
            
            if(address.equals("/7/savePreset1") || address.equals("/7/savePreset2")) { savePreset = true; createFinalValuesPlease = false; } 
              //Check all the preset buttons
            for(int ij = 1; ij <= 2; ij++) { //Goes through all the mhx50 fixtures
              for(int i = 0; i <= 15; i++) { //Goes through all the presetbuttons
                if(address.equals("/7/preset" + str(i) + "_" + str(ij))) { //Check if button is pressed
                  if(value == 1) {
                    if(savePreset) { //If savepresed is true then saves presed to presetplace which you clicked
                      for(int ijk = 0; ijk < whatToSave.length; ijk++) { whatToSave[ijk][i] = saveOptionButtonVariableValues[ijk]; }
                      saveFixtureMemory(i);
                      savePreset = false;
                    }
                    else { //Shows preset if you just clicked preset without savePreset or saves2l
                      loadFixtureMemory(i, 255);
                      savePreset = false;
                    }  
                  }
                  createFinalValuesPlease = false; //That's because we don't want to change any dmx values now
                }
              }
            }
            
            
            //The next function checks all the saveSetting buttons. That is to check what values do you want to save and what not.
            if (value == 1) {
              for(int i = 0; i < saveOptionButtonVariables.length; i++) {
                if(address.equals("/saveOptions/" + saveOptionButtonVariables[i] + "Button")) { 
                  saveOptionButtonVariableValues[i] = !saveOptionButtonVariableValues[i]; 
                  sendDataToIpad("/saveOptions/" + saveOptionButtonVariables[i] + "Led", int(saveOptionButtonVariableValues[i])); 
                  createFinalValuesPlease = false; //That's because we don't want to change any dmx values now
                }
              }
            }
    
    
            for(int i = 0; i <= 1; i++) {
              
              
            //Checking selectedFixture change buttons   ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            if((address.equals("/8/selectedFixtureDown" + str(i + 1)) || (address.equals("/saveOptions/selectedFixtureDown")) && i == 0) && value == 1) { 
              changeSelectedFixtureData(i, 0, false, 1);
            }
            if((address.equals("/8/selectedFixtureUp" + str(i + 1))  || (address.equals("/saveOptions/selectedFixtureUp")) && i == 0) && value == 1) { 
              changeSelectedFixtureData(i, 0, true, 1);
            }
            if(address.equals("/saveOptions/selectedFixtureDownTen") && value == 1) { 
              changeSelectedFixtureData(i, 0, false, 10);
            }
            if(address.equals("/saveOptions/selectedFixtureUpTen") && value == 1) { 
              changeSelectedFixtureData(i, 0, true, 10);
            }
            //Checking selectedFixture change buttons  ends --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              
              
            //Checking sliders buttons etc. --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              
            //CH 1: Pan
            if(address.equals("/7/xy" + str(i + 1)) || address.equals("/8/xy" + str(i + 1))) { fixtureInputs[i].pan(value2); } //Changes pan value
            //CH 2: Tilt
            if(address.equals("/7/xy" + str(i + 1)) || address.equals("/8/xy" + str(i + 1))) { fixtureInputs[i].tilt(value); } //Changes tilt value
            //CH 3: Fine adjustment for rotation (pan)
            if(addr.equals("/8/panUp" + str(i + 1)) && value == 1) { fixtureInputs[i].panFine++; }
            if(addr.equals("/8/panDown" + str(i + 1)) && value == 1) { fixtureInputs[i].panFine--; }
            if(addr.equals("/8/tiltUp" + str(i + 1)) && value == 1) { fixtureInputs[i].tiltFine++; }
            if(addr.equals("/8/tiltDown" + str(i + 1)) && value == 1) { fixtureInputs[i].tiltFine--; }
            fixtureInputs[i].responseSpeed(0); //Sets responseSpeed to zero which means the fastest possible
            
            //CH 6: Colour wheel
            fixtureInputs[i].setColorValues(address); //Check color buttons every round
            if(address.equals("/8/rainbow" + str(i + 1))) { fixtureInputs[i].rainbow(value); } //Color rainbow
            
            //CH 7: Shutter
            if(address.equals("/8/blackOut" + str(i + 1)) && value == 1) { fixtureInputs[i].blackOut(); } //Check if blackout is presset
            if(address.equals("/8/openShutter" + str(i + 1)) && value == 1) { fixtureInputs[i].openShutter(); } //Check if open is pressed
            if(address.equals("/8/strobe" + str(i + 1))) { fixtureInputs[i].strobe(value); } //Check if strobe slider is over zero
            
            //CH 8: Mechanical dimmer
            if(address.equals("/7/dimmer" + str(i + 1)) || address.equals("/8/dimmer" + str(i + 1))) { fixtureInputs[i].dimmer(value); } //Changes dimmer value
            
            //CH 9: Gobo wheel
            if(address.equals("/8/noGobo" + str(i + 1)) && value == 1) { fixtureInputs[i].noGobo(); } //Gobowheel open
            if(address.equals("/8/goboUp" + str(i + 1)) && value == 1) { fixtureInputs[i].goboUp(); } //Next gobo
            if(address.equals("/8/goboDown" + str(i + 1)) && value == 1) { fixtureInputs[i].goboDown(); } //Reverse gobo
            if(address.equals("/8/goboRainbowUp" + str(i + 1))) { fixtureInputs[i].goboRainbowUp(value); } //Gobowheel positive rotation
            if(address.equals("/8/goboRainbowDown" + str(i + 1))) { fixtureInputs[i].goboRainbowDown(value); } //Gobowheel negative rotation
            
            //CH 10: Gobo rotation
            if(address.equals("/8/goboRotationUp" + str(i + 1))) { fixtureInputs[i].goboRotationUp(value); } //Gobo positive rotation
            if(address.equals("/8/goboRotationDown" + str(i + 1))) { fixtureInputs[i].goboRotationDown(value); } //Gobo negative rotation
            if(address.equals("/8/goboNoRotation" + str(i + 1)) && value == 1) { fixtureInputs[i].goboNoRotation(); } //No gobo rotation
            if(address.equals("/8/goboBouncing" + str(i + 1)) && value == 1) { fixtureInputs[i].goboBouncing(); } //Gobo bouncing
            
            //CH 11: Special functions
            if(address.equals("/8/reset" + str(i + 1))) { fixtureInputs[i].reset(value); } //Check ig reset button is pressed and resets all the channels in moving head
            
            //CH 12: Built-in programmes
            if(address.equals("/8/autoProgram" + str(i + 1)) && value == 1) { fixtureInputs[i].autoProgram(); } //Next autoProgram
            
            //CH 13: Prism
            if(address.equals("/8/prism" + str(i + 1))) { fixtureInputs[i].prism(value); } //Change prism value
            
            //CH 14: Focus
            if(address.equals("/8/focus" + str(i + 1))) { fixtureInputs[i].focus(value); } //Change focus value
            
            //Checking sliders buttons etc. ends --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            
            if(createFinalValuesPlease) { //Check if pressed some button which needs finalValues creating
              fixtureInputs[i].createFinalValues();
            }
            
            }
  
            
            
         
    }
}

