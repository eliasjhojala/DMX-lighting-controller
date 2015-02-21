FixtureProfile[] fixtureProfiles = new FixtureProfile[19]; 

void saveFixtureProfiles() {
  
  XML xml;
  String data = "<fixtureProfiles></fixtureProfiles>";
  xml = parseXML(data);
  
  XML profiles = xml.addChild("profiles");
  for(int i = 0; i < fixtureProfiles.length; i++) {
    XML profile = profiles.addChild("profile");
    profile.setInt("id", i);
    profile.setString("fixtureName", fixtureProfiles[i].fixtureName);
    profile.setString("fixtureLongName", fixtureProfiles[i].fixtureLongName);
    profile.setString("fixtureBrand", fixtureProfiles[i].fixtureBrand);
    XML channelNames = profile.addChild("channelNames");
    for(int j = 0; j < fixtureProfiles[i].channelNames.length; j++) {
      XML channelName = channelNames.addChild("channelName");
      channelName.setInt("id", j);
      channelName.setContent(fixtureProfiles[i].channelNames[j]);
    }
    
    XML channelTypes = profile.addChild("channelTypes");
    for(int j = 0; j < fixtureProfiles[i].channelTypes.length; j++) {
      XML channelType = channelTypes.addChild("channelType");
      channelType.setInt("id", j);
      channelType.setContent(str(fixtureProfiles[i].channelTypes[j]));
    }
    
    XML fixtureSize = profile.addChild("fixtureSize");
    XML w = fixtureSize.addChild("width");
    w.setContent(str(fixtureProfiles[i].size.w));
    XML h = fixtureSize.addChild("height");
    h.setContent(str(fixtureProfiles[i].size.h));
    XML isDrawn = fixtureSize.addChild("isDrawn");
    isDrawn.setContent(str(fixtureProfiles[i].size.isDrawn));
  }
  saveXML(xml, "fixtureProfiles.xml");
}

void loadFixtureProfiles() {
      XML xml;
    
      xml = loadXML("fixtureProfiles.xml");
      XML profiles = xml.getChild("profiles");
      XML[] profile = profiles.getChildren("profile");
    
    
      fixtureProfiles = new FixtureProfile[profile.length];
      for (int i = 0; i < profile.length; i++) {
        fixtureProfiles[profile[i].getInt("id")] = new FixtureProfile();
        fixtureProfiles[profile[i].getInt("id")].fixtureName = profile[i].getString("fixtureName");
      }
}

void createFixtureProfiles() {
  fixtureProfiles[0] = new FixtureProfile("", new String[] { }, new int[] { }, toFixtureSize(50, 50, false) );
  fixtureProfiles[1] = new FixtureProfile("par64", "PAR64", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(30, 50) );
  fixtureProfiles[2] = new FixtureProfile("p.fresu", "Pieni fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(25, 30) );
  fixtureProfiles[3] = new FixtureProfile("k.fresu", "Keskikokoinen fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(35, 40) );
  fixtureProfiles[4] = new FixtureProfile("i.fresu", "Iso fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(40, 50) );
  fixtureProfiles[5] = new FixtureProfile("flood", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(40, 20) );
  fixtureProfiles[6] = new FixtureProfile("linssi", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(20, 60) );
  
  fixtureProfiles[7] = new FixtureProfile("Strobe", new String[] {"Dimmer", "Frequency"}, new int[] {DMX_DIMMER, DMX_FREQUENCY}, toFixtureSize(40, 25) );
  fixtureProfiles[8] = new FixtureProfile("Hazer", new String[] {"Haze", "Fan"}, new int[] {DMX_HAZE, DMX_FAN}, toFixtureSize(40, 45) );
  fixtureProfiles[9] = new FixtureProfile("Fog", new String[] {"Fog"}, new int[] {DMX_FOG}, toFixtureSize(40, 55) );
 
  fixtureProfiles[16] = new FixtureProfile("RGBW", "Stairville 8ch rgbw led", 
    new String[] {"Red", "Green", "Blue", "White", "Color", "Strobe", "Mode", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2, DMX_STROBE, DMX_SPECIAL1, DMX_DIMMER} );
    
  fixtureProfiles[15] = new FixtureProfile("RGBW", "Stairville 6ch rgbw led",
    new String[] {"Mode", "Red", "Green", "Blue", "White", "Effect"}, 
    new int[] {DMX_SPECIAL1, DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2} );
    
  fixtureProfiles[14] = new FixtureProfile("RGBW", "Stairville 4ch rgbw led",
    new String[] {"Red", "Green", "Blue", "White"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
    
  fixtureProfiles[13] = new FixtureProfile("RGBWD", new String[] {"Red", "Green", "Blue", "White", "Dimmer"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_DIMMER} );
  fixtureProfiles[12] = new FixtureProfile("RGBW", new String[] {"Red", "Green", "Blue", "White"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
  fixtureProfiles[11] = new FixtureProfile("RGBD", new String[] {"Red", "Green", "Blue", "Dimmer"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_DIMMER} );
  fixtureProfiles[10] = new FixtureProfile("RGB", new String[] {"Red", "Green", "Blue"}, new int[] {DMX_RED, DMX_GREEN, DMX_BLUE} );
    
  fixtureProfiles[17] = new FixtureProfile("MHX50", 
    new String[] {"Pan", "Tilt", "Pan fine", "Tilt fine", "Responsespeed", "Colorwheel", "Shutter", "Dimmer", "Gobowheel", "Goborotation", "Specialfunctions", "Autoprograms", "Prism", "Focus" }, 
    new int[] { DMX_PAN, DMX_TILT, DMX_PANFINE, DMX_TILTFINE, DMX_RESPONSESPEED, DMX_COLORWHEEL, DMX_SHUTTER, DMX_DIMMER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_SPECIALFUNCTIONS, DMX_AUTOPROGRAMS, DMX_PRISM, DMX_FOCUS } );
    
  fixtureProfiles[18] = new FixtureProfile("MHX50", 
    new String[] {"Pan", "Tilt", "Colorwheel", "Shutter", "Gobowheel", "Gobo rotation", "Prism", "Focus" }, 
    new int[] {DMX_PAN, DMX_TILT, DMX_COLORWHEEL, DMX_SHUTTER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_PRISM, DMX_FOCUS} );
    
    
  saveFixtureProfiles();
  loadFixtureProfiles();
}
