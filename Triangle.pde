/**
 * Object representing an equilateral triangle
 */

class Triangle {
  private PVector _pos;
  private float _sideLength;
  float rotation = radians(0);
  private PolarCoord _vertex3polar;
  private PVector _vertex3;
  
  //Post-transform vectors for drawing
  private PVector _vertex1post = new PVector();
  private PVector _vertex2post = new PVector();
  private PVector _vertex3post = new PVector();
  float scaleFactor = 1;
  
  //char tri_type = TRI_TYPE_CENTER;
  char tri_type = TRI_TYPE_CORNER;
    
  Triangle(PVector pos, float sideLength, float rot) {
    //Todo: add getters/setters
    _pos = pos;
    _sideLength = sideLength;
    rotation = rot;
    _vertex3polar = new PolarCoord(_sideLength, radians(60));
    
    _vertex3 = _vertex3polar.getCartesianCoords();
  }
  
  void draw() {
    _vertex1post = _pos.get();
    _vertex2post.x = _sideLength;
    _vertex2post.y = 0;
    _vertex3post = _vertex3.get();
    
    pushMatrix();
    
    if (TRI_TYPE_CORNER == tri_type) {
      translate(_pos.x, _pos.y);
      rotate(rotation);
      //We draw the triangle in local space, oriented flat and downward.
      //We apply the scaling factor directly to the vertices to ensure clean, 1px lines, scale() doesn't do this for all renderers.
      triangle(0, 0, _sideLength * scaleFactor, 0, _vertex3.x * scaleFactor, _vertex3.y * scaleFactor);
    } else if (TRI_TYPE_CENTER == tri_type) {
      translate(_pos.x, _pos.y);
      
      //Manually rotate points
      _vertex1post = QMath.rotatePVector2D(_vertex1post, rotation);
      
      _vertex2post = QMath.rotatePVector2D(_vertex2post, rotation);
      
      _vertex3post = QMath.rotatePVector2D(_vertex3post, rotation);
    } else {
      println("ERROR: Triangle[" + this + "].draw(): Unrecognized triangle type.");
    }
    triangle(_vertex1post.x, _vertex1post.y, _vertex2post.x, _vertex2post.y, _vertex3post.x, _vertex3post.y);
    popMatrix();
  }
}
