
class Color {
  int red, green, blue, white;
  Color(int r, int g, int b) {
    red = r;
    green = g;
    blue = b;
  }
  Color(int r, int g, int b, int w) {
    red = r;
    green = g;
    blue = b;
    white = w;
  }
  int getRed() { return red; }
  int getGreen() { return green; }
  int getBlue() { return blue; }
  int getWhite() { return white; }
}


void colorWashSetup() {
  createColorNames();
}

colorWash[] washs = new colorWash[40];
colorWash wash;
void newColorWash() {
   for(int i = 0; i < washs.length; i++) {
     washs[i] = new colorWash("");
     washs[i].clear();
   }
   
}

boolean colorWashMenuOpen = false;
PVector colorMenuOffset = new PVector(0, 0);

int lastClickedColor;

ColorWashMenu colorWashMenu = new ColorWashMenu();

class ColorWashMenu {
  Window window;
  ColorWashMenu() {
    w = 600;
    h = 400;
    locX = 100;
    locY = 100;
    window = new Window("colorSelectBox", new PVector(w, h), this);
  }
  int locX, locY, w, h;
  boolean open;
  void draw(PGraphics g, Mouse mouse, boolean doTranslate) { //Color wash selection menu box
     window.draw(g, mouse);
     g.pushMatrix();
        g.pushStyle();
        g.textAlign(LEFT);
          if(wash == null) { wash = new colorWash(""); } //If wash doesn't exist then create it
          {
            g.stroke(150); //Gray corners
            g.strokeWeight(3); //A bit bolded corners
            g.fill(255, 230); //White transperent background
          }
         
          //Count all the active colorNames (the colorNames object array isn't really good-ordered)
            int[] activeColorNames = new int[colorNames.length];
            int[] activeColorNamesTemp = new int[colorNames.length];
            int n = 0;
            for(int i = 0; i < colorNames.length; i++) {
              if(colorNames[i] != null) {
                activeColorNames[n] = i; //Write down all the existing colorNames
                n++;
              }
            }
            mouse.declareUpdateElementRelative("colorSelectBox", 10000000, 50, 80, n/5*100+200, 5*50+20 ,g); //Declare element for the whole colorSelectBox
            mouse.setElementExpire("colorSelectBox", 2);
            
            
            arrayCopy(activeColorNames, activeColorNamesTemp);
            activeColorNames = new int[n];
            for(int i = 0; i < activeColorNames.length; i++) {
              activeColorNames[i] = activeColorNamesTemp[i];
            }
          //End counting active colorNames
  
       
          g.pushMatrix();
           
              g.translate(80, 0);
              PVector onlySelectedButton = new PVector(50*6-40, 30+50+1*40);
              PVector buttonSize = new PVector(120, 30);
              PVector oddEvenButton = new PVector(50*6-40, 30+50+2*40);
              PVector clearButton = new PVector(50*6-40, 30+50+3*40);
              PVector HSBPickerButton = new PVector(50*6-40, 30+50+4*40);
              PVector textOffset = new PVector(15, 22);
              int buttonCorners = 5;
              
              
              //ONLY SELECTED BUTTON
                mouse.declareUpdateElementRelative("cWB:onlySelected", "colorSelectBox",  round(onlySelectedButton.x), round(onlySelectedButton.y), round(buttonSize.x), round(buttonSize.y) ,g);
                mouse.setElementExpire("cWB:onlyDelected", 2);
                g.pushStyle();
                if(mouse.isCaptured("cWB:onlySelected") && mouse.firstCaptureFrame) { g.stroke(0); wash.onlySelected = !wash.onlySelected; }
                g.rect(round(onlySelectedButton.x), round(onlySelectedButton.y), round(buttonSize.x), round(buttonSize.y), buttonCorners);
                g.fill(0); //Black text
                g.textSize(15); //A bit bigger text than default
                g.textAlign(LEFT);
                if(wash.onlySelected) { g.text("Selected", round(onlySelectedButton.x+textOffset.x), round(onlySelectedButton.y+textOffset.y)); }
                else { g.text("All", round(onlySelectedButton.x+textOffset.x), round(onlySelectedButton.y+textOffset.y)); }
                g.popStyle();
              //END OF ONLY SELECTED BUTTON
             
             
              //ODDEVEN BUTTON
                mouse.declareUpdateElementRelative("cWB:oddEven", "colorSelectBox",  round(oddEvenButton.x), round(oddEvenButton.y), round(buttonSize.x), round(buttonSize.y) ,g);
                mouse.setElementExpire("cWB:oddEven", 2);
                g.pushStyle();
                if(mouse.isCaptured("cWB:oddEven") && mouse.firstCaptureFrame) { g.stroke(0); wash.oddEvenNext(); }
                g.rect(round(oddEvenButton.x), round(oddEvenButton.y), round(buttonSize.x), round(buttonSize.y), buttonCorners);
                g.fill(0); //Black text
                g.textSize(15); //A bit bigger text than default
                String[] OEMS = { "", "Odd", "Even", "All" }; //OddEven mode names
                String OEM = OEMS[wash.oddEvenMode];
                g.text(OEM, round(oddEvenButton.x+textOffset.x), round(oddEvenButton.y+textOffset.y));
                  
            
                g.popStyle();
              //END OF ODDEVEN BUTTON
             
              
              //CLEAR BUTTON
                mouse.declareUpdateElementRelative("cWB:clearAll", "colorSelectBox",  round(clearButton.x), round(clearButton.y), round(buttonSize.x), round(buttonSize.y) ,g);
                mouse.setElementExpire("cWB:clearAll", 2);
                g.pushStyle();
                if(mouse.isCaptured("cWB:clearAll") && mouse.firstCaptureFrame) { g.stroke(0);  clearAllTheWashes(); }
                g.rect(round(clearButton.x), round(clearButton.y), round(buttonSize.x), round(buttonSize.y), buttonCorners);
                g.fill(0); //Black text
                g.textSize(15); //A bit bigger text than default
                g.textAlign(LEFT);
                g.text("Clear all", round(clearButton.x+textOffset.x), round(clearButton.y+textOffset.y));
                g.popStyle();
              //END OF CLEAR BUTTON
               
               
              //COLORPICKER BUTTON
                mouse.declareUpdateElementRelative("cWB:HSBPicker", "colorSelectBox",  round(HSBPickerButton.x), round(HSBPickerButton.y), round(buttonSize.x), round(buttonSize.y) ,g);
                mouse.setElementExpire("cWB:HSBPicker", 2);
                g.pushStyle();
                if(mouse.isCaptured("cWB:HSBPicker") && mouse.firstCaptureFrame) { g.stroke(0); colorPick.open = !colorPick.open; }
                g.rect(round(HSBPickerButton.x), round(HSBPickerButton.y), round(buttonSize.x), round(buttonSize.y), buttonCorners);
                
                  g.fill(0);
                  g.textSize(15);
            
                  g.textAlign(LEFT);
                  if(colorPick.open) { g.text("Close", round(HSBPickerButton.x+textOffset.x), round(HSBPickerButton.y+textOffset.y)); }
                  else { g.text("ColorPicker", round(HSBPickerButton.x+textOffset.x), round(HSBPickerButton.y+textOffset.y)); }
                g.popStyle();
              //END OF COLORPICKER BUTTON
            g.popMatrix();
             
             
             if(colorPick.open) { //Check that should color picker be open
               g.pushStyle(); //Pushstyle to make sure no any styles go out of colorPicker
                 colorPick.colorSelectorOpen = true; //Tell to color picker that it should be open
                 color c = colorPick.getColorFromPicker(); //Get picked color
                 if(colorPick.changed()) { //Check if color values has changed
                   wash.clear(); //Clear old wash
                   wash.setRgb(round(red(c)), round(green(c)), round(blue(c))); //Set rgb color to wash
                   wash.dim = round(brightness(c)); //Set also dim value to wash
                   wash.go(); //Activate wash
                 }
               g.popStyle();
             }
             else { //if color picker should be closed then close it
               colorPick.colorSelectorOpen = false; //Tell to picker that it should be closed
             }
              
              g.pushMatrix();
              g.translate(30, 0);
        
              { //This function is controlling all the color buttons
                  int a = 0;
                  for(int i = 0; i < activeColorNames.length; i++) { //Go through all the activeColorNames
                    for(int j = 0; j < 5; j++) { //Five rows
                      if(i*5+j < activeColorNames.length) {
                        if(colorNames[activeColorNames[i*5+j]] != null) {
                          a++;
                          mouse.declareUpdateElementRelative("cWB:color"+str(i*5+j), "colorSelectBox",  50*i, 30+50+a*40, 40, 30 ,g); //Declare mouse element for color rect
                          mouse.setElementExpire("cWB:color"+str(i*5+j), 2);
                          g.fill(colorNames[activeColorNames[i*5+j]].getRGB()); //Fill rect with right color
                          g.strokeWeight(1); //Strokeweight is 1 by default
                          g.stroke(0); //This is in weird place, because it was the first good place I found quickly
                          if(lastClickedColor == i*5+j) {
                            g.strokeWeight(3);
                          }
                          if(mouse.isCaptured("cWB:color"+str(i*5+j)) && mouse.firstCaptureFrame) {
                            g.strokeWeight(3); //Bolded stroke
                            boolean found = false;
                                wash.clear();
                                wash.setColor(colorNames[activeColorNames[i*5+j]].name); //Set new color to wash
                                wash.dim = 255; //Set also dim value to wash
                                wash.go(); //Activate wash
                                lastClickedColor = i*5+j;
                          }
                          g.rect(50*i, 30+50+a*40, 40, 30, 5); //Draw color rect
                        }
                      }
                    }
                    a = 0;
                  }
             }
             
             g.popMatrix();
                
            
        g.popStyle();
     g.popMatrix();
  } //End of color wash selection box
}

