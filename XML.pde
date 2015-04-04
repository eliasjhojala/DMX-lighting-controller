//Functions to handle XML are located in this tab

String showFilePath = "XML/ShowFile.xml";

void saveShowFileXML() {
  String data = "<ShowFile></ShowFile>";
  XML xml = parseXML(data);
  XML block;
  
  block = xml.addChild("Fixtures");
  block = block.addChild(getFixturesXML());
  
  block = xml.addChild("Memories");
  block = block.addChild(getMemoriesAsXML());
  
  block = xml.addChild("Trusses");
  block = block.addChild(getTrussesAsXML());
  
  block = xml.addChild("Dimmers");
  block = block.addChild(dimmersAsXML());
  
  block = xml.addChild("Elements");
  block = block.addChild(elementsAsXML());
  
  block = xml.addChild("Sockets");
  block = block.addChild(getSocketsAsXML());
  
  block = xml.addChild("OSCHandler");
  block = block.addChild(oscHandler.getXML());
  
  XML midi = xml.addChild("Midi");
  
  block = midi.addChild("Launchpad");
  if(launchpad != null) block = block.addChild(launchpad.getXML());
  
  block = midi.addChild("LC2412");
  if(LC2412 != null) block = block.addChild(LC2412.getXML());
  
  XML visualisation = xml.addChild("Visualisation");
  visualisation.addChild(get3DasXML());
  visualisation.addChild(get2DasXML());
  
  saveXML(xml, showFilePath);
  
  
}

void loadShowFileFromXML() {
  XML xml = loadXML(showFilePath);
  XML block;
  
  XMLtoFixtures(xml.getChild("Fixtures").getChild("fixtures"));
  XMLtoMemories(xml.getChild("Memories").getChild("Memories"));
  XMLtoTrusses(xml.getChild("Trusses").getChild("Trusses"));
  XMLtoDimmers(xml.getChild("Dimmers").getChild("dimmers"));
  XMLtoElements(xml.getChild("Elements").getChild("elements"));
  XMLtoSockets(xml.getChild("Sockets").getChild("Sockets"));
  oscHandler.XMLtoObject(xml.getChild("OSCHandler").getChild("OSChandler"));
  
  block = xml.getChild("Midi");
  if(launchpad != null) launchpad.XMLtoObject(block.getChild("Launchpad").getChild("launchpad"));
  if(LC2412 != null) LC2412.XMLtoObject(block.getChild("LC2412").getChild("LC2412"));
  
  try {
    block = xml.getChild("Visualisation");
    XMLto3D(block.getChild("ThreeDee"));
    XMLto2D(block.getChild("TwoDee"));
  }
  catch (Exception e) {}
  

}

ManageXML fixtureXML = new ManageXML("XML/fixtures.xml");
ManageXML memoryXML = new ManageXML("XML/memories.xml");

boolean savingTestXML;
void saveTestXML() {
  savingTestXML = true;
  saveXML(getFixturesXML(), "XML/fixtures.xml");
  savingTestXML = false;
}

XML getFixturesXML() {
	String data = "<fixtures></fixtures>";
	XML xml = parseXML(data);

  for(int i = 0; i < fixtures.array.size(); i++) {
    int id = idLookupTable.indexOf(i);
    XML block = xml.addChild(fixtures.array.get(i).getXML());
    block.setInt("id", id);
  }
  return xml;
}



void loadTestXML() {
  XMLtoFixtures(loadXML("XML/fixtures.xml"));
}

void XMLtoFixtures(XML xml) {
    //IDLOOKUPTABLE TÄHÄN ROOPE TEEEE --- pitäisi olla nyt tehty (en kokeillut vielä)
    fixtures.clear();
      try {
        
        XML[] allTheFixtures = xml.getChildren();
        println(allTheFixtures);
        for(int i = 0; i < allTheFixtures.length; i++) {
          if(!trim(allTheFixtures[i].toString()).equals("")) {
            XML block = allTheFixtures[i];
            int id = block.getInt("id");
            fixture newFix = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            fixtures.add(newFix);
            newFix.loadFixtureData(block);
          }
        }
      }
      catch (Exception e) {
        e.printStackTrace();
      }
}


