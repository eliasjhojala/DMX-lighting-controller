boolean dmxButtonPressed(int id, int val) {
  boolean buttonDown = val > 100;
  
  nextStepPressed = buttonDown && id == 1;
  if(buttonDown && id == 2) { chaseMode++; if(chaseMode > 5) { chaseMode = 1; } }
  wave = buttonDown && id == 3;
  return buttonDown;
}
