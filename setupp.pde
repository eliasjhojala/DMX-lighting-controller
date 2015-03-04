//Tähän välilehteen voi laittaa setup-komentoja, jotta main ei tule turhan täyteen

OscP5 oscP52;



boolean loadAllDataInSetup = true;

void setuppi() {
  createMemoryObjects();
  createSockets();
  thread("createMidiClasses");
  thread("loadSetupData");
  thread("loadAllData");
  thread("setFixtureChannelsAtSoftwareBegin");

  oscP52 = new OscP5(this, 5001);

  fixtureForSelected[0] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}
