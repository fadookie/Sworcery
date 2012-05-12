class Trigon {
  PVector pos = new PVector();
  Triangle centerTri;
  private ArrayDeque<Triangle> _borderTris = new ArrayDeque<Triangle>();
  
  Trigon(Triangle t) {
    centerTri = t;
  }
  
  void addScale(float amount) {
    centerTri.scaleFactor += amount;
  }
  
  void addRotation(float amount) {
    centerTri.rotation += amount;
  }
  
  void draw() {
    centerTri.draw();
  }
}
