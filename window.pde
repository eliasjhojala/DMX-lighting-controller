class Window {
  PVector size = new PVector(500, 500);
  java.lang.reflect.Field locX, locY;
  java.lang.reflect.Field open;
  
  
  
  
  java.lang.Object window;
  
  String name;
  
  boolean openChanged;
  
  Class windowClass;
  
  Window(String name, PVector size, java.lang.Object window) {
    this.name = name;
    this.size = size.get();
    windowClass = window.getClass();
    this.window = window;
    try {
      locX = windowClass.getDeclaredField("locX");
      locY = windowClass.getDeclaredField("locY");
      open = windowClass.getDeclaredField("open");
    }
    catch (Exception e) {
      e.printStackTrace();
      notifier.notify("Critical error loading window data", true);
    }
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
      try {
        int locXvalueToWindow = round(constrain(mouseX - pmouseX + locX.getInt(window), 40, width - (size.x+20+168)));
        locX.setInt(window, locXvalueToWindow);
        
        int locYvalueToWindow = round(constrain(mouseY - pmouseY + locY.getInt(window), 40, height - (size.y+40)));
        locY.setInt(window, locYvalueToWindow);
      }
      catch (Exception e) {
         e.printStackTrace();
         notifier.notify("Critical error with moving window", true);
      }
    }
    
    g.textSize(12);
    
    //Close button
    mouse.declareUpdateElementRelative(name+":close", name, 30, 10, 50, 20, g);
    mouse.setElementExpire(name+":close", 2);
    boolean cancelHover = mouse.elmIsHover(name+":close");
    g.fill(cancelHover ? 220 : 180, 30, 30);
    //Close if close is pressed
    if(mouse.isCaptured(name+":close")) {
      try {
        open.setBoolean(window, false);
      }
      catch (Exception e) {
        e.printStackTrace();
        notifier.notify("Critical error with closing window", true);
      }
    }
    g.rect(30, 10, 50, 20, 0, 4, 4, 0);
    g.fill(230);
    g.textAlign(CENTER);
    g.text("Close", 55, 24);
  }

}
