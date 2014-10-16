void drawMainWindow() {
  pushMatrix();
    //TÄSSÄ KÄÄNNETÄÄN JA SIIRRETÄÄN NÄKYMÄ OIKEIN - DO ROTATE AND TRANSFORM RIGHT
   
   
   //Transform
   
   
   translate(width/2, height/2);
   translate(x_siirto, y_siirto); //Siirretään sivua oikean verran - move page
   scale(float(zoom)/100); //Skaalataan sivua oikean verran - scale page
   rotate(radians(pageRotation)); //Käännetään sivua oikean verran - rotate page
   translate(-width/2, -height/2); //move page back
   translate(0, 50); //Siirretään kaikkea alaspäin ylävalikon verran - move all the objects down because top menu
   
   
   
   
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
        visualisationSettingsFromMovingHeadData(i); //Set right values to fixtures in visualisation
        pushMatrix();
            if(move && (!mouseLocked || mouseLocker == "main")) {
                if(!mouseClicked) {
                  if(moveLamp == true) {
                   if(lampToMove < ansaTaka) {
                    xTaka[lampToMove] = xTaka[lampToMove] + (int(mouseRotated.x) - oldMouseX1) * 100 / zoom - ansaX[ansaParent[lampToMove]];
                    yTaka[lampToMove] = yTaka[lampToMove] + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom;
                    
                  }
            
                  moveLamp = false;
                  }
                    
                }
        
              if(moveLamp == true) {
                mouseLocked = true;
                mouseLocker = "main";
                if(i == lampToMove) { translate(xTaka[lampToMove] + ((int(mouseRotated.x) - oldMouseX1) * 100 / zoom), yTaka[lampToMove] + (int(mouseRotated.y) - oldMouseY1) * 100 / zoom + ansaY[ansaParent[lampToMove]]); }
                else { translate(xTaka[i]+ansaX[ansaParent[i]], yTaka[i]+ansaY[ansaParent[i]]); }
              }
              else { translate(xTaka[i]+ansaX[ansaParent[i]], yTaka[i]+ansaY[ansaParent[i]]); }
            }
            
            
            else { translate(xTaka[i]+ansaX[ansaParent[i]], yTaka[i]+ansaY[ansaParent[i]]); }


           if(fixtureType1[i] != 14) { rotate(radians(rotTaka[i])); }
           kalvo(round(map(red[i], 0, 255, 0, dim[channel[i]])), round(map(green[i], 0, 255, 0, dim[channel[i]])), round(map(blue[i], 0, 255, 0, dim[channel[i]])));
            
            
            
            if(move && (!mouseLocked || mouseLocker == "main")) {
              if(mouseClicked) {
                mouseLocked = true;
                mouseLocker = "main";
              
              
              //Get dimensions for the current fixture
              int[] fixSize = getFixtureSize(i);
              
              //IF cursor is hovering over i:th fixtures bounding box AND fixture should be drawn AND mouse is clicked
              if(isHover(0, 0, fixSize[0], fixSize[1]) && fixSize[2] == 1 && mouseClicked) {
               
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
        if(mouseReleased) { mouseLocked = false; }
      }
      popMatrix();
}



void visualisationSettingsFromMovingHeadData(int i) {
  if(fixtureType1[i] == 16) {
    slowRotationForMovingHead(0, i);
    colorsToMovingHeadVisualisation(0, i);
  }
  if(fixtureType1[i] == 17) {
    slowRotationForMovingHead(1, i);
    colorsToMovingHeadVisualisation(1, i);
  }
}

void slowRotationForMovingHead(int id, int i) {
  slowRotationForMovingHead2(id, i);
}

void slowRotationForMovingHead1(int id, int i) {
  if(rotTaka[i] < round(map(mhx50_createFinalChannelValues[id][0], 255, 0, 0, 540))) { rotTaka[i] += 5; }
  if(rotTaka[i] > round(map(mhx50_createFinalChannelValues[id][0], 255, 0, 0, 540))) { rotTaka[i] -= 5; }
  if(rotX[i] < round(map(mhx50_createFinalChannelValues[id][1], 0, 255, 45, 270+45))) { rotX[i] += 5; }
  if(rotX[i] > round(map(mhx50_createFinalChannelValues[id][1], 0, 255, 45, 270+45))) { rotX[i] -= 5; }  
}


void slowRotationForMovingHead2(int id, int i) {
  if(rotTaka[i] < round(map(mhx50_createFinalChannelValues[id][0], 255, 0, 0, 540))) { rotTaka[i] += constrain(round((map(float(mhx50_createFinalChannelValues[id][0]), 255, 0, 0, 540) - float(rotTaka[i]))/40+0.6), 1, 8); }
  if(rotTaka[i] > round(map(mhx50_createFinalChannelValues[id][0], 255, 0, 0, 540))) { rotTaka[i] -= constrain(round((float(rotTaka[i]) - map(float(mhx50_createFinalChannelValues[id][0]), 255, 0, 0, 540))/40+0.6), 1, 8); }
  if(rotX[i] < round(map(mhx50_createFinalChannelValues[id][1], 0, 255, 45, 270+45))) { rotX[i] += constrain(round((map(float(mhx50_createFinalChannelValues[id][1]), 0, 255, 45, 270+45) - float(rotX[i]))/40+0.6), 1, 8); }
  if(rotX[i] > round(map(mhx50_createFinalChannelValues[id][1], 0, 255, 45, 270+45))) { rotX[i] -= constrain(round((float(rotX[i]) - map(float(mhx50_createFinalChannelValues[id][1]), 0, 255, 45, 270+45))/40+0.6), 1, 8); }
}

void colorsToMovingHeadVisualisation(int id, int i) {
  red[i] = mhx50_RGB_color_Values[mhx50_colorNumber[id]][0];
  green[i] = mhx50_RGB_color_Values[mhx50_colorNumber[id]][1];
  blue[i] = mhx50_RGB_color_Values[mhx50_colorNumber[id]][2];
}
