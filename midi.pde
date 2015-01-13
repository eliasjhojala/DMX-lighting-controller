Launchpad launchpad;

final int OUTPUT_TO_FIXTURES = 1;
final int OUTPUT_TO_DMX = 2;
final int OUTPUT_TO_MEMORIES = 3;

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
  
  MidiBus bus;
  
  Launchpad(int inputIndex, int outputIndex) {
    setup(inputIndex, outputIndex);
  }
  
  void setup(int inputIndex, int outputIndex) {
    
    bus = new MidiBus(this, inputIndex, outputIndex);
    pads = new boolean[8][8];
    padsToggle = new boolean[8][8];
    upperPads = new boolean[8];
    upperPadsToggle = new boolean[8];
    
    output = 2;
    
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    int x = constrain(pitch%16, 0, pads.length-1), y = constrain(pitch/16, 0, pads[0].length-1);
    boolean val = midiToBoolean(velocity);
    pads[x][y] = val;
    if(val) padsToggle[x][y] = !padsToggle[x][y];
    
    bus.sendNoteOn(0, pitch, byte(padsToggle[x][y]) * 127);
    if(output == 1) { memories[x+8*y+1].setValue(padsToggle[x][y] ? 255 : 0); }
    else if(output == 2) { fixtures.get(x+8*y).setDimmer(padsToggle[x][y] ? 255 : 0); }
    
    println("RECEIVED LAUNCHPAD MIDI");
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
  int masterAvalue, masterBvalue, masterValue;
  int[] masterValues = new int[3];
  int[] masterValuesOld = new int[3];
  int[] chaserValues = new int[3];
  int[] chaserValuesOld = new int[3];
  int speedValue, xFadeValue, chaserValue;
  int bank;
  int chaserNumber;
  boolean stepKey, channelFlashKey, soloKey, special1Key, special2Key, manualKey, chaserModeKey, insertKey, presetKey, memoryKey;
  
  int output = 3;

  
  behringerLC2412(int inputIndex, int outputIndex) {
    setup(inputIndex, outputIndex);
  }
  
  MidiBus bus;
  void setup(int inputIndex, int outputIndex) {
    //Midi start commands
    bus = new MidiBus(this, inputIndex, outputIndex);
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    midiMessageIn(pitch, velocity);
    println("RECEIVED BEHRINGER MIDI");
  }
  void noteOff(int channel, int pitch, int velocity) {
    midiMessageIn(pitch, velocity);
  }
  
  void midiMessageIn(int num, int val) {
    if(isBetween(num, 0, 11)) {
      faderValue[0][num] = midiToDMX(val);
    }
    else if(isBetween(num, 12, 23)) {
      faderValue[1][num-12] = midiToDMX(val);
    }
    else if(isBetween(num, 31, 42)) {
      buttons[num-31] = midiToBoolean(val);
    }
    else {
      switch(num) {
        case 24: chaserValues[0] = midiToDMX(val);
        case 25: chaserValues[1] = midiToDMX(val);
        case 26: chaserValues[2] = midiToDMX(val);
        case 27: masterValues[0] = midiToDMX(val);
        case 28: masterValues[1] = midiToDMX(val);
        case 29: masterValues[2] = midiToDMX(val);
        case 30: stepKey = midiToBoolean(val);
        case 43: bank = val;
        case 44: chaserNumber = val;
        case 45: channelFlashKey = midiToBoolean(val);
        case 46: soloKey = midiToBoolean(val);
        case 47: special1Key = midiToBoolean(val);
        case 48: special2Key = midiToBoolean(val);
        case 49: manualKey = midiToBoolean(val);
        case 50: chaserModeKey = midiToBoolean(val);
        case 51: insertKey = midiToBoolean(val);
        case 52: presetKey = midiToBoolean(val);
        case 53: memoryKey = midiToBoolean(val);
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
    
  }
  void processBehringerLC2412master() {
    if(LC2412.masterValues[0] != LC2412.masterValuesOld[0]) {
      changeGrandMasterValue(LC2412.masterValues[0]);
      LC2412.masterValuesOld[0] = LC2412.masterValues[0];
    }
  }
  void processBehringerLC2412faders() {
    for(int i = 0; i <= 11; i++) {
      if(setValueToOutput(i, LC2412.output, LC2412.bank*12, LC2412.faderValue[1], LC2412.faderValueOld[1])) {
        LC2412.faderValueOld[1][i] = LC2412.faderValue[1][i];
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
 
 void createMidiClasses() {
   LaunchpadData launchpadData = new LaunchpadData();
   launchpad = new Launchpad(0, 3);
   behringerLC2412 LC2412 = new behringerLC2412(1, 2);
   inputClass = new Input();
 }

 LaunchpadData launchpadData;
 behringerLC2412 LC2412;
 Input inputClass;


 
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
