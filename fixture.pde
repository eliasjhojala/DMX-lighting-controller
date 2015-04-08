FixtureControllerWindow fixtureController = new FixtureControllerWindow();
class FixtureControllerWindow {
  Window window;
  int locX, locY, w, h;
  boolean open;
  int x_location, y_location, z_location;
  
  
  fixture fix;
  IntController xL, yL, zL;
  PushButton addNewAllowedTrussForWiring;
  DropdownMenu trussesDDM;
  DropdownMenu socketsDDM;
  
  IntController watts, channel;
  
  FixtureControllerWindow() {
    w = 1000; h = 500;
    window = new Window("fixtureController", new PVector(w, h), this);
    
    xL = new IntController("LocationController"+this.toString()+":xL");
    yL = new IntController("LocationController"+this.toString()+":yL");
    zL = new IntController("LocationController"+this.toString()+":zL");
    
    watts = new IntController("Watts"+this.toString());
    channel = new IntController("Channel"+this.toString());
    
    addNewAllowedTrussForWiring = new PushButton("addNewAllowedTrussForWiring");
    
    updateTrusses();
    updateSockets();
  }
  
  void updateSockets() {
    if(sockets != null) {
      ArrayList<DropdownMenuBlock> blocks = new ArrayList<DropdownMenuBlock>();
      for(int i = 0; i < sockets.size(); i++) {
        blocks.add(new DropdownMenuBlock("Socket " + sockets.get(i).name, i));
      }
      
      if(blocks != null) socketsDDM = new DropdownMenu("SocketParentTruss", blocks);
    }
    
    
  }
  
  void updateTrusses() {
    if(trusses != null) {
      ArrayList<DropdownMenuBlock> blocks = new ArrayList<DropdownMenuBlock>();
      for(int i = 0; i < trusses.length; i++) {
        blocks.add(new DropdownMenuBlock("Truss " + str(i), i));
      }
      if(blocks != null) trussesDDM = new DropdownMenu("SocketParentTruss", blocks);
    }
  }
  
  boolean addingNewAllowedTrussForWiring;
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    g.translate(60, 80);
    if(fix != null) {
      if(fix.x_location != x_location) { x_location = fix.x_location; xL.setValue(x_location); }
      if(fix.y_location != x_location) { y_location = fix.y_location; yL.setValue(y_location); }
      if(fix.z_location != x_location) { z_location = fix.z_location; zL.setValue(z_location); }
      g.pushMatrix();
        xL.draw(g, mouse); if(xL.valueHasChanged()) { setLocationX(xL.getValue()); }
        g.translate(0, 30);
        yL.draw(g, mouse); if(yL.valueHasChanged()) { setLocationY(yL.getValue()); }
        g.translate(0, 30);
        zL.draw(g, mouse); if(zL.valueHasChanged()) { setLocationZ(zL.getValue()); }
      g.popMatrix();
      g.pushMatrix();
        g.translate(300, 0);
        
        g.pushMatrix();
          g.translate(0, 100);
          g.pushStyle(); g.fill(0);
          for(int i = 0; i < fix.allowedTrussesForWiring.size(); i++) {
            g.text(fix.allowedTrussesForWiring.get(i), 10, i*20);
          }
          g.popStyle();
        g.popMatrix();
        
        if(addNewAllowedTrussForWiring.isPressed(g, mouse)) addingNewAllowedTrussForWiring = true;
        if(addingNewAllowedTrussForWiring) {
          if(trussesDDM != null) {
            trussesDDM.draw(g, mouse);
            if(trussesDDM.valueHasChanged()) { fix.allowedTrussesForWiring.append(trussesDDM.getValue()); addingNewAllowedTrussForWiring = false; }
          }
        }
        
        g.pushMatrix();
        g.translate(200, 0);
        if(socketsDDM != null) {
          socketsDDM.draw(g, mouse);
          if(socketsDDM.valueHasChanged()) { fix.socket = sockets.get(socketsDDM.getValue()); fix.socket.channel = fix.channelStart; }
        }
        g.popMatrix();
        
        g.pushMatrix();
        g.pushStyle();
          g.translate(200, 200);
          int valueToWatts = -1;
          if((fixtureProfiles[fix.fixtureTypeId].watts != watts.getValue() && fix.watts == -1)) {
            valueToWatts = fixtureProfiles[fix.fixtureTypeId].watts;
          }
          if(fix.watts != watts.getValue() && fix.watts != -1) {
            valueToWatts = fix.watts;
          }
          if(valueToWatts != -1) watts.setValue(valueToWatts);
          g.fill(0);
          g.textSize(15);
          g.text("Watts", 125, 16);
          watts.draw(g, mouse);
          watts.setDefinition(50);
          watts.setLimits(0, 2000);
          if(watts.valueHasChanged()) {
            fix.watts = watts.getValue();
          }
        g.popStyle();
        g.popMatrix();
        
        g.pushMatrix(); g.pushStyle();
          g.translate(200, 250);
          g.fill(0);
          g.text("Channel: ", -50, 16);
          channel.draw(g, mouse);
          if(channel.valueHasChanged()) { fix.channelStart = channel.getValue(); }
          if(fix.channelStart != channel.getValue()) { channel.setValue(fix.channelStart); }
          
        g.popMatrix(); g.popStyle();
        
      g.popMatrix();
    }
  }
  
  void setLocationX(int val) {
    fix.x_location = val;
  }
  void setLocationY(int val) {
    fix.y_location = val;
  }
  void setLocationZ(int val) {
    fix.z_location = val;
  }
  
}

