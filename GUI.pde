//This tab contains classes and functions related to the GUI

class SubWindowContainer {
  //X and Y offset
  int x, y;
  int h, w;
  
  Mouse swMouse;
  
  PGraphics swBuffer;
  
  //Contained windows
  //MemoryCreationBox memoryCreation;
  //SettingsWindow settings;
  //LowerMenu lowerm;
  java.lang.Object window;
  Class windowClass;
  
  
  boolean reflectionCapable = true;
  
  
  
  SubWindowContainer(java.lang.Object window, String mouseName, int mousePriority) {
    this.window = window;
    windowClass = window.getClass();
    
    w = 0;
    h = 0;
    int locX = 0;
    int locY = 0;
    try {
      w = (int) windowClass.getDeclaredField("w").getInt(window);
      h = (int) windowClass.getDeclaredField("h").getInt(window);
      
      locX = (int) windowClass.getDeclaredField("locX").getInt(window);
      locY = (int) windowClass.getDeclaredField("locY").getInt(window);
    } catch(Exception e) {
      reflectionCapable = false;
      println("Error while creating SubWindowContainer " + this.toString() + ". Probably passed an incapable object as the window parameter!\n");
      e.printStackTrace();
    }
    
    swBuffer = createGraphics(w+3, h+3);
    
    
    x = locX; y = locY;
    swMouse = new Mouse(mouse, mouseName, mousePriority, x, y, w, h);
    
  }
  
  
  boolean draw() {
    if(isOpen() && reflectionCapable) {
      mouse.getElementByName(swMouse.bridgedModeName).enabled = true;
      getXY();
      
      swBuffer.beginDraw();
      swBuffer.clear();
      swBuffer.translate(1, 1);
      
      getXY();
      
      
      swMouse.refreshBridged(x, y, w, h, swBuffer);
      
      //memoryCreation.draw(swBuffer, swMouse, false);
      try {
        windowClass.getDeclaredMethod("draw", PGraphics.class, swMouse.getClass(), boolean.class)
          .invoke(window, swBuffer, swMouse, false);
      } catch(Exception e) {
        e.printStackTrace();
        reflectionCapable = false;
        println("Error while creating SubWindowContainer " + this.toString() + ". Probably passed an incapable object as the window parameter!\n");
      }
      
      swBuffer.endDraw();
      image(swBuffer, x, y);
      if(mouse.isCaptured(swMouse.bridgedModeName)) return true;
    } else { swMouse.bridgedModeParent.getElementByName(swMouse.bridgedModeName).enabled = false; swMouse.captured = false; }
    return false;
  }
  
  
  void getXY() {
    try {
      x = (int) windowClass.getDeclaredField("locX").getInt(window);
      y = (int) windowClass.getDeclaredField("locY").getInt(window);
      
      int tempW, tempH;
      tempW = (int) windowClass.getDeclaredField("w").getInt(window);
      tempH = (int) windowClass.getDeclaredField("h").getInt(window);
      if(w != tempW || h != tempH) { //size changed
        w = tempW;
        h = tempH;
        swBuffer = createGraphics(w+3, h+3);
      }
      
      
    } catch(Exception e) {
      
      reflectionCapable = false;
      println("Error while creating SubWindowContainer " + this.toString() + ". Probably passed an incapable object as the window parameter!\n");
      
      e.printStackTrace();
    }
  }
  
  boolean isOpen() {
    try {
      return (boolean) windowClass.getDeclaredField("open").getBoolean(window);
    } catch(Exception e) {
      
      reflectionCapable = false;
      println("Error while creating SubWindowContainer " + this.toString() + ". Probably passed an incapable object as the window parameter!\n");
      
      e.printStackTrace();
      return false;
    }
    
  }
  
}

SubWindowHandler subWindowHandler;

class SubWindowHandler {
  
  SubWindowHandler() {
    subWindows = new ArrayList<SubWindowContainer>();
    createDefaultWindows();
  }
  
  void createDefaultWindows() {
    subWindows.add(new SubWindowContainer(memoryCreator, "MemoryCreator", 1000));
    subWindows.add(new SubWindowContainer(settingsWindow, "SettingsWindow", 1000));
    subWindows.add(new SubWindowContainer(help, "HelpWindow", 1000));
    subWindows.add(new SubWindowContainer(colorWashMenu, "colorSelectBox", 1000));
    subWindows.add(new SubWindowContainer(colorPick, "HSBP", 1000));
    if(useNewLowerMenu) { subWindows.add(new SubWindowContainer(lowerMenu, "LowerMenu", 1000)); }
    subWindows.add(new SubWindowContainer(oscSettings, "OSCSettingsWindow", 1000));
    subWindows.add(new SubWindowContainer(midiWindow, "MidiHandlerWindow", 1000));
    subWindows.add(new SubWindowContainer(enttecOutputSettingsWindow, "enttecOutputSettingsWindow", 1000));
    subWindows.add(new SubWindowContainer(elementController, "elementController", 1000));
    subWindows.add(new SubWindowContainer(fixtureController, "fixtureController", 1000));
    subWindows.add(new SubWindowContainer(trussController, "trussController", 1000));
    subWindows.add(new SubWindowContainer(socketController, "socketController", 1000));
    
    subWindows.add(new SubWindowContainer(powerWindow, "powerWindow", 1000));
    subWindows.add(new SubWindowContainer(dimmerWindow, "dimmerWindow", 1000));
    
    
    
    
    
	
    
    subWindows.add(new SubWindowContainer(midiWindow.launchpadToggleOrPush, "launchpadToggleOrPush", 1000));
    subWindows.add(new SubWindowContainer(midiWindow.launchPadMemories, "launchPadMemories", 1000));
    subWindows.add(new SubWindowContainer(midiWindow.LC2412faderModes, "LC2412faderModes", 1000));
    subWindows.add(new SubWindowContainer(midiWindow.LC2412buttonModes, "LC2412buttonModes", 1000));
    subWindows.add(new SubWindowContainer(midiWindow.LC2412faderMemories, "LC2412faderMemories", 1000));
    subWindows.add(new SubWindowContainer(midiWindow.LC2412buttonMemories, "LC2412buttonMemories", 1000));
    
    if(useNewLowerMenu) { lowerMenu.open = false; }
    
  }
  
