//Tässä välilehdessä on paljon lyhyitä voideja

void arduinoSend() {
  
  for(int i = 0; i < channels; i++) {
    if(dim[i] != dimOld[i]) {
      if(useCOM == true) {
      setDmxChannel(i, dim[i]);
      }
      dimOld[i] = dim[i];
      sendOscToAnotherPc(i, dim[i]);
      sendOscToIpad(i, dimInput[i]);
  }
  }
}


void ansat() {
  fill(0, 0, 0);
  rect(0, (y[0]+25)*zoom/100, width*zoom/150, 5);
  rect(0, (y[1]+25)*zoom/100, width*zoom/150, 5);
}
void kalvo(int r, int g, int b) {
  fill(r, g, b);
}


void drawFixture(int i) {
  boolean showFixture = true;
  int lampWidth = 30;
  int lampHeight = 40;
  String fixtuuriTyyppi = "";
  
  if(fixtureType1[i] == 1) { fixtuuriTyyppi = "par64"; }
  if(fixtureType1[i] == 2) { fixtuuriTyyppi = "p.fresu"; }
  if(fixtureType1[i] == 3) { fixtuuriTyyppi = "k.fresu"; }
  if(fixtureType1[i] == 4) { fixtuuriTyyppi = "i.fresu"; }
  if(fixtureType1[i] == 5) { fixtuuriTyyppi = "flood"; }
  if(fixtureType1[i] == 6) { fixtuuriTyyppi = "linssi"; }
  if(fixtureType1[i] == 7) { fixtuuriTyyppi = "haze"; }
  if(fixtureType1[i] == 8) { fixtuuriTyyppi = "fan"; }
  if(fixtureType1[i] == 9) { fixtuuriTyyppi = "strobe"; }
  if(fixtureType1[i] == 10) { fixtuuriTyyppi = "freq"; }
  if(fixtureType1[i] == 11) { fixtuuriTyyppi = "fog"; }
  if(fixtureType1[i] == 12) { fixtuuriTyyppi = "pinspot"; }
  if(fixtureType1[i] == 13) { fixtuuriTyyppi = "MHdim"; }
  if(fixtureType1[i] == 14) { fixtuuriTyyppi = "MHpan"; }
  if(fixtureType1[i] == 15) { fixtuuriTyyppi = "MHtilt"; }
  
  
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
  if(fixtureType1[i] == 14) { showFixture = false; movingHeadPan = dim[i]; rotTaka[i] = round(map(dim[channel[i]], 0, 255, -90, 90)); }
  if(fixtureType1[i] == 15) { showFixture = false; rotX[i-2] = round(map(dim[channel[i]], 0, 255, 180, 0)); }
  
  if(showFixture == true) {
    int x1 = 0; int y1 = 0;
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate(radians(map(movingHeadPan, 0, 255, 0, 180))); }
    rect(x1, y1, lampWidth, lampHeight);
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate((radians(map(movingHeadPan, 0, 255, 0, 180))) * (-1)); rectMode(CORNER); }
    if(zoom > 50) {
      if(printMode == false) {
        fill(255, 255, 255);
        text(dim[channel[i]], x1, y1 + lampHeight + 15);
      }
      else {
        fill(0, 0, 0);
        text(fixtuuriTyyppi, x1, y1 + lampHeight + 15);
      }
    
    text(channel[i], x1, y1 - 15);
    }
  }
}

void mouseWheel(MouseEvent event) {
  if(mouseX < width-120) { //Jos hiiri ei ole sivuvalikon päällä sen skrollaus vaikuttaa visualisaation zoomaukseen
    float e = event.getCount();
    if(e < 0) { zoom--; }
    else if(e > 0) { zoom++; }
  }
  else {
    float e = event.getCount();
    if(e < 0) { if(memoryMenu > 0) { memoryMenu--; } }
    else if(e > 0) { if(memoryMenu < numberOfMemories) { memoryMenu++; } }
  }
}
