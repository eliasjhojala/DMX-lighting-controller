//Tässä välilehdessä piirretään 3D-mallinnus
/* 
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */
 
int coneScale = 500;

boolean use3D = true;


int centerX;
int centerY;


//0 = None, 1 = ansa 0, 2 = ansa 1
int numberOfAnsas = 6;
int[] ansaZ = new int[numberOfAnsas];
int[] ansaX = new int[numberOfAnsas];
int[] ansaY = new int[numberOfAnsas];
int[] ansaType = new int[numberOfAnsas];

PVector cam = new PVector(s1.width/2.0, s1.height/2.0 + 4000, 1000);

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
  
  PShape par64Model, par64Holder, base, cone;
  
  void setup() {
    size(500, 500, P3D);

    
    try {
      par64Model = loadShape(parent.dataPath("par64.obj"));
      par64Holder = loadShape(parent.dataPath( "par64_holder.obj"));
      base = loadShape(parent.dataPath( "base.obj"));
      cone = loadShape(parent.dataPath( "cone.obj"));
      cone.disableStyle();
      base.disableStyle();
    }
    catch (Exception e) {
     // use3D = false;
    }

    frameRate(60);
    
  
    
  }
  
  int[] valoY = {100 + 70, 100 +140, 100 + 210, 100 + 280, 100 + 350, 100 + 420};
  int valoScale = 20;
  
  
  
  void draw() {
    if(!use3D) {   
      drawText("3D not in use");
    }
    if(use3D == true && dataLoaded) { }
    if(true) {
     setMainSettings();
     drawFloor();
     drawTrusses();
     drawLights();          
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
  }
  
  void setPerspective() {
    float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
    perspective(1, float(width)/height, cameraZ/10.0/10, cameraZ*10.0*10);
  }
  
  void setCamera() {
    //Camera
    camera(cam.x, cam.y, cam.z, width/2.0+centerX, height/2.0 + 1500+centerY, -1000, 0, 0, -1);
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
    int[] ij = { ansaY.length, ansaX.length, ansaZ.length };
    for(int i = 0; i < min(ij); i++) {
      if(ansaType[i] == 1) {
        pushMatrix();
        translate(0, ansaY[i] * 5, ansaZ[i] + 82);
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
    if (parentAnsa != 0) {
      posZ += ansaZ[parentAnsa];
      posX += ansaX[parentAnsa];
      posY += ansaY[parentAnsa];
    }
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
        centerX += (mouseX - pmouseX) * 5;
        centerY += (mouseY - pmouseY) * 10;
        
        translate(width/2.0+centerX, height/2.0 + 1500+centerY, 0); 
        fill(255, 255, 0);
        box(50);
        translate((width/2.0+centerX)*(-1), (height/2.0 + 1500+centerY)*(-1), 0); 
      }
      
      else {
        cam.x += (mouseX - pmouseX) * 5;
        cam.y += (mouseY - pmouseY) * 10;
      }
  }
   
  void mousePressed() {
    if(use3D) {
      loop();
      frameRate(60);
    }
  }
   
  void keyPressed()
  {
    if (keyCode == UP) { cam.z += 100; } 
    else if (keyCode == DOWN) { cam.z -= 100; }
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


