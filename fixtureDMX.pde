FixtureDMX[] fixtureDMX;

void fixtureDMXloop() { //This should be placed in draw
  try {
    if(fixtureDMX.length == fixtures.size()) {
      for(int i = 0; i < fixtureDMX.length; i++) {
        //everyLoopFunction();
      }
    }
    else {
      createFixtureDMXobjects();
    }
  }
  catch(Exception e) {
    createFixtureDMXobjects();
  }
}

void createFixtureDMXobjects() {
  fixtureDMX = new FixtureDMX[fixtures.size()];
  for(int i = 0; i < fixtures.size(); i++) {
    fixtureDMX[i] = new FixtureDMX();
  }
}

class FixtureDMX { //Class containig and counting all the dmx values
  /*
    In this class should be located all the fixture's dmx variables
  */
  int DMXlenght = 26;
  
  int[] DMXoutput = new int[DMXlenght]; //The FINAL output
  int[] DMXinput = new int[DMXlenght]; //The original input
  int[] DMXprocessed = new int[DMXlenght]; //The processed value
  int[] DMXoutputOld = new int[DMXlenght]; //Last output
  int[] DMXinputOld = new int[DMXlenght]; //Last input
  int[] DMXprocessedOld = new int[DMXlenght]; //Last processed value
  boolean DMXChanged;
  
  FixtureDMX() { //init
  }
  
  void everyLoopFunction() {
    processEveryLoop();
  }
  
  void checkDMXvariables() {
    for(int i = 0; i < DMXinput.length; i++) { //Go through the whole DMXinput array
     if(valueHasChanged(i, DMXinput, DMXinputOld)) {
        process(i);
      } //End of valueChanged check
    } //End of for loop
  } //End of void checkDMXvariables()
  
  void countDMXvariables() {
  }
 
 void process(int i) {
   setNewValueToFade(i);
 }
 
 void processEveryLoop() {
   for(int i = 0; i < DMXinput.length; i++) {
     DMXprocessed[i] = getFadedValue(i);
     if(valueHasChanged(i, DMXprocessed, DMXprocessedOld)) {
       processedValueToOutput(i);
     }
   }
 }
 
 void processedValueToOutput(int i) {
   DMXoutput[i] = DMXprocessed[i];
 }
 
 void setNewValueToFade(int i) {
 }
 
 int getFadedValue(int i) {
   return 100;
 }
 
 void sendDMXtoFixture() {
   for(int i = 0; i < DMXoutput.length; i++) {
     if(valueHasChanged(i, DMXoutput, DMXoutputOld)) {
      // fixtures[i].setUniversalDMX(i, DMXoutput[i]);
     }
   }
   
 }
 

 
}

boolean valueHasChanged(int i, int[] cur, int[] old) {
  return valueHasChanged(cur[i], old[i]);
}
boolean valueHasChanged(int cur, int old) {
  return cur != old;
}
