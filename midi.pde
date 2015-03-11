 


 LaunchpadData launchpadData;
 behringerLC2412 LC2412;
 Input inputClass;
 Keyrig49 keyRig49;
 
 MidiHandlerWindow midiWindow = new MidiHandlerWindow();
 
 class MidiHandlerWindow {
   int locX, locY, w, h;
   boolean open;
   
   int selectedMachine;
   
   Window window;
   DropdownMenu machineSelect;
   DropdownMenu midiInSelect;
   DropdownMenu midiOutSelect;
   RadioButtonMenu outputModes;
   RadioButtonMenu toggleOrPush;
   CheckBoxTableWindow launchpadToggleOrPush;
   
   MidiHandlerWindow() {
     h = 500;
     w = 500;
     locX = 0;
     locY = 0;
     window = new Window("MidiHandlerWindow", new PVector(h, w), this);
     
     ArrayList<DropdownMenuBlock> midiMachines = new ArrayList<DropdownMenuBlock>();
     midiMachines.add(new DropdownMenuBlock("launchPad", 1));
     midiMachines.add(new DropdownMenuBlock("LC2412", 2));
     midiMachines.add(new DropdownMenuBlock("keyRig 49", 3));
     machineSelect = new DropdownMenu("midiMachines", midiMachines); 
     
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
     
     outputModes = new RadioButtonMenu();
     outputModes.addBlock(new RadioButton("Memories", 1));
     outputModes.addBlock(new RadioButton("Fixtures", 2));
     
     toggleOrPush = new RadioButtonMenu();
     toggleOrPush.addBlock(new RadioButton("Toggle", 1));
     toggleOrPush.addBlock(new RadioButton("Push", 2));
     
     launchpadToggleOrPush = new CheckBoxTableWindow("launchpadToggleOrPush", 8, 8);
   }
   
   IntController offset = new IntController("testIntController");
   
   void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
     window.draw(g, mouse);
     g.pushMatrix();
       g.translate(40, 60);
  
       
       if(machineSelect.valueHasChanged()) {
         selectedMachine = machineSelect.getValue();
       }
       
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
       
       if(selectedMachine == 1) { //Launchpad
         g.pushMatrix();
           g.translate(500, 0);
           launchpadToggleOrPush.draw(g, mouse, isTranslated);
           launchpadToggleOrPush.locX = locX + 500;
           launchpadToggleOrPush.locY = locY;
           launchpadToggleOrPush.open = true;
           if(launchpadToggleOrPush.valueHasChanged()) {
             if(launchpad != null) {
             launchpad.useToggle[launchpadToggleOrPush.changedValue()[0]][launchpadToggleOrPush.changedValue()[1]] 
             = launchpadToggleOrPush.getValue(launchpadToggleOrPush.changedValue()[0], launchpadToggleOrPush.changedValue()[1]);
             }
           }
          
         g.popMatrix();
       }
       
       g.translate(0, 200);
       
       g.pushMatrix();
         g.translate(200, 0);
         toggleOrPush.draw(g, mouse);
       g.popMatrix();
       
       
       outputModes.draw(g, mouse);
       
       
       
       
      if(toggleOrPush.valueHasChanged()) {
         switch(selectedMachine) {
           case 1: //Launchpad
             if(launchpad != null) launchpad.setUseToggleToAll(toggleOrPush.getValue() == 1);
           break;
           
           case 2: //LC2412
           break;
           
           case 3: //KerRig 49
             
           break;
         }
      }
       
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
       
       
     
     g.popMatrix();
     
     g.pushMatrix();
       g.translate(40, 60);
       machineSelect.draw(g, mouse);
     g.popMatrix();
     
     
     
     
   }
   
    
 }
 
 
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
           g.translate(x*30, y*30);
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
     toReturn[0] = changedY;
     toReturn[1] = changedX;
     return toReturn;
   }
   
   boolean getValue(int x, int y) {
     return boxes[x][y].getValue();
   }
 }


 void createMidiClasses() {
   LaunchpadData launchpadData = new LaunchpadData();
 //  launchpad = new Launchpad(2, 2);
  // LC2412 = new behringerLC2412(1, 2);
   inputClass = new Input();
  // keyRig49 = new Keyrig49(1);
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
  
  Keyrig49(int inputIndex) {
    setup(inputIndex);
  }
  
  void setup(int inputIndex) {
    if(bus != null) { bus.clearAll(); }
    this.inputIndex = inputIndex;
    if(bus != null) { bus.addInput(inputIndex); }
    else { bus = new MidiBus(this, inputIndex, 0); }

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
  
  boolean[][] useToggle;
  
  MidiBus bus;
  
  int inputIndex;
  int outputIndex;
  
  int offset;
  
  Launchpad(int inputIndex, int outputIndex) {
    setup(inputIndex, outputIndex);
  }
  
  void setup(int inputIndex, int outputIndex) {
    if(bus != null) { bus.clearAll(); }
    this.inputIndex = inputIndex;
    this.outputIndex = outputIndex;
    if(bus != null) { bus.addInput(inputIndex); bus.addOutput(outputIndex); }
    else { bus = new MidiBus(this, inputIndex, outputIndex); }
    
    pads = new boolean[8][8];
    padsToggle = new boolean[8][8];
    upperPads = new boolean[8];
    upperPadsToggle = new boolean[8];
    
    output = 1;
    useToggle = new boolean[8][8];
    for(int x = 0; x < 8; x++) { 
      for(int y = 0; y < 8; y++) { 
        useToggle[x][y] = true; 
      } 
    }
    
  }
  
  void setUseToggleToAll(boolean use) {
    for(int x = 0; x < 8; x++) { 
      for(int y = 0; y < 8; y++) { 
        useToggle[x][y] = use; 
      } 
    }
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    int x = constrain(pitch%16, 0, pads.length-1), y = constrain(pitch/16, 0, pads[0].length-1);
    boolean val = midiToBoolean(velocity);
    pads[x][y] = val;
    if(val) padsToggle[x][y] = !padsToggle[x][y];
    
    boolean value;
    if(useToggle[x][y]) {
      value = padsToggle[x][y];
    }
    else {
      value = pads[x][y];
    }
    bus.sendNoteOn(0, pitch, byte(value) * 127);
    if(output == 1) { setMemoryEnabledByOrderInVisualisation(x+8*y+1+offset, value); }
    else if(output == 2) { fixtures.get(constrain(x+8*y+offset, 0, fixtures.size()-1)).in.setUniversalDMX(DMX_DIMMER, value ? 255 : 0); }
  }
  
  void noteOff(int channel, int pitch, int velocity) {
    noteOn(channel, pitch, 0);
  }

  
  void controllerChange(int channel, int number, int value) {
    boolean val = midiToBoolean(value);
    int x = constrain(number-104, 0, upperPads.length-1);
    upperPads[x] = val;
    if(val) upperPadsToggle[x] = !upperPadsToggle[x];
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
  
  int[] output = { OUTPUT_TO_FIXTURES, OUTPUT_TO_MEMORIES };

  
  
  int inputIndex;
  int outputIndex;
  
  int offset;
  
  behringerLC2412(int inputIndex, int outputIndex) {
    setup(inputIndex, outputIndex);
  }
  
  MidiBus bus;
  void setup(int inputIndex, int outputIndex) {
    //Midi start commands
    if(bus != null) { bus.clearAll(); }
    this.inputIndex = inputIndex;
    this.outputIndex = outputIndex;
    if(bus != null) { bus.addInput(inputIndex); bus.addOutput(outputIndex); }
    else { bus = new MidiBus(this, inputIndex, outputIndex); }
    
    faderValue = new int[2][12];
    faderValueOld = new int[2][12];
    buttons = new boolean[12];
    buttonsOld = new boolean[12];
    buttonsToggle = new boolean[12];
    buttonsToggleOld = new boolean[12];
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
    }
    else if(isBetween(num, 12, 23)) {
      faderValue[1][num-12] = midiToDMX(val);
    }
    else if(isBetween(num, 31, 42)) {
      buttons[constrain(num-31, 0, buttons.length-1)] = midiToBoolean(val);
      if(buttons[constrain(num-31, 0, buttons.length-1)]) { buttonsToggle[constrain(num-31, 0, buttons.length-1)] = !buttonsToggle[constrain(num-31, 0, buttons.length-1)]; }
    }
    else {
      switch(num) {
        case 24: chaserValues[0] = midiToDMX(val); break; //Speed
        case 25: chaserValues[1] = midiToDMX(val); break; //X-fade
        case 26: chaserValues[2] = midiToDMX(val); break; //Chase
        case 27: masterValues[0] = midiToDMX(val); break; //Main
        case 28: masterValues[1] = midiToDMX(val); break; //Main A
        case 29: masterValues[2] = midiToDMX(val); break; //Main B
        case 30: stepKey = midiToBoolean(val); break;
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
    processBehringerLC2412();
    
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

  
  
}

boolean midiToBoolean(int val) {
  return val > 63;
}
int midiToDMX(int val) {
  return rMap(val, 0, 127, 0, 255);
}

class LaunchpadData {
  LaunchpadData() {
  }
  boolean[][] button = new boolean[8][8];
}


 
//Maschine Mikro MK2 Interfacing -------------------------------------------------------------------------------------------------------

//This void is executed on program start
void initializeMaschine() {
  //Set left-right buttons so, that only the right one is lit
  Maschine.sendControllerChange(10, 105, 0);
  Maschine.sendControllerChange(10, 106, 127);
  
  //Set mute button's light off
  Maschine.sendControllerChange(10, 119, 0);
  
  //Clear pad selection
  selectMaschinePad(1, false);
  
  //Turn the play button light on according to current pause status

}

//0: panDo, 1: tiltDo, 2: panUp, 3: tiltUp
boolean[] maschineManualMHadjustButtons = new boolean[4];


void maschineNote(int pitch, int velocity) {
  println("Maschine noteOn PITCH|" + pitch + "/VEL|" + velocity);
  
  //If velocity is not zero, the pad has been pressed down
  boolean down = velocity != 0;
  switch (pitch) {
    //Next step according to direction
    case 12: triggerStepFromMaschine(down); break;
    
    //These are tha pads for adjusting the moving heads manually
    case 36: maschineManualMHadjustButtons[0] = down; break;
    case 38: maschineManualMHadjustButtons[1] = down; break;
    case 40: maschineManualMHadjustButtons[2] = down; break;
    case 41: maschineManualMHadjustButtons[3] = down; break;
  }
  //Trigger moving head preset
  if(pitch >= 14 && pitch <= 28 && velocity != 0) {

    selectMaschinePad(pitch - 13, true);
  }
}


void triggerStepFromMaschine(boolean onOrOff) {
  if (maschineStepDirectionIsNext) nextStepPressed = onOrOff; 
        else revStepPressed = onOrOff;
        
  //Toggle step direction, as nextRevAutoChange is true
  if (nextRevAutoChange && !onOrOff) setMaschineStepDirection(!maschineStepDirectionIsNext);
}


//Select a maschine pad and turn all the rest off
//This only affects pads 2-16
//The putOn parameter affects whether the selected pad will be lit on or not (to use for clearing)
void selectMaschinePad(int padId, boolean putOn) {
  //2nd pad is at 14
  Maschine.sendNoteOn(10, padId + 13, 127);
  
  //Turn the rest off 
  for (int i = 1; i <= 16; i++) {
    if (i != padId || !putOn) Maschine.sendNoteOn(10, i + 13, 0); 
  }
}

boolean maschineStepDirectionIsNext = true;

int maschineKnobVal = 0;

boolean nextRevAutoChange = false;

void setMaschineStepDirection(boolean direction) {
  if (direction) {
    maschineStepDirectionIsNext = true;
    Maschine.sendControllerChange(10, 105, 0);
    Maschine.sendControllerChange(10, 106, 127);
  } else {
    maschineStepDirectionIsNext = false;
    Maschine.sendControllerChange(10, 105, 127);
    Maschine.sendControllerChange(10, 106, 0);
  }
  
   
}



void maschineControllerChange(int number, int value) {
  
  println("Maschine CC NUMBER|" + number + "/VALUE|" + value);
  switch(number) {
    case 22:
      //Knob rotated
      maschineKnobRotated(value == 1);
    break;
    
    //CONTROL button, next chase mode
    case 92: nextChaseMode(); break;
    
    //Step direction: back
    case 105: 
      setMaschineStepDirection(false);
    break;
    //Step direction: forward
    case 106: 
      setMaschineStepDirection(true);
    break;
    
    //toggle BlackOut
    case 119: 
      blackOutToggle();
      //Turn the mute button light on according to current blackout status
      if(blackOut) Maschine.sendControllerChange(10, 119, 127); else Maschine.sendControllerChange(10, 119, 0);
    break;
    
    //toggle fullOn
    case 112: 
      fullOnToggle();
      //Turn the mute button light on according to current blackout status
      if(fullOn) Maschine.sendControllerChange(10, 112, 127); else Maschine.sendControllerChange(10, 112, 0);
    break;
    
    
    //toggle chasePause
    case 108: 

      //Turn the play button light on according to current pause status

    break;
    
    //register tempo tap (REC button)
    case 109: registerTempoTapTap(); break;
    //clear automatic temp tapping (ERASE button)
    case 110: clearMaschineAutoTap(); break;
    
    //toggle nextRevAutoChange
    case 117: 
      nextRevAutoChange = !nextRevAutoChange;
      //Turn the select button light on according to current nextRecAutoChange status
      if(nextRevAutoChange) Maschine.sendControllerChange(10, 117, 127); else Maschine.sendControllerChange(10, 117, 0);
    break;
    
  }
  
}

void maschineKnobRotated(boolean positive) {
  if(positive) {
    if (maschineKnobVal < 30) maschineKnobVal++; else maschineKnobVal = 0;
  } else {
    if (maschineKnobVal > 0) maschineKnobVal--; else maschineKnobVal = 30;
  }
  println(maschineKnobVal);
  doByMaschineKnob();
}

void doByMaschineKnob() {
  //Current task: rotate main window view
  pageRotation = int(map(maschineKnobVal, 0, 31, 0, 360));
}


//Tempo tap feature (MAT = Maschine Auto Tap)----------

//How many times the rec button has been pressed (4 is needed to start MAT)
int tempotapTapCount = 0;
int[] tempotapTaps = new int[4];
int tapStartMillis;

boolean MATenable = false;
int MATinterval;

//This is triggered when the rec button is pressed
void registerTempoTapTap() {
  if (!MATenable) {
    //Go to next step
    MATstepTriggered = true; triggerStepFromMaschine(true);
    if (tempotapTapCount < 3) {
      if (tempotapTapCount == 0) tapStartMillis = millis();
      tempotapTaps[tempotapTapCount] = millis() - tapStartMillis;
      
      tempotapTapCount++;
    } else {
      //Tempo tap finished. Calculate interval and begin automatic "tapping"
      tempotapTaps[3] = millis() - tapStartMillis;
      
      //calculate automatic tap interval
      
      //Calculate total sum of intervals between taps
      int total = 0;
      for (int i = 1; i <= 3; i++) {
        total += tempotapTaps[i] - tempotapTaps[i - 1];
      }
      //Take average
      MATinterval = int(total/3);
      MATenable = true;
    }
  }
}

boolean MATstepTriggered = false;
int MATlastStepMillis;
//This function gets triggered every draw, so it can be used for other purposes as well.
void calcMaschineAutoTap() {

  //------AutoTap calculations
  //Always turn off the booleans if they were put to true last time
  if(MATstepTriggered) { MATstepTriggered = false; triggerStepFromMaschine(false); Maschine.sendControllerChange(10, 109, 0); }
  if(MATenable) {
    if(millis() > MATlastStepMillis + MATinterval) {
      MATstepTriggered = true;
      triggerStepFromMaschine(true);
      Maschine.sendControllerChange(10, 109, 127);
      MATlastStepMillis = millis();
    }
  }
  
}

//Clean up MAT variables
void clearMaschineAutoTap() {
  tempotapTapCount = 0;
  tempotapTaps = new int[4];
  tapStartMillis = 0;
  
  MATenable = false;
  MATinterval = 0;
}
