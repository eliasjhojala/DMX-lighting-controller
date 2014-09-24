//Tässä välilehdessä on koko ohjelman ydin, eli draw-loop

int oldMouseX1;
int oldMouseY1;

int grandMaster = 50;
int oldGrandMaster = 40;
void draw() {
  checkThemeMode();
  
  setDimAndMemoryValuesAtEveryDraw(); //Set dim and memory values
  arduinoSend(); //Send dim-values to arduino, which sends them to DMX-shield
  
  drawMainWindow(); //Draw fixtures (tab main_window)
  
  ylavalikko(); //top menu
  alavalikko(); //bottom menu
  sivuValikko(); //right menu
  
}