void clearAllTheWashes() {
  //Check allways that we are not trying to call null elements to avoid nullPointers
  //Clear all the existing washes
  for(int i = 0; i < washs.length; i++) {
    if(washs[i] != null) { washs[i].clear(); }
  }
  if(wash != null) { wash.clear(); }
}

class colorWash {
  //TODO: clear should set all the lamps to values where they was before colorwash
  //TODO: rgbw values should be converted to rgb values if we are using rgb lamps
  
  int red, green, blue, white, dim;
  int[] rgb = new int[3];
  int[] rgbw = new int[4];
  int[] rgbwd = new int[5];
  
  boolean useHalogens = true;
  boolean useLeds = true;
  boolean onlySelected = false;
  boolean onlyList = false;
  int[] selectedFixtures;
  boolean disableByType;
  int[] disabledTypes;
  
  boolean odd = true;
  boolean even = true;
  boolean pairless;
  
  int oddEvenMode = 1;
  
  int accuracy = 5;
  
  boolean ready = true;
  
  colorWash(String colour) {
    setRgbwd(getColorFromName(colour));
  }
  
  void setColor(String colour) {
    setRgbwd(getColorFromName(colour));
  }
  
  void setRgb(int r, int g, int b) {
    red = r;
    green = g;
    blue = b;
  }
  void setRgbw(int r, int g, int b, int w) {
    setRgb(r, g, b);
    white = w;
  }
  void setRgbwd(int r, int g, int b, int w, int d) {
    setRgbw(r, g, b, w);
    dim = d;
  }
  void setRgb(int[] c) {
    if(c.length == 3) { setRgb(c[0], c[1], c[2]); }
  }
  void setRgbw(int[] c) {
    if(c.length == 4) { setRgbw(c[0], c[1], c[2], c[3]); }
  }
  void setRgbwd(int[] c) {
    if(c.length == 5) { setRgbwd(c[0], c[1], c[2], c[3], c[4]); }
  }
  
