//Draw main/2D visualization

boolean rotateLamp = false;
int lampToRotate = -1;
PVector oldMouseForMovingFixtures = new PVector(0, 0);
int rotationForAllTheFixtures;
boolean rotateFixturesToSamePoint;

boolean editFixtureType;
int lampToEditFixtureType;
boolean firsTimeDrawingFixtureTypeBox;

boolean addedElementsToHelp = false;

void drawMainWindow() {
  if(!addedElementsToHelp) {
    help.add("Rotating fixture", "You can rotate fixture by pressin r key and dragging fixture");
    help.add("Changing fixtureType", "You can open fixtureType menu by pressing t key and clicking on the fixture");
    addedElementsToHelp = true;
  }
  pushMatrix(); 
   
   { //Declare all the mouse elements
     mouse.declareUpdateElement("main:fixtures", 0, 0, 0, width, height);
     mouse.getElementByName("main:fixtures").autoCapture = false;
     mouse.declareUpdateElement("main:move", 0, 0, 0, width, height);
     mouse.getElementByName("main:move").autoCapture = false;
   } //End of declaring all the mouse variables
   
   { //Transform view
     translate(width/2, height/2); //Move view for fine rotating
     scale(zoom/100); //Scale view
     translate(x_siirto, y_siirto); //Move view depending on the values set by user
     if(pageRotation != 0) { rotate(radians(pageRotation)); } //Rotate view depending on the values set by user
     translate(-width/2, -height/2); //Move view back after rotating
   } //End of transforming view
   
   
   
  { //begin drawing all elements (fixtures & other non-HUD objects)
    //Just using the rotation of PVectors, it already exists, so why not use it?
    PVector mouseRotated = new PVector(mouseX, mouseY);
    if(pageRotation != 0) { mouseRotated.rotate(radians(-pageRotation)); }
    
    //DRAW TRUSSES
    drawTrusses(mouseRotated); //Draw trusses
    if(showSockets) { drawSockets(mouseRotated); } //Draw sockets
    
    

    
    //THIS FOR LOOP DRAWS ALL THE FIXTURES AND CHECKS IF YOU HAVE CLICKED THEM
    if(programReadyToRun) if(!showSockets) for(int i = 0; i < fixtures.size(); i++) if(fixtures.get(i).size.isDrawn) { //Go through all the fixtures if sockets aren't shown
      pushMatrix();
      
        fixture fix = fixtures.get(i);
        PVector originalLocation = new PVector(fix.x_location, fix.y_location);
        PVector trussOffset = new PVector(0, 0); //Create PVector to loccate fixtures to right places according to trusses
        if(trusses != null) if(trusses[fix.parentAnsa] != null) { //Block nullpointer for trusses
          trussOffset = new PVector(trusses[fix.parentAnsa].location.x, trusses[fix.parentAnsa].location.y); //Get truss offset from right truss
        } //End of blocking nullpointer for trusses
        PVector finalLocation = new PVector(originalLocation.x + trussOffset.x, originalLocation.y + trussOffset.y); //Location where fixture is finally drawn
        
        //Center fixture
        finalLocation.x += fix.size.w/2;
        finalLocation.y += fix.size.h/2;
        //End of centering
        
        translate(finalLocation.x, finalLocation.y);
        
        
        if(!showMode && !showModeLocked) { //Rotating and enabling fixtures possible only if showMode isn't enabled
          //Fixture rotating
          if(rotateLamp && (lampToRotate == i || (fixtures.get(lampToRotate).selected && fix.selected))) {
            PVector vec = new PVector(mouseX - screenX(0, 0), mouseY - screenY(0, 0));
            if(rotateFixturesToSamePoint) {
              int rot = round(((vec.heading() + TWO_PI + HALF_PI) % TWO_PI) / TWO_PI * 360);
              fix.rotationZ = rot;
            }
            else {
              if(lampToRotate == i) { 
                rotationForAllTheFixtures = round(((vec.heading() + TWO_PI + HALF_PI) % TWO_PI) / TWO_PI * 360); 
              }
              fix.rotationZ = rotationForAllTheFixtures;
            }
          }
          //End of fixture rotating
          
          //Fixture moving
          if(moveLamp && (lampToMove >= 0 && lampToMove < fixtures.size())) { //Check are we moving any lamp and is lampToMove valid
            if(moveLamp && (lampToMove == i || (fixtures.get(lampToMove).selected && fix.selected))) {
              PVector mouseOffset = new PVector((mouseRotated.x - oldMouseForMovingFixtures.x) * 100 / zoom, (mouseRotated.y - oldMouseForMovingFixtures.y) * 100 / zoom);
              fix.x_location += int(mouseOffset.x); //Add mouse offset
              fix.y_location += int(mouseOffset.y); //Add mouse offset
            }
          } //End of checking are we moving any lamp and is lampToMove valid
          //End of fixture moving
        }
        
        

        if(fix.rotationZ != 0) { rotate(radians(fix.rotationZ)); }
        
         
        //IF cursor is hovering over i:th fixtures bounding box AND fixture should be drawn AND mouse is clicked
        //Functions running when pressed on the fixture
        if(isHover(-fix.size.w/2, -fix.size.h/2, fix.size.w, fix.size.h) && mousePressed && !mouse.captured && mouse.elmIsHover("main:fixtures")) {
          if(mouseButton == RIGHT) { //Functions running when pressed on the fixture with mouse left button
            mouse.capture(mouse.getElementByName("main:fixtures"));
            contextMenu1.initiateForFixture(i);
          } //End of functions running when pressed on the fixture with mouse left button
          else { //Functions running when pressed on the fixture with mouse left button
            mouse.capture(mouse.getElementByName("main:fixtures"));
            oldMouseX1 = int(mouseRotated.x);
            oldMouseY1 = int(mouseRotated.y);
            if(!showMode && !showModeLocked) { //Rotate and move fixtures if not in showMode
              if(keyPressed && key == 'r') { //If r pressed then we will rotate fixture
                lampToRotate = i; //Tell what fixture are we rotating
                rotateLamp = true; //Tell that we are rotating some fixture 
              }
              else if(keyPressed && key == 't') {
                lampToEditFixtureType = i;
                editFixtureType = true;
                firsTimeDrawingFixtureTypeBox = true;
              }
              else { //If only mouse clicked without pressing r then we will move fixture
                lampToMove = i; //Tell what fixture we are moving
                moveLamp = true; //Tell that we are moving some fixture
              }
              mouseReleased = false; //Tell that mouse isn't released anymore
            } 
            else { //Put fixture on and off by clicking it in showMode
              fix.toggle(true);
            }
          } //End of functions running when pressed on the fixture with mouse left button
        } //End of functions running when pressed on the fixture
        fix.draw2D(i); //This command draws the fixture
        
      popMatrix();
          
    } //End of going through all the fixtures if sockets aren't shown
    oldMouseForMovingFixtures = mouseRotated.get(); //Set old mouse location for fixture moving
    //END OF DRAWING ALL THE FIXTURES AND CHECKING IF YOU HAVE CLICKED THEM
    
    
    
    popMatrix(); //End of view scale, rotate and translate
    
    //Functions to draw fixtureTypeSelection dropdownMenu (these are loose from for loop above to put menu on top of fixtures)
    if(!showSockets && editFixtureType && lampToEditFixtureType >= 0 && lampToEditFixtureType < fixtures.size()) {
      pushMatrix();
        int i = lampToEditFixtureType;
        if(fixtures.get(i).size.isDrawn) {
          fixture fix = fixtures.get(i);
          
          PVector finalLocation = new PVector(fix.locationOnScreenX, fix.locationOnScreenY); //Location where fixture is finally drawn
          
          
          translate(finalLocation.x, finalLocation.y);
          
          //Type selection from dropdownMenu
          if(editFixtureType && lampToEditFixtureType == i) {
            pushMatrix();
              translate(-(fixtureTypes.getBlockSize().x/2), (fix.size.h/2)*zoom/100+25);
              fixtureTypes.draw();
              if(firsTimeDrawingFixtureTypeBox) {
                fixtureTypes.setValue(fix.fixtureTypeId);
                fixtureTypes.open = true;
                firsTimeDrawingFixtureTypeBox = false;
              }
              if(fixtureTypes.valueHasChanged()) {
                fix.fixtureTypeId = fixtureTypes.getValue();
                lampToEditFixtureType = -1;
                editFixtureType = false;
              }
            popMatrix();
          }
          //End of type selection from dropdownMenu
        }
      popMatrix();
    }
    //End of functions to draw fixtureTypeSelection dropdownMenu
    
  } //Endof: draw all elements
  
  //Check if mouse is released
    if(!mousePressed) { 
      //If mouse isn't pressed then we aren't moving or rotating anything
      rotateLamp = false;
      moveLamp = false; 
    }
  //End of checking is mouse released
  
  //------------------View drag & box selection------------------------
    if(!moveLamp) {
      if(mousePressed) {
        if (mouseButton == LEFT) {
          if (!mouse.captured || mouse.isCaptured("main:move")) {
            mouse.capture(mouse.getElementByName("main:move"));
            movePage();
            editFixtureType = false;
          }
        } else if(mouseButton == RIGHT) {
          //Box select
          editFixtureType = false;
          doBoxSelect();
        }
      }
    }
    if(!mousePressed && boxSelect) thread("endBoxSelect");
  //-------------End of view drag & box selection----------------------
}




