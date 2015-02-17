boolean initSettingsInSetupDone = false; 
int initSettingsInSetupStep;
int initSettingsInSetupSelected;




void initSettingsInSetup() {
  if(!initSettingsInSetupDone) {
    initSettingsInSetupDone = true; 
    useEnttec = false;
    useCOM = false;
    background(0);
    fill(255);
    textSize(15);
    if(initSettingsInSetupStep == 0 || initSettingsInSetupStep == 1) {
      if(initSettingsInSetupStep == 0) {
        text("Select COM port for enttec", 10, 20);
      }
      else if(initSettingsInSetupStep == 1) {
        text("Select COM port for Arduino", 10, 20);
      }
      if(scrolledUp) { initSettingsInSetupSelected++; scrolledUp = false; }
      if(scrolledDown) { initSettingsInSetupSelected--; scrolledDown = false; }
      for(int i = 0; i < getSerialList().length; i++) {
        if(initSettingsInSetupSelected == i) { fill(255, 0, 0); }
        text(getSerialList()[i], 10, i*20+50);
        if(initSettingsInSetupSelected == i) { fill(255); }
      }
      if(enterPressed) {
        if(initSettingsInSetupStep == 0) {
          useEnttec = true;
          enttecIndex = initSettingsInSetupSelected;
          initSettingsInSetupStep++;
        }
        else if(initSettingsInSetupStep == 1) {
          useCOM = true;
          arduinoIndex = initSettingsInSetupSelected;
          initSettingsInSetupDone = true;
          if(useEnttec) {
            myPort = new Serial(this, Serial.list()[enttecIndex], 115000);
          }
          if(useCOM) {
            try {
              arduinoPort = new Serial(this, Serial.list()[arduinoIndex], arduinoBaud);
            }
            catch(Exception e) {
              println("ERROR WITH DMX OUTPUT");
              useCOM = false;
            }
          }
        }
        enterPressed = false;
      }
      if(rightPressed) {
        initSettingsInSetupStep++;
        rightPressed = false;
      }
      if(leftPressed) {
        initSettingsInSetupStep--;
        leftPressed = false;
      }
    }
  }
}

String[] getSerialList() {
  return Serial.list();
}




////////////////////////////////////////SETTINGS//GUI///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SettingsWindow settingsWindow = new SettingsWindow(false);

class SettingsWindow {
  
  
  
  SettingsWindow() {
    onInit();
  }
  
  SettingsWindow(boolean open) {
    this.open = open;
    onInit();
  }
  
