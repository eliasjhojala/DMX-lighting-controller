
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
    } else throw new IllegalArgumentException(); // the two arrays have to be of same size, otherwise throw an IllegalArgumentException
    
  }
  
  int fixtureId = 0;
  void initiateForFixture(int fId) {
    fixtureId = fId;
    String[] acts = {"openBottomMenuControlBoxFromContextMenu", "openBottomMenuControlBoxForSelectedFs"};
    String[] labs = {"Control this", "Control all Selected"};
    initiate(acts, labs, mouseX, mouseY);
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
          boolean hovered = isHoverSimple(0, 0, 200, 22);
          if(hovered && mousePressed && mouseButton == LEFT) {
            execute(i);
          } else if (!hovered && mousePressed && mouseButton == LEFT) open = false;
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
  
  void execute(int optionId) {
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

Switch debugSw = new Switch();

class Switch {
  
  boolean state;
  color bg, fg;
  
  //Initailize with default settings
  Switch() {
    state = false;
    bg = color(45, 138, 179);
    fg = color(61, 190, 255);
  }
  
  //Initialize with state
  Switch(boolean state) {
    this.state = state;
    bg = color(45, 138, 179);
    fg = color(61, 190, 255);
  }
  
  //Initialize with custom colors
  Switch(boolean state, color bg, color fg) {
    this.state = state;
    this.bg = bg;
    this.fg = fg;
  }
  
  int animationState = 0;
  void draw() {
    if(state && animationState < 25) {
      animationState += 3;
    } else
    if(!state && animationState > 0) {
      animationState -= 3;
    }
    int animState = animationState;
    
    pushStyle(); pushMatrix();
    {
      //-db\
      translate(10, 50);
      //-/
      
      //background
      fill(80, 150);
      noStroke();
      rect(1.5, 1.5, 30, 10, 5);
      fill(multiplyColor(bg, float(constrain(animState, 15, 25)) / 25));
      rect(0, 0, 30, 10, 5);
      if(mousePressed && isHoverSimple(-3, -3, 36, 16)) {
        state = !state;
        mouseLocked = true;
        mouseLocker = "toggleSw";
      }
      
      //Knob
      fill(80, 120);
      translate(animState - 3, -3);
      ellipseMode(CORNER);
      ellipse(1.5, 1.5, 16, 16);
      fill(fg);
      ellipse(0, 0, 16, 16);
    }
    popStyle(); popMatrix();
    
  }
}



