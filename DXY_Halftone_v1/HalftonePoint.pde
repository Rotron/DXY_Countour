class HalftonePoint {
  float x;
  float y;
  float r;
  float fill_spacing = 5;
  float angle = 120;
  float segment_ratio = 0.15;
  
  ArrayList<Line> lines;
  
  HalftonePoint( float x, float y, float r ) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  void draw() {
    this.lines = get_lines();
    this.drawCircle();
    this.drawFill();
    if ( random(0,100) > 90 ) {
      this.drawFill( 90 );
    }
  }
  
  void drawFill() {
    drawFill(0);
  }
  
  void drawFill( float angle_offset ) {
    PVector start = new PVector( 
      this.x + sin( radians( this.angle + angle_offset + 45 ) ) * this.r * 2,
      this.y + cos( radians( this.angle + angle_offset + 45 ) ) * this.r * 2
    );
    PVector end = new PVector( 
      this.x + sin( radians( this.angle + angle_offset - 45 ) ) * this.r * 2,
      this.y + cos( radians( this.angle + angle_offset - 45 ) ) * this.r * 2
    );
    float dir = this.angle + 180 + angle_offset;
    
    float dist = start.dist( end );
    int lines = round( dist / this.fill_spacing );
    
    for ( int i = 0; i < lines; i++ ) {
      float travel = i * 1.0 / lines;
      PVector pos1 = PVector.lerp(start, end, travel);
      PVector pos2 = new PVector(
        pos1.x + sin( radians( dir ) ) * this.r * 3,
        pos1.y + cos( radians( dir ) ) * this.r * 3
      );
      Line l = new Line(pos1,pos2);
      this.drawFillLine( l );
    }
    // Debug the projection tangent
    //line( start.x, start.y, end.x, end.y );
  }
  void drawFillLine( Line projected ) {
    ArrayList<PVector> vectors = new ArrayList();
    for ( Line l : this.lines ) {
      PVector intersect = projected.intersect( l );
      if ( null == intersect ) {
        continue;
      }
      vectors.add( intersect );
    }
    
    if ( 2 != vectors.size() ) {
      return;
    }
    
    Line fill_line = new Line( vectors.get(0), vectors.get(1) );
    fill_line.draw();
  }
  
  void drawCircle() {
    for ( Line l : this.lines ) {
       l.draw();
    }
  }
  
  ArrayList<Line> get_lines() {
    ArrayList<Line> lines = new ArrayList();
    int segments = round( r * this.segment_ratio );
    for ( int i = 0; i < segments; i++ ) {
      float deg = 360.0 * i / segments;
      float deg_end = 360.0 * ( i + 1 ) / segments;
      lines.add( new Line(
        this.x + sin(radians(deg)) * this.r,
        this.y + cos(radians(deg)) * this.r,
        this.x + sin(radians(deg_end)) * this.r,
        this.y + cos(radians(deg_end)) * this.r
       ) );
    }
    return lines;
  }
}