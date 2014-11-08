//Tässä välilehdessä piirretään ylävalikko, ja käsitellään sen nappuloiden komentoja 

color topMenuTheme = color(222, 0, 0);
color topMenuAccent = color(150, 0, 0);

void ylavalikko() {
  pushStyle();
  
  //Draw bubble
  noFill();
  stroke(0, 120); strokeWeight(6);
  arc(0, 0, 250, 250, 0, HALF_PI);
  fill(topMenuTheme);
  stroke(topMenuAccent); strokeWeight(2);
  arc(0, 0, 250, 250, 0, HALF_PI);
  
  
  
  
  //Time display
  fill(255);
  textSize(25);
  text(hour() + ":" + minute() + ":" + second(), 3, 28);
  textSize(12);
  text("Loaded file: dsdjlsdl h klhklhdf hkjdhfsk  hksdhf ksdfhj khj ksdhjf kh kfh skdh khk  fhjksdfh skdfh ksdfh ks", 3, 28, 125, 125);
  
  popStyle();
}

void nextChaseMode() {
  resetChaseVariables();
  chaseMode++;
  if(chaseMode > 8) {
    chaseMode = 1;
  }
  sendDataToIpad("/chaseMode", chaseMode);
  resetChaseVariables();
}

void reverseChaseMode() {
  resetChaseVariables();
  chaseMode--;
  if(chaseMode < 1) {
    chaseMode = 8;
  }
  sendDataToIpad("/chaseMode", chaseMode);
  resetChaseVariables();
}

void resetChaseVariables() {
  //This void resets all the chase variables, because otherwise chaseModes could make trouble to each others
  chaseStepChanging = new boolean[numberOfMemories];
  chaseStepChangingRev = new boolean[numberOfMemories];
  fallingEdgeChaseStepChangin = new boolean[numberOfMemories];
  
  chaseStep1 = 1;
  chaseStep2 = 1;
  chaseBright1 = new int[numberOfMemories];
  chaseBright2 = new int[numberOfMemories];
  
  
  //These two variables are important to prevent trouble between chaseMode 8 and 3
  steppi = new int[numberOfMemories];
  steppi1 = new int[numberOfMemories];
}



