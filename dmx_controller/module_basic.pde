

class SliderModule implements IntegerModule {
  int min, max;
  PVector location;
  SliderModule(int min, int max, int x, int y) {
    this.min = min;
    this.max = max;
    value = 0;
    location = new PVector(x, y);
  }
  
  int value;
  Integer getValue() {
    return value;
  }
  
  void draw(ImageBuffer imageBuffer, PGraphics g) {
    g.pushMatrix(); g.pushStyle();
      g.translate(location.x, location.y);
      
      int px = (value - min) / (max-min);
      
      theme.fill(g);
      g.rect(1, 1, 20, 200);
      
      theme.active(g);
      g.rect(1, 200-px, 20, 200);
      
      theme.frame(g);
      g.rect(0, 0, 22, 202);
    g.popMatrix(); g.popStyle();
  }
}
