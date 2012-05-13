class Trigon {
  PVector pos = new PVector();
  Triangle centerTri;
  private ArrayDeque<Triangle> _borderTris = new ArrayDeque<Triangle>();

  int numBorders = 5;

  float scaleFactor;
  float rotation;
  
  Trigon(Triangle t) {
    centerTri = t;
    scaleFactor = t.scaleFactor;
    rotation = t.rotation;

    for (int i = 0; i < numBorders; i++) {
      _borderTris.add(new Triangle(centerTri.getPos(), centerTri.getSideLength() * (i + 1), centerTri.rotation));
    }
  }

  void triggerPulse(char pulseType) {
    //Pulse center triangle
    if (PULSE_TYPE_PUSH == pulseType) {
      //push border out by one and add another border in the center
      Triangle newTri = new Triangle(centerTri.getPos(), centerTri.scaleFactor, centerTri.rotation);
      newTri.myColor = color(255, 255, 255, 0);
      _borderTris.addFirst(newTri);
    }
  }
  
  void update() {
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