  void setHsb(int h, int s, int b) {
    int[] colors = new int[3];
    colors[0] = h;
    colors[1] = s;
    colors[2] = b;
    setRgbwd(colorConverter.convertColor(colors, 2, 4));
  }
  
  colorWash(int r, int g, int b) {
    setRgbwd(r, g, b, 0, 255);
  }
  
  colorWash(int r, int g, int b, int w) {
    setRgbwd(r, g, b, w, 255);
  }
  
  colorWash(int r, int g, int b, int w, int d) {
    setRgbwd(r, g, b, w, d);
  }
  
  colorWash(int h, int s, int b, String mode) {
    setHsb(h, s, b);
  }
  
  void onlyHalogens() { useLeds = false; useHalogens = true; }
  void onlyLeds() { useLeds = true; useHalogens = false; }
  void noHalogens() { useHalogens = false; }
  void noLeds() { useLeds = false; }
  void useHalogens() { useHalogens = true; }
  void useLeds() { useLeds = true; }
  void useOnlySelected() { onlySelected = true; }
  void useAll() { useHalogens(); useLeds(); onlySelected = false; onlyList = false; disableByType = false; oddAndEven(); }
  void useOnlyList() { onlyList = true; }
  void setList(int[] list) { selectedFixtures = new int[list.length]; arrayCopy(list, selectedFixtures); }
  void setDisabledTypes(int[] list) { disabledTypes = new int[list.length]; arrayCopy(list, disabledTypes); }
  void useDisabledTypes() { disableByType = true; }
  void noDisabledTypes() { disableByType = false; }
  void odd() { odd = true; even = false; }
  void even() { odd = false; even = true; }
  void oddAndEven() { odd = true; even = true; }
  void setAccuracy(int a) { accuracy = a; }
  void oddEvenNext() {
    oddEvenMode = getNext(oddEvenMode, 1, 3);
    if(oddEvenMode == 1) { odd(); }
    if(oddEvenMode == 2) { even(); }
    if(oddEvenMode == 3) { oddAndEven(); }
  }
  boolean isReady() { return ready; }
  
  
  void go() { //Activate colorWash
    if(useLeds) { setColorToLeds(255); } //If useLeds is true then we set right colors to them
    if(useHalogens) { setColorToHalogens(255); } //If useHalogens is true then we put them on if they are right-colored
    ready = false;
  }
    
