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

int wholeSaveTimeAsMilliSeconds;
boolean wholeSaveTimeAsMilliSecondsIsCounted;
boolean savingAllData;
long saveDataBeginMillis;

void saveAllData() {
  if(!loadingDataAtTheTime()) {
    if(loadedOnce) {
      savingAllData = true;
      wholeSaveTimeAsMilliSecondsIsCounted = false;
      saveDataBeginMillis = millis();

    
      //Asetetaan oikeat tallennuspolut käyttäjän mukaan
      notifier.notify("Started saving to " + showFilePath, false);
      try {
        saveNearestSocketsToXML();

        SaveChannelsAsPdf();

        saveShowFileXML();
      } catch (Exception e) {
        e.printStackTrace();
        notifier.notify("Save failed! Try again by saving to another location by pressing SHIFT + S", true);
      }
      
      savingAllData = false;
    }
    else {
      notifier.notify("You can't save before you have loaded once", true);
    }
  }
}

boolean savingDataAtTheTime() {
  boolean toReturn = savingSocketsToXML || savingTrussesToXML || savingMemoriesToXML || savingTestXML || savingAllData || savingMidiData;
  if(!toReturn && !wholeSaveTimeAsMilliSecondsIsCounted) {
     wholeSaveTimeAsMilliSeconds = round(millis() - saveDataBeginMillis);
     wholeSaveTimeAsMilliSecondsIsCounted = true;
     notifier.notify("Save complete. (" + str(wholeSaveTimeAsMilliSeconds) + "ms)");
  }
  return toReturn;
}

boolean savingDataRecently() {
  return savingDataAtTheTime() || (millis()-(saveDataBeginMillis+(wholeSaveTimeAsMilliSeconds)) < 5000);
}
