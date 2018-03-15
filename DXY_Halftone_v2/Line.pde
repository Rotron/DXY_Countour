class Line {
  PVector start; 
  PVector end;
  
  /**
   * Line
   * @param PVector start
   * @param PVector end
   */
  Line( PVector start, PVector end ) {
    this.start = start;
    this.end = end;
  }
  
  /**
   * Line
   * @param float x1
   * @param float y1
   * @param float x2
   * @param float y2
   */
  Line( float x1, float y1, float x2, float y2 ) {
    this.start = new PVector( x1, y1 );
    this.end = new PVector( x2, y2 );
  }
  Line copy() {
    return new Line( start.copy(), end.copy() );
  }
  PVector intersect( Line l2 ) {
    // calculate the distance to intersection point
    float uA = ((l2.end.x-l2.start.x)*(this.start.y-l2.start.y) - (l2.end.y-l2.start.y)*(this.start.x-l2.start.x)) / ((l2.end.y-l2.start.y)*(this.end.x-this.start.x) - (l2.end.x-l2.start.x)*(this.end.y-this.start.y));
    float uB = ((this.end.x-this.start.x)*(this.start.y-l2.start.y) - (this.end.y-this.start.y)*(this.start.x-l2.start.x)) / ((l2.end.y-l2.start.y)*(this.end.x-this.start.x) - (l2.end.x-l2.start.x)*(this.end.y-this.start.y));
  
    // if uA and uB are between 0-1, lines are colliding
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      return new PVector(this.start.x + (uA * (this.end.x-this.start.x)), this.start.y + (uA * (this.end.y-this.start.y)));
    }
    return null;
  }
  
  void draw() {
    line( start.x, start.y, end.x, end.y );
    if ( plot.enabled ) {
      plot.line( start, end );
    }
  }
}