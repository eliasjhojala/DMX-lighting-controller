

interface Module {
  Object getValue();
}

class ModulePicker implements Module {
  Void getValue() {
    return null;
  }
}

interface IntegerModule extends Module {
  Integer getValue();
}

interface StringModule extends Module {
  String getValue();
}
