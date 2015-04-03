PowerWindow powerWindow = new PowerWindow();

class Channel {
  IntList fixtures = new IntList();
  int watts;
  Channel() {
  }
}

class PowerWindow {
  Window window;
  int locX, locY, w, h;
  boolean open;
  
  int offset = 0;
  int offsetChannels = 0;
  
  PowerWindow() {
    w = 1000; h = 500;
    window = new Window("powerWindow", new PVector(w, h), this);
  }
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    
    window.draw(g, mouse);
    g.translate(60, 60);
    
    
    IntList fixturesShown = new IntList();
    for(int i = 0; i < fixtures.size(); i++) {
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
    for(int i = 0; i < fixturesShown.size(); i++) {
      totalPower += fixtures.get(fixturesShown.get(i)).getActualWatts();
    }
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
    totalPower = (round(totalPower/10)*10)/1000;
    g.translate(800, 30);
    g.fill(0);
    g.textSize(40);
    g.text(str(totalPower)+"kW", 0, 0);
    g.popMatrix(); g.popStyle();
  }
}
