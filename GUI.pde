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
    //subWindows.add(new SubWindowContainer(lowerMenu, "LowerMenu", 1000));
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
    if(!showMode) {
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



