class FixtureProfile {
  String fixtureName;
  String[] channelNames;
  int[] channelTypes;
  fixtureSize size;
  
  FixtureProfile(String fN, String[] cN, int[] cT, fixtureSize s) {
    fixtureName = fN;
    arrayCopy(cN, channelNames);
    arrayCopy(cT, channelTypes);
    size = s;
  }
  
   FixtureProfile(String fN, String[] cN, int[] cT) {
    fixtureName = fN;
    channelNames = new String[cN.length];
    channelTypes = new int[cT.length];
    arrayCopy(cN, channelNames);
    arrayCopy(cT, channelTypes);
  }
}
