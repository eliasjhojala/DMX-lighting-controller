class Fade { 
  int originalValue, targetValue, actualValue;
  int preFade, postFade;
  long startMillis;
  boolean complete;
  
  Fade(int from, int to, int pre, int post) {
    startFade(from, to, pre, post);
  }
  
  Fade(int from, int to) {
    startFade(from, to, preFade, postFade);
  }
  
  Fade() {
  }
  
  void startFade(int from, int to, int pre, int post) {
    if(to != from) {
      preFade = pre;
      postFade = post;
      startMillis = millis();
      originalValue = from;
      actualValue = originalValue;
      targetValue = to;
      complete = false;
    }
  }
  
  void countActualValue() {
    if(!complete) {
      int timer = round(millis()-startMillis);
      if(actualValue < targetValue && actualValue < 255) {
        actualValue = constrain(iMap(timer, 0, preFade, originalValue, targetValue), originalValue, targetValue);
      } 
      else if(actualValue > targetValue && actualValue > 0) {
        actualValue = constrain(iMap(timer, 0, postFade, originalValue, targetValue), targetValue, originalValue);
      } 
      else {
        complete = true;
      }
    }
  }
  
  int getActualValue() {
    return actualValue;
  }
  boolean  isCompleted() {
    return complete;
  }
}
