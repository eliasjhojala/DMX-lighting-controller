PowerWindow powerWindow = new PowerWindow();



void saveDimmersToXML() {
  saveXML(dimmersAsXML(), "XML/dimmers.xml");
}
void loadDimmersFromXML() {
  XMLtoDimmers(loadXML("XML/dimmers.xml"));
}

XML dimmersAsXML() {
  String data = "<dimmers></dimmers>";
  XML xml = parseXML(data);
  for(int i = 0; i < dimmers.size(); i++) {
    xml.addChild(dimmers.get(i).getXML());
  }
  return xml;
}

void XMLtoDimmers(XML xml) {
  XML[] dimmersXML = xml.getChildren("Dimmer");
  dimmers.clear();
  for(int i = 0; i < dimmersXML.length; i++) {
    Dimmer newDimmer = new Dimmer();
    dimmers.add(newDimmer);
    newDimmer.XMLtoObject(dimmersXML[i]);
  }
}

class Dimmer {
  int startChannel;
  int numberOfChannels = 6;
  int powerSocketId;
  int phases = 3;
  
  int watts;
  int[] wattsPerPhase;
  
  Dimmer() {
  }
  
  XML getXML() {
    String data = "<Dimmer></Dimmer>";
    XML xml = parseXML(data);
    xml.setInt("startChannel", startChannel);
    xml.setInt("numberOfChannels", numberOfChannels);
    xml.setInt("powerSocketId", powerSocketId);
    xml.setInt("phases", phases);
    return xml;
  }
  
  void XMLtoObject(XML xml) {
    startChannel = xml.getInt("startChannel");
    numberOfChannels = xml.getInt("numberOfChannels");
    powerSocketId = xml.getInt("powerSocketId");
    phases = xml.getInt("phases");
  }
}


DimmerWindow dimmerWindow = new DimmerWindow();
ArrayList<Dimmer> dimmers = new ArrayList<Dimmer>();

class DimmerWindow {
  Window window;
  int locX, locY, w, h;
  boolean open;
  
  PushButton addNewDimmer;
  IntController dimmerStartChannel, dimmerPowerSocketId, numberOfChannels, phases;
  
  Dimmer newDimmer;
  boolean addingNewDimmer;

  
  DimmerWindow() {
    w = 1000; h = 700;
    window = new Window("powerWindow", new PVector(w, h), this);
    
    addNewDimmer = new PushButton("addNewDimmer");
    dimmerStartChannel = new IntController("dimmerStartChannel"+this.toString());
    dimmerPowerSocketId = new IntController("dimmerPowerSocketId"+this.toString());
    numberOfChannels = new IntController("numberOfChannels"+this.toString());
    phases = new IntController("phases"+this.toString());
    dimmerStartChannel.setLimits(1, DMX_CHAN_LENGTH);
    dimmerPowerSocketId.setLimits(1, 4);
    numberOfChannels.setLimits(1, 36);
    phases.setLimits(1, 3);
  }
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    
    window.draw(g, mouse);
    g.translate(60, 60);
    
    int textTranslationWithIntController = 14;
    
    if(addNewDimmer.isPressed(g, mouse)) { addingNewDimmer = true; newDimmer = new Dimmer(); dimmers.add(newDimmer); }
    if(addingNewDimmer) {
      g.pushMatrix(); g.pushStyle();
        g.fill(0);
        g.textAlign(LEFT);
        
        g.translate(30, 0);
        g.pushMatrix();
          String text = "Start channel:";
          g.text(text, 0, textTranslationWithIntController);
          g.translate(130, 0);
          dimmerStartChannel.draw(g, mouse);
          if(dimmerStartChannel.valueHasChanged()) { newDimmer.startChannel = dimmerStartChannel.getValue(); }
          if(newDimmer.startChannel != dimmerStartChannel.getValue()) { dimmerStartChannel.setValue(newDimmer.startChannel); }
        g.popMatrix();
        
        g.translate(0, 50);
        g.pushMatrix();
          text = "Powersocket id:";
          g.text(text, 0, textTranslationWithIntController);
          g.translate(130, 0);
          dimmerPowerSocketId.draw(g, mouse);
          if(dimmerPowerSocketId.valueHasChanged()) { newDimmer.powerSocketId = dimmerPowerSocketId.getValue(); }
          if(newDimmer.powerSocketId != dimmerPowerSocketId.getValue()) { dimmerPowerSocketId.setValue(newDimmer.powerSocketId); }
        g.popMatrix();
        
        g.translate(0, 50);
        g.pushMatrix();
          text = "numberOfChannels:";
          g.text(text, 0, textTranslationWithIntController);
          g.translate(130, 0);
          numberOfChannels.draw(g, mouse);
          if(numberOfChannels.valueHasChanged()) { newDimmer.numberOfChannels = numberOfChannels.getValue(); }
          if(newDimmer.numberOfChannels != numberOfChannels.getValue()) { numberOfChannels.setValue(newDimmer.numberOfChannels); }
        g.popMatrix();
        
        
        g.translate(0, 50);
        g.pushMatrix();
          text = "phases:";
          g.text(text, 0, textTranslationWithIntController);
          g.translate(130, 0);
          phases.draw(g, mouse);
          if(phases.valueHasChanged()) { newDimmer.phases = phases.getValue(); }
          if(newDimmer.phases != phases.getValue()) { phases.setValue(newDimmer.phases); }
        g.popMatrix();
        
      g.popMatrix(); g.popStyle();
    }
    
    
    g.pushMatrix(); g.pushStyle();
    g.translate(0, 200);
    g.fill(0);
    //g.rect(0, 0, 700, 300);
    for(int i = 0; i < dimmers.size(); i++) {
      Dimmer dimmer = dimmers.get(i);
      g.pushMatrix(); g.pushStyle();
        g.fill(0);
        g.translate(40, i*20);
        g.text("CH "+str(dimmer.startChannel)+"-"+str(dimmer.startChannel+dimmer.numberOfChannels-1), 0, 14);
        g.text("phases: "+str(dimmer.phases), 100, 14);
        g.text("powerSocketId: "+str(dimmer.powerSocketId), 200, 14);
        g.translate(300, 0);
        {
          PushButton remove = new PushButton("Remove"+str(i)+this.toString()+dimmer.toString());
          if(remove.isPressed(g, mouse)) { dimmers.remove(i); }
          g.translate(30, 0);
          PushButton edit = new PushButton("edit"+str(i)+this.toString()+dimmer.toString());
          if(edit.isPressed(g, mouse)) { newDimmer = dimmers.get(i); }
        }
        
      g.popMatrix(); g.popStyle();
    }
    