  void clear() { //Clear colorWash
    if(useLeds) { setColorToLeds(0); } //If useLeds is true then we turn off them
    if(useHalogens) { setColorToHalogens(0); } //If useHalogens is true then we turn off them
    ready = true;
  }
  
  void setColorToLeds(int val) { //Set right colors to leds
    for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) { //Go through all the fixtures
      fixture fix = entry.getValue();
      int i = entry.getKey();
      
      if(fix != null) { //Check that fixture exist
        //If onlySelected or onlyList is true then we have to check is fixture selected or in list
        if((!onlySelected && !onlyList) || fix.selected || isInList(i, selectedFixtures)) {
          if(thisFixtureUseRgb(i)) { //Check that does this fixture use rgb
            fix.in.setUniversalDMX(DMX_RED, rMap(red, 0, 255, 0, val)); //Set red value
            fix.in.setUniversalDMX(DMX_GREEN, rMap(green, 0, 255, 0, val)); //Set green value
            fix.in.setUniversalDMX(DMX_BLUE, rMap(blue, 0, 255, 0, val)); //Set blue value
            if(thisFixtureUseWhite(i)) { //Check that does this fixture use also white
              fix.in.setUniversalDMX(DMX_WHITE, rMap(white, 0, 255, 0, val)); //set white value
            } //End of white check
            if(thisFixtureUseDim(i)) { //Check that does this fixture use also dimmer
              fix.in.setUniversalDMX(DMX_DIMMER, rMap(dim, 0, 255, 0, val)); //Set dimmer value
            } //End of dimmer check
            fix.DMXChanged = true; //Tell to fixture class that DMX has changed
          } //End of rgb check
        } //End of checking will we use this fixture
      } //End of null-check
    } //End of for loop
  }  //End of void setColorToLeds

  
  void setColorToHalogens(int val) { //Put halogens on if they are right-colored
    for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) { //Go through all the fixtures
      fixture fix = entry.getValue();
      int i = entry.getKey();
      
      if(fix != null) { //Check that fixture exist
        //First we have check is the fixture halogen when we can only change it's dimmer
        if(fix.isHalogen()) {
          //If onlySelected or onlyList is true then we have to check is fixture selected or in list
          if(useThisFixture(i)) {
            color c = fix.getColor();
            float r = red(c);
            float g = green(c);
            float b = blue(c);
            if(isAbout(r, red, accuracy) && isAbout(g, green, accuracy) && isAbout(b, blue, accuracy)) { //Check that halogen's colour (foil) is about same colour than selected wash colour
              fix.setDimmer(val); //Put halogen on if it's right-coloured
            } //End of checking is the colour of this fixture right
          } //End of checking will we use this fixture
        } //End of halogen-check
      } //End of null-check
    } //End of for loop
  } //End void of setColorToHalogens
  
  
  
  //Inside colorWash class
    int fT(int i) {
      return fixtures.get(i).fixtureTypeId;
    }
    boolean fixtureIsSelected(int i) {
      return fixtures.get(i).selected;
    }
    boolean thisFixtureUseRgb(int i) {
      return fixtures.get(i).thisFixtureUseRgb();
    }
    boolean thisFixtureUseDim(int i) {
      return fixtures.get(i).thisFixtureUseDim();
    }
    boolean thisFixtureUseWhite(int i) {
      return fixtures.get(i).thisFixtureUseWhite();
    }
    
    boolean useThisFixture(int i) {
      pairless = !pairless;
      return (!onlySelected || fixtureIsSelected(i)) && (!onlyList || isInList(i, selectedFixtures)) && (!disableByType || !isInList(fT(i), disabledTypes)) && ((odd && !pairless) || (even && pairless));
    }
  
  
  void makeColorArrays() {
    rgb[0] = red;
    rgb[1] = green;
    rgb[2] = blue;
    arrayCopy(rgb, rgbw);
    rgbw[3] = white;
    arrayCopy(rgbw, rgbwd);
    rgbwd[4] = dim;
  }
  
}

