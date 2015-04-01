SocketController socketController = new SocketController();

class SocketController {
  Window window;
  int locX, locY, w, h;
  boolean open;
  
  Socket socket;
  
  TextBox socketName;
  DropdownMenu parentTruss;
  
  SocketController() {
    w = 500;
    h = 500;
    window = new Window("socketController", new PVector(w, h), this);
    
    socketName = new TextBox("", 1);
    
    ArrayList<DropdownMenuBlock> blocks = new ArrayList<DropdownMenuBlock>();
    if(trusses != null) {
      for(int i = 0; i < trusses.length; i++) {
        blocks.add(new DropdownMenuBlock("Truss " + str(i), i));
      }
      if(blocks != null) parentTruss = new DropdownMenu("SocketParentTruss", blocks);
    }
  }
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    g.translate(60, 60);
    if(socket != null) {
      String mouseObjectName = "SocketControllerTextBoxSocketName" + this.toString();
      mouse.declareUpdateElementRelative(mouseObjectName, 100000, 0, 0, 30, 20, g);
      mouse.setElementExpire(mouseObjectName, 2);
      socketName.textBoxSize.x = 30;
      socketName.drawToBuffer(g, mouse, mouseObjectName);
      
      if(socketName.textChanged()) socket.name = socketName.getText();
      if(!socketName.getText().equals(socket.name)) socketName.setText(socket.name);
      g.translate(0, 60);
      if(parentTruss != null) {
        parentTruss.draw(g, mouse);
        if(parentTruss.valueHasChanged()) {
          socket.truss = parentTruss.getValue();
        }
      }
    }
  }
}

ArrayList<Socket> sockets = new ArrayList<Socket>();

class Socket {
  int truss, id, x_location, channel;
  boolean isInUse = false;
  boolean exist = false;
  String name = "";
  
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
}

void addNewSocket() {
  Socket socket = new Socket();
  socket.truss = 1;
  socket.exist = true;
  sockets.add(socket);
  socketController.open = true;
  socketController.socket = socket;
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
    IntList fixturesInTruss = getListOfFixturesInTruss(truss);
    IntList socketsInTruss = getListOfSocketsInTruss(truss);
    for(int i = 0; i < findNearestSocket(truss).length; i++) {
      if(findNearestSocket(truss)[i] >= 0) {
        XML block = xml.addChild("socket");
        block.setInt("id", i);
        block.setContent(sockets.get(findNearestSocket(truss)[i]).name);
        block.setInt("fixture", fixturesInTruss.get(i));
        block.setInt("channel", sockets.get(findNearestSocket(truss)[i]).channel);
      }
    }
    xml = xml.getParent();
  }
  return xml;
}

boolean savingSocketsToXML;
void saveSocketsToXML() {
  savingSocketsToXML = true;
  String data = "<Sockets></Sockets>";
  XML xml = parseXML(data);
  for(int i = 0; i < sockets.size(); i++) {
    Socket socket = sockets.get(i);
    if(socket != null) {
      XML block = xml.addChild("Socket");
      block.setInt("id", i);
      block.setInt("number", socket.id);
      block.setInt("truss", socket.truss);
      block.setInt("x_location", socket.x_location);
      block.setInt("channel", socket.channel);
      block.setInt("isInUse", int(socket.isInUse));
      block.setInt("exist", int(socket.exist));
      block.setString("name", socket.name);
    }
  }
  saveXML(xml, "XML/sockets.xml");
  savingSocketsToXML = false;
}

void loadSocketsFromXML() {
  sockets = new ArrayList<Socket>();
  XML xml = loadXML("XML/sockets.xml");
  //XML socketss = xml.getChild("Sockets");
  XML[] socket = xml.getChildren("Socket");
  for(int i = 0; i < socket.length; i++) {
    Socket socketO;
    socketO = new Socket();
    socketO.truss = socket[i].getInt("truss");
    socketO.id = socket[i].getInt("number");
    socketO.x_location = socket[i].getInt("x_location");
    socketO.channel = socket[i].getInt("channel");
    socketO.isInUse = boolean(socket[i].getInt("isInUse"));
    socketO.exist = boolean(socket[i].getInt("exist"));
    socketO.isInUse = false;
    socketO.name = socket[i].getString("name");
    sockets.add(socketO);
  }
}

IntList getListOfFixturesInTruss(int truss) {
  IntList fixturesInTruss = new IntList();
  for(int i = 0; i < fixtures.size(); i++) {
    fixture fix = fixtures.get(i);
    if(fixtureIsDrawnById(i)) { //check if fixture exist in visualisation
      if(fix.parentAnsa == truss || isInIntList(truss, fix.allowedTrussesForWiring)) { //Check if fixture is in current truss
        fixturesInTruss.append(i);
      }
    }
  }
  
  return fixturesInTruss;
}


IntList getListOfSocketsInTruss(int truss) {
  IntList socketsInTruss = new IntList();
  for(int i = 0; i < sockets.size(); i++) {
    Socket socket = sockets.get(i);
    if(socket != null) {
      if(socket.exist) { //check if fixture exist in visualisation
        if(socket.truss == truss) { //Check if fixture is in current truss
          socketsInTruss.append(i);
        }
      }
    }
  }
  
  return socketsInTruss;
}



int[] findNearestSocket(int truss) {
  IntList fixturesInTruss = getListOfFixturesInTruss(truss);
  IntList socketsInTruss = getListOfSocketsInTruss(truss);
  int[] nearestFoundSocket = new int[fixturesInTruss.size()];
  
  
  for(int i = 0; i < fixturesInTruss.size(); i++) {
    int nearestFoundDistance = Integer.MAX_VALUE;
    nearestFoundSocket[i] = -1;
    fixture fix = fixtures.get(fixturesInTruss.get(i));
    if(fix.isHalogen()) {
      for(int j = 0; j < socketsInTruss.size(); j++) {
        if(sockets.get(socketsInTruss.get(j)) != null) {
          Socket socket = sockets.get(socketsInTruss.get(j));
          if((!socket.isInUse) || (socket.channel == fix.channelStart)) {
            if(abs(socket.x_location - fix.x_location) <= nearestFoundDistance) {
              nearestFoundDistance = abs(socket.x_location - fix.x_location);
              nearestFoundSocket[i] = socketsInTruss.get(j);
            }
          }
          
        }
      }
      if(nearestFoundSocket[i] >= 0) {
        sockets.get(nearestFoundSocket[i]).isInUse = true;
        sockets.get(nearestFoundSocket[i]).channel = fix.channelStart;
      }
    }
 }
  
  return nearestFoundSocket;
}
