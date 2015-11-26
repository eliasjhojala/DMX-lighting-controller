

interface Module {
  Object getValue();
}

class ModulePicker implements Module {
  Boolean getValue() {
    return false;
  }
}

interface IntegerModule extends Module {
  Integer getValue();
}

interface StringModule extends Module {
  String getValue();
}
