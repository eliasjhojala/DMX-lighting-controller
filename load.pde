//Tässä välilehdessä luetaan aikaisemmin tallennettuja tietoja csv-taulukkotiedostosta
boolean dataLoaded = false;
void loadSetupData() {
  if(userId == 1) {
   table = loadTable("/Users/elias/Dropbox/DMX controller/main_for_two_pc/variables/settings.csv", "header"); //Eliaksen polku
  }
  else if(userId == 2) {
    if(!roopeAidilla){
     table = loadTable("E:\\Dropbox\\DMX controller\\main_for_two_pc\\variables\\settings.csv", "header"); //Roopen polku
    } else table = loadTable("C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_for_two_pc\\variables\\settings.csv", "header"); // Roope äidillä -polku
  }
  else if(userId == 3) {
     table = loadTable("C:\\Users\\elias\\Dropbox\\DMX Controller\\main_modular\\variables\\settings.csv", "header");
  }

  
  use3D = !(userId == 3);
  showOutputAsNumbers = true;
}

void loadAllData() {
    loadSetupData();
   
   
    
    if(userId == 1) {
     table = loadTable("/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv", "header"); //Eliaksen polku
    }
    else if(userId == 2) {
      if(!roopeAidilla) {
       table = loadTable("E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv", "header"); //Roopen polku
      } else table = loadTable("C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv", "header"); //Roope äidillä -polku
    }
    else if(userId == 3) {
      table = loadTable("C:\\Users\\elias\\Dropbox\\DMX Controller\\main_modular\\variables\\pikkusten_disko.csv", "header");
    }
    
//         for(int i = 0; i < repOfFixtures.length; i++) {
//        for(int ij = 0; ij < repOfFixtures[i].length; ij++) {
//          repOfFixtures[i][ij] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//        }
//      }
    
    //FIXTURES---------------------------------------------------------------------------------------------------------------------------
    //Initialize fixtures using type
    int fL = fixtures.length;
    for (TableRow row : table.findRows("fixtureType1", "variable_name")) if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, int(row.getString("value")) ); }
    
    for (TableRow row : table.findRows("xTaka", "variable_name"))      if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].x_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("yTaka", "variable_name"))      if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].y_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("fixZ", "variable_name"))       if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].z_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("rotTaka", "variable_name"))    if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].rotationZ            = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("rotX", "variable_name"))       if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].rotationX            = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("fixParam", "variable_name"))   if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].parameter            = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("red", "variable_name"))        if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].red                  = int(row.getString("value")); }
    for (TableRow row : table.findRows("green", "variable_name"))      if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].green                = int(row.getString("value")); }
    for (TableRow row : table.findRows("blue", "variable_name"))       if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].blue                 = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("channel", "variable_name"))    if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].channelStart         = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("ansaParent", "variable_name")) if(fL > int(row.getString("1D"))) 
        { fixtures[int(row.getString("1D"))].parentAnsa           = int(row.getString("value")); }
    
    //--------------------------------------------------------------------------------------------------------------------------------------
    // whatToSave titles: { "dimmer", "colorWheel", "gobo", "goboRotation", "shutter", "pan", "tilt" }
    
    for (TableRow row : table.findRows("whatToSave", "variable_name")) if(int(row.getString("1D")) < whatToSave.length && int(row.getString("2D")) < whatToSave[0].length)
    {
      int val = int(row.getString("value"));
      
      whatToSave[int(row.getString("1D"))][int(row.getString("2D"))] = boolean(val);
    }
    
