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

boolean use3D = false;

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


int[] fixParam = { 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45 };

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
  par64Model = loadShape(path + "par64.obj");
  par64Holder = loadShape(path + "par64_holder.obj");
  kFresu = loadShape(path + "kFresu.obj");
  iFresu = loadShape(path + "iFresu.obj");
  linssi = loadShape(path + "linssi.obj");
  flood = loadShape(path + "flood.obj");
  floodCover = loadShape(path + "floodCover.obj");
  strobo = loadShape(path + "strobo.obj");
  mhMain = loadShape(path + "mhMain.obj");
  mhHolder = loadShape(path + "mhHolder.obj");
  mhBase = loadShape(path + "mhBase.obj"); 
  base = loadShape(path + "base.obj");
  cone = loadShape(path + "cone.obj");
  table = loadShape(path + "table.obj");
  table.disableStyle();
  }
  catch (Exception e) {
    use3D = false;
  }
  cone.disableStyle();
  base.disableStyle();
  
  if(userId == 1) {frameRate(1);} else {frameRate(userTwoFrameRate);} 
  //frameRate(15);
  
  noLoop();
  if (frame != null) {
    frame.setResizable(false);
  }
  
}

int[] valoY = {100 + 70, 100 +140, 100 + 210, 100 + 280, 100 + 350, 100 + 420};
int valoScale = 20;



void draw() {

  if(!use3D) {   
    textSize(26);
    background(0); 
    fill(255);
    text("3D not in use", 10, 100); 
  }
  if(use3D == true && dataLoaded) {
 
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

              
            /*  
              //Draw lights
              for (int i = 0; i < ansaTaka; i++) {
                //If light is of type par64 OR moving head dim
                if(fixtures.get(i).fixtureTypeId == 1 || fixtures.get(i).fixtureTypeId == 13){
                  drawLight(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, valoScale, par64ConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, -60, fixtures.get(i).parentAnsa, par64Model);
                } else 
                //If light is of type p. fresu ("small" F.A.L. fresnel)
                if(fixtures.get(i).fixtureTypeId == 2) {
                  drawLight(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location + 40, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, int(valoScale * 0.6), pFresuConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, 0, fixtures.get(i).parentAnsa, iFresu);
                } else 
                //If light is of type k. fresu (F.A.L. fresnel)
                if(fixtures.get(i).fixtureTypeId == 3) {
                  drawLight(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, valoScale, kFresuConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, 0, fixtures.get(i).parentAnsa, kFresu);
                } else 
                //If light is of type i. fresu ("big" F.A.L. fresnel)
                if(fixtures.get(i).fixtureTypeId == 4) {
                  drawLight(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, valoScale, iFresuConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, 0, fixtures.get(i).parentAnsa, iFresu);
                } else
                //If light is of type flood
                if(fixtures.get(i).fixtureTypeId == 5) {
                  pushMatrix();
                  translate(0, 15, 0);
                  drawFlood(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, valoScale, floodConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, 0, fixtures.get(i).parentAnsa, flood, fixParam[i]);
                  popMatrix();
                } else
                //If light is of type linssi (linssi = lens)
                if(fixtures.get(i).fixtureTypeId == 6) {
                  drawLight(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, valoScale, linssiConeDiameter * map(fixParam[i], 45, -42, 2, 1), fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, 120, fixtures.get(i).parentAnsa, linssi);
                } else
                //If light is of type strobo brightness
                if(fixtures.get(i).fixtureTypeId == 9) {
                  boolean stroboOnTemp = !stroboOn[i];
                  drawStrobo(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, int(valoScale * 1.2), stroboConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, 0, fixtures.get(i).parentAnsa, strobo, stroboOnTemp);
                  stroboOn[i] = stroboOnTemp;
                }
                //If light is of type Stairville MHX50 (moving head)
                if(fixtures.get(i).fixtureTypeId == 16 || fixtures.get(i).fixtureTypeId == 17) {
                  pushMatrix();
                  translate(0, -50, 0);
                  drawMHX(fixtures.get(i).x_location, fixtures.get(i).y_location, fixtures.get(i).z_location, fixtures.get(i).rotationZ, fixtures.get(i).rotationX, valoScale, mhxConeDiameter, fixtures.get(i).getRawColor(), fixtures.get(i).dimmer, -30, fixtures.get(i).parentAnsa, mhMain);
                  popMatrix();
                }
              }
              
              */
              
              
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


void drawFlood(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, color coneColor, int conedim, int coneZOffset, int parentAnsa, PShape lightModel, int LightParam) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa != 0) {
        posZ += ansaZ[parentAnsa];
        posX += ansaX[parentAnsa];
        posY += ansaY[parentAnsa];
      }
      posY -= 20;
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
      
      //Draw light "flaps"
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      translate(0, 12, 18);
      rotateX(radians(-LightParam));
      scale(scale);
      shape(floodCover);
      popMatrix();
      
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      translate(0, -30, 18);
      rotateX(radians(LightParam));
      scale(scale, scale * -1, scale);
      shape(floodCover);
      popMatrix();
      
      //Draw light cone
      if(conedim > 0) {
        pushMatrix();
        translate(posX * 5 - 1000, posY * 5, posZ);
        rotateZ(radians(rotZ));
        rotateX(radians(rotX));
        //Cone offset
        translate(0, 0, coneZOffset);
        scale(scale * coneScale * coneDiam * 2, scale * coneScale  * coneDiam * map(LightParam, 45, -42, 1, 0), scale * coneScale);
        //fill(255, 0, 0, 128);
        fill(coneColor, conedim / 2);
        shape(cone);
        popMatrix();
      }
}

void drawStrobo(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, color coneColor, int conedim, int coneZOffset, int parentAnsa, PShape lightModel, boolean stroboIsOn) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa != 0) {
        posZ += ansaZ[parentAnsa];
        posX += ansaX[parentAnsa];
        posY += ansaY[parentAnsa];
      }
      
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
      if(conedim > 0 && stroboIsOn) {
        pushMatrix();
        translate(posX * 5 - 1000, posY * 5, posZ);
        rotateZ(radians(rotZ));
        rotateX(radians(rotX));
        //Cone offset
        translate(0, 0, coneZOffset);
        scale(scale * coneScale * coneDiam * 2, scale * coneScale  * coneDiam, scale * coneScale);
        //fill(255, 0, 0, 128);
        fill(coneColor, conedim / 2);
        shape(cone);
        popMatrix();
      }
}

void drawMHX(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, color coneColor, int conedim, int coneZOffset, int parentAnsa, PShape lightModel) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa != 0) {
        posZ += ansaZ[parentAnsa];
        posX += ansaX[parentAnsa];
        posY += ansaY[parentAnsa];
      }
      
      //Draw MHX base
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateX(radians(270));
      noStroke();
      scale(scale);
      shape(mhBase);
      popMatrix();
      
      //Draw MHX holder
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(270));
      noStroke();
      scale(scale);
      shape(mhHolder);
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
  public PFrame1() {
          setBounds(0, 0, 600, 340);
          setResizable(true);
          s1 = new secondApplet1();
          add(s1);
          s1.init();
          show();
  }
}