ManageXML manageXML = new ManageXML("XML/DMX_Controller.xml");
class ManageXML {
  XML currentBlock;
  XML xml;
  String path = "new.xml";
  ManageXML(String p) {
    String data = "<DMX_Controller></DMX_Controller>";
    xml = parseXML(data);
    currentBlock = xml.addChild("content");
    path = p;
  }
  
  ManageXML(XML newBlock) {
    xml = newBlock;
    currentBlock = xml;
  }
  
  //LOAD FROM XML
  boolean loadData() {
    xml = loadXML(path);
    currentBlock = xml.getChild("content");
    if(currentBlock != null) { return true; }
    return false;
  }
  boolean goToChild(String name) {
    currentBlock = currentBlock.getChild(name);
    if(currentBlock != null) { return true; }
    return false;
  }
  String getBlock(String name) {
    String toReturn = "";
    XML newBlock = currentBlock.getChild(name);
    if(newBlock != null) toReturn = newBlock.getContent();
    return toReturn;
  }
  String getBlockAndIncrease(String name) {
    String toReturn = "";
    currentBlock = currentBlock.getChild(name);
    toReturn = currentBlock.getContent();
    return toReturn;
  }
  String getDataString(String name) {
    return currentBlock.getString(name);
  }
  int getDataInt(String name) {
    if(currentBlock != null) return currentBlock.getInt(name);
    return 0;
  }
  float getDataFloat(String name) {
    return currentBlock.getFloat(name);
  }
  XML getCurrentXML() {
	return currentBlock;
  }
  int[] getArray(String name) {
    int[] data = { };
    if(goToChild(name)) {
      XML[] dataFromXML = currentBlock.getChildren();
      int[] id = new int[dataFromXML.length];
      int[] rawData = new int[dataFromXML.length];
      for(int i = 0; i < dataFromXML.length; i++) {
        id[i] = dataFromXML[i].getInt("id");
        rawData[i] = dataFromXML[i].getInt("val");
      }
      data = new int[max(id)+1];
      for(int i = 0; i < rawData.length; i++) {
        data[id[i]] = rawData[i];
      }
    }
    goBack();
    return data;
  }

  
  
  //SAVE TO XML
  void addData(String name, int data) {
    currentBlock.setInt(name, data);
  }
  void addData(String name, String data) {
    currentBlock.setString(name, data);
  }
  void addData(String name, float data) {
    currentBlock.setFloat(name, data);
  }
  void addData(String name, boolean data) {
    addData(name, int(data));
  }
  void addBlock(String name, int content) {
    addBlock(name, str(content));
  }
  void addBlock(String name, String content) {
    XML newBlock = currentBlock.addChild(name);
    newBlock.setContent(content);
  }
  void addBlock(String name, boolean content) {
    addBlock(name, int(content));
  }
  void addBlockAndIncrease(String name, String content) {
    currentBlock = currentBlock.addChild(name);
    currentBlock.setContent(content);
  }
  void addBlock(String name) {
    XML newBlock = currentBlock.addChild(name);
  }
  void addBlockAndIncrease(String name) {
    currentBlock = currentBlock.addChild(name);
  }
  void addBlock(XML block) {
	XML newBlock = currentBlock.addChild(block);
  }
  void addArray(String name, int[] data) {
    if(data != null) {
      addBlockAndIncrease(name);
        if(max(data) > 0 || min(data) < 0) {
          for(int i = 0; i < data.length; i++) {
            if(data[i] != 0) {
              addBlockAndIncrease("int");
                addData("id", i);
                addData("val", data[i]);
              goBack();
            }
          }
        }
      goBack();
    }
  }
  
  //Functions for save and load
  void goBack() {
    currentBlock = currentBlock.getParent();
  }
  void goBack(int timesToGoBack) {
    for(int i = 0; i < timesToGoBack; i++) {
      currentBlock = currentBlock.getParent();
    }
  }
  void goToRoot() {
    currentBlock = xml.getChild("content");
  }
  void saveData() {
    saveXML(xml, path);
  }
  
}


void setIntXML(String name, int data, XML block) {
  if(data != 0) {
    block.setInt(name, data);
  }
}

int getIntXML(String name, XML block) {
  if(block != null) {
    return block.getInt(name);
  }
  return 0;
}
