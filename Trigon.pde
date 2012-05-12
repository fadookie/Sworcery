class Trigon {
  PVector pos = new PVector();
  Triangle centerTri;
  private ArrayDeque<Triangle> _borderTris = new ArrayDeque<Triangle>();

  int numBorders = 5;

  float scaleFactor;
  float rotation;
  
  Trigon(Triangle t) {
    centerTri = t;

    for (int i = 0; i < numBorders; i++) {
      _borderTris.add(new Triangle(centerTri.getPos(), centerTri.getSideLength() * (i + 1), centerTri.rotation));
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
