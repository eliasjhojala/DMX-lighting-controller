

class SliderModule implements IntegerModule {
  int min, max;
  PVector location;
  SliderModule(int min, int max, int x, int y) {
    this.min = min;
    this.max = max;
    value = 100;
    location = new PVector(x, y);
  }
  
  int value;
  Integer getValue() {
    return value;
  }
  
  void draw(ImageBuffer imageBuffer, PGraphics g) {
    g.pushMatrix(); g.pushStyle();
      g.translate(location.x, location.y);
      
      int w = 20;
      int h = 120;
      int px = round(float(value - min) / (max-min) * h);
      
      g.clear();
      
      theme.fill(g);
      g.rect(1, 1, w, h);
      
      theme.active(g);
      g.rect(1, h+1, w, -px);
      
      theme.frame(g);
      g.rect(1, 1, w-1, h-1);
      
      theme.line(g);
      g.line(-1, h-px, w+3, h-px);
      
      imageBuffer.addArea(location.x, location.y, w, h);
    g.popMatrix(); g.popStyle();
  }
}
