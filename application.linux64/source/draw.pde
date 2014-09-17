void draw() {
  memoryType[1] = 4;
  memoryType[2] = 5;
  memoryType[3] = 6;
  fill(0, 0, 0);
  background(0, 0, 0);
  stroke(255, 255, 255);
   
   translate(x_siirto, y_siirto);
   rotate(radians(pageRotation));
  ansat();
  dmxCheck();
  dmxToDim();
  memoryData = new int[channels];
  for(int i = 0; i < numberOfMemories; i++) {
    if(useSolo == true) {
      if(valueOfMemory[soloMemory] < 10) {
        if(soloWasHere == true) {
          memory(i, valueOfMemoryBeforeSolo[i]);
          soloWasHere = false;
        }
        else {
          if(valueOfMemory[i] > 0) {
            memory(i, valueOfMemory[i]);
          }
        }
      }
      else {
        soloWasHere = true;
        if(soloWasHere == false) {
          if(i == soloMemory && valueOfMemory[i] != 0) {
            memory(i, valueOfMemory[i]);
          }
          else {
            if(valueOfMemory[i] != 0) {
              valueOfMemoryBeforeSolo[i] = valueOfMemory[i];
            }
            memory(i, 0);
          }
        }
        else {
          if(i == soloMemory && valueOfMemory[i] != 0) {
            memory(i, valueOfMemory[i]);
          }
        }
      }
    }
    else {
      if(valueOfMemory[i] > 0) {
        memory(i, valueOfMemory[i]);
      }
    }
  }
  for (int i = 0; i < channels; i++) {
    if (memoryData[i] != 0 || memoryIsZero[i] == false) {
      dim[i] = memoryData[i];
      if (memoryData[i] == 0) {memoryIsZero[i] = true;} else {memoryIsZero[i] = false;}
    }
  }
  
  if(play == false) {
    if(chase == false) {
      if(dmxSoundToLight == false) {
        
      }
      else {
       // beatDetectionDMX(1, 3, 2);
      }
    }
    else {
//      chaser(1);
    }
  }
  else {
    toista();
  }
  arduinoSend();
  if(rec == true) {
    tallennus();
  }
  delay(10);
  translate(0, 0);
  
 
  
  for(int i = 0; i < ansaTaka; i++) {
    if(move == true && (mouseLocked == false || mouseLocker == "main")) {
    if(mouseClicked == true) {
        if(mouseX > (xTaka[i])*zoom/100 + x_siirto && mouseX < (xTaka[i])*zoom/100 + 30 + x_siirto && mouseY > (yTaka[i])*zoom/100 + y_siirto && mouseY < (yTaka[i])*zoom/100 + 50 + y_siirto) {
          if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i; }
          else {
            lampToMove = i;
            moveLamp = true;
          }
        }
      }
      else {
      if(moveLamp == true) {
       if(lampToMove < ansaTaka) {
        xTaka[lampToMove] = mouseX;
        yTaka[lampToMove] = mouseY;
      }
//      else {
//        xEtu[lampToMove-ansaTaka] = mouseX;
//        yEtu[lampToMove-ansaTaka] = mouseY;
//      }
      moveLamp = false;
      }
      }
    if(moveLamp == true) {
    if(i == lampToMove) {
      translate(mouseX, mouseY);
    }
    else {
      translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100);
    }
    }
    else {
      translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100);
    }
    }
    else {
      translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100);
    }
      rotate(radians(rotTaka[i]));
      kalvo(round(map(red[i], 0, 255, 0, dim[channel[i]])), round(map(green[i], 0, 255, 0, dim[channel[i]])), round(map(blue[i], 0, 255, 0, dim[channel[i]])));
      drawFixture(i);
      rotate(radians(rotTaka[i] * (-1)));
     if(moveLamp == true) {
    if(i == lampToMove) {
      translate(0-mouseX, 0-mouseY);
    }
    else {
      translate((0-xTaka[i])*zoom/100, (0-yTaka[i])*zoom/100);
    }
    }
    else {
      translate((0-xTaka[i])*zoom/100, (0-yTaka[i])*zoom/100);
    }
  }
  
//Valoja ei enää lajitella erikseen ansoille, joten alla oleva koodi on turha
  
//  for(int i = 0; i < ansaEtu; i++) {
//    if(move == true && (mouseLocked == false || mouseLocker == "main")) {
//    if(mouseClicked == true) {
//        if(mouseX > xEtu[i] && mouseX < xEtu[i] + 30 && mouseY > yEtu[i] && mouseY < yEtu[i] + 50) {
//          if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i+ansaTaka; }
//          else {
//            lampToMove = i+ansaTaka;
//            moveLamp = true;
//          }
//        }
//    }
//    else {
//      if(moveLamp == true) {
//      if(lampToMove <= ansaTaka) {
//        xTaka[lampToMove] = mouseX;
//        yTaka[lampToMove] = mouseY;
//      }
//      else {
//      xEtu[lampToMove-ansaTaka] = mouseX;
//      yEtu[lampToMove-ansaTaka] = mouseY;
//    }
//    moveLamp = false;
//      }
//    }
//    if(moveLamp == true) {
//    if(i+ansaTaka == lampToMove) {
//      translate(mouseX, mouseY);
//    }
//    else {
//      translate((xEtu[i])*zoom/100, (yEtu[i])*zoom/100);
//    }
//    }
//    else {
//      translate((xEtu[i])*zoom/100, (yEtu[i])*zoom/100);
//    }
//    }
//    else {
//      translate((xEtu[i])*zoom/100, (yEtu[i])*zoom/100);
//    }
//    rotate(0);
//   
//    kalvo(round(map(red[i], 0, 255, 0, dim[channel[i+ansaTaka]])), round(map(green[i], 0, 255, 0, dim[channel[i+ansaTaka]])), round(map(blue[i], 0, 255, 0, dim[channel[i+ansaTaka]])));
//    par64(0, 0, dim[channel[i+ansaTaka]], channel[i+ansaTaka]);
//    if(moveLamp == true) {
//    if(i+ansaTaka == lampToMove) {
//      translate(0-mouseX, 0-mouseY);
//    }
//    else {
//      translate((0-xEtu[i])*zoom/100, (0-yEtu[i])*zoom/100);
//    }
//    }
//    else {
//      translate((0-xEtu[i])*zoom/100, (0-yEtu[i])*zoom/100);
//    }
//  }
  
   if(useMovingHead == true) {
     rectMode(CENTER);
    translate(width/2, height/2);
    rotate(radians(90-movingHeadPan));
    kalvo(round(map(movingHeadRed, 0, 255, 0, movingHeadDim)), round(map(movingHeadGreen, 0, 255, 0, movingHeadDim)), round(map(movingHeadBlue, 0, 255, 0, movingHeadDim)));
    par64(movingHeadDimChannel);
    rotate(radians((90-movingHeadPan) * (-1)));
    translate(-200, -200);
    rectMode(CORNER);
  }
  rotate(radians(pageRotation*(-1)));
  translate((x_siirto)*(-1), (y_siirto)*(-1));
  ylavalikko();
  alavalikko();
  sivuValikko();
  translate(x_siirto, y_siirto);

}
