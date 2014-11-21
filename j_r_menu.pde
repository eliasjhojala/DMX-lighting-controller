//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit

memoryCreationBox memoryCreator = new memoryCreationBox(true);

void sivuValikko() {
  
  //The old code can be found in old versions
  
  //-
  pushMatrix();
  translate(width-168, 0);
  for(int i = 1; i <= height/20+1; i++) {
    if(memoryMenu+i < numberOfMemories) {
      pushMatrix();
        translate(0, 20*(i-1));
        drawMemoryController(i+memoryMenu, getMemoryTypeName(i+memoryMenu), !presetIsEmpty(i+memoryMenu));
      popMatrix();
    }
  }
  
  popMatrix();
  //-
  
  memoryCreator.draw();
 
}


void drawMemoryController(int controlledMemoryId, String text, boolean inUse) {
  int value = memoryValue[controlledMemoryId];
  
  pushStyle();
  
  textSize(12);
  textAlign(CENTER);
  //Draw controller
  strokeWeight(2);
  noStroke();
  fill(240);
  //Number indication box
  rect(0, 0, 25, 20);
  fill(20);
  text(controlledMemoryId, 25/2, 15);
  //Type indication box
  fill(10, 240, 10);
  rect(25, 0, 40, 20);
  fill(20);
  textAlign(LEFT);
  text(text, 30, 15);
  
  //Controller box
  fill(255, 200);
  noStroke();
  rect(65, 0, 100, 20);
  fill(50, 50, 240);
  rect(65, 0, map(value, 0, 255, 0, 100), 20);
  fill(0);
  text(value, 68, 16);
  
  if (isHoverSimple(0, 0, 170, 20) && mousePressed && (!mouseLocked || mouseLocker.equals("presetControl"))) {
    mouseLocked = true;
    mouseLocker = "presetControl";
    value = constrain(int(map(mouseX - screenX(65, 0), 0, 100, 0, 255)), 0, 255);
    memory(controlledMemoryId, value);
    memoryValue[controlledMemoryId] = value;
  }
  noFill();
  stroke(100);
  rect(0, 0, 65, 20);
  rect(65, 0, 100, 20);
  popStyle();
}


class memoryCreationBox {
  memoryCreationBox(boolean o) {
    open = o;
    locY = 40;
  }
  
  boolean open;
  int locY;
  
  void draw() {
    if(open) {
      pushMatrix();
      pushStyle();
      translate(width - (320 + 168), locY);
      fill(255, 230);
      stroke(150);
      strokeWeight(3);
      //Box itself
      rect(0, 0, 300, 300, 20);
      //Grabable location button
      fill(180);
      noStroke();
      rect(10, 10, 20, 20, 20, 0, 0, 4);
      if((mousePressed && isHoverSimple(10, 10, 20, 20)) || (mouseLocked && mouseLocker.equals("memoryCreationBox:move"))) {
        mouseLocked = true;
        mouseLocker = "memoryCreationBox:move";
        locY = constrain(mouseY - pmouseY + locY, 40, height - 340);
      }
      //Cancel button
      boolean cancelHover = isHoverSimple(30, 10, 50, 20);
      fill(cancelHover ? 220 : 180, 30, 30);
      //Close if Cancel is pressed
      if(cancelHover && mousePressed && !mouseLocker.equals("memoryCreationBox:move")) open = false;
      rect(30, 10, 50, 20, 0, 4, 4, 0);
      fill(230);
      textAlign(CENTER);
      text("Cancel", 55, 24);
      popMatrix();
      popStyle();
    }
  }
  
}



String getMemoryTypeName(int numero) {
  String nimi = "";
  if(memoryType[numero] == 1) { nimi = "prst"; }
  if(memoryType[numero] == 2) { nimi = "s2l"; }
  if(memoryType[numero] == 4) { nimi = "mstr"; }
  if(memoryType[numero] == 5) { nimi = "fade"; }
  if(memoryType[numero] == 6) { nimi = "wave"; }
  return nimi;
}
