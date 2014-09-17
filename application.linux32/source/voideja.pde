void arduinoSend() {
  if(useCOM == true) {
  for(int i = 0; i < channels; i++) {
    if(dim[i] != dimOld[i]) {
      setDmxChannel(i, dim[i]);
      dimOld[i] = dim[i];
    }
  }
  }
}

void tallennus() {
  countteri++;
  for(int i = 0; i < 12; i++) {
    recVal[countteri][i] = dim[i];
  }
  delay(10);
}

void toista() {
    if(playStep < 1000) { playStep++; }
    for(int i = 0; i < 12; i++) {
      dim[i] = recVal[playStep][i];
    }
    delay(10);
}

//void chase() {
//  
//  
//  chaseBright1[memoryNumber]++;
//  if(chaseBright1 > ch[1]) {
//    chaseStep1++;
//    chaseBright1 = 0;
//    delay(ch[2]*10);
//  }
//  if(chaseStep1 > 12) {
//    chaseStep1 = 1;
//  }
//  dim[chaseStep1] = round(map(chaseBright1, 0, ch[1], 0, 255));
//  dim[chaseStep1-1] = 255 - round(map(chaseBright1, 0, ch[1], 0, 255));
//}



void ansat() {
  fill(0, 0, 0);
  rect(0, (y[0]+25)*zoom/100, width*zoom/150, 5);
  rect(0, (y[1]+25)*zoom/100, width*zoom/150, 5);
}
void kalvo(int r, int g, int b) {
  fill(r, g, b);
}
void par64(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 30*zoom/100;
  int lampHeight = 50*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void linssi(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 20*zoom/100;
  int lampHeight = 60*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void iso_fresu(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 40*zoom/100;
  int lampHeight = 50*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void keski_fresu(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 35*zoom/100;
  int lampHeight = 40*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void pieni_fresu(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 25*zoom/100;
  int lampHeight = 30*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void flood(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 40*zoom/100;
  int lampHeight = 20*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void strobe(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 40*zoom/100;
  int lampHeight = 30*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void haze(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 50*zoom/100;
  int lampHeight = 50*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
void fog(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 50*zoom/100;
  int lampHeight = 70*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}

void drawFixture(int i) {
  boolean showFixture = true;
  int lampWidth = 30;
  int lampHeight = 40;
  if(fixtureType1[i] == 1) { lampWidth = 30*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 2) { lampWidth = 25*zoom/100; lampHeight = 30*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 3) { lampWidth = 35*zoom/100; lampHeight = 40*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 4) { lampWidth = 40*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 5) { lampWidth = 40*zoom/100; lampHeight = 20*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 6) { lampWidth = 20*zoom/100; lampHeight = 60*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 7) { lampWidth = 50*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 8) { showFixture = false; }
  if(fixtureType1[i] == 9) { lampWidth = 40*zoom/100; lampHeight = 30*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 10) { showFixture = false; }
  if(fixtureType1[i] == 11) { lampWidth = 50*zoom/100; lampHeight = 70*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 12) { lampWidth = 5*zoom/100; lampHeight = 8*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 13) { lampWidth = 30*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 14) { showFixture = false; movingHeadPan = dim[channel[i]]; rotTaka[i-1] = round(map(dim[channel[i]], 0, 255, -90, 90)); }
  if(fixtureType1[i] == 15) { showFixture = false; rotX[i-2] = round(map(dim[channel[i]], 0, 255, 180, 0)); }
  
  if(showFixture == true) {
    int x1 = 0; int y1 = 0;
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate(radians(map(movingHeadPan, 0, 255, 0, 180))); }
    rect(x1, y1, lampWidth, lampHeight);
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate((radians(map(movingHeadPan, 0, 255, 0, 180))) * (-1)); rectMode(CORNER); }
    if(zoom > 50) {
    fill(255, 255, 255);
    text(dim[channel[i]], x1, y1 + lampHeight + 15);
    text(channel[i], x1, y1 - 15);
    }
  }
}

void mouseWheel(MouseEvent event) {
  if(mouseX < width-120) {
  float e = event.getCount();
  if(e < 0) {
    zoom--;
  }
  else if(e > 0) {
    zoom++;
  }
  }
  else {
    float e = event.getCount();
  if(e < 0) {
    if(memoryMenu > 0) {
      memoryMenu--;
    }
  }
  else if(e > 0) {
    if(memoryMenu < numberOfMemories) {
      memoryMenu++;
    }
  }
  }
}
