//Tässä välilehdessä on koko ohjelman ydin, eli draw-loop
 
int oldMouseX1;
int oldMouseY1;

int grandMaster = 255;
int oldGrandMaster = 40;


boolean soloIsOn;

void draw() {
  if(programReadyToRun && !freeze) {

    for(int i = 0; i < fixtures.size(); i++) {
      if(fixtures.get(i) != null) {
        fixtures.get(i).soloInThisFixture = false;
      }
    }
    
    textSize(12);
    
    inputClass.draw();

    mouse.refresh();
    
    //Move this to setDimAndMemoryValuesAtEveryDraw, maybe?
    updateMemories();
    
    checkThemeMode();
    
    setDimAndMemoryValuesAtEveryDraw(); //Set dim and memory values
    if (arduinoFinished) thread("arduinoSend"); //Send dim-values to arduino, which sends them to DMX-shield
    
    drawMainWindow(); //Draw fixtures (tab main_window)
    
    if(!printMode) {
      ylavalikko(); //top menu
      alavalikko(); //bottom menu
      sivuValikko(); //right menu
      contextMenu1.draw();
    }

    
    if (useMaschine) calcMaschineAutoTap();
    
    //Invoke every fixtures draw
    //if(invokeFixturesDrawFinished) thread("invokeFixturesDraw");
    invokeFixturesDraw();
    drawColorWashMenu();
    
    subWindowHandler.draw();
    soloIsOn = false;
  }
}

boolean memoriesFinished = true;
void updateMemories() {
  memoriesFinished = false;
  memories[1].type = 4;
  memories[2].type = 5;
  for(int i = 0; i < memories.length; i++) { memories[i].draw(); }
  memoriesFinished = true;
}

