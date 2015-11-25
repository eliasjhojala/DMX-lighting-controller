
void setup() {
  size(800, 800);
  surface.setResizable(true);
  test = screen.registerNewBuffer(10, 10, 80, 80);
  testArea.add(new DrawnArea(test, 20, 20, 50, 50));
}



void draw() {
  PGraphics g = test.beginDraw();
  g.rect(20, 20, 50, 50);
  test.endDraw(testArea);
  screen.draw();
}

ImageBuffer test;
ArrayList<DrawnArea> testArea = new ArrayList<DrawnArea>();
