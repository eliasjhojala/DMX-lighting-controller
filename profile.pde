/*
PROFILE CREATION GUI CODER TIPS

- add fixtureType button opens menu which ask following things
- fixtureName? --> textbox which data is saved into fixtureName variable
- fixtureLongName? --> textbox which data is saved into fixtureLongName variable
- fixtureBrand --> textbox which data is saved into fixtureBrand variable
- add channel button --> ask what kind of channel this channel is
    --> user can add as many channels as he wants
    --> select some of the followings
    --> finally save selected channels as array channelNames and channelTypes
- ask user to stretch square as big as he wants
    --> save data as fixtureSize size = new fixtureSize(w, h, true);
- fixtureProfiles[id] = new FixtureProfile(fixtureName, fixtureLongName, fixtureBrand, channelNames, channelTypes, size);
    
          list of dmx channels:
_____________________________________________          
channelName        | channelTypeNumber
-------------------|-------------------------
"Dimmer"           | DMX_DIMMER
"Red"              | DMX_RED
"Green"            | DMX_GREEN
"Blue"             | DMX_BLUE
"White"            | DMX_WHITE
"Amber"            | DMX_AMBER
"Pan"              | DMX_PAN
"Tilt"             | DMX_TILT
"Pan fine"         | DMX_PANFINE
"Tilt fine"        | DMX_TILTFINE
"Colorwheel"       | DMX_COLORWHEEL
"Gobowheel"        | DMX_GOBOWHEEL
"Goborotation"     | DMX_GOBOROTATION
"Prism"            | DMX_PRISM
"Focus"            | DMX_FOCUS
"Shutter"          | DMX_SHUTTER
"Strobe"           | DMX_STROBE
"Frequency"        | DMX_FREQUENCY
"Response speed"   | DMX_RESPONSESPEED
"Auto programs"    | DMX_AUTOPROGRAMS
"Special functions"| DMX_SPECIALFUNCTIONS
"Haze"             | DMX_HAZE
"Fan"              | DMX_FAN
"Fog"              | DMX_FOG
"Special ch 1"     | DMX_SPECIAL1
"Special ch 2"     | DMX_SPECIAL2
"Special ch 3"     | DMX_SPECIAL3
"Special ch 4"     | DMX_SPECIAL4

*/

class FixtureProfile {
  String modelPath = "par64.obj";
  PShape model = loadShape(dataPath(modelPath));
  
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
  
  void setModel(String path) {
    modelPath = path;
    model = loadShape(dataPath(modelPath));
  }
  
  PShape getModel() {
    return model;
  }
}