boolean invokeFixturesDrawFinished = true;
void invokeFixturesDraw() {
  invokeFixturesDrawFinished = false;
  for (fixture fix : fixtures.iterate()) if(memoriesFinished) fix.draw();
    else { while(!memoriesFinished); }
  invokeFixturesDrawFinished = true;
}

import java.util.TreeMap;
import java.util.Map;
import java.util.Collection;
import java.util.Set;
import java.util.Map.Entry;

class FixtureArray {
  
  
 
  FixtureArray() {
    array = new TreeMap<Integer, fixture>();
    //dummyFixture = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    
  }
  
  TreeMap<Integer, fixture> array;
  
  fixture dummyFixture;
  
  
  Collection<fixture> iterate() {
    return array.values();
  }
  
  Set<Entry<Integer, fixture>> iterateIDs() {
    return array.entrySet();
  }
  
  void add(fixture newFix) {
    int newId = array.size();
    array.put(newId, newFix);
  }
  
  void set(int id, fixture newFix) {
    array.put(id, newFix);
  }
  
  
  void remove(int id) {
    array.remove(id);
    if(currentBottomMenuControlBoxOwner == id) bottomMenuControlBoxOpen = false;
  }
  
  
  fixture get(int fid) {
    if(array.containsKey(fid)) {
      return array.get(fid);
    } else {
      if(dummyFixture == null) dummyFixture = new fixture(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      dummyFixture.size.isDrawn = false;
      return dummyFixture;
    }
    
  }
  
  
  int size() {
    return most() +1;
  }
  
  int mapSize() {
    return array.size();
  }
  
  //Todo: replace a lot of fixtures.size()s to fixture.most()
  int most() {
    return array.lastEntry().getKey();
  }
  
  
  void clear() {
    array.clear();
  }
  
}


void createNewFixtureAt00() {
  fixtures.add(new fixture(0, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 1));
}

 
class fixture {
  //Variables---------------------------------------------------------------------------------
  boolean selected = false;
  
  boolean DMXChanged = false;

  //int dimmer;
  

  PVector getLocation() {
    return new PVector(x_location, y_location, z_location);
  }
  PVector getLocationOnScreen() {
    return new PVector(locationOnScreenX, locationOnScreenY, 0);
  }
  PVector getRotation() {
    return new PVector(rotationX, 0, rotationZ);
  }
  LocationData getLocationData() {
    return new LocationData(getLocation(), getRotation());
  }
  RGBWD getRGBWD() {
    return new RGBWD(getRawColor(), out.getUniversalDMX(DMX_DIMMER));
  }
  
