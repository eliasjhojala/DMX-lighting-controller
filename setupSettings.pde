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

SettingsWindow settingsWindow = new SettingsWindow(true);

class SettingsWindow {
  
  SettingsWindow() {
    onInit();
  }
  
  SettingsWindow(boolean open) {
    this.open = open;
    onInit();
  }
  
  void onInit() {
    tabs = new SettingsTab[2];
    tabs[0] = new SettingsTab("UI", this);
    tabs[0].setControllers(
      new SettingController[] {
        new SettingController(false, "Text", "Yayyy longer description text right here!", tabs[0]),
        new SettingController(true, "The other text", "A really long description. It's interesting how busy I am but for some reason I still have time to write this long text.", tabs[0])
      }
    );
    tabs[1] = new SettingsTab("Other Settings", this);
    tabs[1].setControllers(
      new SettingController[] {
        new SettingController(false, "Text", "Yayyy longer description text right here!", tabs[1]),
        new SettingController(true, "The other text", "A really long description. It's interesting how busy I am but for some reason I still have time to write this long text.", tabs[1])
      }
    );
  }
  
  int locX, locY;
  
  boolean open;
  
  void open() {
    open = true;
  }
  
  SettingsTab[] tabs;
  
  final int size = 500;
  
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
  
  String text;
  int height_;
  
  SettingsTab(String text, int hght, SettingsWindow parent) {
    this.text = text;
    this.height_ = hght;
    parentWindow = parent;
  }
  
  //If you just give reference to the parent SettingsWindow, height of the tab will be autamatcially inherited from it
  SettingsTab(String text, SettingsWindow parent) {
    this.text = text;
    this.height_ = parent.size - 60;
    parentWindow = parent;
  }
  
  int getSelectorWidth() {
    pushStyle();
    textSize(16);
    int temp = int(textWidth(text));
    popStyle();
    return temp + 6;
  }
  
  //Return true if pressed
  boolean drawSelector(boolean selected) {
    int wid = getSelectorWidth();
    mouse.declareUpdateElementRelative("Settings:TabSelector:" + text, "settings", 0, 0, wid, 18);
    mouse.setElementExpire("Settings:TabSelector:" + text, 2);
    if(mouse.getElementByName("Settings:TabSelector:" + text).isHovered || selected) {
      //draw hover rect
      if(!selected) fill(255, 160);
        else fill(200, 160);
      noStroke();
      rect(1, -1, wid, 20, 4, 0, 0, 0);
    }
    textAlign(LEFT);
    textSize(16);
    fill(0);
    text(text, 3, 15);
    stroke(120);
    strokeWeight(2);
    line(0, 18, wid, 18);
    translate(wid, 0);
    line(0, 0, 0, 18);
    return mouse.isCaptured("Settings:TabSelector:" + text);
  }
  
  void drawChildren() {
    pushMatrix();
      line(0, 18, 0, height_);
      translate(6, 20);
      if(controllers != null) {
        for(SettingController contr : controllers) {
          contr.draw();
          translate(0, contr.getDrawHeight());
          stroke(0, 100);
          strokeWeight(1.5);
          line(0, -2, parentWindow.size - 28, -2);
        }
      }
    popMatrix();
  }
}


class SettingController {
  Switch booleanController;
  IntSettingController intController;
  
  SettingsTab parentTab;
  
  int mode; //0: switch, 1: numbox, 2: slider, 3: knob, /-4: textbox, 5: listbox-/
  
  String name;
  String description;
  
  SettingController(int state, int type, String name, String description, SettingsTab parent) {
    intController = new IntSettingController(type, state);
    mode = type+1;
    this.name = name;
    this.description = description;
    parentTab = parent;
  }
  
  SettingController(boolean state, String name, String description, SettingsTab parent) {
    mode = 0;
    booleanController = new Switch(state, "settings:" + parent.text + ":" + name, "settings", parent.parentWindow.size-70, 8);
    this.name = name;
    this.description = description;
    parentTab = parent;
  }
  
  int getDrawHeight() {
    //Return consumed height
    pushStyle();
    textSize(12);
    int temp = int(textWidth(description));
    popStyle();
    return 48 + temp / (parentTab.parentWindow.size-40) * 14;
  }
  
  //Returns true if value changed
  boolean draw() {
    switch(mode) {
      case 0:
        drawText(0, 0);
        booleanController.draw();
      break;
      case 1: case 2: case 3:
        drawText(0, 0);
      break;
    }
    return false;
  }
  
  void drawText(int x, int y) {
    pushMatrix();
      translate(x, y);
      textSize(24);
      fill(0);
      text(name, 0, 25);
      textSize(12);
      textLeading(14);
      fill(0, 200);
      text(description, 0, 26, parentTab.parentWindow.size-40, 40);
    popMatrix();
  }
}




class IntSettingController {
  int mode = 0; //0: numbox, 1: slider, 2: knob
  int state;
  IntSettingController(int mode, int state) {
    this.mode = mode;
    this.state = state;
  }
}
