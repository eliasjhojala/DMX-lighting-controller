String[] saveOptionButtonVariables = { "dimmer", "red", "green", "blue", "white", "amber", "pan", "tilt", "panFine", "tiltFine",
"colorWheel", "goboWheel", "goboRotation", "prism", "focus", "shutter", "strobe", "frequency", "responseSpeed",
"autoPrograms", "specialFunctions", "haze", "fan", "fog", "special1", "special2", "special3", "special4" };

  soundDetect s2l;
  memory[] memories = new memory[1000];

int fixtureOwnFade;

void removeMemory(int id) {
  memories[id] = new memory();
}

void setMemoryValueByOrderInVisualisation(int id, int val) {
  if(memoryControllerLookupTable != null) {
    if(id >= 0 && id < memoryControllerLookupTable.length) {
      int i = memoryControllerLookupTable[id];
      if(memories != null) {
        if(i >= 0 && i < memories.length) {
          val = constrain(val, 0, 255);
          memories[i].setValue(val);
        }
      }
    }
  }
}

void setMemoryEnabledByOrderInVisualisation(int id, boolean val) {
  if(memoryControllerLookupTable != null) {
    if(id >= 0 && id < memoryControllerLookupTable.length) {
      int i = memoryControllerLookupTable[id];
      if(memories != null) {
        if(i >= 0 && i < memories.length) {
          memories[i].enabled = val;
        }
      }
    }
  }
}
  
void createMemoryObjects() {
  s2l = new soundDetect();
  for (memory temp : memories) temp = new memory();
  for(int i = 0; i < memories.length; i++) {
    memories[i] = new memory();
  }
}

XML getMemoriesAsXML() {
  String data = "<Memories></Memories>";
  XML xml = parseXML(data);
  xml.addChild(arrayToXML("memoryControllerLookupTable", memoryControllerLookupTable));
  for(int i = 0; i < memories.length; i++) {
    if(memories[i].type != 0) {
      xml = xml.addChild(memories[i].getXML());
      xml.setInt("id", i);
      xml = xml.getParent();
    }
  }
  return xml;
}


void XMLtoMemories(XML xml) {
  XML[] block = xml.getChildren();
  if(XMLtoIntArray("memoryControllerLookupTable", xml) != null) {
    memoryControllerLookupTable = XMLtoIntArray("memoryControllerLookupTable", xml);
  }
  int a = 0;
  
  for(int i = 0; i < block.length; i++) {
    if(block[i] != null) if(!trim(block[i].toString()).equals("")) /*if(!block[i].getName().equals("memoryControllerLookupTable"))*/  {
      int id = block[i].getInt("id");
      if(loadFast && !loadSafe) {
        singleMemoryXMLtoObjectXML = block[i];
        singleMemoryXMLtoObjectid = id;
        thread("singleMemoryXMLtoObject");
        delay(10);
      }
      else {
        memories[id].XMLtoObject(block[i]);
      }
      a++;
    }
  }
}

XML singleMemoryXMLtoObjectXML;
int singleMemoryXMLtoObjectid;

void singleMemoryXMLtoObject() {
  memories[singleMemoryXMLtoObjectid].XMLtoObject(singleMemoryXMLtoObjectXML);
}

boolean savingMemoriesToXML;
void saveMemoriesToXML() {
  savingMemoriesToXML = true;
  saveXML(getMemoriesAsXML(), "XML/memories.xml");
  savingMemoriesToXML = false;
}

void loadMemoriesFromXML() {
   loadinMemoriesFromXML = true;
    XMLtoMemories(loadXML("XML/memories.xml"));
   loadinMemoriesFromXML = false;
}


class memory { //Begin of memory class--------------------------------------------------------------------------------------------------------------------------------------
  
  //-----------CODER MANUAL----------------//|
  // when you use memory, please use       //|
  // command memories[i].setValue(value)   //|
  // Never use value = ;                   //|
  //---------------------------------------//|
  
  //--Memory types--//|
  // 1: preset      //|
  // 2: chase       //|
  // 3: quickChase  //|
  // 4: master      //|
  // 5: fade        //|
  // 6: chase1      //|
  // 7: special     //|
  // 8: queStack    //|
  // 9: masterGroup //|
  //----------------//|
  
  
  //chase variables
  int value, valueOld; //memorys value
  int type; //memorys type (preset, chase, master, fade etc) (TODO: expalanations for different memory type numbers here)
  boolean enabled = true;
  boolean soloInThisMemory;
  int specialType; //Strobeon, fullon, blackout etc.
  boolean doOnce;
  int triggerButton;
  
  boolean doOnce() {
	return doOnce;
  }

  
  boolean[] whatToSave = new boolean[saveOptionButtonVariables.length+10];
  boolean[] fixturesToSave = new boolean[fixtures.size()];
  
  boolean loadingFromXML = false;
  
  
  FixtureDMX[] repOfFixtures = new FixtureDMX[fixtures.size()];
  
  chase myChase;
  Preset myPreset;
  
  memory() {
    myChase = new chase(this);
    myPreset = new Preset(this);
  }
  
  XML getXML() {
    String data = "<Memory></Memory>";
    XML xml = parseXML(data);
    xml.setInt("enabled", int(enabled));
    xml.setInt("value", value);
    xml.setInt("valueOld", valueOld);
    xml.setInt("type", type);
    xml.setInt("specialType", specialType);
    xml.setInt("soloInThisMemory", int(soloInThisMemory));
    if(type == 1) {
      xml.addChild(myPreset.getXML());
    }
    if(type == 2 || type == 3 || type == 6 || type == 8) {
      xml.addChild(myChase.getXML());
    }
    if(type == 9) {
      xml.addChild(arrayToXML("fixturesToSave", fixturesToSave));
    }
    return xml;
  }
  
  void XMLtoObject(XML xml) {
    if(!loadingFromXML) {
      loadingFromXML = true;
      enabled = boolean(xml.getInt("enabled"));
      value = xml.getInt("value");
      valueOld = xml.getInt("valueOld");
      type = xml.getInt("type");
      specialType = xml.getInt("specialType");
      soloInThisMemory = boolean(xml.getInt("soloInThisMemory"));
      if(type == 1) {
        myPreset.XMLtoObject(xml);
      }
      if(type == 2 || type == 3 || type == 6 || type == 8) {
        myChase.XMLtoObject(xml);
      }
      if(type == 9) {
        fixturesToSave = new boolean[fixtures.size()];
        arrayCopy(XMLtoBooleanArray("fixturesToSave", xml), fixturesToSave);
      }
      loadingFromXML = false;
    }
  }
  
  
  void toggle(boolean down) {
    if(down) {
      if(value > 0) { setValue(0); } else { setValue(255); }
    }
  }
  
  void toggleWithMemory(boolean down) {
    if(down) {
      enabled = !enabled;
    }
  }
  
  void pushWithMemory(boolean down) {
    enabled = down;
  }
  
  int valueBeforePush;
  void push(boolean down) {
    if(down) {
      valueBeforePush = getValue();
      setValue(255);
    }
    else {
      setValue(valueBeforePush);
    }
  }

  boolean thisIsChase() {
    return type == 2;
  }
  
