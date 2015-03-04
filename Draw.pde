<<<<<<< HEAD
//Tässä välilehdessä on koko ohjelman ydin, eli draw-loop

int[] midiNotesWithoutBlacks = { 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 27, 28, 29, 30, 31 };
boolean wasAt64 = false;
=======
//The main loop (void draw()) is located in this tab
>>>>>>> XML+3D
 
int oldMouseX1;
int oldMouseY1;

int grandMaster = 255;
int oldGrandMaster = 40;

<<<<<<< HEAD
long[] totalMillis = new long[9];


=======

boolean soloIsOn;

boolean oldUse3D = false;

boolean useMidiMaschines = false;

float scrollSpeed = 0;
boolean scrolled;
>>>>>>> XML+3D

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
