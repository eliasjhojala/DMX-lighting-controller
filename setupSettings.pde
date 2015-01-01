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
  }
  
  SettingsWindow(boolean open) {
    this.open = open;
  }
  
  int locX, locY;
  
  boolean open;
  
  
  
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
        
      }
      
      {
        
      }
      popMatrix();
      popStyle();
    }
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
    
  }
}
