HelpWindow help = new HelpWindow();

class HelpWindow {
  
  int locX, locY, w, h;
  boolean open;
  
  HelpWindow() {
    locX = 100;
    locY = 100;
    w = 500;
    h = 500;
    open = true;
  }
  
  
  
  void draw(PGraphics g, Mouse mouse, boolean doTranslate) {
    g.fill(100);
    g.stroke(255);
    g.strokeWeight(10);
    g.rect(0, 0, 500, 500);
  }
}
