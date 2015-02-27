//Tässä välilehdessä piirretään 3D-mallinnus
/* 
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */
 
int coneScale = 500;

//0 = None, 1 = ansa 0, 2 = ansa 1
int numberOfAnsas = 10;
//int[] ansaZ = new int[numberOfAnsas];
//int[] ansaX = new int[numberOfAnsas];
//int[] ansaY = new int[numberOfAnsas];
//int[] ansaType = new int[numberOfAnsas];

PVector cam = new PVector(s1.width/2.0, s1.height/2.0 + 4000, 1000);
PVector center = new PVector(0, 0, 0);
PVector rotation = new PVector(0, 0, 0);

public class PFrame extends JFrame {
  public PFrame() {
    setBounds(0, 0, 600, 340);
    s = new secondApplet();
    add(s);
    s.init();
    show();
  }
}

//Begin 3D visualizer window class
public class secondApplet1 extends PApplet {
  PApplet parent;
  secondApplet1(PApplet parent) {
    this.parent = parent;
  }
  
  PShape par64Model, par64Holder, base, cone; //Define 3D model objects
  
  void setup() {
    size(500, 500, P3D);

    
    { //Try to load 3D models from file. If not succeed then don't use 3D.
      try { //Load 3D models 
        par64Model = loadShape(parent.dataPath("par64.obj")); //Load par64 3D model from file 
        par64Holder = loadShape(parent.dataPath( "par64_holder.obj")); //Load par64 holder 3D model from file
        base = loadShape(parent.dataPath( "base.obj")); //Load base (floor) 3D model from file
        cone = loadShape(parent.dataPath( "cone.obj")); //Load light cone 3D model from file
        cone.disableStyle();
        base.disableStyle();
      } //End of loadin 3D models
      catch (Exception e) { //What to do if not succeed
        use3D = false;
      } //End of catch
    } //End of trying to load 3D models

    frameRate(60); //Set fps to most usual display fps
  }
  
  int valoScale = 20;
  
  void draw() {
    if(use3D) {
     setMainSettings(); //Set settings for beginning (camera, perspective etc)
     drawFloor(); //Draw floor
     drawTrusses(); //Draw all the trusses
     drawLights(); //Draw all the lights
    }
    else {
      drawText("3D not in use");
    }
  }
  
  void drawText(String text) {
    textSize(26);
    background(0); 
    fill(255);
    text(text, 10, 100); 
  }
  
  void setMainSettings() {
    background(0);
    lights();
    setPerspective();
    setCamera();
    setRotation();
  }
  
  void setPerspective() {
    float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
    perspective(1, float(width)/height, cameraZ/10.0/10, cameraZ*10.0*10);
  }
  
  void setCamera() {
    //Camera
    camera(cam.x, cam.y, cam.z, width/2.0+center.x, height/2.0 + 1500+center.y, -1000, 0, 0, -1);
  }
  
  void setRotation() {
    rotateZ(rotation.z/100);
    rotateX(rotation.x/100);
    rotateY(rotation.y/100);
  }
  
  void drawFloor() {
    //Draw floor
    pushMatrix();
      translate(width/2, height/2+4000, -1000);
      noStroke();
      rotateX(radians(90));
      fill(50);
      scale(400, 400, 400);
      shape(base);
    popMatrix();
  }
  
  void drawTrusses() {
    //Draw trusses etc.
    for(int i = 0; i < trusses.length; i++) {
      if(trusses[i].type == 1) {
        pushMatrix();
        translate(0, trusses[i].location.x * 5, trusses[i].location.y + 82);
        box(10000, 10, 10);
        popMatrix();
      }
    }
  }
  
  void drawLights() {
    //Draw lights
    for (int i = 0; i < fixtures.size(); i++) {
      drawSingleLight(i);
    } 
    
    for (int i = 0; i < fixtures.size(); i++) {
      drawSingleCone(i);
    }
  }
  
  void drawSingleLight(int i) {
    if(fixtureIsDrawnById(i)) {
      PShape model = par64Model;
      try { model = getFixtureModelById(i); } catch (Exception e) { e.printStackTrace(); }
      LocationData locationData = fixtures.get(i).getLocationData();
      RGBWD rgbwd = fixtures.get(i).getRGBWD();
      int parentAnsa = fixtures.get(i).parentAnsa;
      drawLight(locationData, valoScale, 0.4, rgbwd, -60, parentAnsa, model);
    }
  }
  void drawSingleCone(int i) {
    if(fixtureIsDrawnById(i)) {
      PShape model = par64Model;
      try { model = getFixtureModelById(i); } catch (Exception e) { e.printStackTrace(); }
      LocationData locationData = fixtures.get(i).getLocationData();
      RGBWD rgbwd = fixtures.get(i).getRGBWD();
      int parentAnsa = fixtures.get(i).parentAnsa;
      drawCone(locationData, valoScale, 0.4, rgbwd, -60, parentAnsa, model);
    }
  }
  
  
  
