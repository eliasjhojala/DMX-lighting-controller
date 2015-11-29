// Specifies the colors of the UI.
// The theme can be swapped on the fly (make sure that screen.redrawEverything() is called)
Theme theme = new DefaultTheme();

interface Theme {
  void shadow(PGraphics g);
  void fill(PGraphics g);
  void active(PGraphics g);
  void frame(PGraphics g);
  void line(PGraphics g);
}

class DefaultTheme implements Theme {
  DefaultTheme() {}
  
  void shadow(PGraphics g) {
    g.fill(1, 20);
    g.noStroke();
  }
  
  void fill(PGraphics g) {
    g.fill(180);
    g.noStroke();
  }
  
  void active(PGraphics g) {
    g.fill(19, 166, 69);
    g.noStroke();
  }
  
  void frame(PGraphics g) {
    g.noFill();
    g.stroke(0, 42);
    g.strokeWeight(4);
  }
  
  void line(PGraphics g) {
    g.noFill();
    g.stroke(27, 252, 103);
    g.strokeWeight(1);
  }
}
