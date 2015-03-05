//Tässä välilehdessä tallennetaan tietoja csv-taulukkotiedostoon

Table table;

void saveVariable(int variable, String variableName) {
  if(variable != 0) { //Don't save zero values
    saveDataMainCommands(str(variable), variableName, "0", "-", "-");
  }
}
void save1Darray(int[] array, String arrayName) {
  for(int i = 0; i < array.length; i++) {
    if(array[i] != 0) { //Don't save zero values
      saveDataMainCommands(str(array[i]), arrayName, "1", str(i), "-");
    }
  }
}
void save1DarrayString(String[] array, String arrayName) {
  for(int i = 0; i < array.length; i++) {
    saveDataMainCommands(array[i], arrayName, "1", str(i), "-");
  }
}

void save2Darray(int[][] array, String arrayName) {
  for(int ij = 0; ij < array.length; ij++) {
    for(int i = 0; i < array[0].length; i++) {
      if(array[ij][i] != 0) { //Don't save zero values
        saveDataMainCommands(str(array[ij][i]), arrayName, "2", str(i), str(ij));
      }
    }
  }
}

void save2DarrayBoolean(boolean[][] array, String arrayName) {
  for(int ij = 0; ij < array.length; ij++) {
    for(int i = 0; i < array[0].length; i++) {
      if(array[ij][i]) { //Don't save false values (0)
        saveDataMainCommands(str(int(array[ij][i])), arrayName, "2", str(ij), str(i));
      }
    }
  }
}

void saveDataMainCommands(String variable, String variableName, String dimensions, String D1, String D2) {
  if(variable != null) {
    if(!(variable.equals("0")) && !(variable.equals("false"))) { //Don't save zero values
      TableRow newRow = table.addRow();
      newRow.setInt("id", table.lastRowIndex());
      newRow.setString("variable_name", variableName);
      newRow.setString("variable_dimensions", dimensions);
      newRow.setString("value", variable);
      newRow.setString("1D", D1);
      newRow.setString("2D", D2);
    }
  }
}

void saveDataBYPASSZERO(String variable, String variableName, String dimensions, String D1, String D2) {
  if(variable != null) {
    //if(!(variable.equals("0")) && !(variable.equals("false"))) { //Don't save zero values
      TableRow newRow = table.addRow();
      newRow.setInt("id", table.lastRowIndex());
      newRow.setString("variable_name", variableName);
      newRow.setString("variable_dimensions", dimensions);
      newRow.setString("value", variable);
      newRow.setString("1D", D1);
      newRow.setString("2D", D2);
    //}
  }
}

void saveAllData() {
  long saveDataBeginMillis = millis();
  table = new Table();
  
  table.addColumn("id");
  table.addColumn("variable_name");
  table.addColumn("variable_dimensions");
  table.addColumn("value");
  table.addColumn("1D");
  table.addColumn("2D");
  
  
  
  for (int i = 0; i < idLookupTable.size(); i++) {
    saveDataBYPASSZERO(str(idLookupTable.get(i)), "idLookupTable", "1", str(i), "-");
    
  }
  saveDataBYPASSZERO(str(fixtures.array.size()), "fixtures.size", "0", "-", "-");
  for (int i = 0; i < fixtures.array.size(); i++) {
      saveDataMainCommands(str(fixtures.array.get(i).red),           "red", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).green),         "green", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).blue),          "blue", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).x_location),    "xTaka", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).y_location),    "yTaka", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).z_location),    "fixZ", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).rotationX),     "rotX", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).rotationZ),     "rotTaka", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).parameter),     "fixParam", "1", str(i), "-");
      saveDataMainCommands(fixtures.array.get(i).fixtureType,        "fixtureTypeS", "1", str(i), "-");
      saveDataBYPASSZERO(str(fixtures.array.get(i).fixtureTypeId), "fixtureType1", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).channelStart),  "channel", "1", str(i), "-");
      saveDataMainCommands(str(fixtures.array.get(i).parentAnsa),    "ansaParent", "1", str(i), "-");
  }



  save1Darray(bottomMenuOrder, "bottomMenuOrder");
  

  
  int[] grouping = new int[3];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        
  save1Darray(grouping, "grouping");
  

  saveVariable(int(cam.x), "camX");
  saveVariable(int(cam.y), "camY");
  saveVariable(int(cam.z), "camZ");
  saveVariable(int(center.x), "centerX");
  saveVariable(int(center.y), "centerY");
  saveVariable(chaseMode, "chaseMode");
  
  saveDataMainCommands(loadPath, "loadPath", "0", "-", "-");
   

  //Asetetaan oikeat tallennuspolut käyttäjän mukaan
  println(savePath);
  try {
    saveTable(table, savePath, "csv");
    saveSocketsToXML();
    saveTrussesAsXML();
    saveMemoriesToXML();
    saveTestXML();
   
  } catch (Exception e) {
    e.printStackTrace();
    notifier.notify("Save failed! Try again by saving to another location by pressing SHIFT + S", true);
  }
  

  long takedTime = millis() - saveDataBeginMillis;
  notifier.notify("Save complete. (" + str(takedTime) + "ms)");
}
