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

    
//  saveFixtureProfiles();
  loadFixtureProfiles();
}
