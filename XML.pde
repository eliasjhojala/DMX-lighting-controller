void saveTestXML() {
  manageXML.addBlockAndIncrease("fixtures");
  for(int i = 0; i < fixtures.size(); i++) {
    manageXML.addBlockAndIncrease("Fixture");
    manageXML.addData("id", i);
      
      fixtures.get(i).saveFixtureDataToXML();
    manageXML.goBack();
  }
  manageXML.saveData();
  loadTestXML();
  saveMemoriesToXML();
}

void loadTestXML() {
  if(manageXML.loadData()) {
    manageXML.goToChild("fixtures");
      for(int i = 0; i < fixtures.size(); i++) {
        manageXML.goToChild("Fixture");
          fixtures.get(manageXML.getDataInt("id")).loadFixtureData();
        manageXML.goBack();
      }
    manageXML.goBack();
  }
}


ManageXML manageXML = new ManageXML();  
class ManageXML {
  XML currentBlock;
  XML xml;
  ManageXML() {
    String data = "<DMX_Controller></DMX_Controller>";
    xml = parseXML(data);
    currentBlock = xml.addChild("content");
  }
  
  //LOAD FROM XML
  boolean loadData() {
    xml = loadXML("DMX_Controller.xml");
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
    currentBlock = currentBlock.getChild(name);
    toReturn = currentBlock.getContent();
    currentBlock = currentBlock.getParent();
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
  void addBlock(String name, int content) {
    addBlock(name, str(content));
  }
  void addBlock(String name, String content) {
    XML newBlock = currentBlock.addChild(name);
    newBlock.setContent(content);
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
    saveXML(xml, "DMX_Controller.xml");
  }
  
}
