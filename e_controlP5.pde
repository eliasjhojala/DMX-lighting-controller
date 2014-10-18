//CONTROL WINDOW CODE//---->

   //This file is based on:
   /**
   * ControlP5 Controlframe
   * with controlP5 2.0 all java.awt dependencies have been removed
   * as a consequence the option to display controllers in a separate
   * window had to be removed as well. 
   * this example shows you how to create a java.awt.frame and use controlP5
   *
   * by Andreas Schlegel, 2012
   * www.sojamo.de/libraries/controlp5
   *
   */

 import java.io.File.*;
 //This file is a part of a DMX control sweet. This part of the program uses specific variables. THIS IS NOT A STANDALONE PROGRAM
 
 
 /*
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */
 
boolean wave = false;

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(theWidth, theHeight);
  f.setLocation(100, 100);
  f.setResizable(true);
  f.setVisible(true);
  return p;
}

//Comments from original file
  // the ControlFrame class extends PApplet, so we 
  // are creating a new processing applet inside a
  // new frame with a controlP5 object loaded

public class ControlFrame extends PApplet {

  int w, h;
  
  int pressedButton1 = 0;
  int pressedButton2 = 0;
 
  boolean effChaser;
  boolean effChaserOld = false;
  
  XML presets;
  int[] targetDim = new int[13]; // 0 = master
  boolean reachedTarget = true;
  
  int childrenLength = 0;
  void savePresets() {
    
    saveXML(presets, savePath + "cp5Presets.xml");
  }
  
  //Self explanatory...
  boolean successLoad = false;
  void loadPresets() {
    //Load raw XML data
      //This will throw an error if there is no file, but it shouldn't interrupt execution.
    XML loadedXML = loadXML(loadPath + "cp5Presets.xml");
    
    //Check if load was succesful
    if(loadedXML != null) {presets = loadedXML; successLoad = true;} else {presets = parseXML("<root></root>"); successLoad = false;}
    
    int offset = 0;
    
    if (successLoad) {offset -= 2;} else {offset = 0;}
    
    //What? Why such an equation? Well, the getChildCount is weird... (Spent 2 hours trying to figure this out)
    if (presets.getChildCount() > 2) {offset += - ((presets.getChildCount() - 1) / 2) + 1;}
    childrenLength = presets.getChildCount() + offset;
    addButtonsForNewPresets();
    
  }
  int preRow;
  int checkedPresets = 0;
  void addButtonsForNewPresets() {
    //for every unprocessed preset, create a new button
    for (int i = checkedPresets; i < childrenLength; i++) {
      // if the width of checked presets - prerow * width exceeds window width, add a new row
      if (checkedPresets * 25 + 20 + 20 - preRow * (width - 25) > width) {preRow++;}
      cp5.addButton("preset" + str(i + 1))
     .setLabel(str(i + 1))
     .setValue(0)
     .setPosition(10 + checkedPresets * 25 - preRow * (width - 25), aY + aHeight + 45 + preRow * 30)
     .setSize(20, 20)
     .moveTo("default")
     ;
     checkedPresets ++;
    }
  }
  
  //  A Slider params:
        int maxi = 0;
        int aXoffset = 10;
        int aY = 30;
        int aWidth = 14;
        int aHeight = 100;
    //  /params
  
  int createdAnsaZBoxes = 0;
  int createdAnsaXBoxes = 0;
  int createdAnsaYBoxes = 0;
  int createdAnsaTypeBoxes = 0;
  
