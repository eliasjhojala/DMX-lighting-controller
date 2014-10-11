//Tässä välilehdessä luetaan aikaisemmin tallennettuja tietoja csv-taulukkotiedostosta
boolean dataLoaded = false;
void loadSetupData() {
  if(userId == 1) {
   table = loadTable("/Users/elias/Dropbox/DMX controller/main_for_two_pc/variables/settings.csv", "header"); //Eliaksen polku
  }
  else if(!roopeAidilla){
   table = loadTable("E:\\Dropbox\\DMX controller\\main_for_two_pc\\variables\\settings.csv", "header"); //Roopen polku
  } else table = loadTable("C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_for_two_pc\\variables\\settings.csv", "header"); // Roope äidillä -polku
  
  for (TableRow row : table.findRows("sendOscToAnotherPc", "variable_name")) { sendOscToAnotherPc = boolean(row.getString("value")); }
  for (TableRow row : table.findRows("sendOscToIpad", "variable_name")) { sendOscToIpad = boolean(row.getString("value")); }
  for (TableRow row : table.findRows("sendMemoryToIpad", "variable_name")) { sendMemoryToIpad = boolean(row.getString("value")); }
  for (TableRow row : table.findRows("useCOM", "variable_name")) { useCOM = boolean(row.getString("value")); }
  for (TableRow row : table.findRows("showOutputAsNumbers", "variable_name")) { showOutputAsNumbers = boolean(row.getString("value")); }
  for (TableRow row : table.findRows("use3D", "variable_name")) { use3D = boolean(row.getString("value")); }
  for (TableRow row : table.findRows("loadAllDataInSetup", "variable_name")) { loadAllDataInSetup = boolean(row.getString("value")); }
  
}

void loadAllData() {
    loadSetupData();
    
    if(userId == 1) {
     table = loadTable("/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv", "header"); //Eliaksen polku
    }
    else if(!roopeAidilla) {
     table = loadTable("E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv", "header"); //Roopen polku
    } else table = loadTable("C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv", "header"); //Roope äidillä -polku
    
    for (TableRow row : table.findRows("xTaka", "variable_name")) { if(xTaka.length > (int(row.getString("1D")))) {xTaka[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("yTaka", "variable_name")) { yTaka[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("rotX", "variable_name")) { rotX[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixZ", "variable_name")) { fixZ[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("memoryType", "variable_name")) { memoryType[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("soundToLightSteps", "variable_name")) { soundToLightSteps[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("red", "variable_name")) { red[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("green", "variable_name")) { green[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("blue", "variable_name")) { blue[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("rotTaka", "variable_name")) { rotTaka[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureType1", "variable_name")) { fixtureType1[int(row.getString("1D"))] = int(row.getString("value")); }
    
    int[] grouping = new int[4];
    for (TableRow row : table.findRows("grouping", "variable_name")) { grouping[int(row.getString("1D"))] = int(row.getString("value")); }
    controlP5place = grouping[0]; enttecDMXplace = grouping[1]; touchOSCplace = grouping[2];
          
    for (TableRow row : table.findRows("memory", "variable_name"))              { memory[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("soundToLightPresets", "variable_name")) { soundToLightPresets[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("preset", "variable_name"))              { preset[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("camX", "variable_name"))              { camX = int(row.getString("value")); }
    for (TableRow row : table.findRows("camY", "variable_name"))              { camY = int(row.getString("value")); }
    for (TableRow row : table.findRows("camZ", "variable_name"))              { camZ = int(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("rotX", "variable_name"))              { rotX[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixZ", "variable_name"))              { fixZ[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixParam", "variable_name"))              { fixParam[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("ansaZ", "variable_name"))         { if((int(row.getString("1D")) < ansaZ.length)) { ansaZ[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaX", "variable_name"))         { if((int(row.getString("1D")) < ansaX.length)) { ansaX[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaY", "variable_name"))         { if((int(row.getString("1D")) < ansaY.length)) { ansaY[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaParent", "variable_name"))    { if((int(row.getString("1D")) < ansaParent.length)) { ansaParent[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaType", "variable_name"))    { if((int(row.getString("1D")) < ansaType.length)) { ansaType[int(row.getString("1D"))] = int(row.getString("value")); } }
  
    
    for (TableRow row : table.findRows("channel", "variable_name"))              { channel[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureIdNow", "variable_name"))              { fixtureIdNow[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureIdOriginal", "variable_name"))              { fixtureIdOriginal[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureIdPlaceInArray", "variable_name"))              { fixtureIdPlaceInArray[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("chaseModeByMemoryNumber", "variable_name"))              { chaseModeByMemoryNumber[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("chaseMode", "variable_name"))              { chaseMode = int(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("valueOfMemory", "variable_name"))              { valueOfMemory[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("memoryValue", "variable_name"))              { memoryValue[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("centerX", "variable_name"))              { centerX = int(row.getString("value")); }
    for (TableRow row : table.findRows("centerY", "variable_name"))              { centerY = int(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("mhx50_createFinalPresetValues[1D][0][2D]", "variable_name"))         if((int(row.getString("2D")) < mhx50_createFinalPresetValues.length) && (int(row.getString("1D")) < mhx50_createFinalPresetValues[0][0].length)) {     { mhx50_createFinalPresetValues[int(row.getString("2D"))][0][int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("mhx50_createFinalPresetValues[1D][1][2D]", "variable_name"))         if((int(row.getString("2D")) < mhx50_createFinalPresetValues.length) && (int(row.getString("1D")) < mhx50_createFinalPresetValues[0][0].length)) {     { mhx50_createFinalPresetValues[int(row.getString("2D"))][1][int(row.getString("1D"))] = int(row.getString("value")); } }

    
    
    for (TableRow row : table.findRows("mhx50_s2l_presets", "variable_name"))              { mhx50_s2l_presets[int(row.getString("1D"))] = int(row.getString("value")); }
    
    dataLoaded = true;
  
}
