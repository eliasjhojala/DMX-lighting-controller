fixture[][] repOfFixtures = new fixture[fixtures.length][numberOfMemories];
void saveFixtureMemory(int fixtureMemoryId) {
      for(int i = 0; i < fixtures.length; i++) {
      repOfFixtures[i][fixtureMemoryId] = new fixture();
  }
  for (int i = 0; i < fixtures.length; i++) {
    if(whatToSave[fixtureMemoryId][0]) {
     repOfFixtures[i][fixtureMemoryId].dimmer = fixtures[i].dimmer;
    }
  }
  memoryType[fixtureMemoryId] = 1;
}



void loadFixtureMemory(int fixtureMemoryId, int value) {
  
  for (int i = 0; i < fixtures.length; i++) {
    if(whatToSave[fixtureMemoryId][0]) {
      int val = int(map(repOfFixtures[i][fixtureMemoryId].dimmer, 0, 255, 0, value));
      println(val);
      if(val > fixtures[i].dimmerPresetTarget) {
        fixtures[i].dimmerPresetTarget = val;
      }
    }
  }
}