  ///////////////////////////////////////////////////////////
  public void setup() {
    
    if(!dataLoaded) {
      loadSetupData();
      loadAllData();
    }
    
    //startof: Setup
    //set window size according to parameters
    size(w, h);
    //set window framerate (This will affect Wave and Preset transition times! Change cautiously.)
    frameRate(25);
    //load ControlP5 (The control element library) (It's great, by the way!)
    cp5 = new ControlP5(this);
    
    
    
    //From original file. Kept it here for reference
      // create a slider
      // parameters:
      // name, minValue, maxValue, defaultValue, x, y, width, height
    
    //CREATE UI ELEMENTS
    
    //Tab: Control
    cp5.tab("default").setLabel("Control");
    
    //A Sliders
    
    
    //Create A Sliders
    for (int i = 1; i <= 12; i++) {
    cp5.addSlider("a" + str(i), 0, 255, 0, aXoffset + (i - 1) * (aWidth + 20), aY, aWidth, aHeight)
    .setLabel(str(i))
    .setDecimalPrecision(0)
    .moveTo("default");
    maxi = i;
    }
    
    //Create A Slider Master
    cp5.addSlider("am", 0, 255, 255, aXoffset + maxi * (aWidth + 20), aY, aWidth, aHeight)
    .setLabel("Master")
    .setDecimalPrecision(0)
    .moveTo("default");
     
     //Create A Preset Button
     cp5.addButton("asvPre")
     .setLabel("Save as Preset")
     .setValue(0)
     .setPosition(10, aY + aHeight + 20)
     .setSize(100, 20)
     .moveTo("default")
     ;
     
     //Create A Delete All Presets Button
     cp5.addButton("adelPre")
     .setLabel("Delete ALL presets")
     .setValue(0)
     .setPosition(this.w - 110, this.h - 60)
     .setSize(100, 20)
     .setColorForeground(color(200, 0, 0))
     .setColorActive(color(255, 0, 0))
     .moveTo("default")
     ;
     
     
    
     //Tab: Effects
     cp5.tab("effects").setLabel("Efektit");
     
     //Create chaser toggle
     cp5.addToggle("effChaser")
    .setLabel("Chaser")
    .setPosition(10, 20)
    .setSize(20, 20)
    .moveTo("effects")
    ;
    
    cp5.addTextlabel("waveEffLabel")
    .setText("Wave Effect")
    .setPosition(5, 80)
    .moveTo("effects")
    ;
    
    cp5.addRange("waveRange")
    .setLabel("Wave Range")
    .setPosition(10, 90)
    .setSize(100, 14)
    .setHandleSize(10)
    .setDecimalPrecision(0)
    .setRange(1, 12)
    .setRangeValues(1, 12)
    .moveTo("effects")
    ;
    
    cp5.addButton("waveTrigger")
     .setLabel("Trigger Wave")
     .setValue(0)
     .setPosition(10, 110)
     .setSize(100, 20)
     .moveTo("effects")
     ;
     
     cp5.addNumberbox("waveLengthBox")
    .setLabel("Wave Length")
    .setPosition(180, 90)
    .setSize(30, 14)
    .setDecimalPrecision(0)
    .setRange(1, 100)
    .setValue(3)
    .moveTo("effects")
    ;
    
    cp5.addNumberbox("waveStepBox")
    .setLabel("Wave Step")
    .setPosition(240, 90)
    .setSize(30, 14)
    .setDecimalPrecision(0)
    .setRange(1, 100)
    .setValue(2)
    .moveTo("effects")
    ;
    
    //Tab: Settings
    cp5.tab("settings").setLabel("Asetukset");
    
    //Label for Source Grouping
    cp5.addTextlabel("groupingLabel")
    .setText("Source grouping: ")
    .setPosition(10, 20)
    .moveTo("settings")
    ;
    
    //Create Grouping's numberBoxes
    cp5.addNumberbox("grouping1")
    .setSize(40, 10)
    .setRange(1, 5)
    .setPosition(10, 40)
    .setLabel("ControlP5")
    .moveTo("settings")
    ;
    cp5.addNumberbox("grouping2")
    .setSize(40, 10)
    .setRange(1, 5)
    .setPosition(60, 40)
    .setLabel("enttec DMX")
    .moveTo("settings")
    ;
    cp5.addNumberbox("grouping3")
    .setSize(40, 10)
    .setRange(1, 5)
    .setPosition(110, 40)
    .setLabel("Touch OSC")
    .moveTo("settings")
    ;
    
    //View rotation knob
      //Label for it
    cp5.addTextlabel("viewRotLabel")
    .setText("View Rotation")
    .setPosition(10, 80)
    .moveTo("settings")
    ;
    
    cp5.addKnob("viewRotKnob")
    .setRange(0, 360)
    .setPosition(20, 100)
    .setDecimalPrecision(0)
    .setLabel("")
    .setNumberOfTickMarks(36)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .moveTo("settings")
    ;
    
    //Ansa Z nBoxes
    for (int i = 0; i < ansaZ.length; i++) {
      createdAnsaZBoxes ++;
      cp5.addNumberbox("ansaZ" + str(i))
      .setLabel("Ansa " + str(i) + " Z")
      .setPosition(20 + i * 105, 180)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(-10000, 10000)
      .setValue(ansaZ[i])
      .moveTo("settings")
      ;
    }
    
    for (int i = 0; i < ansaX.length; i++) {
      createdAnsaXBoxes ++;
      cp5.addNumberbox("ansaX" + str(i))
      .setLabel("Ansa " + str(i) + " X")
      .setPosition(20 + i * 105, 220)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(-10000, 10000)
      .setValue(ansaX[i])
      .moveTo("settings")
      ;
    }
    
    for (int i = 0; i < ansaY.length; i++) {
      createdAnsaYBoxes ++;
      cp5.addNumberbox("ansaY" + str(i))
      .setLabel("Ansa " + str(i) + " Y")
      .setPosition(20 + i * 105, 260)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(-10000, 10000)
      .setValue(ansaY[i])
      .moveTo("settings")
      ;
    }
    
    for (int i = 0; i < ansaType.length; i++) {
      createdAnsaTypeBoxes ++;
      cp5.addNumberbox("ansaType" + str(i))
      .setLabel("Ansa " + str(i) + " visibility")
      .setPosition(20 + i * 105, 300)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(0, 1)
      .setValue(ansaType[i])
      .moveTo("settings")
      ;
    }
    
    
    //Tab: Fixture settings
     cp5.tab("fixtSettings").setLabel("Fixture Settings").setVisible(false);
     
     //RGB Sliders
     cp5.addSlider("colorRed", 0, 255, 255, 10, 20, 14, 100)
    .setLabel("R")
    .moveTo("fixtSettings");
    
    cp5.addSlider("colorGreen", 0, 255, 255, 60, 20, 14, 100)
    .setLabel("G")
    .moveTo("fixtSettings");
    
    cp5.addSlider("colorBlue", 0, 255, 255, 110, 20, 14, 100)
    .setLabel("B")
    .moveTo("fixtSettings");
    
    //Rotation Knob
    cp5.addKnob("fixtRotation")
    .setRange(-90, 90)
    .setPosition(20, 150)
    .setDecimalPrecision(0)
    .setLabel("")
    .setNumberOfTickMarks(36)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .moveTo("fixtSettings")
    ;
    //Rotation label
    cp5.addTextlabel("fixtRotationLabel")
    .setText("Rotation Z")
    .setPosition(20, 200)
    .moveTo("fixtSettings")
    ;
    
    //X rotation knob
    cp5.addKnob("fixtRotationX")
    .setRange(0, 360)
    .setPosition(80, 150)
    .setDecimalPrecision(0)
    .setLabel("")
    .setNumberOfTickMarks(36)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .moveTo("fixtSettings")
    ;
    //Rotation label
    cp5.addTextlabel("fixtRotationXLabel")
    .setText("Rotation X")
    .setPosition(80, 200)
    .moveTo("fixtSettings")
    ;
    
    //Fixture Z location
    cp5.addNumberbox("fixtZ")
    .setLabel("Z Location")
    .setPosition(20, 300)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(-10000, 10000)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    //Fixture channel
    cp5.addNumberbox("fixtChan")
    .setLabel("Channel")
    .setPosition(150, 300)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(1, 511)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    

    //Fixture Parameter
    cp5.addNumberbox("fixtParam")
    .setLabel("Parameter")
    .setPosition(20, 330)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(-10000, 10000)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    //Parent ansa
    cp5.addNumberbox("ansaParent")
    .setLabel("ansaParent")
    .setPosition(20, 430)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(0, numberOfAnsas-1)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    //Fixture order number in lower menu
    cp5.addNumberbox("orderNumber")
    .setLabel("Order in lower menu")
    .setPosition(300, 430)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(0, 1000)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    
    //Fixture type Dropdown
    lb = cp5.addDropdownList("fixtType")
    .setPosition(180, 40)
    .setSize(200, 200)
    .setItemHeight(15)
    .setBarHeight(20)
    
    .moveTo("fixtSettings")
    ;
    
    lb.captionLabel().style().marginTop = 6;
    lb.captionLabel().style().marginLeft = 3;
    
    //Add dropdown items
    lb.addItem("Par64", 1);
    lb.addItem("Pieni Fresu", 2);
    lb.addItem("Kesk. Fresu", 3);
    lb.addItem("Iso Fresu", 4);
    lb.addItem("Flood", 5);
    lb.addItem("Linssi", 6);
    lb.addItem("Haze", 7);
    lb.addItem("Haze Fan", 8);
    lb.addItem("Strobe", 9);
    lb.addItem("Strobe Freq.", 10);
    lb.addItem("Fog", 11);
    lb.addItem("Pinspot", 12);
    lb.addItem("1. MH-X50", 16);
    lb.addItem("2. MH-X50", 17);
    
    
    //Create and define the tooltip
    cp5.getTooltip().setDelay(500);
    cp5.getTooltip().register("asvPre","Saves a new preset. ");
    //cp5.getTooltip().register("s2","Changes the Background");
    
    //Check the loadPresets void
    loadPresets();
    
    //endof: Setup
     

  }
  DropdownList lb;
  
