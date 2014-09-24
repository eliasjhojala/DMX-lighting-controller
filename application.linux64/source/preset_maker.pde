//Tässä välilehdessä mm. luodaan presettejä
int[] oldMemoryValue = new int[numberOfMemories]; //Muuttuja, johon tallennetaan memoryn edellinen arvo
int[] oldPresetValue = new int[numberOfMemories]; //Muuttuja, johon tallennetaan memoryn edellinen arvo
void makePreset(int memoryNumber) {
  rect(width/2-100, height/2-100, 100, 100);
  for(int i = 0; i < channels; i++) {
      preset[memoryNumber][i] = dim[i];
  }
  memoryType[memoryNumber] = 1;
}
void preset(int memoryNumber, int value) {
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
  for(int i = 0; i < numberOfMemories; i++) {
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
  valueOfMemory[memoryNumber] = value;
//  memoryValue[memoryNumber] = value;
  if(memoryType[memoryNumber] == 1) {
    preset(memoryNumber, value);
  }
  if(memoryType[memoryNumber] == 2) {
    beatDetectionDMX(memoryNumber, value);
  }
  if(memoryType[memoryNumber] == 3) {
    beatDetectionDMX(0, value);
  }
  if(memoryType[memoryNumber] == 4) {
    if(blackOut == false) { grandMaster = value; } else { grandMaster = 0; }
  }
  if(memoryType[memoryNumber] == 5) {
    chaseFade = value;
  }
  oldMemoryValue[memoryNumber] = value;
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
