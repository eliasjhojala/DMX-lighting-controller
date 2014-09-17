
void loadAllData() {
  
  if(userId == 1) {
   table = loadTable("/Users/elias/Dropbox/DMX controller/main/variables/new.csv", "header"); //Eliaksen polku
  }
  else {
   table = loadTable("E:\\Dropbox\\DMX controller\\main\\variables\\new.csv", "header"); //Roopen polku
  }

  println(table.getRowCount() + " total rows in table1"); 

//  for (TableRow row1 : table1.rows()) {
//    
//    int id = row1.getInt("id");
//    String variable_name = row1.getString("variable_name");
//    String value = row1.getString("value");
//    String D1 = row1.getString("1D");
//    if(variable_name == "xTaka") {
//      xTaka[int(D1)] = int(value);
//    }
//    if(variable_name == "yTaka") {
//      yTaka[int(D1)] = int(value);
//    }
//  }
  
  
  for (TableRow row : table.findRows("xTaka", "variable_name")) { xTaka[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("yTaka", "variable_name")) { yTaka[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("rotX", "variable_name")) { rotX[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("fixZ", "variable_name")) { fixZ[int(row.getString("1D"))] = int(row.getString("value")); }
  
  for (TableRow row : table.findRows("memoryType", "variable_name")) { memoryType[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("soundToLightSteps", "variable_name")) { soundToLightSteps[int(row.getString("1D"))] = int(row.getString("value")); }
  
  for (TableRow row : table.findRows("red", "variable_name")) { red[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("green", "variable_name")) { green[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("blue", "variable_name")) { blue[int(row.getString("1D"))] = int(row.getString("value")); }
  
  for (TableRow row : table.findRows("rotTaka", "variable_name")) { rotTaka[int(row.getString("1D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("fixtureType1", "variable_name")) { fixtureType1[int(row.getString("1D"))] = int(row.getString("value")); }
  
  int[] grouping = new int[4];
  for (TableRow row : table.findRows("grouping", "variable_name")) { grouping[int(row.getString("1D"))] = int(row.getString("value")); }
  controlP5place = grouping[0]; enttecDMXplace = grouping[1]; touchOSCplace = grouping[2];
        
  for (TableRow row : table.findRows("memory", "variable_name"))              { memory[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("soundToLightPresets", "variable_name")) { soundToLightPresets[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
  for (TableRow row : table.findRows("preset", "variable_name"))              { preset[int(row.getString("1D"))][int(row.getString("2D"))] = int(row.getString("value")); }
  
  for (TableRow row : table.findRows("camX", "variable_name"))              { camX = int(row.getString("value")); }
  for (TableRow row : table.findRows("camY", "variable_name"))              { camY = int(row.getString("value")); }
  for (TableRow row : table.findRows("camZ", "variable_name"))              { camZ = int(row.getString("value")); }
  
}
void loadAllDataWithOldMethod() {
    String lines[] = loadStrings(loadPath + "variables/xTaka.txt");
    for (int i = 0; i < lines.length; i++) {
      xTaka[i] = int(lines[i]);
    }
    String lines1[] = loadStrings(loadPath + "variables/yTaka.txt");
    for (int i = 0; i < lines1.length; i++) {
      yTaka[i] = int(lines1[i]);
    }
//    String lines2[] = loadStrings(loadPath + "variables/xEtu.txt");
//    for (int i = 0; i < lines2.length; i++) {
//      xEtu[i] = int(lines2[i]);
//    }
//    String lines3[] = loadStrings(loadPath + "variables/yEtu.txt");
//    for (int i = 0; i < lines3.length; i++) {
//      yEtu[i] = int(lines3[i]);
//    }
    String lines4[] = loadStrings(loadPath + "variables/chGroup.txt");
    controlP5place = int(lines4[0]);
    enttecDMXplace = int(lines4[1]);
    touchOSCplace = int(lines4[2]);
    
    
    for (int i = 0; i < 100; i++) {
      memory[i] = int(loadStrings(loadPath + "variables/memories/memory"+str(i)+".txt"));
    }
    for(int i = 0; i < 100; i++) {
      soundToLightPresets[i] = int(loadStrings(loadPath + "variables/s2l_presets/preset"+str(i)+".txt"));
    }
    for(int i = 0; i < 100; i++) {
      preset[i] = int(loadStrings(loadPath + "variables/presets/preset"+str(i)+".txt"));
    }
    
    String lines5[] = loadStrings(loadPath + "variables/memoryType.txt");
    for (int i = 0; i < lines5.length; i++) {
      memoryType[i] = int(lines5[i]);
    }
    
    String lines6[] = loadStrings(loadPath + "variables/soundToLightSteps.txt");
    for (int i = 0; i < lines6.length; i++) {
      soundToLightSteps[i] = int(lines6[i]);
    }
    
    String lines7[] = loadStrings(loadPath + "variables/kalvot/red.txt");
    for (int i = 0; i < lines7.length; i++) {
      red[i] = int(lines7[i]);
    }
    
    String lines8[] = loadStrings(loadPath + "variables/kalvot/green.txt");
    for (int i = 0; i < lines8.length; i++) {
      green[i] = int(lines8[i]);
    }
    
    String lines9[] = loadStrings(loadPath + "variables/kalvot/blue.txt");
    for (int i = 0; i < lines9.length; i++) {
      blue[i] = int(lines9[i]);
    }
    
    String lines10[] = loadStrings(loadPath + "variables/rotTaka.txt");
    for (int i = 0; i < lines10.length; i++) {
      rotTaka[i] = int(lines10[i]);
    }
    String lines11[] = loadStrings(loadPath + "variables/fixtureType.txt");
    for (int i = 0; i < lines11.length; i++) {
      fixtureType1[i] = int(lines11[i]);
    }
 
}