    g.popMatrix(); g.popStyle();
    
  }
}


class Channel {
  IntList fixtures = new IntList();
  IntList socketsInThisChannel = new IntList();
  int watts;
  Channel() {
  }
}

class Phase {
  int socketId;
  int phaseId;
  int watts;
  int ampers;
  int maxAmpers = 32;
  
  Phase() {
  }
}


ArrayList<Phase> phases = new ArrayList<Phase>();


class PowerWindow {
  Window window;
  int locX, locY, w, h;
  boolean open;
  
  int offset = 0;
  int offsetChannels = 0;
  
  PowerWindow() {
    w = 1000; h = 700;
    window = new Window("powerWindow", new PVector(w, h), this);
  }
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    
    window.draw(g, mouse);
    g.translate(60, 60);
    
    float voltage = 230;
    
    IntList fixturesShown = new IntList();
    for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) {
      int i = entry.getKey();
      if(fixtureIsDrawnById(i)) {
        fixturesShown.append(i);
      }
    }
    
    ArrayList<Channel> fixtureChannels = new ArrayList<Channel>();
    for(int i = 0; i < DMX_CHAN_LENGTH+1; i++) {
      fixtureChannels.add(new Channel());
    }
    for(int i = 0; i < fixturesShown.size(); i++) {
      Channel chan = fixtureChannels.get(fixtures.get(fixturesShown.get(i)).channelStart);
      chan.fixtures.append(fixturesShown.get(i));
    }
    
    for(int i = 0; i < fixtureChannels.size(); i++) {
      Channel chan = fixtureChannels.get(i);
      chan.watts = 0;
      for(int j = 0; j < chan.fixtures.size(); j++) {
        chan.watts += fixtures.get(chan.fixtures.get(j)).getActualWatts();
      }
    }
    
    for(int i = 0; i < dimmers.size(); i++) {
      Dimmer dimmer = dimmers.get(i);
      int start = dimmer.startChannel;
      int channels = dimmer.numberOfChannels;
      int phases = dimmer.phases;
      int channelsPerPhase = channels/phases;
      
      dimmer.wattsPerPhase = new int[phases];
      dimmer.watts = 0;
      
      for(int j = 0; j < phases; j++) {
        dimmer.wattsPerPhase[j] = 0;
        for(int k = 0; k < channelsPerPhase; k++) {
          int channel = start+(j*channelsPerPhase)+k;
          
          dimmer.wattsPerPhase[j] += fixtureChannels.get(channel).watts;
          dimmer.watts += fixtureChannels.get(channel).watts;
        }
      }
    }
    
    phases.clear();
    for(int i = 0; i < dimmers.size(); i++) {
      for(int j = 0; j < dimmers.get(i).wattsPerPhase.length; j++) {
        Phase phase = new Phase();
        boolean found = false;
        for(int k = 0; k < phases.size(); k++) {
          if(phases.get(k).phaseId == j && phases.get(k).socketId == dimmers.get(i).powerSocketId) {
            phase = phases.get(k);
            found = true;
          }
        }
        if(!found) { phase = new Phase(); phases.add(phase); }
        phase.socketId = dimmers.get(i).powerSocketId;
        phase.phaseId = j;
        phase.watts += dimmers.get(i).wattsPerPhase[j];
        phase.ampers = ceil(phase.watts/voltage);
        
      }
    }
    
    
    
    
    mouse.declareUpdateElementRelative("fixturePowers", "powerWindow", 60, 0, 260, h-100);
    mouse.setElementExpire("fixturePowers", 2);
    
    mouse.declareUpdateElementRelative("channelPowers", "powerWindow", 300, 0, 200, h-100);
    mouse.setElementExpire("channelPowers", 2);
    
    
    if(mouse.elmIsHover("fixturePowers")) {
      if(scrolled) { offset+=scrollSpeed; offset = constrain(offset, 0, fixturesShown.size()-(h-100)/20); }
    }
    
    if(mouse.elmIsHover("channelPowers")) {
      if(scrolled) { offsetChannels+=scrollSpeed; offsetChannels = constrain(offsetChannels, 0, fixtureChannels.size()-(h-100)/20); }
    }
    
    int a = 0;
    float totalPower = 0;
    float maxTotalPower = 0;
    float totalAmpers = 0;
    float maxTotalAmpers = 0;
    
    
    for(int i = 0; i < fixturesShown.size(); i++) {
      totalPower += fixtures.get(fixturesShown.get(i)).getActualWatts();
      maxTotalPower += fixtures.get(fixturesShown.get(i)).getWatts();
    }
    
    totalAmpers = round(totalPower/voltage*10);
    totalAmpers = totalAmpers / 10;
    maxTotalAmpers = round(maxTotalPower/voltage*10);
    maxTotalAmpers = maxTotalAmpers / 10;
    
    
    for(int i = offset; i < fixturesShown.size(); i++) {
      fixture fixD = fixtures.get(fixturesShown.get(i));
      a++;
      if(!(a*20 > h-100)) {
        g.pushMatrix(); g.pushStyle(); g.fill(0); g.textAlign(LEFT);
        g.translate(0, a*20);
        g.text(getFixtureLongNameByType(fixD.fixtureTypeId), 0, 0);
        g.text(fixD.getActualWatts(), 200, 0);
        g.popMatrix(); g.popStyle();
      }
    }
    
      a = 0;
      
      for(int i = offsetChannels; i < fixtureChannels.size(); i++) {
        a++;
        if(!(a*20 > h-100)) {
          g.pushMatrix(); g.pushStyle(); g.fill(0); g.textAlign(LEFT);
          g.translate(0, a*20);
          g.text("CH " + str(i), 300, 0);
          g.text(fixtureChannels.get(i).watts, 350, 0);
          g.popMatrix(); g.popStyle();
        }
      }

    
    
    
    
    g.pushMatrix(); g.pushStyle();
      g.translate(700, 30);
      g.pushMatrix(); g.pushStyle();
        g.translate(0, 30);
        int h1 = 200;
        int h2 = round(map(totalPower, 0, maxTotalPower, 0, h1));
        g.fill(100, 230);
        g.rect(0, 0, h1, 30);
        g.fill(255, 255, 200);
        g.rect(0, 0, h2, 30);
      g.popMatrix(); g.popStyle();
      totalPower = round(totalPower/100);
      totalPower = totalPower/10;
      maxTotalPower = round(maxTotalPower/100);
      maxTotalPower = maxTotalPower/10;
      g.fill(0);
      g.textSize(40);
      g.text(str(totalPower)+"kW, "+str(totalAmpers)+"A", 0, 0);
    g.popMatrix(); g.popStyle();
    
    g.pushMatrix(); g.pushStyle();
      g.translate(700, 200); g.fill(0);
      for(int i = 0; i < dimmers.size(); i++) {
        g.pushMatrix();
          g.translate(0, i*20);
          g.text("Dimmer "+str(i)+" : " + str(dimmers.get(i).watts) + "kW", 0, 0);
        g.popMatrix();
      }
    g.popMatrix(); g.popStyle();
    
    g.pushMatrix(); g.pushStyle();
      g.translate(700, 300); g.fill(0);
      for(int i = 0; i < phases.size(); i++) {
        Phase phase = phases.get(i);
        g.pushMatrix(); g.pushStyle();
          g.translate(0, i*20);
          g.text("Phase "+str(phase.socketId)+"."+str(phase.phaseId)+" : " + str(phase.ampers) + "A", 0, 14);
          float x = map(phase.ampers, 0, phase.maxAmpers, 0, 255);
          g.noStroke();
          g.fill(100, 230);
          g.rect(50, 0, 255/3, 10);
          color c = color(x, 255-x, 0);
          colorMode(HSB);
          c = color(hue(c), 255, 255);
          colorMode(RGB);
          g.fill(c);
          x = x/3;
          g.rect(50, 0, x, 10);
        g.popMatrix(); g.popStyle();
      }
    g.popMatrix(); g.popStyle();
  }
}