  int x_location, y_location, z_location; //location in visualisation
  int locationOnScreenX, locationOnScreenY;
  int rotationX, rotationZ;
  int parameter;
  int preFadeSpeed = 1000;
  int postFadeSpeed = 5000;
  
  int red, green, blue; //color values
  
  String fixtureType;
  int fixtureTypeId;
  int channelStart;
  int watts = -1;
  
  int getWatts() {
    if(watts != -1) {
      return watts;
    }
    else {
      return fixtureProfiles[fixtureTypeId].watts;
    }
  }
  
  int getActualWatts() {
    if(isHalogen() || isLed()) {
      return round(map(out.getUniversalDMX(1), 0, 255, 0, getWatts()));
    }
    else {
      return getWatts();
    }
  }
  
  fixtureSize size;
  
  int parentAnsa;
  
  Socket socket = new Socket();
  
  IntList allowedTrussesForWiring = new IntList();
  
  boolean soloInThisFixture;
  
  FixtureDMX in;
  FixtureDMX out;
  FixtureDMX preset;
  FixtureDMX bottomMenu;
  FixtureDMX fade;
  FixtureDMX presetReady;
  
  Fade[] fades = new Fade[universalDMXlength];
  
  IntList masters = new IntList();
  

  //End of initing variables
  
  void saveFixtureDMXDataToXML(ManageXML XMLObject) {
    XMLObject.addBlockAndIncrease("FixtureDMXdata");
      if(in != null) { in.saveToXML("in", XMLObject); }
      if(out != null) { out.saveToXML("out", XMLObject); }
      if(preset != null) { preset.saveToXML("preset", XMLObject); }
      if(bottomMenu != null) { bottomMenu.saveToXML("bottomMenu", XMLObject); }
      if(fade != null) { fade.saveToXML("fade", XMLObject); }
    XMLObject.goBack();
  }
  
  XML getXML() {
	String data = "<fixture></fixture>";
	XML xml = parseXML(data);
	XML block;
	block = xml.addChild("StartChannel");
	block.setContent(str(channelStart));
	block = xml.addChild("fixtureTypeId");
	block.setContent(str(fixtureTypeId));
	block = xml.addChild("Location");
	block.setInt("x", x_location);
	block.setInt("y", y_location);
	block.setInt("z", z_location);
	block = block.addChild("OnScreen");
	block.setInt("x", locationOnScreenX);
	block.setInt("y", locationOnScreenY);
	block = block.getParent();
	block = block.addChild("Rotation");
	block.setInt("x", rotationX);
	block.setInt("z", rotationZ);
	
	block = xml.addChild("parameter");
	block.setContent(str(parameter));
	block = xml.addChild("preFadeSpeed");
	block.setContent(str(preFadeSpeed));
	block = xml.addChild("postFadeSpeed");
	block.setContent(str(postFadeSpeed));
	block = xml.addChild("Color");
	block.setInt("r", red);
	block.setInt("g", green);
	block.setInt("b", blue);
	block = xml.addChild("parentAnsa");
	block.setContent(str(parentAnsa));
	block = xml.addChild(socket.getXML());
 
	return xml;
  }
  
