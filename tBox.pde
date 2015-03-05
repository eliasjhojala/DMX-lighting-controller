
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
    
    if(mouse.elmIsHover(mouseObjectName)) { thisIsActive = true; textBox(); textBoxColor = color(50, 200, 255); }
    else {
       textBoxColor  = color(50, 100, 255);
    }

    g.pushStyle();
    g.fill(textBoxColor);
    g.rect(textBoxLocation.x, textBoxLocation.y-3, textBoxSize.x, textBoxSize.y);
    g.popStyle();
    if(editedText != null) {
      g.text(editedText, textBoxLocation.x+4, textBoxLocation.x, textBoxSize.x-5, textBoxSize.y);
    }
  }
  


  
  void textBox() {
    if(thisIsActive) {
      if (key == BACKSPACE && keyReleased) {
        if(editedText.length() > 0) {
          editedText = editedText.substring(0, editedText.length()-1);
        }
        keyReleased = false;
      }
      else if (key == ENTER && keyReleased) {
        ready = true;
        textHasChanged = true;
        keyReleased = false;
      }
      else if(editedText.equals("null")) { editedText = ""; }
      if(keyIsAccepted()) {
        editedText = editedText+key;
      }
    }
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
  
}

