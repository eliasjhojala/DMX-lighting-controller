//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit
 
memoryCreationBox memoryCreator;

boolean savingMemory = false;
 
void sivuValikko() {
  
  //The old code can be found in old versions
  
  { // Memory creator open button
    pushStyle();
    //Open MemoryCreator bubblebutton
    int bubS = 250;
    int origBubS = bubS;
    mouse.declareUpdateElementRelative("addMemory", "main:move", width-168, 0, -bubS/2, bubS/2);
    if (mouse.elmIsHover("addMemory")) bubS += 10;
    
    
    if (mouse.isCaptured("addMemory") && mouse.firstCaptureFrame) {
      memoryCreator.initiatePassive();
    }
    
    //bubble shadow
    noFill();
    stroke(0, 120); strokeWeight(6);
    arc(width-168, 0, bubS, bubS, -(PI + HALF_PI), -PI);
    
    //chaseMode button(s)
    mouse.declareUpdateElementRelative("InMode", "main:move", width-268, bubS/2+30, 102, 30);
    mouse.setElementExpire("InMode", 2);
    boolean isHoverIM = mouse.elmIsHover("InMode");
    mouse.declareUpdateElementRelative("OutMode", "main:move", width-268, bubS/2, 102, 30);
    mouse.setElementExpire("OutMode", 2);
    boolean isHoverOM = mouse.elmIsHover("OutMode");
    stroke(topMenuAccent);  strokeWeight(2);
    pushStyle();
      pushStyle();
        //inputMode (lower)
        fill(isHoverIM ? topMenuTheme : topMenuTheme2);
        rect(width-268, bubS/2+10, 102, 50, 0, 0, 0, 20);
      popStyle();
      pushStyle();
        fill(255);
        text("InM: " + getInputModeMasterDesc(), width-262+3, bubS/2+48);
      popStyle();
      pushStyle();
        //outputMode (upper)
        fill(isHoverOM ? topMenuTheme : topMenuTheme2);
        rect(width-268, bubS/2-50, 102, 80, 0, 0, 0, 20);
      popStyle();
      pushStyle();
        fill(255);
        text("OutM: " + getOutputModeMasterDesc(), width-262+3, bubS/2+20);
      popStyle();
    popStyle();
    
    if(mouse.isCaptured("InMode") && mouse.firstCaptureFrame) { //lower
      if(mouseButton == LEFT) inputModeMasterUp(); else if(mouseButton == RIGHT) inputModeMasterDown();
    }
    if(mouse.isCaptured("OutMode") && mouse.firstCaptureFrame) { //upper
      if(mouseButton == LEFT) outputModeMasterUp(); else if(mouseButton == RIGHT) outputModeMasterDown();
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
  mouse.declareUpdateElement("rearMenu:presetcontrols", "main:move", width-168, 0, width, height);
  for(int i = 1; i <= height/20+1; i++) {
    if(memoryMenu+i < numberOfMemories) {
      pushMatrix();
        translate(0, 20*(i-1));
        drawMemoryController(i+memoryMenu, memories[i+memoryMenu].getText());
      popMatrix();
    }
  }
  
  popMatrix();
  //-
  
  memoryCreator.draw();
  
  
}


void drawMemoryController(int controlledMemoryId, String text) {
  int value = memories[controlledMemoryId].getValue();
  
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
  
  if (isHoverSimple(0, 0, 170, 20) && mouse.isCaptured("rearMenu:presetcontrols")) {
    if(mouseButton == LEFT) {
      value = constrain(int(map(mouseX - screenX(65, 0), 0, 100, 0, 255)), 0, 255);
      memories[controlledMemoryId].setValue(value);
    } else if(mouseButton == RIGHT) memoryCreator.initiateFromExsisting(controlledMemoryId);
  }
  noFill();
  stroke(100);
  rect(0, 0, 65, 20);
  rect(65, 0, 100, 20);
  popStyle();
}


String getMemoryTypeName(int numero) {
  return memories[numero].getText();
}

/////////MemoryCreationBox////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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
    
    
    switch(memories[memory].type) {
      case 0:
        selectedMemoryMode = 0;
      break;
      case 1:
        selectedMemoryMode = 0;
      break;
      case 2:
        selectedMemoryMode = 1;
      break;
      case 3:
        selectedMemoryMode = 2;
      break;
      
      default: return;
    }
    open = true;
    selectedMemorySlot = memory;
    selectedWhatToSave = new boolean[memories[memory].whatToSave.length];
    arrayCopy(memories[memory].whatToSave, selectedWhatToSave);
    
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
        mouse.declareUpdateElementRelative("memoryCreationBox", "addMemory", 0, 0, 300, 300);
        mouse.setElementExpire("memoryCreationBox", 2);
        //Grabable location button
        fill(180);
        noStroke();
        rect(10, 10, 20, 20, 20, 0, 0, 4);
        mouse.declareUpdateElementRelative("memoryCreationBox:move", "memoryCreationBox", 10, 10, 20, 20);
        mouse.setElementExpire("memoryCreationBox:move", 2);
        if(mouse.isCaptured("memoryCreationBox:move")) {
          locY = constrain(mouseY - pmouseY + locY, 40, height - 340);
        }
        //Cancel button
        mouse.declareUpdateElementRelative("memoryCreationBox:cancel", "memoryCreationBox", 30, 10, 50, 20);
        mouse.setElementExpire("memoryCreationBox:cancel", 2);
        boolean cancelHover = mouse.elmIsHover("memoryCreationBox:cancel");
        fill(cancelHover ? 220 : 180, 30, 30);
        //Close if Cancel is pressed
        if(mouse.isCaptured("memoryCreationBox:cancel")) open = false;
        rect(30, 10, 50, 20, 0, 4, 4, 0);
        fill(230);
        textAlign(CENTER);
        text("Cancel", 55, 24);
        //Save button
        mouse.declareUpdateElementRelative("memoryCreationBox:save", "memoryCreationBox", 290, 290, -50, -20);
        mouse.setElementExpire("memoryCreationBox:save", 2);
        boolean saveHover = mouse.elmIsHover("memoryCreationBox:save");
        fill(50, saveHover ? 240 : 220, 60);
        rect(290, 290, -50, -20, 4, 4, 20, 4);
        fill(255);
        text("Save", 265, 285);
        if(mouse.isCaptured("memoryCreationBox:save")) {
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
      mouse.declareUpdateElementRelative("memoryCreationBox:type", "memoryCreationBox", 0, 10, 100, 20);
      mouse.setElementExpire("memoryCreationBox:type", 2);
      boolean boxIsHover = mouse.elmIsHover("memoryCreationBox:type");
      fill(boxIsHover ? 200 : 180); noStroke();
      rect(82.5, 12.5, 16, 16, 2);
      fill(230);
      
      if(mouse.isCaptured("memoryCreationBox:type") && mouse.firstCaptureFrame)
        { addToSelectedMemoryMode(); }
      
      fill(0);
      textAlign(LEFT);
      text("Memory type:", 0, 5);
      switch(selectedMemoryMode) {
        case 0: {
          text("Preset", 2, 25);
        } break;
        case 1: {
          text("Chase", 2, 25);
        } break;
        case 2: {
          text("QChase", 2, 25);
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
      mouse.declareUpdateElementRelative("memoryCreationBox:slot", "memoryCreationBox", int(mappedSlot-10), 0, 20, 22);
      mouse.setElementExpire("memoryCreationBox:slot", 2);
      if(mouse.isCaptured("memoryCreationBox:slot")) {
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
        case 0: //Preset
          //Draw whatToSave checkboxes
          textAlign(LEFT);
          text("What to save:", 10, 125);
          translate(10, 132);
          int rows = 5;
          for(int i = 0; i < saveOptionButtonVariables.length; i++) {
            pushMatrix();
              translate(i / rows * 120, i % rows * 30);
              mouse.declareUpdateElementRelative("memoryCreationBox:wts" + i, "memoryCreationBox", 0, 0, 120, 25);
              mouse.setElementExpire("memoryCreationBox:wts" + i, 2);
              boolean boxIsHover = mouse.elmIsHover("memoryCreationBox:wts" + i);
              fill(boxIsHover ? 210 : 200);
              noStroke();
              rect(0, 0, 25, 25, 4);
              
              if(mouse.isCaptured("memoryCreationBox:wts" + i) && mouse.firstCaptureFrame) {
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
        case 1: case 2: //Chase & quickChase
          if(memories[selectedMemorySlot].myChase != null) {
          textAlign(LEFT);
          { //Chase Input
            text("Input Mode:", 10, 125);
            fill(0, 186, 240); noStroke();
            rect(110, 115, 12, 12, 1.5);
            if(isHoverSimple(110, 115, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.inputModeUp();
            }
            rect(124, 115, 12, 12, 1.5);
            if(isHoverSimple(124, 115, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.inputModeDown();
            }
            textSize(10);
            fill(0);
            text("+", 111.5, 124);
            text("-", 125.5, 124);
            text(memories[selectedMemorySlot].myChase.getInputModeDesc(), 10, 140);
          }
          { //Chase Output
            textSize(12);
            text("Output Mode:", 10, 175);
            fill(0, 186, 240); noStroke();
            rect(110, 165, 12, 12, 1.5);
            if(isHoverSimple(110, 165, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.outputModeUp();
            }
            rect(124, 165, 12, 12, 1.5);
            if(isHoverSimple(124, 165, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.outputModeDown();
            }
            textSize(10);
            fill(0);
            text("+", 111.5, 174);
            text("-", 125.5, 174);
            text(memories[selectedMemorySlot].myChase.getOutputModeDesc(), 10, 190);
          }
          { //Beat Mode
            textSize(12);
            text("Beat Mode:", 10, 225);
            fill(0, 186, 240); noStroke();
            rect(110, 215, 12, 12, 1.5);
            if(isHoverSimple(110, 215, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.beatModeUp();
            }
            rect(124, 215, 12, 12, 1.5);
            if(isHoverSimple(124, 215, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.beatModeDown();
            }
            textSize(10);
            fill(0);
            text("+", 111.5, 224);
            text("-", 125.5, 224);
            text(memories[selectedMemorySlot].myChase.beatMode, 10, 240);
          }
          { //Fade Mode
            textSize(12);
            text("Fade Mode:", 10, 275);
            fill(0, 186, 240); noStroke();
            rect(110, 265, 12, 12, 1.5);
            if(isHoverSimple(110, 265, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.fadeModeUp();
            }
            rect(124, 265, 12, 12, 1.5);
            if(isHoverSimple(124, 265, 12, 12) && mousePressed && mouse.capturedElement == mouse.getElementByName("memoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.fadeModeDown();
            }
            textSize(10);
            fill(0);
            text("+", 111.5, 274);
            text("-", 125.5, 274);
            text(memories[selectedMemorySlot].myChase.getFadeModeDesc(), 10, 290);
          }
          //Separator
          stroke(120);
          fill(120);
          strokeWeight(2);
          line(150, 110, 150, 260);
          { //fade
            textSize(12);
            fill(0);
            text("Fade: " + memories[selectedMemorySlot].myChase.ownFade, 160, 125);
            pushMatrix();
              translate(160, 130);
              memories[selectedMemorySlot].myChase.changeFade(quickSlider("memoryCreationBox:fade", memories[selectedMemorySlot].myChase.ownFade));
            popMatrix();
            
          }
          }
        break;
      }
    }
    popMatrix();
  }
  
  void save() {
    savingMemory = true;
    switch(selectedMemoryMode) {
      case 0: //Preset
        memories[selectedMemorySlot].savePreset(selectedWhatToSave);
      break;
      case 1: //s2l
        memories[selectedMemorySlot].myChase.newChase();
      break;
      case 2: //s2l
        memories[selectedMemorySlot].myChase.createQuickChase();
      break;
    }
    open = false;
    savingMemory = false;
  }
  
  //Returns whether box is hovered on
  boolean isMouseOver() {
    return isHoverSimple(width - (320 + 168), locY, 300, 300) && open;
  }
  
  void addToSelectedMemoryMode() {
    if(selectedMemoryMode < 2) selectedMemoryMode++;
    else selectedMemoryMode = 0;
  }
}




