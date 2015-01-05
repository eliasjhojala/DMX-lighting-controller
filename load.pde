//Tässä välilehdessä luetaan aikaisemmin tallennettuja tietoja csv-taulukkotiedostosta
boolean dataLoaded = false;
boolean programReadyToRun = false; 
void loadSetupData() {
  use3D = !(userId == 3);
  showOutputAsNumbers = true;
}

void loadAllData() {
  programReadyToRun = false;
  try {
    loadAllData1();
    programReadyToRun = true;
  }
  catch(Exception e) {
    if(inputIsSelected) {
      fileDialogInput();
      programReadyToRun = false;
      loadAllData();
    }
    e.printStackTrace();
  }
}
void loadAllData1() {
    loadSetupData();

     table = loadTable(loadPath, "header"); //Eliaksen polku

        
    
    //FIXTURES---------------------------------------------------------------------------------------------------------------------------
    //Initialize fixtures using type
    fixtures.clear();
    for(TableRow row : table.findRows("idLookupTable", "variable_name")) {
      idLookupTable.add(int(row.getString("value")));
    }
    
  
    
    //fixtures.array.ensureCapacity(int(table.findRow("fixtures.size", "variable_name").getString("value")));
    
    for (TableRow row : table.findRows("fixtureType1", "variable_name")) 
        { 
          fixtures.array.add(int(row.getString("1D")), new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, int(row.getString("value"))));
        
        }
    
    
    for (TableRow row : table.findRows("xTaka", "variable_name"))      if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).x_location           = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("yTaka", "variable_name"))      if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).y_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("fixZ", "variable_name"))       if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).z_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("rotTaka", "variable_name"))    if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).rotationZ            = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("rotX", "variable_name"))       if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).rotationX            = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("fixParam", "variable_name"))   if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).parameter            = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("red", "variable_name"))        if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).red                  = int(row.getString("value")); }
    for (TableRow row : table.findRows("green", "variable_name"))      if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).green                = int(row.getString("value")); }
    for (TableRow row : table.findRows("blue", "variable_name"))       if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).blue                 = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("channel", "variable_name"))    if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).channelStart         = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("ansaParent", "variable_name")) if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).parentAnsa           = int(row.getString("value")); }
    
    //--------------------------------------------------------------------------------------------------------------------------------------
    // whatToSave titles: { "dimmer", "colorWheel", "gobo", "goboRotation", "shutter", "pan", "tilt" }
    
    /*for (TableRow row : table.findRows("whatToSave", "variable_name")) if(int(row.getString("1D")) < whatToSave.length && int(row.getString("2D")) < whatToSave[0].length)
    {
      int val = int(row.getString("value"));
      
      whatToSave[int(row.getString("1D"))][int(row.getString("2D"))] = boolean(val);
    }*/
    
    
    
    
  
    
    
    
    
    
 

int memoriesLength = 0;

for (TableRow row : table.findRows("memories.length", "variable_name")) {
  int v = int(row.getString("value"));
  memoriesLength = v;
}

int[] repOfFixturesLength = new int[memoriesLength];

for (TableRow row : table.findRows("memories[i].repOfFixtures.length", "variable_name")) {
  int v = int(row.getString("value"));
  int D1 = int(row.getString("1D"));
  repOfFixturesLength[D1] = v;
}

/*for(int i = 0; i < memoriesLength; i++) {
  memories[i] = new memory();
  memories[i].repOfFixtures = new fixture[repOfFixturesLength[i]];
  for(int ij = 0; ij < repOfFixturesLength[i]; ij++) {
    memories[i].repOfFixtures[ij] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }
}*/

//memory objects and repOfFixtures objects are now created but NOT myChase.presets objects


int[] myChasePresetsLength = new int[memoriesLength];
int[] myChaseContentLength = new int[memoriesLength];

for (TableRow row : table.findRows("memories[i].myChase.presets.length", "variable_name")) {
  int v = int(row.getString("value"));
  int D1 = int(row.getString("1D"));
  myChasePresetsLength[D1] = v;
}

for (TableRow row : table.findRows("memories[i].myChase.content.length", "variable_name")) {
  int v = int(row.getString("value"));
  int D1 = int(row.getString("1D"));
  myChaseContentLength[D1] = v;
}

