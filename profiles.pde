FixtureProfile[] fixtureProfiles = new FixtureProfile[19]; 
void createFixtureProfiles() {
  fixtureProfiles[1] = new FixtureProfile("par64", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(30, 50) );
  fixtureProfiles[2] = new FixtureProfile("p.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(25, 30) );
  fixtureProfiles[3] = new FixtureProfile("k.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(35, 40) );
  fixtureProfiles[4] = new FixtureProfile("i.fresu", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(40, 50) );
  fixtureProfiles[5] = new FixtureProfile("flood", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(40, 20) );
  fixtureProfiles[6] = new FixtureProfile("linssi", new String[] {"Dimmer"}, new int[] {DMX_DIMMER}, toFixtureSize(20, 60) );
  
  fixtureProfiles[7] = new FixtureProfile("Strobe", new String[] {"Dimmer", "Frequency"}, new int[] {DMX_DIMMER, DMX_FREQUENCY}, toFixtureSize(40, 25) );
  fixtureProfiles[8] = new FixtureProfile("Hazer", new String[] {"Haze", "Fan"}, new int[] {DMX_HAZE, DMX_FAN}, toFixtureSize(40, 45) );
  fixtureProfiles[9] = new FixtureProfile("Fog", new String[] {"Fog"}, new int[] {DMX_FOG}, toFixtureSize(40, 55) );
 
  fixtureProfiles[16] = new FixtureProfile("strv 8ch", 
    new String[] {"Red", "Green", "Blue", "White", "Color", "Strobe", "Mode", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2, DMX_STROBE, DMX_SPECIAL1, DMX_DIMMER} );
    
  fixtureProfiles[15] = new FixtureProfile("strv 6ch", 
    new String[] {"Mode", "Red", "Green", "Blue", "White", "Effect"}, 
    new int[] {DMX_SPECIAL1, DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_SPECIAL2} );
    
  fixtureProfiles[14] = new FixtureProfile("strv 4ch", 
    new String[] {"Red", "Green", "Blue", "White"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
    
  fixtureProfiles[13] = new FixtureProfile("RGBWD", 
    new String[] {"Red", "Green", "Blue", "White", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE, DMX_DIMMER} );
    
  fixtureProfiles[12] = new FixtureProfile("RGBW", 
    new String[] {"Red", "Green", "Blue", "White"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_WHITE} );
    
  fixtureProfiles[11] = new FixtureProfile("RGBD", 
    new String[] {"Red", "Green", "Blue", "Dimmer"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE, DMX_DIMMER} );
    
  fixtureProfiles[10] = new FixtureProfile("RGB", 
    new String[] {"Red", "Green", "Blue"}, 
    new int[] {DMX_RED, DMX_GREEN, DMX_BLUE} );
    
  fixtureProfiles[17] = new FixtureProfile("MHX50", 
    new String[] {"Pan", "Tilt", "Pan fine", "Tilt fine", "Responsespeed", "Colorwheel", "Shutter", "Dimmer", "Gobowheel", "Goborotation", "Specialfunctions", "Autoprograms", "Prism", "Focus" }, 
    new int[] { DMX_PAN, DMX_TILT, DMX_PANFINE, DMX_TILTFINE, DMX_RESPONSESPEED, DMX_COLORWHEEL, DMX_SHUTTER, DMX_DIMMER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_SPECIALFUNCTIONS, DMX_AUTOPROGRAMS, DMX_PRISM, DMX_FOCUS } );
    
  fixtureProfiles[18] = new FixtureProfile("MHX50", 
    new String[] {"Pan", "Tilt", "Colorwheel", "Shutter", "Gobowheel", "Gobo rotation", "Prism", "Focus" }, 
    new int[] {DMX_PAN, DMX_TILT, DMX_COLORWHEEL, DMX_SHUTTER, DMX_GOBOWHEEL, DMX_GOBOROTATION, DMX_PRISM, DMX_FOCUS} );
    
}
