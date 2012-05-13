class Trigon {
  PVector pos = new PVector();
  Triangle centerTri;
  private ArrayDeque<Triangle> _borderTris = new ArrayDeque<Triangle>();

  int maxBorders = 3;

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

    for (int i = 0; i < maxBorders; i++) {
      Triangle tri = new Triangle(centerTri.getPos(), centerTri.getSideBaseLength(), centerTri.rotation);
      tri.setSideLengthScale(i + 2); //Needs to be at least one, so we add 1. Needs to be 1 level above the center triangle, so we add 1 again.
      tri.myColor = myColor;
      _borderTris.add(tri);
    }
  }

  void triggerPulse(char pulseType) {
    if (!isPulseAnimating) {
      println("pulse triggered at " + millis() + " audio: " + music.position());

      //These pulse types can be wrapped around more primitive ones, so we'll call triggerPulse recursively before setting up timers, bools, etc.
      if (PULSE_TYPE_PUSH_ADD == pulseType) {
        maxBorders++;
        triggerPulse(PULSE_TYPE_PUSH);
      } else if (PULSE_TYPE_PUSH_ADD_EMPTY == pulseType) {
        maxBorders++;
        triggerPulse(PULSE_TYPE_PUSH_EMPTY);
      }

      lastPulse = millis();
      currentPulseType = pulseType;
      isPulseAnimating = true;
      //Pulse center triangle
      if (PULSE_TYPE_PUSH == pulseType) {
        //push border out by one and add another border in the center
        Triangle newTri = new Triangle(centerTri.getPos(), centerTri.getSideBaseLength() + 1, centerTri.rotation);
        newTri.myColor = myColor;
        _borderTris.addFirst(newTri);
      } else if (PULSE_TYPE_PUSH_EMPTY == pulseType) {
        if (_borderTris.size() > 0) {
          //Only bother adding a spacer if there are already borders
          Triangle newTri = new Triangle(centerTri.getPos(), centerTri.getSideBaseLength() + 1, centerTri.rotation);
          newTri.visible = false;
          _borderTris.addFirst(newTri);
        }
      } else if (PULSE_TYPE_ADD_BORDER == pulseType) {
        if (_borderTris.size() < maxBorders) {
          Triangle newTri = new Triangle(centerTri.getPos(), centerTri.getSideBaseLength() + _borderTris.size(), centerTri.rotation);
          newTri.myColor = myColor;
          _borderTris.addLast(newTri);
        }
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
        if (PULSE_TYPE_PUSH == currentPulseType
            || PULSE_TYPE_PUSH_EMPTY == currentPulseType
        ) {
          //If we are over the border limit and done animating, remove the last border
          if (_borderTris.size() > maxBorders) {
            _borderTris.removeLast();
          }
        }

        trimBorder();
      } else {
        float pulsePercentComplete = (millis() - lastPulse) / pulseDuration;
        //Pulse is animating
        if (PULSE_TYPE_PUSH == currentPulseType
            || PULSE_TYPE_PUSH_EMPTY == currentPulseType
        ) {
          throbCenterTriangle(pulsePercentComplete);

          if (pulsePercentComplete < 0.5) {
            //We're less than halfway done with the pulse
            //Enlarge all the borders over time to make room for the incoming border
            {
              int centerEdgeOffsetCounter = 0;
              for (Triangle tri : _borderTris) {
                tri.setSideLengthScale(lerp(centerEdgeOffsetCounter + 1, centerEdgeOffsetCounter + 2, pulsePercentComplete * 2));
                centerEdgeOffsetCounter++;
              }
            }
          }


          //Process colors
          if (DEBUG) {
            for (Triangle tri : _borderTris) {
              tri.myColor = #FFFFFF;
              tri.opacity = 255;
            }
          }

          try {
            Triangle first = _borderTris.getFirst();
            if (first.visible) {
              if (DEBUG) first.myColor = #0000FF;
              first.opacity = lerp(50, 255, pulsePercentComplete);
            }
          } catch (NoSuchElementException e) {
          }

          try {
            Triangle last = _borderTris.getLast();
            if (last.visible) {
              //If we are going over the border limit, fade the last border out
              if (_borderTris.size() > maxBorders) {
                if (DEBUG) last.myColor = #00FF00;
                last.opacity = lerp(255, 0, pulsePercentComplete);
              }
            }
          } catch (NoSuchElementException e) {
          }

        } else if (PULSE_TYPE_ADD_BORDER == currentPulseType) {
          Triangle last = _borderTris.getLast();
          //If we are not over border limit, fade in the new border
          if (_borderTris.size() < maxBorders) {
            last.opacity = lerp(255, 0, pulsePercentComplete);
          }
        } else if (PULSE_TYPE_SQUEEZE == currentPulseType) {
          throbCenterTriangle(pulsePercentComplete);
        }
      }
    }
  }

  /**
   * Dispose of invisible outer border triangle(s)
   */
  void trimBorder() {
    boolean done = false;
    while (!done) {
      try {
        Triangle last = _borderTris.getLast();
        if (!last.visible) {
          _borderTris.removeLast();
        } else {
          done = true;
        }
      } catch (NoSuchElementException e) {
        done = true;
      }
    }
  }

  void throbCenterTriangle(float pulsePercentComplete) {
      if (pulsePercentComplete > 0.5){
        //We're at least halfway done with the pulse
        //Snap the center triangle back
        centerTri.scaleFactorMultiplier = lerp(scaleFactor + centerTriPulseAmount, scaleFactor, pulsePercentComplete);
      } else {
        //We're less than halfway done with the pulse
        //Pulse the center triangle out
        centerTri.scaleFactorMultiplier = lerp(scaleFactor, scaleFactor + centerTriPulseAmount, pulsePercentComplete);
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
