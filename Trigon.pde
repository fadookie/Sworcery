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

  color myColor = #FFFFFF;
  
  Trigon(Triangle t) {
    centerTri = t;
    scaleFactor = t.scaleFactor;
    rotation = t.rotation;
    myColor = t.myColor;

    for (int i = 0; i < numBorders; i++) {
      Triangle tri = new Triangle(centerTri.getPos(), centerTri.getSideBaseLength(), centerTri.rotation);
      tri.setSideLengthScale(i + 2);
      tri.myColor = myColor;
      _borderTris.add(tri);
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
        Triangle newTri = new Triangle(centerTri.getPos(), centerTri.getSideBaseLength() + 1, centerTri.rotation);
        newTri.myColor = myColor;
        _borderTris.addFirst(newTri);
      }
    }
  }
  
  void update() {
    updateTriangle(centerTri);

    for (Triangle tri : _borderTris) {
      updateTriangle(tri);
    }

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
            //Snap the center triangle back
            centerTri.scaleFactorMultiplier = lerp(_prePulseScaleFactor + centerTriPulseAmount, _prePulseScaleFactor, pulsePercentComplete);
          } else {
            //We're less than halfway done with the pulse
            //Pulse the center triangle out
            centerTri.scaleFactorMultiplier = lerp(_prePulseScaleFactor, _prePulseScaleFactor + centerTriPulseAmount, pulsePercentComplete);
            //Enlarge all the borders over time to make room for the incoming border
            int centerEdgeOffsetCounter = 0;
            for (Triangle tri : _borderTris) {
              tri.setSideLengthScale(lerp(centerEdgeOffsetCounter + 1, centerEdgeOffsetCounter + 2, pulsePercentComplete * 2));
              centerEdgeOffsetCounter++;
            }
          }

          //Process colors
          /*
          for (Triangle tri : _borderTris) {
            tri.myColor = #FFFFFF;
            tri.opacity = 255;
          }
          */
          Triangle first = _borderTris.getFirst();
          //first.myColor = #0000FF;
          first.opacity = lerp(50, 255, pulsePercentComplete);

          Triangle last = _borderTris.getLast();
          //last.myColor = #00FF00;
          last.opacity = lerp(255, 0, pulsePercentComplete);
        }
      }
    }
  }

  void updateTriangle(Triangle t) {
    t.rotation = rotation;
    t.scaleFactorMultiplier = scaleFactor;
  }

  void draw() {
    centerTri.draw();

    for (Triangle tri : _borderTris) {
      tri.draw();
    }
  }
}
