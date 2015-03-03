FixtureProfile[] fixtureProfiles = new FixtureProfile[19]; 
DropdownMenu fixtureTypes;
void createFixtureProfiles() {
    loadFixtureProfiles();
    
    ArrayList<DropdownMenuBlock> fixtureTypeBlocks = new ArrayList<DropdownMenuBlock>();
    for(int i = 1; i < fixtureProfiles.length; i++) {
      String name = "";
      if(fixtureProfiles[i].fixtureLongName.equals("")) {
        name = fixtureProfiles[i].fixtureName;
      }
      else {
        name = fixtureProfiles[i].fixtureLongName;
      }
      DropdownMenuBlock newType = new DropdownMenuBlock(name, i);
      fixtureTypeBlocks.add(newType);
    }
    fixtureTypes = new DropdownMenu("fixtureTypes", fixtureTypeBlocks);
    fixtureTypes.setBlockSize(new PVector(170, 22));
    
}