  ArrayList<SubWindowContainer> subWindows;
  
  void draw() {
    int toPutOnTop = -1;
    for(int i = subWindows.size()-1; i >= 0; i--) {
      SubWindowContainer sw = subWindows.get(i);
      setPriority(5100 - i, sw);
      if(sw.draw()) {
        toPutOnTop = i;
      }
      
    }
    
    if(toPutOnTop != -1) putOnTop(toPutOnTop);
  }
  
  void setPriority(int newPriority, SubWindowContainer sw) {
    mouse.getElementByName(sw.swMouse.bridgedModeName).priority = newPriority;
  }
  
  void putOnTop(int i) {
    ArrayList<SubWindowContainer> temp = new ArrayList<SubWindowContainer>(subWindows);
    for(int i_ = 0; i_ < i; i_++) {
      subWindows.set(i_+1, temp.get(i_));
    }
    subWindows.set(0, temp.get(i));
  }
  
  
}



CursorHandler cursor = new CursorHandler();
class CursorHandler {
  CursorHandler() {
  }
  
  int cursor;
  void set(int cur) {
    cursor = cur;
  }
  
  void push() {
    cursor(cursor);
    cursor = java.awt.Cursor.DEFAULT_CURSOR;
  }
}


//Window class

class Window {
  PVector size = new PVector(500, 500);
  java.lang.reflect.Field locX, locY;
  java.lang.reflect.Field open;
  
  
  
  
  java.lang.Object window;
  
  String name;
  
  boolean openChanged;
  
  Class windowClass;
  
  Window(String name, PVector size, java.lang.Object window) {
    this.name = name;
    this.size = size.get();
    windowClass = window.getClass();
    this.window = window;
    try {
      locX = windowClass.getDeclaredField("locX");
      locY = windowClass.getDeclaredField("locY");
      open = windowClass.getDeclaredField("open");
    }
    catch (Exception e) {
      e.printStackTrace();
      notifier.notify("Critical error loading window data", true);
    }
  }
  void draw(PGraphics g, Mouse mouse) {
    themes.window.setTheme(g, mouse);

    
    //Box itself
    g.rect(0, 0, size.x, size.y, 20);
    mouse.declareUpdateElementRelative(name, 1, 0, 0, round(size.x), round(size.y), g);
    mouse.setElementExpire(name, 2);
    
    //Grabable location button
    g.fill(180);
    g.noStroke();
    g.rect(10, 10, 20, 20, 20, 0, 0, 4);
    mouse.declareUpdateElementRelative(name+":move", name, 10, 10, 20, 20, g);
    mouse.setElementExpire(name+":move", 2);
    if(mouse.isCaptured(name+":move")) {
      try {
        int locXvalueToWindow = round(constrain(mouseX - pmouseX + locX.getInt(window), 40, width - (size.x+20+168)));
        locX.setInt(window, locXvalueToWindow);
        
        int locYvalueToWindow = round(constrain(mouseY - pmouseY + locY.getInt(window), 40, height - (size.y+40)));
        locY.setInt(window, locYvalueToWindow);
      }
      catch (Exception e) {
         e.printStackTrace();
         notifier.notify("Critical error with moving window", true);
      }
    }
    
    g.textSize(12);
    
    //Close button
    mouse.declareUpdateElementRelative(name+":close", name, 30, 10, 50, 20, g);
    mouse.setElementExpire(name+":close", 2);
    boolean cancelHover = mouse.elmIsHover(name+":close");
    g.fill(cancelHover ? 220 : 180, 30, 30);
    //Close if close is pressed
    if(mouse.isCaptured(name+":close")) {
      try {
        open.setBoolean(window, false);
      }
      catch (Exception e) {
        e.printStackTrace();
        notifier.notify("Critical error with closing window", true);
      }
    }
    g.rect(30, 10, 50, 20, 0, 4, 4, 0);
    g.fill(230);
    g.textAlign(CENTER);
    g.text("Close", 55, 24);
  }

}

//End of Window class


//////////////////////////////////////////////////////////////CONTEXT//MENU///////////////////////////////////////////////////////////////////////////////////////////////////
contextMenu contextMenu1 = new contextMenu(this);

class contextMenu {
  
  PApplet parent;
  contextMenuOption[] options;
  boolean open;
  
  int x, y; //locations on screen
  
  contextMenu(PApplet p) {
    open = false;
    x = 0; y = 0;
    parent = p;
    
  }
  
