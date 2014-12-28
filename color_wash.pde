void colorWashSetup() {
  createColorNames();
}
void newColorWash() {
   colorWash wash = new colorWash("red");
   wash.go();
}

class colorWash {
  int red, green, blue, white, dim;
  int[] rgb = new int[3];
  int[] rgbw = new int[4];
  int[] rgbwd = new int[5];
  
  boolean useHalogens = true;
  boolean useLeds = true;
  boolean onlySelected = false;
  boolean onlyList = false;
  int[] selectedFixtures;
  
  colorWash(String colour) {
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
    setRgbwd(convertColor(colors, 2, 4));
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
  void useAll() { useLeds = true; useHalogens = true; onlySelected = false; onlyList = false; }
  void useOnlyList() { onlyList = true; }
  void setList(int[] list) { selectedFixtures = new int[list.length]; arrayCopy(list, selectedFixtures); }
  
  void go() {
    if(useLeds) { setColorToLeds(255); }
    if(useHalogens) { setColorToHalogens(255); }
  }
  

  
  void setColorToLeds(int val) {
    for(int i = 0; i < fixtures.length; i++) {
      if(fixtures[i] != null) {
        if((!onlySelected && !onlyList) || fixtures[i].selected || isInList(i, selectedFixtures)) {
          if(fixtureUseRgb(i)) {
            fixtures[i].red = rMap(red, 0, 255, 0, val);
            fixtures[i].green = rMap(green, 0, 255, 0, val);
            fixtures[i].blue = rMap(blue, 0, 255, 0, val);
            if(fixtureUseWhite(i)) {
              fixtures[i].white = rMap(white, 0, 255, 0, val);
            }
            if(fixtureUseDim(i)) {
              fixtures[i].dimmer = rMap(dim, 0, 255, 0, val);
            }
            fixtures[i].DMXChanged = true;
          }
        }
      }
    }
  } 
  
  void clear() {
    if(useLeds) { setColorToLeds(0); }
    if(useHalogens) { setColorToHalogens(0); }
  }
  
  void setColorToHalogens(int val) {
    for(int i = 0; i < fixtures.length; i++) {
      if(fixtures[i] != null) {
        if(fixtures[i].isHalogen()) {
          if((!onlySelected && !onlyList) || fixtures[i].selected || isInList(i, selectedFixtures)) {
            int r = fixtures[i].red;
            int g = fixtures[i].green;
            int b = fixtures[i].blue;
            if(isAbout(r, red) && isAbout(g, green) && isAbout(b, blue)) {
              fixtures[i].setDimmer(val);
            }
          }
        }
      }
    }
  }
  
    boolean fixtureUseRgb(int i) {
      int fT = fixtures[i].fixtureTypeId;
      return fT == 24 || fT == 25 || fT == 18 || fT == 19;
    }
    boolean fixtureUseDim(int i) {
      int fT = fixtures[i].fixtureTypeId;
      return fT == 25 || fT == 19;
    }
    boolean fixtureUseWhite(int i) {
      int fT = fixtures[i].fixtureTypeId;
      return fT == 25 || fT == 24;
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
  
  colorNames[20] = new colorName("amber", 100, 50, 0, 255);
  colorNames[21] = new colorName("white", 255, 255, 255, 255);
  colorNames[22] = new colorName("clearWhite", 0, 0, 0, 255);
  colorNames[23] = new colorName("coldWhite", 0, 50, 100, 255);
  colorNames[24] = new colorName("hotWhite", 100, 0, 0, 255);
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

class colorName {
  String name;
  int red, green, blue, white, dim;
  
  colorName(String colour, int r, int g, int b) {
    name = colour;
    red = r;
    green = g;
    blue = b;
    white = 0;
    dim = 255;
  }
  
  colorName(String colour, int r, int g, int b, int w) {
    name = colour;
    red = r;
    green = g;
    blue = b;
    white = w;
    dim = 255;
  }
  
  
}

int[] convertColor(int[] original, int from, int to) {
  //original array: { r, g, b, w, d } or { h, s, b } or
  //from & to: 1 = rgb, 2 = hsb, 3 = rgbw, 4 = rgbwd, 5 = rgbd
  int[] toReturn = { 0, 0, 0 };
  pushStyle(); //we use colorModes in this function so make sure they don't affect to other parts of the software
      if(from == 1) { //rgb
        pushStyle();
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
          popStyle();
      }
      else if(from == 2) { //hsb
        pushStyle();
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
        popStyle();
      }
      else if(from == 3) { //rgbw
        pushStyle();
          colorMode(RGB);
            if(to == 1) { //rgb
              color c = color(original[0], original[1], original[2]);
              int white = toReturn[4];
              toReturn = new int[3];
              toReturn[1] = round(red(c) + white/3);
              toReturn[2] = round(green(c) + white/3); 
              toReturn[3] = round(blue(c) + white/3); 
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
        popStyle();
      }
      else if(from == 4) { //rgbwd
        pushStyle();
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
          
        popStyle();
      }
      else if(from == 5) { //rgbd
        pushStyle();
          colorMode(RGB);
            color c = color(original[0], original[1], original[2]);
            int dim = original[3];
            if(to == 1) { //rgb
              toReturn = new int[3];
              toReturn[0] = rMap(round(red(c)), 0, 255, 0, dim);
              toReturn[1] = rMap(round(green(c)), 0, 255, 0, dim);
              toReturn[2] = rMap(round(blue(c)), 0, 255, 0, dim);
            }
            else if(to == 2) { //hsb
              toReturn = new int[3];
              toReturn[0] = round(hue(c));
              toReturn[1] = round(saturation(c));
              toReturn[2] = round(min(brightness(c), dim));
            }
            else if(to == 3) { //rgbw
              toReturn = new int[4];
              arrayCopy(convertColor(original, 1, 3), toReturn);
              for(int i = 0; i < toReturn.length; i++) {
                toReturn[i] = rMap(toReturn[i], 0, 255, 0, dim);
              }
            }
            else if(to == 4) { //rgbwd
              toReturn = new int[5];
              arrayCopy(convertColor(original, 1, 3), toReturn);
              toReturn[4] = dim;
            }
            else if(to == 5) { //rgbd
              toReturn = new int[4];
              arrayCopy(original, toReturn);
            }
        popStyle(); 
      }
  popStyle();
  return toReturn;
}


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
cyan = 1 - (red(c) / 255);
magenta = 1 - (green(c) / 255);
yellow = 1 - (blue(c) / 255);
//convert to CMYK
black = 1; 
if (cyan < black) { black = cyan; }
if (magenta < black) { black = magenta; }
if (yellow < black) { black = yellow; }
cyan = ( cyan - black ) / ( 1 - black );
magenta = ( magenta - black ) / ( 1 - black );
yellow = ( yellow - black ) / ( 1 - black ); 
//convert to value between 0 and 100
cyan = cyan * 100;
magenta = magenta * 100;
yellow = yellow * 100;
black = black * 100;
}  

}   
