//Tähän välilehteen voi laittaa setup-komentoja, jotta main ei tule turhan täyteen

OscP5 oscP52;





boolean loadAllDataInSetup = true;

public int leveys;
public int korkeus;
void setuppi() {
   createMemoryObjects();

  leveys = displayWidth;
  korkeus = displayHeight;
  loadSetupData();
  if(loadAllDataInSetup == true) {
    thread("loadAllData");
  }
  thread("setFixtureChannelsAtSoftwareBegin");


  oscP52 = new OscP5(this, 5001);
  
  ansaWidth = int(width*0.6);
  
 
    fixtureForSelected[0] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  
}