  //OPENING----------------------------------------------------------------------------------------------------\
  //Open menu using Strings to make the Methods
  void initiate(String[] actions, String[] lables, int x, int y) {
    if (actions.length == lables.length) {
      this.x = x ;
      this.y = y ;
      
      options = new contextMenuOption[actions.length];
      
      try {
        for (int i = 0; i < actions.length; i++) {
          options[i] = new contextMenuOption(parent.getClass().getMethod(actions[i]), lables[i]);
        }
      } catch(Exception e) { e.printStackTrace(); }
      open = true;
      declareMouseElement();
    } else throw new IllegalArgumentException(); // the two arrays have to be of same size, otherwise throw an IllegalArgumentException
  }
  
  //Open menu using ready-made methods (for greater control)
  void initiate(Method[] actions, String[] lables, int x, int y) {
    if (actions.length == lables.length) {
      this.x = x ;
      this.y = y ;
      
      options = new contextMenuOption[actions.length];
      
      try {
        for (int i = 0; i < actions.length; i++) {
          options[i] = new contextMenuOption(actions[i], lables[i]);
        }
      } catch(Exception e) { e.printStackTrace(); }
      open = true;
      declareMouseElement();
    } else throw new IllegalArgumentException(); // the two arrays have to be of same size, otherwise throw an IllegalArgumentException
    
  }
  
  void declareMouseElement() {
    mouse.removeElement("contextMenu");
    mouse.declareElement("contextMenu", 100000, x, y, x+200, y+22*options.length);
  }
  
  int fixtureId = 0;
  void initiateForFixture(int fId) {
    fixtureId = fId;
    String[] acts;
    String[] labs;
    if(!showMode && !showModeLocked) {
        acts = new String[] {"openBottomMenuControlBoxFromContextMenu", "openBottomMenuControlBoxForSelectedFs", "removeFixtureFromCM", "removeAllSelectedFixtures", "openFixtureSettings"};
        labs = new String[] {"Control this", "Control all selected", "Remove this", "Remove all selected", "Open fixture settings"};
    } else {
      acts = new String[] {"openBottomMenuControlBoxFromContextMenu", "openBottomMenuControlBoxForSelectedFs"};
      labs = new String[] {"Control this", "Control all selected"};
    }
    initiate(acts, labs, mouseX+2, mouseY+2);
  }
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -/
  
  void draw() {
    if (open) {
      pushMatrix();
      pushStyle();
      {
        translate(x, y);
        fill(200);
        stroke(120); strokeWeight(2);
        rect(0, 0, 200, 22*options.length);
        textSize(16);
        for(int i = 0; i < options.length; i++) {
          pushMatrix();
          translate(0, 22*i);
          boolean hovered = isHoverSimple(-2, -2, 204, 26);
          if(hovered && mousePressed && mouseButton == LEFT) {
            execute(i);
          } else if (!hovered && mousePressed && mouseButton == LEFT) close();
          fill(hovered ? 220 : 180);
          stroke(170); strokeWeight(1);
          rect(2, 2, 196, 18, 2);
          fill(0);
          text(options[i].title, 5, 17);
          
          
          popMatrix();
        }
      }
      popMatrix();
      popStyle();
    }
  }
  
  void close() {
    open = false;
    mouse.removeElement("contextMenu");
  }
  
  void execute(int optionId) {
    mouse.removeElement("contextMenu");
    open = false;
    try {
      options[optionId].action.invoke(parent);
    } catch(Exception e) { e.printStackTrace(); }
  }
  
}


class contextMenuOption {
  
  Method action;
  String title;
  
  contextMenuOption(Method action, String displayText) {
    this.action = action;
    title = displayText;
  }
  
  
}

//////////////////////////////////////////////////////////////////////////SWITCH////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Switch {
  
  boolean state;
  color bg, fg;
  
  String captureName;
  String ontopofName;
  
  int locX, locY;
  
  //Initailize with default settings
  Switch(int locX, int locY) {
    state = false;
    bg = color(45, 138, 179);
    fg = color(61, 190, 255);
    captureName = "switch";
    ontopofName = "main:move";
    this.locX = locX; this.locY = locY;
  }
  
  //Initialize with state
  Switch(boolean state, String captureName, String ontopofName, int locX, int locY) {
    this.state = state;
    bg = color(45, 138, 179);
    fg = color(61, 190, 255);
    this.captureName = captureName;
    this.ontopofName = ontopofName;
    this.locX = locX; this.locY = locY;
  }
  
  //Initialize with custom colors
  Switch(boolean state, color bg, color fg, String captureName, String ontopofName, int locX, int locY) {
    this.state = state;
    this.bg = bg;
    this.fg = fg;
    this.captureName = captureName;
    this.ontopofName = ontopofName;
    this.locX = locX; this.locY = locY;
  }
  
  boolean draw() {
    return drawToBuffer(g, g, mouse);
  }
  
  int animationState = 0;
  boolean drawToBuffer(PGraphics b, PGraphics g, Mouse mouse) {
    if(state && animationState < 19) {
      animationState += 3;
    } else
    if(!state && animationState > 0) {
      animationState -= 3;
    }
    int animState = animationState;
    
    b.pushStyle(); b.pushMatrix();
    {
      
      b.translate(locX, locY);
      
      if(inBds1D(b.screenY(0, 0), -13, b.height)) {
        //background
        b.fill(80, 150);
        b.noStroke();
        b.rect(1.5, 1.5, 30, 10, 5);
        b.fill(multiplyColor(bg, float(constrain(animState, 15, 25)) / 19));
        b.rect(0, 0, 30, 10, 5);
        g.pushMatrix();
          g.translate(b.screenX(0, 0), b.screenY(0, 0));
          mouse.declareUpdateElementRelative(captureName, ontopofName, -3, -3, 36, 16, g);
        g.popMatrix();
        mouse.setElementExpire(captureName, 2);
        if(mouse.isCaptured(captureName) && mouse.firstCaptureFrame) {
          state = !state;
        }
        
        //Knob
        b.fill(80, 120);
        b.translate(animState - 3, -3);
        b.ellipseMode(CORNER);
        b.ellipse(1.5, 1.5, 16, 16);
        b.fill(fg);
        b.ellipse(0, 0, 16, 16);
      }
      
    }
    b.popStyle(); b.popMatrix();
    
    return state;
  }
}