  //Create and configure all tabs & controllers
  void onInit() {
    tabs = new SettingsTab[5];
    tabs[0] = new SettingsTab("Other windows", this);
    tabs[0].setControllers(
      new SettingController[] {
        new SettingController(0, "Use 3D window", "The 3D window visualizes fixtures in a 3D space.", tabs[0]),
        new SettingController(1, "Use text window", "This window is handy for debug purposes.", tabs[0]),
        new SettingController(0, 0, "Test Int", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int1", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int2", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int3", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int4", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int5", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int6", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int7", "This is just a test controller to see how the int controller will work.", tabs[0]),
        new SettingController(0, 0, "Test Int8", "This is just a test controller to see how the int controller will work.", tabs[0])
      }
    );
    tabs[1] = new SettingsTab("Visualization", this);
    tabs[1].setControllers(
      new SettingController[] {
        new SettingController(2, "ShowMode", "When showMode is enabled, many features not intended for performace are disabled. Shortcut: (tgl)[M]", tabs[1]),
        new SettingController(3, "PrintMode", "Show the visualizer with a white background useful for printing. (NOTICE! Press ESC to exit printMode)", tabs[1]),
        new SettingController(3, 2, "View Rotation", "Adjust the rotation of the visualization.", tabs[1])
      }
    );
    tabs[2] = new SettingsTab("Chase", this);
    tabs[2].setControllers(
      new SettingController[] {
        new SettingController(4, "Blinky mode", "In blinky mode, EQ chases are handled differently. Go ahead and try it!", tabs[2])
      }
    );
    tabs[3] = new SettingsTab("COM", this);
    tabs[4] = new SettingsTab("OSC", this);
  }
  
  
  
  //Set & get external values (the values that the controllers control)
  //It's stupid we do it like this, but primitives.
  void setExternalBoValue(boolean b, int var) {
    switch(var) {
      case 0: use3D = b;               break;
      case 1: showOutputAsNumbers = b; break;
      case 2: showMode = b;            break;
      case 3: printMode = b;           break;
      case 4: s2l.blinky = b;          break;
    }
  }
  
  boolean getExternalBoValue(int var) {
    switch(var) {
      case 0:  return use3D;
      case 1:  return showOutputAsNumbers;
      case 2:  return showMode;
      case 3:  return printMode;
      case 4:  return s2l.blinky;
      default: return false;
    }
  }
  
  
  void setExternalInValue(int v, int var) {
    switch(var) {
      case 0: /*defaultZoom*/   break;
      case 1: /*defaultX*/      break;
      case 2: /*defaultY*/      break;
      case 3: pageRotation = v; break;
    }
  }
  
  int getExternalInValue(int var) {
    switch(var) {
      //case 0: return ;
      //case 1: return ;
      //case 2: return ;
      case 3:  return pageRotation;
      default: return 0;
    }
  }
  
  //X & Y location of the window (in the actual window)
  int locX, locY;
  
  //Is the window open
  boolean open;
  
  //Open the window
  void open() {
    open = true;
  }
  
  SettingsTab[] tabs;
  
  //The total width and height of the window (can be un-finalized, but you should only be change it on init)
  final int size = 500;
  
  //Currently selected tab
  int selectedTab = 0;
  
  
  void draw() {
    if(open) {
      pushMatrix();
      pushStyle();
      { // frame & frame controls
        translate(locX, locY);
        fill(255, 230);
        stroke(150);
        strokeWeight(3);
        
        //Box itself
        rect(0, 0, size, size, 20);
        mouse.declareUpdateElementRelative("settings", "main:move", 0, 0, size, size);
        mouse.setElementExpire("settings", 2);
        
        //Grabable location button
        fill(180);
        noStroke();
        rect(10, 10, 20, 20, 20, 0, 0, 4);
        mouse.declareUpdateElementRelative("settings:move", "settings", 10, 10, 20, 20);
        mouse.setElementExpire("settings:move", 2);
        if(mouse.isCaptured("settings:move")) {
          locY = constrain(mouseY - pmouseY + locY, 40, height - (size+40));
          locX = constrain(mouseX - pmouseX + locX, 40, width - (size + 20 + 168));
        }
        
        //Close button 
        mouse.declareUpdateElementRelative("settings:close", "settings", 30, 10, 50, 20);
        mouse.setElementExpire("settings:close", 2);
        boolean cancelHover = mouse.elmIsHover("settings:close");
        fill(cancelHover ? 220 : 180, 30, 30);
        //Close if close is pressed
        if(mouse.isCaptured("settings:close")) open = false;
        rect(30, 10, 50, 20, 0, 4, 4, 0);
        fill(230);
        textAlign(CENTER);
        text("Close", 55, 24);
        
        //Window title text
        fill(0, 220);
        textAlign(LEFT);
        text("Settings", 87, 24);
      }
      
      //Draw all tabs
      {  pushMatrix();
        translate(10, 40);
        
        pushMatrix();
          for(int i = 0; i < tabs.length; i++) {
            
            //Draw all tabs, if they return true, they demand to be selected
            if(tabs[i].drawSelector(selectedTab == i)) {
              selectedTab = i;
            }
            
          }
        popMatrix();
        //Draw the children of the selected tab
        tabs[selectedTab].drawChildren();
      popMatrix();  }
      popMatrix();
      popStyle();
    }
  }
  
}


class SettingsTab {
  //A container for multiple settings
  
  SettingController[] controllers;
  
  SettingsWindow parentWindow;
  
  void setControllers(SettingController[] newControllers) {
    controllers = newControllers;
  }
  //The text displayed on the tab selector
  String text;
  
  //Height and width of the area this tab can use for its children
  int height_;
  int width_;
  
  SettingsTab(String text, int hght, SettingsWindow parent) {
    this.text = text;
    this.height_ = hght;
    this.width_ = parent.size - 28;
    parentWindow = parent;
  }
  
  //If you just give reference to the parent SettingsWindow, height of the tab will be autamatcially derived from it
  SettingsTab(String text, SettingsWindow parent) {
    this.text = text;
    this.height_ = parent.size - 60;
    this.width_ = parent.size - 44;
    parentWindow = parent;
  }
  
  int getSelectorWidth() {
    pushStyle();
    textSize(16);
    int temp = int(textWidth(text));
    popStyle();
    return temp + 10;
  }
  
