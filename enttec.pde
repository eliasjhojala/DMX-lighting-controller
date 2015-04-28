EnttecOutputSettingsWindow enttecOutputSettingsWindow = new EnttecOutputSettingsWindow(this);
EnttecOutput enttecOutput = new EnttecOutput();

int[] dmxToOutputSended = new int[DMX_CHAN_LENGTH+1];

class EnttecOutputSettingsWindow {
  Window window;
  boolean open;
  int locX, locY, w, h;
  PApplet parent;
  
  DropdownMenu comPort;
  
  EnttecOutputSettingsWindow(PApplet parent) {
    this.parent = parent;
    locX = 0;
    locY = 0;
    w = 500;
    h = 500;
    window = new Window("enttecOutputSettingsWindow", new PVector(w, h), this);
    ArrayList<DropdownMenuBlock> comPorts = new ArrayList<DropdownMenuBlock>();
    for(int i = 0; i < Serial.list().length; i++) {
      comPorts.add(new DropdownMenuBlock(Serial.list()[i], i));
    }
    comPort = new DropdownMenu("comPorts", comPorts);
    comPort.setBlockSize(new PVector(300, 20));
  }
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    
    g.pushMatrix();
      g.translate(30, 60);
      comPort.draw(g, mouse);
    g.popMatrix();
    
    if(comPort.valueHasChanged()) {
      int index = comPort.getValue();
      enttecOutput = new EnttecOutput(parent, Serial.list()[index]);
    }
  }
}

import dmxP512.*;
import processing.serial.*;

DmxP512 dmxOutput;


class EnttecOutput {
  String port;
  int[] lastDMX;
  int delayBetweenPackets = 1;
  long lastPacketMillis;
  
  int DMXPRO_BAUDRATE=115000;
  int universeSize=512;
  
  
  
  boolean inUse;
  
  EnttecOutput() {
  }
  
  PApplet parent;
  
  EnttecOutput(PApplet parent, String port) {
    setup(parent, port);
  }
  
  void setup(PApplet parent, String port) {
    try {
      this.parent = parent;
      this.port = port;
      enttecOutputSettingsWindow.comPort.setText(port);
      lastDMX = new int[DMXforOutput.length];
      dmxOutput = new DmxP512(parent, universeSize, false);
      dmxOutput.setupDmxPro(port, DMXPRO_BAUDRATE);
      inUse = true;
    }
    catch (Exception e) {
      e.printStackTrace();
      inUse = false;
    }
  }
  
  
  void draw() {
    if(inUse) {
      sendUniversum();
    }
  }
  
  void sendUniversum() {
    if(lastDMX.length != DMXforOutput.length) {
      lastDMX = new int[DMXforOutput.length];
    }
    for(int i = 0; i < DMXforOutput.length; i++) {
      int newVal = DMXforOutput[i];
      if(newVal != lastDMX[i] /*&& waitedEnough()*/) {
        sendChannel(i, newVal);
        lastDMX[i] = newVal;
      }
    }
  }
  
  void sendChannel(int ch, int val) {
    dmxOutput.set(ch, val);
    if(ch >= 0 && ch < dmxToOutputSended.length) {
      dmxToOutputSended[ch] = val;
    }
    println("Sent dmx ch: " + str(ch) + " val: " + str(val));
  }
  
  boolean waitedEnough() {
    if(millis() - lastPacketMillis > delayBetweenPackets) {
      lastPacketMillis = millis();
      return true;
    }
    return false;
  }
  
  
  XML getXML() {
    String data = "<Enttec></Enttec>";
    XML xml = parseXML(data);
    XML block = xml.addChild("port");
    block.setContent(port);
    return xml;
  }
  
  void XMLtoObject(XML xml, PApplet parent) {
    setup(parent, xml.getChild("port").getContent());
  }
  
  
}