class DropdownMenu {
  color scrollBarColor = color(100, 100, 255);
  color scrollBarBaseColor = color(200, 200, 200);
  int scrollBarBaseStrokeWeight = 2;
  color scrollBarBaseStrokeColor = color(100, 100, 100);
  
  ArrayList<DropdownMenuBlock> blocks = new ArrayList<DropdownMenuBlock>();
  DropdownMenuBlock topBlock;
  String name;
  int selectedBlock;
  boolean open;
  boolean thisMenuIsHovered;
  boolean valueChanged;
  
  DropdownMenu(String name) {
    this.name = name;
    topBlock = new DropdownMenuBlock(name, 0);
  }
  DropdownMenu(String name, String[] blockNames, int[] blockValues) {
    this.name = name;
    topBlock = new DropdownMenuBlock(name, 0);
    addBlocks(blockNames, blockValues);
  }
  DropdownMenu(String name, ArrayList<DropdownMenuBlock> newBlocks) {
    this.name = name;
    topBlock = new DropdownMenuBlock(name, 0);
    blocks = newBlocks;
  }
  
  
  
  void draw() {
    draw(g, mouse);
  }
  
  float offset = 0;
  int maxNumberOfBlocks = 10;
  
  void draw(PGraphics g, Mouse mouse) {
    if(blocks != null) {
      int order = 0;
      valueChanged = false;
      g.pushMatrix();
        g.pushMatrix();
          drawTopBlock(g, mouse);
          if(open) {
            g.pushMatrix();
            g.pushStyle();
              g.fill(200, 200, 200);
              g.noStroke();
              g.rect(0, 0, blockSize.x, blockSize.y*maxNumberOfBlocks);
            g.popStyle();
            mouse.declareUpdateElementRelative(name, 1000000, 0, 0, round(blockSize.x), round(blockSize.y*maxNumberOfBlocks), g);
            mouse.setElementExpire(name, 2);
            thisMenuIsHovered = false;
              for(int id = 0; id < maxNumberOfBlocks; id++) {
                if(isBetween(round(id+offset), 0, blocks.size()-1)) {
                  if(blocks.get(round(id+offset)) != null) {
                    drawBlock(round(id+offset), order, g, mouse);
                    order++;
                  }
                }
              }
              g.popMatrix();
            
            g.pushMatrix();
              g.pushStyle();
                g.fill(scrollBarBaseColor);
                g.strokeWeight(scrollBarBaseStrokeWeight);
                g.stroke(scrollBarBaseStrokeColor);
                g.translate(blockSize.x+3, 0);
                
                PVector scrollBarBaseStartPoint = new PVector(0, 0);
                PVector scrollBarBaseSize = new PVector(15, blockSize.y*(maxNumberOfBlocks));
                mouse.declareUpdateElementRelative(name+"scrollBarBase", 1000000, scrollBarBaseStartPoint, scrollBarBaseSize, g);
                rect(scrollBarBaseStartPoint, scrollBarBaseSize, g);
                
                PVector scrollBarStartPoint = new PVector(0, 0);
                PVector scrollBarSize = new PVector(15, (blockSize.y*(maxNumberOfBlocks-1))/((blocks.size())/maxNumberOfBlocks));
                
                g.translate(0, map(offset, 0, blocks.size()-maxNumberOfBlocks, 0, scrollBarBaseSize.y-scrollBarSize.y));
                mouse.declareUpdateElementRelative(name+"scrollBar", 10000000, scrollBarStartPoint, scrollBarSize, g);
                mouse.setElementExpire(name+"scrollBar", 2);
                g.fill(scrollBarColor);
                rect(scrollBarStartPoint, scrollBarSize, g);
                if(mouse.isCaptured(name+"scrollBar")) {
                  offset += map(mouseY-pmouseY, 0, blockSize.y*(maxNumberOfBlocks), 0, blocks.size()-1);
                  constrainOffset();
                }
                if((mouse.elmIsHover(name) || thisMenuIsHovered) && scrolled) {
                  offset+=scrollSpeed;
                  constrainOffset();
                }
                
               
              g.popStyle();
            g.popMatrix();
          }
        g.popMatrix();
      g.popMatrix();
    }
  }
  
  void constrainOffset() {
    offset = constrain(offset, 0, blocks.size()-maxNumberOfBlocks);
  }
  
  PVector blockSize = new PVector(150, 20);
  PVector topBlockBigger = new PVector(10, 10);
  
  
  void drawTopBlock(PGraphics g, Mouse mouse) {
    PVector size = blockSize.get();
    size.x += topBlockBigger.x;
    size.y += topBlockBigger.y;
    g.pushMatrix();
      g.translate(-(topBlockBigger.x/2), -(topBlockBigger.y/2));
      size.x += 17; //This is because scrollbar
      topBlock.draw(size, name, -1, false, g, mouse);
      if(topBlock.isPressed()) {
        open = !open;
        setRightOffsetAccordingToId(selectedBlock);
      }
    g.popMatrix();
    g.translate(0, size.y);
  }
  
