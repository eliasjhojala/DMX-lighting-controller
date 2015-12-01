

interface Module {
  Object getValue();
  void draw(ImageBuffer buffer, PGraphics g);
}

class ModulePicker implements Module {
  PVector location;
  Void getValue() {
    return null;
  }
  
  void draw(ImageBuffer buffer, PGraphics g) {
    
  }
}

interface IntegerModule extends Module {
  Integer getValue();
}

interface StringModule extends Module {
  String getValue();
}
