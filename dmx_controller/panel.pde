

class Panel {
  ArrayList<Module> containedModules;
  ImageBuffer buffer;
  
  PVector location, size;
  Panel() {
    
  }
  boolean needsRedraw;
  void requireRedraw() { needsRedraw = true; }
  void draw() {
    if(needsRedraw) {
      PGraphics g = buffer.beginDraw();
      
      // Draw frame
      theme.panel(g);
      rect(0, 0, size.x, location.y);
      
      // Draw childen
      for (Module module : containedModules) {
        module.draw(buffer, g);
      }
      
      buffer.endDraw(new DrawnArea(buffer));
      
      needsRedraw = false;
    }
  }
  
  void resize() {
    
  }
}