  void drawBlock(int id, int order, PGraphics g, Mouse mouse) {
    PVector size = blockSize.get();
    blocks.get(id).draw(size, name, id, selectedBlock == id, g, mouse);
    if(blocks.get(id).isPressed()) {
      if(open) {
        selectedBlock = id; //Save selected block id
        topBlock.setText(blocks.get(id).getText()); //Set topBlock text
        valueChanged = true;
        open = false; //Close menu when selected block
      }
    }
    if(blocks.get(id).isHovered()) {
      thisMenuIsHovered = true;
    }
    g.translate(0, size.y);
  }

  
  
  void setValue(int value) {
    for(int id = 0; id < blocks.size(); id++) {
      if(blocks.get(id) != null) {
        if(blocks.get(id).getValue() == value) {
          selectedBlock = id; //Save selected block id
          topBlock.setText(blocks.get(id).getText()); //Set topBlock text
          setRightOffsetAccordingToId(id);
          break;
        }
      }
    }
  } //End of setValue()
  
  void setText(String text) {
    for(int id = 0; id < blocks.size(); id++) {
      if(blocks.get(id) != null) {
        println(trim(blocks.get(id).getText()));
        println(trim(text));
        if(trim(blocks.get(id).getText()).equals(trim(text))) {
          selectedBlock = id; //Save selected block id
          topBlock.setText(blocks.get(id).getText()); //Set topBlock text
          setRightOffsetAccordingToId(id);
          break;
        }
      }
    }
  } //End of setValue()
  
  void setRightOffsetAccordingToId(int id) {
    offset = id-round(maxNumberOfBlocks/2);
    constrainOffset();
  }
  
  
  //Functions which could be used from outside class
  
  void addBlock(String text, int value) {
    DropdownMenuBlock newBlock = new DropdownMenuBlock(text, value);
    blocks.add(newBlock);
  }
  
  void addBlocks(String[] text, int[] value) {
    blocks = new ArrayList<DropdownMenuBlock>();
    for(int i = 0; i < min(text.length, value.length); i++) {
      addBlock(text[i], value[i]);
    }
  }
  
  int getValue() {
    return blocks.get(selectedBlock).value;
  }
  
  boolean valueHasChanged() {
    return valueChanged;
  }

  void setBlockSize(PVector size) {
    blockSize = size.get();
  }
  
  PVector getBlockSize() {
    return blockSize.get();
  }
  
  //End off functions which could be used from outside class
}

class DropdownMenuBlock {
  int value;
  String text;
  
  color bgColor = color(255, 255, 255);
  color hoveredBgColor = color(200, 200, 200);
  color pressedBgColor = color(100, 100, 100);
  color selectedBgColor = color(70, 70, 255);
 
  color textColor = color(0, 0, 0);
  color strokeColor = color(100, 100, 100);
  int strokeWeight = 2;
  
  boolean hovered, pressed;
  
  DropdownMenuBlock(String text, int value) {
    this.value = value;
    this.text = text;
  }
  
  String getText() {
    return text;
  }
  int getValue() {
    return value;
  }
  
  void setText(String text) {
    this.text = text;
  }
  void setValue(int value) {
    this.value = value;
  }
  
  
  
  void draw(PVector size, String parentName, int thisId, boolean selected, PGraphics g, Mouse mouse) {
    g.pushMatrix();
      g.pushStyle();
        
        { //Block
          PVector rectStartPoint = new PVector(0, 0);
          PVector rectSize = size.get();
          
          String blockNameForMouse = parentName+":block:"+str(thisId);
          
          mouse.declareUpdateElementRelative(blockNameForMouse, 10000000, round(rectStartPoint.x), round(rectStartPoint.y), round(rectSize.x), round(rectSize.y), g);
          mouse.setElementExpire(blockNameForMouse, 2);
          
          hovered = mouse.elmIsHover(blockNameForMouse);
          pressed = mouse.isCaptured(blockNameForMouse) && mouse.firstCaptureFrame;
          
          color fillColor = bgColor;
          if(pressed) {
            fillColor = pressedBgColor;
          }
          else if(hovered) {
            fillColor = hoveredBgColor;
          }
          else if(selected) {
            fillColor = selectedBgColor;
          }
          g.fill(fillColor);
          g.stroke(strokeColor);
          g.strokeWeight(strokeWeight);
          g.rect(rectStartPoint.x, rectStartPoint.y, rectSize.x, rectSize.y);
        
        
          { //Text
            g.pushStyle();
            g.textAlign(LEFT);
            g.fill(textColor);
            g.text(text, rectStartPoint.x+4, rectStartPoint.y+(size.y/2)+5);
            g.popStyle();
          } //End of text
        
        } //End of blcock
        
      g.popStyle();
    g.popMatrix();
  }
  
  boolean isHovered() {
    return hovered;
  }
  boolean isPressed() {
    return pressed;
  }
  
}

class PushButton {
  String name = "";
  PVector size = new PVector(20, 20);
  
  boolean hovered, pressed;
  
  PushButton(String name) {
    this.name = name;
  }
  PushButton(String name, PVector size) {
    this.name = name;
    this.size = size.get();
  }
  
 
  
  boolean isPressed(PGraphics g, Mouse mouse) {
    //Usually this function is used
    drawBeforeMouse(g, mouse);
    addMouseElement(g, mouse);
    drawAfterMouse(g, mouse);
    return pressed;
  }
  