  //Draw the tab selector --- Returns true if pressed
  boolean drawSelector(boolean selected) {
    int wid = getSelectorWidth();
    mouse.declareUpdateElementRelative("Settings:TabSelector:" + text, "settings", 0, 0, wid, 20);
    mouse.setElementExpire("Settings:TabSelector:" + text, 2);
    if(mouse.getElementByName("Settings:TabSelector:" + text).isHovered || selected) {
      //draw hover rect
      if(!selected) fill(255, 160);
        else fill(200, 160);
      noStroke();
      rect(1, -1, wid, 22, 4, 0, 0, 0);
    }
    textAlign(LEFT);
    textSize(16);
    fill(0);
    text(text, 5, 15);
    stroke(120);
    strokeWeight(2);
    line(0, 20, wid, 20);
    translate(wid, 0);
    line(0, 0, 0, 20);
    return mouse.isCaptured("Settings:TabSelector:" + text);
  }
  
  //Total height of all the controllers
  int controllerStackHeight = 0;
  //Current scroll status (from 0 to 1)
  float scrollStatus = 0;
  //scrollStatus target, used for smooth-scroll
  float scrollStatusTrg = 0;
  boolean doSmoothScroll = false;
  
  void drawChildren() {
    pushMatrix();
      line(0, 20, 0, height_);
      translate(6, 20);
      
      if(controllers != null) {
        //Draw all children in a limited container, so they don't overflow
        PGraphics buffer = createGraphics(width_, height_-20);
        buffer.beginDraw();
        if(controllerStackHeight > height_-20) buffer.translate(0, -scrollStatus * (controllerStackHeight - height_+20));
        int stackHeight = 0;
        for(SettingController contr : controllers) {
          contr.draw(buffer);
          buffer.translate(0, contr.getDrawHeight());
          stackHeight += contr.getDrawHeight();
          buffer.stroke(0, 100);
          buffer.strokeWeight(1.5);
          buffer.line(0, -2, width_, -2);
        }
        controllerStackHeight = stackHeight;
        buffer.endDraw();
        image(buffer, 0, 0);
        
        //Draw scroll slider
        
        //If there's nothing to scroll (everything fits in at once), always stay on top.
        if(controllerStackHeight <= height_-20) scrollStatus = 0;
        translate(width_+7, 2);
        fill(180, 100); noStroke();
        rect(0, 0, 10, height_-20);
        mouse.declareUpdateElementRelative("settings:scroll", "settings", 0, 0, 10, height_-20);
        mouse.setElementExpire("settings:scroll", 2);
        if(mouse.isCaptured("settings:scroll")) {
          scrollStatus += (mouseY - pmouseY)/(float(height_)-20);
        }
        if(mouse.elmIsHover("settings")) {
          if(scrolledUp)   { scrollStatusTrg += 120/(float(height_)-20);
            doSmoothScroll = true;
            scrolledUp = false;
          }
          if(scrolledDown) { scrollStatusTrg -= 120/(float(height_)-20);
            doSmoothScroll = true;
            scrolledDown = false;
          }
        }
        if(doSmoothScroll)
          if(abs(scrollStatusTrg - scrollStatus) > 0.001) scrollStatus += (scrollStatusTrg - scrollStatus) / 3;
            else doSmoothScroll = false;
          else scrollStatusTrg = scrollStatus;
        scrollStatus = constrain(scrollStatus, 0, 1);
        scrollStatusTrg = constrain(scrollStatusTrg, 0, 1);
        if(controllerStackHeight > height_-20) {
          translate(0, scrollStatus * (height_-20 - 40));
          fill(180, 180);
          rect(0, 0, 10, 40);
        }
      }
    popMatrix();
  }
}


class SettingController {
  Switch booleanController;
  IntSettingController intController;
  
  boolean oldValueBoolean;
  int oldValueInt;
  
  SettingsTab parentTab;
  
  int var;
  
  int mode; //0: switch, 1: numbox, 2: slider, 3: knob, /-4: textbox, 5: listbox-/
  
  String name;
  String description;
  
  SettingController(int var, int type, String name, String description, SettingsTab parent) {
    intController = new IntSettingController(type, 0, parent.width_-106, 8, this);
    mode = type+1;
    this.name = name;
    this.description = description;
    this.var = var;
    parentTab = parent;
  }
  
  SettingController(int var, String name, String description, SettingsTab parent) {
    mode = 0;
    booleanController = new Switch(false, "settings:" + parent.text + ":" + name, "settings", parent.width_-42, 8);
    this.name = name;
    this.description = description;
    this.var = var;
    parentTab = parent;
  }
  
