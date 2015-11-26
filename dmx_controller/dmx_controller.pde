//Remember to test drawing speed

void setup() {
  size(displayWidth, displayHeight);
  surface.setResizable(true);
  test = screen.registerNewBuffer(10, 10, 80, 80);
  testArea.add(new DrawnArea(test, 20, 20, 50, 50));
}



void draw() {
  PGraphics g = test.beginDraw();
  g.rect(20, 20, 50, 50);
  test.endDraw(testArea);
  screen.draw();


  drawSpeedCounter();

}

ImageBuffer test;
ArrayList<DrawnArea> testArea = new ArrayList<DrawnArea>();



//Draw speed counter----------------------------------------------------------
int drawSpeedCounterCounter;
long drawSpeedCounterLastMillis;
float drawSpeed, drawFreq;
void drawSpeedCounter() {
  int countTimes = 10;
  drawSpeedCounterCounter++;
  if(drawSpeedCounterCounter >= countTimes) {
    drawSpeed = (millis() - drawSpeedCounterLastMillis);
    drawSpeed = drawSpeed / countTimes;
    drawSpeedCounterLastMillis = millis();
    drawFreq = 1000 / drawSpeed;
    drawSpeedCounterCounter = 0;
  }
  
  println("one draw time: " + drawSpeed + "  draws in sec: " + drawFreq);
}
