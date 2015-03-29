import processing.pdf.*;

void SaveChannelsAsPdf() {
  PGraphics pdf = createGraphics(1000, 2000, PDF, "FILES/channels.pdf");
  pdf.beginDraw();
  pdf.background(255, 255, 255);
  pdf.fill(0);
  int count = 0;
  for(int ch = 0; ch < DMX_CHAN_LENGTH; ch++) {
    ArrayList<fixture> fixturesInThisChannel = new ArrayList<fixture>();
    for(int fix = 0; fix < fixtures.size(); fix++) {
      if(fixtures.get(fix).channelStart == ch) if(!getFixtureLongNameByType(fixtures.get(fix).fixtureTypeId).equals("")) {
        fixturesInThisChannel.add(fixtures.get(fix));
      }
    }
    String text = str(ch) + ": ";
    if(fixturesInThisChannel.size() > 0) {
      count++;
      if(fixturesInThisChannel.size() > 1) {
        for(int fix = 0; fix < fixturesInThisChannel.size(); fix++) {
          fixture fixt = fixturesInThisChannel.get(fix);
          text = text + getFixtureLongNameByType(fixt.fixtureTypeId) + ", ";
        }
      }
      else {
        fixture fixt = fixturesInThisChannel.get(0);
        text = text + getFixtureLongNameByType(fixt.fixtureTypeId);
      }
      pdf.text(text, 10, count*15);
    }
  }
  pdf.dispose();
  pdf.endDraw();
  
  
  float[] x = new float[fixtures.size()];
  float[] y = new float[fixtures.size()];
  for(int i = 0; i < fixtures.size(); i++) {
    fixture fix = fixtures.get(i);
    if(fix.size.isDrawn) {
      x[i] = fix.x_location+trusses[fix.parentAnsa].location.x;
      y[i] = fixtures.get(i).y_location+trusses[fix.parentAnsa].location.y;
    }
  }
  pdf = createGraphics(int(-(min(x))+max(x)+100), int(-(min(y))+max(y)+150), PDF, "FILES/map.pdf");
  pdf.beginDraw();
  pdf.background(255);
  pdf.fill(0);
  pdf.translate(-(min(x)), -(min(y))+80);
  for(int i = 0; i < fixtures.size(); i++) {
    fixture fix = fixtures.get(i);
    if(fix.size.isDrawn) {
      pdf.pushMatrix();
      pdf.translate(x[i], y[i]);
      pdf.rotate(radians(fix.rotationZ));
      fixtures.get(i).draw2D(i, pdf);
      pdf.popMatrix();
    }
  }
  pdf.dispose();
  pdf.endDraw();
  
}