  int getDrawHeight() {
    //Return consumed height
    pushStyle();
    textSize(12);
    int temp = int(textWidth(description));
    popStyle();
    //         (compute height of description text)
    return 48 + temp / (parentTab.width_-12) * 14 + (mode >= 1 ? 10 : 0);
  }
  
  
  void draw(PGraphics buffer) {
    switch(mode) {
      case 0:
        drawText(0, 0, buffer);
        booleanController.drawToBuffer(buffer);
        if(booleanController.state != oldValueBoolean) {
          //Set
          parentTab.parentWindow.setExternalBoValue(booleanController.state, var);
          oldValueBoolean = booleanController.state;
        } else {
          //Get
          booleanController.state = parentTab.parentWindow.getExternalBoValue(var);
          oldValueBoolean = booleanController.state;
        }
      break;
      case 1: case 2: case 3:
        drawText(0, 0, buffer);
        intController.drawToBuffer(buffer);
        if(intController.state != oldValueInt) {
          //Set
          parentTab.parentWindow.setExternalInValue(intController.state, var);
          oldValueInt = intController.state;
        } else {
          //Get
          intController.setState(parentTab.parentWindow.getExternalInValue(var));
          oldValueInt = intController.state;
        }
      break;
    }
  }
  
  void drawText(int x, int y, PGraphics buffer) {
    buffer.pushMatrix();
      buffer.translate(x, y);
      buffer.textSize(24);
      buffer.fill(0);
      buffer.text(name, 0, 25);
      buffer.textSize(12);
      buffer.textLeading(14);
      buffer.fill(0, 200);
      //                                If int controller, use up 10px more
      buffer.text(description, 0, 26 + (mode >= 1 ? 10 : 0), parentTab.width_-12, 40);
    buffer.popMatrix();
  }
}







class IntSettingController {
  int mode = 0; //0: numbox, 1: slider, 2: knob
  int state;
  float floatState;
  
  int min, max;
  
  SettingController parentContainer;
  
  int x, y;
  
  IntSettingController(int mode, int state, int x_offs, int y_offs, SettingController parent) {
    this.mode = mode;
    this.state = state;
    x = x_offs;
    y = y_offs;
    parentContainer = parent;
  }
  
  void setState(int newState) {
    state = newState;
    floatState = newState;
  }
  
  void draw() {
    drawToBuffer(g);
  }
  
  
  void drawToBuffer(PGraphics b) {
    b.pushMatrix(); b.pushStyle();
    b.translate(x, y);
    if(inBds1D(b.screenY(0, 0), -50, b.height)) {
      switch(mode) {
        case 0:
          //Numberbox
          //Background
          b.fill(45, 138, 179);
          b.stroke(20, 100, 130);
          pushMatrix();
            translate(b.screenX(0, 0), b.screenY(0, 0));
            mouse.declareUpdateElementRelative("settings:" + parentContainer.name, "settings", 0, 0, 100, 20);
            if(mouse.isCaptured("settings:" + parentContainer.name) && mouseButton == LEFT) {
              floatState += float(pmouseY - mouseY) / 10 * (abs(mouseX - screenX(0, 0)) / 20 + 1);
              state = round(floatState);
            }
          popMatrix();
          
          b.rect(0, 0, 100, 20);
          b.textAlign(RIGHT);
          b.fill(255);
          b.textSize(14);
          b.text(str(state), 2, 2, 96, 18);
          
        break;
        case 2:
          //Knob
          
          b.ellipseMode(CENTER);
          b.translate(78, 19.5);
          pushMatrix();
            translate(b.screenX(0, 0), b.screenY(0, 0));
            mouse.declareUpdateElementRelative("settings:" + parentContainer.name, "settings", -25, -25, 50, 50);
            if(mouse.isCaptured("settings:" + parentContainer.name) && mouseButton == LEFT) {
              PVector vec = new PVector(mouseX - screenX(0, 0), mouseY - screenY(0, 0));
              floatState = ((vec.heading() + TWO_PI + HALF_PI) % TWO_PI) / TWO_PI * 360;
              state = round(floatState);
            }
          popMatrix();
          
          b.fill(topMenuTheme2);
          b.stroke(topMenuAccent);
          //Radial visualizer
          b.arc(0, 0, 50, 50, -HALF_PI, (floatState/360*TWO_PI) - HALF_PI, PIE);
          
          //Text container
          b.fill(45, 138, 179);
          b.stroke(20, 100, 130);
          b.ellipse(0, 0, 30, 30);
          
          
          
          b.textAlign(CENTER);
          b.fill(255);
          b.textSize(14);
          b.text(str(state), 0, 5);
          //Active portion
          //b.fill(61, 190, 255);
        break;
      }
      
      mouse.setElementExpire("settings:" + parentContainer.name, 2);
      if(mouse.isCaptured("settings:" + parentContainer.name) && mouseButton == RIGHT && mouse.firstCaptureFrame) {
        if(lastRMBc > millis() - 1000) setState(0); else lastRMBc = millis();
      }
    }
    b.popMatrix(); b.popStyle();
  }
  
}