  boolean isPressed(PGraphics b, PGraphics g, Mouse mouse) {
    //This function is made for settings (they are using PGraphics buffer)
    drawBeforeMouse(b, mouse);
    
    g.pushMatrix();
    g.translate(b.screenX(0, 0), b.screenY(0, 0));
    addMouseElement(g, mouse);
    g.popMatrix();
    
    drawAfterMouse(b, mouse);
    return pressed;
  }
  
  void drawBeforeMouse(PGraphics g, Mouse mouse) {
    g.pushMatrix();
    g.pushStyle();
  }
  void addMouseElement(PGraphics g, Mouse mouse) {
    mouse.declareUpdateElementRelative("button"+name, 10000000, 0, 0, round(size.x), round(size.y), g);
    mouse.setElementExpire("button"+name, 2);
    
    hovered = mouse.elmIsHover("button"+name);
    pressed = mouse.isCaptured("button"+name) && mouse.firstCaptureFrame;
  }
  void drawAfterMouse(PGraphics g, Mouse mouse) {
    themes.button.setTheme(g, mouse, hovered, pressed);
    g.pushStyle();
      g.fill(80, 150);
      g.noStroke();
      g.rect(size.x/20, size.y/20, size.x, size.y, min(size.x, size.y)/5);
    g.popStyle();
    g.pushStyle();
      g.noStroke();
      g.rect(0, 0, size.x, size.y, min(size.x, size.y)/5);
    g.popStyle();
    g.popStyle();
    g.popMatrix();
  }
}


RadioButtonMenu testRadio = new RadioButtonMenu();

class RadioButtonMenu {
  ArrayList<RadioButton> buttons = new ArrayList<RadioButton>();
  
  RadioButtonMenu() {

  }
  
  void addBlock(RadioButton button) {
    buttons.add(button);
  }
  
  boolean selectedChanged;
  int selectedId;
  
  void draw(PGraphics g, Mouse mouse) {
    for(int i = 0; i < buttons.size(); i++) {
      RadioButton button = buttons.get(i);
      String mouseName = this.toString() + str(i);

      if(button.selectedChanged) {
        if(button.selected) {
          selectedId = i;
          selectedChanged = true;
          button.selectedChanged = false;
        }
      }
      else {
        if(i != selectedId) {
          button.selected = false;
        }
      }
      
      button.draw(g, mouse, mouseName);
      g.translate(0, button.buttonSize*1.5);
    }
  }
  
  boolean valueHasChanged() {
    boolean toReturn = selectedChanged;
    selectedChanged = false;
    return toReturn;
  }
  
  int getValue() {
    return buttons.get(selectedId).getValue();
  }
  
  void setValue(int val) {
    for(int i = 0; i < buttons.size(); i++) {
      if(buttons.get(i).getValue() == val) {
        selectedId = i;
        selectedChanged = true;
        break;
      }
    }
  }
  
}



class RadioButton {
  
  RadioButton(String text, int value) {
    this.value = value;
    this.text = text;
  }
  
  boolean selected = false;
  boolean selectedChanged;
  int buttonSize;
  String text;
  int value;
  
  void draw(PGraphics g, Mouse mouse, String mouseName) {
    buttonSize = 20;
    mouse.declareUpdateElementRelative(mouseName, 100000, -(buttonSize/2), -(buttonSize/2), buttonSize, buttonSize, g);
    mouse.setElementExpire(mouseName, 2);
    boolean pressed = mouse.isCaptured(mouseName) && mouse.firstCaptureFrame;
    if(pressed) { selected = true; selectedChanged = true; }
    drawShapes(g, mouse, selected);
  }
  
  void drawShapes(PGraphics g, Mouse mouse, boolean selected) {
    g.pushMatrix();
      g.pushStyle();
        g.rectMode(CENTER);
        g.noFill();
        g.strokeWeight(buttonSize/5);
        g.stroke(themes.buttonColor.neutral);
        g.ellipse(0, 0, buttonSize, buttonSize);
        if(selected) {
          g.fill(themes.buttonColor.neutral);
          g.noStroke();
          g.ellipse(0.3, 0.3, buttonSize/2, buttonSize/2);
        }
        g.pushMatrix();
          g.pushStyle();
            g.textAlign(LEFT);
            g.rectMode(CORNER);
            g.fill(0);
            g.text(text, buttonSize*1.1, buttonSize/4);
          g.popStyle();
        g.popMatrix();
      g.popStyle();
    g.popMatrix();
  }
  
  int getValue() {
    return value;
  }
}

class IntController {
  int state;
  float floatState;
  String name;
  
  int defaultVal;
  
  boolean valueChanged;
  
  IntController(String name) {
    this.name = name;
  }
  
  void setState(int newState) {
    state = newState;
    floatState = newState;
  }
  
  int lo_limit = 0;
  int hi_limit = 1000;
  
  void draw(PGraphics g, Mouse mouse) {
    PGraphics b = g;
    b.pushMatrix(); b.pushStyle();
    if(inBds1D(b.screenY(0, 0), -50, b.height)) {

          //Numberbox
          //Background
          b.fill(themes.intControllerColor.neutral);
          b.stroke(multiplyColor(themes.intControllerColor.neutral, 0.7));
          g.pushMatrix(); pushMatrix();

            mouse.declareUpdateElementRelative(name, 10000, 0, 0, 100, 20, g);
            if(mouse.isCaptured(name) && mouseButton == LEFT) {
              floatState += (float(pmouseY - mouseY) / 20 * (abs(mouseX - screenX(0, 0)) / 20 + 1))*definition/10;
              floatState = constrain(floatState, lo_limit, hi_limit);
              if(round(floatState) != state) { valueChanged = true; }
              state = round(floatState/definition)*definition;
            }
          g.popMatrix(); popMatrix();
          
          b.strokeWeight(1.5);
          b.rect(0, 0, 100, 20);
          b.textAlign(RIGHT);
          b.fill(255);
          b.textSize(14);
          b.text(str(state), 2, 2, 96, 18);

      
      mouse.setElementExpire(name, 2);
      if(mouse.isCaptured(name) && mouseButton == RIGHT && mouse.firstCaptureFrame) {
        if(lastRMBc > millis() - 1000) { setState(defaultVal); valueChanged = true; } else lastRMBc = millis();
      }
    }
    b.popMatrix(); b.popStyle();
  }
  
