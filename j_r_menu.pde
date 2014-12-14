//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit

memoryCreationBox memoryCreator = new memoryCreationBox(false);

void sivuValikko() {
  
  //The old code can be found in old versions
  
  { // Memory creator open button
    pushStyle();
    //Open MemoryCreator bubblebutton
    int bubS = 250;
    int origBubS = bubS;
    boolean bubbleHover = isHover(width-168, 0, -bubS/2, bubS/2);
    if (bubbleHover) bubS += 10;
    
    if (bubbleHover && mousePressed && mouseLocker.equals("main")) {
      mouseLocker = "addMemory";
      mouseLocked = true;
      memoryCreator.initiatePassive();
    }
    
    //bubble shadow
    noFill();
    stroke(0, 120); strokeWeight(6);
    arc(width-168, 0, bubS, bubS, -(PI + HALF_PI), -PI);
    
    //chaseMode button(s)
    boolean isHoverCM = isHoverSimple(width-268, bubS/2, 102, 40);
    fill(isHoverCM ? topMenuTheme : topMenuTheme2);
    stroke(topMenuAccent);  strokeWeight(2);
    //Lower
    //rect(width-268, bubS/2+40, 102, 40, 0, 0, 0, 20); - not in use for now
    //Upper
    rect(width-268, bubS/2-50, 102, 90, 0, 0, 0, 20);
    fill(255);
    text("Chase Mode: " + chaseMode, width-262, bubS/2+34);
    
    if(mousePressed && isHoverCM && !(mouseLocked && mouseLocker.equals("rearMenu:ChaseMode"))) {
      mouseLocked = true;
      mouseLocker = "rearMenu:ChaseMode";
      if(mouseButton == LEFT) nextChaseMode(); else if(mouseButton == RIGHT) reverseChaseMode();
    }
    
    
    
    //bubble itself
    fill(topMenuTheme);
    stroke(topMenuAccent);
    arc(width-168, 0, bubS, bubS, -(PI + HALF_PI), -PI);
    
    //Text
    fill(255);
    textSize(15);
    text("Add memory", width-150-bubS/2, 25);
    popStyle();
  }
  
  //-
  pushMatrix();
  translate(width-168, 0);
  for(int i = 1; i <= height/20+1; i++) {
    if(memoryMenu+i < numberOfMemories) {
      pushMatrix();
        translate(0, 20*(i-1));
        drawMemoryController(i+memoryMenu, getMemoryTypeName(i+memoryMenu));
      popMatrix();
    }
  }
  
  popMatrix();
  //-
  
  memoryCreator.draw();
  
  
}


void drawMemoryController(int controlledMemoryId, String text) {
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
    if(mouseButton == LEFT) {
      mouseLocked = true;
      mouseLocker = "presetControl";
      value = constrain(int(map(mouseX - screenX(65, 0), 0, 100, 0, 255)), 0, 255);
      memory(controlledMemoryId, value);
      memoryValue[controlledMemoryId] = value;
    } else if(mouseButton == RIGHT) memoryCreator.initiateFromExsisting(controlledMemoryId);
  }
  noFill();
  stroke(100);
  rect(0, 0, 65, 20);
  rect(65, 0, 100, 20);
  popStyle();
}


String getMemoryTypeName(int numero) {
  String nimi = "";
  if(memoryType[numero] == 1) { nimi = "prst"; }
  if(memoryType[numero] == 2) { nimi = "s2l"; }
  if(memoryType[numero] == 3) { nimi = "myst"; }
  if(memoryType[numero] == 4) { nimi = "mstr"; }
  if(memoryType[numero] == 5) { nimi = "fade"; }
  if(memoryType[numero] == 6) { nimi = "wave"; }
  return nimi;
}


class memoryCreationBox {
  memoryCreationBox(boolean o) {
    open = o;
    locY = 40;
    selectedWhatToSave = new boolean[saveOptionButtonVariables.length];
  }
  
  void initiate(int slot, int lY) {
    open = true;
    locY = lY;
    selectedMemorySlot = slot;
  }
  
  //Initiate with last configuration
  void initiatePassive() {
    open = true;
  }
  
  //Initiate with configuration from an existing memory
  void initiateFromExsisting(int memory) {
    
    
    switch(memoryType[memory]) {
      case 0:
        selectedMemoryMode = 0;
      break;
      case 1:
        selectedMemoryMode = 0;
      break;
      case 2:
        selectedMemoryMode = 1;
      break;
      
      default: return;
    }
    open = true;
    selectedMemorySlot = memory;
    selectedWhatToSave = whatToSave[memory];
    
  }
  
  boolean open;
  int locY;
  
  int selectedMemoryMode = 0;
  int selectedMemorySlot = 1;
  
  boolean[] selectedWhatToSave;
  
