class TimeEvent {
    char type;
    char subtype;
    float start;
    float duration = -1; //Defaults to no end
    HashMap<String, Object> additionalSettings = new HashMap<String, Object>();

    TimeEvent() {
    }

    TimeEvent(char _type, char _subtype, float _start) {
      type = _type;
      subtype = _subtype;
      start = _start;
    }

    TimeEvent(char _type, char _subtype, float _start, float _duration) {
      type = _type;
      subtype = _subtype;
      start = _start;
      duration = _duration;
    }

    TimeEvent(char _type, char _subtype, float _start, float _duration, HashMap<String, Object> _additionalSettings) {
      type = _type;
      subtype = _subtype;
      start = _start;
      duration = _duration;
      additionalSettings = _additionalSettings;
    }

    /**
     * Get completion as a percentage between 0 and 1
     */
    float getCompletion(float currentTime) {
      return constrain((currentTime - start) / duration, 0, 1);
    }

    String toString() {
      return "TimeEvent {" + " type:" + (int)type + " subtype:" + (int)subtype + " start:" + start + " duration:" + duration + " }";
    }
}