//----------\
int boxStartX, boxStartY;
boolean boxSelect = false;
void doBoxSelect() {
    if (!mouse.captured) {
      
      mouse.capture(mouse.getElementByName("main:move"));
      
      boxSelect = true;
      boxStartX = mouseX;
      boxStartY = mouseY; 
    } else if(mouse.isCaptured("main:move")) {
      
      pushStyle();
      fill(50, 50, 150, 150);
      stroke(0, 0, 150);
      rectMode(CORNERS);
      rect(mouseX, mouseY, boxStartX, boxStartY);
      popStyle();
    }
  
}
void endBoxSelect() {
  boxSelect = false;
  
  //Get smallest corners of the box
  int[] cornerX = { boxStartX, mouseX };
  int x1 = min(cornerX);
  int x2 = max(cornerX);
  int[] cornerY = { boxStartY, mouseY };
  int y1 = min(cornerY);
  int y2 = max(cornerY);
  
  if(abs(x2 - x1) > 15 && abs(y2 - y1) > 15) {
    
    boolean shiftDown = keyPressed && keyCode == SHIFT;
    boolean ctrlDown = keyPressed && keyCode == CONTROL;
    
    for (int i = 0; i < fixtures.size(); i++) {
      boolean inside = inBds2D(
        fixtures.get(i).locationOnScreenX,
        fixtures.get(i).locationOnScreenY,
        x1, y1,
        x2, y2
      );
      
      
      if(shiftDown) fixtures.get(i).selected = fixtures.get(i).selected || inside; //additive select
        else if(ctrlDown) fixtures.get(i).selected = inside ? false : fixtures.get(i).selected; //exclusive select
          else fixtures.get(i).selected = inside;
        
       
    }
  } else if(!showMode && !showModeLocked) {
    //open contextMwnu
    String[] acts = { "createNewFixtureAt00" };
    String[] texs = { "Create new fixture" };
    contextMenu1.initiate(acts, texs, mouseX, mouseY);
  }
}
//----------/