  void setFade(int v) {
    if(myChase != null) myChase.ownFade = v;
  }

  
  String getText() {
    String toReturn = "";
    switch(type) {
      case 0: toReturn = ""; break;
      case 1: toReturn = "prst"; break;
      case 2: toReturn = "chs"; break;
      case 3: toReturn = "qChs"; break;
      case 4: toReturn = "mstr"; break;
      case 5: toReturn = "fade"; break;
      case 6: toReturn = "chs1"; break;
      case 7: toReturn = "spcl"; break;
      case 8: toReturn = "chs2"; break;
      case 9: toReturn = "mstrG"; break;
      default: toReturn = "unkn"; break;
    }
    return toReturn;
  }
  
  void draw() {
    if(!savingMemory) {
      switch(type) {
        case 0: empty(); break;
        case 1: preset(); break;
        case 3: chase(); break;
        case 2: chase(); break;
        case 4: grandMaster(); break;
        case 5: fade(); break;
        case 6: chase(); break;
        case 7: special(); break;
        case 8: chase(); break;
        case 9: masterGroup(); break;
        default: unknown(); break;
      }
    }
  }
  
  void preset() {
    if(type == 1 && enabled) {
      myPreset.setValue(value);
      loadPreset();
    }
  }
  
  boolean firstTimeAtZero;
  void chase() {
    if(enabled) {
      if(value > 0 || firstTimeAtZero) {
         myChase.draw();
         firstTimeAtZero = false;
      }
      if(value > 0) {
        firstTimeAtZero = true;
      }
    }
  }
  void grandMaster() {
    //function to adjust grandMaster
    setGrandMaster(value);
  }
  void fade() {
    chaseFade = value;
  }
  void unknown() {
  }
  void empty() {
  }
  void masterGroup() {
    for(int i = 0; i < fixturesToSave.length; i++) {
      if(fixturesToSave[i]) {
        fixtures.get(i).masters.append(value);
      }
    }
  }
  
  void saveMasterGroup() {
    type = 9;
    fixturesToSave = new boolean[fixtures.size()];
    for(int i = 0; i < fixtures.size(); i++) {
      fixturesToSave[i] = fixtures.get(i).selected;
    }
  }
  
  void special() {
    if((value == 0 || !enabled) && firstTimeAtZero) {
       switch(specialType) {
         case 1: fullOn = false; break;
         case 2: blackOut = false; break;
         case 3: strobeNow = false; break;
         case 4: fogNow = false; break;
       }
       firstTimeAtZero = false;
    }
    if(value > 0 && enabled) {
      switch(specialType) {
         case 1: fullOn = true; break;
         case 2: blackOut = true; break;
         case 3: strobeNow = true; break;
         case 4: fogNow = true; break;
       }
      firstTimeAtZero = true;
    }
  }
  
  
  void setValue(int val) {
    value = val;
    draw();
  }
  int getValue() {
    return value;
  }
  
  void setGrandMaster(int value) {
    grandMaster = value;
    if(grandMaster != oldGrandMaster) {
      for(int i = 0; i < fixtures.size(); i++) {
        fixtures.get(i).DMXChanged = true;
      }
      oldGrandMaster = grandMaster;
    }
  }
  
  
  
  
  void savePreset(boolean[] newWhatToSave) {
    myPreset.savePreset(newWhatToSave);
    type = 1;
    enabled = true;
  }
  
  void savePreset() {
    myPreset.savePreset();
    type = 1;
    enabled = true;
  }



  void loadPreset(int v) {
    myPreset.setValue(v);
  }

  void loadPreset() {
    myPreset.loadPreset();
  }

  
  
} //end of memory class-----------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



XML array2DToXML(String name, int[][] array2D) {
  
  String data = "<" + name + "></" + name + ">";
  XML xml = parseXML(data);
  if(array2D != null) {
    for(int j = 0; j < array2D.length; j++) {
      int[] array = array2D[j];
      if(array != null) {
        XML block = xml.addChild(arrayToXML("row", array));
        block.setInt("id", j);
      }
    }
  }
  return xml;
}

XML array3DToXML(String name, int[][][] array3D) {
  
  String data = "<" + name + "></" + name + ">";
  XML xml = parseXML(data);
  if(array3D != null) {
    for(int j = 0; j < array3D.length; j++) {
      int[][] array = array3D[j];
      if(array != null) {
        XML block = xml.addChild(array2DToXML("z", array));
        block.setInt("id", j);
      }
    }
  }
  return xml;
}

int[][] XMLtoIntArray2D(String name, XML xml) {
  int[][] toReturn = { };
  if(xml != null) {
    xml = xml.getChild(name);
    if(xml != null) {
      XML[] block = xml.getChildren();
      int a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int tmp = block[i].getInt("id")+1;
          if(tmp > a) a = tmp;
        }
      }
      toReturn = new int[a][];
      a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int id = block[i].getInt("id");
          toReturn[id] = XMLtoIntArray(block[i]);
          a++;
        }
      }
    }
    return toReturn;
  }
  return null;
}

int[][] XMLtoIntArray2D(XML xml) {
  int[][] toReturn = { };
    if(xml != null) {
      XML[] block = xml.getChildren();
      int a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int tmp = block[i].getInt("id")+1;
          if(tmp > a) a = tmp;
        }
      }
      toReturn = new int[a][];
      a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int id = block[i].getInt("id");
          toReturn[id] = XMLtoIntArray(block[i]);
          a++;
        }
      }
      return toReturn;
    }
  return null;
}

int[][][] XMLtoIntArray3D(String name, XML xml) {
  int[][][] toReturn = { };
  if(xml != null) {
    xml = xml.getChild(name);
    if(xml != null) {
      XML[] block = xml.getChildren();
      int a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int tmp = block[i].getInt("id")+1;
          if(tmp > a) a = tmp;
        }
      }
      toReturn = new int[a][][];
      a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int id = block[i].getInt("id");
          toReturn[id] = XMLtoIntArray2D(block[i]);
          a++;
        }
      }
    }
    return toReturn;
  }
  return null;
}

XML arrayToXML(String name, int[] array) {
  
  String data = "<" + name + "></" + name + ">";
  XML xml = parseXML(data);
  if(array != null) {
    for(int i = 0; i < array.length; i++) {
      if(array[i] != 0) {
        XML block = xml.addChild("int");
        block.setInt("id", i);
        block.setInt("val", array[i]);
      }
    }
  }
  return xml;
}

int[] XMLtoIntArray(String name, XML xml) {
  int[] toReturn = { };
  if(xml != null) {
    xml = xml.getChild(name);
    if(xml != null) {
      XML[] block = xml.getChildren();
      int a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int tmp = block[i].getInt("id")+1;
          if(tmp > a) a = tmp;
        }
      }
      toReturn = new int[a];
      a = 0;
      for(int i = 0; i < block.length; i++) {
        if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
          int id = block[i].getInt("id");
          toReturn[id] = block[i].getInt("val");
          a++;
        }
      }
    }
    return toReturn;
  }
  return null;
}

int[] XMLtoIntArray(XML xml) {
  int[] toReturn = { };
  if(xml != null) {
    XML[] block = xml.getChildren();
    int a = 0;
    for(int i = 0; i < block.length; i++) {
      if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
        int tmp = block[i].getInt("id")+1;
        if(tmp > a) a = tmp;
      }
    }
    toReturn = new int[a];
    a = 0;
    for(int i = 0; i < block.length; i++) {
      if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
        int id = block[i].getInt("id");
        toReturn[id] = block[i].getInt("val");
        a++;
      }
    }
  return toReturn;
  }
  return null;
}