//Colorname class is only to call colors with their names
colorName[] colorNames = new colorName[30];
void createColorNames() {
  colorNames[0] = new colorName("red", 255, 0, 0);
  colorNames[1] = new colorName("green", 0, 255, 0);
  colorNames[2] = new colorName("blue", 0, 0, 255);
  colorNames[3] = new colorName("yellow", 255, 255, 0);
  colorNames[4] = new colorName("cyan", 0, 255, 255);
  colorNames[5] = new colorName("lila", 255, 0, 255);
  colorNames[6] = new colorName("pink", 255, 0, 100);
  colorNames[7] = new colorName("orange", 255, 100, 0);
  
  colorNames[10] = new colorName("lightRed", 255, 0, 0, 255);
  colorNames[11] = new colorName("lightGreen", 0, 255, 0, 255);
  colorNames[12] = new colorName("lightBlue", 0, 0, 255, 255);
  colorNames[13] = new colorName("lightYellow", 255, 255, 0, 255);
  colorNames[14] = new colorName("lightCyan", 0, 255, 255, 255);
  colorNames[15] = new colorName("lightLila", 255, 0, 255, 255);
  colorNames[16] = new colorName("lightPink", 255, 0, 100, 255);
  colorNames[17] = new colorName("lightOrange", 255, 100, 0, 255);
  
  colorNames[20] = new colorName("amber", 100, 50, 0, 255); //Amber color for rgbw led
  colorNames[21] = new colorName("white", 255, 255, 255, 255); //The brightes possible white for rgbw leds
  colorNames[22] = new colorName("clearWhite", 0, 0, 0, 255); //The clearest possible white for rgbw leds
  colorNames[23] = new colorName("coldWhite", 0, 50, 100, 255);
  colorNames[24] = new colorName("hotWhite", 100, 0, 0, 255);
  
  colorNames[25] = new colorName("halogen", 255, 255, 180); //Normal halogen without any colour foil
}

