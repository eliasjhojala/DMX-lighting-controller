//Tähän välilehteen voi laittaa setup-komentoja, jotta main ei tule turhan täyteen
OscP5 oscP52;

void setuppi() {
  createMemoryObjects();
  createSockets();
  createMidiClasses();
  
  if(loadAllDataInSetup) { loadAllData(); }
  else { programReadyToRun = true; }
  
  thread("setFixtureChannelsAtSoftwareBegin");

  oscP52 = new OscP5(this, 5001);

  fixtureForSelected[0] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  
   
  elementsSetup();
  doAfterLoad();
}

void doAfterLoad() {
  socketController.updateTrusses();
  fixtureController.updateSockets();
  fixtureController.updateTrusses();
}