  boolean valueHasChanged() {
    boolean toReturn = valueChanged;
    valueChanged = false;
    return toReturn;
  }
  
  int getValue() {
    return state;
  }
  
  void setValue(float val) {
    state = int(val);
    floatState = val;
  }
  
  
  int definition = 1;
  void setDefinition(int val) {
    definition = val;
  }
  
  void setLimits(int lo, int hi) {
    hi_limit = hi;
    lo_limit = lo;
  }
  
}


class CheckBox {
  
  CheckBox(String text) {
    this.text = text;
  }
  
  boolean selected = false;
  boolean selectedChanged;
  int buttonSize;
  String text;
  
  void draw(PGraphics g, Mouse mouse, String mouseName) {
    buttonSize = 20;
    mouse.declareUpdateElementRelative(mouseName, 100000, -(buttonSize/2), -(buttonSize/2), buttonSize, buttonSize, g);
    boolean pressed = mouse.isCaptured(mouseName) && mouse.firstCaptureFrame;
    if(pressed) { selected = !selected; selectedChanged = true; }
    drawShapes(g, mouse, selected);
  }
  
  void drawShapes(PGraphics g, Mouse mouse, boolean selected) {
    g.pushMatrix();
      g.pushStyle();
        g.rectMode(CENTER);
        g.noFill();
        g.strokeWeight(buttonSize/5);
        g.stroke(themes.buttonColor.neutral);
        g.rect(0, 0, buttonSize, buttonSize);
        if(selected) {
          g.fill(themes.buttonColor.neutral);
          g.noStroke();
          g.rect(0.3, 0.3, buttonSize/2, buttonSize/2);
        }
        g.pushMatrix();
          g.pushStyle();
            g.textAlign(LEFT);
            g.rectMode(CORNER);
            g.fill(0);
            g.text(text, buttonSize*1.1, buttonSize/4);
          g.popStyle();
        g.popMatrix();
      g.popStyle();
    g.popMatrix();
  }
  
  void setValue(boolean val) {
    selected = val;
  }
  
  boolean getValue() {
    return selected;
  }
  
  boolean valueHasChanged() {
    boolean toReturn = selectedChanged;
    selectedChanged = false;
    return toReturn;
  }
}


class NumberBox {
  
  NumberBox(String text, int min, int max) {
    this.text = text;
    minVal = min;
    maxVal = max;
  }
  
  int val = 0;
  int minVal = 0;
  int maxVal = 0;
  boolean selectedChanged;
  int buttonSize;
  String text;
  
  void draw(PGraphics g, Mouse mouse, String mouseName) {
    buttonSize = 20;
    mouse.declareUpdateElementRelative(mouseName, 100000, -(buttonSize/2), -(buttonSize/2), buttonSize, buttonSize, g);
    boolean pressed = mouse.isCaptured(mouseName) && mouse.firstCaptureFrame;
    if(pressed) { val = getNext(val, minVal, maxVal); selectedChanged = true; }
    drawShapes(g, mouse);
  }
  
  void drawShapes(PGraphics g, Mouse mouse) {
    g.pushMatrix();
      g.pushStyle();
        g.rectMode(CENTER);
        g.noFill();
        g.strokeWeight(buttonSize/10);
        g.stroke(themes.buttonColor.neutral);
        g.rect(1, 1, buttonSize-2, buttonSize-2);
        g.pushStyle();
          g.pushMatrix();
            g.translate(buttonSize/15, buttonSize/3);
            g.fill(0);
            g.text(str(val), 0, 0);
          g.popMatrix();
        g.popStyle();
        g.pushMatrix();
          g.pushStyle();
            g.textAlign(LEFT);
            g.rectMode(CORNER);
            g.fill(0);
            g.text(text, buttonSize*1.1, buttonSize/4);
          g.popStyle();
        g.popMatrix();
      g.popStyle();
    g.popMatrix();
  }
  
  void setValue(int val) {
    this.val = val;
  }
  
  int getValue() {
    return val;
  }
  
  boolean valueHasChanged() {
    boolean toReturn = selectedChanged;
    selectedChanged = false;
    return toReturn;
  }
}





/////TEXTBOX////////////TEXTBOX////////////////TEXTBOX//////////////TEXTBOX//////////////////////TEXTBOX///////////////////////TEXTBOX////////////


  final int TEXTBOX_MODE_TEXT = 1;
  final int TEXTBOX_MODE_NUMBER = 2;
  final int TEXTBOX_MODE_IP = 3;

boolean keyDown = false;

class TextBox {
  color textBoxColor = color(50, 100, 255);
  String originalText = "";
  String editedText = "";
  TextBox(String originalText, int mode) {
    this.originalText = originalText;
    this.editedText = originalText;
    this.mode = mode;
  }
  
  void keyPressed() {
    textBox();
  }
  
