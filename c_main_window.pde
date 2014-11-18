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
   
   
   
   
       //TÄSSÄ PIIRRETÄÄN ANSAT - DRAW TRUSSES
      ansat();
      
      //Just using the rotation of PVectors, it already exists, so why not use it?
      PVector mouseRotated = new PVector(mouseX, mouseY);
      mouseRotated.rotate(radians(-pageRotation));
      
      if(moveLamp) {
        mouseLocked = true;
        mouseLocker = "main";
      }
      
      for(int i = 0; i < ansaTaka; i++) {
        pushMatrix();
            if(move && (!mouseLocked || mouseLocker == "main")) {
                if(!mouseClicked) {
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
                mouseLocker = "main";
                if(i == lampToMove) { translate(fixtures[lampToMove].x_location + ((int(mouseRotated.x) - oldMouseX1) * 100 / zoom), fixtures[lampToMove].y_location + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom + ansaY[fixtures[lampToMove].parentAnsa]); }
                else { translate(fixtures[i].x_location+ansaX[fixtures[i].parentAnsa], fixtures[i].y_location+ansaY[fixtures[i].parentAnsa]); }
              }
              else { translate(fixtures[i].x_location+ansaX[fixtures[i].parentAnsa], fixtures[i].y_location+ansaY[fixtures[i].parentAnsa]); }
            }
            
            
            else { translate(fixtures[i].x_location+ansaX[fixtures[i].parentAnsa], fixtures[i].y_location+ansaY[fixtures[i].parentAnsa]); }


           if(fixtureType1[i] != 14) { rotate(radians(fixtures[i].rotationZ)); }

            
            
            
            if(move && (!mouseLocked || mouseLocker == "main")) {
              if(mouseClicked) {
                mouseLocked = true;
                mouseLocker = "main";
              
              
              
              //IF cursor is hovering over i:th fixtures bounding box AND fixture should be drawn AND mouse is clicked
              if(isHover(0, 0, fixtures[i].size.w, fixtures[i].size.h) && fixtures[i].size.isDrawn && mouseClicked) {
               
                if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i; }
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
        if(!mousePressed) { mouseLocked = false; }
      }
      popMatrix();
}
