
OSCHandler oscHandler = new OSCHandler();

class OSCHandler {
  ArrayList<OSCmachine> OSCmachines;
  OSCHandler() {
    OSCmachines = new ArrayList<OSCmachine>();
    addNewOscMachine(new OSCmachine(8000, 9000, "192.168.0.15"));
    addNewOscMachine(new OSCmachine(8000, 9000, "192.168.0.13"));
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
  
  
}




class OSCmachine {
  int portOutgoing, portIncoming;
  String ipAddress;
  
  NetAddress osc;
  
  OSCmachine(int out, int in, String ip) {
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
    msg.add(val); // add an String to the osc message
    oscP52.send(msg, osc); 
  }
}
