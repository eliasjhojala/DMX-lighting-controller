//The main loop (void draw()) is located in this tab
 
int oldMouseX1;
int oldMouseY1;

int grandMaster = 255;
int oldGrandMaster = 40;


boolean soloIsOn;

boolean oldUse3D = false;

boolean useMidiMaschines = false;

float scrollSpeed = 0;
boolean scrolled;

boolean helpBoxOpen;


void draw() {
  checkShowMode();
  check3D();
  if(programReadyToRun && !freeze) {
    checkSolo();
    setTextSize();
    updateMidi();
    mouse.refresh();
    updateMemories();
    
    checkThemeMode();
    setDimAndMemoryValuesAtEveryDraw(); //Set dim and memory values
    
    sendDataToArduino();
    drawMainWindow(); //Draw main view (mainly fixtures)
    drawMenus();
    invokeFixturesDraw(); //Invoke every fixtures draw
    resetSolo();
    
    prompter.draw();
    cursor.push();
  }
  scrolledUp = false;
  scrolledDown = false;
  scrollSpeed = 0;
}

boolean memoriesFinished = true;
void updateMemories() {
  memoriesFinished = false;
  memories[1].type = 4;
  memories[2].type = 5;
  for(int i = 0; i < memories.length; i++) { memories[i].draw(); }
  memoriesFinished = true;
}

void checkShowMode() {
  if(showModeLocked) { showMode = true; }
  if(showMode) { printMode = false; }
}
void check3D() {
  if(use3D) { if(use3D != oldUse3D) { s1.loop(); f.setBounds(0, 0, displayWidth, displayHeight); oldUse3D = use3D; } }
  else { if(use3D != oldUse3D) { s1.noLoop(); f.setBounds(0, 0, 0, 0); oldUse3D = use3D; } }
}
void checkSolo() {
  if(soloIsOn) {
    for(int i = 0; i < fixtures.size(); i++) {
      if(fixtures.get(i) != null) {
        fixtures.get(i).soloInThisFixture = false;
      }
    }
  }
}
void setTextSize() {
  textSize(12);
}
void updateMidi() {
  if(useMidiMaschines) { inputClass.draw(); }
  if (useMaschine) { calcMaschineAutoTap(); }
}
void sendDataToArduino() {
  if (arduinoFinished) { thread("arduinoSend"); } //Send dim-values to arduino, which sends them to DMX-shield
}
void drawMenus() {
  if(!printMode) {
    ylavalikko(); //top menu
    alavalikko(); //bottom menu
    sivuValikko(); //right menu
    contextMenu1.draw();
    drawColorWashMenu();
    subWindowHandler.draw();
  }
}
void resetSolo() {
  soloIsOn = false;
}
