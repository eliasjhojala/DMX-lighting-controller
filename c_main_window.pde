void drawMainWindow() {
  pushMatrix(); 
    //TÄSSÄ KÄÄNNETÄÄN JA SIIRRETÄÄN NÄKYMÄ OIKEIN - DO ROTATE AND TRANSFORM RIGHT
   
   mouse.declareUpdateElement("main:fixtures", 0, 0, 0, width, height);
   mouse.getElementByName("main:fixtures").autoCapture = false;
   mouse.declareUpdateElement("main:move", 0, 0, 0, width, height);
   mouse.getElementByName("main:move").autoCapture = false;
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
    
    /*if(moveLamp) {
      mouseLocked = true;
      mouseLocker = "main:fixMove";
    }*/
    
   for(int i = 0; i < fixtures.size(); i++) if(fixtures.get(i).size.isDrawn) {
     pushMatrix();
        if(!mouse.captured || mouse.isCaptured("main:fixtures")) {
          if(!mousePressed && moveLamp == true) {
            if(lampToMove < fixtures.size()) {
             fixtures.get(lampToMove).x_location = fixtures.get(lampToMove).x_location + (int(mouseRotated.x) - oldMouseX1) * 100 / zoom;
             fixtures.get(lampToMove).y_location = fixtures.get(lampToMove).y_location + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom;
            }
     
           moveLamp = false; 
          }
    
          if(moveLamp == true) {
            mouse.capture(mouse.getElementByName("main:fixtures"));
            if(i == lampToMove) { translate(fixtures.get(lampToMove).x_location + ((int(mouseRotated.x) - oldMouseX1) * 100 / zoom)  + ansaX[fixtures.get(lampToMove).parentAnsa], fixtures.get(lampToMove).y_location + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom + ansaY[fixtures.get(lampToMove).parentAnsa]); }
              else { translate(fixtures.get(i).x_location+ansaX[fixtures.get(i).parentAnsa], fixtures.get(i).y_location+ansaY[fixtures.get(i).parentAnsa]); }
          } else { translate(fixtures.get(i).x_location+ansaX[fixtures.get(i).parentAnsa], fixtures.get(i).y_location+ansaY[fixtures.get(i).parentAnsa]); }
        } else { translate(fixtures.get(i).x_location+ansaX[fixtures.get(i).parentAnsa], fixtures.get(i).y_location+ansaY[fixtures.get(i).parentAnsa]); }
        
          
        if(fixtures.get(i).fixtureTypeId != 14) { rotate(radians(fixtures.get(i).rotationZ)); }
        
        
             
       //IF cursor is hovering over i:th fixtures bounding box AND fixture should be drawn AND mouse is clicked
       if(isHover(0, 0, fixtures.get(i).size.w, fixtures.get(i).size.h) && mousePressed && !mouse.captured) {
        
         if(mouseButton == RIGHT) {
           toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i; 
           mouse.capture(mouse.getElementByName("main:fixtures"));
           
           contextMenu1.initiateForFixture(i);
         }
         else {
           mouse.capture(mouse.getElementByName("main:fixtures"));
           if(!showMode) {
             oldMouseX1 = int(mouseRotated.x);
             oldMouseY1 = int(mouseRotated.y);
             lampToMove = i;
             moveLamp = true;
             mouseReleased = false;
           } 
           else {
              fixtures.get(i).toggle(true);
           }
           
         }
       }
           
       
       
       
       drawFixture(i);
          //
      popMatrix();
      
    }
    popMatrix();
    
    
    
  }//Endof: draw all elements
      
  //---------------View drag & box selection
  if(!moveLamp) {
    
    if(mousePressed) {
      
      if (mouseButton == LEFT) {
        if (!mouse.captured || mouse.isCaptured("main:move")) {
          mouse.capture(mouse.getElementByName("main:move"));
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
    if (!mouse.captured) {
      
      mouse.capture(mouse.getElementByName("main:move"));
      
      boxSelect = true;
      boxStartX = mouseX;
      boxStartY = mouseY; 
    } else if(mouse.isCaptured("main:move")) {
      
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
  
  if(abs(x2 - x1) > 15 && abs(y2 - y1) > 15) {
    
    boolean shiftDown = keyPressed && keyCode == SHIFT;
    boolean ctrlDown = keyPressed && keyCode == CONTROL;
    
    for (int i = 0; i < fixtures.size(); i++) {
      boolean inside = inBds2D(
        fixtures.get(i).locationOnScreenX,
        fixtures.get(i).locationOnScreenY,
        x1, y1,
        x2, y2
      );
      
      
      if(shiftDown) fixtures.get(i).selected = fixtures.get(i).selected || inside; //additive select
        else if(ctrlDown) fixtures.get(i).selected = inside ? false : fixtures.get(i).selected; //exclusive select
          else fixtures.get(i).selected = inside;
        
       
    }
  } else {
    //open contextMwnu
    String[] acts = { "createNewFixtureAt00" };
    String[] texs = { "Create new fixture" };
    contextMenu1.initiate(acts, texs, mouseX, mouseY);
  }
}
//----------/
