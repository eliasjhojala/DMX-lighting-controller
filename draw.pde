//Tässä välilehdessä on koko ohjelman ydin, eli draw-loop

int grandMaster = 50;
int oldGrandMaster = 40;
void draw() {
  for(int i = 0; i < channels; i++) {
    dim[i] = round(map(dimInput[i], 0, 255, 0, grandMaster));
  }
  memoryType[1] = 4; //Ensimmäisessä memorypaikassa on grandMaster
  memoryType[2] = 5; //Toisessa memorypaikassa on fade
  fill(0, 0, 0);
  if(printMode == true) { //Tarkistetaan onko tulostusmode päällä
    background(255, 255, 255); //Jos tulostusmode on päällä taustaväri on valkoinen
    stroke(0, 0, 0); //Jos tulostusmode on päällä kuvioiden reunat ovat mustia
  }
  else {
    background(0, 0, 0); //Jos tulostusmode on pois päältä taustaväri on musta
    stroke(255, 255, 255); //Jos tulostusmode on pois päältä kuvoiden reunat ovat valkoisia
  }
  
   
   translate(x_siirto, y_siirto); //Siirretään sivua oikean verran
   rotate(radians(pageRotation)); //Käännetään sivua oikean verran
   
  ansat();
  dmxCheck();
  dmxToDim();
  
  
  
  memoryData = new int[channels];
  for(int i = 0; i < numberOfMemories; i++) {
    if(useSolo == true) {
      if(valueOfMemory[soloMemory] < 10) {
        if(soloWasHere == true) {
          memory(i, valueOfMemoryBeforeSolo[i]);
          dimInput[i] = valueOfChannelBeforeSolo[i];
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
            if(valueOfMemory[i] != 0 || dim[i] != 0) {
              valueOfMemoryBeforeSolo[i] = valueOfMemory[i];
              valueOfChannelBeforeSolo[i] = dim[i];
            }
            memory(i, 0);
            dimInput[i] = 0; 
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
      dimInput[i] = memoryData[i];
      if (memoryData[i] == 0) {memoryIsZero[i] = true;} else {memoryIsZero[i] = false;}
    }
  }
  
  if(blackOut == true)  { //Tarkistetaan onko blackout päällä
     grandMaster = 0;
  }
  
   if(fullOn == true)  { //Tarkistetaan onko blackout päällä
     for(int i = 0; i < channels; i++) { //Käydään kaikki kanavat läpi
       dimInput[i] = 255; //Asetetaan kanavan arvoksi nolla
     }
  }
  
 
  arduinoSend(); //Lähetetään dim-arvot arduinolle, joka lähettää ne edelleen DMX-shieldille
  translate(0, 0);
  
 
  
  for(int i = 0; i < ansaTaka; i++) {
    if(move == true && (mouseLocked == false || mouseLocker == "main")) {
      if(mouseClicked == true) {
          if(mouseX > (xTaka[i])*zoom/100 + x_siirto && mouseX < (xTaka[i])*zoom/100 + 30 + x_siirto && mouseY > (yTaka[i])*zoom/100 + y_siirto && mouseY < (yTaka[i])*zoom/100 + 50 + y_siirto) {
            if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = fixtureIdOriginal[i]; }
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
  
        moveLamp = false;
        }
        }
      if(moveLamp == true) {
        if(i == lampToMove) { translate(mouseX, mouseY); }
        else { translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100); }
      }
      else { translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100); }
    }
    else { translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100); }
     if(fixtureType1[i] != 14) { rotate(radians(rotTaka[i])); }
      kalvo(round(map(red[i], 0, 255, 0, dim[channel[i]])), round(map(green[i], 0, 255, 0, dim[channel[i]])), round(map(blue[i], 0, 255, 0, dim[channel[i]])));
      drawFixture(i);
     if(fixtureType1[i] != 14) { rotate(radians(rotTaka[i] * (-1))); }
     if(moveLamp == true) {
      if(i == lampToMove) { translate(0-mouseX, 0-mouseY); }
      else { translate((0-xTaka[i])*zoom/100, (0-yTaka[i])*zoom/100); }
     }
     else { translate((0-xTaka[i])*zoom/100, (0-yTaka[i])*zoom/100); }
  }
  

 
  rotate(radians(pageRotation*(-1)));
  translate((x_siirto)*(-1), (y_siirto)*(-1));
  ylavalikko();
  alavalikko();
  sivuValikko();
  translate(x_siirto, y_siirto);
  
  

}
