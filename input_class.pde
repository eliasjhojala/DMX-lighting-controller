


class fixtureInput {
  int selectedFixture;
  //Define all the variables
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int rotationX, rotationZ;
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
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
    
    
    
    
    
    
    void setColorValues(String address) {
    //This void goes through all the color buttons and gives right color values to mhx50
      for(int i = 0; i < mhx50_color_names.length; i++) {
        if(address != null) {
          if(address.equals("/8/" + mhx50_color_names[i] + str(1))) {
            colorNumber = i; break; //This is to show right rgb values in visualisation
          }
        }
      }
      red = mhx50_RGB_color_Values[colorNumber][0];
      green = mhx50_RGB_color_Values[colorNumber][1];
      blue = mhx50_RGB_color_Values[colorNumber][2];
      
      if(ftIsMhX50()) { colorWheel = mhx50_color_values[colorNumber]; } //Gives right value to moving head color channel
    }
    
    
    
    
    
    //This void set right values to fixtures[] object++
    void createFinalValues() {
      int fogId = 20;
      int hazeId = 21;
        dimInput[sF+1] = dimmer;
      if(fT >= 1 && fT <= 6) { fixtures[sF].dimmer = dimmer; }
      if(fT == fogId) { fixtures[sF].fog = dimmer; }
      if(fT == hazeId) { fixtures[sF].haze = dimmer; fixtures[sF].fan = dimmer; }
      if(ftIsMhX50()) {
        fixtures[sF].dimmer = dimmer;
        fixtures[sF].pan = pan;
        fixtures[sF].tilt = tilt;
        fixtures[sF].panFine = panFine;
        fixtures[sF].tiltFine = tiltFine;
        fixtures[sF].red = red;
        fixtures[sF].green = green;
        fixtures[sF].blue = blue;
        fixtures[sF].goboWheel = goboWheel;
        fixtures[sF].goboRotation = goboRotation;
        fixtures[sF].colorWheel = colorWheel;
        fixtures[sF].specialFunctions = specialFunctions;
        fixtures[sF].autoPrograms = autoPrograms;
        fixtures[sF].shutter = shutter;
        fixtures[sF].prism = prism;
        fixtures[sF].focus = focus;
        fixtures[sF].responseSpeed = responseSpeed;
      }
    }
    
    boolean ftIsMhX50() { //This function is only to check is the fixtureType moving head (17 or 16)
      return fT == 16 || fT == 17;
    }
}


//This void receives osc data from moving head page which is nowadays used as controller for everything but dimmer channels
 void receiveOSC(int value, int value2, String address) {
        
            
    
    
            for(int i = 0; i <= 1; i++) {
              
              
            if(address.equals("/8/selectedFixtureDown" + str(i + 1)) && value == 1) { fixtureInputs[i].selectedFixture--; fixtureInputs[i].updateVariables(); sendDataToIpad("/8/selectedFixture" + str(i + 1), fixtureInputs[i].selectedFixture); }
            if(address.equals("/8/selectedFixtureUp" + str(i + 1)) && value == 1) { fixtureInputs[i].selectedFixture++; fixtureInputs[i].updateVariables(); sendDataToIpad("/8/selectedFixture" + str(i + 1), fixtureInputs[i].selectedFixture); }
              
              
            //CH 1: Pan
            if(address.equals("/7/xy" + str(i + 1)) || address.equals("/8/xy" + str(i + 1))) { fixtureInputs[i].pan(value2); } //Changes pan value
            //CH 2: Tilt
            if(address.equals("/7/xy" + str(i + 1)) || address.equals("/8/xy" + str(i + 1))) { fixtureInputs[i].tilt(value); } //Changes tilt value
            //CH 3: Fine adjustment for rotation (pan)
            fixtureInputs[i].panFine(0); //Sets panFine value to zero
            //CH 4: Fine adjustment for inclination (tilt)
            fixtureInputs[i].tiltFine(0); //Sets tiltFine value to zero
            //CH 5: Response speed
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
            
            fixtureInputs[i].createFinalValues();
            
            }
            
    }