  void loadFixtureData(XML xml) {
    channelStart = int(xml.getChild("StartChannel").getContent());
    fixtureTypeId = int(xml.getChild("fixtureTypeId").getContent());
	
	println(xml);println();println();
	XML block;
	
	try {
		block = xml.getChild("Location");
		x_location = block.getInt("x");
		y_location = block.getInt("y");
		z_location = block.getInt("z_location");
		block = block.getChild("OnScreen");
		locationOnScreenX = block.getInt("x");
		locationOnScreenY = block.getInt("y");
		block = block.getParent();
		block = block.getChild("Rotation");
		rotationX = block.getInt("x");
		rotationZ = block.getInt("z");
	}
	catch(Exception e) {
		println("Error with location");
	}
	
	try {
		block = xml.getChild("parameter");
		parameter = int(block.getContent());
		block = xml.getChild("preFadeSpeed");
		preFadeSpeed = int(block.getContent());
		block = xml.getChild("postFadeSpeed");
		postFadeSpeed = int(block.getContent());
		
		block = xml.getChild("Color");
		red = block.getInt("r");
		green = block.getInt("g");
		blue = block.getInt("b");
		
		block = xml.getChild("parentAnsa");
		parentAnsa = int(block.getContent());
		block = xml.getChild("socket");
		socket.XMLtoObject(block);
	}
	catch (Exception e) {
		e.printStackTrace();
	}

  }
  
 
  void setDimmer(int val) {
    in.setDimmer(val);
  }
  
   float soloFade = 255;
   float afterSoloFade = 0;
   boolean thisFixtureWasOffBySolo = false;
   
  void processDMXvalues() {
    preset.presetProcess();
    
    
    
    int[] newIn  = in.getUniversalDMX();
    int[] oldOut = out.getUniversalDMX();
    //Keep old dimmer value if it hasn't changed more than 5 and this fixture is a halogen
    if(isHalogen() && abs(newIn[DMX_DIMMER] - oldOut[DMX_DIMMER]) <= 5)
      newIn[DMX_DIMMER] = oldOut[DMX_DIMMER];
      newIn[DMX_DIMMER] = masterize(newIn[DMX_DIMMER]); //PROBLEM this is causing some masterloop problemes! If master isn't 255 all the lights fade off PROBLEM!!!!!!!!!!

    for(int i = 0; i < masters.size(); i++) {
      newIn[DMX_DIMMER] = round(map(newIn[DMX_DIMMER], 0, 255, 0, masters.get(i)));
    }
    masters.clear();
    
    if(soloIsOn && !soloInThisFixture) {
      newIn[DMX_DIMMER] = round(map(newIn[DMX_DIMMER], 0, 255, 0, soloFade));
      if(soloFade > 0) { soloFade-=(float(60)/frameRate)*20; soloFade = constrain(soloFade, 0, 255); }
      thisFixtureWasOffBySolo = true;
      afterSoloFade = 0;
    }
    if(!soloIsOn && !soloInThisFixture && thisFixtureWasOffBySolo) {
      newIn[DMX_DIMMER] = round(map(newIn[DMX_DIMMER], 0, 255, 0, afterSoloFade));
      if(afterSoloFade < 255) { afterSoloFade+=(float(60)/frameRate)*20; afterSoloFade = constrain(afterSoloFade, 0, 255); }
      if(afterSoloFade == 255) { thisFixtureWasOffBySolo = false;  soloFade = 255;}
    }
    
    if(fullOn) {
      newIn[DMX_DIMMER] = 255;
      if((newIn[DMX_RED] + newIn[DMX_GREEN] + newIn[DMX_BLUE] + newIn[DMX_WHITE])  == 0) { newIn[DMX_RED] = 255; newIn[DMX_GREEN] = 255; newIn[DMX_BLUE] = 255; newIn[DMX_WHITE] = 255; }
      else {
        int maxValueOfColors = max(max(newIn[DMX_RED], newIn[DMX_GREEN]), newIn[DMX_BLUE], newIn[DMX_WHITE]);
        newIn[DMX_RED] = round(map(newIn[DMX_RED], 0, maxValueOfColors, 0, 255));
        newIn[DMX_GREEN] = round(map(newIn[DMX_GREEN], 0, maxValueOfColors, 0, 255));
        newIn[DMX_BLUE] = round(map(newIn[DMX_BLUE], 0, maxValueOfColors, 0, 255));
        newIn[DMX_WHITE] = round(map(newIn[DMX_WHITE], 0, maxValueOfColors, 0, 255));
      }
    }
    if(strobeNow) {
      if(fixtureProfiles[fixtureTypeId].isStrobe) {
        newIn[DMX_DIMMER] = 255;
        newIn[DMX_FREQUENCY] = 255;
        newIn[DMX_STROBE] = 255;
        newIn[DMX_RED] = 255;
        newIn[DMX_GREEN] = 255;
        newIn[DMX_BLUE] = 255;
        newIn[DMX_WHITE] = 255;
      }
      else {
        newIn[DMX_DIMMER] = 0;
      }
    }
    if(fogNow) {
      if(fixtureProfiles[fixtureTypeId].isFog) {
        newIn[DMX_FOG] = 255;
      }
    }
    if(blackOut) { newIn[DMX_DIMMER] = 0; }
    int[] oldDMX = out.getUniversalDMX();
    for(int i = 0; i < newIn.length; i++) {
      if(newIn[i] != oldDMX[i]) {
        DMXChanged = true;
      }
    }
    out.setUniversalDMX(newIn);
    processFade();
    
    for(int i = 0; i < bottomMenu.DMXlength; i++) {
      if(bottomMenu.DMX[i] != bottomMenu.DMXold[i]) {
        in.DMX[i] = bottomMenu.DMX[i];
        DMXChanged = true;
        bottomMenu.DMXold[i] = bottomMenu.DMX[i];
      }
    }
  }
  