XML arrayToXML(String name, boolean[] array) {
  String data = "<" + name + "></" + name + ">";
  XML xml = parseXML(data);
  for(int i = 0; i < array.length; i++) {
    if(array[i]) {
      XML block = xml.addChild("int");
      block.setInt("id", i);
      block.setInt("val", int(array[i]));
    }
  }
  return xml;
}

boolean[] XMLtoBooleanArray(String name, XML xml) {
  boolean[] toReturn = { };
  xml = xml.getChild(name);
  XML[] block = xml.getChildren();
  int a = 0;
  for(int i = 0; i < block.length; i++) {
    if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
      int id = block[i].getInt("id");
      if(id+1 > a) { a = id+1; }
    }
  }
  toReturn = new boolean[a];
  a = 0;
  for(int i = 0; i < block.length; i++) {
    if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
      int id = block[i].getInt("id");
      toReturn[id] = boolean(block[i].getInt("val"));
      a++;
    }
  }
  return toReturn;
}


class Preset { //Begin of Preset class
  //You need to supply a memory parent for this to work properly
  memory parent;
  Preset(memory parent) {
    this.parent = parent;
    for(int i = 0; i < repOfFixtures.length; i++) {
      repOfFixtures[i] = new FixtureDMX();
    }
  }
  
  chase parentChase;
  Preset(chase parentChase) {
    this.parentChase = parentChase;
    this.parent = parentChase.parent;
    for(int i = 0; i < repOfFixtures.length; i++) {
      repOfFixtures[i] = new FixtureDMX();
    }
  }
  
  //Define variables
    int value, valueOld; //memorys value
    boolean[] whatToSave = new boolean[saveOptionButtonVariables.length+10];
    boolean[] fixturesToSave = new boolean[fixtures.size()];
    FixtureDMX[] repOfFixtures = new FixtureDMX[fixtures.size()];
  //End of defining variables
  
  XML getXML() {
    String data = "<Preset></Preset>";
    XML xml = parseXML(data);
    xml = xml.addChild("mainData");
    xml.setInt("value", value);
    xml.setInt("valueOld", valueOld);
    xml = xml.getParent();
    try {
    xml.addChild(arrayToXML("whatToSave", whatToSave));
    xml.addChild(arrayToXML("fixturesToSave", fixturesToSave));
    }
    catch (Exception e) {
      notifier.notify("Error with whatToSave or fixturesToSave saving", true);
      println("Error with whatToSave or fixturesToSave saving");
    }
    try {
      xml = xml.addChild("repOfFixtures");
          if(repOfFixtures != null) {
            for(int i = 0; i < repOfFixtures.length; i++) {
              if(fixturesToSave[i]) {
                if(repOfFixtures != null) {
                    if(repOfFixtures[i].getXML() != null) {
                      xml = xml.addChild(repOfFixtures[i].getXML());
                      xml.setInt("id", i);
                      xml = xml.getParent();
                      
                    }
                    else {
                      println("Error with saving repOfFixtures[" + str(i) + "]");
                    }
                }
              }
            }
          }
      xml = xml.getParent();
    }
    catch (Exception e) {
      notifier.notify("Error with repofFixtures saving", true);
      println("Error with repofFixtures saving");
    }
    return xml;
  }
  
  
  boolean XMLloadSucces = true;
  
  void XMLtoObject(XML xml) {
    XMLloadSucces = false;
    if(xml != null) {
      xml = xml.getChild("Preset");
      if(xml != null) {
        xml = xml.getChild("mainData");
        if(xml != null) {
          value = xml.getInt("value");
          valueOld = xml.getInt("valueOld");
          xml = xml.getParent();
        }
        if(xml != null) {
          whatToSave = new boolean[saveOptionButtonVariables.length+10];
          arrayCopy(XMLtoBooleanArray("whatToSave", xml), whatToSave);
          fixturesToSave = new boolean[fixtures.size()];
          arrayCopy(XMLtoBooleanArray("fixturesToSave", xml), fixturesToSave);
        }
    
        xml = xml.getChild("repOfFixtures");
        XML[] block = xml.getChildren();
        int a = 0;
          for(int i = 0; i < block.length; i++) {
            if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
              int id = block[i].getInt("id");
              if(id+1 > a) { a = id+1; }
            }
          }
          repOfFixtures = new FixtureDMX[a];
          for(int i = 0; i < repOfFixtures.length; i++) {
            repOfFixtures[i] = new FixtureDMX();
          }
          for(int i = 0; i < block.length; i++) {
            if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
                int id = block[i].getInt("id");
                if(fixturesToSave[id]) {
                  repOfFixtures[id].XMLtoObject(block[i]);
                }
            }
          }
        xml = xml.getParent();
      }
    }
    XMLloadSucces = true;
  }
  
  void XMLtoObject(XML xml, boolean a) {
    XMLloadSucces = false;
    if(xml != null) {
      //xml = xml.getChild("Preset");
      if(xml != null) {
        xml = xml.getChild("mainData");
        if(xml != null) {
          value = xml.getInt("value");
          valueOld = xml.getInt("valueOld");
          xml = xml.getParent();
        }
        if(xml != null) {
          arrayCopy(XMLtoBooleanArray("whatToSave", xml), whatToSave);
          arrayCopy(XMLtoBooleanArray("fixturesToSave", xml), fixturesToSave);
        }
    
        xml = xml.getChild("repOfFixtures");
        XML[] block = xml.getChildren();
          for(int i = 0; i < block.length; i++) {
            if(block[i] != null) if(!trim(block[i].toString()).equals("")) {
              int id = block[i].getInt("id");
              repOfFixtures[id].XMLtoObject(block[i]);
            }
          }
        xml = xml.getParent();
      }
    }
    XMLloadSucces = true;
  }
  
  
  
  void savePreset(boolean[] newWhatToSave) {
    whatToSave = new boolean[40];
    arrayCopy(newWhatToSave, whatToSave);
    savePreset();
  }
  
  void setValue(int val) {
    value = val;
    draw();
  }
  int getValue() {
    return value;
  }
  
  void loadPreset(int v) {
    setValue(v);
  }
  
  void draw() {
    if(XMLloadSucces) {
      if(parent.type == 1 || parent.type == 6) {
        loadPreset();
      }
    }
  }
  
  void loadPreset() {
    if(!loadinMemoriesFromXML) {
      if(!soloIsOn || parent.soloInThisMemory) {
        if(XMLloadSucces) if(parent.type == 1 || parent.type == 6) {
          valueOld = value;
          for(int jk = 1; jk < fixtures.get(0).preset.DMXlength; jk++) {
            if(whatToSave[jk-1]) {
              for(int i = 0; i < fixtures.size(); i++) { //Go through all the fixtures
                if(i < repOfFixtures.length) {
                  if(fixturesToSave[i]) {
                    if(jk < fixtures.get(i).preset.DMXlength) {
                      int val = rMap(repOfFixtures[i].getUniversalDMX(jk), 0, 255, 0, value);
                      fixtures.get(i).preset.setUniDMXfromPreset(jk, val);
                      if(val > 0) {
                        if(parent.type == 1) {
                          fixtures.get(i).preset.preFade = round(float(fixtureOwnFade)/20);
                          fixtures.get(i).preset.postFade = fixtureOwnFade;
                        }
                        else {
                          fixtures.get(i).preset.preFade = 0;
                          fixtures.get(i).preset.postFade = 0;
                        }
                      }
                      if(parent.soloInThisMemory && val > 0) {
                        fixtures.get(i).soloInThisFixture = true;
                        soloIsOn = true;
                      }
                    }
                  }
                }
                else {
                  break;
                }
              } //End of going through all the fixtures
            }
          }
        }
      }
      }
  }
  
  void savePreset() {
    repOfFixtures = new FixtureDMX[fixtures.size()];
    for(int i = 0; i < fixtures.size(); i++) {
        repOfFixtures[i] = new FixtureDMX();
    }
    
    fixturesToSave = new boolean[fixtures.size()];
    for(int i = 0; i < fixtures.size(); i++) {
      fixturesToSave[i] = fixtures.get(i).selected;
    }
      
    for(int i = 0; i < fixtures.size(); i++) {
      if(fixturesToSave[i]) {
        for(int jk = 1; jk < fixtures.get(i).in.DMXlength; jk++) {
          if(whatToSave[jk-1])
            repOfFixtures[i].setUniversalDMX(jk, fixtures.get(i).in.getUniversalDMX(jk));
        }
      }
    }
  }
  
  
} //End of Preset class