//    
//    
//    for (fixture[] fixs : repOfFixtures) for (fixture fix : fixs) fix = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[0], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      
//      
// 
//      
//      //fixture thisObj = repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))];
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].dimmer = int(row.getString("value"));
//    }
//    
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[1], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].colorWheel = int(row.getString("value"));
//    }
//    
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[2], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].goboWheel = int(row.getString("value"));
//    }
//    
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[3], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].goboRotation = int(row.getString("value"));
//    }
//    
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[4], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].shutter = int(row.getString("value"));
//    }
//    
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[5], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].pan = int(row.getString("value"));
//    }
//    
//    for (TableRow row : table.findRows("repOF:" + saveOptionButtonVariables[6], "variable_name")) if(int(row.getString("1D")) < repOfFixtures.length) if(int(row.getString("2D")) < repOfFixtures[0].length)
//    {
//      
//      if (repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] == null) repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))] = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
//      repOfFixtures[int(row.getString("1D"))][int(row.getString("2D"))].tilt = int(row.getString("value"));
//    }
//    
    //---------------------------------------------------------------------------------------------------------------------------------------
    
    for (TableRow row : table.findRows("memoryType", "variable_name")) if(int(row.getString("1D")) < memoryType.length) { memoryType[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("soundToLightSteps", "variable_name")) if(int(row.getString("1D")) < soundToLightSteps.length) { soundToLightSteps[int(row.getString("1D"))] = int(row.getString("value")); }
    
    
    
    int[] grouping = new int[4];
    for (TableRow row : table.findRows("grouping", "variable_name")) { grouping[int(row.getString("1D"))] = int(row.getString("value")); }
    controlP5place = grouping[0]; enttecDMXplace = grouping[1]; touchOSCplace = grouping[2];
          
    for (TableRow row : table.findRows("memory", "variable_name")) if(memory.length > int(row.getString("1D")) && memory[0].length > int(row.getString("2D")))
            { memory[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("soundToLightPresets", "variable_name")) if(soundToLightPresets.length > int(row.getString("2D")) && soundToLightPresets[0].length > int(row.getString("1D"))) 
            { soundToLightPresets[int(row.getString("2D"))][int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("preset", "variable_name")) if(preset.length > int(row.getString("1D")) && preset[0].length > int(row.getString("2D")))
            { preset[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("camX", "variable_name"))              { camX = int(row.getString("value")); }
    for (TableRow row : table.findRows("camY", "variable_name"))              { camY = int(row.getString("value")); }
    for (TableRow row : table.findRows("camZ", "variable_name"))              { camZ = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("bottomMenuOrder", "variable_name")) if(int(row.getString("1D")) < bottomMenuOrder.length) bottomMenuOrder[int(row.getString("1D"))] = int(row.getString("value"));
    
    
    for (TableRow row : table.findRows("ansaZ", "variable_name"))         { if((int(row.getString("1D")) < ansaZ.length)) { ansaZ[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaX", "variable_name"))         { if((int(row.getString("1D")) < ansaX.length)) { ansaX[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaY", "variable_name"))         { if((int(row.getString("1D")) < ansaY.length)) { ansaY[int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaType", "variable_name"))    { if((int(row.getString("1D")) < ansaType.length)) { ansaType[int(row.getString("1D"))] = int(row.getString("value")); } }
  
    
    for (TableRow row : table.findRows("chaseModeByMemoryNumber", "variable_name"))              { chaseModeByMemoryNumber[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("chaseMode", "variable_name"))              { chaseMode = int(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("valueOfMemory", "variable_name")) if(valueOfMemory.length > int(row.getString("1D")))
          { valueOfMemory[int(row.getString("1D"))] = int(row.getString("value")); }
    for (TableRow row : table.findRows("memoryValue", "variable_name")) if(memoryValue.length > int(row.getString("1D")))
          { memoryValue[int(row.getString("1D"))] = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("centerX", "variable_name"))              { centerX = int(row.getString("value")); }
    for (TableRow row : table.findRows("centerY", "variable_name"))              { centerY = int(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("mhx50_createFinalPresetValues[1D][0][2D]", "variable_name"))         if((int(row.getString("2D")) < mhx50_createFinalPresetValues.length) && (int(row.getString("1D")) < mhx50_createFinalPresetValues[0][0].length)) {     { mhx50_createFinalPresetValues[int(row.getString("2D"))][0][int(row.getString("1D"))] = int(row.getString("value")); } }
    for (TableRow row : table.findRows("mhx50_createFinalPresetValues[1D][1][2D]", "variable_name"))         if((int(row.getString("2D")) < mhx50_createFinalPresetValues.length) && (int(row.getString("1D")) < mhx50_createFinalPresetValues[0][0].length)) {     { mhx50_createFinalPresetValues[int(row.getString("2D"))][1][int(row.getString("1D"))] = int(row.getString("value")); } }

    
    
    dataLoaded = true;
    
    
  
}
