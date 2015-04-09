import processing.pdf.*;

void SaveChannelsAsPdf() {
  
  for(int i = 0; i < sockets.size(); i++) {
    sockets.get(i).isInActiveUse = false;
    for(fixture fix : fixtures.iterate()) {
      if(fix.socket == sockets.get(i)) {
        sockets.get(i).isInActiveUse = true;
        break;
      }
    }
  }
  
  int count = 0;
  int usedChannels = 0;
  int curCh = -1;
  int[] textSize = new int[DMX_CHAN_LENGTH+1];
  for(int ch = 0; ch < DMX_CHAN_LENGTH; ch++) {
    for(fixture fix : fixtures.iterate()) {
      if(fix.channelStart == ch) if(!getFixtureLongNameByType(fix.fixtureTypeId).equals("")) {
        if(curCh != ch) {
          usedChannels++;
        }
        textSize[ch] += textWidth(getFixtureLongNameByType(fix.fixtureTypeId));
        curCh = ch;
      }
    }
  }
  
  int h = usedChannels*15+30;
  PGraphics pdf = createGraphics(int(max(max(textSize)+50, float(h)*297/420)), h, PDF, "FILES/channels.pdf");
  
  pdf.beginDraw();
  pdf.background(255, 255, 255);
  pdf.fill(0);
  
  count = 0;
  for(int ch = 0; ch < DMX_CHAN_LENGTH; ch++) {
    ArrayList<fixture> fixturesInThisChannel = new ArrayList<fixture>();
    for(fixture fix : fixtures.iterate()) {
      if(fix.channelStart == ch) if(!getFixtureLongNameByType(fix.fixtureTypeId).equals("")) {
        fixturesInThisChannel.add(fix);
      }
    }
    String text = "";
    if(fixturesInThisChannel.size() > 0) {
      count++;
      for(int fix = 0; fix < fixturesInThisChannel.size(); fix++) {
        fixture fixt = fixturesInThisChannel.get(fix);
        if(text.equals("")) {
          text = getFixtureLongNameByType(fixt.fixtureTypeId);
        }
        else {
          text = text + ", " + getFixtureLongNameByType(fixt.fixtureTypeId);
        }
      }
      pdf.text(str(ch) + ": "+text, 10, count*15);
    }
  }
  pdf.dispose();
  pdf.endDraw();
  
  
  { //Set sockets to dimmers
    ArrayList<Channel> socketChannels = new ArrayList<Channel>();
    for(int i = 0; i < DMX_CHAN_LENGTH; i++) {
      socketChannels.add(new Channel());
    }
    
    for(int i = 0; i < sockets.size(); i++) {
      if(sockets.get(i).isInActiveUse) {
        Socket s = sockets.get(i);
        Channel c = socketChannels.get(s.channel);
        c.socketsInThisChannel.append(i);
      }
    }
    
    h = 0;
    { //Count pdf file widht and height
      for(int i = 0; i < dimmers.size(); i++) {
        h += (50+(dimmers.get(i).numberOfChannels*15));
      }

      
      textSize = new int[DMX_CHAN_LENGTH+1];
      
      for(int i = 0; i < dimmers.size(); i++) {
        Dimmer d = dimmers.get(i);
        int start = d.startChannel;
        int nOfCh = d.numberOfChannels;
        
          int arrangeNumber = 0;
          for(int j = start; j < start+nOfCh; j++) {
            arrangeNumber++;
            pdf.textSize(12);
            String text = "";
            for(int k = 0; k < socketChannels.get(j).socketsInThisChannel.size(); k++) {
              if(text.equals("")) { text = sockets.get(socketChannels.get(j).socketsInThisChannel.get(k)).name; }
              else { text = text + ", " + sockets.get(socketChannels.get(j).socketsInThisChannel.get(k)).name; }
            }
            textSize[j] = int(textWidth(text));
          }
          pdf.translate(0, 25);
      }
    } //End of counting pdf file width and height
    
    pdf = createGraphics(int(max(max(textSize)+100, float(h)*297/420)), h, PDF, "FILES/dimmerSockets.pdf");
    pdf.beginDraw();
    pdf.background(255);
    
    pdf.pushMatrix();
    for(int i = 0; i < dimmers.size(); i++) {
      Dimmer d = dimmers.get(i);
      int start = d.startChannel;
      int nOfCh = d.numberOfChannels;
      
        pdf.translate(0, 25);
        pdf.fill(0);
        pdf.textAlign(LEFT);
        pdf.textSize(16);
        pdf.text("Dimmer "+str(i),10, 0);
        int arrangeNumber = 0;
        for(int j = start; j < start+nOfCh; j++) {
          arrangeNumber++;
          pdf.textSize(12);
          String text = "";
          for(int k = 0; k < socketChannels.get(j).socketsInThisChannel.size(); k++) {
            if(text.equals("")) {
              text = sockets.get(socketChannels.get(j).socketsInThisChannel.get(k)).name;
            }
            else {
              text = text + ", " + sockets.get(socketChannels.get(j).socketsInThisChannel.get(k)).name;
            }
          }
          pdf.text(str(arrangeNumber)+". Ch" + str(j) + " : " + text, 20, 15);
          pdf.translate(0, 15);
        }
        pdf.translate(0, 25);
    }
    pdf.popMatrix();
    pdf.dispose();
    pdf.endDraw();
    
  } //End of settings sockets to dimmers
  
  
  float[] x = new float[fixtures.size()];
  float[] y = new float[fixtures.size()];
  for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) {
    fixture fix = entry.getValue();
    int i = entry.getKey();
    if(fix.size.isDrawn) {
      x[i] = fix.x_location+trusses[fix.parentAnsa].location.x;
      y[i] = fix.y_location+trusses[fix.parentAnsa].location.y;
    }
  }
  pdf = createGraphics(int(-(min(x))+max(x)+100), int(-(min(y))+max(y)+150), PDF, "FILES/map.pdf");
  pdf.beginDraw();
  pdf.background(255);
  pdf.fill(0);
  pdf.translate(-(min(x)), -(min(y))+80);
  for(int i = 0; i < elements.size(); i++) {
    elements.get(i).draw(pdf);
  }
  for(Entry<Integer, fixture> entry : fixtures.iterateIDs()) {
    fixture fix = entry.getValue();
    int i = entry.getKey();
    if(fix.size.isDrawn) {
      pdf.pushMatrix();
      pdf.translate(x[i], y[i]);
      pdf.rotate(radians(fix.rotationZ));
      fix.draw2D(i, pdf);
      pdf.popMatrix();
    }
  }
  pdf.dispose();
  pdf.endDraw();
  
}
