HSBColorPicker colorPick = new HSBColorPicker();
class HSBColorPicker { 
  
  Window window;
  
  HSBColorPicker() {
    locX = 700;
    locY = 100;
    w = 600;
    h = 230;
    window = new Window("HSBP", new PVector(w, h), this);
  }

  int hue = 0;
  int saturation = 255*2;
  int brightness = 255*2;
  boolean colorSelectorOpen = true;
  PVector offset = new PVector(0, 0);
  
  boolean open;
  int locX, locY, w, h;
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    g.pushMatrix();
      g.pushStyle();
      g.translate(40, 50);
      g.translate(offset.x, offset.y);
        

          //Count values by mouse dragging
          countHue(g, mouse);
          countSaturation(g, mouse);
          countBrightness(g, mouse);
          
          //Show bars
          showHue(g, mouse);
          showBrightness(g, mouse);
          showSaturation(g, mouse);
        
      g.popStyle();
    g.popMatrix();
  }

  void countHue(PGraphics g, Mouse mouse) {
    //Edit hue if dragged
    mouse.declareUpdateElementRelative("HSBP:hue", "HSBP", 0, 0, 255*3, 30, g);
    mouse.setElementExpire("HSBP:hue", 2);
    if(mouse.isCaptured("HSBP:hue")) {
        hue+=(mouseX-pmouseX);
        hue = constrain(hue, 0, 255*2);
    }
  }
  void countBrightness(PGraphics g, Mouse mouse) {
    //Edit brightness if dragged
    mouse.declareUpdateElementRelative("HSBP:brightness", "HSBP", 0, 50, 255*3, 30, g);
    mouse.setElementExpire("HSBP:brightness", 2);
    if(mouse.isCaptured("HSBP:brightness")) {
        brightness+=(mouseX-pmouseX);
        brightness = constrain(brightness, 0, 255*2);
    }
  }
  void countSaturation(PGraphics g, Mouse mouse) {
    //Edit saturation if dragged
    mouse.declareUpdateElementRelative("HSBP:saturation", "HSBP", 0, 100, 255*3, 30, g);
    mouse.setElementExpire("HSBP:saturation", 2);
    if(mouse.isCaptured("HSBP:saturation")) {
        saturation+=(mouseX-pmouseX);
        saturation = constrain(saturation, 0, 255*2);
    }
  }
  
  int triangleWidth = 7;
  int triangleHeight = triangleWidth*2;
  
  void showHue(PGraphics g, Mouse mouse) {
    //Show hue bar
    for(int i = 0; i < 255; i++) {
      g.pushStyle();
        g.colorMode(HSB);
        g.stroke(i, saturation/2, brightness/2);
        g.fill(i, saturation/2, brightness/2);
        g.rect(i*2, 10, 2, 10);
      g.popStyle();
    }
    g.fill(255);
    g.stroke(0);
    g.triangle(hue, 20, hue-triangleWidth, 20+triangleHeight, hue+triangleWidth, 20+triangleHeight);
  }
  
  void showBrightness(PGraphics g, Mouse mouse) {
    //Show brightness bar
    g.pushMatrix();
      g.translate(0, 50);
      for(int i = 0; i < 255; i++) {
        g.pushStyle();
          g.colorMode(HSB);
          g.stroke(hue/2, saturation/2, i);
          g.fill(hue/2, saturation/2, i);
          g.rect(i*2, 10, 2, 10);
        g.popStyle();
      }
      g.fill(255);
      g.stroke(0);
      g.triangle(brightness, 20, brightness-triangleWidth, 20+triangleHeight, brightness+triangleWidth, 20+triangleHeight);
    g.popMatrix();
  }

  void showSaturation(PGraphics g, Mouse mouse) {
    //Show saturation bar
    g.pushMatrix();
      g.translate(0, 100);
      for(int i = 0; i < 255; i++) {
        g.pushStyle();
          g.colorMode(HSB);
          g.stroke(hue/2, i, brightness/2);
          g.fill(hue/2, i, brightness/2);
          g.rect(i*2, 10, 2, 10);
        g.popStyle();
      }
      g.fill(255);
      g.stroke(0);
      g.triangle(saturation, 20, saturation-triangleWidth, 20+triangleHeight, saturation+triangleWidth, 20+triangleHeight);
    g.popMatrix();
  }

  color getColorFromPicker() {
    g.pushStyle();
      g.colorMode(HSB);
      color c = color(hue/2, saturation/2, brightness/2); //Divide all the values with two because they are 0-255*2
    g.popStyle();
    return c;
  }
  
  boolean changed() {
    return true; //TODO: check if value is changed
  }
}