//chase mode variables--------------------------------------------------------------------------------------------------------

  String[] outputModeDescs = { "inherit", "steps", "eq", "shaky", "sine", "sSine", "rainbow", "onoff" };

  int[] inputModeLimit = { 1, 4 };
  int[] outputModeLimit = { 1, outputModeDescs.length-1 };
  int[] fadeModeLimit = { 1, 3 };
  int[] beatModeLimit = { 2, 4 };
          
  
  
  int inputModeMaster = inputModeLimit[0];
  int outputModeMaster = outputModeLimit[0];
  int beatModeMaster = beatModeLimit[0];
  
  
  
  


        void inputModeMasterUp() {
          inputModeMaster = getNext(inputModeMaster, inputModeLimit);
        }
        void inputModeMasterDown() {
          inputModeMaster = getReverse(inputModeMaster, inputModeLimit);
        }
        void outputModeMasterUp() {
          outputModeMaster = getNext(outputModeMaster, outputModeLimit);
        }
        void outputModeMasterDown() {
          outputModeMaster = getReverse(outputModeMaster, outputModeLimit);
        }

        
        String getOutputModeMasterDesc() {
          String toReturn = "";
          toReturn = outputModeDescs[outputModeMaster];
          return toReturn;
        }
        

        String getInputModeMasterDesc() {
          String toReturn = "";
          switch(inputModeMaster) {
            case 0: toReturn = "inherit"; break;
            case 1: toReturn = "beat"; break;
            case 2: toReturn = "manual"; break;
            case 3: toReturn = "auto"; break;
            case 4: toReturn = "tap"; break;
          }
          return toReturn;
        }
        
//chase mode variables end--------------------------------------------------------------------------------------------------------------
        
        
        




class chase { //Begin of chase class--------------------------------------------------------------------------------------------------------------------------------------
  //---------------------init all the variables--------------------------------
  int value;
  int inputMode, outputMode, beatModeId; //What is input and what will output look like
  String beatMode = new String(); //kick, snare or hat
 
  int[] inputModeLimit = { 0, 4 };
  int[] outputModeLimit = { 0, outputModeDescs.length-1 };
  int[] fadeModeLimit = { 1, 3 };
  int[] beatModeLimit = { 2, 4 };
 
  
  int fadeMode; //1 = from own, 2 = from own*master, 3 = from master
  
  int[] presets; //all the presets in chase
  int[] content; //all the content in chase - in the future also presets
  ArrayList<Preset> steps = new ArrayList<Preset>(); //all the presets in chase
  IntList stepsForChase2 = new IntList();
  
  int step, brightness, brightness1;
  boolean stepHasChanged;
  int fade, ownFade;
  
  int sineMax = 300;
  int sineMin = 1;
  
  sine[] sines = new sine[sineMax+1];
  int[] sineValue = new int[500];
  
  
  //----------------------end declaring variables--------------------------------
  
  
  XML getXML() {
    String data = "<Chase></Chase>";
    XML xml = parseXML(data);
    if(parent.type == 2) {
      xml.addChild(arrayToXML("presets", presets));
    }
    if(parent.type == 3) {
      xml.addChild(arrayToXML("content", content));
    }
    XML block = xml.addChild("stepData");
      setIntXML("step", step, block);
      setIntXML("brightness", brightness, block);
      setIntXML("brightness1", brightness1, block);
    block = xml.addChild("mainData");
      setIntXML("fade", fade, block);
      setIntXML("ownFade", ownFade, block);
      setIntXML("value", value, block);
    block = xml.addChild("modeData");
      setIntXML("inputMode", inputMode, block);
      setIntXML("outputMode", outputMode, block);
      setIntXML("beatModeId", beatModeId, block);
      setIntXML("fadeMode", fadeMode, block);
    if(parent.type == 6) {
      block = xml.addChild("steps");
        block.setInt("size", steps.size());
        for(int i = 0; i < steps.size(); i++) {
          block.addChild(steps.get(i).getXML());
        }
    }
    if(parent.type == 8) {
      block = xml.addChild("stepsForChase2");
        block.setInt("size", stepsForChase2.size());
        for(int i = 0; i < stepsForChase2.size(); i++) {
          block.addChild("step").setInt("val", stepsForChase2.get(i));
        }
    }
    return xml;
  }
  
  boolean XMLloadSucces = true;
  
  void XMLtoObject(XML xml) {
    XMLloadSucces = false;
    if(xml != null) {
      xml = xml.getChild("Chase");
      if(xml != null) {
        presets = XMLtoIntArray("presets", xml);
        content = XMLtoIntArray("content", xml);
        sineValue = XMLtoIntArray("sineValue", xml);
        XML block = xml.getChild("stepData");
        if(block != null) {
          step = getIntXML("step", block);
          brightness = getIntXML("brightness", block);
          brightness1 = getIntXML("brightness1", block);
        }
        block = xml.getChild("mainData");
        if(block != null) {
          fade = getIntXML("fade", block);
          ownFade = getIntXML("ownFade", block);
          value = getIntXML("value", block);
        }
        block = xml.getChild("modeData");
        if(block != null) {
          inputMode = getIntXML("inputMode", block);
          outputMode = getIntXML("outputMode", block);
          beatModeId = getIntXML("beatModeId", block);
          fadeMode = getIntXML("fadeMode", block);
        }
        block = xml.getChild("steps");
        if(block != null) {
          XML[] blocks = block.getChildren();
          for(int i = 0; i < blocks.length; i++) {
            if(blocks[i] != null) if(!trim(blocks[i].toString()).equals("")) {
              Preset x = new Preset(this);
              steps.add(x);
              x.XMLtoObject(blocks[i], true);
            }
          }
        }
        block = xml.getChild("stepsForChase2");
        if(block != null) {
          XML[] blocks = block.getChildren("step");
          for(int i = 0; i < blocks.length; i++) {
            stepsForChase2.append(blocks[i].getInt("val"));
          }
        }
      }
    }
    XMLloadSucces = true;
  }
  
  
  memory parent;
  //You need to supply a memory parent for this to work properly
  chase(memory parent) {
    this.parent = parent;
  }

  
  void draw() {
    if(XMLloadSucces) {
      setValue();
      setFade();
      output();
    }
  }
  
