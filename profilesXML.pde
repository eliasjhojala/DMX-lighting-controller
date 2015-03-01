//FixtureProfile[] fixtureProfiles = new FixtureProfile[19]; 

String nameOfProfileFile = "fixtureProfiles.xml"; //Name of xml file where all the fixtureProfile data is located

boolean loadingFixtureProfiles = false;
void saveFixtureProfiles() {
  //This function saves all the fixtureProfiles to xml file
  //This will be useful when qui for adding fixtureProfiles is ready
  
  XML xml; //define xml variable
  String data = "<fixtureProfiles></fixtureProfiles>"; //Make base for xml data file
  xml = parseXML(data); //parse xml base to xml variable
  
  XML profiles = xml.addChild("profiles"); //add profiles parent for all the profiles
  
  for(int i = 0; i < fixtureProfiles.length; i++) { //Go through all the fixtureProfiles
    XML profile = profiles.addChild("profile"); //child for single profile
    profile.setInt("id", i);
    
    { //Save profile's nameData
      profile.setString("fixtureName", fixtureProfiles[i].fixtureName); //Save fixtureName
      profile.setString("fixtureLongName", fixtureProfiles[i].fixtureLongName); //Save fixtureLongName
      profile.setString("fixtureBrand", fixtureProfiles[i].fixtureBrand); //Save fixtureBrand
    } //End of saving profile's nameData
    
    { //Save channelNames
      XML channelNames = profile.addChild("channelNames");
      for(int j = 0; j < fixtureProfiles[i].channelNames.length; j++) {
        XML channelName = channelNames.addChild("channelName");
        channelName.setInt("id", j);
        channelName.setContent(fixtureProfiles[i].channelNames[j]);
      }
    } //End of saving channelNames
    
    { //save channelTypes
      XML channelTypes = profile.addChild("channelTypes");
      for(int j = 0; j < fixtureProfiles[i].channelTypes.length; j++) {
        XML channelType = channelTypes.addChild("channelType");
        channelType.setInt("id", j);
        channelType.setContent(str(fixtureProfiles[i].channelTypes[j]));
      }
    } //End of saving channelTypes
    
    { //save fixtureSize
      XML fixtureSize = profile.addChild("fixtureSize");
      XML w = fixtureSize.addChild("width");
      w.setContent(str(fixtureProfiles[i].size.w));
      XML h = fixtureSize.addChild("height");
      h.setContent(str(fixtureProfiles[i].size.h));
      XML isDrawn = fixtureSize.addChild("isDrawn");
      isDrawn.setContent(str(fixtureProfiles[i].size.isDrawn));
    } //end of saving fixtureSize
  
  
    { //load fixture model PShape
      XML fixtureModelPath = profile.addChild("fixtureModelPath");
      fixtureModelPath.setContent(fixtureProfiles[i].modelPath);
    } //end of loading fixture model PShape
    
  } //End of going through all the profiles
  saveXML(xml, nameOfProfileFile); //Finally save xml which we have created
} //End of saving all the fixtureProfiles to xml

void loadFixtureProfiles() {
  //This function loads all the fixtureProfiles from XML file
  loadingFixtureProfiles = true;
  XML xml; //Define xml variable

  xml = loadXML(nameOfProfileFile); //load XML from file
  XML profiles = xml.getChild("profiles"); //parent of all the profiles
  XML[] profile = profiles.getChildren("profile"); //single profiles


  fixtureProfiles = new FixtureProfile[profile.length];
  for (int i = 0; i < profile.length; i++) { //Go through all the profiles
    int id = profile[i].getInt("id"); //Get profile id
    fixtureProfiles[id] = new FixtureProfile(); //Create new fixtureProfile with no data
    
    { //Load profile's nameData
      fixtureProfiles[id].fixtureName = profile[i].getString("fixtureName"); //Set fixtureName for profile
      fixtureProfiles[id].fixtureLongName = profile[i].getString("fixtureLongName"); //Set fixtureLongName for profile
      fixtureProfiles[id].fixtureBrand = profile[i].getString("fixtureBrand"); //Set fixtureBrand for profile
    } //End of loading profile's nameData
    
    { //load channelNames
      XML channelNames = profile[i].getChild("channelNames"); //parent of all the channelNames
      XML[] channelName = channelNames.getChildren("channelName"); //single channelNames
      fixtureProfiles[id].channelNames = new String[channelName.length]; //define channelNames array
      for(int j = 0; j < channelName.length; j++) { //go through all the fixtureProfile
        fixtureProfiles[id].channelNames[j] = channelName[j].getContent(); //Set right channelNames to fixtureProfile
      }
    } //end of loading channelNames
    
    { //load channelTypes
      XML channelTypes = profile[i].getChild("channelTypes"); //parent of all the channelTypes
      XML[] channelType = channelTypes.getChildren("channelType"); //single channelTypes
      fixtureProfiles[id].channelTypes = new int[channelType.length]; //define channelTyeps array
      for(int j = 0; j < channelType.length; j++) { //Go through all the channelTypes
        fixtureProfiles[id].channelTypes[j] = int(channelType[j].getContent()); //Set right channelTypes to fixtureProfile
      }
    } //end of loading channelTypes
    
    { //load fixtureSize
      XML fixtureSize = profile[i].getChild("fixtureSize"); //parent of fixtureSize data
      XML w = fixtureSize.getChild("width");
      fixtureProfiles[id].size.w = int(w.getContent());
      XML h = fixtureSize.getChild("height");
      fixtureProfiles[id].size.h = int(h.getContent());
      XML isDrawn = fixtureSize.getChild("isDrawn");
      fixtureProfiles[id].size.isDrawn = boolean(isDrawn.getContent());
    } //end of loading fixtureSize
    
     { //load fixture model PShape
      XML fixtureModelPath = profile[i].getChild("fixtureModelPath");
      if(fixtureModelPath != null) {
        fixtureProfiles[id].setModel(fixtureModelPath.getContent());
      }
      
      fixtureProfiles[id].checkDMXchannels(); //Check DMX channels if there is strobe or something like that
    } //end of loading fixture model PShape
  } //End of going through all the profiles
  loadingFixtureProfiles = false;
} //End of loading fixtureProfiles from xml


