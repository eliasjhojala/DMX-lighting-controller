String coreFilePath = "core.csv";
boolean inputIsSelected = true;

FileSelect lastFileSelect;

void inputSelected(File selection) {
  if(lastFileSelect != null) lastFileSelect.inputSelected(selection);
}
void outputSelected(File selection) {
  if(lastFileSelect != null) lastFileSelect.outputSelected(selection);
}
void fileDialogInput() {
  inputIsSelected = false;
  selectInput("Select a CSV File to Load Data From", "inputSelected");
}
void fileDialogOutput() {
  selectOutput("Save Configuration to CSV", "outputSelected");
}

void saveCoreDataMainFunction(String variableName, String variable) {
  TableRow newRow = table.addRow();
  newRow.setInt("id", table.lastRowIndex());
  newRow.setString("variableName", variableName);
  newRow.setString("value", variable);
}

String loadCoreDataMainFunction(String variableName) {
  String toReturn = "";
    for (TableRow row : table.findRows(variableName, "variableName")) {
      toReturn = row.getString("value");
    }
  return toReturn;
}

void saveCoreData() {
  table = new Table();
  
  table.addColumn("id");
  table.addColumn("variableName");
  table.addColumn("value");
  
  saveCoreDataMainFunction("savePath", savePath);
  saveCoreDataMainFunction("loadPath", loadPath);
  
  saveTable(table, coreFilePath);
}
void loadCoreData() {
  try {
    table = loadTable(coreFilePath, "header");
    savePath = loadCoreDataMainFunction("savePath");
    loadPath = loadCoreDataMainFunction("loadPath");
    println("Core file load succes");
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

class FileSelect {
  FileSelect() {}
  FileSelect(String mode, String text) {
    if(mode.equals("Output")) {
      fileDialogOutput(text);
    }
    else if(mode.equals("Input")) {
      fileDialogInput(text);
    }
  }
  
  boolean pathChanged;
  String path;
  
  void inputSelected(File selection) {
    if (selection != null) {
      path = selection.getAbsolutePath();
      pathChanged = true;
    }
  }
  void outputSelected(File selection) {
    if (selection != null) {
      path = selection.getAbsolutePath();
      pathChanged = true;
    }
  }
  void fileDialogInput(String text) {
    lastFileSelect = this;
    selectInput(text, "inputSelected");
  }
  void fileDialogOutput(String text) {
    lastFileSelect = this;
    selectOutput(text, "outputSelected");
  }
  
  boolean pathChanged() {
    boolean toReturn = pathChanged;
    pathChanged = false;
    return toReturn;
  }
  
  String getPath() {
    return path;
  }
}

FileSelectWindow fileSelectWindow = new FileSelectWindow();

class FileSelectWindow {
  Window window;
  int locX, locY, w, h;
  boolean open;
  
  boolean selectingFixtureFile = false;
  boolean selectingFixtureSaveFile = false;
  
  boolean selectingTrussLoadFile = false;
  boolean selectingTrussSaveFile = false;
  
  boolean selectingSocketLoadFile = false;
  boolean selectingSocketSaveFile = false;
  
  FileSelect fileSelect = new FileSelect();
  
  FileSelectWindow() {
    w = 1000; h = 500;
    window = new Window("fileSelectWindow", new PVector(w, h), this);
  }
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    
    g.fill(0);
    g.translate(60, 60);
    PushButton fixtureFile = new PushButton("fixtureFile");
    g.textAlign(LEFT);
    g.text("Open fixture file", 30, 12);
    if(fixtureFile.isPressed(g, mouse)) { selectingFixtureFile = true; fileSelect = new FileSelect("Input", "Open fixture file"); }
    if(selectingFixtureFile) { if(fileSelect.pathChanged()) {
        XMLtoFixtures(loadXML(fileSelect.getPath()));
        fixturesExternalFile = fileSelect.getPath();
        selectingFixtureFile = false;
        loadedFixturesFromExternalFile = true;
      }
    }
    
    
    g.translate(0, 30);
    PushButton fixtureSaveFile = new PushButton("fixtureSaveFile");
    g.textAlign(LEFT);
    g.text("Open fixture file", 30, 12);
    if(fixtureSaveFile.isPressed(g, mouse)) { selectingFixtureSaveFile = true; fileSelect = new FileSelect("Output", "Save fixture file"); }
    if(selectingFixtureSaveFile) { if(fileSelect.pathChanged()) {
        saveXML(getFixturesXML(), fileSelect.getPath());
        fixturesExternalFile = fileSelect.getPath();
        loadedFixturesFromExternalFile = true;
        selectingFixtureSaveFile = false;
        }
    }
    
    
    
    
    g.translate(0, 60);
    

    PushButton trussLoadFile = new PushButton("trussLoadFile");
    g.text("Open truss file", 30, 12);
    if(trussLoadFile.isPressed(g, mouse)) { selectingTrussLoadFile = true; fileSelect = new FileSelect("Input", "Open truss file"); }
    if(selectingTrussLoadFile) { if(fileSelect.pathChanged()) {
        XMLtoTrusses(loadXML(fileSelect.getPath()));
        trussesExternalFile = fileSelect.getPath();
        selectingTrussLoadFile = false;
        loadedTrussesFromExternalFile = true;
      }
    }
    
    
    g.translate(0, 30);
    PushButton trussSaveFile = new PushButton("trussSaveFile");
    g.text("Save truss file", 30, 12);
    if(trussSaveFile.isPressed(g, mouse)) { selectingTrussSaveFile = true; fileSelect = new FileSelect("Output", "Save truss file"); }
    if(selectingTrussSaveFile) { if(fileSelect.pathChanged()) {
        saveXML(getTrussesAsXML(), fileSelect.getPath());
        trussesExternalFile = fileSelect.getPath();
        selectingTrussSaveFile = false;
        loadedTrussesFromExternalFile = true;
      }
    }
    
    
    g.translate(0, 60);
    

    PushButton socketLoadFile = new PushButton("socketLoadFile");
    g.text("Open socket file", 30, 12);
    if(socketLoadFile.isPressed(g, mouse)) { selectingSocketLoadFile = true; fileSelect = new FileSelect("Input", "Open socket file"); }
    if(selectingSocketLoadFile) { if(fileSelect.pathChanged()) {
        XMLtoSockets(loadXML(fileSelect.getPath()));
        socketsExternalFile = fileSelect.getPath();
        selectingSocketLoadFile = false;
        loadedSocketsFromExternalFile = true;
      }
    }
    
    
    g.translate(0, 30);
    PushButton socketSaveFile = new PushButton("socketSaveFile");
    g.text("Save socket file", 30, 12);
    if(socketSaveFile.isPressed(g, mouse)) { selectingSocketSaveFile = true; fileSelect = new FileSelect("Output", "Save socket file"); }
    if(selectingSocketSaveFile) { if(fileSelect.pathChanged()) {
        saveXML(getSocketsAsXML(), fileSelect.getPath());
        socketsExternalFile = fileSelect.getPath();
        selectingSocketSaveFile = false;
        loadedSocketsFromExternalFile = true;
      }
    }
    
  }
  
  
  
}
