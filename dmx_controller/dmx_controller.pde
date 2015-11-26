//Remember to test drawing speed

void setup() {
  size(1000, 1000);
  surface.setResizable(true);
  
  appearance = new Appearance(screen);
  appearance.setup();
}



void draw() {
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