for(int i = 0; i < memoriesLength; i++) {
  
  for(int ij = 0; ij < myChasePresetsLength[i]; ij++) {
    memories[i].myChase.presets = new int[myChasePresetsLength[i]];
  }
  for(int ij = 0; ij < myChaseContentLength[i]; ij++) {
    memories[i].myChase.content = new int[myChaseContentLength[i]];
  }
}

//Now also myChase.presets objects are created



for (TableRow row : table.findRows("memories[i].myChase.presets[ij]", "variable_name")) {
  int i = int(row.getString("1D"));
  int ij = int(row.getString("2D"));
  int v = int(row.getString("value"));
  if(memories[i].myChase.presets != null) { //no nullpointers anymore
    memories[i].myChase.presets[ij] = v;
  }
}

for (TableRow row : table.findRows("memories[i].myChase.content[ij]", "variable_name")) {
  int i = int(row.getString("1D"));
  int ij = int(row.getString("2D"));
  int v = int(row.getString("value"));
  if(memories[i].myChase.content != null) { //no nullpointers anymore
    memories[i].myChase.content[ij] = v;
  }
}

for (TableRow row : table.findRows("memories[i].myChase.inputMode", "variable_name")) {
  int i = int(row.getString("1D"));
  int v = int(row.getString("value"));
  memories[i].myChase.inputMode = v;
}

for (TableRow row : table.findRows("memories[i].myChase.outputMode", "variable_name")) {
  int i = int(row.getString("1D"));
  int v = int(row.getString("value"));
  memories[i].myChase.outputMode = v;
}

for (TableRow row : table.findRows("memories[i].myChase.beatModeId", "variable_name")) {
  int i = int(row.getString("1D"));
  int v = int(row.getString("value"));
  memories[i].myChase.beatModeId = v;
}

for (TableRow row : table.findRows("memories[i].myChase.beatMode", "variable_name")) {
  int i = int(row.getString("1D"));
  String v = row.getString("value");
  memories[i].myChase.beatMode = v;
}

for(int abc = 0; abc < universalDMXlength; abc++) {
  for (TableRow row : table.findRows("memories[i].repOfFixtures[j].getUniDMX(" + str(abc) + ")", "variable_name")) {
    int i = int(row.getString("1D"));
    int j = int(row.getString("2D"));
    int v = int(row.getString("value"));
    memories[i].repOfFixtures[j].setUniDMX(abc, v);
    
  }
}

