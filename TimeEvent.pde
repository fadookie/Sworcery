class TimeEvent {
    char type;
    char subtype;
    float start;
    float end = -1; //Defaults to no end, signified by -1
    HashMap<String, Object> additionalSettings = new HashMap<String, Object>();

    TimeEvent() {
    }

    TimeEvent(char _type, char _subtype, float _start) {
      type = _type;
      subtype = _subtype;
      start = _start;
    }

    TimeEvent(char _type, char _subtype, float _start, float _end) {
      type = _type;
      subtype = _subtype;
      start = _start;
      end = _end;
    }

    TimeEvent(char _type, char _subtype, float _start, float _end, HashMap<String, Object> _additionalSettings) {
      type = _type;
      subtype = _subtype;
      start = _start;
      end = _end;
      additionalSettings = _additionalSettings;
    }

    /**
     * Get duration in Ms, -1 means unknown (no end specified)
     */
    float getDuration() {
      if (-1 == end) {
        return end;
      } else {
        return end - start;
      }
    }

    /**
     * Get completion as a percentage between 0 and 1. 0 will always be returned for events with no set end time.
     */
    float getCompletion(float currentTime) {
      if (-1 == end) return 0;
      return constrain((currentTime - start) / getDuration(), 0, 1);
    }

    String toString() {
      return "TimeEvent {" + " type:" + (int)type + " subtype:" + (int)subtype + " start:" + start + " end:" + end + " }";
    }
}
