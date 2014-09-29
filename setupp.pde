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



  oscP51 = new OscP5(this, 5001);
  oscP52 = new OscP5(this, 5000);
  myRemoteLocation1 = new NetAddress("192.168.0.17",5001);
  myRemoteLocation2 = new NetAddress("192.168.0.11",5000);
  
  
  if(dataLoaded) {
    ansaWidth = max(xTaka)+80;
  }
}
