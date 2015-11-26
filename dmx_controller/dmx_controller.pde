//Remember to test drawing speed

SliderModule testSlider = new SliderModule(0, 255, 20, 20);
ImageBuffer testB;

void setup() {
  size(1000, 1000);
  surface.setResizable(true);
  
  appearance = new Appearance(screen);
  appearance.setup();
  
  testB = screen.registerNewBuffer(0, 0, 500, 500, 2);
}



void draw() {
  PGraphics testG = testB.beginDraw();
  testSlider.draw(testB, testG);
  testB.endDraw(new DrawnArea(testB, 20, 20, 202, 22));
  
  appearance.draw(); // Always do this after all other drawing
  // drawSpeedCounter();
}

// --> frameRate
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
