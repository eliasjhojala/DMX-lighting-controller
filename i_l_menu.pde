//Tässä välilehdessä piirretään alavalikko, jossa näkyy mm. fixtuurien nykyiset arvot
//Alavalikko toimii nyt hyvin ja fixture(i) voidia voi käyttää missä vain ohjelmassa
/*Jostain syystä id:n vaihtamisen kanssa on välillä pieniä ongelmia
se pitäisi selvittää*/

//Create variables for old mouse locations
int oldMouseX2;
int oldMouseY2;

void alavalikko() {
  pushMatrix(); 
    translate(0, height-100); //alavalikko is located to bottom of the window
    //Upper row
    pushMatrix();
      for(int i = 0; i < 15; i++) {
        translate(65, 0); //moves box to its place
        createFixtureBox(i); //Create fixture boxes including buttons and their functions
      }
    popMatrix();
    //Lower row
    pushMatrix();
      translate(0, 65); 
      for(int i = 16; i <= 32; i++) {
        translate(65, 0); //moves box to its place
        createFixtureBox(i); //Create fixture boxes including buttons and their functions
      }
    popMatrix(); 
  popMatrix();
}
void createFixtureBox(int id) {
  drawFixtureRectangles(id); //draw fixtureboxes with buttons etc.
  checkFixtureBoxGo(id); //Check if you pressed go button button to set fixture on until jo release mouse
  checkFixtureBoxToggle(id); //Check if you pressed toggle button to set fixture on and off
  checkFixtureBoxSlider(id); //Check if you moved slider to change channels dimInput value
  checkFixtureBoxRightClick(id); //Check if you clicked right button at title to edit fixture settings
}

void drawFixtureRectangles(int id) {
  String fixtuuriTyyppi = getFixtureName(fixtureIdNow[id]);
  
  fill(255, 255, 255); //White color for fixtureBox
  stroke(255, 255, 0); //Yellow corners for fixtureBox
  rect(0, 0, 60, -51); //The whole fixtureBox
  stroke(0, 0, 0); //black corners for other rects
  fill(0, 255, 0); //green color for title box
  rect(0, -40, 60, -15); //title box
  fill(0, 0, 0); //black color for title
  text(str(channel[fixtureIdNow[id]])+":" +fixtuuriTyyppi, 2, -44); //Title (fixture id and type texts)
  fill(0, 0, 255); //blue color for slider
  rect(0, 0, 10, (map(dimInput[channel[fixtureIdNow[id]]], 0, 255, 0, 30))*(-1)); //Draw slider
  fill(255, 255, 255); //white color for Go button
  rect(10, 0, 49, -15); //Draw Go button
  fill(0, 0, 0); //black color for Go text
  text("Go", 12, -3); //go text
  fill(255, 255, 255); //white color for toggle button
  rect(10, -15, 49, -15); //Draw Toggle button
  fill(0, 0, 0); //black color fot toggle text
  text("Toggle", 12, -18); //toggle text
  fill(255, 255, 255); //white color at end
}

void checkFixtureBoxGo(int id) { //This void checks Go button
  if(isHover(10, 0, 49, -15)) { //Check if mouse is on go box
    if(mouseClicked) { //Check if mouse is clicked
      dimInput[channel[fixtureIdNow[id]]] = 255; //Set dimInput value to max
    }
    if(mouseReleased) { //Check if mouse is released
      mouseReleased = false; //Set mouseReleased to false 
      dimInput[channel[fixtureIdNow[id]]] = 0; //Set dimInput value to min
    }
  }
}
void checkFixtureBoxToggle(int id) { //This void checks Toggle button
  if(isHover(10, -15, 49, -15) && mouseClicked && mouseReleased) { //Check if mouse is on toggle box and clicked and released before it
    mouseReleased = false; //Mouse isn't released anymore
    if(dimInput[channel[fixtureIdNow[id]]] == 255) { //Check if dimInput is 255
      dimInput[channel[fixtureIdNow[id]]] = 0; //If dimInput is at 255 then set it to zero
    }
    else {
      dimInput[channel[fixtureIdNow[id]]] = 255; //If dimInput is not at max value then set it to max
    }
  }
}
void checkFixtureBoxSlider(int id) {
   if(isHover(0, 0, 10, -30) && mouseClicked) { //Check if mouse is on the slider rect
    if(mouseReleased) { //If you start dragging set oldMouse values current mouse values
      oldMouseX2 = mouseX;
      oldMouseY2 = mouseY;
      mouseReleased = false;
    }
      
      dimInput[channel[fixtureIdNow[id]]] += map(oldMouseY2 - mouseY, 0, 30, 0, 255); //Change dimInput value as much as you moved mouse
      dimInput[channel[fixtureIdNow[id]]] = constrain(dimInput[channel[fixtureIdNow[id]]], 0, 255); //Make sure that dimInput value is between 0-255 
      oldMouseX2 = mouseX; //Set oldMouseX2 to current mouseX
      oldMouseY2 = mouseY; //Set oldMouseY2 to current mouseY
  }
}

void checkFixtureBoxRightClick(int id) {
   if(isHover(0, -40, 60, -15) && mouseClicked && mouseButton == RIGHT && mouseReleased) { //Check if mouse is on the title box anf clicked
    toChangeFixtureColor = true; //Tells controlP5 to open fixtureSettings window
    toRotateFixture = true; //Tells controlP5 to open fixtureSettings window
    changeColorFixtureId = id; //Tells controlP5 which fixture to edit
  }
  if(isHover(0, -40, 60, -15) && mouseClicked && mouseButton == RIGHT && keyPressed && keyCode == RIGHT && keyReleased) { //Check if mouse is on the title box anf clicked
    change_fixture_id(fixtureIdNow[id]); //Tells controlP5 which fixture to edit
    mouseReleased = false;
    keyReleased = false;
  }
  if(isHover(0, -40, 60, -15) && mouseClicked && mouseButton == RIGHT && keyPressed && keyCode == LEFT && keyReleased) { //Check if mouse is on the title box anf clicked
    change_fixture_id_down(fixtureIdNow[id]); //Tells controlP5 which fixture to edit
    mouseReleased = false;
    keyReleased = false;
  }
}
