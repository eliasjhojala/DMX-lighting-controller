
ManageXML fixtureXML = new ManageXML("XML/fixtures.xml");
ManageXML memoryXML = new ManageXML("XML/memories.xml");

void saveTestXML() {
  ManageXML XMLObject = fixtureXML;
  XMLObject.addBlockAndIncrease("fixtures");
  for(int i = 0; i < fixtures.size(); i++) {
    XMLObject.addBlockAndIncrease("Fixture");
    XMLObject.addData("id", i);
      
      fixtures.get(i).saveFixtureDataToXML(XMLObject);
    XMLObject.goBack();
  }
//  XMLObject.saveData();
  loadTestXML();
  saveMemoriesToXML();
//  loadMemoriesFromXML();
}

void loadTestXML() {
  ManageXML XMLObject = fixtureXML;
  ManageXML SingleFixture;
  if(XMLObject.loadData()) {
    XMLObject.goToChild("fixtures");
    XML[] allTheFixtures = XMLObject.currentBlock.getChildren();
      for(int i = 0; i < fixtures.size(); i++) {
        SingleFixture = new ManageXML(allTheFixtures[i]);

        println(SingleFixture.currentBlock);
        if(SingleFixture.currentBlock != null) {
        println(SingleFixture.getBlock("Color"));
        }
        //fixtures.get(SingleFixture.getDataInt("id")).loadFixtureData(fixtureXML);
        //SingleFixture.goBack();
      }
    XMLObject.goBack();
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
    return currentBlock.getInt(name);
  }
  float getDataFloat(String name) {
    return currentBlock.getFloat(name);
  }
  int[] getArray(String name) {
    int[] data = { };
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