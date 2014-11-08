//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit

void sivuValikko() {
  if(mouseX > width-120 && mouseX < width && mouseY > 30) { //Check if mouse is on the memory menu
    mouseLocked = true; //Lukitsee hiiren, jottei se vaikuta muihin alueisiin
    mouseLocker = "sivuValikko"; //Kertoo hiiren olevan lukittu alueelle sivuValikko
  }
   if(mousePressed == true) { //Check if mouse is pressed
      if(mouseX > width-120 && mouseX < width && mouseY > 30) { //Check if mouse is on the memorymenu
          mouseLocked = true; //Lock mouse
          mouseLocker = "sivuValikko"; //Mouse is locked to area "sivuValikko"
          if(round(map((mouseX-width+60), 1, 59, 0, 255)) >= 0) { //Check if mouse is located on memory sliders
            memory(round((mouseY-35)/15)+memoryMenu, round(map((mouseX-width+60), 1, 59, 0, 255))); //Set right memory value according to the mouse location
            memoryValue[round((mouseY-35)/15)+memoryMenu] = round(map((mouseX-width+60), 1, 59, 0, 255)); //Set right memory variable value according to the mouse location
          }
          else {
            if(mouseButton == RIGHT) { //Check if you clicked right button on green area
              changeChaseModeByMemoryNumber(round((mouseY-35)/15)+memoryMenu); //Open chaseMode window
            }
            else { 
            memory(round((mouseY-25)/15)+memoryMenu, 0); //Set memory value to zero if you click on the green area 
            memoryValue[round((mouseY-25)/15)+memoryMenu] = 0; //Set memory variable value to zero if you click on the green area 
            }
          }
      }
      else { //If mouse is clicked but not on the memorymenu unlocks mouse
        if(mouseLocker == "sivuValikko") {
          //mouseLocked = false; 
          mouseLocker = "";
        }
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
  nimi = getMemoryTypeName(numero);
  
  fill(255, 255, 255);
  stroke(255, 255, 0); //Yellow borders
  rect(0, -5, 60, 15); //White rect under slider bar
  fill(0, 255, 0); //Green color for title box
  rect(-60, -5, 60, 15); //Title box
  fill(0, 0, 0); //Black title text
  text(str(numero)+":"+nimi, -47, 7); //Title text (emory number and type text)
  fill(0, 0, 255); //Blue color for slider bar
  rect(0, -5, (map(dimmi, 0, 255, 0, 60))*(1), 15); //Slider bar
  fill(0, 0, 0); //Black color for text
  text(str(dimmi), 0, 7); //Value text
}
String getMemoryTypeName(int numero) {
  String nimi = "";
  if(memoryType[numero] == 1) { nimi = "prst"; }
  if(memoryType[numero] == 2) { nimi = "s2l"; }
  if(memoryType[numero] == 4) { nimi = "mstr"; }
  if(memoryType[numero] == 5) { nimi = "fade"; }
  if(memoryType[numero] == 6) { nimi = "wave"; }
  return nimi;
}