  void setValue() {
    value = parent.getValue();
  }

  
  //fadeMode functions
      void changeFade(int val) {
        ownFade = defaultConstrain(val);
      }
      void fadeModeUp() {
        fadeMode = getNext(fadeMode, fadeModeLimit);
      }
      void fadeModeDown() {
        fadeMode = getReverse(fadeMode, fadeModeLimit);
      }
      
        String getFadeModeDesc() {
        String toReturn = "";
        switch(fadeMode) {
          case 1: toReturn = "Own"; break;
          case 2: toReturn = "Scaled Master"; break;
          case 3: toReturn = "Inherit"; break;
        }
        return toReturn;
      }
      
        void setFade() {
          switch(fadeMode) {
            case 1: fade = ownFade; break;
            case 2: fade = (ownFade + chaseFade) / 2; break;
            case 3: fade = chaseFade; break;
            default: fade = chaseFade;
          }
          fade = constrain(round(map((pow(round(fade/25.5), 4)+1), (pow(round(0/25.5), 4)+1), (pow(round(255/25.5), 4)+1), 0, 255)), 0, 255);
        }
  //End of fadeMode functions
  
 
 
    
   //beatMode functions
        void setBeatMode(String bM) {
          beatMode = bM;
          if(bM.equals("beat")) { beatModeId = 1; }
          if(bM.equals("kick")) { beatModeId = 2; }
          if(bM.equals("snare")) { beatModeId = 3; }
          if(bM.equals("hat")) { beatModeId = 4; }
        }
                                                                                               
        void setBeatModeId(int bM) {
          beatModeId = bM;
          switch(bM) {
            case 0: beatMode = "inherit"; break;
            case 1: beatMode = "beat"; break;
            case 2: beatMode = "kick"; break;
            case 3: beatMode = "snare"; break;
            case 4: beatMode = "hat"; break;
          }
        }
                                                                                               
        String getBeatMode() {
          return beatMode;
        }
                                                                                               
        int getBeatModeId() {
          int toReturn = 0;
          if(beatModeId > 0) { toReturn = beatModeId; } else { toReturn = beatModeMaster; }
          return toReturn;
        }
                                                                                               
        void beatModeUp() {
          setBeatModeId(getNext(getBeatModeId(), beatModeLimit));
        }
        void beatModeDown() {
          setBeatModeId(getReverse(getBeatModeId(), beatModeLimit));
        }
   //End of beatMode functions
   
   
   
   //input and output mode functions
        void changeInputMode(int v) {
          inputMode = constrain(v, inputModeLimit[0], inputModeLimit[1]);
        }
        void changeOutputMode(int v) {
          outputMode = constrain(v, outputModeLimit[0], outputModeLimit[1]);
        }
        
        void inputModeUp() {
          inputMode = getNext(inputMode, inputModeLimit);
        }
        void inputModeDown() {
          inputMode = getReverse(inputMode, inputModeLimit);
        }
        void outputModeUp() {
          outputMode = getNext(outputMode, outputModeLimit);
        }
        void outputModeDown() {
          outputMode = getReverse(outputMode, outputModeLimit);
        }
        
        void output() {
          int oM = 0;
          if(outputMode > 0) { oM = outputMode; } else { oM = outputModeMaster; }
          switch(oM) {
            case 1: beatToMoving(); break;
            case 2: freqToLight(); break;
            case 3: shake(); break;
            case 4: sine(); break;
            case 5: singleSine(); break;
            case 6: rainbow(); break;
            case 7: beatToLight(); break;
          }
        }
        
        String getOutputModeDesc() {
          String toReturn = "";
          toReturn = outputModeDescs[constrain(outputMode, 0, outputModeDescs.length-1)];
          return toReturn;
        }
        

        String getInputModeDesc() {
          String toReturn = "";
          switch(inputMode) {
            case 0: toReturn = "inherit"; break;
            case 1: toReturn = "beat"; break;
            case 2: toReturn = "manual"; break;
            case 3: toReturn = "auto"; break;
            case 4: toReturn = "tap"; break;
          }
          return toReturn;
        }
        
        boolean nextStepPressedWasDown;
        boolean beatWasTrue;
        boolean reverseStepPressedWasDown;
        boolean tempoTapTriggerWasTrue;
        
          boolean trigger() {
            boolean toReturn = false;
            int iM = 0;
            if(inputMode > 0) { iM = inputMode; } else { iM = inputModeMaster; }
            switch(iM) {
              case 1: toReturn = !beatWasTrue && s2l.beat(constrain(getBeatModeId(), beatModeLimit[0], beatModeLimit[1])); if(toReturn) { beatWasTrue = true; } else { beatWasTrue = false; } break;
              case 2: toReturn = ((!nextStepPressedWasDown && nextStepPressed) || (keyPressed && key == ' ')); if(nextStepPressed) { nextStepPressedWasDown = true; } else { nextStepPressedWasDown = false; } break;
              case 3: toReturn = true; break;
              case 4: toReturn = (tapTempo.trigger() && !tempoTapTriggerWasTrue); if(tapTempo.trigger()) { tempoTapTriggerWasTrue = true; } else { tempoTapTriggerWasTrue = false; } break;
            }
            return toReturn;
          }
          
          boolean back() {
            boolean toReturn = false;
            int iM = 0;
            if(inputMode > 0) { iM = inputMode; } else { iM = inputModeMaster; }
            switch(iM) {
              //case 1: toReturn = !beatWasTrue && s2l.beat(constrain(getBeatModeId(), beatModeLimit[0], beatModeLimit[1])); if(toReturn) { beatWasTrue = true; } else { beatWasTrue = false; } break;
              case 2: toReturn = ((!reverseStepPressedWasDown && reverseStepPressed) || (keyPressed && key == 'r')); if(reverseStepPressed) { reverseStepPressedWasDown = true; } else { reverseStepPressedWasDown = false; } break;
              //case 3: toReturn = true; break;
            }
            return toReturn;
          }
          
          boolean doOnce() {
            return parent.doOnce();
          }
          
   //End of input and output mode functions
   
  
  
  
  /* This function saves all the presets to presets[]
  array if they are on (value is over 0) */
  void newChase() {
    createPresetsArray();
    makePresetsArray();
    setParentType(2);
  }
  
  void addNewStepForChase2(int id) {
    stepsForChase2.append(id);
  }
  
