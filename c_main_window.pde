void drawMainWindow() {
  pushMatrix();
    //TÄSSÄ KÄÄNNETÄÄN JA SIIRRETÄÄN NÄKYMÄ OIKEIN - DO ROTATE AND TRANSFORM RIGHT
   
   
   //Transform
   
   
   translate(width/2, height/2);
   translate(x_siirto, y_siirto); //Siirretään sivua oikean verran - move page
   scale(float(zoom)/100); //Skaalataan sivua oikean verran - scale page
   rotate(radians(pageRotation)); //Käännetään sivua oikean verran - rotate page
   translate(-width/2, -height/2); //move page back
   //translate(0, 50); //Siirretään kaikkea alaspäin ylävalikon verran - move all the objects down because top menu
   
   
   
   {//begin drawing all elements (fixtures & other non-HUD objects)
     //TÄSSÄ PIIRRETÄÄN ANSAT - DRAW TRUSSES
    ansat();
    
    //Just using the rotation of PVectors, it already exists, so why not use it?
    PVector mouseRotated = new PVector(mouseX, mouseY);
    mouseRotated.rotate(radians(-pageRotation));
    
    if(moveLamp) {
      mouseLocked = true;
      mouseLocker = "main:fixMove";
    }
    
    for(int i = 0; i < ansaTaka; i++) {
      pushMatrix();
          if(!mouseLocked || mouseLocker == "main:fixMove") {
              if(!mousePressed) {
                if(moveLamp == true) {
                 if(lampToMove < ansaTaka) {
                  fixtures[lampToMove].x_location = fixtures[lampToMove].x_location + (int(mouseRotated.x) - oldMouseX1) * 100 / zoom - ansaX[fixtures[lampToMove].parentAnsa];
                  fixtures[lampToMove].y_location = fixtures[lampToMove].y_location + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom;
                  
                }
          
                moveLamp = false;
                }
                  
              }
      
            if(moveLamp == true) {
              mouseLocked = true;
              mouseLocker = "main:fixMove";
              if(i == lampToMove) { translate(fixtures[lampToMove].x_location + ((int(mouseRotated.x) - oldMouseX1) * 100 / zoom), fixtures[lampToMove].y_location + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom + ansaY[fixtures[lampToMove].parentAnsa]); }
              else { translate(fixtures[i].x_location+ansaX[fixtures[i].parentAnsa], fixtures[i].y_location+ansaY[fixtures[i].parentAnsa]); }
            }
            else { translate(fixtures[i].x_location+ansaX[fixtures[i].parentAnsa], fixtures[i].y_location+ansaY[fixtures[i].parentAnsa]); }
          }
          
          
          else { translate(fixtures[i].x_location+ansaX[fixtures[i].parentAnsa], fixtures[i].y_location+ansaY[fixtures[i].parentAnsa]); }
  
  
         if(fixtureType1[i] != 14) { rotate(radians(fixtures[i].rotationZ)); }
         
          if(!mouseLocked || mouseLocker == "main:fixMove") {
            if(mousePressed) {
              
            //IF cursor is hovering over i:th fixtures bounding box AND fixture should be drawn AND mouse is clicked
            if(isHover(0, 0, fixtures[i].size.w, fixtures[i].size.h) && fixtures[i].size.isDrawn && mousePressed) {
             
              if(mouseButton == RIGHT) {
                toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i; 
                mouseLocked = true;
                mouseLocker = "main:openToolBox";
                
                contextMenu1.initiateForFixture(i);
              }
              else if(mouseReleased) {
                oldMouseX1 = int(mouseRotated.x);
                oldMouseY1 = int(mouseRotated.y);
                lampToMove = i;
                moveLamp = true;
                mouseReleased = false;
              }
            }
          }
        }
            
            
            drawFixture(i);
          //
      popMatrix();
      
    }
    popMatrix();
    
    if(!mousePressed) { mouseLocked = false; }
    
  }//Endof: draw all elements
      
  //---------------View drag & box selection
  if(!moveLamp && inBdsMouse(0, 0, width - 165, height - 225) && !isHoverBottomMenu() && !memoryCreator.isMouseOver()) {
    if(mousePressed) {
      println("gothere");
      if (mouseButton == LEFT) {
        if (!mouseLocked || mouseLocker == "main") {
          mouseLocked = true;
          mouseLocker = "main";
          movePage();
        }
      } else if(mouseButton == RIGHT) {
        //Box select
        
        
        doBoxSelect();
      }
    }
  }
  if(!mousePressed && boxSelect) thread("endBoxSelect");
}




//----------\
int boxStartX, boxStartY;
boolean boxSelect = false;
void doBoxSelect() {
    if (!mouseLocked) {
      
      mouseLocked = true;
      mouseLocker = "boxSelect";
      boxSelect = true;
      boxStartX = mouseX;
      boxStartY = mouseY; 
    } else if(mouseLocker.equals("boxSelect")) {
      
      pushStyle();
      fill(50, 50, 150, 150);
      stroke(0, 0, 150);
      rectMode(CORNERS);
      rect(mouseX, mouseY, boxStartX, boxStartY);
      popStyle();
    }
  
}
void endBoxSelect() {
  boxSelect = false;
  
  //Get smallest corners of the box
  int[] cornerX = { boxStartX, mouseX };
  int x1 = min(cornerX);
  int x2 = max(cornerX);
  int[] cornerY = { boxStartY, mouseY };
  int y1 = min(cornerY);
  int y2 = max(cornerY);
  
  boolean shiftDown = keyPressed && keyCode == SHIFT;
  for (int i = 0; i < fixtures.length; i++) {
    boolean inside = inBds2D(
      fixtures[i].locationOnScreenX,
      fixtures[i].locationOnScreenY,
      x1, y1,
      x2, y2
    );
    
    if(shiftDown) fixtures[i].selected = fixtures[i].selected || inside; else fixtures[i].selected = inside;
    
   
  }
}
//----------/
