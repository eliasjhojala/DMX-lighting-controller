class FixtureProfile {
  String fixtureName;
  String[] channelNames;
  int[] channelTypes;
  fixtureSize size;
  
  FixtureProfile(String fN, String[] cN, int[] cT, fixtureSize s) {
    fixtureName = fN;
    channelNames = new String[cN.length];
    channelTypes = new int[cT.length];
    arrayCopy(cN, channelNames);
    arrayCopy(cT, channelTypes);
    size = new fixtureSize(s.w, s.h, s.isDrawn);
  }
  
   FixtureProfile(String fN, String[] cN, int[] cT) {
    fixtureName = fN;
    channelNames = new String[cN.length];
    channelTypes = new int[cT.length];
    arrayCopy(cN, channelNames);
    arrayCopy(cT, channelTypes);
    size = new fixtureSize(30, 40, true);
  }
}
