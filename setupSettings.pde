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
    tabs = new SettingsTab[1];
    tabs[0] = new SettingsTab("UI", this);
    tabs[0].setControllers(
      new SettingController[] {
        
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
  
  void setControllers(SettingController[] newControllers) {
    controllers = newControllers;
  }
  
  String text;
  int height_;
  
  SettingsTab(String text, int hght) {
    this.text = text;
    this.height_ = hght;
  }
  
  //If you just give reference to the parent SettingsWindow, height of the tab will be autamatcially inherited from it
  SettingsTab(String text, SettingsWindow parent) {
    this.text = text;
    this.height_ = parent.size - 60;
  }
  
  int getSelectorWidth() {
    return text.length() * 10;
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
    line(0, 18, 0, height_);
    if(controllers != null) {
    }
  }
}


class SettingController {
  Switch booleanController;
  IntSettingController intController;
  int mode; //0: switch, 1: numbox, 2: slider, 3: knob
  
  String name;
  String description;
  
  SettingController(int state, int type, String name, String description, SettingsTab parent) {
    intController = new IntSettingController(type, state);
    mode = type+1;
    this.name = name;
    this.description = description;
  }
  
  SettingController(boolean state, String name, String description, SettingsTab parent) {
    mode = 0;
    booleanController = new Switch(state, "settings:" + parent.text + ":" + name, "settings", 0, 0);
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
