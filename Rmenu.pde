//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit
 
MemoryCreationBox memoryCreator;

int[] memoryControllerLookupTable = newIncrementingIntArray(numberOfMemories, 0);


boolean draggingMemory = false;
int     draggingMemoryId;


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
      if(!showMode) memoryCreator.initiatePassive();
        else notifier.notify("Cannot use memoryCreator while showMode is enabled! (Press M to toggle)");
      
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
    int ai = memoryControllerLookupTable[i] + memoryMenu;
    if(ai < numberOfMemories) {
      pushMatrix();
        translate(0, 20*(i-1));
        drawMemoryController(ai, memories[ai].getText());
      popMatrix();
    }
  }
  
  if(draggingMemory) { pushStyle();
    translate(0, mouseY);
    PGraphics temp = createGraphics(170, 22);
    temp.beginDraw();
    temp.translate(1, 1);
    drawMemoryControllerToBuffer(draggingMemoryId, memories[draggingMemoryId].getText(), temp, false, true);
    temp.endDraw();
    tint(255, 140);
    image(temp, -1, -1);
  popStyle(); }
  
  popMatrix();
  //-
    
    
  //if(!showMode) { memoryCreator.draw(); }
}

void reorderMemoryController(int from, int to) {
  int valFrom = from;
  int valTo   = to  ;
  from = indexOf(memoryControllerLookupTable, from);
  to   = indexOf(memoryControllerLookupTable, to  );
  
  
  
  if(from > to) { //If from is lower than to (drawn)
    for(int i = from; i > to; i--) {
      if(i - 1 >= 0) memoryControllerLookupTable[i] = memoryControllerLookupTable[i - 1];
    }
    memoryControllerLookupTable[to] = valFrom;
    return;
  } else if(from < to) { //If from is higher than to (drawn)
    for(int i = from; i < to; i++) {
      if(i + 1 >= 0) memoryControllerLookupTable[i] = memoryControllerLookupTable[i + 1];
    }
    memoryControllerLookupTable[to] = valFrom;
  } else if(from == to) {
    return;
  }
}

void drawMemoryController(int cMId, String text) {
  drawMemoryControllerToBuffer(cMId, text, g, true, false);
}

void drawMemoryControllerToBuffer(int controlledMemoryId, String text, PGraphics g, boolean checkMouse, boolean bypassDrawBlock) {
  int value = memories[controlledMemoryId].getValue();
  
  g.pushStyle();
  
  if(!(draggingMemory && draggingMemoryId == controlledMemoryId) || bypassDrawBlock) {
    g.textSize(12);
    g.textAlign(CENTER);
    //Draw controller
    g.strokeWeight(2);
    g.noStroke();
    g.fill(240);
    //Number indication box
    g.rect(0, 0, 25, 20);
    g.fill(20);
    g.text(controlledMemoryId, 25/2, 15);
    //Type indication box
    g.fill(10, 240, 10);
    g.rect(25, 0, 40, 20);
    g.fill(20);
    g.textAlign(LEFT);
    g.text(text, 30, 15);
    
    //Controller box
    g.fill(255, 200);
    g.noStroke();
    g.rect(65, 0, 100, 20);
    if(memories[controlledMemoryId].enabled) g.fill(50, 50, 240);
      else                                   g.fill(140);
    g.rect(65, 0, map(value, 0, 255, 0, 100), 20);
    g.fill(0);
    g.text(value, 68, 16);
    
    //Borders
    g.noFill();
    g.stroke(100);
    g.rect(0, 0, 65, 20);
    g.rect(65, 0, 100, 20);
  }


  if (isHoverSimple(0, 0, 170, 20) && mouse.isCaptured("rearMenu:presetcontrols") && !draggingMemory && checkMouse) {
    if(mouseButton == LEFT) {
      if(keyPressed && keyCode == CONTROL) {
        if(mouse.firstCaptureFrame) memories[controlledMemoryId].toggleWithMemory(true);
      } else if(keyPressed && keyCode == SHIFT) {
        if(!showMode) {
          draggingMemoryId = controlledMemoryId;
          draggingMemory = true;
        }
      } else {
        value = constrain(int(map(mouseX - screenX(65, 0), 0, 100, 0, 255)), 0, 255);
        memories[controlledMemoryId].setValue(value);
      }
    } else if(mouseButton == RIGHT) memoryCreator.initiateFromExsisting(controlledMemoryId);
  } else if(draggingMemory && isHoverSimple(0, 0, 170, 20) && checkMouse) {
    g.fill(20, 255, 20, 180); g.noStroke();
    g.rect(0, 0, 168, 20);
    if(!mousePressed) {
      reorderMemoryController(draggingMemoryId, controlledMemoryId);
      draggingMemory = false;
    }
  }
  
  
  
  
  g.popStyle();
}


