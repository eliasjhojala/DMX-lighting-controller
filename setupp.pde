//Tähän välilehteen voi laittaa setup-komentoja, jotta main ei tule turhan täyteen

OscP5 oscP51;
NetAddress myRemoteLocation1;

OscP5 oscP52;
NetAddress myRemoteLocation2;




boolean loadAllDataInSetup = true;

public int leveys;
public int korkeus;
void setuppi() {

  
  leveys = displayWidth;
  korkeus = displayHeight;
  loadSetupData();
  if(loadAllDataInSetup == true) {
    loadAllData();
  }
  setFixtureChannelsAtSoftwareBegin();
  if(userId == 1) { //Jos Elias käyttää
    getPaths = false; //Ei oteta polkuja tiedostosta
  }
  else { //Jos Roope käyttää
    getPaths = true; //Otetaan polut tiedostosta
  }



  oscP51 = new OscP5(this, 5000);
  oscP52 = new OscP5(this, 5001);
  myRemoteLocation1 = new NetAddress("192.168.0.17",5001);
  myRemoteLocation2 = new NetAddress("192.168.0.13",50000);
  
  ansaWidth = int(width*0.6);
  
  fixtureInputs = new fixtureInput[2];
  
  for(int i = 0; i < fixtureInputs.length; i++) {
    fixtureInputs[i] = new fixtureInput(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }
  

  
}