  void drawLight(LocationData locationData, int scale, float coneDiam, RGBWD rgbwd, int coneZOffset, int parentAnsa, PShape lightModel) {
    PVector location = locationData.getLocation();
    PVector rotation = locationData.getRotation();
    float posX = location.x;
    float posY = location.y;
    float posZ = location.z;
    float rotZ = rotation.z;
    float rotX = rotation.x;
    
    color coneColor = rgbwd.getCol();
    int conedim = rgbwd.getDim();
    //If light is parented to an ansa, offset Z height by ansas height
      posZ += trusses[parentAnsa].location.z;
      posX += trusses[parentAnsa].location.x;
      posY += trusses[parentAnsa].location.y;
    //Draw p64 holder
    pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(90));
      noStroke();
      scale(scale);
      shape(par64Holder);
    popMatrix();
    
    //Draw light itself
    pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      noStroke();
      scale(scale);
      shape(lightModel);
    popMatrix();
    
//     //Draw light cone
//    if(conedim > 0) {
//      pushMatrix();
//        translate(posX * 5 - 1000, posY * 5, posZ);
//        rotateZ(radians(rotZ));
//        rotateX(radians(rotX));
//        //Cone offset
//        translate(0, 0, coneZOffset);
//        scale(scale * coneScale * coneDiam, scale * coneScale  * coneDiam, scale * coneScale);
//        fill(coneColor, conedim / 2);
//        shape(cone);
//      popMatrix();
//    }
  }
  
    
  void drawCone(LocationData locationData, int scale, float coneDiam, RGBWD rgbwd, int coneZOffset, int parentAnsa, PShape lightModel) {
    PVector location = locationData.getLocation();
    PVector rotation = locationData.getRotation();
    float posX = location.x;
    float posY = location.y;
    float posZ = location.z;
    float rotZ = rotation.z;
    float rotX = rotation.x;
    
    color coneColor = rgbwd.getCol();
    int conedim = rgbwd.getDim();
    //If light is parented to an ansa, offset Z height by ansas height
      posZ += trusses[parentAnsa].location.z;
      posX += trusses[parentAnsa].location.x;
      posY += trusses[parentAnsa].location.y;

     //Draw light cone
    if(conedim > 0) {
      pushMatrix();
        translate(posX * 5 - 1000, posY * 5, posZ);
        rotateZ(radians(rotZ));
        rotateX(radians(rotX));
        //Cone offset
        translate(0, 0, coneZOffset);
        scale(scale * coneScale * coneDiam, scale * coneScale  * coneDiam, scale * coneScale);
        fill(coneColor, conedim / 2);
        shape(cone);
      popMatrix();
    }
  }
  
  
  void mouseDragged() {
      if(mouseButton == RIGHT) {
        center.x += (mouseX - pmouseX) * 5;
        center.y += (mouseY - pmouseY) * 10;
        
        translate(width/2.0+center.x, height/2.0 + 1500+center.y, 0); 
        fill(255, 255, 0);
        box(50);
        translate((width/2.0+center.x)*(-1), (height/2.0 + 1500+center.y)*(-1), 0); 
      }
      
      else {
        rotation.z -= (mouseX - pmouseX);
        cam.y += (mouseY - pmouseY) * 30;
      }
  }
  
  void keyPressed()
  {
    if (keyCode == UP) { cam.z += 100; } 
    else if (keyCode == DOWN) { cam.z -= 100; }
    if(key==27) { key=0; }
  }
  


} //End 3D visualizer window class


public class PFrame1 extends JFrame {
  public PFrame1(PApplet parent, int w, int h) {
    setBounds(0, 0, w, h);
    setResizable(true);
    s1 = new secondApplet1(parent);
    add(s1);
    s1.init();
    show();
  }
}

Truss[] trusses = new Truss[numberOfAnsas];

class Truss {
  PVector location;
  int type;
  int lng;
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
      if(a < trusses.length) {
        trusses[a] = new Truss();
        trusses[a].XMLtoObject(XMLtrusses[i]);
      }
      a++;
    }
  }
}

void loadXmlToTrusses() {
  XMLtoTrusses(loadXML("XML/trusses"));
}

void saveTrussesAsXML() {
  saveXML(getTrussesAsXML(), "XML/trusses");
}

XML vectorAsXML(PVector vector, String name) {
  String data = "<"+name+"></"+name+">";
  XML xml = parseXML(data);
  xml.setFloat("x", vector.x);
  xml.setFloat("y", vector.y);
  xml.setFloat("z", vector.z);
  return xml;
}

PVector XMLtoVector(XML xml, String name) {
  PVector toReturn = new PVector(0, 0, 0);
  xml = xml.getChild(name);
  toReturn.x = xml.getFloat("x");
  toReturn.y = xml.getFloat("y");
  toReturn.z = xml.getFloat("z");
  xml = xml.getParent();
  return toReturn;
}
