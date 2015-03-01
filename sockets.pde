Socket[] sockets = new Socket[50];

class Socket {
  int truss, id, x_location, channel;
  boolean isInUse = false;
  boolean exist = false;
  
  Socket(int number, int parentTruss, int x) {
    truss = parentTruss;
    id = number;
    x_location = x;
    exist = true;
  }
  Socket() {
  }
  
  
}

void createSockets() {
  for(int i = 0; i < 30; i++) {
    sockets[i] = new Socket(i, 2, i*100);
  }
}

boolean savingNearestSocketsToXML = false;
void saveNearestSocketsToXML() {
  savingNearestSocketsToXML = true;
  saveXML(getNearestSocketsAsXML(), "XML/nearestSockets.xml");
  savingNearestSocketsToXML = false;
}

XML getNearestSocketsAsXML() {
  String data = "<NearestSockets></NearestSockets>";
  XML xml = parseXML(data);
  for(int truss = 0; truss < trusses.length; truss++) {
    xml = xml.addChild("truss");
    xml.setInt("id", truss);
    int[] fixturesInTruss = getListOfFixturesInTruss(truss);
    int[] socketsInTruss = getListOfSocketsInTruss(truss);
    for(int i = 0; i < findNearestSocket(truss).length; i++) {
      if(findNearestSocket(truss)[i] >= 0) {
        XML block = xml.addChild("socket");
        block.setInt("id", i);
        block.setContent("H"+str(sockets[findNearestSocket(truss)[i]].id));
        block.setInt("fixture", fixturesInTruss[i]);
        block.setInt("channel", sockets[findNearestSocket(truss)[i]].channel);
      }
    }
    xml = xml.getParent();
  }
  return xml; 
}

void saveSocketsToXML() {
  String data = "<Sockets></Sockets>";
  XML xml = parseXML(data);
  for(int i = 0; i < sockets.length; i++) {
    Socket socket = sockets[i];
    if(socket != null) {
      XML block = xml.addChild("Socket");
      block.setInt("id", i);
      block.setInt("number", socket.id);
      block.setInt("truss", socket.truss);
      block.setInt("x_location", socket.x_location);
      block.setInt("channel", socket.channel);
      block.setInt("isInUse", int(socket.isInUse));
      block.setInt("exist", int(socket.exist));
    }
  }
  saveXML(xml, "XML/sockets.xml");
}

void loadSocketsFromXML() {
  XML xml = loadXML("XML/sockets.xml");
  //XML socketss = xml.getChild("Sockets");
  XML[] socket = xml.getChildren("Socket");
  for(int i = 0; i < socket.length; i++) {
    int id = socket[i].getInt("id");
    sockets[id] = new Socket();
    sockets[id].truss = socket[i].getInt("truss");
    sockets[id].id = socket[i].getInt("number");
    sockets[id].x_location = socket[i].getInt("x_location");
    sockets[id].channel = socket[i].getInt("channel");
    sockets[id].isInUse = boolean(socket[i].getInt("isInUse"));
    sockets[id].exist = boolean(socket[i].getInt("exist"));
    sockets[id].isInUse = false ;
  }
}

int[] getListOfFixturesInTruss(int truss) {
  int counter = 0;
  int[] fixturesInTruss = new int[1];
  for(int i = 0; i < fixtures.size(); i++) {
    fixture fix = fixtures.get(i);
    if(fixtureIsDrawnById(i)) { //check if fixture exist in visualisation
      if(fix.parentAnsa == truss) { //Check if fixture is in current truss
        fixturesInTruss[counter] = i;
        counter++;
        int[] fixturesInTrussTemp = new int[fixturesInTruss.length];
        arrayCopy(fixturesInTruss, fixturesInTrussTemp);
        fixturesInTruss = new int[fixturesInTruss.length+1];
        arrayCopy(fixturesInTrussTemp, fixturesInTruss);
      }
    }
  }
  
  return fixturesInTruss;
}


int[] getListOfSocketsInTruss(int truss) {
  int counter = 0;
  int[] socketsInTruss = new int[1];
  for(int i = 0; i < sockets.length; i++) {
    Socket socket = sockets[i];
    if(socket != null) {
      if(socket.exist) { //check if fixture exist in visualisation
        if(socket.truss == truss) { //Check if fixture is in current truss
          socketsInTruss[counter] = i;
          counter++;
          int[] socketsInTrussTemp = new int[socketsInTruss.length];
          arrayCopy(socketsInTruss, socketsInTrussTemp);
          socketsInTruss = new int[socketsInTruss.length+1];
          arrayCopy(socketsInTrussTemp, socketsInTruss);
        }
      }
    }
  }
  
  return socketsInTruss;
}



int[] findNearestSocket(int truss) {
  int[] fixturesInTruss = getListOfFixturesInTruss(truss);
  int[] socketsInTruss = getListOfSocketsInTruss(truss);
  int[] nearestFoundSocket = new int[fixturesInTruss.length];
  
  
  for(int i = 0; i < fixturesInTruss.length; i++) {
    int nearestFoundDistance = Integer.MAX_VALUE;
    nearestFoundSocket[i] = -1;
    fixture fix = fixtures.get(fixturesInTruss[i]);
    for(int j = 0; j < socketsInTruss.length; j++) {
      if(sockets[socketsInTruss[j]] != null) {
        Socket socket = sockets[socketsInTruss[j]];
        if((!socket.isInUse) || (socket.channel == fix.channelStart)) {
          if(abs(socket.x_location - fix.x_location) <= nearestFoundDistance) {
            nearestFoundDistance = abs(socket.x_location - fix.x_location);
            nearestFoundSocket[i] = socketsInTruss[j];
          }
        }
        
      }
    }
    if(nearestFoundSocket[i] >= 0) {
      sockets[nearestFoundSocket[i]].isInUse = true;
      sockets[nearestFoundSocket[i]].channel = fix.channelStart;
    }
 }
  
  return nearestFoundSocket;
}
