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
    subWindows.add(new SubWindowContainer(colorPick, "HSB", 1000));
    subWindows.add(new SubWindowContainer(lowerMenu, "LowerMenu", 1000));
    subWindows.add(new SubWindowContainer(oscSettings, "OSCSettingsWindow", 1000));
    subWindows.add(new SubWindowContainer(midiWindow, "MidiHandlerWindow", 1000));
    
    
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
      acts = new String[] {"openBottomMenuControlBoxFromContextMenu", "openBottomMenuControlBoxForSelectedFs", "removeFixtureFromCM", "removeAllSelectedFixtures"};
      labs = new String[] {"Control this", "Control all selected", "Remove this", "Remove all selected"};
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
                
                g.translate(0, map(offset, 0, blocks.size()-maxNumberOfBlocks, 0, scrollBarBaseSize.y-scrollBarSize.y));
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
  PushButton(String name) {
    this.name = name;
  }
  
 
  
  boolean isPressed(PGraphics g, Mouse mouse) {
    g.pushMatrix();
    g.pushStyle();
    PVector size = new PVector(20, 20);
    
    mouse.declareUpdateElementRelative("button"+name, 10000000, 0, 0, round(size.x), round(size.y), g);
    mouse.setElementExpire("button"+name, 2);
    
    boolean hovered = mouse.elmIsHover("button"+name);
    boolean pressed = mouse.isCaptured("button"+name) && mouse.firstCaptureFrame;
    
    themes.button.setTheme(g, mouse, hovered, pressed);
    
    
    g.rect(0, 0, size.x, size.y, 4);
    g.popStyle();
    g.popMatrix();
    if(pressed) {
      return true;
    }
    return false;
  }
  
  boolean isPressed(PGraphics b, PGraphics g, Mouse mouse) {
    b.pushMatrix();
    b.pushStyle();
    PVector size = new PVector(20, 20);
    b.translate(20, 20);
    
    mouse.declareUpdateElementRelative("button"+name, 10000000, 0, 0, round(size.x), round(size.y), g);
    mouse.setElementExpire("button"+name, 2);
    
    boolean hovered = mouse.elmIsHover("button"+name);
    boolean pressed = mouse.isCaptured("button"+name) && mouse.firstCaptureFrame;
    
    themes.button.setTheme(b, mouse, hovered, pressed);
    
    
    b.rect(0, 0, size.x, size.y, 4);
    b.popStyle();
    b.popMatrix();
    if(pressed) {
      return true;
    }
    return false;
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
      button.draw(g, mouse, mouseName);
      g.translate(0, button.buttonSize*1.5);
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
