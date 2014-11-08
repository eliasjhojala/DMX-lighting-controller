//Tässä välilehdessä piirretään alavalikko, jossa näkyy mm. fixtuurien nykyiset arvot
//Alavalikko toimii nyt hyvin ja fixture(i) voidia voi käyttää missä vain ohjelmassa
/*Jostain syystä id:n vaihtamisen kanssa on välillä pieniä ongelmia
se pitäisi selvittää*/

//Create variables for old mouse locations
int oldMouseX2;
int oldMouseY2;

void alavalikko() {
  //The boolean is set to true on a spot that has been checked. It should not be drawn again.
  boolean[] drawn = new boolean[bottomMenuOrder.length];
  
  pushMatrix(); 
    translate(0, height-170); //alavalikko is located to bottom of the window
    //Upper row
    pushMatrix();
      for(int i = 0; i < 20; i++) {
        int tempIndex = indexOfMinCheck(bottomMenuOrder, drawn);
        drawn[tempIndex] = true;
        
        translate(65, 0); //moves box to its place
        createFixtureBox(tempIndex); //Create fixture boxes including buttons and their functions
      }
    popMatrix();
    //Lower row
    pushMatrix();
      translate(0, 65); 
      for(int i = 20; i <= 40; i++) {
        int tempIndex = indexOfMinCheck(bottomMenuOrder, drawn);
        drawn[tempIndex] = true;
        
        translate(65, 0); //moves box to its place
        createFixtureBox(tempIndex); //Create fixture boxes including buttons and their functions
      }
    popMatrix(); 
    
    pushMatrix();
      translate(0, 65+65); 
      for(int i = 40; i <= 60; i++) {
        int tempIndex = indexOfMinCheck(bottomMenuOrder, drawn);
        drawn[tempIndex] = true;
        
        translate(65, 0); //moves box to its place
        createFixtureBox(tempIndex); //Create fixture boxes including buttons and their functions
      }
    popMatrix(); 
  popMatrix();
  
  drawBottomMenuControlBox();
}
void createFixtureBox(int id) {
  drawFixtureRectangles(id); //draw fixtureboxes with buttons etc.
  checkFixtureBoxGo(id); //Check if you pressed go button button to set fixture on until jo release mouse
  checkFixtureBoxToggle(id); //Check if you pressed toggle button to set fixture on and off
  checkFixtureBoxSlider(id); //Check if you moved slider to change channels dimInput value
  checkFixtureBoxRightClick(id); //Check if you clicked right button at title to edit fixture settings
}

