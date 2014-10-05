//Tässä välilehdessä muutetaan fixtuurien ID:tä. Voideja kutsutaan controlP5:stä

void change_fixture_id(int originalFixtureId) {
  //Reset temporary variables
  fixtureIdNowTemp = new int[numberOfAllFixtures];
  fixtureIdNewTemp = new int[numberOfAllFixtures];
  fixtureIdOldTemp = new int[numberOfAllFixtures];
  
  //Save current data to temporary variables
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdNowTemp[i] = fixtureIdNow[i];
  }
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]+1];
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]+1] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]];

  fixtureIdPlaceInArray[originalFixtureId]++; 
  fixtureIdPlaceInArray[originalFixtureId+1]--; 
}
void change_fixture_id_down(int originalFixtureId) {
  //Reset temporary variables
  fixtureIdNowTemp = new int[numberOfAllFixtures];
  fixtureIdNewTemp = new int[numberOfAllFixtures];
  fixtureIdOldTemp = new int[numberOfAllFixtures];
  
  //Save current data to temporary variables
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdNowTemp[i] = fixtureIdNow[i];
  }
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]-1];
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]-1] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]];

  fixtureIdPlaceInArray[originalFixtureId]--;
  if(originalFixtureId-1 >= 0) {
    fixtureIdPlaceInArray[originalFixtureId-1]++; 
  }
}