  void setUniversalDMXwithFade(int i, int val, int pre, int post) {
    if(i >= 0 && i < fades.length) {
      fades[i] = new Fade(in.getUniversalDMX(i), val, pre, post);
    }
  }
  
  void processFade() {
    if(fades != null) {
      int[] fadeVal = new int[fades.length];
      for(int i = 0; i < fades.length; i++) {
        if(fades[i] != null) {
          if(!fades[i].isCompleted()) {
            fades[i].countActualValue();
            fadeVal[i] = fades[i].getActualValue();
            in.setUniversalDMX(i, fadeVal[i]);
            in.DMXChanged = true;
            DMXChanged = true;
          }
        }
      }
    }
  }

  

  boolean thisFixtureUseRgb() {
    return fixtureUseRgbByType(fixtureTypeId);
  }
    
  boolean thisFixtureUseDim() {
    return fixtureUseDimByType(fixtureTypeId);
  }
  boolean thisFixtureUseWhite() {
    return fixtureUseWhiteByType(fixtureTypeId);
  }
  
  boolean thisFixtureIsLed() {
    return thisFixtureUseRgb();
  }
  
  void setColorForLed(int c) {
    if(thisFixtureIsLed()) {
      setColor(c);
    }
  }
  
  void setColorForLedFromPreset(int c) {
    if(thisFixtureIsLed()) {
      setColor(c);
    }
  }
  
  
  void setColor(int c) {
    in.setUniversalDMX(DMX_RED, rRed(c));
    in.setUniversalDMX(DMX_GREEN, rGreen(c));
    in.setUniversalDMX(DMX_BLUE, rBlue(c));
    DMXChanged = true;
    in.DMXChanged = true;
  }
  
  color getColor() {
    return color(red, green, blue);
  }


  
  
  void createDMXobjects() {
    in = new FixtureDMX(this);
    out = new FixtureDMX(this);
    preset = new FixtureDMX(this);
    bottomMenu = new FixtureDMX(this);
    presetReady = new FixtureDMX(this);
    
    presetReady.fades = new Fade[in.DMXlength];
  }

  //Initialization----------------------------------------------------------------------------
  
  //Type in string
  fixture(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, String fixtType) {
   fixtureType = fixtType;
   initFixtureObj(dim, r, g, b, x, y, z, rZ, rX, ch, parentA, param, getFixtureTypeId());
  }
  
  //Type in int
  fixture(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, int fixtTypeId) {
    initFixtureObj(dim, r, g, b, x, y, z, rZ, rX, ch, parentA, param, fixtTypeId);
    fixtureType = getFixtureNameByType(fixtTypeId);
    
  }
  