void drawFixtureRectangles(int id) {
  String fixtuuriTyyppi = fixtures[id].fixtureType;
  
  fill(255, 255, 255); //White color for fixtureBox
  stroke(255, 255, 0); //Yellow corners for fixtureBox
  rect(0, 0, 60, -51); //The whole fixtureBox
  stroke(0, 0, 0); //black corners for other rects
  fill(0, 255, 0); //green color for title box
  rect(0, -40, 60, -15); //title box
  if (isHover(0, -40, 60, -15) && mousePressed && !mouseLocked) openBottomMenuControlBox(id); //Open control box
  fill(0, 0, 0); //black color for title
  text(str(id)+":" +fixtuuriTyyppi, 2, -44); //Title (fixture id and type texts)
  text("Ch " + str(fixtures[id].channelStart) , 2, -30); // Channel
  fill(0, 0, 255); //blue color for slider
  rect(0, 0, 10, (map(fixtures[id].dimmer, 0, 255, 0, 30))*(-1)); //Draw slider
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
      dimInput[fixtures[id].channelStart] = 255; //Set dimInput value to max
    }
    if(mouseReleased) { //Check if mouse is released
      mouseReleased = false; //Set mouseReleased to false 
      dimInput[fixtures[id].channelStart] = 0; //Set dimInput value to min
    }
  }
}
void checkFixtureBoxToggle(int id) { //This void checks Toggle button
  if(isHover(10, -15, 49, -15) && mouseClicked && mouseReleased) { //Check if mouse is on toggle box and clicked and released before it
    mouseReleased = false; //Mouse isn't released anymore
    if(dimInput[fixtures[id].channelStart] == 255) { //Check if dimInput is 255
      dimInput[fixtures[id].channelStart] = 0; //If dimInput is at 255 then set it to zero
    }
    else {
      dimInput[fixtures[id].channelStart] = 255; //If dimInput is not at max value then set it to max
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
      
      dimInput[fixtures[id].channelStart] += map(oldMouseY2 - mouseY, 0, 30, 0, 255); //Change dimInput value as much as user has moved the mouse and make sure it is between 0 and 255
      dimInput[fixtures[id].channelStart] = constrain(dimInput[fixtures[id].channelStart], 0, 255); //Make sure that dimInput value is between 0-255 
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
    bottomMenuOrder[id] = constrain(bottomMenuOrder[id] + 1, 0, 1000);
    mouseReleased = false;
    keyReleased = false;
  }
  if(isHover(0, -40, 60, -15) && mouseClicked && mouseButton == RIGHT && keyPressed && keyCode == LEFT && keyReleased) { //Check if mouse is on the title box anf clicked
    bottomMenuOrder[id] = constrain(bottomMenuOrder[id] - 1, 0, 1000);
    mouseReleased = false;
    keyReleased = false;
  }
}



//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//bottomMenuControlBox---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//Variables----------------------------------------------//|
int currentBottomMenuControlBoxOwner;                    //|
boolean bottomMenuControlBoxOpen = false;                //|
boolean bottomMenuControlBoxOpenOld = false;             //|
bottomMenuChController[] bottomMenuControlBoxControllers;//|
int[] bottomMenuControlBoxDMXValues;                     //|
boolean[] bottomMenuControlBoxDMXValueChanged;           //|
int bottomMenuControlBoxHeight = 200;                    //|
int bottomMenuControlBoxWidth = 20*65;                   //|
String bottomMenuControlBoxDisplayText;                  //|
//-------------------------------------------------------//|


//Constants------------------------------------------------//|
String bottomMenuControlBoxSubstr = "bottomMenuControlBox";//|
//---------------------------------------------------------//|

void openBottomMenuControlBox(int owner) {
  bottomMenuControlBoxOpen = true;
  currentBottomMenuControlBoxOwner = owner;
  bottomMenuControlBoxDisplayText = "Fixture ID: " + owner + ", Type: " + fixtures[owner].fixtureType + ", Starting Channel: " + fixtures[owner].channelStart;
  boolean successInit = false; //This boolean is set to true, if the fixtureType has a specific configuration applied for it.
  switch(fixtures[owner].fixtureTypeId) {
    //Configure box according to fixtureType
    case 1: case 2: case 3: case 4: case 5: case 6:
      // all "dumb" fixtures (with only one channel: dim)
      bottomMenuControlBoxControllers = new bottomMenuChController[1];
      bottomMenuControlBoxControllers[0] = new bottomMenuChController(50, 50, 0, 0, "Dimmer");
      successInit = true;
    break;
    //MH-X50 14&8 channel modes
    case 16:
      bottomMenuControlBoxControllers = new bottomMenuChController[14];
      String[] chanNamesTp16 = {"Pan", "Tilt", "Fine Pan", "Fine Tilt", "Resp. Speed", "Color Wheel", "Shutter", "Dimmer", "Gobo", "Gobo Rotation", "S. Function", "Auto Program", "Prism", "Focus"};
      for (int i = 0; i < chanNamesTp16.length; i++) {
        bottomMenuControlBoxControllers[i] = new bottomMenuChController(30 + i*90, 50, i, 0, chanNamesTp16[i]);
      }
      successInit = true;
    break;
    case 17:
      bottomMenuControlBoxControllers = new bottomMenuChController[8];
      String[] chanNamesTp17 = {"Pan", "Tilt", "Color Wheel", "Shutter", "Gobo", "Gobo Rotation", "Prism", "Focus"};
      for (int i = 0; i < chanNamesTp17.length; i++) {
        bottomMenuControlBoxControllers[i] = new bottomMenuChController(50 + i*120, 50, i, 0, chanNamesTp17[i]);
      }
      successInit = true;
    break;
    default:
      bottomMenuControlBoxControllers = new bottomMenuChController[0];
      bottomMenuControlBoxDMXValues = new int[0];
      bottomMenuControlBoxDMXValueChanged = new boolean[0];
    break;
  }
  if (successInit) {
    bottomMenuControlBoxDMXValues = fixtures[owner].getDMX();
    bottomMenuControlBoxDMXValueChanged = new boolean[bottomMenuControlBoxDMXValues.length];
  }
}

void drawBottomMenuControlBox() {
  if (bottomMenuControlBoxOpen) {
    
    
    pushMatrix();
    //Control box open ---> draw it
    translate(65, height - 260 - bottomMenuControlBoxHeight);
    
    //Frame of the box
    fill(5, 100, 150);
    stroke(9, 157, 222);
    strokeWeight(5);
    rect(0, 0, bottomMenuControlBoxWidth, bottomMenuControlBoxHeight);
    fill(0, 50);
    textSize(120);
    text("Fixture " + currentBottomMenuControlBoxOwner, 0, bottomMenuControlBoxHeight - 10);
    textSize(12);
    
    //Draw X button (for an option to close the box)
    pushMatrix();
    fill(255, 0, 0); noStroke();
    translate(0, bottomMenuControlBoxHeight - 20);
    rect(0, 0, 21, 20);
    stroke(200); strokeWeight(2);
    line(4, 4, 16, 16); line(4, 16, 16, 4);
    //hovering over the X button AND mouse is down --> close box
    if (isHover(0, 0, 21, 20) && mousePressed && !mouseLocked) { mouseLocked = true; mouseLocker = "bottomMenuControlBox:close"; bottomMenuControlBoxOpen = false; }
    popMatrix();
    
    if (bottomMenuControlBoxControllers != null) for (bottomMenuChController controller : bottomMenuControlBoxControllers) controller.draw();
    
    //Update DMX values-----------------------------------------------------------------|
    int[] tempDMX = fixtures[currentBottomMenuControlBoxOwner].getDMX();
    int arrayIndex = 0;
    //This value is true if any of the entries in the boolean array are true
    boolean changd = false;
    //Error prevention
    if (bottomMenuControlBoxDMXValueChanged != null && bottomMenuControlBoxDMXValues != null) if (bottomMenuControlBoxDMXValueChanged.length != 0 && bottomMenuControlBoxDMXValues.length != 0)
    for (boolean changed : bottomMenuControlBoxDMXValueChanged) { 
      if (changed) { 
        tempDMX[arrayIndex] = bottomMenuControlBoxDMXValues[arrayIndex];
        changd = true;
      } else bottomMenuControlBoxDMXValues[arrayIndex] = tempDMX[arrayIndex];
      arrayIndex++;
    }
    bottomMenuControlBoxDMXValueChanged = new boolean[tempDMX.length];
    if (changd) fixtureInputs[0].receiveFromBottomMenu(tempDMX, currentBottomMenuControlBoxOwner+1);
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
    
    text(bottomMenuControlBoxDisplayText, 15, 20);
    
    //Reset draw modifiers
    strokeWeight(1);
    stroke(255, 255, 255);
    fill(0, 0, 0);
    popMatrix();
  }
  if (!bottomMenuControlBoxOpen && bottomMenuControlBoxOpenOld) {
    //box was just closed
    
    //Make sure mouseLocked is false
    if (mouseLocker.substring(bottomMenuControlBoxSubstr.length()).equals(bottomMenuControlBoxSubstr)) mouseLocked = false;
  }
  bottomMenuControlBoxOpenOld = bottomMenuControlBoxOpen;
}



//Channel controller
class bottomMenuChController {
  int value;
  int x, y;
  
  String displayText;
  
  int dragStartX;
  int dragY;
  
  int assignedData; //Datatype assigned to this slider
  
  //Profiles: 0: all options, 1: compact, only slider, 2: compact, only toggle & go
  int profile = 0;
  
  bottomMenuChController(int xIn, int yIn, int assign, int prof, String text) {
    x               =    xIn;
    y               =    yIn;
    assignedData    = assign;
    profile         =   prof;
    displayText     =   text;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    //Draw the element according to profile mode
    switch(profile) {
      case 0:
        slider();
        buttons();
        translate(0, 115);
        text(displayText, 0, 0);
        //This is for visuals
        stroke(255, 100); strokeWeight(1);
        line(-5, 4, 50, 4);
        line(-6, 4, -6, -119);
        break;
      case 1:
        
        break;
    }
    popMatrix();
  }
  
  
  void slider() {
    //Draw slider
    drawBottomMenuChControllerSlider(value);
    //Check for drag
    if (isHover(0, 0, 20, 100) && mousePressed && !mouseLocked) {
      //Started dragging
      mouseLocked = true;
      mouseLocker = "bottomMenuControlBox:slider" + str(assignedData);
      dragStartX = mouseX;
    }
    boolean valueChanged = false;
    if (mouseLocked && mouseLocker.equals("bottomMenuControlBox:slider" + str(assignedData))) {
      value += map(dragY - mouseY, 0, 100 + constrain((mouseX - dragStartX) * 2, 0, 414), 0, 255);
      value = constrain(value, 0, 255);
      valueChanged = true;
    } else getValueFromOwner();
    dragY = mouseY;
    
    if (valueChanged) setOwnerValue();
  }
  
  boolean oldGo;
  int valueBeforeGo;
  //Draws & handles the two buttons
  void buttons() {
    pushMatrix();
    translate(30, 65);
    
    //Go button
    boolean goDown = isHover(0, 0, 48, 15) && mousePressed;
    boolean mouseLockerIsMain = !mouseLocked;
    if (goDown && mouseLockerIsMain) {
      mouseLocked = true;
      mouseLocker = "bottomMenuControlBox:go" + str(assignedData);
      if(value != 255) valueBeforeGo = value; else valueBeforeGo = 0;
      
      value = 255;
      setOwnerValue();
      oldGo = true;
    }
    boolean mouseLockerIsGo = mouseLocker.equals("bottomMenuControlBox:go" + str(assignedData)) && mouseLocked;
    if (!mouseLockerIsGo && oldGo) { value = valueBeforeGo; setOwnerValue(); oldGo = false; }
    drawBottomMenuChControllerButton("Go", mouseLockerIsGo);
    println(str(mouseLocked) + mouseLocker);
    //Toggle button
    translate(0, 20);
    boolean tglDown = isHover(0, 0, 48, 15) && mousePressed;
    if (tglDown && mouseLockerIsMain) {
      mouseLocked = true;
      mouseLocker = "bottomMenuControlBox:toggle" + str(assignedData);
      if (value == 0) value = 255; else value = 0;
      setOwnerValue();
    }
    drawBottomMenuChControllerButton("Toggle", mouseLocker.equals("bottomMenuControlBox:toggle" + str(assignedData)) && mouseLocked);
    
    popMatrix();
  }
  
  
  void getValueFromOwner() {
    if (bottomMenuControlBoxDMXValues != null) value = bottomMenuControlBoxDMXValues[assignedData];
  }
  
  void setOwnerValue() {
    if (bottomMenuControlBoxDMXValues != null) {
      bottomMenuControlBoxDMXValues[assignedData] = value;
      bottomMenuControlBoxDMXValueChanged[assignedData] = true;
    }
  }
}

//Interface drawing

//values go from 0 to 255
void drawBottomMenuChControllerSlider(int value) {
  rectMode(CORNERS);
  //Draw background
  noStroke();
  fill(50);
  rect(0, 0, 20, 100);
  //Draw active portion of slider
  fill(0, 200, 0);
  float activeY = map(value, 0, 255, 0, 100);
  rect(0, 100 - activeY, 20, 100);
  //Draw decorative "frame" around the slider
  noFill();
  stroke(0, 50); strokeWeight(2);
  rect(0, 0, 20, 100);
  //Draw value indication bar
  stroke(0, 255, 0); strokeWeight(2);
  line(-1, 100 - activeY, 21, 100 - activeY);
  
  //Reset draw modifiers
  strokeWeight(1);
  stroke(255, 255, 255);
  fill(0, 0, 0);
  rectMode(CORNER);
  
}


void drawBottomMenuChControllerButton(String text, boolean down) {
  //rectMode = CORNER
  //Draw background of the button
  if(!down) fill(200); else fill(120);
  noStroke();
  rect(0, 0, 48, 15);
  //Draw the text of the button
  fill(0);
  textSize(12);
  text(text, 4, 12);
  //Draw decorative "frame" around the button
  noFill(); 
  if (!down) { stroke(0, 50); strokeWeight(2); } else { stroke(0, 80); strokeWeight(1); }
  rect(0, 0, 48, 15);
  
  textSize(12);
}