  //////////////////////////////////////////////////////////////////////////////
  
  //The controlEvent void triggers also when the elements are created, so we have to make sure it doesn't execute the trigger at the first catch of a specific element. (asvPre and adelPre should not be fired at program launch)
  boolean deleteAll = false;
  boolean createNew = false;
  boolean Trigwave = false;
  
  public void controlEvent(ControlEvent theEvent) {
    //DropDownlists don't like .getName(), so we'll check that there is no error
    boolean error = false;
    try {
      theEvent.getController().getName();
    } catch(Exception e) {error = true;}
    
    //startof: Event catcher
    if(error != true) {
    //println(theEvent.getController().getName());
    if(theEvent.getController().getName() == "waveTrigger") {
      if (Trigwave == true) {
        // Old method
       //waveLocation[int(cp5.controller("waveRange").getArrayValue()[0]) - 1] = true;
       
       wave = true;
      }
      Trigwave = true;
    }
    //Create preset button pressed?
    if(theEvent.getController().getName() == "asvPre") {
      if (createNew == true) {
       aCreatePreset();
      }
      createNew = true;
    }
    //Delete all presets button pressed?
    if(theEvent.getController().getName() == "adelPre") {
      if (deleteAll == true) {
       aDeleteAllPresets();
      }
      deleteAll = true;
    }
    
    //Preset button pressed?
    if(theEvent.getController().getName().startsWith("preset")) {
      //Get preset id from controller name
      int presetId = int(theEvent.getController().getName().replace("preset", ""));
      //Load preset with parset id
      loadPreset(presetId);
    }
    
    
    
    
    //Update waveLength
    if(theEvent.getController().getName().startsWith("waveLengthBox")){
      waveLength = int(cp5.controller("waveLengthBox").getValue());
      waveData = new int[12 + waveLength];
      waveLocation = new boolean[12 + waveLength];
    }
    //Update waveStep
    if(theEvent.getController().getName().startsWith("waveStepBox")){
      waveStep = int(cp5.controller("waveStepBox").getValue());
    }
    }
    //endof: Event catcher
  }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////
   
