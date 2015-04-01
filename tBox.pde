
  final int TEXTBOX_MODE_TEXT = 1;
  final int TEXTBOX_MODE_NUMBER = 2;
  final int TEXTBOX_MODE_IP = 3;

boolean keyDown = false;

class TextBox {
  color textBoxColor = color(50, 100, 255);
  String originalText = "";
  String editedText = "";
  TextBox(String originalText, int mode) {
    this.originalText = originalText;
    this.editedText = originalText;
    this.mode = mode;
  }
  
  void keyPressed() {
    textBox();
  }
  
  PVector textBoxLocation = new PVector(0, 0);
  PVector textBoxSize = new PVector(200, 20);
  
  boolean ready;
  boolean textHasChanged;
  
  int mode;
  
  int lastKeyCode;
  long lastMillis;
  
  boolean thisIsActive;
  
  
  
  
  void drawToBuffer(PGraphics g, Mouse mouse, String mouseObjectName) {
    
    if(mouse.elmIsHover(mouseObjectName)) { thisIsActive = true; textBox(); }

    g.pushStyle();
    themes.textBox.setTheme(g, mouse, mouse.elmIsHover(mouseObjectName), false);
    g.strokeWeight(1.5);
    g.stroke(multiplyColor(themes.textBoxColor.neutral, 0.7));
    g.rect(textBoxLocation.x, textBoxLocation.y, textBoxSize.x, textBoxSize.y);
    g.popStyle();
    if(editedText != null) {
      g.pushStyle();
        g.fill(255);
        g.text(editedText, textBoxLocation.x+4, textBoxLocation.x+3, textBoxSize.x-5, textBoxSize.y);
      g.popStyle();
    }
  }
  


  
  void textBox() {
    if(thisIsActive) {
      if (key == BACKSPACE && keyReleased) {
        if(editedText.length() > 0) {
          editedText = editedText.substring(0, editedText.length()-1);
        }
        keyReleased = false;
        export();
      }
      else if (key == ENTER && keyReleased) {
        export();
      }
      else if(editedText.equals("null")) { editedText = ""; }
      if(keyIsAccepted()) {
        editedText = editedText+key;
        export();
      }
    }
  }
  
  void export() {
    ready = true;
    textHasChanged = true;
    keyReleased = false;
  }
  
   
  
  
  boolean keyIsAccepted() {
    boolean toReturn = false;
    if(keyCode != 157 && keyCode != 16 && keyCode != 17 && keyCode != 18 && keyCode != 0 && keyCode != 20 && keyCode != 9 && keyReleased) {
      lastKeyCode = keyCode;
      keyReleased = false;
      if(mode == TEXTBOX_MODE_TEXT) {
        toReturn = true;
      }
      else if(mode == TEXTBOX_MODE_NUMBER) {
        toReturn = ((int(str(key)) > 0 && int(str(key)) <= 9) || key == '0');
      }
      else if(mode == TEXTBOX_MODE_IP) {
        toReturn = ((int(str(key)) > 0 && int(str(key)) <= 9) || key == '0' || key == '.');
      }
    }
    return toReturn;
  }
  
  
  String getText() {
    if(ready == true) {
      ready = false;
      originalText = editedText;
      return editedText;
    }
    return originalText;
  }
  
  boolean textChanged() {
    boolean toReturn = textHasChanged;
    textHasChanged = false;
    return toReturn;
  }
  
  void setText(String text) {
    originalText = text;
    editedText = text;
  }
  
  void setValue(int value) {
    if(value != 0) {
      originalText = str(value);
    }
    else {
      originalText = "";
    }
    editedText = originalText;
  }
  
}


class TextBoxTableWindow {
  Window window;
  TextBox[][] cells;
  
  int locX, locY, w, h;
  boolean open;
  
  String name;
  
  TextBoxTableWindow(String name, int x_, int y_) {
    this.name = name;
    w = x_*21+100;
    h = y_*21+100;
    cells = new TextBox[x_][y_];
    for(int x = 0; x < cells.length; x++) {
      for(int y = 0; y < cells[x].length; y++) {
        cells[x][y] = new TextBox("", 2);
        cells[x][y].textBoxSize = new PVector(20, 20);
      }
    }
    window = new Window(name+"cellTable", new PVector(w, h), this);
  }
  
  int changedX, changedY;
  boolean valueChanged;
  
  void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
    window.draw(g, mouse);
    g.translate(50, 50);
    for(int x = 0; x < cells.length; x++) {
      for(int y = 0; y < cells[x].length; y++) {
        g.pushMatrix();
          g.translate(x*21, y*21);
          String mouseObjectName = name+"cellTable["+str(x)+"]["+str(y)+"]";
          mouse.declareUpdateElementRelative(mouseObjectName, 100000, 0, 0, 20, 20, g);
          mouse.setElementExpire(mouseObjectName, 2);
          cells[x][y].drawToBuffer(g, mouse, mouseObjectName);
          if(cells[x][y].textChanged()) {
            valueChanged = true;
            changedX = x;
            changedY = y;
          }
        g.popMatrix();
      }
    }
  }
  
  boolean valueHasChanged() {
     boolean toReturn = valueChanged;
     valueChanged = false;
     return toReturn;
   }
   
   int[] changedValue() {
     int[] toReturn = new int[2];
     toReturn[0] = changedX;
     toReturn[1] = changedY;
     return toReturn;
   }
  
  int getValue(int x, int y) {
    if(x >= 0 && x < cells.length) if(y >= 0 && y < cells[x].length) {
      return int(cells[x][y].getText());
    }
    return 0;
  }
  
  void setValue(int value, int x, int y) {
    if(x >= 0 && x < cells.length) if(y >= 0 && y < cells[x].length) {
      cells[x][y].setValue(value);
    }
  }
  
  void setValue(int[][] value) {
    for(int x = 0; x < value.length; x++) {
      for(int y = 0; y < value[x].length; y++) {
        setValue(value[x][y], x, y);
      }
    }
  }
  
  void setValue(int val[]) {
    for(int i = 0; i < val.length; i++) {
      setValue(val[i], i, 0);
    }
  }
}