  //Empty fixture
  fixture() {}
  
  void initFixtureObj(int dim, int r, int g, int b, int x, int y, int z, int rZ, int rX, int ch, int parentA, int param, int fixtTypeId) {
   createDMXobjects();
   in.setUniDMX(DMX_DIMMER, dim);
   channelStart = ch;
   red = r;
   green = g;
   blue = b;
   x_location = x;
   y_location = y;
   z_location = z;
   rotationZ = rZ; rotationX = rX;
   parameter = param;
   parentAnsa = parentA;
   
   size = new fixtureSize(fixtTypeId);
   
   fixtureTypeId = fixtTypeId;
  }
  
  
  //Query-------------------------------------------------------------------------------------
  
  //Returns raw fixture color in type color
  
  color convertedColor;
  int oldRed, oldGreen, oldBlue, oldWhite;
  
  color getRawColor() {
    if(!isHalogen()) {
      if(out.getUniversalDMX(DMX_WHITE) > 0) {
        if(out.getUniversalDMX(DMX_RED) != oldRed || out.getUniversalDMX(DMX_GREEN) != oldGreen || out.getUniversalDMX(DMX_BLUE) != oldBlue || out.getUniversalDMX(DMX_WHITE) != oldWhite) {
          oldRed = out.getUniversalDMX(DMX_RED);
          oldGreen = out.getUniversalDMX(DMX_GREEN);
          oldBlue = out.getUniversalDMX(DMX_BLUE);
          oldWhite = out.getUniversalDMX(DMX_WHITE);
          int[] convertedColorV = colorConverter.convertColor(new int[] { out.getUniversalDMX(DMX_RED), out.getUniversalDMX(DMX_GREEN), out.getUniversalDMX(DMX_BLUE), out.getUniversalDMX(DMX_WHITE) }, 3, 1);
          convertedColor = color(convertedColorV[0], convertedColorV[1], convertedColorV[2]);
          return convertedColor;
        }
        else {
          return convertedColor;
        }
      }
      return color(out.getUniversalDMX(DMX_RED), out.getUniversalDMX(DMX_GREEN), out.getUniversalDMX(DMX_BLUE));
    }
    else {
      return color(red, green, blue);
    }
  }
  
  //Returns dimmed fixture color in type color
  color getColor_wDim() {
    int dwm = getDimmerWithMaster();
    color c = getRawColor();
    if(!isHalogen()) {
      if(thisFixtureUseDim()) {
        return color(map(red(c), 0, 255, 0, dwm), map(green(c), 0, 255, 0, dwm), map(blue(c), 0, 255, 0, dwm));
      }
      else { return c; }
    }
    else {
      return color(map(red, 0, 255, 0, dwm), map(green, 0, 255, 0, dwm), map(blue, 0, 255, 0, dwm));
    }
  }
  
  
 
  
  int getFixtureTypeId() {
    return getFixtureTypeId1(fixtureType);
  }
  

  
  
  
  int[] getDMX() {
    return in.getDMX();
  }
  
  int dimmerLast = 0;
  int[] getDMXforOutput() {
    
    //We're going to temporarily modify the dimmer variable to suit our needs
 /*   int tempDimmer = out.dimmer;
    if(abs(out.dimmer - dimmerLast) >= 5) {
      out.dimmer = getDimmerWithMaster();
      if(out.dimmer < 5) out.dimmer = 0;
      if(out.dimmer > 250) out.dimmer = 255;
      dimmerLast = out.dimmer;
    } else if(isHalogen()) { out.dimmer = int(map(dimmerLast, 0, 255, 0, grandMaster)); } */
    
    return out.getDMX();
  }
  
  
  boolean isHalogen() {
    return fixtureProfiles[fixtureTypeId].isHalogen;
  }
  
  boolean isLed() {
    return fixtureProfiles[fixtureTypeId].isLed;
  }
  
