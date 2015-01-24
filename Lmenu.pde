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
    int row = 20;
    int rows = 3;
    mouse.declareUpdateElement("bottomMenu", "main:move", 65, height-260, (row+1)*65, height-260 + rows*65);
    
    for(int i = 0; i < row*rows; i++) {
      int tempIndex = indexOfMinCheck(bottomMenuOrder, drawn);
      drawn[tempIndex] = true;
      pushMatrix();
        translate(65*(i%row+1), 65*(i/row));
        createFixtureBox(tempIndex);
      popMatrix();
    }
  popMatrix();
    
  if(!mousePressed) { mouseLocked = false; }
  if(mouse.captured && !mouse.isCaptured("bottomMenu")) { mouseLocked = true; mouseLocker = "external"; }
  
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
  if(id < fixtures.size()) {
    String fixtuuriTyyppi = fixtures.get(id).fixtureType;
    
    fill(255, 255, 255); //White color for fixtureBox
    stroke(255, 255, 0); //Yellow corners for fixtureBox
    rect(0, 0, 60, -51); //The whole fixtureBox
    stroke(0, 0, 0); //black corners for other rects
    fill(0, 255, 0); //green color for title box
    rect(0, -40, 60, -15); //title box
    if (isHover(0, -40, 60, -15) && mousePressed && !mouseLocked) openBottomMenuControlBox(id); //Open control box
    fill(0, 0, 0); //black color for title
    text(str(id)+":" +fixtuuriTyyppi, 2, -44); //Title (fixture id and type texts)
    text("Ch " + str(fixtures.get(id).channelStart) , 2, -30); // Channel
    fill(0, 0, 255); //blue color for slider
    rect(0, 0, 10, (map(fixtures.get(id).in.getUniversalDMX(1), 0, 255, 0, 30))*(-1)); //Draw slider
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
}

void checkFixtureBoxGo(int id) { //This void checks Go button
  if(isHover(10, 0, 49, -15) && mousePressed && !mouseLocked) { //Check if mouse is on go box
      mouseLocked = true;
      mouseLocker = "fbox" + id + ":go";
      fixtures.get(id).in.setDimmer(255); //Set dimInput value to max
    
  } else
  if(!mousePressed && mouseLocker.equals("fbox" + id + ":go")) { //Check if mouse is released
    mouseLocker = ":";
    fixtures.get(id).in.setDimmer(0); //Set dimInput value to min
   }
}
void checkFixtureBoxToggle(int id) { //This void checks Toggle button
  if(isHover(10, -15, 49, -15) && mousePressed && !mouseLocked) { //Check if mouse is on toggle box and clicked and released before it
    mouseLocked = true;
    mouseLocker = "fbox" + id + ":toggle";
    if(fixtures.get(id).in.getUniversalDMX(1) == 255) { //Check if dimInput is 255
      fixtures.get(id).in.setDimmer(0); //If dimInput is at 255 then set it to zero
    }
    else {
      fixtures.get(id).in.setDimmer(255); //If dimInput is not at max value then set it to max
    }
  }
}
void checkFixtureBoxSlider(int id) {
   if(isHover(0, 0, 10, -30) && mousePressed && !mouseLocked) { //Check if mouse is on the slider rect
      mouseLocked = true;
      mouseLocker = "fbox" + id + ":slider";
  } else if(mouseLocked && mouseLocker.equals("fbox" + id + ":slider")) {
      fixtures.get(id).in.setDimmer(fixtures.get(id).in.getUniversalDMX(1) + int(map(pmouseY - mouseY, 0, 30, 0, 255))); //Change dimInput value as much as user has moved the mouse and make sure it is between 0 and 255
      fixtures.get(id).in.setDimmer(constrain(fixtures.get(id).in.getUniversalDMX(1), 0, 255)); //Make sure that dimInput value is between 0-255 
  }
}