  int getNumberOfActivePresets() {
    int a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1 && memories[i].value > 0) { a++; }
    }
    return a;
  }
  
  void createPresetsArray() {
    presets = new int[getNumberOfActivePresets()];
  }
  
  void makePresetsArray() {
    int a = 0;
    for(int i = 0; i < memories.length; i++) {
      if(memories[i].type == 1 && memories[i].value > 0) {
          presets[a] = i;
          a++;
      }
    }
  }
  
  void setParentType(int t) {
    parent.type = t;
  }
  
  /* This function checks that this memory is a chase
  and the memory we're trying to control is a preset. */
  boolean firstTimeLoading = true;
  int[] oldValue;
  void loadPreset(int num, int val) {
    val = defaultConstrain(rMap(val, 0, 255, 0, value));
    if(firstTimeLoading) {
      oldValue = new int[getPresets().length];
      firstTimeLoading = false;
    }
    if(parent.type == 2) {
      memories[num].setValue(val);
    }
    if(parent.type == 3)  { //quickChase
      
      if(parent.soloInThisMemory && val > 0) { //Begin of solo commands
        soloIsOn = true;
        fixtures.get(num).soloInThisFixture = true;
      } //End of Solo commands
      fixtures.get(num).preset.preFade = 0;
      fixtures.get(num).preset.postFade = 0;
      fixtures.get(num).preset.setUniDMXfromPreset(DMX_DIMMER, val);
      oldValue[constrain(num, 0, oldValue.length-1)] = val;
    }
    if(parent.type == 6) { //Chase with steps inside
      loadOwnPreset(num, val);
    }
    if(parent.type == 8) {
      memories[num].setValue(val);
    }
  }
  
  void loadOwnPreset(int num, int val) {
    steps.get(num).setValue(rMap(val, 0, 255, 0, value));
  }
      
  int[] getPresets() {
     //here function which returns all the presets in this chase
     int[] toReturn = new int[1];
     if(parent.type == 2) {
       toReturn = new int[presets.length];
       arrayCopy(presets, toReturn);
     }
     else if(parent.type == 3) {
       toReturn = new int[content.length];
       arrayCopy(content, toReturn);
     }
     else if(parent.type == 6) { //Chase1 (all the presets in chase)
       toReturn = new int[steps.size()];
       for(int i = 0; i < steps.size(); i++) {
         toReturn[i] = i;
       }
     }
     else if(parent.type == 8) { //Chase2 (que stack)
       toReturn = new int[stepsForChase2.size()];
       for(int i = 0; i < stepsForChase2.size(); i++) {
         toReturn[i] = stepsForChase2.get(i);
       }
     } //End of if(parent.type == 8)
     return toReturn;
     
  }
  
  int getPresetValue(int i) {
    int toReturn = 0;
    int n = constrain(i, 0, getPresets().length-1);
     if(parent.type == 2) {
       toReturn = memories[getPresets()[n]].getValue();
     }
     else if(parent.type == 3) {
       toReturn = fixtures.get(getPresets()[n]).in.getUniDMX(DMX_DIMMER);
     }
     else if(parent.type == 8) {
       toReturn = memories[getPresets()[n]].getValue();
     }
     return toReturn;
  }
  
  boolean isQuickChase() {
    return parent.type == 3;
  }
  
  float loopMap(float val, float in_lo, float in_hi, float out_hi, float offset) {
    return (int(map(val, in_lo, in_hi, 0, out_hi)) + offset) % out_hi;
  }
  
  void setColor(int i, color c) {
    if(isQuickChase()) {
      if(fixtures.get(i).thisFixtureIsLed()) {
        fixtures.get(i).setColorForLedFromPreset(c);
      }
    }
  }

  
    
  int beatToLightValue;
  void beatToLight() { //This function turns all the lights in chase on if there is beat, else it turns all the lights off
    if(trigger()) {
      beatToLightValue = 255;
    }
      for(int i = 0; i < getPresets().length; i++) {
          loadPreset(getPresets()[i], beatToLightValue);
      }
      beatToLightValue = constrain(beatToLightValue-getInvertedValue(fade, 0, 255), 0, 255);
  }
  
  int lastDirection;
  final int REVERSE = 0;
  final int NEXT = 1;
  
  void beatToMoving() {
    //This function goes through all the presets. When there is beat this goes to next preset
    //There is some problems with this function
    boolean next = trigger() && !stepHasChanged;
    boolean reverse = back() && !stepHasChanged;
    if(next) {
      if(step == getPresets().length-1 && doOnce()) { parent.enabled = false; if(launchpad != null) { launchpad.sendNoteOff(parent.triggerButton); } }
      step = getNext(step, 0, getPresets().length-1);
      lastDirection = NEXT;
    }
    if(reverse) {
      if(step == 0 && doOnce()) { parent.enabled = false; }
      step = getReverse(step, 0, getPresets().length-1);
      lastDirection = REVERSE;
    }
    if(next || reverse) {
      brightness1 = 0;
      stepHasChanged = true;
    }
    if(stepHasChanged) {
      brightness1 += 1;
      if(brightness1 >= fade) {
        brightness1 = fade;
        stepHasChanged = false;
      }
      brightness = defaultConstrain(iMap(brightness1, 0, fade, 0, 255));
    }
    int[] presets = getPresets();
    int rS = 0;
    if(lastDirection == REVERSE) { rS = getNext(step, 0, presets.length-1); }
    else { rS = getReverse(step, 0, presets.length-1); }
    if(presets.length > 0) {
      loadPreset(presets[constrain(step, 0, onlyPositive(presets.length-1))], brightness);
      loadPreset(presets[constrain(rS, 0, onlyPositive(presets.length-1))], getInvertedValue(brightness, 0, 255));
    }
  }
  
  void freqToLight() { //This function gives frequence values to chase presets
    for(int i = 0; i < getPresets().length; i++) {
      loadPreset(getPresets()[i], s2l.freq(iMap(i, 0, getPresets().length, 0, s2l.getFreqMax())));
    }
  }
  
  

  void shake1() { //function to shake fixture values near the original value
    for(int i = 0; i < getPresets().length; i++) {
      loadPreset(getPresets()[i], defaultConstrain(round(random(value-value/3, value+value/3))));
    }
  }
  
  
  int[] originalValue;
  int[] valueChange;
  int[] finalValue;
  int[] changed;
  int[] changeTime;
  
  void shake() {
    
    int[] presets = getPresets();
    int randomIterations = 10;
    for(int i = 0; i < presets.length; i++) {
      
      int randomVal = 0;
      for(int j = 0; j < randomIterations; j++) randomVal += int(random(-20, 20));
      randomVal /= randomIterations;
      
      loadPreset(presets[i], defaultConstrain(getPresetValue(i) + randomVal));
      
    }
    

  }
  
  float hueOffset = 0;
  void rainbow() {
    if(true) {
      pushStyle();
        colorMode(HSB);
        
        if(fade > 150) {
          hueOffset += float(getInvertedValue(fade, 0, 255))/float(100);
        }
        else {
          hueOffset += float(getInvertedValue(fade, 0, 255))/float(10);
        }
        if(hueOffset > 255) { hueOffset = 0; }
        for(int i = 0; i < getPresets().length; i++) {
          color c = color(loopMap(i, 0, getPresets().length, 255, hueOffset), 255, 255);
          setColor(getPresets()[i], c);
        }
      popStyle();
    }
  }
  
  float log10 (int x) {
    return (log(x) / log(10));
  }
  
  
  
  
  float sinStep = 0; //step of sine wave
  void sine() { //function to make sine waves to presets
    int[] finalValue; //output value
    finalValue = new int[getPresets().length]; //create right lengthed array to place all the output values
    for(int i = 0; i < getPresets().length; i++) { //go through all the presets in chase
        sinStep+=map(chaseFade, 0, 255, 0.1, 0.001); //count sinestep according to chaseFade
        finalValue[i] = int(map(sin(sinStep-i), -1, 1, 0, 255)); //count output value according to sinestep and preset number
        loadPreset(getPresets()[i], finalValue[i]); //output the output value
    } //end of for(int i = 0; i < valueChange.length; i++)
  } //end of void sine()
  
  
  void singleSine() { //The function which makes ONE sine wave always when trigger is true
    for(int i = 0; i < sines.length; i++) { //Go throught all the sines
      if(sines[i] != null) { //Check if sine is created
        if(sines[i].go) { //Check if sine has to go on
          sines[i].draw(); //Count sine wave
        } //End of sines[i].go check
      } //End of checking does this sine exist
    }
    int[] presets = getPresets();
    for(int i = 0; i <= sineMax; i++) {
      if(i < presets.length) { //No nullpointers anymore
        if(i < presets.length && i < sineValue.length) {
          loadPreset(presets[i], sineValue[i]); //Finally put the values from sine class to loadPreset function
        }
      }
    }
    
    boolean trigger = trigger(); //use trigger function as trigger
    if(trigger) { //If triggered
      boolean found = false; //At first let's reset found boolean
      for(int i = 0; i < sines.length; i++) { //Go trhoughr all the sines
        if(sines[i] != null) { //Check if sine exist
          if(sines[i].ready) { sines[i].go(); found = true; break; } //If sine is ready we can use it again for new wave
        }
      }
      if(!found) { //If we didn't found any sine to use
      int numero = 0; //Reset numbero variable (numero = number)
        for(int i = 0; i < sines.length; i++) { //Go trhough all the sines
          if(sines[i] == null) { //check if sine isn't created
            numero = i; break; //Select the first sine which isn't created
          }
        }
      sines[numero] = new sine(numero, this); sines[numero].go(); } //Create sine and start it
    }
    sineValue = new int[getPresets().length];
  }
  

  
  //Create quickChase-------------------------------------------------------------
  /*Actually this function only saves selected
  fixtures to content array arranged by x location in screen */
  
  
   void createQuickChase() {
     int[] fixturesInChase; //create variable where selected fixtures will be stored
     int a = 0; //used mainly to count amount of some details
     
     for(int i = 0; i < fixtures.size(); i++) { //This for loop is made only to count how many fixtures are selected
       if(fixtures.get(i).selected) { a++; }
     }
     fixturesInChase = new int[a]; //Now we know how many fixtures are selected so we can create right lengthed array for storing them

     int[] x = new int[a]; //let's make also right lengthed array to store fixtures' x-location
     a = 0; //reset a variable because we're gonna use it again
     for(int i = 0; i < fixtures.size(); i++) { //This loop places right fixture id:s to fixturesInChase array
       if(fixtures.get(i).selected) {
         fixturesInChase[a] = i;
         a++;
       }
     }
     for(int i = 0; i < fixturesInChase.length; i++) { //this function places right x locations to x array
       x[i] = fixtures.get(fixturesInChase[i]).locationOnScreenX;
     }
     
     
     int[] fixturesInChaseTemp = new int[fixturesInChase.length]; //Create temp array to store fixturesInChase array temporarily
     arrayCopy(fixturesInChase, fixturesInChaseTemp);
     for(int i = 0; i < fixturesInChase.length; i++) { //This function stores fixture values to fixturesInChase array in right order
       fixturesInChase[i] = fixturesInChaseTemp[sortIndex(x)[i]];
     }
     
     //Fixtures are now right ordered in fixtuesInChase array, but the same channeled fixtures aren't removed
     
     a = 0; //Reset a again
     for(int i = 0; i < fixturesInChase.length; i++) { //let's count how long will final array be, when same channeled fixtures are removed
       if(fixtures.get(fixturesInChase[i]).channelStart != fixtures.get(fixturesInChase[getReverse(i, 0, fixturesInChase.length-1)]).channelStart) {
         a++;
       }
     }
     
     fixturesInChaseTemp = new int[a]; //Reset temp array and make it length good for save !(same channeled) fixtures
     a = 0; //reset a again
     for(int i = 0; i < fixturesInChase.length; i++) { //This function removes same channeled fixtures
       if(fixtures.get(fixturesInChase[i]).channelStart != fixtures.get(fixturesInChase[getReverse(i, 0, fixturesInChase.length-1)]).channelStart) {
         fixturesInChaseTemp[a] = fixturesInChase[i];
         a++;
       }
     }
     
     //now fixturesInChaseTemp is ready!
     //So let's copy it to fixturesInChase and then to content
     
     fixturesInChase = new int[fixturesInChaseTemp.length]; //reset fixturesInChase and make it right lenght
     content = new int[fixturesInChaseTemp.length]; //reset content array and make it right length
     
     arrayCopy(fixturesInChaseTemp, fixturesInChase); //copu temp array to fixturesInChase array
     arrayCopy(fixturesInChase, content); //copu fixturesInChase to content array
     
     setParentType(3); //set parent to 3 which means quickChase
     //Saving quickChase is ready!
 } //End of create quick chase -----------------------------------------------------------------------

  boolean chaseWithStepsInsideCreating = false;
  boolean showWhatToSaveOptions = true;
  boolean chaseWithStepsInsideIsCleared = false;
  void startCreatingChaseWidthStepsInside() { chaseWithStepsInsideCreating = true; parent.type = 6; chaseWithStepsInsideIsCleared = false; }
  void createNextStep(boolean[] newWhatToSave) {
    Preset x = new Preset(this);
    steps.add(x);
    x.savePreset(newWhatToSave);
  }
  void endCreatingChaseWidthStepsInside() { chaseWithStepsInsideCreating = false; }
  void clearChaseWidthStepsInside() { steps = new ArrayList<Preset>(); chaseWithStepsInsideIsCleared = true; }
  boolean creatingChaseWithStepsInside() { return chaseWithStepsInsideCreating; }
  boolean clearedChaseWithStepsInside() { return chaseWithStepsInsideIsCleared; }
} //end of chase class-----------------------------------------------------------------------------------------------------------------------------------------------------


