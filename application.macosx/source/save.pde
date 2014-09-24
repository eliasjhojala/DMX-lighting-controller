//Tässä välilehdessä tallennetaan tietoja csv-taulukkotiedostoon

Table table;
void saveAllData() {
    table = new Table();
  
  table.addColumn("id");
  table.addColumn("variable_name");
  table.addColumn("variable_dimensions");
  table.addColumn("value");
  table.addColumn("1D");
  table.addColumn("2D");

  
  for(int i = 0; i < xTaka.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "xTaka");
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(xTaka[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i < yTaka.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "yTaka"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(yTaka[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  for(int i = 0; i < rotX.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "rotX"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(rotX[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  for(int i = 0; i < fixZ.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixZ"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixZ[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaZ.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaZ"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaZ[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaX.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaX"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaX[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaY.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaY"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaY[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }


  for(int i = 0; i < ansaParent.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaParent"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaParent[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaType.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaType"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaType[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }

  
  for(int i = 0; i <  memoryType.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "memoryType"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(memoryType[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  soundToLightSteps.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "soundToLightSteps"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(soundToLightSteps[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  red.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "red"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(red[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  green.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "green"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(green[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  blue.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "blue"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(blue[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  rotTaka.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "rotTaka"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(rotTaka[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  rotX.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "rotX"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(rotX[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  fixZ.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixZ"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixZ[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixParam.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixParam"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixParam[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureType1.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureType1"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureType1[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  channel.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "channel"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(channel[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureIdNow.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureIdNow"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureIdNow[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureIdOriginal.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureIdOriginal"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureIdOriginal[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureIdPlaceInArray.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureIdPlaceInArray"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureIdPlaceInArray[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  
  
  
  
  
  
  for(int i = 0; i <  chaseModeByMemoryNumber.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "chaseModeByMemoryNumber"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(chaseModeByMemoryNumber[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  valueOfMemory.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "valueOfMemory"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(valueOfMemory[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
 
 for(int i = 0; i <  memoryValue.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "memoryValue"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(memoryValue[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
 
  
  
  int[] grouping = new int[4];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        grouping[3] = int(useMovingHead);
  for(int i = 0; i <  grouping.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "grouping"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(grouping[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int a = 0; a < numberOfMemories; a++) {
    for(int i = 0; i <  channels+5; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "memory"); 
      newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(memory[a][i]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  for(int a = 0; a < numberOfMemories; a++) {
    for(int i = 0; i <  channels*2; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "soundToLightPresets"); 
      newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(soundToLightPresets[a][i]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  for(int a = 0; a < numberOfMemories; a++) {
    for(int i = 0; i <  channels*2; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "preset"); 
      newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(preset[a][i]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  
  
  
 
  
  TableRow newRow = table.addRow();     
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "camX"); 
  newRow.setString("variable_dimensions", "1"); 
  newRow.setString("value", str(camX));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "camY"); 
  newRow.setString("variable_dimensions", "1"); 
  newRow.setString("value", str(camY));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "camZ"); 
  newRow.setString("variable_dimensions", "1"); 
  newRow.setString("value", str(camZ));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "chaseMode"); 
  newRow.setString("variable_dimensions", "0"); 
  newRow.setString("value", str(chaseMode));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "centerX"); 
  newRow.setString("variable_dimensions", "0"); 
  newRow.setString("value", str(centerX));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "centerY"); 
  newRow.setString("variable_dimensions", "0"); 
  newRow.setString("value", str(centerY));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  //Asetetaan oikeat tallennuspolut käyttäjän mukaan

  if(userId == 1) { //Jos Elias käyttää
    saveTable(table, "/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv"); //Eliaksen polku
  }
  else { //Jos Roope käyttää
    saveTable(table, "E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv"); //Roopen polku
  }
}

