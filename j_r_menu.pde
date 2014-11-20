//Tässä välilehdessä piirretään sivuvalikko, jossa näkyy memorit ja niiden arvot, sekä tyypit

void sivuValikko() {
  
  /*if(mouseX > width-120 && mouseX < width && mouseY > 30) { //Check if mouse is on the memory menu
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
    translate(width-60, 0);
    for(int i = 1; i <= height/15-5; i++) {
      if(memoryMenu < numberOfMemories+40) {
        translate(0, 15);
        memoryy(i+memoryMenu, memoryValue[i+memoryMenu]);
        
      }
    }
  popMatrix();*/
  
  //-
  pushMatrix();
  translate(width-168, 0);
  for(int i = 1; i <= height/20-1; i++) {
    if(memoryMenu < numberOfMemories+40) {
      pushMatrix();
        translate(0, 20*i);
        drawMemoryController(i, getMemoryTypeName(i), true);
      popMatrix();
    }
  }
  
  //contr.update();
  popMatrix();
  //-
 
}






void drawMemoryController(int controlledMemoryId, String text, boolean inUse) {
  int value = memoryValue[controlledMemoryId];
  pushStyle();
  
  textSize(12);
  textAlign(CENTER);
  //Draw controller
  strokeWeight(2);
  stroke(80);
  fill(240);
  //Number indication box
  rect(0, 0, 25, 20);
  fill(20);
  text(controlledMemoryId, 25/2, 15);
  //Type indication box
  fill(10, 240, 10);
  rect(25, 0, 40, 20);
  fill(20);
  textAlign(LEFT);
  text(text, 30, 15);
  
  //Controller box
  fill(200);
  noStroke();
  rect(65, 0, 100, 20);
  fill(50, 50, 240);
  rect(65, 0, map(value, 0, 255, 0, 100), 20);
  fill(0);
  text(value, 68, 16);
  
  if (isHoverSimple(0, 0, 170, 20) && mousePressed) {
    mouseLocked = true;
    mouseLocker = "presetControl";
    value = constrain(int(map(mouseX - screenX(65, 0), 0, 100, 0, 255)), 0, 255);
    memory(controlledMemoryId, value);
    memoryValue[controlledMemoryId] = value;
  }
  noFill();
  stroke(80);
  rect(65, 0, 100, 20);
  popStyle();
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
