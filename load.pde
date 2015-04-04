//Load all the data from csv file and xml files
boolean dataLoaded = false;
boolean programReadyToRun = false;

boolean loadFast = !showMode;
boolean loadSafe = showMode;

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
boolean fixtureProfilesLoaded = false;
boolean loadingAllData;

int wholeLoadTimeAsMilliSeconds;
boolean wholeLoadTimeAsMilliSecondsIsCounted;

long loadDataBeginMillis;

boolean loadedOnce = false;

void loadAllData1() {
  if(!savingDataAtTheTime()) {
    loadingAllData = true;
    wholeLoadTimeAsMilliSecondsIsCounted = false;
    loadDataBeginMillis = millis();
    if(!loadingFixtureProfiles) { loadFixtureProfiles(); }
    
       table = loadTable(loadPath, "header"); //Eliaksen polku
  
      programReadyToRun = false;

  
      int[] grouping = new int[3];
  
      
      for (TableRow row : table.findRows("camX", "variable_name"))              { cam.x = int(row.getString("value")); }
      for (TableRow row : table.findRows("camY", "variable_name"))              { cam.y = int(row.getString("value")); }
      for (TableRow row : table.findRows("camZ", "variable_name"))              { cam.z = int(row.getString("value")); }
      
      for (TableRow row : table.findRows("bottomMenuOrder", "variable_name")) if(int(row.getString("1D")) < bottomMenuOrder.length) bottomMenuOrder[int(row.getString("1D"))] = int(row.getString("value"));
  
      
      for (TableRow row : table.findRows("chaseMode", "variable_name"))              { chaseMode = int(row.getString("value")); }
      
      for (TableRow row : table.findRows("centerX", "variable_name"))              { center.x = int(row.getString("value")); }
      for (TableRow row : table.findRows("centerY", "variable_name"))              { center.y = int(row.getString("value")); }
     
    
      
      
      
      
      dataLoaded = true;
      programReadyToRun = true;

      if(!savingNearestSocketsToXML) { saveNearestSocketsToXML(); }
      
      loadShowFileFromXML();
      
      doAfterLoad();
      loadingAllData = false;
  }
}

boolean loadingDataAtTheTime() {
  boolean toReturn = loadinMemoriesFromXML || savingNearestSocketsToXML || loadingFixtureProfiles || loadingAllData || loadingMidiData;
  if(!toReturn && !wholeLoadTimeAsMilliSecondsIsCounted) {
     wholeLoadTimeAsMilliSeconds = round(millis() - loadDataBeginMillis);
     wholeLoadTimeAsMilliSecondsIsCounted = true;
     notifier.notify("Load complete. (" + str(wholeLoadTimeAsMilliSeconds) + "ms)");
     loadedOnce = dataLoaded;
  }
  return toReturn;
}

boolean loadingDataRecently() {
  return loadingDataAtTheTime() || (millis()-(loadDataBeginMillis+(wholeLoadTimeAsMilliSeconds)) < 5000);
}
