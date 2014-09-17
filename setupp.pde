//Tähän välilehteen voi laittaa setup-komentoja, jotta main ei tule turhan täyteen

OscP5 oscP51;
NetAddress myRemoteLocation1;

OscP5 oscP52;
NetAddress myRemoteLocation2;
boolean loadAllDataInSetup = true;

int leveys;
int korkeus;
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


  // start oscP5, telling it to listen for incoming messages at port 5001 */
  oscP51 = new OscP5(this,5001);
 
  // set the remote location to be the localhost on port 5001
  myRemoteLocation1 = new NetAddress("192.168.0.11",5001);


 oscP52 = new OscP5(this,5001);
  // set the remote location to be the localhost on port 5001
  myRemoteLocation2 = new NetAddress("192.168.0.17",5000);

}
