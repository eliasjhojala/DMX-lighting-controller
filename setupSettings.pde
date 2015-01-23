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
    tabs[0] = new SettingsTab("TestTab");
  }
  
  int locX, locY;
  
  boolean open;
  
  void open() {
    open = true;
  }
  
  SettingsTab[] tabs;
  
  final int size = 500;
  
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
        for(SettingsTab tab : tabs) {
          tab.drawSelector();
        }
      popMatrix();  }
      popMatrix();
      popStyle();
    }
  }
  
}


class SettingsTab {
  //A container for multiple settings
  SettingController[] controllers;
  
  String text;
  
  SettingsTab(String text) {
    this.text = text;
  }
  //Return true if pressed
  boolean drawSelector() {
    int wid = text.length() * 10;
    mouse.declareUpdateElementRelative("Settings:TabSelector:" + text, "settings", 0, 0, wid * 10);
    mouse.setExpire("Settings:TabSelector:" + text, 2);
    if(mouse.getElementByName("Settings:TabSelector:" + text).isHovered) {
      //---draw hover rect
    }
    textAlign(LEFT);
    textSize(16);
    text(text, 3, 15);
    stroke(120);
    strokeWeight(2);
    line(0, 18, text.length() * 10, 18);
    translate(text.length() * 10, 0);
    line(0, 0, 0, 18);
    return false;
  }
  
  void drawChildren() {
  }
}


class SettingController {
  BooleanSettingController booleanController;
  IntSettingController intController;
  SettingController() {
  }
}

class BooleanSettingController {
  
  String text;
  Switch controller;
  
  boolean setting;
  
  
  BooleanSettingController(String tx, boolean se) {
    text = tx;
    setting = se;
    controller = new Switch(se, "settings:" + text, "settings", 0, 0);
  }
  
  //Draws and returns true if boolean export changed
  boolean changed() {
    return false;
  }
}


class IntSettingController {
  int mode = 0; //0: numbox, 1: slider, 2: knob
  IntSettingController(int mode) {
    this.mode = mode;
  }
}
