

class colorWash {
  colorWash(String colour) {
    
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

class colorName {
  String name;
  int red, green, blue, white;
  colorName(String colour, int r, int g, int b) {
    name = colour;
    red = r;
    green = g;
    blue = b;
  }
  colorName(String colour, int r, int g, int b, int w) {
    name = colour;
    red = r;
    green = g;
    blue = b;
    white = w;
  }
}

int[] convertColor(int[] original, int from, int to) {
  //original array: { r, g, b, w, d } or { h, s, b } or { c, m, y, k }
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
            if(to == 3) { //rgbw
              color c = color(original[0], original[1], original[2]);
              toReturn = new int[4];
              toReturn[0] = original[0];
              toReturn[1] = original[1];
              toReturn[2] = original[2];
              toReturn[3] = (original[0] + original[1] + original[2]) / 3;
            }
            if(to == 4) { //rgbwd
              color c = color(original[0], original[1], original[2]);
              toReturn = new int[4];
              toReturn[0] = original[0];
              toReturn[1] = original[1];
              toReturn[2] = original[2];
              toReturn[3] = (original[0] + original[1] + original[2]) / 3;
              toReturn[4] = 255;
            }
            if(to == 5) { //rgbd
              color c = color(original[0], original[1], original[2]);
              toReturn = new int[4];
              toReturn[0] = original[0];
              toReturn[1] = original[1];
              toReturn[2] = original[2];
              toReturn[3] = 255;
            }
          popStyle();
      }
      if(from == 2) { //hsb
        pushStyle();
          colorMode(HSB);
            if(to == 1) { //rgb
              color c = color(original[0], original[1], original[2]);
              toReturn = new int[3];
              toReturn[0] = round(red(c));
              toReturn[1] = round(green(c));
              toReturn[2] = round(blue(c));
            }
            if(to == 2) { //hsb
              toReturn = new int[3];
              arrayCopy(original, toReturn);
            }
            if(to == 3) { //rgbw
              toReturn = new int[4];
              arrayCopy(convertColor(convertColor(original, 2, 1), 1, 3), toReturn);
            }
            if(to == 4) { //rgbwd
              toReturn = new int[5];
              arrayCopy(convertColor(convertColor(original, 2, 1), 1, 4), toReturn);
            }
            if(to == 5) { //rgbd
              toReturn = new int[4];
              arrayCopy(convertColor(convertColor(original, 2, 1), 1, 5), toReturn);
            }
        popStyle();
      }
      if(from == 3) { //rgbw
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
            if(to == 2) { //hsb
              toReturn = new int[3];
              arrayCopy(convertColor(convertColor(original, 3, 1), 1, 2), toReturn);
            }
            if(to == 3) { //rgbw
              toReturn = new int[4];
              arrayCopy(original, toReturn);
            }
            if(to == 4) { //rgbwd
              toReturn = new int[5];
              arrayCopy(original, toReturn); //rgbw values
              toReturn[4] = 255; //dimmer
            }
            if(to == 5) {
              toReturn = new int[4];
              arrayCopy(convertColor(original, 3, 1), toReturn); //rgb values
              toReturn[3] = 255; //dimmer
            }
        popStyle();
      }
      if(from == 4) { //rgbwd
        pushStyle();
          colorMode(RGB);
          color c = color(original[0], original[1], original[2]);
          int dim = original[4];
          int white = original[3];
          if(to == 1) { //rgb
            toReturn = new int[3];
            int[] temp = new int[4];
            temp[0] = original[0]; //red
            temp[1] = original[1]; //green
            temp[2] = original[2]; //blue
            temp[3] = original[3]; //white
            arrayCopy(convertColor(temp, 3, 1), toReturn);
            color co = color(toReturn[0], toReturn[1], toReturn[2]);
            toReturn[0] = rMap(round(red(co)), 0, 255, 0, dim); 
            toReturn[1] = rMap(round(green(co)), 0, 255, 0, dim);
            toReturn[2] = rMap(round(blue(co)), 0, 255, 0, dim);
            
          }
          if(to == 2) { //hsb
            toReturn = new int[3];
            toReturn[0] = round(hue(c));
            toReturn[1] = round((saturation(c) + getInvertedValue(white, 0, 255)) / 2);
            toReturn[2] = round((brightness(c)*2 + white) / 3);
          }
          if(to == 3) { //rgbw
            toReturn = new int[4];
            toReturn[0] = rMap(round(red(c)), 0, 255, 0, dim);
            toReturn[1] = rMap(round(green(c)), 0, 255, 0, dim);
            toReturn[2] = rMap(round(blue(c)), 0, 255, 0, dim);
            toReturn[3] = rMap(white, 0, 255, 0, dim);
          }
          if(to == 4) { //rgbwd
            toReturn = new int[5];
            arrayCopy(original, toReturn);
          }
          if(to == 5) { //rgbd
            toReturn = new int[4];
            arrayCopy(convertColor(original, 4, 1), toReturn);
            toReturn[3] = original[4];
          }
          
        popStyle();
      }
  popStyle();
  return toReturn;
}

