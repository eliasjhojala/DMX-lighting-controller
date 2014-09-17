void alavalikko() {
  translate(0, height-100);
  for(int i = 0; i <= channels/2; i++) {
    translate(65, 0);
    fixture(i, dim[i+1], fixtureType1[i]);
  }
  for(int i = 0; i <= channels/2; i++) {
    translate(-65, 0);
  }
  translate(0, 65);
  for(int i = channels/2+1; i <= channels; i++) {
    translate(65, 0);
    fixture(i, dim[i+1], fixtureType1[i]);
  }
  translate(0, -55);
  for(int i = channels/2+1; i <= channels; i++) {
    translate(-65, 0);
  }
  translate(0, (height-100)*(-1));
}
void fixture(int numero, int dimmi, int fixtuuriTyyppi1) {
  String fixtuuriTyyppi = "";

    
  if(fixtuuriTyyppi1 == 1) { fixtuuriTyyppi = "par64"; }
  if(fixtuuriTyyppi1 == 2) { fixtuuriTyyppi = "p.fresu"; }
  if(fixtuuriTyyppi1 == 3) { fixtuuriTyyppi = "k.fresu"; }
  if(fixtuuriTyyppi1 == 4) { fixtuuriTyyppi = "i.fresu"; }
  if(fixtuuriTyyppi1 == 5) { fixtuuriTyyppi = "flood"; }
  if(fixtuuriTyyppi1 == 6) { fixtuuriTyyppi = "linssi"; }
  if(fixtuuriTyyppi1 == 7) { fixtuuriTyyppi = "haze"; }
  if(fixtuuriTyyppi1 == 8) { fixtuuriTyyppi = "fan"; }
  if(fixtuuriTyyppi1 == 9) { fixtuuriTyyppi = "strobe"; }
  if(fixtuuriTyyppi1 == 10) { fixtuuriTyyppi = "freq"; }
  if(fixtuuriTyyppi1 == 11) { fixtuuriTyyppi = "fog"; }
  if(fixtuuriTyyppi1 == 12) { fixtuuriTyyppi = "pinspot"; }
  if(fixtuuriTyyppi1 == 13) { fixtuuriTyyppi = "MHdim"; }
  if(fixtuuriTyyppi1 == 14) { fixtuuriTyyppi = "MHpan"; }
  if(fixtuuriTyyppi1 == 15) { fixtuuriTyyppi = "MHtilt"; }
  fill(255, 255, 255);
  stroke(255, 255, 0);
  rect(0, 0, 60, -51);
  stroke(0, 0, 0);
  fill(0, 255, 0);
  rect(0, -40, 60, -15);
  fill(0, 0, 0);
  text(str(numero+1)+":"+fixtuuriTyyppi, 2, -44);
  fill(0, 0, 255);
  rect(0, 0, 10, (map(dimmi, 0, 255, 0, 30))*(-1));
  fill(255, 255, 255);
  rect(10, 0, 49, -15);
  fill(0, 0, 0);
  text("Go", 12, -3);
  fill(255, 255, 255);
  rect(10, -15, 49, -15);
  fill(0, 0, 0);
  text("Toggle", 12, -18);
  fill(255, 255, 255);
  
  if(numero <= channels/2) {
  if(mouseX > 65*numero+10 && mouseX < 65*(numero+1)) {
    
    if(mouseY > height-(200+15) && mouseY < height-110) {
          if(mousePressed == true && mouseButton == RIGHT) {
            toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = numero-1;
          }
    }
      if(mouseY > height-(100+15) && mouseY < height-100) {
        if(mouseClicked == true) {
            dim[numero] = 255;       
        }
        else if(mouseReleased == true){
          mouseReleased = false;
          dim[numero] = 0;
        }
      }
    }
  }
  else {
    
    if((mouseX > 65*(numero-(channels/2))+10) && (mouseX < 65*(numero+1-(channels/2)))) {
      if(mouseY > height-(100+15) && mouseY < height-10) {
          if(mousePressed == true && mouseButton == RIGHT) {
            toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = numero;
          }
    }
      if(mouseY > height-(100+15-65) && mouseY < height-110) {
      }
          if(mouseY > height-(100+15-65) && mouseY < height-(100-65)) {
            if(mouseClicked == true) {
                dim[numero+1] = 255;
            }
            else if(mouseReleased == true){
              mouseReleased = false;
              dim[numero+1] = 0;
            }
          }
        }
      }
      
      if(numero <= channels/2) {
  if(mouseX > 65*numero+10 && mouseX < 65*(numero+1)) {
      if(mouseY > height-(100+30) && mouseY < height-(100+15)) {
        if(mouseClicked == true) {
          if(mouseReleased == true) {
          if(dim[numero] == 255) {
                dim[numero] = 0;
              }
              else {
                dim[numero] = 255;
              }
              mouseReleased = false;
          }
        }
      }
    }
  }
  else {
    if((mouseX > 65*(numero-(channels/2))+10) && (mouseX < 65*(numero+1-(channels/2)))) {
          if(mouseY > height-(100+30-65) && mouseY < height-(100-65+15)) {
            if(mouseClicked == true) {
              if(mouseReleased == true) {
              if(dim[numero+1] == 255) {
                dim[numero+1] = 0;
              }
              else {
                dim[numero+1] = 255;
              }
              mouseReleased = false;
              }
            }
          }
        }
      }
      
      
      if(numero <= channels/2) {
  if(mouseX > 65*numero && mouseX < 65*(numero)+10) {
      if(mouseY > height-(100+30) && mouseY < height-100) {
        if(mouseClicked == true) {
          dim[numero] = round(map(mouseY, height-100, height-(100+30), 0, 255));
          
        }
        else if(mouseReleased == true) {
          mouseReleased = false;
        }
      }
    }
  }
  else {
    if((mouseX > 65*(numero-(channels/2))) && (mouseX < 65*(numero-(channels/2))+10)) {
          if(mouseY > height-(100+30-65) && mouseY < height-(100-65)) {
            if(mouseClicked == true) {
              dim[numero+1] = round(map(mouseY, height-(100-65), height-(100+30-65), 0, 255));
            }
            else if(mouseReleased == true) {
              mouseReleased = false;
            }
          }
        }
      }
}