  int getDimmerWithMaster() {
    return masterize(out.getUniversalDMX(DMX_DIMMER));
  }
  
  int masterize(int val) {
    return int(map(val, 0, 255, 0, grandMaster));
  }
  
  int getDMXLength() {
    return out.getDMX().length;
  }
  
  //Returns true if operation is succesful
  boolean receiveDMX(int[] dmxChannels) {
    //return in.receiveDMX(dmxChannels);
    return true;
  }
  
   void setColorValuesFromDmxValue(int a) {
      for(int i = 0; i < mhx50_color_values.length; i++) {
        if((a >= mhx50_color_values[i] - 5) && (a <= mhx50_color_values[i])) {
          setColorNumber(i);
          return;
        }
      }
    }
  
  int colorNumber;
  void setColorNumber(int value) {
      colorNumber = value;
      red = mhx50_RGB_color_Values[colorNumber][0];
      green = mhx50_RGB_color_Values[colorNumber][1];
      blue = mhx50_RGB_color_Values[colorNumber][2];
    }
    
    boolean ftIsMhX50() { //This function is only to check is the fixtureType moving head (17 or 16)
      return fixtureTypeId == 16 || fixtureTypeId == 17;
    }
  


  
  int oldFixtureTypeId;
  
  void draw() {
    //setFadeValues();
    processDMXvalues();
    /*if (dimmerPresetTarget != -1 && dimmerPresetTarget != lastDimmerPresetTarget) {
      setDimmer(dimmerPresetTarget);
      lastDimmerPresetTarget = dimmerPresetTarget;
    } dimmerPresetTarget = -1;*/
   

    
    if (oldFixtureTypeId != fixtureTypeId) {
      oldFixtureTypeId = fixtureTypeId;
      //Fixture type changed, recalculate certain variables
      size = new fixtureSize(fixtureTypeId);
      fixtureType = getFixtureNameByType(fixtureTypeId);
    }
    if(fixtureTypeId == 16 || fixtureTypeId == 17) {
    }
  }
  
  color getFixtureColorFor2D() {
    if(fixtureTypeId < fixtureProfiles.length) {
      FixtureProfile profile = fixtureProfiles[fixtureTypeId];
      if(profile != null) {
        if(profile.hasDimmer) {
          return this.getColor_wDim();
        }
        else if(profile.isFog) {
          int val = in.getUniversalDMX(DMX_FOG);
          color c = color(val, val, val);
          return c;
        }
        else if(profile.isHazer) {
          int val = in.getUniversalDMX(DMX_HAZE);
          color c = color(val, val, val);
          return c;
        }
        else {
          color c = color(0, 0, 0);
          return c;
        }
      }
    }
    color c = color(0, 0, 0);
    return c;
  }
  
  boolean toggleState = false;
  
  void push(boolean down) {
    mainChannelOnOff(down);
  }
  
  void toggle(boolean down) {
    if(down) {
      toggleState = !toggleState;
      mainChannelOnOff(toggleState);
    }
  }
  
  void mainChannelOnOff(boolean state) {
    FixtureProfile profile = fixtureProfiles[fixtureTypeId];
    if(profile.hasDimmer) { in.setUniversalDMX(DMX_DIMMER, state ? 255 : 0); }
    if(profile.isStrobe && profile.channelTypes.length <= 2) { in.setUniversalDMX(DMX_STROBE, state ? 255 : 0); }
    if(profile.isFog) { in.setUniversalDMX(DMX_FOG, state ? 255 : 0); }
    if(profile.isHazer) { in.setUniversalDMX(DMX_HAZE, state ? 255 : 0); in.setUniversalDMX(DMX_FAN, state ? 255 : 0); }
    DMXChanged = true;
  }
  