  void draw() {
    if(open) {
      pushMatrix();
      pushStyle();
      { // frame & frame controls
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
        if((mousePressed && isHoverSimple(10, 10, 20, 20) && !mouseLocked) || (mouseLocked && mouseLocker.equals("memoryCreationBox:move"))) {
          mouseLocked = true;
          mouseLocker = "memoryCreationBox:move";
          locY = constrain(mouseY - pmouseY + locY, 40, height - 340);
        }
        //Cancel button
        boolean cancelHover = isHoverSimple(30, 10, 50, 20);
        fill(cancelHover ? 220 : 180, 30, 30);
        //Close if Cancel is pressed
        if(cancelHover && mousePressed && !mouseLocked) open = false;
        rect(30, 10, 50, 20, 0, 4, 4, 0);
        fill(230);
        textAlign(CENTER);
        text("Cancel", 55, 24);
        //Save button
        boolean saveHover = isHover(290, 290, -50, -20);
        fill(50, saveHover ? 240 : 220, 60);
        rect(290, 290, -50, -20, 4, 4, 20, 4);
        fill(255);
        text("Save", 265, 285);
        if(saveHover && mousePressed && !mouseLocked) {
          mouseLocked = true;
          mouseLocker = "memoryCreationBox:save";
          save();
        }
      }
      
      { //Preset creation options
        drawModeSelection();
        drawSlotSelector();
        drawTypeSpecificOptions();
      }
      popMatrix();
      popStyle();
    }
  }
  
  void drawModeSelection() {
    pushMatrix();
    {
      
      translate(10, 40);
      strokeWeight(1);
      stroke(150);
      fill(240);
      rect(0, 10, 100, 20, 2);
      boolean boxIsHover = isHoverSimple(0, 10, 100, 20);
      fill(boxIsHover ? 200 : 180); noStroke();
      rect(82.5, 12.5, 16, 16, 2);
      fill(230);
      
      if(boxIsHover && mousePressed && !mouseLocked)
        { mouseLocked = true; mouseLocker = "memoryCreationBox:type"; addToSelectedMemoryMode(); }
      
      fill(0);
      textAlign(LEFT);
      text("Memory type:", 0, 5);
      switch(selectedMemoryMode) {
        case 0: {
          text("Preset", 2, 25);
        } break;
        case 1: {
          text("Chase (s2l)", 2, 25);
        } break;
      }
    }
    popMatrix();
  }
  
  void drawSlotSelector() {
    pushMatrix();
    {
      textAlign(CENTER);
      
      //Area bar
      translate(10, 75);
      stroke(120);
      fill(120);
      strokeWeight(2);
      line(0, 0, 280, 0);
      text("SLOT", 140, 16);
      
      //Selection indicator
      float mappedSlot = map(selectedMemorySlot, 1, numberOfMemories-1, 0, 280);
      fill(0, 186, 240);
      stroke(0, 0, 200);
      triangle(mappedSlot, 2, mappedSlot+10, 22, mappedSlot-10, 22);
      if(mousePressed && isHoverSimple(int(mappedSlot-10), 0, 20, 22) && !mouseLocked) {
        mouseLocked = true;
        mouseLocker = "memoryCreationBox:slot";
      }
      if(mouseLocked && mouseLocker.equals("memoryCreationBox:slot")) {
        selectedMemorySlot = constrain(int(map(mouseX - screenX(0, 0), 0, 280, 0, numberOfMemories)), 1, numberOfMemories-1);
      }
      
      fill(0);
      text(selectedMemorySlot, mappedSlot, 34);
    }
    popMatrix();
  }
  
  void drawTypeSpecificOptions() {
    pushMatrix();
    {
      switch(selectedMemoryMode) {
        case 0:
          //Draw whatToSave checkboxes
          textAlign(LEFT);
          text("What to save:", 10, 125);
          translate(10, 132);
          int rows = 5;
          for(int i = 0; i < saveOptionButtonVariables.length; i++) {
            pushMatrix();
              translate(i / rows * 120, i % rows * 30);
              boolean boxIsHover = isHoverSimple(0, 0, 120, 25);
              fill(boxIsHover ? 210 : 200);
              noStroke();
              rect(0, 0, 25, 25, 4);
              if(boxIsHover && mousePressed && !mouseLocked) {
                mouseLocked = true;
                mouseLocker = "memoryCreationBox:wts" + i;
                selectedWhatToSave[i] = !selectedWhatToSave[i];
              }
              if(selectedWhatToSave[i]) {
                fill(0, 186, 240);
                rect(4, 4, 17, 17, 4);
              }
              fill(10);
              text(saveOptionButtonVariables[i], 30, 16);
            popMatrix();
          }
        break;
        case 1:
          
        break;
      }
    }
    popMatrix();
  }
  
  void save() {
    switch(selectedMemoryMode) {
      case 0: //Preset
        arrayCopy(selectedWhatToSave, whatToSave[selectedMemorySlot]);
        saveFixtureMemory(selectedMemorySlot);
      break;
      case 1: //s2l
        soundToLightFromPreset(selectedMemorySlot);
      break;
    }
    open = false;
  }
  
  //Returns whether box is hovered on
  boolean isMouseOver() {
    return isHoverSimple(width - (320 + 168), locY, 300, 300) && open;
  }
  
  void addToSelectedMemoryMode() {
    if(selectedMemoryMode < 1) selectedMemoryMode++;
    else selectedMemoryMode = 0;
  }
}




