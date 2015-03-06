OSCHandler oscHandler = new OSCHandler();
OSCSettingsWindow oscSettings = new OSCSettingsWindow();

class OSCSettingsWindow {
  int locX, locY, w, h;
  boolean open;
  Window window;
  
  int maxId = 10;

  OSCSettingsWindow() {
    locX = 100;
    locY = 100;
    w = 500;
    h = 500;
    window = new Window("OSCSettingsWindow", new PVector(w, h), this);

  }
  
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    
    if(!oscHandler.loadingXML) {
      g.pushMatrix();
        g.translate(40, 60);
        g.pushMatrix();
          g.translate(20, 0);
          PushButton addNewOsc = new PushButton("AddNewOsc");
          if(addNewOsc.isPressed(g, mouse)) { addNewOsc(); }
          g.pushStyle();
            g.fill(0);
            g.textAlign(LEFT);
            g.text("Add new", 30, 13);
          g.popStyle();
        g.popMatrix();
        g.pushStyle();
          g.fill(0);
          g.pushMatrix();
            try {
              g.translate(0, 20);
              g.pushMatrix();
                g.translate(0, 30);
                g.textAlign(LEFT);
                g.text("ip", 0, 0);
                g.translate(160, 0);
                g.text("incoming", 0, 0);
                g.translate(70, 0);
                g.text("outgoing", 0, 0);
                g.translate(70, 0);
                g.text("remove", 0, 0);
              g.popMatrix();
              g.pushMatrix();
                g.translate(0, 40);
                for(int i = 0; i < oscHandler.OSCmachines.size(); i++) {
                  if(i < oscHandler.OSCmachines.size()) {
                    if(oscHandler.OSCmachines.get(i) != null) {
                      oscHandler.OSCmachines.get(i).controller.draw(g, mouse, i);
                      g.translate(0, 30);
                    }
                  }
                }
              g.popMatrix();
            }
            catch (Exception e) {
            }
          g.popMatrix();
        g.popStyle();
      g.popMatrix();
    }
  }
  
  void addNewOsc() {
    maxId++;
    OSCmachine newMachine = new OSCmachine(maxId, 8000, 9000, "");
    oscHandler.OSCmachines.add(newMachine);

  }
}

class OSCmachineController {
  TextBox ipBox;
  TextBox incomingBox;
  TextBox outgoingBox;
  PushButton remover;
  
  int id;
  
  OSCmachine parent;
  OSCmachineController(OSCmachine parent, int id) {
    this.parent = parent;
    ipBox = new TextBox(parent.ipAddress, 3);
    incomingBox = new TextBox(str(parent.portIncoming), 2);
    outgoingBox = new TextBox(str(parent.portOutgoing), 2);
    this.id = id;
  }
  
  void draw(PGraphics g, Mouse mouse, int trueId) {
    g.pushMatrix();
    String mouseObjectName = "OSCmachineController"+str(id)+":"+"ipBox";
    mouse.declareUpdateElementRelative(mouseObjectName, 100000, 0, 0, 150, 20, g);
    mouse.setElementExpire(mouseObjectName, 2);
    ipBox.textBoxSize.x = 150;
    ipBox.drawToBuffer(g, mouse, mouseObjectName);
    if(ipBox.textChanged()) oscHandler.OSCmachines.get(trueId).setIp(ipBox.getText());
    
    g.translate(160, 0);
    mouseObjectName = "OSCmachineController"+str(id)+":"+"incomingBox";
    mouse.declareUpdateElementRelative(mouseObjectName, 100000, 0, 0, 60, 20, g);
    mouse.setElementExpire(mouseObjectName, 2);
    incomingBox.textBoxSize.x = 60;
    incomingBox.drawToBuffer(g, mouse, mouseObjectName);
    if(incomingBox.textChanged()) oscHandler.OSCmachines.get(trueId).setIncoming(int(incomingBox.getText()));
    
    g.translate(70, 0);
    mouseObjectName = "OSCmachineController"+str(id)+":"+"outgoingBox";
    mouse.declareUpdateElementRelative(mouseObjectName, 100000, 0, 0, 60, 20, g);
    mouse.setElementExpire(mouseObjectName, 2);
    outgoingBox.textBoxSize.x = 60;
    outgoingBox.drawToBuffer(g, mouse, mouseObjectName);
    if(outgoingBox.textChanged()) oscHandler.OSCmachines.get(trueId).setOutgoing(int(outgoingBox.getText()));
    
    g.translate(70, 0);
    mouseObjectName = "OSCmachineController"+str(id)+":"+"removePushButton";
    remover = new PushButton(mouseObjectName);
    if(remover.isPressed(g, mouse)) { oscHandler.removeOscMachineById(trueId); }
    g.popMatrix();
  }
  
  
}

