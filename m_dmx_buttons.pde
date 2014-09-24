boolean[] dmxButtonReleased = new int[512];
boolean dmxButtonPressed(int id, int val) {
  boolean toReturn = false;
  if(val == 255) {
    if(dmxButtonReleased[id]) {
      toReturn = true;
      dmxButtonReleased[id] = false;
    }
  }
  else {
    dmxButtonReleased[id] = true;
  }
  return toReturn;
}