  //Load preset; params: id = Preset id
  void loadPreset(int id) {
    
    //Set target values for main sliders
    for (int i = 1; i <= 12; i++) {
      targetDim[i] = int(presets.getChild("preset" + str(id)).getChild("chan" + str(i)).getContent());
    }
    //Reminder: 0 = master!; Set target value for master sliders
    targetDim[0] = int(presets.getChild("preset" + str(id)).getChild("master").getContent());
    
    //initialize toTarget (transition)
    reachedTarget = false;
    started = false;
    targetStep = 0;
  }
  
  
  
  //Note to self: This void gets triggered 25 times a second. (Unless computer can't keep up with 25 FPS) The animation will happen in 10 frames
  int targetStep = 0;
  int transitionSteps = 20;
  int[] targetFrom = new int[13];
  boolean started = false;
  void toTarget() {
    //Check if we have a pending transition
    if (reachedTarget == false) {
      if (started == false) {
        //first step of animation -- saves original values for use later
        for (int i = 1; i <= 12; i++) {targetFrom[i] = int(cp5.controller("a" + str(i)).getValue());}
        targetFrom[0] = int(cp5.controller("am").getValue());
        started = true;
        
      }
      
      //Set sliders according to transition step
      //Set slider values to target at last step, because the transition might leave behind a slightly modified value of the original (Division inaccuracy)
      if(targetStep >= transitionSteps) {
        for (int i = 1; i <= 12; i++) {
          cp5.controller("a" + str(i)).setValue(targetDim[i]);
        }
        cp5.controller("am").setValue(targetDim[0]);
      } else {
        for (int i = 1; i <= 12; i++) {
          cp5.controller("a" + str(i)).setValue(targetFrom[i] + (targetDim[i] - targetFrom[i]) * 100 / transitionSteps * targetStep / 100);
        }
        cp5.controller("am").setValue(targetFrom[0] + (targetDim[0] - targetFrom[0]) * 100 / transitionSteps * targetStep / 100);
      }
      targetStep ++;
      if (targetStep >= transitionSteps + 1) {
        //Transition has finished
        reachedTarget = true;
      }
    }
    
  }
  
