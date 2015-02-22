void saveTestXML() {
  manageXML.addBlockAndIncrease("fixtures");
  for(int i = 0; i < fixtures.size(); i++) {
    manageXML.addBlockAndIncrease("Fixture");
    manageXML.addData("id", i);
      manageXML.addBlock("StartChannel", str(fixtures.get(i).channelStart));
      manageXML.addBlock("fixtureTypeId", str(fixtures.get(i).fixtureTypeId));
      manageXML.addBlock("fixtureType", getFixtureName(i)); //This is not so important but let's do this because then file is better readable by human
      
    manageXML.goBack();
  }
  manageXML.saveData();
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
  
  void addData(String name, int data) {
    currentBlock.setInt(name, data);
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