int[] getColorFromName(String colour) {
  int[] toReturn = new int[5];
    for(int i = 0; i < colorNames.length; i++) {
      if(colorNames[i] != null) {
        if(colorNames[i].name.equals(colour)) {
          toReturn[0] = colorNames[i].red;
          toReturn[1] = colorNames[i].green;
          toReturn[2] = colorNames[i].blue;
          toReturn[3] = colorNames[i].white;
          toReturn[4] = colorNames[i].dim;
        }
      }
    }
    return toReturn;
}

color getRGBfromName(String colour) {
  color toReturn = color(0, 0, 0);
    for(int i = 0; i < colorNames.length; i++) {
      if(colorNames[i] != null) {
        if(colorNames[i].name.equals(colour)) {
          toReturn = color(colorNames[i].red, colorNames[i].green, colorNames[i].blue);
        }
      }
    }
    return toReturn;
}

class colorName {
  String name;
  int red, green, blue, white, dim;
  int colorMode;
  
  colorName(String colour, int r, int g, int b) {
    name = colour;
    red = r;
    green = g;
    blue = b;
    white = 0;
    dim = 255;
    colorMode = 1;
  }
  
  colorName(String colour, int r, int g, int b, int w) {
    name = colour;
    red = r;
    green = g;
    blue = b;
    white = w;
    dim = 255;
    colorMode = 3;
  }
  
  boolean convertedToRGB = false;
  
  color rgb = color(0, 0, 0);
  
  color getRGB() {
    if(!convertedToRGB) {
      if(colorMode == 3) {
        if(white > 0) {
          int[] rgbVals = new int[3];
          arrayCopy(colorConverter.convertColor(toArray(red, green, blue, white), 3, 1), rgbVals);
          rgb = color(rgbVals[0], rgbVals[1], rgbVals[2]);
        }
        else {
          rgb = color(red, green, blue);
        }
      }
      if(colorMode == 1) {
        rgb = color(red, green, blue);
      }
      convertedToRGB = true;
    }
    return rgb;
  }
  
  
}


ColorConverter colorConverter = new ColorConverter();