//inside papplet


class soundDetect { //----------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  //init all the variables
  float[] bands = new float[getFreqMax()];
  float[] avgTemp = new float[getFreqMax()];
  float[] avgCounter = new float[getFreqMax()];
  float[] avg = new float[getFreqMax()];
  float[] currentAvgTemp = new float[getFreqMax()];
  float[] currentAvg = new float[getFreqMax()];
  float[] currentAvgCounter = new float[getFreqMax()];
  float[] max = new float[getFreqMax()];
 
  boolean blinky = true;
  
  int oldFrameCount = 0;
  boolean onset, kick, snare, hat;
  
  //end initing variables
  
  
  
  soundDetect() {
  }
  
  
  boolean beat(int bT) {
    beat.detect(in.mix); //beat detect command of minim library
    boolean toReturn = true;
    
    if(frameCount > oldFrameCount) {
      oldFrameCount = frameCount;
      switch(bT) {
        case 1: toReturn = beat.isOnset(); onset = toReturn; break;
        case 2: toReturn = beat.isKick(); kick = toReturn; break;
        case 3: toReturn = beat.isSnare(); snare = toReturn; break;
        case 4: toReturn = beat.isHat(); hat = toReturn; break;
      }
    }
    else {
      switch(bT) {
        case 1: toReturn = onset; break;
        case 2: toReturn = kick; break;
        case 3: toReturn = snare; break;
        case 4: toReturn = hat; break;
      }
    }
    
    return toReturn;
  }
  
  
  //inside soundDetect class
  int freq(int i) { //Get freq of specific band
    float toReturn = 0;
    fft.forward(in.mix);
    toReturn = 0;
    float val = getBand(i);
    toReturn = constrain((map(val, avg[i], max[i], 0, 255*2)), 0, 255); //This is what this function returns
    { //Counting avg values
      avgTemp[i] += val;
      avgCounter[i]++;
      if(avgCounter[i] > 200) {
        avg[i] = (avg[i] + (avgTemp[i] / avgCounter[i])) / 2;
        avgTemp[i] = 0;
        avgCounter[i] = 0;
      }
    } //End of counting avg values
    
    { //Counting max values
      if(max[i] > 0.8) { max[i]-=0.01; } //Make sure max isn't too big
      if(val > max[i]) { max[i] = val; } //Make sure max isn't too small
    } //End of counting max values
    return round(toReturn);
    //command to get  right freq from fft or something like it.
  }
  
