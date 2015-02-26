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
  for(int i = 0; i < 20; i++) {
    sockets[i] = new Socket(i, 2, i*100);
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
            nearestFoundSocket[i] = j;
          }
        }
        
      }
    }
    if(nearestFoundSocket[i] >= 0) {
      sockets[socketsInTruss[nearestFoundSocket[i]]].isInUse = true;
    }
 }
  
  return nearestFoundSocket;
}
