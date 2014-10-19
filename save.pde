//Tässä välilehdessä tallennetaan tietoja csv-taulukkotiedostoon

Table table;

void saveVariable(int variable, String variableName) {
    saveDataMainCommands(str(variable), variableName, "0", "-", "-");
}
void save1Darray(int[] array, String arrayName) {
  for(int i = 0; i < array.length; i++) {
    saveDataMainCommands(str(array[i]), arrayName, "1", str(i), "-");
  }
}
void save1DarrayString(String[] array, String arrayName) {
  for(int i = 0; i < array.length; i++) {
    saveDataMainCommands(array[i], arrayName, "1", str(i), "-");
  }
}

void save2Darray(int[][] array, String arrayName) {
  for(int ij = 0; ij < array.length; ij++) {
    println(ij); 
    for(int i = 0; i < array[0].length; i++) {
      saveDataMainCommands(str(array[ij][i]), arrayName, "2", str(i), str(ij));
    }
  }
}

void saveDataMainCommands(String variable, String variableName, String dimensions, String D1, String D2) {
  TableRow newRow = table.addRow();   
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", variableName);
  newRow.setString("variable_dimensions", dimensions); 
  newRow.setString("value", variable);   
  newRow.setString("1D", D1);               
  newRow.setString("2D", D2);
}

void saveAllData() {
  table = new Table();
  
  table.addColumn("id");
  table.addColumn("variable_name");
  table.addColumn("variable_dimensions");
  table.addColumn("value");
  table.addColumn("1D");
  table.addColumn("2D");
  
  for (int i = 0; i < fixtures.length; i++) {
    saveDataMainCommands(str(fixtures[i].red),           "red", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].green),         "green", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].blue),          "blue", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].x_location),    "xTaka", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].y_location),    "yTaka", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].z_location),    "fixZ", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].rotationX),     "rotX", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].rotationZ),     "rotTaka", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].parameter),     "fixParam", "1", str(i), "-");
    saveDataMainCommands(fixtures[i].fixtureType,        "fixtureTypeS", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].fixtureTypeId), "fixtureType1", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].channelStart),  "channel", "1", str(i), "-");
    saveDataMainCommands(str(fixtures[i].parentAnsa),    "ansaParent", "1", str(i), "-");
  }
  
  
  save1Darray(ansaZ, "ansaZ");
  save1Darray(ansaX, "ansaX");
  save1Darray(ansaY, "ansaY");
  save1Darray(ansaType, "ansaType");
  save1Darray(memoryType, "memoryType");
  save1Darray(soundToLightSteps, "soundToLightSteps");
  save1Darray(ansaX, "ansaX");
  save1Darray(mhx50_s2l_presets, "mhx50_s2l_presets"); 
  save1Darray(chaseModeByMemoryNumber, "chaseModeByMemoryNumber"); 
  save1Darray(valueOfMemory, "valueOfMemory"); 
  save1Darray(memoryValue, "memoryValue"); 
  
  
  
  
  int[] grouping = new int[4];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        grouping[3] = int(useMovingHead);
        
  save1Darray(grouping, "grouping"); 
  
  
  save2Darray(memory, "memory");
  save2Darray(soundToLightPresets, "soundToLightPresets");
  save2Darray(preset, "preset");

  
  for(int a = 0; a < mhx50_createFinalPresetValues[0][0].length; a++) {
    for(int i = 0; i <  mhx50_createFinalPresetValues.length; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "mhx50_createFinalPresetValues[1D][0][2D]"); 
      newRow.setString("variable_dimensions", "2"); newRow.setString("value", str(mhx50_createFinalPresetValues[i][0][a]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  
  for(int a = 0; a < mhx50_createFinalPresetValues[0][0].length; a++) {
    for(int i = 0; i <  mhx50_createFinalPresetValues.length; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "mhx50_createFinalPresetValues[1D][1][2D]"); 
      newRow.setString("variable_dimensions", "2"); newRow.setString("value", str(mhx50_createFinalPresetValues[i][1][a]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  
  
  
  saveVariable(int(camX), "camX");
  saveVariable(int(camY), "camY");
  saveVariable(int(camZ), "camZ");
  saveVariable(int(centerX), "centerX");
  saveVariable(int(centerY), "centerY");
  saveVariable(chaseMode, "chaseMode");
  saveVariable(mmhx50_s2l_numberOfPresets, "mmhx50_s2l_numberOfPresets");
  

  //Asetetaan oikeat tallennuspolut käyttäjän mukaan

  if(userId == 1) { //Jos Elias käyttää
    saveTable(table, "/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv"); //Eliaksen polku
  } else if(!roopeAidilla)

    saveTable(table, "E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv"); //Roopen polku
  } else saveTable(table, "C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv");
}