class ColorConverter {
  ColorConverter() {
  }
  int[] convertColor(int[] original, int from, int to) {
    //original array: { r, g, b, w, d } or { h, s, b }
    //from & to: 1 = rgb, 2 = hsb, 3 = rgbw, 4 = rgbwd, 5 = rgbd
    int[] toReturn = { 0, 0, 0 };
        if(from == 1) { //rgb
            colorMode(RGB);
              if(to == 1) { //rgb
                toReturn = new int[3];
                arrayCopy(original, toReturn);
              }
              if(to == 2) { //hsb
                toReturn = new int[3];
                color c = color(original[0], original[1], original[2]);
                toReturn[0] = round(hue(c));
                toReturn[1] = round(saturation(c));
                toReturn[2] = round(brightness(c));
              }
              else if(to == 3) { //rgbw
                color c = color(original[0], original[1], original[2]);
                toReturn = new int[4];
                toReturn[0] = original[0];
                toReturn[1] = original[1];
                toReturn[2] = original[2];
                toReturn[3] = (original[0] + original[1] + original[2]) / 3;
              }
              else if(to == 4) { //rgbwd
                color c = color(original[0], original[1], original[2]);
                toReturn = new int[4];
                toReturn[0] = original[0];
                toReturn[1] = original[1];
                toReturn[2] = original[2];
                toReturn[3] = (original[0] + original[1] + original[2]) / 3;
                toReturn[4] = 255;
              }
              else if(to == 5) { //rgbd
                color c = color(original[0], original[1], original[2]);
                toReturn = new int[4];
                toReturn[0] = original[0];
                toReturn[1] = original[1];
                toReturn[2] = original[2];
                toReturn[3] = 255;
              }
              else if(to == 6) { //cmyk
                color c = color(original[0], original[1], original[2]);
                CMYK_Colour cmyk = new CMYK_Colour(c);
                toReturn = new int[4];
                toReturn[0] = round(cmyk.cyan);
                toReturn[1] = round(cmyk.magenta);
                toReturn[2] = round(cmyk.yellow);
                toReturn[3] = round(cmyk.black);
              }
        }
        else if(from == 2) { //hsb
            colorMode(HSB);
              if(to == 1) { //rgb
                color c = color(original[0], original[1], original[2]);
                toReturn = new int[3];
                toReturn[0] = round(red(c));
                toReturn[1] = round(green(c));
                toReturn[2] = round(blue(c));
              }
              else if(to == 2) { //hsb
                toReturn = new int[3];
                arrayCopy(original, toReturn);
              }
              else if(to == 3) { //rgbw
                toReturn = new int[4];
                arrayCopy(convertColor(convertColor(original, 2, 1), 1, 3), toReturn);
              }
              else if(to == 4) { //rgbwd
                toReturn = new int[5];
                arrayCopy(convertColor(convertColor(original, 2, 1), 1, 4), toReturn);
              }
              else if(to == 5) { //rgbd
                toReturn = new int[4];
                arrayCopy(convertColor(convertColor(original, 2, 1), 1, 5), toReturn);
              }
              else if(to == 6) { //cmyk
                toReturn = new int[4];
                arrayCopy(convertColor(convertColor(original, 2, 1), 1, 6), toReturn);
              }
           colorMode(RGB);
        }
        else if(from == 3) { //rgbw
            colorMode(RGB);
              if(to == 1) { //rgb
                color c = color(original[0], original[1], original[2]);
                int white = original[3];
                toReturn = new int[3];
                toReturn[0] = round(red(c) + white/1.5);
                toReturn[1] = round(green(c) + white/1.5);
                toReturn[2] = round(blue(c) + white/1.5);
                
                toReturn[0] = round(map(toReturn[0], 0, max(toReturn), 0, max(original)));
                toReturn[1] = round(map(toReturn[1], 0, max(toReturn), 0, max(original)));
                toReturn[2] = round(map(toReturn[2], 0, max(toReturn), 0, max(original)));
              }
              else if(to == 2) { //hsb
                toReturn = new int[3];
                arrayCopy(convertColor(convertColor(original, 3, 1), 1, 2), toReturn);
              }
              else if(to == 3) { //rgbw
                toReturn = new int[4];
                arrayCopy(original, toReturn);
              }
              else if(to == 4) { //rgbwd
                toReturn = new int[5];
                arrayCopy(original, toReturn); //rgbw values
                toReturn[4] = 255; //dimmer
              }
              else if(to == 5) {
                toReturn = new int[4];
                arrayCopy(convertColor(original, 3, 1), toReturn); //rgb values
                toReturn[3] = 255; //dimmer
              }
              else if(to == 6) { //cmyk
                toReturn = new int[4];
                arrayCopy(convertColor(convertColor(original, 3, 1), 1, 6), toReturn);
              }
        }
        else if(from == 4) { //rgbwd
            colorMode(RGB);
            color c = color(original[0], original[1], original[2]);
            int dim = original[4];
            int white = original[3];
            if(to == 1) { //rgb
              toReturn = new int[3];
              arrayCopy(convertColor(original, 3, 1), toReturn);
              color co = color(toReturn[0], toReturn[1], toReturn[2]);
              toReturn[0] = rMap(round(red(co)), 0, 255, 0, dim);
              toReturn[1] = rMap(round(green(co)), 0, 255, 0, dim);
              toReturn[2] = rMap(round(blue(co)), 0, 255, 0, dim);
              
            }
            else if(to == 2) { //hsb
              toReturn = new int[3];
              toReturn[0] = round(hue(c));
              toReturn[1] = round((saturation(c) + getInvertedValue(white, 0, 255)) / 2);
              toReturn[2] = round((brightness(c)*2 + white) / 3);
            }
            else if(to == 3) { //rgbw
              toReturn = new int[4];
              toReturn[0] = rMap(round(red(c)), 0, 255, 0, dim);
              toReturn[1] = rMap(round(green(c)), 0, 255, 0, dim);
              toReturn[2] = rMap(round(blue(c)), 0, 255, 0, dim);
              toReturn[3] = rMap(white, 0, 255, 0, dim);
            }
            else if(to == 4) { //rgbwd
              toReturn = new int[5];
              arrayCopy(original, toReturn);
            }
            else if(to == 5) { //rgbd
              toReturn = new int[4];
              arrayCopy(convertColor(original, 4, 1), toReturn);
              toReturn[3] = original[4];
            }
            else if(to == 6) { //cmyk
                toReturn = new int[4];
                arrayCopy(convertColor(convertColor(original, 4, 1), 1, 6), toReturn);
              }
            
        }
        else if(from == 5) { //rgbd
            colorMode(RGB);
              color c = color(original[0], original[1], original[2]);
              int dim = original[3];
              if(to == 1) { //rgb
                //When we conver RGBD to RGB we only have to map all the RGB values with dim value
                toReturn = new int[3];
                toReturn[0] = rMap(round(red(c)), 0, 255, 0, dim);
                toReturn[1] = rMap(round(green(c)), 0, 255, 0, dim);
                toReturn[2] = rMap(round(blue(c)), 0, 255, 0, dim);
              }
              else if(to == 2) { //hsb
                //When converting RGBD to HSB we have to take HSB values with hue(), saturation() and brightness functions
                //We also have to take account of dim value
                toReturn = new int[3];
                toReturn[0] = round(hue(c));
                toReturn[1] = round(saturation(c));
                toReturn[2] = round(min(brightness(c), dim));
              }
              else if(to == 3) { //rgbw
                //When converting RGBD to RGBW we will first convert the RGB part to RGBW and then map all the values with dim
                toReturn = new int[4];
                arrayCopy(convertColor(original, 1, 3), toReturn);
                for(int i = 0; i < toReturn.length; i++) {
                  toReturn[i] = rMap(toReturn[i], 0, 255, 0, dim);
                }
              }
              else if(to == 4) { //rgbwd
                //When converting rgbd to rgbwd we will convert only RGB part to RGBW and then add dim to end
                toReturn = new int[5];
                arrayCopy(convertColor(original, 1, 3), toReturn);
                toReturn[4] = dim;
              }
              else if(to == 5) { //rgbd
                //RGBD to RGBD doesn't need any convertion so we can copy the original array to return array
                toReturn = new int[4];
                arrayCopy(original, toReturn);
              }
              else if(to == 6) { //cmyk
                toReturn = new int[4];
                arrayCopy(convertColor(convertColor(original, 5, 1), 1, 6), toReturn);
              }
        }
    return toReturn;
  }
} //End of class ColorConverter




//Got from https://processing.org/discourse/beta/num_1228243376.html
//USAGE
/*
  colorMode(RGB, 255);
  color swatch = color(255,0,255);
  CMYK_Colour cmyk_swatch = new CMYK_Colour(swatch);
  //output CMYK values (these are floats)
  println("CYAN: " + cmyk_swatch.cyan);
  println("MAGENTA: " + cmyk_swatch.magenta);
  println("YELLOW: " + cmyk_swatch.yellow);
  println("BLACK: " + cmyk_swatch.black);
*/

class CMYK_Colour {
  
  //fields
  float cyan, magenta, yellow, black;
  
  //constructor - requires colorMode(RGB,255) is set
  CMYK_Colour(color c) {
    //convert to CMY
    cyan = 255 - red(c);
    magenta = 255 - green(c);
    yellow = 255 - blue(c);
    
    //convert to CMYK
    black = 255;
    if (cyan < black) { black = cyan; }
    if (magenta < black) { black = magenta; }
    if (yellow < black) { black = yellow; }
    
    cyan = ( cyan - black ) / ( 255 - black );
    magenta = ( magenta - black ) / ( 255 - black );
    yellow = ( yellow - black ) / ( 255 - black );
  }
}
