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
  
  
  
  //---------------------------------------------------------------Saving memories---------------------------------------------------------------------------------------------------------

  saveVariable(memories.length, "memories.length");
  for(int i = 0; i < memories.length; i++) {
    if(memories[i].repOfFixtures != null) {
      saveDataMainCommands(str(memories[i].repOfFixtures.length), "memories[i].repOfFixtures.length", "1", str(i), "-");
    }
    
    saveDataMainCommands(str(memories[i].type), "memories[i].type", "1", str(i), "-");
     saveDataMainCommands(str(memories[i].value), "memories[i].value", "1", str(i), "-");

    { //Saving chase variables
      if(memories[i].myChase != null) {
        
        { //IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT   IMPORTANT  
          if(memories[i].myChase.presets != null) {
            saveDataMainCommands(str(memories[i].myChase.presets.length), "memories[i].myChase.presets.length", "1", str(i), "-"); 
            for(int ij = 0; ij < memories[i].myChase.presets.length; ij++) { //This is the most important part of saving chase data
              saveDataMainCommands(str(memories[i].myChase.presets[ij]), "memories[i].myChase.presets[ij]", "2", str(i), str(ij));
            } //End of for(int ij = 0; ij < memories[i].myChase.presets.length; ij++)
          }
          
          if(memories[i].myChase.content != null) {
            saveDataMainCommands(str(memories[i].myChase.content.length), "memories[i].myChase.content.length", "1", str(i), "-"); 
            for(int ij = 0; ij < memories[i].myChase.content.length; ij++) { //This is the most important part of saving chase data
              saveDataMainCommands(str(memories[i].myChase.content[ij]), "memories[i].myChase.content[ij]", "2", str(i), str(ij));
            } //End of for(int ij = 0; ij < memories[i].myChase.content.length; ij++)
          }
          
          
          { //Pretty important data to save
            saveDataMainCommands(str(memories[i].myChase.inputMode), "memories[i].myChase.inputMode", "1", str(i), "-");
            saveDataMainCommands(str(memories[i].myChase.outputMode), "memories[i].myChase.outputMode", "1", str(i), "-");
            saveDataMainCommands(str(memories[i].myChase.beatModeId), "memories[i].myChase.beatModeId", "1", str(i), "-");
            saveDataMainCommands(memories[i].myChase.beatMode, "memories[i].myChase.beatMode", "1", str(i), "-");
          } //End of saving pretty important data
        } //END OF IMPORTANT   END OF IMPORTANT   END OF IMPORTANT   END OF IMPORTANT   END OF IMPORTANT   END OF IMPORTANT   END OF IMPORTANT   END OF IMPORTANT   
        
        //INSIDE SAVING MEMORIES
        
        { //UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   UNIMPORTANT   

          
          { //These are not so important variables
            saveDataMainCommands(str(memories[i].myChase.step), "memories[i].myChase.step", "1", str(i), "-");
            saveDataMainCommands(str(memories[i].myChase.brightness), "memories[i].myChase.brightness", "1", str(i), "-");
            saveDataMainCommands(str(memories[i].myChase.brightness1), "memories[i].myChase.brightness1", "1", str(i), "-");
            saveDataMainCommands(str(int(memories[i].myChase.stepHasChanged)), "memories[i].myChase.stepHasChanged", "1", str(i), "-");
            saveDataMainCommands(str(memories[i].myChase.fade), "memories[i].myChase.fade", "1", str(i), "-");
          } //End of saving unimportant variables
        } //END OF UNIMPORTANT   END OF UNIMPORTANT   END OF UNIMPORTANT   END OF UNIMPORTANT   END OF UNIMPORTANT   END OF UNIMPORTANT   END OF UNIMPORTANT   
      } //End of check the memory is not null
    } //End saving chase variables
    

    //INSIDE SAVING MEMORIES
    
    for(int ij = 0; ij < memories[i].whatToSave.length; ij++) {
      saveDataMainCommands(str(memories[i].whatToSave[ij]), "memories[i].whatToSave[ij]", "2", str(i), str(ij));
    } //End of for(int ij = 0; ij < memories[i].whatToSave.length; ij++)
    
   for (int j = 0; j < memories[i].repOfFixtures.length; j++) {
       // whatToSave titles: { "dimmer", "colorWheel", "gobo", "goboRotation", "shutter", "pan", "tilt" }
       for(int jk = 0; jk < universalDMXlength; jk++) {
          if(memories[i].whatToSave[jk]) saveDataMainCommands(str(memories[i].repOfFixtures[j].getUniDMX(jk)), "memories[i].repOfFixtures[j].getUniDMX(" + str(jk) + ")", "2", str(i), str(j));
       }
    } //End of for (int j = 1; j < memories[i].repOfFixtures.length; j++)

  } //End of for(int i = 0; i < memories.length; i++)
 
  
  //-------------------------------------------------------End saving memories------------------------------------------------------------------------------------------------------------------------------
  
  //INSIDE VOID SAVE

  save1Darray(ansaZ, "ansaZ");
  save1Darray(ansaX, "ansaX");
  save1Darray(ansaY, "ansaY");
  save1Darray(ansaType, "ansaType");
  //save1Darray(memoryType, "memoryType");
  //save1Darray(soundToLightSteps, "soundToLightSteps");
  save1Darray(ansaX, "ansaX");
  //save1Darray(chaseModeByMemoryNumber, "chaseModeByMemoryNumber"); 
  //save1Darray(valueOfMemory, "valueOfMemory"); 
  //save1Darray(memoryValue, "memoryValue"); 
  
  save1Darray(bottomMenuOrder, "bottomMenuOrder");
  
  
  
  
  int[] grouping = new int[3];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        
  save1Darray(grouping, "grouping"); 
  
  //save2Darray(memory, "memory");
  //save2Darray(soundToLightPresets, "soundToLightPresets");
  //save2Darray(preset, "preset");


  
  saveVariable(int(camX), "camX");
  saveVariable(int(camY), "camY");
  saveVariable(int(camZ), "camZ");
  saveVariable(int(centerX), "centerX");
  saveVariable(int(centerY), "centerY");
  saveVariable(chaseMode, "chaseMode");
  
  saveDataMainCommands(loadPath, "loadPath", "0", "-", "-");
  

  //Asetetaan oikeat tallennuspolut käyttäjän mukaan
  println(savePath);
  saveTable(table, savePath, "csv");
  
  
  println(); println(); println(); 
  println("SAVE READY");
  long takedTime = millis() - saveDataBeginMillis;
  println("It taked " + str(takedTime) + " ms");
  println();
  
}

