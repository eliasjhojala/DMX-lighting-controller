int selectedFixture;

class fixtureInput {
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int rotationX, rotationZ;
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values
 
  int sF = selectedFixture;
  int fT = fixtures[sF].fixtureTypeId;
  
  int[][] mhx50_RGB_color_Values = { { 255, 255, 255 }, { 255, 255, 0 }, { 255, 100, 255 }, { 0, 100, 0 }, { 255, 0, 255 }, { 0, 0, 255 }, { 0, 255, 0 }, { 255, 30, 0 }, { 0, 0, 100 } };
  int[] mhx50_color_values = { 5, 12, 19, 26, 33, 40, 47, 54, 62 }; //white, yellow, lightpink, green, darkpink, lightblue, lightgreen, red, dark blue
  String[] mhx50_color_names = { "white", "yellow", "lightpink", "green", "darkpink", "lightblue", "lightgreen", "red", "blue" };
  
  int[] mhx50_gobo_values = { 6, 14, 22, 30, 38, 46, 54, 62 };
  
  int[] mhx50_autoProgram_values = { 6, 22, 6, 38, 6, 54, 6, 70, 6, 86, 6, 102, 6, 118, 6, 134, 6, 150, 6, 166, 6, 182, 6, 198, 6, 214, 6, 230, 6, 247, 6, 254 };
  
  int goboNumber;
  int autoProgramNumber;
  int colorNumber;

  

  void receiveOSC(int value, int value2, String address) {
        
            //CH 1: Pan
            if(address.equals("/7/xy" + str(1)) || address.equals("/8/xy" + str(1))) { pan(value2); } //Changes pan value
            //CH 2: Tilt
            if(address.equals("/7/xy" + str(1)) || address.equals("/8/xy" + str(1))) { tilt(value); } //Changes tilt value
            //CH 3: Fine adjustment for rotation (pan)
            panFine(0); //Sets panFine value to zero
            //CH 4: Fine adjustment for inclination (tilt)
            tiltFine(0); //Sets tiltFine value to zero
            //CH 5: Response speed
            responseSpeed(0); //Sets responseSpeed to zero which means the fastest possible
            
            //CH 6: Colour wheel
            setColorValues(address); //Check color buttons every round
            if(address.equals("/8/rainbow" + str(1))) { rainbow(value); } //Color rainbow
            
            //CH 7: Shutter
            if(address.equals("/8/blackOut" + str(1)) && value == 1) { blackOut(); } //Check if blackout is presset
            if(address.equals("/8/openShutter" + str(1)) && value == 1) { openShutter(); } //Check if open is pressed
            if(address.equals("/8/strobe" + str(1))) { strobe(value); } //Check if strobe slider is over zero
            
            //CH 8: Mechanical dimmer
            if(address.equals("/7/dimmer" + str(1)) || address.equals("/8/dimmer" + str(1))) { dimmer(value); } //Changes dimmer value
            
            //CH 9: Gobo wheel
            if(address.equals("/8/noGobo" + str(1)) && value == 1) { noGobo(); } //Gobowheel open
            if(address.equals("/8/goboUp" + str(1)) && value == 1) { goboUp(); } //Next gobo
            if(address.equals("/8/goboDown" + str(1)) && value == 1) { goboDown(); } //Reverse gobo
            if(address.equals("/8/goboRainbowUp" + str(1))) { goboRainbowUp(value); } //Gobowheel positive rotation
            if(address.equals("/8/goboRainbowDown" + str(1))) { goboRainbowDown(value); } //Gobowheel negative rotation
            
            //CH 10: Gobo rotation
            if(address.equals("/8/goboRotationUp" + str(1))) { goboRotationUp(value); } //Gobo positive rotation
            if(address.equals("/8/goboRotationDown" + str(1))) { goboRotationDown(value); } //Gobo negative rotation
            if(address.equals("/8/goboNoRotation" + str(1)) && value == 1) { goboNoRotation(); } //No gobo rotation
            if(address.equals("/8/goboBouncing" + str(1)) && value == 1) { goboBouncing(); } //Gobo bouncing
            
            //CH 11: Special functions
            if(address.equals("/8/reset" + str(1))) { reset(value); } //Check ig reset button is pressed and resets all the channels in moving head
            
            //CH 12: Built-in programmes
            if(address.equals("/8/autoProgram" + str(1)) && value == 1) { autoProgram(); } //Next autoProgram
            
            //CH 13: Prism
            if(address.equals("/8/prism" + str(1))) { prism(value); } //Change prism value
            
            //CH 14: Focus
            if(address.equals("/8/focus" + str(1))) { focus(value); } //Change focus value
    }
    
    
    void dimmer(int value) { dimmer = dimmer; }
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
    
    
    
    
    
    void createFinalValues() {
      int fogId = 20;
      int hazeId = 21;
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
    
    boolean ftIsMhX50() {
      return fT == 16 || fT == 17;
    }
}