  PVector textBoxLocation = new PVector(0, 0);
  PVector textBoxSize = new PVector(200, 20);
  
  boolean ready;
  boolean textHasChanged;
  
  int mode;
  
  int lastKeyCode;
  long lastMillis;
  
  boolean thisIsActive;
  
  
  
  
  void drawToBuffer(PGraphics g, Mouse mouse, String mouseObjectName) {
    
    if(mouse.elmIsHover(mouseObjectName)) { thisIsActive = true; textBox(); }

    g.pushStyle();
    themes.textBox.setTheme(g, mouse, mouse.elmIsHover(mouseObjectName), false);
    g.strokeWeight(1.5);
    g.stroke(multiplyColor(themes.textBoxColor.neutral, 0.7));
    g.rect(textBoxLocation.x, textBoxLocation.y, textBoxSize.x, textBoxSize.y);
    g.popStyle();
    if(editedText != null) {
      g.pushStyle();
        g.fill(255);
        g.text(editedText, textBoxLocation.x+4, textBoxLocation.x+3, textBoxSize.x-5, textBoxSize.y);
      g.popStyle();
    }
  }
  


  
  void textBox() {
    if(thisIsActive) {
      if (key == BACKSPACE && keyReleased) {
        if(editedText.length() > 0) {
          editedText = editedText.substring(0, editedText.length()-1);
        }
        keyReleased = false;
        export();
      }
      else if (key == ENTER && keyReleased) {
        export();
      }
      else if(editedText.equals("null")) { editedText = ""; }
      if(keyIsAccepted()) {
        editedText = editedText+key;
        export();
      }
    }
  }
  
  void export() {
    ready = true;
    textHasChanged = true;
    keyReleased = false;
  }
  
   
  
  
  boolean keyIsAccepted() {
    boolean toReturn = false;
    if(keyCode != 157 && keyCode != 16 && keyCode != 17 && keyCode != 18 && keyCode != 0 && keyCode != 20 && keyCode != 9 && keyReleased) {
      lastKeyCode = keyCode;
      keyReleased = false;
      if(mode == TEXTBOX_MODE_TEXT) {
        toReturn = true;
      }
      else if(mode == TEXTBOX_MODE_NUMBER) {
        toReturn = ((int(str(key)) > 0 && int(str(key)) <= 9) || key == '0');
      }
      else if(mode == TEXTBOX_MODE_IP) {
        toReturn = ((int(str(key)) > 0 && int(str(key)) <= 9) || key == '0' || key == '.');
      }
    }
    return toReturn;
  }
  
  
  String getText() {
    if(ready == true) {
      ready = false;
      originalText = editedText;
      return editedText;
    }
    return originalText;
  }
  
  boolean textChanged() {
    boolean toReturn = textHasChanged;
    textHasChanged = false;
    return toReturn;
  }
  
  void setText(String text) {
    originalText = text;
    editedText = text;
  }
  
  void setValue(int value) {
    if(value != 0) {
      originalText = str(value);
    }
    else {
      originalText = "";
    }
    editedText = originalText;
  }
  
}


class TextBoxTableWindow {
  Window window;
  TextBox[][] cells;
  
  int locX, locY, w, h;
  boolean open;
  
  String name;
  
  TextBoxTableWindow(String name, int x_, int y_) {
    this.name = name;
    w = x_*21+100;
    h = y_*21+100;
    cells = new TextBox[x_][y_];
    for(int x = 0; x < cells.length; x++) {
      for(int y = 0; y < cells[x].length; y++) {
        cells[x][y] = new TextBox("", 2);
        cells[x][y].textBoxSize = new PVector(20, 20);
      }
    }
    window = new Window(name+"cellTable", new PVector(w, h), this);
  }
  
  int changedX, changedY;
  boolean valueChanged;
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    g.translate(50, 50);
    for(int x = 0; x < cells.length; x++) {
      for(int y = 0; y < cells[x].length; y++) {
        g.pushMatrix();
          g.translate(x*21, y*21);
          String mouseObjectName = name+"cellTable["+str(x)+"]["+str(y)+"]";
          mouse.declareUpdateElementRelative(mouseObjectName, 100000, 0, 0, 20, 20, g);
          mouse.setElementExpire(mouseObjectName, 2);
          cells[x][y].drawToBuffer(g, mouse, mouseObjectName);
          if(cells[x][y].textChanged()) {
            valueChanged = true;
            changedX = x;
            changedY = y;
          }
        g.popMatrix();
      }
    }
  }
  
  boolean valueHasChanged() {
     boolean toReturn = valueChanged;
     valueChanged = false;
     return toReturn;
   }
   
   int[] changedValue() {
     int[] toReturn = new int[2];
     toReturn[0] = changedX;
     toReturn[1] = changedY;
     return toReturn;
   }
  
  int getValue(int x, int y) {
    if(x >= 0 && x < cells.length) if(y >= 0 && y < cells[x].length) {
      return int(cells[x][y].getText());
    }
    return 0;
  }
  
  void setValue(int value, int x, int y) {
    if(x >= 0 && x < cells.length) if(y >= 0 && y < cells[x].length) {
      cells[x][y].setValue(value);
    }
  }
  
  void setValue(int[][] value) {
    for(int x = 0; x < value.length; x++) {
      for(int y = 0; y < value[x].length; y++) {
        setValue(value[x][y], x, y);
      }
    }
  }
  
  void setValue(int val[]) {
    for(int i = 0; i < val.length; i++) {
      setValue(val[i], i, 0);
    }
  }
}
