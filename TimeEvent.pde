class TimeEvent {
    char type;
    char subtype;
    float start;
    float duration = -1; //Defaults to no end
    boolean started = false;

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
}