  //Index is used only to display the id of the fixture
  void draw2D(int index) {
    pushStyle();
    fill(getFixtureColorFor2D());
    boolean showFixture = true;
    int lampWidth = 30;
    int lampHeight = 40;
    
    String fixtuuriTyyppi = getFixtureNameByType(fixtureTypeId);
    
    
    
    if(fixtureTypeId >= 1 && fixtureTypeId <= 13) {
      lampWidth = this.size.w;
      lampHeight = this.size.h;
      showFixture = this.size.isDrawn;
    }
    
    boolean selected = this.selected && showFixture;
    
    
    if(showFixture == true) {
      int x1 = 0; int y1 = 0;
      
      this.locationOnScreenX = int(screenX(x1 + lampWidth/2, y1 + lampHeight/2));
      this.locationOnScreenY = int(screenY(x1 + lampWidth/2, y1 + lampHeight/2));
      rectMode(CENTER);
      if(fixtureTypeId == 13) {  rotate(radians(map(rotationZ, 0, 255, 0, 180))); pushMatrix();}
      if(selected) stroke(100, 100, 255); else stroke(255);
      rect(x1, y1, lampWidth, lampHeight, 3);
      if(fixtureTypeId == 13) {  popMatrix();  }
      translate(-size.w/2, -size.h/2);
      if(zoom > 50) {
        if(printMode == false) {
          fill(255, 255, 255);
          text(this.getDimmerWithMaster(), x1, y1 + lampHeight + 15);
        }
        else {
          fill(0, 0, 0);
          text(fixtuuriTyyppi, x1, y1 + lampHeight + 15);
        }
       if(!showMode) text(index + "/" + this.channelStart, x1, y1 - 15);
       else text(this.channelStart, x1, y1 - 15);
      }
    }
    popStyle();
  }
  
  
  //Index is used only to display the id of the fixture
  void draw2D(int index, PGraphics g) {
    g.pushStyle();
    color c = getRawColor();
    if(brightness(c) == 0) {
      c = color(255);
    }
    g.fill(c);
    boolean showFixture = true;
    int lampWidth = 30;
    int lampHeight = 40;
    
    String fixtuuriTyyppi = getFixtureNameByType(fixtureTypeId);
    
    
    
      lampWidth = this.size.w;
      lampHeight = this.size.h;
      showFixture = this.size.isDrawn;
   
    
    boolean selected = this.selected && showFixture;
    
    
    if(showFixture == true) {
      int x1 = 0; int y1 = 0;
      g.rectMode(CENTER);
      g.strokeWeight(2);
      g.stroke(0, 230);
      g.translate(size.w/2, 0);
      g.rect(x1, y1, lampWidth, lampHeight, 3);
      g.rotate(radians(-rotationZ));
      g.translate(-size.w/2, -size.h/2);
      g.fill(0);
      
      String text = getFixtureNameByType(fixtureTypeId);
      g.textSize(10);
      g.text(getFixtureNameByType(fixtureTypeId), lampWidth/2-(textWidth(text)/2), y1 + lampHeight + 13);
      text = str(this.channelStart);
      g.textSize(15);
      textSize(15);
      g.text(text, lampWidth/2-textWidth(text)/2, y1+lampHeight/2+5);
      text = this.socket.name;
      g.text(text, lampWidth/2-textWidth(text)/2, y1-12);
    }
    g.popStyle();
  }
  
}//Endof: fixture class

void removeFixtureFromCM() {
  fixtures.remove(contextMenu1.fixtureId);
}

void removeAllSelectedFixtures() {
  for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) {
    fixture fix = entry.getValue();
    int i = entry.getKey();
    
    if(fix.selected) fixtures.remove(i);
  }
}


class fixtureSize {

  
  int w, h;
  boolean isDrawn;
  
  //Manual parameters
  fixtureSize(int wdt, int hgt, boolean isDrwn) {
    w = wdt; h = hgt;
    isDrawn = isDrwn;
  }
  
  //Parameters through fixture type
  fixtureSize(int fixtureTypeId) {
    int[] siz = getFixtureSizeByType(fixtureTypeId);
    w = siz[0]; h = siz[1];
    isDrawn = siz[2] == 1;
  }
}
