//Tässä välilehdessä tallennetaan tietoja csv-taulukkotiedostoon

Table table;

void save0dDataToTable(String variableName, int value) {
    setVariableDataToTable(variableName, "0", "0", "-", str(value));
}
void save1dDataToTable(String variableName, int[] value) {
  for(int i = 0; i < value.length; i++) {           
    setVariableDataToTable(variableName, "1", str(i), "-", str(value[i]));
  }
}
void save2dDataToTable(String variableName, int[][] value, int length1, int length2) {
  for(int a = 0; a < length1; a++) {
    for(int i = 0; i < length2; i++) {           
      setVariableDataToTable(variableName, "2", str(a), str(i), str(value[a][i]));
    }
  }
}
void setVariableDataToTable(String variableName, String variableDimensions, String D1, String D2, String value) {
    TableRow newRow = table.addRow(); 
    newRow.setInt("id", table.lastRowIndex());  
    newRow.setString("variable_name", variableName);
    newRow.setString("variable_dimensions", variableDimensions); 
    newRow.setString("1D", D1);               
    newRow.setString("2D", D2);
    newRow.setString("value", value);
}
void saveAllData() {
  table = new Table();
  
  table.addColumn("id");
  table.addColumn("variable_name");
  table.addColumn("variable_dimensions");
  table.addColumn("value");
  table.addColumn("1D");
  table.addColumn("2D");


  save1dDataToTable("xTaka", xTaka);
  save1dDataToTable("yTaka", yTaka);
  save1dDataToTable("rotX", rotX);
  save1dDataToTable("fixZ", fixZ);
  save1dDataToTable("ansaZ", ansaZ);
  save1dDataToTable("ansaX", ansaX);
  save1dDataToTable("ansaY", ansaY);
  save1dDataToTable("ansaParent", ansaParent);
  save1dDataToTable("memoryType", memoryType);
  save1dDataToTable("soundToLightSteps", soundToLightSteps);
  save1dDataToTable("red", red);
  save1dDataToTable("green", green);
  save1dDataToTable("blue", blue);
  save1dDataToTable("rotTaka", rotTaka);
  save1dDataToTable("rotX", rotX);
  save1dDataToTable("fixZ", fixZ);
  save1dDataToTable("fixParam", fixParam);
  save1dDataToTable("fixtureType1", fixtureType1);
  save1dDataToTable("channel", channel);
  save1dDataToTable("fixtureIdNow", fixtureIdNow);
  save1dDataToTable("fixtureIdOriginal", fixtureIdOriginal);
  save1dDataToTable("fixtureIdPlaceInArray", fixtureIdPlaceInArray);
  
  save1dDataToTable("chaseModeByMemoryNumber", chaseModeByMemoryNumber);
  save1dDataToTable("valueOfMemory", valueOfMemory);
  save1dDataToTable("memoryValue", memoryValue);
   
  int[] grouping = new int[4];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        grouping[3] = int(useMovingHead);
  for(int i = 0; i <  grouping.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "grouping"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(grouping[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
    
  save2dDataToTable("memory", memory, numberOfMemories, channels+5);
  save2dDataToTable("soundToLightPresets", soundToLightPresets, numberOfMemories, channels*2);
  save2dDataToTable("preset", preset, numberOfMemories, channels*2);
  save2dDataToTable("mhx50_createFinalPresetValues[1D][0][2D]", preset, mhx50_createFinalPresetValues[0][0].length, mhx50_createFinalPresetValues.length);
  
  for(int b = 0; b <= 1; b++) {
    for(int a = 0; a < mhx50_createFinalPresetValues[0][0].length; a++) {
      for(int i = 0; i <  mhx50_createFinalPresetValues.length; i++) {
        TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "mhx50_createFinalPresetValues[1D][0][2D]"); 
        newRow.setString("variable_dimensions", "2"); newRow.setString("value", str(mhx50_createFinalPresetValues[i][b][a]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
      }
    }
  }    
  
  save0dDataToTable("camX", int(camX));
  save0dDataToTable("camY", int(camY));
  save0dDataToTable("camZ", int(camZ));
  save0dDataToTable("chaseMode", chaseMode);
  save0dDataToTable("centerX", centerX);
  save0dDataToTable("centerY", centerY);
  
  //Asetetaan oikeat tallennuspolut käyttäjän mukaan

  if(userId == 1) { //Jos Elias käyttää
    saveTable(table, "/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv"); //Eliaksen polku
  }
  else { //Jos Roope käyttää
    saveTable(table, "E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv"); //Roopen polku
  }
}

