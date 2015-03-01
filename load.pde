//Tässä välilehdessä luetaan aikaisemmin tallennettuja tietoja csv-taulukkotiedostosta
boolean dataLoaded = false;
boolean programReadyToRun = false; 
void loadSetupData() {
  showOutputAsNumbers = true;
}

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
void loadAllData1() {
    loadSetupData();

     table = loadTable(loadPath, "header"); //Eliaksen polku

        
   
    //FIXTURES---------------------------------------------------------------------------------------------------------------------------
    //Initialize fixtures using type
    fixtures.clear();
    for(TableRow row : table.findRows("idLookupTable", "variable_name")) {
      idLookupTable.add(int(row.getString("value")));
    }
    
  
    
    //fixtures.array.ensureCapacity(int(table.findRow("fixtures.size", "variable_name").getString("value")));
    
    for (TableRow row : table.findRows("fixtureType1", "variable_name")) 
        { 
          fixtures.array.add(int(row.getString("1D")), new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, int(row.getString("value"))));
        
        }
    
    
    for (TableRow row : table.findRows("xTaka", "variable_name"))      if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).x_location           = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("yTaka", "variable_name"))      if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).y_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("fixZ", "variable_name"))       if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).z_location           = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("rotTaka", "variable_name"))    if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).rotationZ            = int(row.getString("value")); }
        
    for (TableRow row : table.findRows("rotX", "variable_name"))       if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).rotationX            = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("fixParam", "variable_name"))   if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).parameter            = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("red", "variable_name"))        if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).red                  = int(row.getString("value")); }
    for (TableRow row : table.findRows("green", "variable_name"))      if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).green                = int(row.getString("value")); }
    for (TableRow row : table.findRows("blue", "variable_name"))       if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).blue                 = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("channel", "variable_name"))    if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).channelStart         = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("ansaParent", "variable_name")) if(fixtures.array.size() > int(row.getString("1D"))) 
        { fixtures.array.get(int(row.getString("1D"))).parentAnsa           = int(row.getString("value")); }
    
    //--------------------------------------------------------------------------------------------------------------------------------------




    //---------------------------------------------------------------------------------------------------------------------------------------

    int[] grouping = new int[3];
    for (TableRow row : table.findRows("grouping", "variable_name")) if(int(row.getString("1D")) < grouping.length) { grouping[int(row.getString("1D"))] = int(row.getString("value")); }
    controlP5place = grouping[0]; enttecDMXplace = grouping[1]; touchOSCplace = grouping[2];
          

    
    for (TableRow row : table.findRows("camX", "variable_name"))              { cam.x = int(row.getString("value")); }
    for (TableRow row : table.findRows("camY", "variable_name"))              { cam.y = int(row.getString("value")); }
    for (TableRow row : table.findRows("camZ", "variable_name"))              { cam.z = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("bottomMenuOrder", "variable_name")) if(int(row.getString("1D")) < bottomMenuOrder.length) bottomMenuOrder[int(row.getString("1D"))] = int(row.getString("value"));

    
    for (TableRow row : table.findRows("chaseMode", "variable_name"))              { chaseMode = int(row.getString("value")); }
    
    for (TableRow row : table.findRows("centerX", "variable_name"))              { center.x = int(row.getString("value")); }
    for (TableRow row : table.findRows("centerY", "variable_name"))              { center.y = int(row.getString("value")); }
    
  
    
    dataLoaded = true;
    
    
  
}
