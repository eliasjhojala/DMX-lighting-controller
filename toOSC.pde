
OSCHandler oscHandler = new OSCHandler();

class OSCHandler {
  OSCmaschine[] OSCmaschines;
  OSCHandler() {
    OSCmaschines = new OSCmaschine[2];
    OSCmaschines[0] = new OSCmaschine(8000, 9000, "192.168.0.15");
    OSCmaschines[1] = new OSCmaschine(8000, 9000, "192.168.0.13");
  }
  void sendFaderVal(int ch, int val) {
    sendMessage("/1/fader" + str(ch), val);
  }
  void sendMessage(String address, int data) {
    for(int i = 0; i < OSCmaschines.length; i++) {
      OSCmaschines[i].sendMessage(address, data);
    }
  }
  void sendMessage(String address, String data) {
    for(int i = 0; i < OSCmaschines.length; i++) {
      OSCmaschines[i].sendMessage(address, data);
    }
  }
}




class OSCmaschine {
  int portOutgoing, portIncoming;
  String ipAddress;
  
  NetAddress osc;
  
  OSCmaschine(int out, int in, String ip) {
    portOutgoing = out;
    portIncoming = in;
    ipAddress = ip;
    osc = new NetAddress(ip, portIncoming);
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
  
  void sendMessage(String address, int val) {
    OscMessage msg = new OscMessage(address);
    msg.add(val); // add an int to the osc message
    oscP52.send(msg, osc); 
  }
  
  void sendMessage(String address, String val) {
    OscMessage msg = new OscMessage(address);
    msg.add(val); // add an int to the osc message
    oscP52.send(msg, osc); 
  }
}
