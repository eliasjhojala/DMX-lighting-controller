//Tässä välilehdessä piirretään 3D-mallinnus
/* 
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */
 
int coneScale = 500;

int[] tablex = {  };
int[] tabley = {  };
int[] tablez = {  };
int[] tablePositionsLength = new int[3];

boolean rotateZopposite = true;

boolean use3D = true;

int userOneFrameRate = 30;
int userTwoFrameRate = 30;

int centerX;
int centerY;

String assetPath;

//0 = None, 1 = ansa 0, 2 = ansa 1
int numberOfAnsas = 6;
int[] ansaZ = new int[numberOfAnsas];
int[] ansaX = new int[numberOfAnsas];
int[] ansaY = new int[numberOfAnsas];
int[] ansaType = new int[numberOfAnsas];

float camX = s1.width/2.0, camY = s1.height/2.0 + 4000, camZ = 1000;
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

PShape par64Model;
PShape par64Holder;
PShape kFresu;
PShape iFresu;
PShape linssi;
PShape flood;
PShape floodCover;
PShape strobo;
PShape mhMain;
PShape mhHolder;
PShape mhBase;
PShape base;
PShape cone;
PShape table;

float par64ConeDiameter = 0.4;
float pFresuConeDiameter = 0.7;
float kFresuConeDiameter = 0.8;
float iFresuConeDiameter = 0.8;
float linssiConeDiameter = 0.8;
float floodConeDiameter = 0.8;
float stroboConeDiameter = 0.8;
float mhxConeDiameter = 0.4;

int lavaX = 460, lavaY = 250, lavaSizX = 1000, lavaSizY = 500, lavaH = 100;
boolean lava = false;


boolean[] stroboOn;

void setup() {
  stroboOn = new boolean[ansaTaka];
  
  if(userId == 1) { //Jos Elias käyttää
    assetPath = "/Users/elias/Dropbox/DMX controller/Roopen Kopiot/";
  }
  else if(userId == 2) { //Jos Roope käyttää
    if(getPaths == true) {
      String lines100[] = loadStrings("C:\\DMXcontrolsettings\\assetPath.txt");
      assetPath = lines100[0];
    }
  }
  
  
  size(700, 500, P3D);
  
  
  //Asetetaan oikeat polut käyttäjän mukaan
  
  String path;
  if(userId == 1) { //Jos Elias käyttää
    path = assetPath + "Tallenteet/3D models/";
  }
  else { //Jos Roope käyttää
    path = assetPath + "3D models\\";
  }
  
  try {
    par64Model = loadShape(parent.dataPath("par64.obj"));
    par64Holder = loadShape(parent.dataPath( "par64_holder.obj"));
    kFresu = loadShape(parent.dataPath( "kFresu.obj"));
    iFresu = loadShape(parent.dataPath( "iFresu.obj"));
    linssi = loadShape(parent.dataPath( "linssi.obj"));
    flood = loadShape(parent.dataPath( "flood.obj"));
    floodCover = loadShape(parent.dataPath( "floodCover.obj"));
    strobo = loadShape(parent.dataPath( "strobo.obj"));
    mhMain = loadShape(parent.dataPath( "mhMain.obj"));
    mhHolder = loadShape(parent.dataPath( "mhHolder.obj"));
    mhBase = loadShape(parent.dataPath( "mhBase.obj")); 
    base = loadShape(parent.dataPath( "base.obj"));
    cone = loadShape(parent.dataPath( "cone.obj"));
    table = loadShape(parent.dataPath( "table.obj"));
    table.disableStyle();
  }
  catch (Exception e) {
   // use3D = false;
  }
  cone.disableStyle();
  base.disableStyle();
  
  //if(userId == 1) {frameRate(1);} else {frameRate(userTwoFrameRate);} 
  frameRate(60);
  

  
}

int[] valoY = {100 + 70, 100 +140, 100 + 210, 100 + 280, 100 + 350, 100 + 420};
int valoScale = 20;



void draw() {

//  if(!use3D) {   
//    textSize(26);
//    background(0); 
//    fill(255);
//    text("3D not in use", 10, 100); 
//  }
 // if(use3D == true && dataLoaded) {
 if(true) {
               float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
              perspective(1, float(width)/height, cameraZ/10.0/10, cameraZ*10.0*10);
              background(0);
              lights();
              
              //Camera
              camera(camX, camY, camZ, width/2.0+centerX, height/2.0 + 1500+centerY, -1000, 0, 0, -1);
              
              
              
              
              //Draw floor
              pushMatrix();
                translate(width/2, height/2+4000, -1000);
                noStroke();
                rotateX(radians(90));
                fill(50);
                scale(400, 400, 400);
                shape(base);
              popMatrix();
              
              
              //Draw ansas
              int[] ij = { ansaY.length, ansaX.length, ansaZ.length };
              for(int i = 0; i < min(ij); i++) {
                if(ansaType[i] == 1) {
                  pushMatrix();
                  translate(0, ansaY[i] * 5, ansaZ[i] + 82);
                  box(10000, 10, 10);
                  popMatrix();
                }
              }
              
              //Draw stage (lava)
              if(lava) {
                pushMatrix();
                translate(lavaX * 5 - 1000, lavaY * 5, -990 + lavaH);
                fill(70);
                box(lavaSizX * 5, lavaSizY * 5, lavaH * 2);
                shape(table);
                popMatrix();
              }
              
              
              //Draw tables
              tablePositionsLength[0] = tablex.length;
              tablePositionsLength[1] = tabley.length;
              tablePositionsLength[2] = tablez.length;
              
              for(int i = 0; i < min(tablePositionsLength); i++) {
                pushMatrix();
                translate(tablex[i], tabley[i], tablez[i]);
                scale(100, 100, 100);
                rotateX(radians(90));
                shape(table);
                popMatrix();
              }

              
             
              //Draw lights
              for (int i = 0; i < fixtures.size(); i++) {
                if(fixtureIsDrawnById(i)) {
                  PShape model = par64Model;
                  try { model = getFixtureModelById(i); } catch (Exception e) { e.printStackTrace(); }
                  int x_loc = fixtures.get(i).x_location;
                  int y_loc = fixtures.get(i).y_location;
                  int z_loc = fixtures.get(i).z_location;
                  PVector location = new PVector(x_loc, y_loc, z_loc);
                  int rotaZ = fixtures.get(i).rotationZ;
                  int rotaX = fixtures.get(i).rotationX;
                  color rawColor = fixtures.get(i).getRawColor();
                  int dimmer = fixtures.get(i).out.getUniversalDMX(DMX_DIMMER);
                  int parentAnsa = fixtures.get(i).parentAnsa;
                  drawLight(
                            x_loc, 
                            y_loc, 
                            z_loc, 
                            rotaZ, 
                            rotaX, 
                            valoScale, 
                            par64ConeDiameter, 
                            rawColor, 
                            dimmer, 
                            -60, 
                            parentAnsa, 
                            model);
                }
              }            
}
}



void drawLight(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, color coneColor, int conedim, int coneZOffset, int parentAnsa, PShape lightModel) {
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
          //fill(255, 0, 0, 128);
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
      camX += (mouseX - pmouseX) * 5;
      camY += (mouseY - pmouseY) * 10;
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
  if (keyCode == UP) { camZ += 100; } 
  else if (keyCode == DOWN) { camZ -= 100; }
}



//End 3D visualizer window class
}

public class PFrame1 extends JFrame {
  
  public PFrame1(PApplet parent) {
          setBounds(0, 0, 600, 340);
          setResizable(true);
          s1 = new secondApplet1(parent);
          add(s1);
          s1.init();
          show();
  }
}