  void aDeleteAllPresets() {
    //Delete the file
    File f = new File(savePath + "cp5Presets.xml");
    f.delete();
    //Remove the buttons
    
    for (int i = checkedPresets; i > 0; i--) {
      
      cp5.controller("preset" + str(i)).remove();
      
    }
    //Reset the count values
    childrenLength = 0;
    checkedPresets = 0;
    preRow = 0;
    //Reset the presets XML in memory
    presets = parseXML("<root></root>");
  }
  
  
  void aCreatePreset() {
    //Here I went with a parseXML, because it was the simplest.
    
    childrenLength ++;
    //Start preset node
    String newVals = "<preset"+ str(childrenLength) +">";
    
    //Write channel nodes
    for (int i = 1; i <= 12; i++) {
      newVals = newVals + "<chan" + str(i) + ">" + str(int(cp5.controller("a" + str(i)).getValue())) + "</chan" + str(i) + ">";
    }
    //Write master node
    newVals = newVals + "<master>" + str(int(cp5.controller("am").getValue())) + "</master>";
    //Close preset node
    newVals = newVals + "</preset" + str(childrenLength) + ">";
    
    //add the structure to the presets XML variable
    presets.addChild(parseXML(newVals));
    
    //Save XML file & add a button for the new preset
    savePresets();
    addButtonsForNewPresets();
    
    //lowpriorityTODO: Add automatic reload if file changed
  }
  
  
  ////////////////////////////////////////////////////////////////////////////////////////
  
  int waveStep = 2;
  int waveCurrentStep = 1;
  int waveLength = 3;
  int[] waveData = new int[12 + waveLength];
  boolean[] waveLocation = new boolean[12 + waveLength];
  