for (TableRow row : table.findRows("memories[i].repOfFixtures[j].colorWheel", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  int v = int(row.getString("value"));
  memories[i].repOfFixtures[j].setUniDMX(DMX_COLORWHEEL, v);
}

for (TableRow row : table.findRows("memories[i].repOfFixtures[j].goboWheel", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  int v = int(row.getString("value"));
  memories[i].repOfFixtures[j].setUniDMX(DMX_GOBOWHEEL, v);
}

for (TableRow row : table.findRows("memories[i].repOfFixtures[j].goboRotation", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  int v = int(row.getString("value"));
  memories[i].repOfFixtures[j].setUniDMX(DMX_GOBOROTATION, v);
}

for (TableRow row : table.findRows("memories[i].repOfFixtures[j].shutter", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  int v = int(row.getString("value"));
  memories[i].repOfFixtures[j].setUniDMX(DMX_SHUTTER, v);
}

for (TableRow row : table.findRows("memories[i].repOfFixtures[j].pan", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  int v = int(row.getString("value"));
  memories[i].repOfFixtures[j].setUniDMX(DMX_PAN, v);
}

for (TableRow row : table.findRows("memories[i].repOfFixtures[j].tilt", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  int v = int(row.getString("value"));
  memories[i].repOfFixtures[j].setUniDMX(DMX_TILT, v);
}


for (TableRow row : table.findRows("memories[i].whatToSave[ij]", "variable_name")) {
  int i = int(row.getString("1D"));
  int j = int(row.getString("2D"));
  boolean v = boolean(row.getString("value"));
  memories[i].whatToSave[j] = v;
}

for (TableRow row : table.findRows("memories[i].type", "variable_name")) {
  int i = int(row.getString("1D"));
  int v = int(row.getString("value"));
  memories[i].type = v;
}

for (TableRow row : table.findRows("memories[i].value", "variable_name")) {
  int i = int(row.getString("1D"));
  int v = int(row.getString("value"));
  memories[i].value = v;
}



    //---------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    //for (TableRow row : table.findRows("memoryType", "variable_name")) if(int(row.getString("1D")) < memoryType.length) { memoryType[int(row.getString("1D"))] = int(row.getString("value")); }
    //for (TableRow row : table.findRows("soundToLightSteps", "variable_name")) if(int(row.getString("1D")) < soundToLightSteps.length) { soundToLightSteps[int(row.getString("1D"))] = int(row.getString("value")); }
    
    
    
    int[] grouping = new int[3];
    for (TableRow row : table.findRows("grouping", "variable_name")) if(int(row.getString("1D")) < grouping.length) { grouping[int(row.getString("1D"))] = int(row.getString("value")); }
    controlP5place = grouping[0]; enttecDMXplace = grouping[1]; touchOSCplace = grouping[2];
          
    //for (TableRow row : table.findRows("memory", "variable_name")) if(memory.length > int(row.getString("1D")) && memory[0].length > int(row.getString("2D")))
    //        { memory[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    //for (TableRow row : table.findRows("soundToLightPresets", "variable_name")) if(soundToLightPresets.length > int(row.getString("2D")) && soundToLightPresets[0].length > int(row.getString("1D"))) 
    //        { soundToLightPresets[int(row.getString("2D"))][int(row.getString("1D"))] = int(row.getString("value")); }
    //for (TableRow row : table.findRows("preset", "variable_name")) if(preset.length > int(row.getString("1D")) && preset[0].length > int(row.getString("2D")))
    //        { preset[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("camX", "variable_name"))              { camX = int(row.getString("value")); }
    for (TableRow row : table.findRows("camY", "variable_name"))              { camY = int(row.getString("value")); }
    for (TableRow row : table.findRows("camZ", "variable_name"))              { camZ = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("bottomMenuOrder", "variable_name")) if(int(row.getString("1D")) < bottomMenuOrder.length) bottomMenuOrder[int(row.getString("1D"))] = int(row.getString("value"));
    
    cf.refreshAnsas();
    for (TableRow row : table.findRows("ansaZ", "variable_name"))         { if((int(row.getString("1D")) < ansaZ.length)) { ansaZ[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaX", "variable_name"))         { if((int(row.getString("1D")) < ansaX.length)) { ansaX[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaY", "variable_name"))         { if((int(row.getString("1D")) < ansaY.length)) { ansaY[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaType", "variable_name"))    { if((int(row.getString("1D")) < ansaType.length)) { ansaType[int(row.getString("1D"))] = int(row.getString("value")); } }
    cf.refreshAnsas();
    
    //for (TableRow row : table.findRows("chaseModeByMemoryNumber", "variable_name"))              { chaseModeByMemoryNumber[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("chaseMode", "variable_name"))              { chaseMode = int(row.getString("value")); }
    
    
    //for (TableRow row : table.findRows("valueOfMemory", "variable_name")) if(valueOfMemory.length > int(row.getString("1D")))
    //      { valueOfMemory[int(row.getString("1D"))] = int(row.getString("value")); }
    //for (TableRow row : table.findRows("memoryValue", "variable_name")) if(memoryValue.length > int(row.getString("1D")))
    //      { memoryValue[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("centerX", "variable_name"))              { centerX = int(row.getString("value")); }
    for (TableRow row : table.findRows("centerY", "variable_name"))              { centerY = int(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("mhx50_createFinalPresetValues[1D][0][2D]", "variable_name"))         if((int(row.getString("2D")) < mhx50_createFinalPresetValues.length) && (int(row.getString("1D")) < mhx50_createFinalPresetValues[0][0].length)) {     { mhx50_createFinalPresetValues[int(row.getString("2D"))][0][int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("mhx50_createFinalPresetValues[1D][1][2D]", "variable_name"))         if((int(row.getString("2D")) < mhx50_createFinalPresetValues.length) && (int(row.getString("1D")) < mhx50_createFinalPresetValues[0][0].length)) {     { mhx50_createFinalPresetValues[int(row.getString("2D"))][1][int(row.getString("1D"))] = int(row.getString("value")); } }
    
    
    
    dataLoaded = true;
    
    
  
}
