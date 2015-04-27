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
    updateTrusses();
    
  }
  
  void updateTrusses() {
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
  
  boolean isInActiveUse = false;
  
  Socket(int number, int parentTruss, int x) {
    truss = parentTruss;
    id = number;
    x_location = x;
    exist = true;
  }
  Socket() {
  }
  
	void XMLtoObject(XML xml) {
		truss = xml.getInt("truss");
		id = xml.getInt("number");
		x_location = xml.getInt("x_location");
		channel = xml.getInt("channel");
		isInUse = boolean(xml.getInt("isInUse"));
		exist = boolean(xml.getInt("exist"));
		isInUse = false;
		name = xml.getString("name");
	}
	
	XML getXML() {
		XML xml = parseXML("<socket></socket>");
		xml.setInt("number", id);
		xml.setInt("truss", truss);
		xml.setInt("x_location", x_location);
		xml.setInt("channel", channel);
		xml.setInt("isInUse", int(isInUse));
		xml.setInt("exist", int(exist));
		xml.setString("name", name);
		return xml;
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
  for(int truss = 0; truss < trusses.length; truss++) if(trusses[truss].alignSocketsAutomaticly) {
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
  saveXML(getSocketsAsXML(), "XML/sockets.xml");
  savingSocketsToXML = false;
}


XML getSocketsAsXML() {
  String data = "<Sockets></Sockets>";
  XML xml = parseXML(data);
  for(int i = 0; i < sockets.size(); i++) {
    Socket socket = sockets.get(i);
    if(socket != null) {
      XML block = xml.addChild(socket.getXML());
      block.setInt("id", i);
    }
  }
  return xml;
}

void loadSocketsFromXML() {
  XMLtoSockets(loadXML("XML/sockets.xml"));
}

void XMLtoSockets(XML xml) {
  sockets = new ArrayList<Socket>();
  
  //XML socketss = xml.getChild("Sockets");
  XML[] socket = xml.getChildren("socket");
  for(int i = 0; i < socket.length; i++) {
	if(!trim(socket[i].toString()).equals("")) {
		Socket socketO;
		socketO = new Socket();
		socketO.XMLtoObject(socket[i]);
		sockets.add(socketO);
	}
  }
    fixtureController.updateSockets();
}

IntList getListOfFixturesInTruss(int truss) {
  IntList fixturesInTruss = new IntList();
  for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) {
    fixture fix = entry.getValue();
    int i = entry.getKey();
    
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
      for(int j = 0; j < socketsInTruss.size(); j++) {
        if(sockets.get(socketsInTruss.get(j)) != null) {
          Socket socket = sockets.get(socketsInTruss.get(j));
          if((!socket.isInUse) || (socket.channel == fix.channelStart)/* || (!fix.isHalogen() && socket.channel == -2)*/) {
            if(abs(socket.x_location - fix.x_location) <= nearestFoundDistance) {
              nearestFoundDistance = abs(socket.x_location - fix.x_location);
              nearestFoundSocket[i] = socketsInTruss.get(j);
            }
          }
          
        }
      }
      if(nearestFoundSocket[i] >= 0) {
        sockets.get(nearestFoundSocket[i]).isInUse = true;
        /*if(fix.isHalogen()) { */ sockets.get(nearestFoundSocket[i]).channel = fix.channelStart; /*}
        else { sockets.get(nearestFoundSocket[i]).channel = -2; }*/
        fix.socket.XMLtoObject(sockets.get(nearestFoundSocket[i]).getXML()); println(fix.socket.name);
        sockets.get(nearestFoundSocket[i]).channel = fix.channelStart;
      }
 }
  
  return nearestFoundSocket;
}
