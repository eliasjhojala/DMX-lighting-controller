
Appearance appearance;
class Appearance {
  private int backgroundColor = color(100);
  
  ScreenHandler screen;
  Appearance(ScreenHandler screen) {
    this.screen = screen;
  }
  
  ImageBuffer background;
  void setup() {
    background = screen.registerNewBuffer("background", 0, 0, width, height, 1);
    drawBackground();
    lastWidth = width; lastHeight = height;
  }
  
  int lastWidth, lastHeight;
  void draw() {
    if(lastWidth != width || lastHeight != height) {
     background.updateDimens(width, height, false);
     drawBackground();
     lastWidth = width; lastHeight = height;
    }
    background(backgroundColor);
    screen.draw();
  }
  
  // Private --->
  private void drawBackground() {
    PGraphics g = background.beginDraw();
    g.background(backgroundColor);
    background.endDraw(new DrawnArea(background));
  }
  
}
