
 behringerLC2412 LC2412;
 Input inputClass;
 Keyrig49 keyRig49;
 
 MidiHandlerWindow midiWindow = new MidiHandlerWindow();
 
 void midiWindowLoop() {
   midiWindow.closeAllTheMidiHandlerWindowsIfMainWindowIsClosed();
 }
 
 
 
 class MidiHandlerWindow {
   
   //Init window base variables
     int locX, locY, w, h;
     boolean open;
     Window window;
   //End of initting window base variables
   
   int selectedMachine; //variable to tell what device are we controlling atm
   
   //--------------Create all the controllers we use in this window---------------------
   /**/                                                                              //|
   /**/   DropdownMenu machineSelect;                                                //|
   /**/   DropdownMenu midiInSelect;                                                 //|
   /**/   DropdownMenu midiOutSelect;                                                //|
   /**/   RadioButtonMenu outputModes;                                               //|
   /**/   RadioButtonMenu toggleOrPush;                                              //|
   /**/   RadioButtonMenu buttonModeForLaunchpad;                                    //|
   /**/   NumberBoxTableWindow launchpadToggleOrPush;                                //|
   /**/   TextBoxTableWindow launchPadMemories;                                      //|
   /**/   NumberBoxTableWindow launchPadColors;                                      //|
   /**/   PushButton save, load, bankUp, bankDown;                                   //|
   /**/                                                                              //|
   /**/   NumberBoxTableWindow keyrig49keyModes;                                     //|
   /**/   NumberBoxTableWindow LC2412faderModes;                                     //|
   /**/   NumberBoxTableWindow LC2412buttonModes;                                    //|
   /**/                                                                              //|
   /**/   TextBoxTableWindow LC2412faderMemories;                                    //|
   /**/   TextBoxTableWindow LC2412buttonMemories;                                   //|
   /**/                                                                              //|   
   /**/   TextBoxTableWindow LC2412chaseFaderMemories;                               //| 
   /**/   TextBoxTableWindow LC2412masterFaderMemories;                              //| 
   /**/                                                                              //|   
   /**/   NumberBoxTableWindow LC2412chaseFaderModes;                                //| 
   /**/   NumberBoxTableWindow LC2412masterFaderModes;                               //| 
   /**/                                                                              //|
   //----------End of creating all the controllers we use in this window----------------
   

   
   MidiHandlerWindow() {
     { //Init window
       h = 500;
       w = 500;
       locX = 0;
       locY = 0;
       window = new Window("MidiHandlerWindow", new PVector(h, w), this);
     } //End of initting window
     
     { //Create all the controllers in midiWindow
       { //Create machineSelect dropdownMenu
         ArrayList<DropdownMenuBlock> midiMachines = new ArrayList<DropdownMenuBlock>();
         midiMachines.add(new DropdownMenuBlock("launchPad", 1));
         midiMachines.add(new DropdownMenuBlock("LC2412", 2));
         midiMachines.add(new DropdownMenuBlock("keyRig 49", 3));
         machineSelect = new DropdownMenu("midiMachines", midiMachines);
       } //End of creating machineSelect dropdownMenu
       
       { //Create midi in and out select dropdownMenus
         ArrayList<DropdownMenuBlock> midiInputs = new ArrayList<DropdownMenuBlock>();
         for(int i = 0; i < MidiBus.availableInputs().length; i++) {
           midiInputs.add(new DropdownMenuBlock(MidiBus.availableInputs()[i], i));
         }
         midiInSelect = new DropdownMenu("Midi inputs", midiInputs);
         
         ArrayList<DropdownMenuBlock> midiOutputs = new ArrayList<DropdownMenuBlock>();
         for(int i = 0; i < MidiBus.availableOutputs().length; i++) {
           midiOutputs.add(new DropdownMenuBlock(MidiBus.availableOutputs()[i], i));
         }
         midiOutSelect = new DropdownMenu("Midi outputs", midiOutputs);
       } //End of creating midi in and out select dropdownMenus
       
       { //Create outputModes radioButtonMenu
         outputModes = new RadioButtonMenu();
         outputModes.addBlock(new RadioButton("Memories", 1));
         outputModes.addBlock(new RadioButton("Fixtures", 2));
       } //End of creating outputModes radioButtonMenu
      
       { //Create toggleOrPush radioButtonMenu
         toggleOrPush = new RadioButtonMenu();
         toggleOrPush.addBlock(new RadioButton("Toggle", 0));
         toggleOrPush.addBlock(new RadioButton("Push", 1));
       } //End of creating toggleOrPush radioButtonMenu
       
       { //Create buttonModeForLaunchpad radioButtonMenu
         buttonModeForLaunchpad = new RadioButtonMenu();
         buttonModeForLaunchpad.addBlock(new RadioButton("Toggle", 0));
         buttonModeForLaunchpad.addBlock(new RadioButton("Push", 1));
         buttonModeForLaunchpad.addBlock(new RadioButton("Trigger", 2));
       } //End of creating buttonModeForLaunchpad radioButtonMenu
  	 
  	 
       { //Create launchpad buttons settings tables
         launchpadToggleOrPush = new NumberBoxTableWindow("launchpadToggleOrPush", 8, 8, 0, 4);
         launchPadMemories = new TextBoxTableWindow("launchPadMemories", 8, 8);
         launchPadColors = new NumberBoxTableWindow("launchPadColors", 8, 8, 0, 3);
       } //End of creating launchpad buttons settings tables
       
       { //Create keyrig49 keys settings tables
         keyrig49keyModes = new NumberBoxTableWindow("keyrig49keyModes", 29, 1, 0, 2);
       } //End of creating keyrig49 keys settings tables
       
       { //Create LC2412 settings tables for faders and buttons
         LC2412faderModes = new NumberBoxTableWindow("LC2412faderModes", 12, 2, 0, 1);
         LC2412buttonModes = new NumberBoxTableWindow("LC2412buttonModes", 12, 1, 0, 2);
         
         
         LC2412faderMemories = new TextBoxTableWindow("LC2412faderMemories", 12, 2);
         LC2412buttonMemories = new TextBoxTableWindow("LC2412buttonMemories", 12, 1);
         
         LC2412chaseFaderMemories = new TextBoxTableWindow("LC2412chaseFaderMemories", 3, 1);
         LC2412masterFaderMemories = new TextBoxTableWindow("LC2412masterFaderMemories", 3, 1);
         
         LC2412chaseFaderModes = new NumberBoxTableWindow("LC2412chaseFaderModes", 3, 1, 0, 1);
         LC2412masterFaderModes = new NumberBoxTableWindow("LC2412masterFaderModes", 3, 1, 0, 1);
         
       } //End of creating LC2412 settings tables for faders and buttons
       
       { //Create save and load buttons
         save = new PushButton("saveButtonInMidiWindow");
         load = new PushButton("loadButtonInMidiWindow");
       } //End of creating save and load buttons
       
       { //Create bank buttons
         bankUp = new PushButton("bankUpInMidiWindow");
         bankDown = new PushButton("bankDownInMidiWindow");
       } //End of creating bank buttons
     } //End of creating all the controllers in midiWindow
   }
   
   IntController offset = new IntController("testIntController");
   
   void closeAllTheMidiHandlerWindowsIfMainWindowIsClosed() {
     if(!open || selectedMachine != 1) {
       launchpadToggleOrPush.open = false;
       launchPadMemories.open = false;
       
       launchPadColors.open = false;
     }
     if(!open || selectedMachine != 2) {
       LC2412faderModes.open = false;
       LC2412buttonModes.open = false;
       
       LC2412faderMemories.open = false;
       LC2412buttonMemories.open = false;
       
       LC2412chaseFaderMemories.open = false;
       LC2412masterFaderMemories.open = false;
       
       LC2412chaseFaderModes.open = false;
       LC2412masterFaderModes.open = false;
     }
     if(!open || selectedMachine != 3) {
       keyrig49keyModes.open = false;
     }
   }
   
   int LC2412bank;
   boolean LC2412bankChanged;
   
   void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
     window.draw(g, mouse); //Draw window base
     
    
     g.pushMatrix();
       g.translate(40, 60); //Marginal (there is close button upper)
     
       { //Machineselect
         g.pushMatrix();
           if(!machineSelect.open) {
             switch(selectedMachine) {
               case 1: //Launchpad
                 g.translate(0, 50);
                 midiOutSelect.draw(g, mouse);
                 g.translate(200, 0);
                 midiInSelect.draw(g, mouse);
                 
                 if(midiOutSelect.valueHasChanged() || midiInSelect.valueHasChanged()) {
                   int input = -1;
                   int output = -1;
                   
                   if(launchpad != null) { output = launchpad.outputIndex; input = launchpad.inputIndex; }
                   if(midiOutSelect.valueHasChanged()) { output = midiOutSelect.getValue(); }
                   if(midiInSelect.valueHasChanged()) { input = midiInSelect.getValue(); }
                   
                   if(launchpad != null) { launchpad.setup(input, output); }
                   else { launchpad = new Launchpad(input, output); }
                   
                 }
                 
               break;
               
               case 2: //LC2412
                 g.translate(0, 50);
                 midiOutSelect.draw(g, mouse);
                 g.translate(200, 0);
                 midiInSelect.draw(g, mouse);
                 
                 if(midiOutSelect.valueHasChanged() || midiInSelect.valueHasChanged()) {
                   int input = -1;
                   int output = -1;
                   
                   if(LC2412 != null) { output = LC2412.outputIndex; input = LC2412.inputIndex; }
                   if(midiOutSelect.valueHasChanged()) { output = midiOutSelect.getValue(); }
                   if(midiInSelect.valueHasChanged()) { input = midiInSelect.getValue(); }
                   if(LC2412 != null) { LC2412.setup(input, output); }
                   else { LC2412 = new behringerLC2412(input, output); }
                 }
                 
               break;
               
               case 3: //Keyrig 49
                 g.translate(200, 50);
                 midiInSelect.draw(g, mouse);
                 
                 if(midiInSelect.valueHasChanged()) {
                   int input = midiInSelect.getValue();
                   if(keyRig49 != null) { keyRig49.setup(input); }
                   else { keyRig49 = new Keyrig49(input); }
                 }
                 
               break;
             }
           }
         g.popMatrix();
         
         if(machineSelect.valueHasChanged()) {
           selectedMachine = machineSelect.getValue();
         }
       } //End of machineselect
       
       { //Device specific settings
         if(selectedMachine == 1) { //Launchpad settings
           g.pushMatrix();
             g.translate(500, 0);
             launchPadMemories.locX = locX + 500;
             launchPadMemories.locY = locY + launchpadToggleOrPush.h;
             launchPadMemories.open = true;
             if(launchPadMemories.valueHasChanged()) {
               if(launchpad != null) {
                 TextBoxTableWindow LPM = launchPadMemories;
                 int x = LPM.changedValue()[0];
                 int y = LPM.changedValue()[1];
                 int val = LPM.getValue(x, y);
                 println(val);
                 try {
                   launchpad.setToggleToMemoryValue(val, x, y);
                 }
                 catch (Exception e) {
                   e.printStackTrace();
                 }
               }
             }
            
           g.popMatrix();
           
           g.pushMatrix();
             g.translate(500, 0);
             launchpadToggleOrPush.draw(g, mouse, isTranslated);
             launchpadToggleOrPush.locX = locX + 500;
             launchpadToggleOrPush.locY = locY;
             launchpadToggleOrPush.open = true;
             if(launchpadToggleOrPush.valueHasChanged()) {
               try {
                 if(launchpad != null) {
                   NumberBoxTableWindow LPTOP = launchpadToggleOrPush;
                   int x = LPTOP.changedValue()[0];
                   int y = LPTOP.changedValue()[1];
                   int val = LPTOP.getValue(x, y);
                   launchpad.setButtonMode(val, x, y);
                 }
               }
               catch (Exception e) {
                 e.printStackTrace();
               }
             }
            
           g.popMatrix();
           
           g.pushMatrix();
             g.translate(500, 0);
             launchPadColors.draw(g, mouse, isTranslated);
             launchPadColors.locX = launchPadMemories.locX+launchPadMemories.w;
             launchPadColors.locY = launchPadMemories.locY;
             launchPadColors.open = true;
             if(launchPadColors.valueHasChanged()) {
               try {
                 if(launchpad != null) {
                   NumberBoxTableWindow LPTOP = launchPadColors;
                   int x = LPTOP.changedValue()[0];
                   int y = LPTOP.changedValue()[1];
                   int val = LPTOP.getValue(x, y);
                   launchpad.setColorMode(val, x, y);
                 }
               }
               catch (Exception e) {
                 e.printStackTrace();
               }
             }
            
           g.popMatrix();
           
           
           
           
           
         } //End of launchpad settings
         
         else if(selectedMachine == 2) { //LC2412 fader and button settigns
             { //FaderModes
               LC2412faderModes.locX = locX+500;
               LC2412faderModes.locY = locY;
               LC2412faderModes.open = true;
               
               if(LC2412faderModes.valueHasChanged()) {
                 if(LC2412 != null) {
                   NumberBoxTableWindow LPM = LC2412faderModes;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setFaderModeValue(val, LC2412bank, x, y); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               }
             } //End of faderModes

             { //ButtonModes
               LC2412buttonModes.locX = locX+500;
               LC2412buttonModes.locY = locY+LC2412faderModes.h;
               LC2412buttonModes.open = true;
               
               if(LC2412buttonModes.valueHasChanged()) {
                 if(LC2412 != null) {
                   NumberBoxTableWindow LPM = LC2412buttonModes;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setButtonModeValue(val, LC2412bank, x, y); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               }
             } //End of buttonModes
             
             

             
             
             { //FaderMemories
               LC2412faderMemories.locX = locX+500+LC2412faderModes.w;
               LC2412faderMemories.locY = locY;
               LC2412faderMemories.open = true;
               
               if(LC2412faderMemories.valueHasChanged()) {
                 if(LC2412 != null) {
                   TextBoxTableWindow LPM = LC2412faderMemories;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setFaderMemoryValue(val, LC2412bank, x, y); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               }
             } //End of faderMemories

             { //ButtonMemories
               LC2412buttonMemories.locX = locX+500+LC2412buttonModes.w;
               LC2412buttonMemories.locY = locY+LC2412faderMemories.h;
               LC2412buttonMemories.open = true;
               
               if(LC2412buttonMemories.valueHasChanged()) {
                 if(LC2412 != null) {
                   TextBoxTableWindow LPM = LC2412buttonMemories;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setButtonMemoryValue(val, LC2412bank, x, y); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               }
             } //End of buttonMemories
             
             
             
            { //ChaseMemories
               LC2412chaseFaderMemories.locX = LC2412masterFaderMemories.locX+LC2412masterFaderMemories.w;
               LC2412chaseFaderMemories.locY = locY;
               LC2412chaseFaderMemories.open = true;
               
               if(LC2412chaseFaderMemories.valueHasChanged()) {
                 if(LC2412 != null) {
                   TextBoxTableWindow LPM = LC2412chaseFaderMemories;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setChaseFaderMemoryValue(val, x); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               } 
             } //End of chaseMemories
             
             { //MasterMemories
               LC2412masterFaderMemories.locX = LC2412buttonMemories.locX+LC2412buttonMemories.w;
               LC2412masterFaderMemories.locY = locY;
               LC2412masterFaderMemories.open = true;
               
               if(LC2412masterFaderMemories.valueHasChanged()) {
                 if(LC2412 != null) {
                   TextBoxTableWindow LPM = LC2412masterFaderMemories;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setMasterFaderMemoryValue(val, x); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               } 
             } //End of MasterMemories
             
             
             { //ChaseModes
               LC2412chaseFaderModes.locX = LC2412chaseFaderMemories.locX;
               LC2412chaseFaderModes.locY = LC2412chaseFaderMemories.locY+LC2412chaseFaderMemories.h;
               LC2412chaseFaderModes.open = true;
               
               if(LC2412chaseFaderModes.valueHasChanged()) {
                 if(LC2412 != null) {
                   NumberBoxTableWindow LPM = LC2412chaseFaderModes;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setChaseFaderModeValue(val, x); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               } 
             } //End of ChaseModes
             
             
             { //MasterModes
               LC2412masterFaderModes.locX = LC2412masterFaderMemories.locX;
               LC2412masterFaderModes.locY = LC2412masterFaderMemories.locY+LC2412masterFaderMemories.h;
               LC2412masterFaderModes.open = true;
               
               if(LC2412masterFaderModes.valueHasChanged()) {
                 if(LC2412 != null) {
                   NumberBoxTableWindow LPM = LC2412chaseFaderModes;
                   int x = LPM.changedValue()[0]; int y = LPM.changedValue()[1]; int val = LPM.getValue(x, y);
                   try { LC2412.setMasterFaderModeValue(val, x); }
                   catch (Exception e) { e.printStackTrace(); }
                 }
               } 
             } //End of MasterModes
             
             
             
             
             
             { //Bank
               g.pushMatrix(); g.pushStyle(); g.fill(0); g.textAlign(RIGHT);
                 g.translate(350, 150);
                 g.text("bankUp", -25, 13);
                 if(bankUp.isPressed(g, mouse)) { LC2412bank++; LC2412bankChanged = true; }
                 g.translate(0, 25);
                 g.text("bankDown", -25, 13);
                 if(bankDown.isPressed(g, mouse)) { LC2412bank--; LC2412bankChanged = true; }
                 g.translate(0, 25);
                 g.text("actual bank: " + str(LC2412bank), 25, 13);
                 g.text("LC2412 bank: " + str(LC2412.bank), 25, 13+20);
               g.popMatrix(); g.popStyle();
               
               if(LC2412bankChanged) {
                 LC2412bank = constrain(LC2412bank, 0, 9);
                 setLC2412valuesToControllers();
                 LC2412bankChanged = false;
               }
             } //End of bank
         } //End of LC2412 fader and button settings
       } //End of device specific settings
       
       g.translate(0, 200);
       
       { //Buttonmode for all machines
         { //Draw
           g.pushMatrix();
             g.translate(200, 0);
             if(selectedMachine != 1) { toggleOrPush.draw(g, mouse); }
    		     else { buttonModeForLaunchpad.draw(g, mouse); }
           g.popMatrix();
         } //Endof draw
         
         { //Check values
           if(selectedMachine != 1) if(toggleOrPush.valueHasChanged()) {
              switch(selectedMachine) {
                case 2: //LC2412
                break;
                
                case 3: //KerRig 49
                break;
              }
           }
            
           if(selectedMachine == 1) if(buttonModeForLaunchpad.valueHasChanged()) {
             if(launchpad != null) launchpad.setButtonModeToAll(buttonModeForLaunchpad.getValue()); launchpadToggleOrPush.setValue(buttonModeForLaunchpad.getValue());
           }
         } //End of checking values
       } //End of buttonmode for all machines
       
       { //OutputModes radioButtonMenu
         outputModes.draw(g, mouse);
         
         if(outputModes.valueHasChanged()) {
           switch(selectedMachine) {
             case 1: //Launchpad
               if(launchpad != null) launchpad.output = outputModes.getValue();
             break;
             
             case 2: //LC2412
             break;
             
             case 3: //KerRig 49
               if(keyRig49 != null) keyRig49.output = outputModes.getValue();
             break;
           }
         }
       } //End of outputModes radioButtonMenu
       
       { //Offset intController
         offset.draw(g, mouse);
         
         if(offset.valueHasChanged()) {
           switch(selectedMachine) {
             case 1: //Launchpad
               if(launchpad != null) launchpad.offset = offset.getValue();
             break;
             
             case 2: //LC2412
               if(LC2412 != null) LC2412.offset = offset.getValue();
             break;
               
             case 3: //KerRig 49
               if(keyRig49 != null) keyRig49.offset = offset.getValue();
             break;
           }
         }
       } //End of offset intController

     g.popMatrix();
     
     { //Save and load buttons
       g.pushMatrix();
         g.translate(200, 150);
         switch(selectedMachine) {
           case 1: //Launchpad
             if(launchpad != null) {
               if(save.isPressed(g, mouse)) saveLaunchpadData();
               g.pushMatrix(); g.translate(30, 0);
               if(load.isPressed(g, mouse)) loadLaunchpadData();
               g.popMatrix();
             }
           break;
           
           case 2: //LC2412
           break;
           
           case 3: //KeyRig 49
           break;
         }
       g.popMatrix();
     } //End of save and load buttons
     
     { //Draw machine select
       g.pushMatrix();
         g.translate(40, 60);
         machineSelect.draw(g, mouse);
       g.popMatrix();
     } //End of drawing machine select

   } //End of draw
   
   void setLC2412valuesToControllers() {
     LC2412faderModes.setValue(LC2412.faderMode[LC2412bank]);
     LC2412buttonModes.setValue(LC2412.buttonMode[LC2412bank]);
     LC2412faderMemories.setValue(LC2412.faderMemory[LC2412bank]);
     LC2412buttonMemories.setValue(LC2412.buttonMemory[LC2412bank]);
     LC2412chaseFaderMemories.setValue(LC2412.chaseFaderMemory);
     LC2412chaseFaderModes.setValue(LC2412.chaseFaderMode);
     LC2412masterFaderMemories.setValue(LC2412.masterFaderMemory);
     LC2412masterFaderModes.setValue(LC2412.masterFaderMode);
     
   }

 } //End of MidiHandlerWindow class
 
 
 class CheckBoxTableWindow {
   Window window;
   int locX, locY, w, h;
   boolean open;
   
   String name;
   
   CheckBox[][] boxes;
   
   CheckBoxTableWindow(String name, int x, int y) {
     boxes = new CheckBox[x][y];
     this.name = name;
     locX = 0;
     locY = 0;
     w = x*30+100;
     h = x*30+100;
     window = new Window("name", new PVector(w, h), this);
     
     for(int x_ = 0; x_ < boxes.length; x_++) {
       for(int y_ = 0; y_ < boxes.length; y_++) {
         boxes[x_][y_] = new CheckBox("");
       }
     }
   }
   
   int changedX, changedY;
   boolean valueChanged;
   
   void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
     window.draw(g, mouse);
     g.pushMatrix();
     g.translate(50, 50);
     for(int x = 0; x < boxes.length; x++) {
       for(int y = 0; y < boxes[x].length; y++) {
         g.pushMatrix();
           g.translate(x*25, y*25);
           boxes[x][y].draw(g, mouse, name+"box["+str(x)+"]["+str(y)+"]");
           if(boxes[x][y].valueHasChanged()) {
             changedX = x;
             changedY = y;
             valueChanged = true;
           }
         g.popMatrix();
       }
     }
     g.popMatrix();
   }
   
   boolean valueHasChanged() {
     boolean toReturn = valueChanged;
     valueChanged = false;
     return toReturn;
   }
   
   int[] changedValue() {
     int[] toReturn = new int[2];
     toReturn[0] = changedX;
     toReturn[1] = changedY;
     return toReturn;
   }
   
   boolean getValue(int x, int y) {
     return boxes[x][y].getValue();
   }
   
   void setValue(boolean val) {
     for(int x = 0; x < boxes.length; x++) {
       for(int y = 0; y < boxes[x].length; y++) {
         boxes[x][y].setValue(val);
       }
     }
   }
   
   void setValue(int x, int y, boolean val) {
     if(x < boxes.length) if(y < boxes[x].length) {
       boxes[x][y].setValue(val);
     }
   }
   
 } //End of class CheckBoxTableWindow
 
 
 class NumberBoxTableWindow {
   Window window;
   int locX, locY, w, h;
   boolean open;
   
   int min, max;
   
   String name;
   
   NumberBox[][] boxes;
   
   NumberBoxTableWindow(String name, int x, int y, int min, int max) {
     boxes = new NumberBox[x][y];
     this.name = name;
     this.min = min;
     this.max = max;
     locX = 0;
     locY = 0;
     w = x*21+100;
     h = y*21+100;
     window = new Window("name", new PVector(w, h), this);
     
     for(int x_ = 0; x_ < boxes.length; x_++) {
       for(int y_ = 0; y_ < boxes[x_].length; y_++) {
         boxes[x_][y_] = new NumberBox("", min, max);
       }
     }
   }
   
   int changedX, changedY;
   boolean valueChanged;
   
   void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
     window.draw(g, mouse);
     g.pushMatrix();
     g.translate(50, 50);
     for(int x = 0; x < boxes.length; x++) {
       for(int y = 0; y < boxes[x].length; y++) {
         g.pushMatrix();
           g.translate(x*21, y*21);
           boxes[x][y].draw(g, mouse, name+"box["+str(x)+"]["+str(y)+"]");
           if(boxes[x][y].valueHasChanged()) {
             changedX = x;
             changedY = y;
             valueChanged = true;
           }
         g.popMatrix();
       }
     }
     g.popMatrix();
   }
   
   boolean valueHasChanged() {
     boolean toReturn = valueChanged;
     valueChanged = false;
     return toReturn;
   }
   
   int[] changedValue() {
     int[] toReturn = new int[2];
     toReturn[0] = changedX;
     toReturn[1] = changedY;
     return toReturn;
   }
   
   int getValue(int x, int y) {
     return boxes[x][y].getValue();
   }
   
   void setValue(int val) {
     for(int x = 0; x < boxes.length; x++) {
       for(int y = 0; y < boxes[x].length; y++) {
         boxes[x][y].setValue(val);
       }
     }
   }
   
   void setValue(int[][] val) {
     for(int x = 0; x < val.length; x++) {
       for(int y = 0; y < val[x].length; y++) {
         setValue(x, y, val[x][y]);
       }
     }
   }
   
   void setValue(int[] val) {
    for(int i = 0; i < val.length; i++) {
      setValue(i, 0, val[i]);
    }
   }
   
   void setValue(int x, int y, int val) {
     if(x < boxes.length) if(y < boxes[x].length) {
       boxes[x][y].setValue(val);
     }
   }
   
 } //End of class NumberBoxTableWindow


 void createMidiClasses() {
   launchpad = new Launchpad();
   LC2412 = new behringerLC2412();
   inputClass = new Input();
   keyRig49 = new Keyrig49();
 } //End of void createMidiClasses()
 
 boolean loadingMidiData = false;
 void loadMidiData() {
   loadingMidiData = true;
   loadLaunchpadData();
   loadBehringerLC2412data();
   loadingMidiData = false;
 }
 
 boolean savingMidiData = false;
 void saveMidiData() {
   savingMidiData = true;
   saveLaunchpadData();
   saveBehringerLC2412data();
   savingMidiData = false;
 }

 void loadLaunchpadData() {
   if(launchpad != null) {
     launchpad.loadFromXML();
     midiWindow.launchPadMemories.setValue(launchpad.toggleMemory);
     midiWindow.launchpadToggleOrPush.setValue(launchpad.buttonMode); //Set values to buttonModes
   }
 }
 
 void saveLaunchpadData() {
   if(launchpad != null) {
    launchpad.saveToXML();
   }
 }
 
 void saveBehringerLC2412data() {
   if(LC2412 != null) LC2412.saveToXML();
 }
 
 
 void loadBehringerLC2412data() {
   if(LC2412 != null) LC2412.loadFromXML();
 }


Launchpad launchpad;

final int OUTPUT_TO_FIXTURES = 1;
final int OUTPUT_TO_DMX = 2;
final int OUTPUT_TO_MEMORIES = 3;


public class Keyrig49 {
  
  final boolean[] OCTAVE = {true, false, true, false, true, true, false, true, false, true, false, true};
  final int PIANO_OCTAVE_PATTERN_OFFSET = 0;
  
 
  MidiBus bus;
  
  boolean[] useToggle;
  boolean[] keys;
  boolean[] keysOld;
  int[] keysVal;
  int[] keysValOld;
  
  int output = OUTPUT_TO_FIXTURES;
  
  int inputIndex;
  
  int offset;
  
  Keyrig49() {
    setup();
  }
  
  Keyrig49(int inputIndex) {
    setup(inputIndex);
  }
  
  void setup(int inputIndex) {
    if(bus != null) { bus.clearAll(); }
    this.inputIndex = inputIndex;
    if(bus != null) { bus.addInput(inputIndex); }
    else { bus = new MidiBus(this, inputIndex, 0); }
    setup();
  }
  
  void setup() {
    keys = new boolean[49];
    keysOld = new boolean[49];
    useToggle = new boolean[49];
    keysVal = new int[49];
    keysValOld = new int[49];
    
  }
  
  void noteOn(int channel, int pitch, int velocity) {
      int whiteI = 0;
      for(int k = 0; k < pitch; k++) {
         if(OCTAVE[(k + PIANO_OCTAVE_PATTERN_OFFSET) % OCTAVE.length]) whiteI++;
      }
      if(velocity > 10) velocity = 127;
      keys[constrain(whiteI, 0, keys.length-1)] = midiToBoolean(velocity);
      keysVal[constrain(whiteI, 0, keys.length-1)] = midiToDMX(velocity);
      if(output == 1) {
        setMemoryValueByOrderInVisualisation(whiteI+offset, midiToDMX(velocity));
      }
      else if(output == 2) {
        fixtures.get(constrain(whiteI+offset, 0, fixtures.size()-1)).in.setUniversalDMX(DMX_DIMMER, midiToDMX(velocity));
      }
    
  }
  void noteOff(int channel, int pitch, int velocity) {
    noteOn(channel, pitch, velocity);
  }
  
  void controllerChange(int channel, int number, int value) {
    fixtureOwnFade = value*5;
  }
  
}

public class Launchpad {
  final int LEARN = 0;
  final int VIEW = 1;
  final int PAGEDOWN = 2;
  final int PAGEUP = 3;
  final int SESSION = 4;
  final int USER1 = 5;
  final int USER2 = 6;
  final int MIXER = 7;
  
  boolean[][] pads;
  boolean[][] padsToggle;
  
  boolean[] upperPads;
  boolean[] upperPadsToggle;
  
  int[] mapping;
  int output;
  
  int[][] buttonMode;
  
  int[][] toggleMemory;
  
  int[][] padsColor;
  
  MidiBus bus;
  
  int inputIndex;
  int outputIndex;
  
  String inputName, outputName;
  
  int offset;
  
  Launchpad() {
    setup();
  }
  
  Launchpad(int inputIndex, int outputIndex) {
    setup(inputIndex, outputIndex);
  }
  
  void setup(int inputIndex, int outputIndex) {
    
    this.inputName = MidiBus.availableInputs()[inputIndex];
    this.outputName = MidiBus.availableOutputs()[outputIndex];
    
    if(bus != null) { bus.clearAll(); }
    this.inputIndex = inputIndex;
    this.outputIndex = outputIndex;
    if(bus != null) { bus.addInput(inputIndex); bus.addOutput(outputIndex); }
    else { bus = new MidiBus(this, inputIndex, outputIndex); }
    
    clearLeds();
    
    setup();
    output = 1;

    
  }
  
    
  void setup(String input, String output) {
    int inputI = -1;
    int outputI = -1;
    boolean inputFound = false;
    boolean outputFound = false;
     for(int i = 0; i < MidiBus.availableInputs().length; i++) {
       if(MidiBus.availableInputs()[i].equals(input)) {
         inputI = i;
         inputFound = true;
       }
     }
     
     for(int i = 0; i < MidiBus.availableOutputs().length; i++) {
       if(MidiBus.availableOutputs()[i].equals(output)) {
         outputI = i;
         outputFound = true;
       }
     }
     
     if(inputFound && outputFound) {
       setup(inputI, outputI);
     }
  }
  
  void setup() {
    if(pads == null) pads = new boolean[9][8];
    if(padsToggle == null) padsToggle = new boolean[9][8];
    if(upperPads == null) upperPads = new boolean[8];
    if(upperPadsToggle == null) upperPadsToggle = new boolean[8];
    
    if(toggleMemory == null) toggleMemory = new int[9][8];
    
    if(buttonMode == null) buttonMode = new int[9][8];
    if(toggleMemory == null) toggleMemory = new int[9][8];
    
    if(padsColor == null) padsColor = new int[8][8];
  }
  
  void setButtonModeToAll(int mode) {
    for(int x = 0; x < 8; x++) {
      for(int y = 0; y < 8; y++) {
        buttonMode[x][y] = mode;
      }
    }
  }
  
  
  void sendNoteOff(int pitch) {
	int value = 0;
	try { sendNoteOn(0, pitch, byte(value) * 127); }
        catch (Exception e) {}
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    int x = constrain(pitch%16, 0, pads.length-1), y = constrain(pitch/16, 0, pads[0].length-1);
    boolean val = midiToBoolean(velocity);
    pads[x][y] = val;
    if(val) padsToggle[x][y] = !padsToggle[x][y];
    
    boolean value = false;
    if(x < 8) {
      if(buttonMode[x][y] != 3 && !upperPads[0]) {
          if(buttonMode[x][y] == 1) { //Togglemode
            value = padsToggle[x][y];
          }
          else {
            value = pads[x][y];
          }
          
         // if(output == 1) { setMemoryEnabledByOrderInVisualisation(x+8*y+1+offset, value); }
         // else if(output == 2) { fixtures.get(constrain(x+8*y+offset, 0, fixtures.size()-1)).in.setUniversalDMX(DMX_DIMMER, value ? 255 : 0); }
          
          
          if(output == 1) {
      		if(buttonMode[x][y] != 2 && buttonMode[x][y] != 4) {
      			memories[toggleMemory[x][y]].enabled = value;
      			memories[toggleMemory[x][y]].doOnce = false;
      		}
      		else if(value == true && buttonMode[x][y] == 2) {
      			memories[toggleMemory[x][y]].enabled = true;
      			memories[toggleMemory[x][y]].doOnce = true;
      			memories[toggleMemory[x][y]].triggerButton = pitch;
      		}
                  else if(value && buttonMode[x][y] == 4) {
                          memories[toggleMemory[x][y]].trig();
                  }
      	}
          else if(output == 2) { fixtures.get(constrain(toggleMemory[x][y], 0, fixtures.size()-1)).in.setUniversalDMX(DMX_DIMMER, value ? 255 : 0); }
          
      }
      else if(buttonMode[x][y] == 3 && pads[x][y]) {
        
        value = true;
      }
      if(upperPads[0] && val) {
        memories[toggleMemory[x][y]].trig();
      }
       if(!upperPads[0] && (buttonMode[x][y] != 2 || value)) sendNoteOn(0, pitch, byte(value) * 127);
      }
     
    else if(val) {
      if(pitch == 7*16+8) {
        tapTempo.register();
        for(int i = 0; i < 8; i++) {
          int v = 0; 
          if(tapTempo.getSize()-tapTempo.getActualStep() > i && !tapTempo.enable) {
            v = 1;
          }
          else {
            v = 0;
          }
          bus.sendNoteOn(0, i*16+8, byte(v) * 50);
        }
      }
      else if(pitch == 6*16+8) {
        tapTempo.play = !tapTempo.play;
      }
      println(pitch);
    }
  }
  
  void setRightButton(int i, byte v) {
    bus.sendNoteOn(0, i*16+8, v);
  }
  
  void noteOff(int channel, int pitch, int velocity) {
    noteOn(channel, pitch, 0);
  }
  
  void clearLeds() {
    for(int x = 0; x < 8; x++) {
      for(int y = 0; y < 8; y++) {
        bus.sendNoteOn(0, y*16+x, byte(0));
        bus.sendControllerChange(0, y*16+x, byte(0));
      }
    }
  }
  
  int[][] actualValueToSend = new int[9][8];
  
  void sendNoteOn(int channel, int pitch, int value) {
    int v = value;
    int x = constrain(pitch%16, 0, pads.length-1), y = constrain(pitch/16, 0, pads[0].length-1);
    if(value == 0) {
      sendDefaultZeroToButton(x, y);
    }
    else {
      sendDefaultFullToButton(x, y);
    }
    actualValueToSend[x][y] = v;
    
  }

  
  void controllerChange(int channel, int number, int value) {
    boolean val = midiToBoolean(value);
    int x = constrain(number-104, 0, upperPads.length-1);
    upperPads[x] = val;
    if(val) upperPadsToggle[x] = !upperPadsToggle[x];
    bus.sendControllerChange(0, number, byte(value) * 127);
  }
  
  
  
  
  void saveToXML() {
    saveXML(getXML(), "XML/launchpad.xml");
  }
  
  void loadFromXML() {
    XMLtoObject(loadXML("XML/launchpad.xml"));
  }
  
  XML getXML() {
    
    String data = "<launchpad></launchpad>";
    XML xml = parseXML(data);
    xml.addChild(array2DToXML("toggleMemory", toggleMemory));
    xml.addChild(array2DToXML("buttonMode", buttonMode));
    xml.addChild(array2DToXML("padsColor", padsColor));
    
    XML midiData = xml.addChild("midiData");
    midiData.setString("inputName", inputName);
    midiData.setString("outputName", outputName);
    
    return xml;
  }
  
  void XMLtoObject(XML xml) {
    
    try {
      int[][] fromXML = new int[9][8];
      arrayCopy(XMLtoIntArray2D("toggleMemory", xml), fromXML);
      
  
      for(int x = 0; x < fromXML.length; x++) {
        for(int y = 0; y < fromXML[x].length; y++) {
          toggleMemory[x][y] = fromXML[x][y];
        }
      }
  	
  	fromXML = new int[9][8];
      arrayCopy(XMLtoIntArray2D("buttonMode", xml), fromXML);
  	
  	for(int x = 0; x < fromXML.length; x++) {
        for(int y = 0; y < fromXML[x].length; y++) {
          setButtonMode(fromXML[x][y], x, y);
        }
      }
      
      try {
      
          fromXML = new int[8][8];
          arrayCopy(XMLtoIntArray2D("padsColor", xml), fromXML);
        padsColor = new int[8][8];
        for(int x = 0; x < fromXML.length; x++) {
            if(x < padsColor.length) for(int y = 0; y < fromXML[x].length; y++) {
              if(y < padsColor[x].length) padsColor[x][y] = fromXML[x][y];
            }
          }
          
      }
      catch(Exception e) {
        e.printStackTrace();
      }
      
    {
      try {
        XML midiData = xml.getChild("midiData");
        setup(midiData.getString("inputName"), midiData.getString("outputName"));
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
      
      midiWindow.launchPadMemories.setValue(launchpad.toggleMemory);
      midiWindow.launchpadToggleOrPush.setValue(launchpad.buttonMode); //Set values to buttonModes
      midiWindow.launchPadColors.setValue(launchpad.padsColor);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  void setButtonMode(int val, int x, int y) {
    buttonMode[x][y] = val;
    try { sendDefaultZeroToButton(x, y); } catch (Exception e) { e.printStackTrace(); }
  }
  
  void setColorMode(int val, int x, int y) {
    if(x >= 0 && x < padsColor.length) if(y >= 0 && y < padsColor[x].length) padsColor[x][y] = val;
    if(actualValueToSend[x][y] == 0) {
      sendDefaultZeroToButton(x, y);
    }
    else {
      sendDefaultFullToButton(x, y);
    }
  }
  
  int[][] buttonModeSentOld = new int[9][8];
  int[][] lastSent = new int[9][8];
  
  void draw() {
    for(int x = 0; x < 9; x++) for(int y = 0; y < 8; y++) {
      if(buttonModeSentOld[x][y] != (buttonMode[x][y])*(int(toggleMemory[x][y] == 0)*(-1)) || frameCount > lastSent[x][y]+100) {
        lastSent[x][y] = frameCount;
        buttonModeSentOld[x][y] = (buttonMode[x][y])*(int(toggleMemory[x][y] == 0)*(-1));
        if(actualValueToSend[x][y] == 0) sendDefaultZeroToButton(x, y);
        else sendDefaultFullToButton(x, y);
      }
    }
  }
  
  /*
  
   0Ch 12 Off     Off
   0Dh 13 Red     Low
   0Fh 15 Red     Full
   1Dh 29 Amber   Low
   3Fh 63 Amber   Full
   3Eh 62 Yellow  Full
   1Ch 28 Green   Low
   3Ch 60 Green   Full 
  
  */
  
  int[][] colors = {
    { 13, 15 },
    { 29, 63 },
    { 28, 60 }
  };
  
  void sendDefaultZeroToButton(int x, int y) {
    int v = 12;
    if(toggleMemory[x][y] > 0) {
      if(padsColor[x][y] == 0) {
        switch(buttonMode[x][y]) {
          case 0: v = colors[0][0]; break;
          default: v = colors[1][0]; break;
        }
      }
      else {
        switch(padsColor[x][y]) {
          case 1: v = colors[0][0]; break;
          case 2: v = colors[1][0]; break;
          case 3: v = colors[2][0]; break;
        }
      }
    }
    if(bus != null) bus.sendNoteOn(0, y*16+x, byte(v));
  }
  
  void sendDefaultFullToButton(int x, int y) {
    int v = 12;
    if(toggleMemory[x][y] > 0) {
      if(padsColor[x][y] == 0) {
        switch(buttonMode[x][y]) {
          case 0: v = colors[0][1]; break;
          default: v = colors[1][1]; break;
        }
      }
      else {
        switch(padsColor[x][y]) {
          case 1: v = colors[0][1]; break;
          case 2: v = colors[1][1]; break;
          case 3: v = colors[2][1]; break;
        }
      }
    }
    if(bus != null) bus.sendNoteOn(0, y*16+x, byte(v));
  }
  
  void setToggleToMemoryValue(int val, int x, int y) {
    if(x < toggleMemory.length) {
      if(y < toggleMemory[x].length) {
        toggleMemory[x][y] = val;
      }
      else {
        println("toggleMemory[" + str(x) + "].length: " + toggleMemory[x].length);
      }
    }
    else {
      println("toggleMemory.length: " + toggleMemory.length);
    }
    
    println(toggleMemory[0][0]);
  }


}


public class behringerLC2412 {
  int[][] faderValue; //[row][number]
  int[][] faderValueOld; //[row][number]
  boolean[] buttons; //[number]
  boolean[] buttonsOld; //[number]
  boolean[] buttonsToggle;
  boolean[] buttonsToggleOld;
  int masterAvalue, masterBvalue, masterValue;
  int[] masterValues = new int[3];
  int[] masterValuesOld = new int[3];
  int[] chaserValues = new int[3];
  int[] chaserValuesOld = new int[3];
  int speedValue, xFadeValue, chaserValue;
  int bank;
  int chaserNumber;
  boolean stepKey, channelFlashKey, soloKey, special1Key, special2Key, manualKey, chaserModeKey, insertKey, presetFlashKey, memoryFlashKey;
  boolean insertToggle, presetFlashToggle, memoryFlashToggle;
  
  int[] output = { OUTPUT_TO_MEMORIES, OUTPUT_TO_MEMORIES };

  int[][][] faderMode;
  int[][] buttonMode;
  
  int[][][] faderMemory;
  int[][] buttonMemory;
  
  int[] chaseFaderMemory;
  int[] chaseFaderMode;
  int[] masterFaderMemory;
  int[] masterFaderMode;
  
  int inputIndex;
  int outputIndex;
  
  String inputName;
  String outputName;
  
  int offset;
  
  behringerLC2412() {
    setup();
  }

  
  behringerLC2412(int inputIndex, int outputIndex) {
    setup(inputIndex, outputIndex);
  }
  
  MidiBus bus;
  void setup(int inputIndex, int outputIndex) {
    //Midi start commands
    this.inputName = MidiBus.availableInputs()[inputIndex];
    this.outputName = MidiBus.availableOutputs()[outputIndex];
    if(bus != null) { bus.clearAll(); }
    this.inputIndex = inputIndex;
    this.outputIndex = outputIndex;
    if(bus != null) { bus.addInput(inputIndex); bus.addOutput(outputIndex); }
    else { bus = new MidiBus(this, inputIndex, outputIndex); }
    
    setup();
  }
  
  void setup(String input, String output) {
    int inputI = -1;
    int outputI = -1;
    boolean inputFound = false;
    boolean outputFound = false;
     for(int i = 0; i < MidiBus.availableInputs().length; i++) {
       if(MidiBus.availableInputs()[i].equals(input)) {
         inputI = i;
         inputFound = true;
       }
     }
     
     for(int i = 0; i < MidiBus.availableOutputs().length; i++) {
       if(MidiBus.availableOutputs()[i].equals(output)) {
         outputI = i;
         outputFound = true;
       }
     }
     
     if(inputFound && outputFound) {
       setup(inputI, outputI);
     }
  }
  
  
  void setup() {
    if(faderValue == null) faderValue = new int[2][12];
    if(faderValueOld == null) faderValueOld = new int[2][12];
    if(buttons == null) buttons = new boolean[12];
    if(buttonsOld == null) buttonsOld = new boolean[12];
    if(buttonsToggle == null) buttonsToggle = new boolean[12];
    if(buttonsToggleOld == null) buttonsToggleOld = new boolean[12];
    
    if(faderMode == null) faderMode = new int[10][12][2];
    if(buttonMode == null) buttonMode = new int[10][12];
    if(faderMemory == null) faderMemory = new int[10][12][2];
    if(buttonMemory == null) buttonMemory = new int[10][12];
    
    if(chaseFaderMemory == null) chaseFaderMemory = new int[3];
    if(chaseFaderMode == null) chaseFaderMode = new int[3];
    if(masterFaderMemory == null) masterFaderMemory = new int[3];
    if(masterFaderMode == null) masterFaderMode = new int[3];

  }
  
  
  
  
  void saveToXML() {
    saveXML(getXML(), "XML/LC2412.xml");
  }
  
  XML getXML() {
    
    String data = "<LC2412></LC2412>";
    XML xml = parseXML(data);
    xml.addChild(array3DToXML("faderMode", faderMode));
    xml.addChild(array2DToXML("buttonMode", buttonMode));
    
    xml.addChild(array3DToXML("faderMemory", faderMemory));
    xml.addChild(array2DToXML("buttonMemory", buttonMemory));
    
    xml.addChild(arrayToXML("masterFaderMemory", masterFaderMemory));
    xml.addChild(arrayToXML("masterFaderMode", masterFaderMode));
    
    xml.addChild(arrayToXML("chaseFaderMemory", chaseFaderMemory));
    xml.addChild(arrayToXML("chaseFaderMode", chaseFaderMode));
    
    XML midiData = xml.addChild("midiData");
    midiData.setString("inputName", inputName);
    midiData.setString("outputName", outputName);
    return xml;
  }
  
  
  void loadFromXML() {
    XMLtoObject(loadXML("XML/LC2412.xml"));
  }
  
  void XMLtoObject(XML xml) {

    
    
    { //buttonMode
      int[][] fromXML = XMLtoIntArray2D("buttonMode", xml);
      
      for(int x = 0; x < fromXML.length; x++) {
          for(int y = 0; y < fromXML[x].length; y++) {
            buttonMode[x][y] = fromXML[x][y];
          }
        }
    } //end of buttonMode
    
    { //faderMode
       int[][][] fromXML = XMLtoIntArray3D("faderMode", xml);
      
      
      for(int z = 0; z < fromXML.length; z++) {
        if(z < faderMode.length) for(int x = 0; x < fromXML[z].length; x++) {
          if(x < faderMode[z].length) for(int y = 0; y < fromXML[z][x].length; y++) {
            if(y < faderMode[z][x].length) faderMode[z][x][y] = fromXML[z][x][y];
          } //End of y loop
        } //End of x loop
      } //End of z loop
    } //end of faderMode
    
    { //buttonMemory
      int[][] fromXML = XMLtoIntArray2D("buttonMemory", xml);
      
      for(int x = 0; x < fromXML.length; x++) {
          for(int y = 0; y < fromXML[x].length; y++) {
            buttonMemory[x][y] = fromXML[x][y];
          }
        }
    } //end of buttonMemory
    
    { //faderMemory
       int[][][] fromXML = XMLtoIntArray3D("faderMemory", xml);
      
      
      for(int z = 0; z < fromXML.length; z++) {
        if(z < faderMemory.length) for(int x = 0; x < fromXML[z].length; x++) {
          if(x < faderMemory[z].length) for(int y = 0; y < fromXML[z][x].length; y++) {
            if(y < faderMemory[z][x].length) faderMemory[z][x][y] = fromXML[z][x][y];
          } //End of y loop
        } //End of x loop
      } //End of z loop
    } //end of faderMemory


    { //masterFaderMemory
      int[] fromXML = XMLtoIntArray("masterFaderMemory", xml);
      for(int x = 0; x < fromXML.length; x++) {
        if(x < masterFaderMemory.length) masterFaderMemory[x] = fromXML[x];
      }
    } //end of masterFaderMemory
    
    { //masterFaderMode
      int[] fromXML = XMLtoIntArray("masterFaderMode", xml);
      for(int x = 0; x < fromXML.length; x++) {
        if(x < masterFaderMode.length) masterFaderMode[x] = fromXML[x];
      }
    } //end of masterFaderMode
    
    { //chaseFaderMemory
      int[] fromXML = XMLtoIntArray("chaseFaderMemory", xml);
      for(int x = 0; x < fromXML.length; x++) {
        if(x < chaseFaderMemory.length) chaseFaderMemory[x] = fromXML[x];
      }
    } //end of chaseFaderMemory
    
    { //chaseFaderMode
      int[] fromXML = XMLtoIntArray("chaseFaderMode", xml);
      for(int x = 0; x < fromXML.length; x++) {
        if(x < chaseFaderMode.length) chaseFaderMode[x] = fromXML[x];
      }
    } //end of chaseFaderMode
    
    {
      try {
        XML midiData = xml.getChild("midiData");
        setup(midiData.getString("inputName"), midiData.getString("outputName"));
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
    
    midiWindow.setLC2412valuesToControllers();

  }


  void setFaderModeValue(int val, int b, int x, int y) {
    if(b >= 0 && bank < faderMode.length) if(x >= 0 && x < faderMode[b].length) if(y >= 0 && y < faderMode[b][x].length) faderMode[b][x][y] = val;
  }
  
  void setFaderMemoryValue(int val, int b, int x, int y) {
    if(b >= 0 && bank < faderMemory.length) if(x >= 0 && x < faderMemory[b].length) if(y >= 0 && y < faderMemory[b][x].length) faderMemory[b][x][y] = val;
  }
  
  void setButtonModeValue(int val, int b, int x, int y) {
    if(b >= 0 && bank < buttonMode.length) if(x >= 0 && x < buttonMode[b].length) buttonMode[b][x] = val;
  }
  
  void setButtonMemoryValue(int val, int b, int x, int y) {
    if(b >= 0 && bank < buttonMemory.length) if(x >= 0 && x < buttonMemory[b].length) buttonMemory[b][x] = val;
  }
  
  void setChaseFaderMemoryValue(int val, int x) {
    if(x >= 0 && x < chaseFaderMemory.length) chaseFaderMode[x] = val;
  }
  
  void setMasterFaderMemoryValue(int val, int x) {
    if(x >= 0 && x < masterFaderMemory.length) masterFaderMemory[x] = val;
  }
  
  void setChaseFaderModeValue(int val, int x) {
    if(x >= 0 && x < chaseFaderMode.length) chaseFaderMode[x] = val;
  }
  
  void setMasterFaderModeValue(int val, int x) {
    if(x >= 0 && x < masterFaderMode.length) masterFaderMode[x] = val;
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    if(pitch != 10) { //One slider is crashed
      midiMessageIn(pitch, velocity);
      println(str(pitch) + " : " + str(velocity));
    }
  }
  void noteOff(int channel, int pitch, int velocity) {
    midiMessageIn(pitch, velocity);
  }
  void controllerChange(int channel, int pitch, int velocity) {
    noteOn(channel, pitch, velocity);
  }
  
  void midiMessageIn(int num, int val) {
    if(isBetween(num, 0, 11)) {
      faderValue[0][num] = midiToDMX(val);
      faderValueChange(midiToDMX(val), num, 0);
    }
    else if(isBetween(num, 12, 23)) {
      faderValue[1][num-12] = midiToDMX(val);
      faderValueChange(midiToDMX(val), num-12, 1);
    }
    else if(isBetween(num, 31, 42)) {
      buttons[constrain(num-31, 0, buttons.length-1)] = midiToBoolean(val);
      if(buttons[constrain(num-31, 0, buttons.length-1)]) { buttonsToggle[constrain(num-31, 0, buttons.length-1)] = !buttonsToggle[constrain(num-31, 0, buttons.length-1)]; }
      buttonValueChange(midiToBoolean(val), num-31);
    }
    else {
      switch(num) {
        case 24: chaserValues[0] = midiToDMX(val); chaseFaderValueChange(chaserValues[0], 2); break; //Speed
        case 25: chaserValues[1] = midiToDMX(val); chaseFaderValueChange(chaserValues[1], 1); break; //X-fade
        case 26: chaserValues[2] = midiToDMX(val); chaseFaderValueChange(chaserValues[2], 0); break; //Chase
        case 27: masterValues[0] = midiToDMX(val); masterFaderValueChange(masterValues[0], 2); break; //Main
        case 28: masterValues[1] = midiToDMX(val); masterFaderValueChange(masterValues[1], 0); break; //Main A
        case 29: masterValues[2] = midiToDMX(val); masterFaderValueChange(masterValues[2], 1); break; //Main B
        case 30: stepKey = midiToBoolean(val); tapTempo.register(); break;
        case 43: bank = val; break;
        case 44: chaserNumber = val; break;
        case 45: channelFlashKey = midiToBoolean(val); break;
        case 46: soloKey = midiToBoolean(val); break;
        case 47: special1Key = midiToBoolean(val); break;
        case 48: special2Key = midiToBoolean(val); break;
        case 49: manualKey = midiToBoolean(val); break;
        case 50: chaserModeKey = midiToBoolean(val); break;
        case 51: insertKey = midiToBoolean(val); if(insertKey) { insertToggle = !insertToggle; } memories[chaserNumber].savePreset(new boolean[] { true }); break;
        case 52: presetFlashKey = midiToBoolean(val); if(presetFlashKey) { presetFlashToggle = !presetFlashToggle; } break;
        case 53: memoryFlashKey = midiToBoolean(val); if(memoryFlashKey) { memoryFlashToggle = !memoryFlashToggle; } break;
      }
    }
  }
  
  
  void chaseFaderValueChange(int val, int x) {
    int mode = chaseFaderMode[x];
    int mem = chaseFaderMemory[x];
    if(mode == 0) {
      if(mem >= 0 && mem < memories.length) memories[mem].setValue(val);
    }
    else if(mode == 1) {
      if(mem >= 0 && mem < memories.length) memories[mem].setFade(val);
    }
  }
  
  void masterFaderValueChange(int val, int x) {
    int mode = masterFaderMode[x];
    int mem = masterFaderMemory[x];
    if(mode == 0) {
      if(mem >= 0 && mem < memories.length) memories[mem].setValue(val);
    }
    else if(mode == 1) {
      if(mem >= 0 && mem < memories.length) memories[mem].setFade(val);
    }
  }
  

  void faderValueChange(int val, int x, int y) {
    
    if(output[y] == OUTPUT_TO_FIXTURES) {
      fixtures.get(x).in.setUniversalDMX(1, val);
    }
    else if(output[y] == OUTPUT_TO_MEMORIES) {
      int mode = faderMode[bank][x][y];
      int mem = faderMemory[bank][x][y];
      if(mode == 0) {
        if(mem >= 0 && mem < memories.length) memories[mem].setValue(val);
      }
      else if(mode == 1) {
        if(mem >= 0 && mem < memories.length) memories[mem].setFade(val);
      }
    }
  }
  
  void buttonValueChange(boolean val, int num) {
    if(true) { //if output to memories
      int mode = buttonMode[bank][num];
      int mem = buttonMemory[bank][num];
      
      
      boolean value;
      if(buttonMode[bank][num] == 1) { //Togglemode
        value = buttonsToggle[num];
      }
      else {
        value = buttons[num];
      }
      
      if(buttonMode[bank][num] != 2) {
  			memories[buttonMemory[bank][num]].enabled = value;
        memories[buttonMemory[bank][num]].doOnce = false;
  		}
  		else if(value == true) {
        memories[buttonMemory[bank][num]].enabled = true;
        memories[buttonMemory[bank][num]].doOnce = true;
  		}
      
    } //End of if output to memories
  }
  
  
  void processValues() {
    if(masterValues[0] != masterValuesOld[0]) {
      changeGrandMasterValue(masterValues[0]);
      masterValuesOld[0] = masterValues[0];
    }
  }
}

class Input {
  Input() {
  }
  
  void draw() {
    //processBehringerLC2412();
    
  }
  
  void processBehringerLC2412() {
    if(LC2412 != null) {
      processBehringerLC2412master();
      processBehringerLC2412faders();
    }
    if(keyRig49 != null) processKeyrig49Keys();
      
    
  }
  void processBehringerLC2412master() {
    if(LC2412.masterValues[0] != LC2412.masterValuesOld[0]) {
      changeGrandMasterValue(LC2412.masterValues[0]);
      LC2412.masterValuesOld[0] = LC2412.masterValues[0];
    }
  }
  void processBehringerLC2412faders() {
    for(int i = 0; i <= 11; i++) {
      for(int j = 0; j <= 1; j++) {
        if(setValueToOutput(i, LC2412.output[j], LC2412.bank*12, LC2412.faderValue[j], LC2412.faderValueOld[j])) {
          LC2412.faderValueOld[j][i] = LC2412.faderValue[j][i];
        }
      }
      int buttonOutput = 0;
      if(LC2412.channelFlashKey) { buttonOutput = OUTPUT_TO_FIXTURES; } else { buttonOutput = OUTPUT_TO_MEMORIES; }
      if(LC2412.presetFlashToggle) {
        if(setValueToOutputFromBoolean(i, buttonOutput, LC2412.bank*12, LC2412.buttons, LC2412.buttonsOld)) {
            LC2412.buttonsOld[i] = LC2412.buttons[i];
        }
      }
      else {
        if(setValueToOutputFromBoolean(i, buttonOutput, LC2412.bank*12, LC2412.buttonsToggle, LC2412.buttonsToggleOld)) {
            LC2412.buttonsToggleOld[i] = LC2412.buttonsToggle[i];
        }
      }
    }
    
    for(int i = 0; i <= 2; i++) {
      if(LC2412.chaserValues[i] != LC2412.chaserValuesOld[i]) {
        switch(i) {
          case 0: break;
          case 1: changeCrossFadeValue(LC2412.chaserValues[i]); break;
          case 2: break;
        }
        LC2412.chaserValuesOld[i] = LC2412.chaserValues[i];
      }
    }
    
  }
  
  void processKeyrig49Keys() {
    for(int i = 0; i < 49; i++) {
      if(setValueToOutput(i, keyRig49.output, 0, keyRig49.keysVal, keyRig49.keysValOld)) {
        keyRig49.keysValOld[i] = keyRig49.keysVal[i];
      }
    }
  }
  
  boolean setValueToOutput(int number, int output, int offset, int[] data, int[] dataOld) {
    int n = number+offset;
    if(isBetween(number, 0, min(data.length-1, dataOld.length-1))) {
      if(data[number] != dataOld[number]) {
        if(output == OUTPUT_TO_FIXTURES) {
          if(n < fixtures.size()) {
            fixtures.get(n).in.setUniversalDMX(DMX_DIMMER, data[number]);
            fixtures.get(n).DMXChanged = true;
            
          }
        }
        else if(output == OUTPUT_TO_DMX) {
          //Put value to dmx
        }
        else if(output == OUTPUT_TO_MEMORIES) {
          if(n < memories.length) {
            memories[n].setValue(data[number]);
          }
        }
        return true;
      }
    }
    return false;
  }
  
  boolean setValueToOutputFromBoolean(int number, int output, int offset, boolean[] data, boolean[] dataOld) {
    int n = number+offset;
    if(isBetween(number, 0, min(data.length-1, dataOld.length-1))) {
      if(data[number] != dataOld[number]) {
        if(output == OUTPUT_TO_FIXTURES) {
          if(n < fixtures.size()) {
            fixtures.get(n).setUniversalDMXwithFade(DMX_DIMMER, data[number] ? 255 : 0, 10, 100);
            //fixtures.get(n).in.setUniversalDMX(DMX_DIMMER, data[number] ? 255 : 0);
            fixtures.get(n).DMXChanged = true;
            
          }
        }
        else if(output == OUTPUT_TO_DMX) {
          //Put value to dmx
        }
        else if(output == OUTPUT_TO_MEMORIES) {
          if(n < memories.length) {
            memories[n].setValue(data[number] ? 255 : 0);
          }
        }
        return true;
      }
    }
    return false;
  }

} //End of class Input

boolean midiToBoolean(int val) {
  return val > 63;
}
int midiToDMX(int val) {
  return rMap(val, 0, 127, 0, 255);
}
