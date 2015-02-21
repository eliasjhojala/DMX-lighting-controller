class FixtureProfile {
  String fixtureName;
  String fixtureLongName;
  String fixtureBrand;
  
  
  String[] channelNames;
  int[] channelTypes;
  fixtureSize size;
  
  FixtureProfile() {
    String[] empty = { "" };
    int[] emptyy = { 0 };
    setBasicData("", empty, emptyy);
  }
  
  FixtureProfile(String fN, String fln, String[] cN, int[] cT, fixtureSize s) {
    setBasicData(fN, cN, cT, s);
    fixtureLongName = fln;
  }
  
  FixtureProfile(String fN, String fln, String[] cN, int[] cT) {
    setBasicData(fN, cN, cT);
    fixtureLongName = fln;
  }

  FixtureProfile(String fN, String fln, String fB, String[] cN, int[] cT, fixtureSize s) {
    setBasicData(fN, cN, cT, s);
    setFixtureNameData(fln, fB);
  }
  
  FixtureProfile(String fN, String fln, String fB, String[] cN, int[] cT) {
    setBasicData(fN, cN, cT);
    setFixtureNameData(fln, fB);
  }
  
  FixtureProfile(String fN, String[] cN, int[] cT, fixtureSize s) {
    setBasicData(fN, cN, cT, s);
  }
  
   FixtureProfile(String fN, String[] cN, int[] cT) {
    setBasicData(fN, cN, cT);
  }
  
  
  void setBasicData(String fN, String[] cN, int[] cT) {
    fixtureName = fN;
    channelNames = cN;
    channelTypes = cT;
    fixtureSize s = new fixtureSize(30, 40, true);
    setBasicData(fN, cN, cT, s);
  }
  

  void setBasicData(String fN, String[] cN, int[] cT, fixtureSize s) {
    fixtureName = fN;
    channelNames = cN;
    channelTypes = cT;
    size = s;
  }
  
  void setFixtureNameData(String fln, String fB) {
    fixtureLongName = fln;
    fixtureBrand = fB;
  }
}
