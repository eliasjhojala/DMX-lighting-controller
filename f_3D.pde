//Tässä välilehdessä piirretään 3D-mallinnus
/*
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */

boolean rotateZopposite = true;

boolean use3D = false;

int userOneFrameRate = 30;
int userTwoFrameRate = 30;

int centerX;
int centerY;

String assetPath;
int[] rotX = { 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135 };
int[] fixZ = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

//0 = None, 1 = ansa 0, 2 = ansa 1
int[] ansaParent = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
int numberOfAnsas = 6;
int[] ansaZ = new int[numberOfAnsas];
int[] ansaX = new int[numberOfAnsas];
int[] ansaY = new int[numberOfAnsas];
int[] ansaType = new int[numberOfAnsas];


int[] fixParam = { 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45 };

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
PShape base;
PShape cone;

float par64ConeDiameter = 0.4;
float pFresuConeDiameter = 0.7;
float kFresuConeDiameter = 0.8;
float iFresuConeDiameter = 0.8;
float linssiConeDiameter = 0.8;
float floodConeDiameter = 0.8;
float stroboConeDiameter = 0.8;

int lavaX = 460, lavaY = 250, lavaSizX = 1000, lavaSizY = 500, lavaH = 100;
boolean lava = false;


boolean[] stroboOn;

void setup() {
  stroboOn = new boolean[ansaTaka];
  
  if(userId == 1) { //Jos Elias käyttää
    assetPath = "/Users/elias/Dropbox/DMX controller/Roopen Kopiot/";
  }
  else { //Jos Roope käyttää
    if(getPaths == true) {
      String lines100[] = loadStrings("C:\\DMXcontrolsettings\\assetPath.txt");
      assetPath = lines100[0];
    }
  }
  
  
  size(700, 500, P3D);
  
  
  //Asetetaan oikeat polut käyttäjän mukaan
  
  String path = "";
  if(userId == 1) { //Jos Elias käyttää
    path = assetPath + "Tallenteet/3D models/";
  }
  else { //Jos Roope käyttää
    path = assetPath + "3D models\\";
  }
  
  par64Model = loadShape(path + "par64.obj");
  par64Holder = loadShape(path + "par64_holder.obj");
  kFresu = loadShape(path + "kFresu.obj");
  iFresu = loadShape(path + "iFresu.obj");
  linssi = loadShape(path + "linssi.obj");
  flood = loadShape(path + "flood.obj");
  floodCover = loadShape(path + "floodCover.obj");
  strobo = loadShape(path + "strobo.obj");
  base = loadShape(path + "base.obj");
  cone = loadShape(path + "cone.obj");
  
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
  
  if(use3D == true) {
 
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
                popMatrix();
              }
              
              
              //Draw lights
              for (int i = 0; i < ansaTaka; i++) {
                //If light is of type par64 OR moving head dim
                if(fixtureType1[i] == 1 || fixtureType1[i] == 13){
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, par64ConeDiameter, red[i], green[i], blue[i], dim[channel[i]], -60, ansaParent[i], par64Model);
                } else 
                //If light is of type p. fresu ("small" F.A.L. fresnel)
                if(fixtureType1[i] == 2) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i] + 40, rotTaka[i], rotX[i], int(valoScale * 0.6), pFresuConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], iFresu);
                } else 
                //If light is of type k. fresu (F.A.L. fresnel)
                if(fixtureType1[i] == 3) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, kFresuConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], kFresu);
                } else 
                //If light is of type i. fresu ("big" F.A.L. fresnel)
                if(fixtureType1[i] == 4) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, iFresuConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], iFresu);
                } else
                //If light is of type flood
                if(fixtureType1[i] == 5) {
                  drawFlood(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, floodConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], flood, fixParam[i]);
                } else
                //If light is of type linssi (linssi = lens)
                if(fixtureType1[i] == 6) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, linssiConeDiameter * map(fixParam[i], 45, -42, 2, 1), red[i], green[i], blue[i], dim[channel[i]], 120, ansaParent[i], linssi);
                } else
                //If light is of type strobo brightness
                if(fixtureType1[i] == 9) {
                  boolean stroboOnTemp = !stroboOn[i];
                  drawStrobo(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], int(valoScale * 1.2), stroboConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], strobo, stroboOnTemp);
                  stroboOn[i] = stroboOnTemp;
                }
              }
              
              
              
              
}
}



void drawLight(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel) {
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
        scale(scale * 100 * coneDiam, scale * 100  * coneDiam, scale * 100);
        //fill(255, 0, 0, 128);
        fill(coneR, coneG, coneB, conedim / 2);
        shape(cone);
        popMatrix();
      }
}


void drawFlood(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel, int LightParam) {
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
        scale(scale * 100 * coneDiam * 2, scale * 100  * coneDiam * map(LightParam, 45, -42, 1, 0), scale * 100);
        //fill(255, 0, 0, 128);
        fill(coneR, coneG, coneB, conedim / 2);
        shape(cone);
        popMatrix();
      }
}

void drawStrobo(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel, boolean stroboIsOn) {
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
        scale(scale * 100 * coneDiam * 2, scale * 100  * coneDiam, scale * 100);
        //fill(255, 0, 0, 128);
        fill(coneR, coneG, coneB, conedim / 2);
        shape(cone);
        popMatrix();
      }
}




 

void mouseDragged()
{
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