String getMemoryTypeName(int numero) {
  return memories[numero].getText();
}

/////////MemoryCreationBox////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class MemoryCreationBox {
  MemoryCreationBox(boolean o) {
    open = o;
    locY = 40;
    locX = width - (320 + 168);
    selectedWhatToSave = new boolean[saveOptionButtonVariables.length];
  }
  
  void initiate(int slot, int lY, int lX) {
    open = true;
    locY = lY;
    locX = lX;
    selectedMemorySlot = slot;
  }
  
  //Initiate with last configuration
  void initiatePassive() {
    open = true;
    locY = 40;
    locX = width - (320 + 168);
  }
  
  //Initiate with configuration from an existing memory
  void initiateFromExsisting(int memory) {
    
    
    switch(memories[memory].type) {
      case 0:
        selectedMemoryMode = 0;
      break;
      default:
        selectedMemoryMode = memories[memory].type - 1;
      break;
    }
    open = true;
    selectedMemorySlot = memory;
    selectedWhatToSave = new boolean[memories[memory].whatToSave.length];
    boolean[] defaultWhatToSave = new boolean[memories[memory].whatToSave.length];
    defaultWhatToSave[0] = true;
    arrayCopy(memories[memory].whatToSave, selectedWhatToSave);
    
    if(memories[memory].type == 0) {
      arrayCopy(defaultWhatToSave, selectedWhatToSave);
    }
    
  }
  
  boolean open;
  int locY;
  int locX;
  
  int selectedMemoryMode = 0;
  int selectedMemorySlot = 1;
  
  
  int h = 600, w = 300;
  
  
  boolean[] selectedWhatToSave;
  
  void draw() {
    draw(g, mouse, true);
  }
  
  void draw(PGraphics g, Mouse mouse, boolean translate) {
    if(open) {
      g.pushMatrix();
      g.pushStyle();
      { // frame & frame controls
        if(translate) g.translate(locX, locY);
        g.fill(255, 230);
        g.stroke(150);
        g.strokeWeight(3);
        //Box itself
        g.rect(0, 0, w, h, 20);
        mouse.declareUpdateElementRelative("MemoryCreationBox", 1, 0, 0, w, h, g);
        mouse.setElementExpire("MemoryCreationBox", 2);
        //Grabable location button
        g.fill(180);
        g.noStroke();
        g.rect(10, 10, 20, 20, 20, 0, 0, 4);
        mouse.declareUpdateElementRelative("MemoryCreationBox:move", "MemoryCreationBox", 10, 10, 20, 20, g);
        mouse.setElementExpire("MemoryCreationBox:move", 2);
        if(mouse.isCaptured("MemoryCreationBox:move")) {
          locY = constrain(mouseY - pmouseY + locY, 40, height - h-40);
          locX = constrain(mouseX - pmouseX + locX, 40, width - (320 + 168));
        }
        //Cancel button
        mouse.declareUpdateElementRelative("MemoryCreationBox:cancel", "MemoryCreationBox", 30, 10, 50, 20, g);
        mouse.setElementExpire("MemoryCreationBox:cancel", 2);
        boolean cancelHover = mouse.elmIsHover("MemoryCreationBox:cancel");
        g.fill(cancelHover ? 220 : 180, 30, 30);
        //Close if Cancel is pressed
        if(mouse.isCaptured("MemoryCreationBox:cancel")) open = false;
        g.rect(30, 10, 50, 20, 0, 4, 4, 0);
        g.fill(230);
        g.textAlign(CENTER);
        g.text("Cancel", 55, 24);
        //Save button
        mouse.declareUpdateElementRelative("MemoryCreationBox:save", "MemoryCreationBox", 290, h-10, -50, -20, g);
        mouse.setElementExpire("MemoryCreationBox:save", 2);
        boolean saveHover = mouse.elmIsHover("MemoryCreationBox:save");
        g.fill(50, saveHover ? 240 : 220, 60);
        g.rect(290, h-10, -50, -20, 4, 4, 20, 4);
        g.fill(255);
        g.text("Save", 265, h-15);
        if(mouse.isCaptured("MemoryCreationBox:save")) {
          save();
        }
      }
      
      { //Preset creation options
        drawModeSelection(g, mouse);
        drawSlotSelector(g, mouse);
        drawTypeSpecificOptions(g, mouse);
      }
      g.popMatrix();
      g.popStyle();
    }
  }
  
  void drawModeSelection(PGraphics g, Mouse mouse) {
    g.pushMatrix();
    {
      
      g.translate(10, 40);
      g.strokeWeight(1);
      g.stroke(150);
      g.fill(240);
      g.rect(0, 10, 100, 20, 2);
      mouse.declareUpdateElementRelative("MemoryCreationBox:type", "MemoryCreationBox", 0, 10, 100, 20, g);
      mouse.setElementExpire("MemoryCreationBox:type", 2);
      boolean boxIsHover = mouse.elmIsHover("MemoryCreationBox:type");
      g.fill(boxIsHover ? 200 : 180); g.noStroke();
      g.rect(82.5, 12.5, 16, 16, 2);
      g.fill(230);
      
      if(mouse.isCaptured("MemoryCreationBox:type") && mouse.firstCaptureFrame)
        { addToSelectedMemoryMode(); }
      
      g.fill(0);
      g.textAlign(LEFT);
      g.text("Memory type:", 0, 5);
      switch(selectedMemoryMode) {
        case 0: {
          g.text("Preset", 2, 25);
        } break;
        case 1: {
          g.text("Chase", 2, 25);
        } break;
        case 2: {
          g.text("QChase", 2, 25);
        } break;
        case 5: {
          g.text("Chase1", 2, 25);
        } break;
        case 6: {
          g.text("Special", 2, 25);
        } break;
      }
    }
    g.popMatrix();
  }
  
  void drawSlotSelector(PGraphics g, Mouse mouse) {
    g.pushMatrix();
    {
      g.textAlign(CENTER);
      
      //Area bar
      g.translate(10, 75);
      g.stroke(120);
      g.fill(120);
      g.strokeWeight(2);
      g.line(0, 0, 280, 0);
      g.text("SLOT", 140, 16);
      
      //Selection indicator
      float mappedSlot = map(selectedMemorySlot, 1, numberOfMemories-1, 0, 280);
      g.fill(0, 186, 240);
      g.stroke(0, 0, 200);
      g.triangle(mappedSlot, 2, mappedSlot+10, 22, mappedSlot-10, 22);
      mouse.declareUpdateElementRelative("MemoryCreationBox:slot", "MemoryCreationBox", int(mappedSlot-10), 0, 20, 22, g);
      mouse.setElementExpire("MemoryCreationBox:slot", 2);
      if(mouse.isCaptured("MemoryCreationBox:slot")) {
        selectedMemorySlot = constrain(int(map(mouseX - locX - g.screenX(0, 0), 0, 280, 0, numberOfMemories)), 1, numberOfMemories-1);
      }
      
      g.fill(0);
      g.text(selectedMemorySlot, mappedSlot, 34);
    }
    g.popMatrix();
  }
  
  void drawTypeSpecificOptions(PGraphics g, Mouse mouse) {
    g.pushMatrix();
    {
      g.pushMatrix();
        g.pushMatrix();
              g.translate(275, 110);
              mouse.declareUpdateElementRelative("MemoryCreationBox:solo", "MemoryCreationBox", 0, 0, 120, 25, g);
              mouse.setElementExpire("MemoryCreationBox:solo", 2);
              boolean soloBoxIsHover = mouse.elmIsHover("MemoryCreationBox:solo");
              g.fill(soloBoxIsHover ? 210 : 200);
              g.noStroke();
              g.rect(0, 0, 25, 25, 4);
              
              if(mouse.isCaptured("MemoryCreationBox:solo") && mouse.firstCaptureFrame) {
                memories[selectedMemorySlot].soloInThisMemory = !memories[selectedMemorySlot].soloInThisMemory;
              }
              if(memories[selectedMemorySlot].soloInThisMemory) {
                g.fill(0, 186, 240);
                g.rect(4, 4, 17, 17, 4);
              }
              g.fill(10);
            g.popMatrix();
      g.popMatrix();
      switch(selectedMemoryMode) {
        case 0: //Preset
          //Draw whatToSave checkboxes
          g.textAlign(LEFT);
          g.text("What to save:", 10, 125);
          g.translate(10, 132);
          int cols = 2;
          int rows = saveOptionButtonVariables.length/cols;
          for(int i = 0; i < saveOptionButtonVariables.length; i++) {
            g.pushMatrix();
              g.translate(i / rows * 120, i % rows * 30);
              mouse.declareUpdateElementRelative("MemoryCreationBox:wts" + i, "MemoryCreationBox", 0, 0, 120, 25, g);
              mouse.setElementExpire("MemoryCreationBox:wts" + i, 2);
              boolean boxIsHover = mouse.elmIsHover("MemoryCreationBox:wts" + i);
              g.fill(boxIsHover ? 210 : 200);
              g.noStroke();
              g.rect(0, 0, 25, 25, 4);
              
              if(mouse.isCaptured("MemoryCreationBox:wts" + i) && mouse.firstCaptureFrame) {
                selectedWhatToSave[i] = !selectedWhatToSave[i];
              }
              if(selectedWhatToSave[i]) {
                g.fill(0, 186, 240);
                g.rect(4, 4, 17, 17, 4);
              }
              g.fill(10);
              g.text(saveOptionButtonVariables[i], 30, 16);
            g.popMatrix();
          }
        break; //end of case 0
        case 1: case 2: //Chase & quickChase
          if(memories[selectedMemorySlot].myChase != null) {
          g.textAlign(LEFT);
          { //Chase Input
            g.text("Input Mode:", 10, 125);
            g.fill(0, 186, 240); g.noStroke();
            g.rect(110, 115, 12, 12, 1.5);
            if(isHoverSimple(110, 115, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.inputModeUp();
            }
            g.rect(124, 115, 12, 12, 1.5);
            if(isHoverSimple(124, 115, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.inputModeDown();
            }
            g.textSize(10);
            g.fill(0);
            g.text("+", 111.5, 124);
            g.text("-", 125.5, 124);
            g.text(memories[selectedMemorySlot].myChase.getInputModeDesc(), 10, 140);
          }
          { //Chase Output
            g.textSize(12);
            g.text("Output Mode:", 10, 175);
            g.fill(0, 186, 240); g.noStroke();
            g.rect(110, 165, 12, 12, 1.5);
            if(isHoverSimple(110, 165, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.outputModeUp();
            }
            g.rect(124, 165, 12, 12, 1.5);
            if(isHoverSimple(124, 165, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.outputModeDown();
            }
            g.textSize(10);
            g.fill(0);
            g.text("+", 111.5, 174);
            g.text("-", 125.5, 174);
            g.text(memories[selectedMemorySlot].myChase.getOutputModeDesc(), 10, 190);
          }
          { //Beat Mode
            g.textSize(12);
            g.text("Beat Mode:", 10, 225);
            g.fill(0, 186, 240); g.noStroke();
            g.rect(110, 215, 12, 12, 1.5);
            if(isHoverSimple(110, 215, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.beatModeUp();
            }
            g.rect(124, 215, 12, 12, 1.5);
            if(isHoverSimple(124, 215, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.beatModeDown();
            }
            g.textSize(10);
            g.fill(0);
            g.text("+", 111.5, 224);
            g.text("-", 125.5, 224);
            g.text(memories[selectedMemorySlot].myChase.beatMode, 10, 240);
          }
          { //Fade Mode
            g.textSize(12);
            g.text("Fade Mode:", 10, 275);
            g.fill(0, 186, 240); g.noStroke();
            g.rect(110, 265, 12, 12, 1.5);
            if(isHoverSimple(110, 265, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.fadeModeUp();
            }
            g.rect(124, 265, 12, 12, 1.5);
            if(isHoverSimple(124, 265, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
              memories[selectedMemorySlot].myChase.fadeModeDown();
            }
            g.textSize(10);
            g.fill(0);
            g.text("+", 111.5, 274);
            g.text("-", 125.5, 274);
            g.text(memories[selectedMemorySlot].myChase.getFadeModeDesc(), 10, 290);
          }
          //Separator
          g.stroke(120);
          g.fill(120);
          g.strokeWeight(2);
          g.line(150, 110, 150, 260);
          
          { //fade
            g.textSize(12);
            g.fill(0);
            g.text("Fade: " + memories[selectedMemorySlot].myChase.ownFade, 160, 125);
            g.pushMatrix();
              g.translate(160, 130);
              memories[selectedMemorySlot].myChase.changeFade(quickSlider("MemoryCreationBox:fade", 10, memories[selectedMemorySlot].myChase.ownFade, g, mouse));
            g.popMatrix();
            
          }
          }
        break; //end of case 1 and case 2
        case 5: //chase with steps inside
          //Draw some buttons
          if(memories[selectedMemorySlot].myChase.creatingChaseWithStepsInside()) {
              g.pushMatrix();
                g.translate(10, 110);
                mouse.declareUpdateElementRelative("MemoryCreationBox:nextStep", "MemoryCreationBox", 0, 0, 25, 25, g);
                mouse.setElementExpire("MemoryCreationBox:nextStep", 2);
                boolean boxIsClicked = mouse.isCaptured("MemoryCreationBox:nextStep") && mouse.firstCaptureFrame;
                g.pushStyle();
                  if(boxIsClicked) { g.fill(topMenuTheme); memories[selectedMemorySlot].myChase.createNextStep(selectedWhatToSave); }
                  else { g.fill(topMenuAccent); }
                  g.noStroke();
                  g.rect(0, 0, 25, 25, 4);
                g.popStyle();
                g.text("save step", 56, 16);
              g.popMatrix();
            }
            
            g.pushMatrix();
              g.translate(100, 110);
              mouse.declareUpdateElementRelative("MemoryCreationBox:startCreating", "MemoryCreationBox", 0, 0, 25, 25, g);
              mouse.setElementExpire("MemoryCreationBox:startCreating", 2);
              boolean boxIsClicked = mouse.isCaptured("MemoryCreationBox:startCreating") && mouse.firstCaptureFrame;
              g.pushStyle();
                if(boxIsClicked) { g.fill(topMenuTheme); memories[selectedMemorySlot].myChase.startCreatingChaseWidthStepsInside(); }
                else { g.fill(topMenuAccent); }
                g.noStroke();
                g.rect(0, 0, 25, 25, 4);
              g.popStyle();
              g.text("start creating", 69, 16); //69 was some reason better than 56
            g.popMatrix();
            
            
            g.pushMatrix();
              g.translate(250, 110);
              mouse.declareUpdateElementRelative("MemoryCreationBox:swtso", "MemoryCreationBox", 0, 0, 120, 25, g);
              mouse.setElementExpire("MemoryCreationBox:swtso", 2);
              boolean boxIsHover = mouse.elmIsHover("MemoryCreationBox:swtso");
              g.fill(boxIsHover ? 210 : 200);
              g.noStroke();
              g.rect(0, 0, 25, 25, 4);
              
              if(mouse.isCaptured("MemoryCreationBox:swtso") && mouse.firstCaptureFrame) {
                memories[selectedMemorySlot].myChase.showWhatToSaveOptions = !memories[selectedMemorySlot].myChase.showWhatToSaveOptions;
              }
              if(memories[selectedMemorySlot].myChase.showWhatToSaveOptions) {
                g.fill(0, 186, 240);
                g.rect(4, 4, 17, 17, 4);
              }
              g.fill(10);
            g.popMatrix();
          
          
          if(memories[selectedMemorySlot].myChase.showWhatToSaveOptions) {
         
            if(memories[selectedMemorySlot].myChase.creatingChaseWithStepsInside()) {
              //Draw whatToSave checkboxes
              g.translate(0, 35);
              g.textAlign(LEFT);
              g.text("What to save:", 10, 125);
              g.translate(10, 132);
              cols = 2;
              rows = saveOptionButtonVariables.length/cols;
              for(int i = 0; i < saveOptionButtonVariables.length; i++) {
                g.pushMatrix();
                  g.translate(i / rows * 120, i % rows * 30);
                  mouse.declareUpdateElementRelative("MemoryCreationBox:wts" + i, "MemoryCreationBox", 0, 0, 120, 25, g);
                  mouse.setElementExpire("MemoryCreationBox:wts" + i, 2);
                  boxIsHover = mouse.elmIsHover("MemoryCreationBox:wts" + i);
                  g.fill(boxIsHover ? 210 : 200);
                  g.noStroke();
                  g.rect(0, 0, 25, 25, 4);
                  
                  if(mouse.isCaptured("MemoryCreationBox:wts" + i) && mouse.firstCaptureFrame) {
                    selectedWhatToSave[i] = !selectedWhatToSave[i];
                  }
                  if(selectedWhatToSave[i]) {
                    g.fill(0, 186, 240);
                    g.rect(4, 4, 17, 17, 4);
                  }
                  g.fill(10);
                  g.text(saveOptionButtonVariables[i], 30, 16);
                g.popMatrix();
              }
            }
          }
          
          if(!memories[selectedMemorySlot].myChase.showWhatToSaveOptions) {
                if(memories[selectedMemorySlot].myChase != null) {
                  g.pushMatrix();
                  g.translate(0, 100);
                    g.textAlign(LEFT);
                    { //Chase Input
                      g.text("Input Mode:", 10, 125);
                      g.fill(0, 186, 240); g.noStroke();
                      g.rect(110, 115, 12, 12, 1.5);
                      if(isHoverSimple(110, 115, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.inputModeUp();
                      }
                      g.rect(124, 115, 12, 12, 1.5);
                      if(isHoverSimple(124, 115, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.inputModeDown();
                      }
                      g.textSize(10);
                      g.fill(0);
                      g.text("+", 111.5, 124);
                      g.text("-", 125.5, 124);
                      g.text(memories[selectedMemorySlot].myChase.getInputModeDesc(), 10, 140);
                    }
                    { //Chase Output
                      g.textSize(12);
                      g.text("Output Mode:", 10, 175);
                      g.fill(0, 186, 240); g.noStroke();
                      g.rect(110, 165, 12, 12, 1.5);
                      if(isHoverSimple(110, 165, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.outputModeUp();
                      }
                      g.rect(124, 165, 12, 12, 1.5);
                      if(isHoverSimple(124, 165, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.outputModeDown();
                      }
                      g.textSize(10);
                      g.fill(0);
                      g.text("+", 111.5, 174);
                      g.text("-", 125.5, 174);
                      g.text(memories[selectedMemorySlot].myChase.getOutputModeDesc(), 10, 190);
                    }
                    { //Beat Mode
                      g.textSize(12);
                      g.text("Beat Mode:", 10, 225);
                      g.fill(0, 186, 240); g.noStroke();
                      g.rect(110, 215, 12, 12, 1.5);
                      if(isHoverSimple(110, 215, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.beatModeUp();
                      }
                      g.rect(124, 215, 12, 12, 1.5);
                      if(isHoverSimple(124, 215, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.beatModeDown();
                      }
                      g.textSize(10);
                      g.fill(0);
                      g.text("+", 111.5, 224);
                      g.text("-", 125.5, 224);
                      g.text(memories[selectedMemorySlot].myChase.beatMode, 10, 240);
                    }
                    { //Fade Mode
                      g.textSize(12);
                      g.text("Fade Mode:", 10, 275);
                      g.fill(0, 186, 240); g.noStroke();
                      g.rect(110, 265, 12, 12, 1.5);
                      if(isHoverSimple(110, 265, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.fadeModeUp();
                      }
                      g.rect(124, 265, 12, 12, 1.5);
                      if(isHoverSimple(124, 265, 12, 12, g, mouse) && mouse.isCaptured("MemoryCreationBox") && mouse.firstCaptureFrame) {
                        memories[selectedMemorySlot].myChase.fadeModeDown();
                      }
                      g.textSize(10);
                      g.fill(0);
                      g.text("+", 111.5, 274);
                      g.text("-", 125.5, 274);
                      g.text(memories[selectedMemorySlot].myChase.getFadeModeDesc(), 10, 290);
                    }
                    //Separator
                    g.stroke(120);
                    g.fill(120);
                    g.strokeWeight(2);
                    g.line(150, 110, 150, 260);
                    
                    { //fade
                      g.textSize(12);
                      g.fill(0);
                      g.text("Fade: " + memories[selectedMemorySlot].myChase.ownFade, 160, 125);
                      g.pushMatrix();
                        g.translate(160, 130);
                        memories[selectedMemorySlot].myChase.changeFade(quickSlider("MemoryCreationBox:fade", 10, memories[selectedMemorySlot].myChase.ownFade, g, mouse));
                      g.popMatrix();
                      
                    }
                g.popMatrix();
              
              }
          }
        break; //end of case 5
        case 6: //specialMemory
          g.pushMatrix();
          g.pushStyle();
          g.textAlign(LEFT);
            g.pushMatrix(); //SpecialType 0, type 0
                g.translate(30, 120+40*0);
                mouse.declareUpdateElementRelative("MemoryCreationBox:specialType0", "MemoryCreationBox", 0, 0, 120, 25, g);
                mouse.setElementExpire("MemoryCreationBox:specialType0", 2);
                boxIsHover = mouse.elmIsHover("MemoryCreationBox:specialType0");
                g.fill(soloBoxIsHover ? 210 : 200);
                g.noStroke();
                g.rect(0, 0, 25, 25, 4);
                
                if(mouse.isCaptured("MemoryCreationBox:specialType0") && mouse.firstCaptureFrame) {
                  memories[selectedMemorySlot].specialType = 0;
                  memories[selectedMemorySlot].type = 0;
                }
                if(memories[selectedMemorySlot].specialType == 0) {
                  g.fill(0, 186, 240);
                  g.rect(4, 4, 17, 17, 4);
                }
                g.fill(10);
                g.text("None", 50, 17);
            g.popMatrix();
            g.pushMatrix(); //SpecialType 1
                g.translate(30, 120+40*1);
                mouse.declareUpdateElementRelative("MemoryCreationBox:specialType1", "MemoryCreationBox", 0, 0, 120, 25, g);
                mouse.setElementExpire("MemoryCreationBox:specialType1", 2);
                boxIsHover = mouse.elmIsHover("MemoryCreationBox:specialType1");
                g.fill(soloBoxIsHover ? 210 : 200);
                g.noStroke();
                g.rect(0, 0, 25, 25, 4);
                
                if(mouse.isCaptured("MemoryCreationBox:specialType1") && mouse.firstCaptureFrame) {
                  memories[selectedMemorySlot].specialType = 1;
                  memories[selectedMemorySlot].type = 7;
                }
                if(memories[selectedMemorySlot].specialType == 1) {
                  g.fill(0, 186, 240);
                  g.rect(4, 4, 17, 17, 4);
                }
                g.fill(10);
                g.text("FullOn", 50, 17);
            g.popMatrix();
            
            g.pushMatrix(); //SpecialType 2
                g.translate(30, 120+40*2);
                mouse.declareUpdateElementRelative("MemoryCreationBox:specialType2", "MemoryCreationBox", 0, 0, 120, 25, g);
                mouse.setElementExpire("MemoryCreationBox:specialType2", 2);
                boxIsHover = mouse.elmIsHover("MemoryCreationBox:specialType2");
                g.fill(soloBoxIsHover ? 210 : 200);
                g.noStroke();
                g.rect(0, 0, 25, 25, 4);
                
                if(mouse.isCaptured("MemoryCreationBox:specialType2") && mouse.firstCaptureFrame) {
                  memories[selectedMemorySlot].specialType = 2;
                  memories[selectedMemorySlot].type = 7;
                }
                if(memories[selectedMemorySlot].specialType == 2) {
                  g.fill(0, 186, 240);
                  g.rect(4, 4, 17, 17, 4);
                }
                g.fill(10);
                g.text("BlackOut", 50, 17);
            g.popMatrix();
            
            g.pushMatrix(); //SpecialType 3
                g.translate(30, 120+40*3);
                mouse.declareUpdateElementRelative("MemoryCreationBox:specialType3", "MemoryCreationBox", 0, 0, 120, 25, g);
                mouse.setElementExpire("MemoryCreationBox:specialType3", 2);
                boxIsHover = mouse.elmIsHover("MemoryCreationBox:specialType3");
                g.fill(soloBoxIsHover ? 210 : 200);
                g.noStroke();
                g.rect(0, 0, 25, 25, 4);
                
                if(mouse.isCaptured("MemoryCreationBox:specialType3") && mouse.firstCaptureFrame) {
                  memories[selectedMemorySlot].specialType = 3;
                  memories[selectedMemorySlot].type = 7;
                }
                if(memories[selectedMemorySlot].specialType == 3) {
                  g.fill(0, 186, 240);
                  g.rect(4, 4, 17, 17, 4);
                }
                g.fill(10);
                g.text("StrobeNow", 50, 17);
            g.popMatrix();
          g.popStyle();
          g.popMatrix();
          
        break; //end of case 6
      }
    }
    g.popMatrix();
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
      case 3: //chase with steps inside
        memories[selectedMemorySlot].myChase.endCreatingChaseWidthStepsInside();
      break;
    }
    open = false;
    savingMemory = false;
  }
  
  //Returns whether box is hovered on
  boolean isMouseOver() {
    return isHoverSimple(width - (320 + 168), locY, 300, 300) && open;
  }
  
  int[] memoryModesToShow = { 0, 1, 2, 5, 6 };
  int sMm = 0;
  void addToSelectedMemoryMode() {
    if(sMm < 4) { sMm++; }
    else { sMm = 0; }
    selectedMemoryMode = memoryModesToShow[sMm];
  }
}




