class Trigon {
  PVector pos = new PVector();
  Triangle centerTri;
  private ArrayDeque<Triangle> _borderTris = new ArrayDeque<Triangle>();

  int numBorders = 3;

  private float _prePulseScaleFactor;
  float scaleFactor;
  float rotation;

  float lastPulse;
  float pulseDuration = 300;
  boolean isPulseAnimating = false;
  char currentPulseType;
  float centerTriPulseAmount = 1;
  
  Trigon(Triangle t) {
    centerTri = t;
    scaleFactor = t.scaleFactor;
    rotation = t.rotation;

    for (int i = 0; i < numBorders; i++) {
      _borderTris.add(new Triangle(centerTri.getPos(), centerTri.getSideLength() * (i + 2), centerTri.rotation));
    }
  }

  void triggerPulse(char pulseType) {
    if (!isPulseAnimating) {
      println("pulse triggered at " + millis());
      lastPulse = millis();
      currentPulseType = pulseType;
      isPulseAnimating = true;
      _prePulseScaleFactor = scaleFactor;
      //Pulse center triangle
      if (PULSE_TYPE_PUSH == currentPulseType) {
        //push border out by one and add another border in the center
        Triangle newTri = new Triangle(centerTri.getPos(), centerTri.getSideLength() * 2, centerTri.rotation);
        newTri.myColor = #FF0000;
        newTri.opacity = 255;
        _borderTris.addFirst(newTri);
      }
    }
  }
  
  void update() {
    if (isPulseAnimating) {
      if ((millis() - lastPulse) > pulseDuration) {
        //The pulse is over
        isPulseAnimating = false;
        if (PULSE_TYPE_PUSH == currentPulseType) {
          _borderTris.removeLast();
          scaleFactor = _prePulseScaleFactor;
        }
      } else {
        float pulsePercentComplete = (millis() - lastPulse) / pulseDuration;
        //Pulse is animating
        if (PULSE_TYPE_PUSH == currentPulseType) {
          if (pulsePercentComplete > 0.5){
            //We're at least halfway done with the pulse
            scaleFactor = lerp(_prePulseScaleFactor + centerTriPulseAmount, _prePulseScaleFactor, pulsePercentComplete);
          } else {
            //We're less than halfway done with the pulse
            scaleFactor = lerp(_prePulseScaleFactor, _prePulseScaleFactor + centerTriPulseAmount, pulsePercentComplete);
          }
          Triangle first = _borderTris.getFirst();
          //first.opacity += 0.1;
        }
      }
    }

    updateTriangle(centerTri);

    for (Triangle tri : _borderTris) {
      updateTriangle(tri);
    }
  }

  void updateTriangle(Triangle t) {
    t.rotation = rotation;
    t.scaleFactor = scaleFactor;
  }

  void draw() {
    centerTri.draw();

    for (Triangle tri : _borderTris) {
      tri.draw();
    }
  }
}
