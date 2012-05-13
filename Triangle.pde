/**
 * Object representing an equilateral triangle
 */

class Triangle {
  private PVector _pos;
  private float _sideLength;
  private float _sideLengthScale = 1;
  float rotation = radians(0);
  private PolarCoord _vertex3polar;
  private PVector _vertex3;
  
  //Post-transform vectors for drawing
  private PVector _vertex1post = new PVector();
  private PVector _vertex2post = new PVector();
  private PVector _vertex3post = new PVector();
  private PVector _centroid = new PVector();
  float scaleFactor = 1;
  
  //char tri_type = TRI_TYPE_CORNER;
  char tri_type = TRI_TYPE_CENTER;
  boolean solid = false;
  color myColor = color(255);
  float opacity = 255;
    
  Triangle(PVector pos, float sideLength, float rot) {
    //Todo: add getters/setters
    _pos = pos;
    _sideLength = sideLength;
    rotation = rot;

    _vertex3polar = new PolarCoord(0, radians(60));
    _setVertex3Radius(getSideTotalLength()); //This sets sets vertex3polar and vertex3
  }

  PVector getPos() {
    return _pos;
  }

  float getSideBaseLength() {
    return _sideLength;
  }

  float getSideTotalLength() {
    return _sideLength * _sideLengthScale;
  }

  void setSideLengthScale(float scale) {
    _sideLengthScale = scale;
    _setVertex3Radius(getSideTotalLength());
  }

  /**
   * "Bake" current side length scale into side length, reset scale to 1
   */
  void bakeSideLength() {
    _sideLength = getSideTotalLength();
    setSideLengthScale(1);
  }

  private void _setVertex3Radius(float r) {
    _vertex3polar.r = r;
    _vertex3 = _vertex3polar.getCartesianCoords();
  }
  
  void draw() {
    _vertex1post.x = 0;
    _vertex1post.y = 0;
    _vertex2post.x = getSideTotalLength();
    _vertex2post.y = 0;
    _vertex3post = _vertex3.get();
    
    pushMatrix();
    pushStyle();

    if (solid) {
      noStroke();
      fill(myColor, opacity);
    } else {
      stroke(myColor, opacity);
      noFill();
    }

    if (DEBUG) {
      stroke(myColor, opacity);
      noFill();
    }
    
    translate(_pos.x, _pos.y);
    rotate(rotation);
    
    //We apply the scaling factor directly to the vertices to ensure clean, 1px lines, scale() doesn't do this for all renderers.
    //This also lets us caclulate the correct centroid if we are drawing with TRI_TYPE_CENTER
    _vertex1post.mult(scaleFactor);
    _vertex2post.mult(scaleFactor);
    _vertex3post.mult(scaleFactor);

    if (DEBUG) {
      //Draw pos in red
      pushStyle();
      stroke(#FF0000);
      point(0, 0);
      popStyle();
    }
    
    if (TRI_TYPE_CORNER == tri_type) {
      //This is the default behavior of the matrix
    } else if (TRI_TYPE_CENTER == tri_type) {
      //Offset the triangle drawing so that its centroid is at 0,0
      _centroid.x = (_vertex1post.x + _vertex2post.x + _vertex3post.x) / 3;
      _centroid.y = (_vertex1post.y + _vertex2post.y + _vertex3post.y) / 3;
      translate(-_centroid.x, -_centroid.y);
    } else {
      println("ERROR: Triangle[" + this + "].draw(): Unrecognized triangle type.");
    }
    
    if (DEBUG) {
      //Draw 0,0 in local space in green
      pushStyle();
      stroke(#00FF00);
      point(0, 0);
      popStyle();
    }

    //We draw the triangle in local space, oriented with its base at the top and tip pointing downward.
    triangle(_vertex1post.x, _vertex1post.y, _vertex2post.x, _vertex2post.y, _vertex3post.x, _vertex3post.y);

    popStyle();
    popMatrix();
  }

  String toString() {
    return "Triangle {" + " _pos:"  + _pos + ", scaleFactor:" + scaleFactor + ", rotation:" + rotation + "}";
  }
}