class OSCHandler {
  ArrayList<OSCmachine> OSCmachines;
  boolean loadingXML;
  OSCHandler() {
    OSCmachines = new ArrayList<OSCmachine>();
    addNewOscMachine(new OSCmachine(1, 8000, 9000, "192.168.0.15"));
    addNewOscMachine(new OSCmachine(2, 8000, 9000, "192.168.0.13"));
  }
  void sendFaderVal(int ch, int val) {
    sendMessage("/1/fader" + str(ch), val);
  }
  void sendMessage(String address, int data) {
    for(int i = 0; i < OSCmachines.size(); i++) {
      OSCmachines.get(i).sendMessage(address, data);
    }
  }
  void sendMessage(String address, String data) {
    for(int i = 0; i < OSCmachines.size(); i++) {
      OSCmachines.get(i).sendMessage(address, data);
    }
  }
  
  void addNewOscMachine(OSCmachine toAdd) {
    OSCmachines.add(toAdd);
  }
  void removeOscMachineById(int id) {
    OSCmachines.remove(id);
  }
  void removeOscMachineByIp(String ip) {
    for(int i = 0; i < OSCmachines.size(); i++) {
      if(OSCmachines.get(i).getIp().equals(ip)) {
        OSCmachines.remove(i);
      }
    }
  }
  void removeAllOscMachines() {
    OSCmachines = new ArrayList<OSCmachine>();
  }
  
  
  XML getXML() {
    String data = "<OSChandler></OSChandler>";
    XML xml = parseXML(data);
    for(int i = 0; i < OSCmachines.size(); i++) {
      xml.addChild(OSCmachines.get(i).getXML());
    }
    return xml;
  }
  
  void XMLtoObject(XML xml) {
    loadingXML = true;
    OSCmachines = new ArrayList<OSCmachine>();
    XML[] blocks = xml.getChildren();
    for(int i = 0; i < blocks.length; i++) {
      if(blocks[i] != null) {
        if(!trim(blocks[i].toString()).equals("")) {
          OSCmachine newMachine = new OSCmachine(i);
          OSCmachines.add(newMachine);
          newMachine.XMLtoObject(blocks[i], OSCmachines.size()-1);
        }
      }
    }
    loadingXML = false;
  }
  
  void saveToXML() {
    saveXML(getXML(), "XML/OSCHandler.xml");
  }
  
  void loadFromXML() {
    XMLtoObject(loadXML("XML/OSCHandler.xml"));
  }
}






class OSCmachine {
  int portOutgoing, portIncoming;
  String ipAddress;
  
  NetAddress osc;
  
  OSCmachineController controller;
  
  OSCmachine(int id) {
    controller = new OSCmachineController(this, id);
  }
  
  OSCmachine(int id, int out, int in, String ip) {
    portOutgoing = out;
    portIncoming = in;
    ipAddress = ip;
    osc = new NetAddress(ip, portIncoming);
    
    controller = new OSCmachineController(this, id);
  }
  
  void init(int id, int out, int in, String ip) {
    portOutgoing = out;
    portIncoming = in;
    ipAddress = ip;
    osc = new NetAddress(ip, portIncoming);
    
    controller = new OSCmachineController(this, id);
  }
  
  int getPortOut() {
    return portOutgoing;
  }
  int getPortIn() {
    return portIncoming;
  }
  String getIp() {
    return ipAddress;
  }
  void setIp(String ip) {
    ipAddress = ip;
    osc = new NetAddress(ipAddress, portIncoming);
  }
  void setIncoming(int in) {
    portIncoming = in;
    osc = new NetAddress(ipAddress, portIncoming);
  }
  void setOutgoing(int out) {
    portOutgoing = out;
  }
  
  
  void sendMessage(String address, int val) {
    OscMessage msg = new OscMessage(address);
    msg.add(val); // add an int to the osc message
    oscP52.send(msg, osc); 
  }
  
  void sendMessage(String address, String val) {
    OscMessage msg = new OscMessage(address);
    msg.add(val); // add an String to the osc message
    oscP52.send(msg, osc); 
  }
  
  XML getXML() {
    String data = "<OSCMachine></OSCMachine>";
    XML xml = parseXML(data);
    xml.setInt("portOutgoing", portOutgoing);
    xml.setInt("portIncoming", portIncoming);
    xml.setString("ipAddress", ipAddress);
    return xml;
  }
  
  void XMLtoObject(XML xml, int id) {
    println(xml);
    if(xml != null) {
      portOutgoing = xml.getInt("portOutgoing");
      portIncoming = xml.getInt("portIncoming");
      setIp(xml.getString("ipAddress"));
      controller = new OSCmachineController(this, id);
    }
  }
}
