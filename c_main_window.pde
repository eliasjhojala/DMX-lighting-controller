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
        if(fixtureType1[i] == 16) {

          
          if(rotTaka[i] < round(map(mhx50_createFinalChannelValues[0][0], 0, 255, 0, 540))) {
            rotTaka[i] += 5;
          }
          if(rotTaka[i] > round(map(mhx50_createFinalChannelValues[0][0], 0, 255, 0, 540))) {
            rotTaka[i] -= 5;
          }
          if(rotX[i] < round(map(mhx50_createFinalChannelValues[0][1], 0, 255, 45, 270+45))) {
            rotX[i] += 5;
          }
          if(rotX[i] > round(map(mhx50_createFinalChannelValues[0][1], 0, 255, 45, 270+45))) {
            rotX[i] -= 5;
          }

//          rotTaka[i] = round(map(mhx50_createFinalChannelValues[0][0], 0, 255, 0, 540));
//          rotX[i] = round(map(mhx50_createFinalChannelValues[0][1], 0, 255, 0, 270));
          
          
//          if(red[i] < mhx50_RGB_color_Values[mhx50_colorNumber[0]][0]) { red[i] += round((mhx50_RGB_color_Values[mhx50_colorNumber[0]][0] - red[i]) / 10); }
//          if(red[i] > mhx50_RGB_color_Values[mhx50_colorNumber[0]][0]) { red[i] -= round((red[i] - mhx50_RGB_color_Values[mhx50_colorNumber[0]][0]) / 10); }
//          if(green[i] < mhx50_RGB_color_Values[mhx50_colorNumber[0]][1]) { green[i] += round((mhx50_RGB_color_Values[mhx50_colorNumber[0]][1] - green[i]) / 10); }
//          if(green[i] > mhx50_RGB_color_Values[mhx50_colorNumber[0]][1]) { green[i] -= round((green[i] - mhx50_RGB_color_Values[mhx50_colorNumber[0]][1]) / 10); }
//          if(blue[i] < mhx50_RGB_color_Values[mhx50_colorNumber[0]][2]) { blue[i] += round((mhx50_RGB_color_Values[mhx50_colorNumber[0]][2] - blue[i]) / 10); }
//          if(blue[i] > mhx50_RGB_color_Values[mhx50_colorNumber[0]][2]) { blue[i] -= round((blue[i] - mhx50_RGB_color_Values[mhx50_colorNumber[0]][2]) / 10); }
          
          red[i] = mhx50_RGB_color_Values[mhx50_colorNumber[0]][0];
          green[i] = mhx50_RGB_color_Values[mhx50_colorNumber[0]][1];
          blue[i] = mhx50_RGB_color_Values[mhx50_colorNumber[0]][2];
        }
        if(fixtureType1[i] == 17) {
          
          if(rotTaka[i] < round(map(mhx50_createFinalChannelValues[1][0], 0, 255, 0, 540))) {
            rotTaka[i] += 5;
          }
          if(rotTaka[i] > round(map(mhx50_createFinalChannelValues[1][0], 0, 255, 0, 540))) {
            rotTaka[i] -= 5;
          }
          if(rotX[i] < round(map(mhx50_createFinalChannelValues[1][1], 0, 255, 45, 270+45))) {
            rotX[i] += 5;
          }
          if(rotX[i] > round(map(mhx50_createFinalChannelValues[1][1], 0, 255, 45, 270+45))) {
            rotX[i] -= 5;
          }

//          rotTaka[i] = round(map(mhx50_createFinalChannelValues[1][0], 0, 255, 0, 540));
//          rotX[i] = round(map(mhx50_createFinalChannelValues[1][1], 0, 255, 0, 270));
          
//          if(red[i] < mhx50_RGB_color_Values[mhx50_colorNumber[1]][0]) { red[i] += round((mhx50_RGB_color_Values[mhx50_colorNumber[1]][0] - red[i]) / 10); }
//          if(red[i] > mhx50_RGB_color_Values[mhx50_colorNumber[1]][0]) { red[i] -= round((red[i] - mhx50_RGB_color_Values[mhx50_colorNumber[1]][0]) / 10); }
//          if(green[i] < mhx50_RGB_color_Values[mhx50_colorNumber[1]][1]) { green[i] += round((mhx50_RGB_color_Values[mhx50_colorNumber[1]][1] - green[i]) / 10); }
//          if(green[i] > mhx50_RGB_color_Values[mhx50_colorNumber[1]][1]) { green[i] -= round((green[i] - mhx50_RGB_color_Values[mhx50_colorNumber[1]][1]) / 10); }
//          if(blue[i] < mhx50_RGB_color_Values[mhx50_colorNumber[1]][2]) { blue[i] += round((mhx50_RGB_color_Values[mhx50_colorNumber[1]][2] - blue[i]) / 10); }
//          if(blue[i] > mhx50_RGB_color_Values[mhx50_colorNumber[1]][2]) { blue[i] -= round((blue[i] - mhx50_RGB_color_Values[mhx50_colorNumber[1]][2]) / 10); }
          
          red[i] = mhx50_RGB_color_Values[mhx50_colorNumber[1]][0];
          green[i] = mhx50_RGB_color_Values[mhx50_colorNumber[1]][1];
          blue[i] = mhx50_RGB_color_Values[mhx50_colorNumber[1]][2];
        }
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
