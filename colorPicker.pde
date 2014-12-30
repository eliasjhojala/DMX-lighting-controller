HSBColorPicker colorPick = new HSBColorPicker();
class HSBColorPicker { 
  
  HSBColorPicker() {
  }

int hue = 0;
int saturation = 255*2;
int brightness = 255*2;
boolean colorSelectorOpen = true;
  void showColorSelector() {
    pushMatrix();
      pushStyle();
      translate(100, 100);
        if(colorSelectorOpen) {
        
          fill(255, 230);
          rect(-10, -10, 255*2+20, 150+20, 20);
          
          countHue();
          countSaturation();
          countBrightness();
          showHue();
          showBrightness();
          showSaturation();
        
        }
      popStyle();
    popMatrix();
  }

  void countHue() {
    mouse.declareUpdateElementRelative("HSBP:hue", 11000000, 0, 0, 255*3, 30);
    mouse.setElementExpire("HSBP:hue", 2);
    if(mouse.isCaptured("HSBP:hue")) {
        hue+=(mouseX-pmouseX);
        hue = constrain(hue, 0, 255*2);
    }
  }
  void countBrightness() {
    mouse.declareUpdateElementRelative("HSBP:brightness", 11000000, 0, 50, 255*3, 30);
    mouse.setElementExpire("HSBP:brightness", 2);
    if(mouse.isCaptured("HSBP:brightness")) {
        brightness+=(mouseX-pmouseX);
        brightness = constrain(brightness, 0, 255*2);
    }
  }
  void countSaturation() {
    mouse.declareUpdateElementRelative("HSBP:saturation", 11000000, 0, 100, 255*3, 30);
    mouse.setElementExpire("HSBP:saturation", 2);
    if(mouse.isCaptured("HSBP:saturation")) {
        saturation+=(mouseX-pmouseX);
        saturation = constrain(saturation, 0, 255*2);
    }
  }
  
  void showHue() {
    for(int i = 0; i < 255; i++) {
      pushStyle();
        colorMode(HSB);
        stroke(i, saturation/2, brightness/2);
        fill(i, saturation/2, brightness/2);
        rect(i*2, 10, 2, 10);
      popStyle();
    }
    fill(255);
    triangle(hue, 20, hue-10, 30, hue+10, 30);
  }
  
  void showBrightness() {
    pushMatrix();
    translate(0, 50);
    for(int i = 0; i < 255; i++) {
      pushStyle();
        colorMode(HSB);
        stroke(hue/2, saturation/2, i);
        fill(hue/2, saturation/2, i);
        rect(i*2, 10, 2, 10);
      popStyle();
    }
    fill(255);
    triangle(brightness, 20, brightness-10, 30, brightness+10, 30);
    popMatrix();
  }

  void showSaturation() {
    pushMatrix();
    translate(0, 100);
    for(int i = 0; i < 255; i++) {
      pushStyle();
        colorMode(HSB);
        stroke(hue/2, i, brightness/2);
        fill(hue/2, i, brightness/2);
        rect(i*2, 10, 2, 10);
      popStyle();
    }
    fill(255);
    triangle(saturation, 20, saturation-10, 30, saturation+10, 30);
    popMatrix();
  }

  color getColorFromPicker() {
    pushStyle();
      colorMode(HSB);
      color c = color(hue/2, saturation/2, brightness/2);
      popStyle();
      return c;
    
  }
  
  boolean changed() {
    return true; //TODO: check if value is changed
  }
}
