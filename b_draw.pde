//Tässä välilehdessä on koko ohjelman ydin, eli draw-loop

int[] midiNotesWithoutBlacks = { 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 8, 9, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 27, 28, 29, 30, 31 };
boolean wasAt64 = false;
 
int oldMouseX1;
int oldMouseY1;

int grandMaster = 50;
int oldGrandMaster = 40;

long totalMillis[] = new long[9];

void draw() {
  if(programReadyToRun && !freeze) {
    textSize(12);
    for(int i = 0; i < memories.length; i++) { memories[i].draw(); }
    
    memories[1].type = 4;
    memories[2].type = 5;
  
    checkThemeMode();
    
    setDimAndMemoryValuesAtEveryDraw(); //Set dim and memory values
    if (arduinoFinished) thread("arduinoSend"); //Send dim-values to arduino, which sends them to DMX-shield
    
    drawMainWindow(); //Draw fixtures (tab main_window)
    
    if(!printMode) {
      ylavalikko(); //top menu
      alavalikko(); //bottom menu
      sivuValikko(); //right menu
      contextMenu1.draw();
    }
    thread("detectBeat");
  
    
    if (useMaschine) calcMaschineAutoTap();
    
    //Invoke every fixtures draw
    if(invokeFixturesDrawFinished) thread("invokeFixturesDraw");
    
    
  }
  if(!freeze) initSettingsInSetup();
}



//------------------------------------------------------------------------------------------------------------------------MIDI----------------------------------------------------------------------------------------------------------------------------------

//This void detects if midi keyboard key is pressed
void noteOn(int channel, int pitch, int velocity) {
  
  if (channel != 10 && !useMaschine) {
    noteOn[pitch] = true;
    if(pitch < midiNotesWithoutBlacks.length) {
      dimInput[midiNotesWithoutBlacks[pitch]] = constrain(int(velocity*2.3), 0, 255);
    }
  } else {
    //Coming from Maschine
    maschineNote(pitch, velocity);
  }
}

//This void detects if midi keyboard key is released
void noteOff(int channel, int pitch, int velocity) {
  
   if (channel != 10 && !useMaschine) {
     noteOn[pitch] = false;
     if(pitch < midiNotesWithoutBlacks.length) {
       dimInput[midiNotesWithoutBlacks[pitch]] = 0;
     }
   } else {
     //Coming from Maschine
     maschineNote(pitch, velocity);
   }
}


void controllerChange(ControlChange change) {
  if (change.channel() != 10 && !useMaschine) {
    int i = round(map(change.value(), 0, 127, 0, 255));
    if(change.number() == 7) {
      changeGrandMasterValue(i);
    }
    else if(change.number() == 1) {
      changeCrossFadeValue(i);
    }
  } else {
    //Coming from Maschine
    maschineControllerChange(change.number(), change.value());
  }

}


void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)

  if(message.getStatus() == 224) {
    if(((int)(message.getMessage()[2] & 0xFF)) > 64 && wasAt64) {
      chaseMode++;
    }
    if(((int)(message.getMessage()[2] & 0xFF)) < 64 && wasAt64) {
      chaseMode--;
    }
    if((int)(message.getMessage()[2] & 0xFF) == 64) {
      wasAt64 = true;
    }
    else {
      wasAt64 = false;
    }
  }
  
}

//----------------------------------------------------------------------------------------------------------------------MIDI END--------------------------------------------------------------------------------------------------------------------------------
