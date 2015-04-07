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
    

      programReadyToRun = false;

      
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