  void calculateWave() {
    //Take old wave data from slider values (So that this doesn't put the sliders to zero when there are no waves going on)
    for (int i = 0; i < 12; i++) {
      cp5.controller("a" + str(i + 1)).setValue(cp5.controller("a" + str(i + 1)).getValue() - waveData[i]);
    }
    
    waveData = new int[12 + waveLength];
    for (int i = 0; i < 12 + waveLength; i++) {
      if (waveLocation[i] == true) {
        //Wave peak
        if (i >= cp5.controller("waveRange").getArrayValue()[0] - 1 && i <= cp5.controller("waveRange").getArrayValue()[1] - 1) {
          waveData[i] = 255;
        }
        
        //Left & Right sides of wave peak
        for (int w = 1; w <= waveLength; w++) {
          int val = 255 - 255 / waveLength * w;
          
          if (i - w <= cp5.controller("waveRange").getArrayValue()[1] - 1 && i - w >= cp5.controller("waveRange").getArrayValue()[0] - 1 && waveData[i - w] < val) {
            waveData[i - w] = val;
          }
          
          if (i + w <= cp5.controller("waveRange").getArrayValue()[1] - 1 && i + w >= cp5.controller("waveRange").getArrayValue()[0] - 1 && waveData[i + w] < val) {
            waveData[i + w] = val;
          }
        }
      }
    }
    
    //Add wave data to slider values
    for (int i = 0; i < 12; i++) {
      cp5.controller("a" + str(i + 1)).setValue(cp5.controller("a" + str(i + 1)).getValue() + waveData[i]);
    }
    
    //Push all values to the right if waveCurrentStep > waveStep
    if (waveCurrentStep > waveStep) {
      waveCurrentStep = 1;
      //I could just do waveLocationTemp = waveLocation, but that (I believe) assigns the same memory location for both arrays
      boolean[] waveLocationTemp = new boolean[12 + waveLength];
      for (int i = 0; i < 12 + waveLength; i++) {
        waveLocationTemp[i] = waveLocation[i];
      }
      
      waveLocation[0] = false;
      for (int i = 1; i < 12 + waveLength; i++) {
        waveLocation[i] = waveLocationTemp[i - 1];
      }
    } else {waveCurrentStep++;}
    
  }
  
  //////////////////////////////////////////////////////////////////////////
  
  //Just so that it wont start changing values unless the color change has been triggered atleast once.
  boolean fixtureColorChangeHasHappened = false;
  