void checkFixtureBoxRightClick(int id) {
   if(isHover(0, -40, 60, -15) && mouseClicked && mouseButton == RIGHT && mouseReleased) { //Check if mouse is on the title box anf clicked
    toChangeFixtureColor = true; //Tells controlP5 to open fixtureSettings window
    toRotateFixture = true; //Tells controlP5 to open fixtureSettings window
    changeColorFixtureId = id; //Tells controlP5 which fixture to edit
    
    openBottomMenuControlBox(id); // open bottomMenu
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
boolean bottomMenuAllFixtures = false;                   //|
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

void openBottomMenuControlBoxForSelectedFs() {
  openBottomMenuControlBox(contextMenu1.fixtureId);
  bottomMenuControlBoxDisplayText = "Controlling all selected fixtures, configuration from fixture " + contextMenu1.fixtureId;
  fixtureForSelected[0].fixtureTypeId = fixtures.get(contextMenu1.fixtureId).fixtureTypeId;
  bottomMenuAllFixtures = true;
}

void openBottomMenuControlBoxFromContextMenu() {
  openBottomMenuControlBox(contextMenu1.fixtureId);
}

void openBottomMenuControlBox(int owner) {
  bottomMenuControlBoxOpen = true;
  bottomMenuAllFixtures = false;
  currentBottomMenuControlBoxOwner = owner;
  bottomMenuControlBoxDisplayText = "Fixture ID: " + owner + ", Type: " + fixtures.get(owner).fixtureType + ", Starting Channel: " + fixtures.get(owner).channelStart;
  boolean successInit = false; //This boolean is set to true, if the fixtureType has a specific configuration applied for it.
  
  //Get data from functions in profiles.pde 
  {
    int fT = fixtures.get(owner).fixtureTypeId;
    String[] chNames = getChNamesByFixType(fT);
    bottomMenuControlBoxControllers = new bottomMenuChController[chNames.length];
    for (int i = 0; i < chNames.length; i++) {
      bottomMenuControlBoxControllers[i] = new bottomMenuChController(30 + i*90, 50, i, 0, chNames[i]);
    }
    successInit = true;
  }

  if (successInit) {
    bottomMenuControlBoxDMXValues = fixtures.get(owner).bottomMenu.getDMX();
    bottomMenuControlBoxDMXValueChanged = new boolean[bottomMenuControlBoxDMXValues.length];
  }
}

void drawBottomMenuControlBox() {
  if (bottomMenuControlBoxOpen) {
    
    
    pushMatrix();
    pushStyle();
    //Control box open ---> draw it
    translate(65, height - 260 - bottomMenuControlBoxHeight);
    
    //Frame of the box
    fill(5, 100, 150);
    stroke(9, 157, 222);
    strokeWeight(5);
    rect(0, 0, bottomMenuControlBoxWidth, bottomMenuControlBoxHeight, 40, 40, 40, 0);
    mouse.declareUpdateElementRelative("bottomMenuControlBox", "main:move", 0, 0, bottomMenuControlBoxWidth, bottomMenuControlBoxHeight);
    mouse.setElementExpire("bottomMenuControlBox", 2);
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
    mouse.declareUpdateElementRelative("bMCB:close", "bottomMenuControlBox", 0, 0, 21, 20); mouse.setElementExpire("bMCB:close", 2);
    //hovering over the X button AND mouse is down --> close box
    if (mouse.isCaptured("bMCB:close")) { bottomMenuControlBoxOpen = false; }
    popMatrix();
    
    if (bottomMenuControlBoxControllers != null) for (bottomMenuChController controller : bottomMenuControlBoxControllers) controller.draw();
    
    //Update DMX values-----------------------------------------------------------------|
    bottomMenuDMXUpdate();
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
    
    text(bottomMenuControlBoxDisplayText, 20, 30);
    
    //Reset draw modifiers
    popStyle();
    popMatrix();
  }
  if (!bottomMenuControlBoxOpen && bottomMenuControlBoxOpenOld) {
    //box was just closed
    
    //Make sure mouseLocked is false
    //if (mouseLocker.substring(bottomMenuControlBoxSubstr.length()).equals(bottomMenuControlBoxSubstr)) mouseLocked = false;
  }
  bottomMenuControlBoxOpenOld = bottomMenuControlBoxOpen;
}

void bottomMenuDMXUpdate() {
  int[] tempDMX = fixtures.get(currentBottomMenuControlBoxOwner).in.getDMX();
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
  if (changd) submitDMXFromBMCB(tempDMX);
}

void submitDMXFromBMCB(int[] input) {
  
  if(bottomMenuAllFixtures) {
    fixtureForSelected[0].bottomMenu.receiveDMX(input);
    setValuesToSelected();
  } else {
    fixtures.get(currentBottomMenuControlBoxOwner).bottomMenu.receiveDMX(input);
  }
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
    mouse.declareUpdateElementRelative("bMCB:slider" + assignedData, "bottomMenuControlBox", 0, 0, 20, 100);
    mouse.setElementExpire("bCMB:slider"+assignedData,  2);
    if (mouse.isCaptured("bCMB:slider"+assignedData) && mouse.firstCaptureFrame) {
      //Started dragging
      dragStartX = mouseX;
    }
    boolean valueChanged = false;
    
    if (mouse.isCaptured("bMCB:slider"+assignedData)) {
      value += map(dragY - mouseY, 0, 100 + constrain((mouseX - screenX(0, 20)), 0, 414), 0, 255);
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
    mouse.declareUpdateElementRelative("bMCB:go" + assignedData, "bottomMenuControlBox", 0, 0, 48, 15);
    mouse.setElementExpire("bCMB:go"+assignedData,  2);
    boolean goDown = mouse.isCaptured("bMCB:go"+assignedData);
    if (goDown) {
      mouseLocked = true;
      mouseLocker = "bottomMenuControlBox:go" + str(assignedData);
      if(value != 255) valueBeforeGo = value; else valueBeforeGo = 0;
      
      value = 255;
      setOwnerValue();
      oldGo = true;
    }
    if (!goDown && oldGo) { value = valueBeforeGo; setOwnerValue(); oldGo = false; }
    drawBottomMenuChControllerButton("Go", goDown);
    //Toggle button
    translate(0, 20);
    mouse.declareUpdateElementRelative("bMCB:toggle" + assignedData, "bottomMenuControlBox", 0, 0, 48, 15);
    mouse.setElementExpire("bCMB:toggle"+assignedData,  2);
    boolean tglDown = mouse.isCaptured("bMCB:toggle"+assignedData);
    if (tglDown && mouse.firstCaptureFrame) {
      mouseLocked = true;
      mouseLocker = "bottomMenuControlBox:toggle" + str(assignedData);
      if (value == 0) value = 255; else value = 0;
      setOwnerValue();
    }
    drawBottomMenuChControllerButton("Toggle", tglDown);
    
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
