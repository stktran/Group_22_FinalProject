class Timer {
  int time;
  int interval;
  boolean repeat;
  boolean isActive;
  
  Timer(int _interval) {
    time = millis();
    interval = _interval;
    repeat = false;
    isActive = true;
  }
  
  Timer(int _interval, boolean _repeat) {
    time = millis();
    interval = _interval;
    repeat = _repeat;
    isActive = true;
  }
  
  boolean hasElapsed() {
    if ((millis() - time) > interval && isActive) {
      time = millis();
      if (!repeat) {
        isActive = false;
      }
      return true;
    }
    return false;
  }
  void resetClock() {
    time = millis();
  }
}