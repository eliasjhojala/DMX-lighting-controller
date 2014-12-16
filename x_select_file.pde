String coreFilePath = "core.csv";
boolean inputIsSelected = true;

void inputSelected(File selection) {   
  if (selection != null) {
    loadPath = selection.getAbsolutePath(); 
    saveCoreData(); 
  }
  inputIsSelected = true;
  loadAllData();
}
void outputSelected(File selection) {    
  if (selection != null) {
    savePath = selection.getAbsolutePath() + ".csv"; 
    saveCoreData(); 
    saveAllData(); 
  }
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
