class Window {
  PVector size = new PVector(500, 500);
  int locX, locY;
  boolean open;
  
  String name;
  
  boolean openChanged;
  
  Window(String name, PVector size) {
    this.name = name;
    this.size = size.get();
  }
  void draw(PGraphics g, Mouse mouse) {
    themes.window.setTheme(g, mouse);
    
    //Box itself
    g.rect(0, 0, size.x, size.y, 20);
    mouse.declareUpdateElementRelative(name, 1, 0, 0, round(size.x), round(size.y), g);
    mouse.setElementExpire(name, 2);
    
    //Grabable location button
    g.fill(180);
    g.noStroke();
    g.rect(10, 10, 20, 20, 20, 0, 0, 4);
    mouse.declareUpdateElementRelative(name+":move", name, 10, 10, 20, 20, g);
    mouse.setElementExpire(name+":move", 2);
    if(mouse.isCaptured(name+":move")) {
      locY = round(constrain(mouseY - pmouseY + locY, 40, height - (size.y+40)));
      locX = round(constrain(mouseX - pmouseX + locX, 40, width - (size.x + 20 + 168)));
    }
    
    g.textSize(12);
    
    //Close button
    mouse.declareUpdateElementRelative(name+":close", name, 30, 10, 50, 20, g);
    mouse.setElementExpire(name+":close", 2);
    boolean cancelHover = mouse.elmIsHover(name+":close");
    g.fill(cancelHover ? 220 : 180, 30, 30);
    //Close if close is pressed
    if(mouse.isCaptured(name+":close")) { open = false; openChanged = true; }
    g.rect(30, 10, 50, 20, 0, 4, 4, 0);
    g.fill(230);
    g.textAlign(CENTER);
    g.text("Close", 55, 24);
  }
  
  boolean openChanged() {
    boolean toReturn = openChanged;
    openChanged = false;
    return toReturn;
  }
  
  boolean getOpen() {
    if(openChanged()) {
      return open;
    }
    return true;
  }
}
