HelpWindow help = new HelpWindow();

class HelpWindow {
  color baseStrokeColor = color(200, 200, 200);
  color baseBackgroundColor = color(255, 230);
  
  color blockBackgroundColor = color(255, 230);
  color blockStrokeColor = color(200, 200, 200);
  int blockStrokeWeight = 2;
  color blockSubjectTextColor = color(0);
  color blockTextColor = color(0, 200);
  int blockTextSize = 13;
  int blockSubjectTextSize = 25;
  PVector blockSize = new PVector(500, 100);
  
  int locX, locY, w, h;
  boolean open;
  
  float offset = 0;
  
  ArrayList<HelpObject> blocks = new ArrayList<HelpObject>();
  
  Window helpWindowBase;
  
  HelpWindow() {
    locX = 100;
    locY = 100;
    w = 500;
    h = 500;
    helpWindowBase = new Window("helpWindow", new PVector(500, 500));
  }
  
  void add(String subject, String text) {
    blocks.add(new HelpObject(this, subject, text));
  }
  
  
  
  void draw(PGraphics g, Mouse mouse, boolean doTranslate) {
    g.pushMatrix();
      helpWindowBase.draw(g, mouse);
      locX = helpWindowBase.locX;
      locY = helpWindowBase.locY;
      open = helpWindowBase.getOpen();
        
      g.translate(0, offset);
      for(int i = 0; i < blocks.size(); i++) {         
        blocks.get(i).draw(g, mouse);
        g.translate(0, blockSize.y);
      }
    g.popMatrix();
    if(mouse.elmIsHover("helpWindow") && scrolled) {
      offset += scrollSpeed;
    }
    constrainOffset();
  }
  
  void constrainOffset() {
    if(offset < 40) { offset = 40; }
  }
}

  

class HelpObject {
  String subject;
  String text;
  
  HelpWindow parent;
  HelpObject(HelpWindow parent, String subject, String text) {
    this.parent = parent;
    this.subject = subject;
    this.text = text;
  }
  
  void draw(PGraphics g, Mouse mouse) {
    g.pushMatrix();
      g.pushStyle();
        g.fill(parent.blockBackgroundColor);
        g.stroke(parent.blockStrokeColor);
        g.strokeWeight(parent.blockStrokeWeight);
        g.rect(0, 0, parent.blockSize.x, parent.blockSize.y, 20);
        g.fill(parent.blockSubjectTextColor);
        g.translate(10, 10);
        g.textSize(parent.blockSubjectTextSize);
        g.text(subject, 0, 0, parent.blockSize.x-20, parent.blockSize.y);
        g.translate(10, parent.blockSubjectTextSize*1.2);
        g.fill(parent.blockTextColor);
        g.textSize(parent.blockTextSize);
        g.text(text, 0, 0, parent.blockSize.x-20, parent.blockSize.y);
      g.popStyle();
    g.popMatrix();
  }
}
