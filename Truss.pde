

TrussControllerWindow trussController = new TrussControllerWindow();

class TrussControllerWindow {
  Window window;
  int locX, locY, w, h;
  boolean open;
  
  PVector location;
  
  IntController xL, yL, zL;
  
  CheckBox alignSocketsAuto;
  
  TrussControllerWindow() {
    w = 500; h = 500;
    location = new PVector(0, 0, 0);
    window = new Window("trussController", new PVector(w, h), this);
    
    xL = new IntController("LocationController"+this.toString()+":xL");
    yL = new IntController("LocationController"+this.toString()+":yL");
    zL = new IntController("LocationController"+this.toString()+":zL");
    
    alignSocketsAuto = new CheckBox("alignSocketsAuto");
  }
  
  Truss truss;
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    g.translate(60, 80);
    if(truss.location.x != location.x) { location.x = truss.location.x; xL.setValue(location.x); }
    if(truss.location.y != location.y) { location.y = truss.location.y; yL.setValue(location.y); }
    if(truss.location.z != location.z) { location.z = truss.location.z; zL.setValue(location.z); }
    g.pushMatrix();
      xL.draw(g, mouse); if(xL.valueHasChanged()) { setLocationX(xL.getValue()); }
      g.translate(0, 30);
      yL.draw(g, mouse); if(yL.valueHasChanged()) { setLocationY(yL.getValue()); }
      g.translate(0, 30);
      zL.draw(g, mouse); if(zL.valueHasChanged()) { setLocationZ(zL.getValue()); }
    g.popMatrix();
    g.translate(0, 200);
    alignSocketsAuto.draw(g, mouse, "alignSocketsAuto"+this.toString());
    if(alignSocketsAuto.valueHasChanged()) { truss.alignSocketsAutomaticly = alignSocketsAuto.getValue(); }
    
  }
  
  void setLocationX(int val) {
    truss.location.x = val;
  }
  void setLocationY(int val) {
    truss.location.y = val;
  }
  void setLocationZ(int val) {
    truss.location.z = val;
  }
}

Truss[] trusses;

class Truss {
  PVector location;
  int type;
  int lng = 1000;
  boolean alignSocketsAutomaticly;
  
  Truss(PVector loc, int len, int t) {
    location = loc;
    type = t;
    lng = len;
  }
  
  void truss(PVector loc, int len, int t) {
    location = loc;
    type = t;
    lng = len;
  }
  Truss() {
    if(location == null) {
      location = new PVector(0, 0);
    }
    type = 0;
    lng = 0;
  }
  
  XML getAsXML() {
    String data = "<Truss></Truss>";
    XML xml = parseXML(data);
    xml.addChild(vectorAsXML(location, "location"));
    xml.setInt("type", type);
    xml.setInt("length", lng);
    return xml;
  }
  
  void XMLtoObject(XML xml) {
    truss(XMLtoVector(xml, "location"), xml.getInt("length"), xml.getInt("type"));
  }
}

XML getTrussesAsXML() {
  String data = "<Trusses></Trusses>";
  XML xml = parseXML(data);
  for(int i = 0; i < trusses.length; i++) {
    xml.addChild(trusses[i].getAsXML());
    xml.setInt("id", i);
  }
  return xml;
}

void XMLtoTrusses(XML xml) {
  XML[] XMLtrusses = xml.getChildren();
  int a = 0;
  for(int i = 0; i < XMLtrusses.length; i++) {
    if(XMLtrusses[i] != null) if(!trim(XMLtrusses[i].toString()).equals("")) {
      a++;
    }
  }
  trusses = new Truss[a];
  a = 0;
  for(int i = 0; i < XMLtrusses.length; i++) {
    if(XMLtrusses[i] != null) if(!trim(XMLtrusses[i].toString()).equals("")) {
      if(a < trusses.length) {
        trusses[a] = new Truss();
        trusses[a].XMLtoObject(XMLtrusses[i]);
      }
      a++;
    }
  }
}

boolean trussesLoadedSucces = false;

void loadXmlToTrusses() {
  trussesLoadedSucces = false;
  XMLtoTrusses(loadXML("XML/trusses.xml"));
  trussesLoadedSucces = true;
}

boolean savingTrussesToXML;
void saveTrussesAsXML() {
  savingTrussesToXML = true;
  saveXML(getTrussesAsXML(), "XML/trusses.xml");
  savingTrussesToXML = false;
}