  //Used to determine whether view rotation knob value should be sent to the main window (it should only happen when the knob is changed)
  int oldKnobVal;
  public void draw() {
    
    //startof: Draw
    
      if (typingPreset) {
        presetTypingCurrent ++;
        if(presetTypingCurrent >= presetTypingDelay * frameRate) {
          //Exit typing, as too much time has passed
          typedPreset = "";
          typingPreset = false;
          presetTypingCurrent = 0;
        }
      }
    
      //Make a step towards the target
      toTarget();
      //If wave trigger is true, generate a wave at first allowed position (minimum value of the waveRange range control), set wave trigger to false
      if(wave) {wave = false; waveLocation[int(cp5.controller("waveRange").getArrayValue()[0]) - 1] = true;}
      calculateWave();
      //Check for fixture color change initiation
      if (toChangeFixtureColor){
        fixtureColorChangeHasHappened = true;
        cp5.controller("colorRed").setValue(fixtures[changeColorFixtureId].red);
        cp5.controller("colorGreen").setValue(fixtures[changeColorFixtureId].green);
        cp5.controller("colorBlue").setValue(fixtures[changeColorFixtureId].blue);
        cp5.controller("fixtRotation").setValue(fixtures[changeColorFixtureId].rotationZ);
        cp5.controller("fixtRotationX").setValue(fixtures[changeColorFixtureId].rotationX);
        cp5.controller("fixtZ").setValue(fixtures[changeColorFixtureId].z_location);
        cp5.controller("fixtChan").setValue(fixtures[changeColorFixtureId].channelStart);
        cp5.controller("fixtParam").setValue(fixParam[fixtureIdNow[changeColorFixtureId]]);
        cp5.controller("ansaParent").setValue(fixtures[changeColorFixtureId].parentAnsa);
        cp5.controller("orderNumber").setValue(bottomMenuOrder[changeColorFixtureId]);
        lb.setIndex(fixtures[changeColorFixtureId].fixtureTypeId - 1);
        //Make the color tab visible and activate it
        cp5.tab("fixtSettings").setVisible(true).setLabel("Fixture ID: " + str(changeColorFixtureId));
        cp5.window(this).activateTab("fixtSettings");
        
        toChangeFixtureColor = false;
      }
      
      //Make the color tab invisible again when the user goes out of it
      if(cp5.tab("fixtSettings").isActive() == false) {cp5.tab("fixtSettings").setVisible(false);}
      
      //Set RGB values for selected fixture
      if (fixtureColorChangeHasHappened && cp5.tab("fixtSettings").isActive()) {
        fixtures[changeColorFixtureId].red = int(cp5.controller("colorRed").getValue());
        fixtures[changeColorFixtureId].green = int(cp5.controller("colorGreen").getValue());
        fixtures[changeColorFixtureId].blue = int(cp5.controller("colorBlue").getValue());
        fixtures[changeColorFixtureId].rotationZ = int(cp5.controller("fixtRotation").getValue());
        fixtures[changeColorFixtureId].rotationX = int(cp5.controller("fixtRotationX").getValue());
        fixtures[changeColorFixtureId].z_location = int(cp5.controller("fixtZ").getValue());
        fixtures[changeColorFixtureId].channelStart = int(cp5.controller("fixtChan").getValue());
        fixParam[fixtureIdNow[changeColorFixtureId]] = int(cp5.controller("fixtParam").getValue());
        fixtures[changeColorFixtureId].parentAnsa = int(cp5.controller("ansaParent").getValue());
        bottomMenuOrder[changeColorFixtureId] = int(cp5.controller("orderNumber").getValue());
        fixtures[changeColorFixtureId].fixtureTypeId = int(lb.getValue());
      }
      
      //Set ansa Z values according to NBoxes
      if(dataLoaded == true) {
        for (int i = 0; i < createdAnsaZBoxes; i++) {
          ansaZ[i] = int(cp5.controller("ansaZ" + str(i)).getValue());
        }
        for (int i = 0; i < createdAnsaXBoxes; i++) {
          ansaX[i] = int(cp5.controller("ansaX" + str(i)).getValue());
        }
        for (int i = 0; i < createdAnsaYBoxes; i++) {
          ansaY[i] = int(cp5.controller("ansaY" + str(i)).getValue());
        }
        for (int i = 0; i < createdAnsaTypeBoxes; i++) {
          ansaType[i] = int(cp5.controller("ansaType" + str(i)).getValue());
        }
      }
      
      
      //Update view rotation according to knob
      int knobVal = int(cp5.controller("viewRotKnob").getValue());
      if (knobVal != oldKnobVal) pageRotation = knobVal;
      oldKnobVal = knobVal;
      
      
      //ACTUAL DRAWING HAPPENS HERE!!!
      //Redraw backround
      background(100, 100, 100);
      
      //update effect variables
      if (effChaserOld != effChaser) {chase = effChaser; effChaserOld = effChaser;} else {}
      
      
      
      //set place variables
      controlP5place = int(cp5.controller("grouping1").getValue());
      enttecDMXplace = int(cp5.controller("grouping2").getValue());
      touchOSCplace = int(cp5.controller("grouping3").getValue());
      
      //set light dimming from (A Sliders / 255 * A Master)
      for (int i = 1; i <= 12; i++) {
        controlP5channel[i] = int(cp5.controller("a" + str(i)).getValue() * (cp5.controller("am").getValue() / 255));
      }
 

  }
  
  ///////////////////////////////////////////////////////////////////////////////////
  
  String typedPreset = "";
  boolean typingPreset = false;
  //How long before typing is cleared out (in s)
  int presetTypingDelay = 10;
  int presetTypingCurrent = 0;
  void keyPressed() {
    //If key is Enter (or return for macosx)
    if (keyCode == ENTER || keyCode == RETURN){
      if(typingPreset) {
        //If typed preset is not out of bounds
        if (int(typedPreset) <= checkedPresets && int(typedPreset) != 0) {loadPreset(int(typedPreset));}
        //Reset typing
        typedPreset = "";
        typingPreset = false;
        presetTypingCurrent = 0;
      }
      
    //C for cancel; Cancel typing
    } else if(key == 'c'){
      //Escape typing
      typedPreset = "";
      typingPreset = false;
      presetTypingCurrent = 0;
    } else {
      //See if key can be converted to an int
      boolean error = false;
      try {if(int(key) == 0) {error = true;}} catch(Exception e) {error = true;}
      //If there is no error, start preset activation sequence
      if (!error) {
        typingPreset = true;
        typedPreset = typedPreset + key;
        
      }
    }
    
    
    
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////
  //Frame info -- Not important
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = 500;
    h = 500;
  }
 

  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  
}