  float getBand(int i) {
    if(blinky) {
      return log(getRawBand(i));
    }
    else {
      return getRawBand(i);
    }
  }
  
  float getRawBand(int i) {
    return fft.getBand(i);
  }
  
  int getFreqMax() { //How many bands are available
    int toReturn = fft.specSize();
    return toReturn;
    //command which tells how many frequencies there is available.
  }
  
  
} //en of soundDetect class-----------------------------------------------------------------------------------------------------------------------------------------------------


//inside papplet



//Single Sine class

class sine {
  int kerroin = 2;
  chase parent;
  sine(int num, chase parent) {
    me = num;
    this.parent = parent;
    loc = new int[parent.getPresets().length*kerroin];
  }

  
  
  float ofset = 0;
  boolean up;
  float val;
  boolean go;
  boolean ready;
  
  int me;
  
  int[] loc;
  
  int n = 0;

  
  
  void draw() {

    float plus = map(parent.fade, 0, 255, 1.0, 0.05); //Value wich is added in every for loop
    ofset+=map(parent.fade, 0, 255, 2, 0.001); //How fast will wave go on
       
    int l = loc.length;
    loc = new int[loc.length]; //Reset loc
    
    //Sine wave itself
    for(float i = -HALF_PI; i <= HALF_PI; i+=plus) {
      { //The first half of the sine
        n = round(i+ofset)+4;
        n = constrain(n, 0, loc.length-2);
        val = sin(i)*255;
        loc[n+1] = round(map(val, -255, 255, 255, 0));
      } //End of firs half
      
      { //The second half of the sine
        n = round((i+ofset)-PI)+4;
        n = constrain(n, 0, loc.length-1);
        loc[n] = round(map(val, -255, 255, 0, 255));
      } //End of second half
    }
    
    if(ofset > parent.sineMax+1) {
      ready = true;
      go = false;
    }
    else {
      ready = false;
    }
    
    for(int i = 0; i < parent.sineValue.length; i++) {
      n = constrain(i*kerroin, 0, loc.length-1);
      if(i < parent.sineValue.length) {
        if(loc[n] > parent.sineValue[i]) { parent.sineValue[i] = loc[n]; }
      }
    }
  
  }
  
  void go() {
    go = true;
    ofset = -4;
  }
  
  
}

TapTempo tapTempo = new TapTempo();


class TapTempo {
  
  TapTempo() {
  }
  
  
  int length = 12;



  //Tempo tap feature ( = Maschine Auto Tap)----------
  
  //How many times the rec button has been pressed (4 is needed to start )
  int tempotapTapCount = 0;
  int[] tempotapTaps = new int[length];
  int tapStartMillis;
  
  boolean enable = false;
  int interval;
  
  int[] ellipseSize = new int[length];
  boolean[] ellipseSizeIsFull = new boolean[length];
  
  boolean calculatingRecently;
  long lastRegistered;
  
  boolean boxIsMax = false;
  boolean drawBox = false;
  float boxSize = 1;
  float scale = 1;
  
  void draw() {
    pushMatrix(); pushStyle();
    calculate();
    calculatingRecently = millis() - lastRegistered < interval;
    if(calculating) { drawBox = true; }
    if(drawBox) {
      fill(255, 230);
      translate(width/2, height/2);
      scale(scale);
      rect((-(30*length)/2-30*1.5)*boxSize, -50*boxSize, (30*length+30*2)*boxSize, 100*boxSize, 20*boxSize);
      if(calculating || calculatingRecently) {
        boxSize = 1;
        for(int i = 0; i < length; i++) {
          rectMode(CENTER);
          pushStyle();
          if(i <= tempoTapCountForVisualisation) {
            fill(topMenuAccent);
            noStroke();
            if(ellipseSize[i] < 4 && !ellipseSizeIsFull[i]) {
              ellipseSize[i]++;
            }
            else {
              ellipseSizeIsFull[i] = true;
            }
            if(ellipseSizeIsFull[i] && ellipseSize[i] > 0) {
              ellipseSize[i]--;
            }
          }
          else { fill(themes.buttonColor.neutral, 230); ellipseSizeIsFull[i] = false; }
          ellipse((-length*30)/2+i*30, 0, 10+ellipseSize[i]*5, 10+ellipseSize[i]*5);
          popStyle();
        }
      }
      else {
        if(!boxIsMax) {
          boxSize+=0.3;
          if(boxSize > 1.5) {
            boxIsMax = true;
          }
        }
        if(boxIsMax)
          if(boxSize > 0.5) {
            boxSize-=0.3;
          }
          else {
            boxIsMax = false;
            drawBox = false;
            boxSize = 1;
          }
        }
    }
    popMatrix(); popStyle();
  }
  
  boolean calculating = false;
  int tempoTapCountForVisualisation;
  
  long lastRegistered1 = 0;
  
  //This is triged when the rec button is pressed
  void register() {
    if(millis() - lastRegistered1 > 100) {
      lastRegistered1 = millis();
      //Go to next step
      lastRegistered = millis();
      steptriged = true; trig(true);
      tempoTapCountForVisualisation++;
      if (tempotapTapCount < length-1) {
        if (tempotapTapCount == 0) {  tapStartMillis = millis(); tempoTapCountForVisualisation = 0; ellipseSizeIsFull = new boolean[length]; ellipseSize = new int[length]; }
        tempotapTaps[tempotapTapCount] = millis() - tapStartMillis;
        trig(true);
        tempotapTapCount++;
        enable = false;
        calculating = true;
      } else {
        //Tempo tap finished. Calculate interval and begin autoic "tapping"
        tempotapTaps[length-1] = millis() - tapStartMillis;
        //calculate autoic tap interval
        
        //Calculate total sum of intervals between taps
        int total = 0;
        for (int i = 1; i <= length-1; i++) {
          total += tempotapTaps[i] - tempotapTaps[i - 1];
        }
        //Take average
        interval = int(total/(length-1));
        enable = true;
        calculating = false;
        clear();
      }
    }
      
  
  }
  
  boolean steptriged = false;
  int lastStepMillis;
  //This function gets triged every draw, so it can be used for other purposes as well.
  
 
  
  void calculate() {
  
    //------AutoTap calculations
    //Always turn off the booleans if they were put to true last time
    if(steptriged) { steptriged = false; trig(false); }
    if(enable) {
      if(millis() > lastStepMillis + interval) {
        steptriged = true;
        trig(true);
        lastStepMillis = millis() - (millis() - (lastStepMillis + interval))+1;
      }
    }
    
  }
  
  //Clean up  variables
  void clear() {
    tempotapTapCount = 0;
    tempotapTaps = new int[length];
    tapStartMillis = 0;
    
  }
  
  long oldFrameCount;
  
  
  boolean triggered = false;
  void trig(boolean trig) {
    triggered = trig;
  }
  
  boolean trigger() {
    return triggered;
  }

}
