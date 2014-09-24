//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit

void sivuValikko() {
  if(mouseX > width-120 && mouseX < width && mouseY > 30) {
    mouseLocked = true; //Lukitsee hiiren, jottei se vaikuta muihin alueisiin
    mouseLocker = "sivuValikko"; //Kertoo hiiren olevan lukittu alueelle sivuValikko
  }
   if(mousePressed == true) {
    if(mouseX > width-120 && mouseX < width && mouseY > 30) {
      mouseLocked = true; //Lukitsee hiiren, jottei se vaikuta muihin alueisiin
      mouseLocker = "sivuValikko"; //Kertoo hiiren olevan lukittu alueelle sivuValikko
      if(round(map((mouseX-width+60), 1, 59, 0, 255)) >= 0) {
        memory(round((mouseY-30)/15)+memoryMenu, round(map((mouseX-width+60), 1, 59, 0, 255)));
        memoryValue[round((mouseY-30)/15)+memoryMenu] = round(map((mouseX-width+60), 1, 59, 0, 255));
      }
      else {
        if(mouseButton == RIGHT) {
          changeChaseModeByMemoryNumber(round((mouseY-30)/15)+memoryMenu);
        }
        else {
        memory(round((mouseY-30)/15)+memoryMenu, 0);
        memoryValue[round((mouseY-30)/15)+memoryMenu] = 0;
        }
      }
    }
    else {
      mouseLocked = false;
      mouseLocker = "";
    }
  }
  
  
  //Drawing
  pushMatrix();
  translate(width-60, 40);
  for(int i = 1; i <= height/15-5; i++) {
    if(memoryMenu < numberOfMemories+40) {
      translate(0, 15);
      memoryy(i+memoryMenu, memoryValue[i+memoryMenu]);
    }
  }
  popMatrix();
  
  
 
}
void memoryy(int numero, int dimmi) {
  String nimi = "";
  if(memoryType[numero] == 1) { nimi = "prst"; }
  if(memoryType[numero] == 2) { nimi = "s2l"; }
  if(memoryType[numero] == 4) { nimi = "mstr"; }
  if(memoryType[numero] == 5) { nimi = "fade"; }
  if(memoryType[numero] == 6) { nimi = "wave"; }
  fill(255, 255, 255);
  stroke(255, 255, 0);
  rect(0, -5, 60, 15);
  fill(0, 255, 0);
  rect(-60, -5, 60, 15);
  fill(0, 0, 0);
  text(str(numero)+":"+nimi, -47, 7);
  fill(0, 0, 255);
  rect(0, -5, (map(dimmi, 0, 255, 0, 60))*(1), 15);
  fill(0, 0, 0);
  text(str(dimmi), 0, 7);
}
