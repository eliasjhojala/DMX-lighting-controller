//Tähän välilehteen voi laittaa setup-komentoja, jotta main ei tule turhan täyteen
 
OscP5 oscP51; 
NetAddress myRemoteLocation1;

OscP5 oscP52;
NetAddress myRemoteLocation2;




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



  oscP51 = new OscP5(this, 5000);
  oscP52 = new OscP5(this, 5001);
  myRemoteLocation1 = new NetAddress("192.168.0.17",5001);
  myRemoteLocation2 = new NetAddress("192.168.0.12",50000);
  
  ansaWidth = int(width*0.6);
  
  fixtureInputs = new fixtureInput[2];
  
  for(int i = 0; i < fixtureInputs.length; i++) {
    fixtureInputs[i] = new fixtureInput();
  }
  
    fixtureForSelected[0] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  
}
