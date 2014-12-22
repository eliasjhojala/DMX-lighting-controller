//Tässä välilehdessä mm. luodaan presettejä
int[] oldMemoryValue = new int[numberOfMemories]; //Muuttuja, johon tallennetaan memoryn edellinen arvo
int[] oldPresetValue = new int[numberOfMemories]; //Muuttuja, johon tallennetaan memoryn edellinen arvo
/*void makePreset(int memoryNumber) {
   for (int i = 0; i < fixtures.length; i++) {
    whatToSave[0][memoryNumber] = true;
     
  }
  saveFixtureMemory(memoryNumber);
}*/
void preset(int memoryNumber, int value) {
  presetNew(memoryNumber, value);
}
void presetNew(int memoryNumber, int value) {
  loadFixtureMemory(memoryNumber, value);
  memoryValue[memoryNumber] = value;
}
void presetOld(int memoryNumber, int value) {
  for(int i = 0; i < channels; i++) {
    int to = round(map(preset[memoryNumber][i], 0, 255, 0, value));
    if(memoryData[i] < to) {
      memoryData[i] = to;
    }
    
  }
  memoryValue[memoryNumber] = value;
  if(value != oldPresetValue[memoryNumber]) {
    sendMemoryToIpad(memoryNumber, value); //Läheteetään iPadille memorin arvo, jos se on muuttunut
  }
  oldPresetValue[memoryNumber] = value;
}

void soundToLightFromPreset(int memoryNumber) {
  int a = 0;
  for(int i = 3; i < numberOfMemories; i++) {
    if(memoryValue[i] != 0) {
      a++;
      soundToLightPresets[memoryNumber][a] = i;
    }
}
soundToLightSteps[memoryNumber] = a;
memoryType[memoryNumber] = 2;
}

void memory(int memoryNumber, int value) {
  if(value != oldMemoryValue[memoryNumber]) {
    sendMemoryToIpad(memoryNumber, value); //Läheteetään iPadille memorin arvo, jos se on muuttunut
  }
  memories[memoryNumber].setValue(value);
}
void changeChaseModeByMemoryNumber(int memoryNumber) {
  fill(0, 0, 255);
  rect(width/2-200, height/2-200, 400, 400);
  fill(255, 255, 255);
  text("Change chaseModeByMemoryNumber", width/2-200+20, height/2-200+20);
  if(keyPressed == true) {
    if(keyCode == UP && keyReleased == true) {
      chaseModeByMemoryNumber[memoryNumber]++;
      keyReleased = false;
    }
    if(keyCode == DOWN && keyReleased == true) {
      chaseModeByMemoryNumber[memoryNumber]--;
      keyReleased = false;
    }
  }
  text("chaseModeByMemoryNumber:"+chaseModeByMemoryNumber[memoryNumber], width/2-200+20, height/2-200+50);
}

void changeGrandMasterValue(int value) {
  memory(1, value);
  valueOfMemory[1] = value;
  memoryValue[1] = value;
}
void changeCrossFadeValue(int value) {
  memory(2, value);
  valueOfMemory[2] = value;
  memoryValue[2] = value;
}

boolean presetIsEmpty(int presetId) {
  //todo
  //  todo = todo todo todo
  // doto todo doto
  //todo
  return false;
}
