//Tässä välilehdessä muutetaan fixtuurien ID:tä. Voideja kutsutaan controlP5:stä

void change_fixture_id(int originalFixtureId) {
  //Nollataan väliaikaismuuttujat
  fixtureIdNowTemp = new int[numberOfAllFixtures];
  fixtureIdNewTemp = new int[numberOfAllFixtures];
  fixtureIdOldTemp = new int[numberOfAllFixtures];
  
  //Kirjoitetaan väliaikaismuuttujiin nykyiset tiedot
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdNowTemp[i] = fixtureIdNow[i];
  }
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]+1];
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]+1] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]];

  fixtureIdPlaceInArray[originalFixtureId]++; 
  
}
void change_fixture_id_down(int originalFixtureId) {
  //Nollataan väliaikaismuuttujat
  fixtureIdNowTemp = new int[numberOfAllFixtures];
  fixtureIdNewTemp = new int[numberOfAllFixtures];
  fixtureIdOldTemp = new int[numberOfAllFixtures];
  
  //Kirjoitetaan väliaikaismuuttujiin nykyiset tiedot
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdNowTemp[i] = fixtureIdNow[i];
  }
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]-1];
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]-1] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]];

  fixtureIdPlaceInArray[originalFixtureId]--; 
  
}
