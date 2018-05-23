class Car {
  PVector pos; 
  PVector velocity;
  Plot plot;
  PNField noise_field;
  int samples = 10;
  float range = 10;
  float mod = 0.2;
  float max_velocity = 2;
  float size = 10;
  
  /**
   * Car
   * @param PVector pos
   * @param PVector velocity
   */
  Car( PVector pos, PNField noise_field ) {
    this.pos = pos;
    this.noise_field = noise_field;
    velocity = new PVector();
  }
  
  void tick() {
    for ( int i = 0; i < samples; i++ ) {
      float angle = ( i * 2 * PI ) / samples;
      
      // Get noise from the surounding
      float noise = noise_field.get3d(
        pos.x + sin( angle ) * range,
        pos.y + cos( angle ) * range,
        0
      );
      // Add that noise to the direction measured
      velocity.x += sin( angle ) * noise * mod;
      velocity.y += cos( angle ) * noise * mod;
    }

    // Limit maximum velocity
    if ( sqrt( velocity.x * velocity.x + velocity.y * velocity. y ) > max_velocity ) {
      velocity.normalize();
      velocity.mult( max_velocity );
    }

    // Apply velocity
    pos.add( velocity );

    // Wrap around
    if ( pos.x < 0 ) {
      pos.x += width;
    }
    if ( pos.x > width ) {
      pos.x -= width;
    }
    if ( pos.y < 0 ) {
      pos.y += height;
    }
    if ( pos.y > height ) {
      pos.y -= height;
    }
    
    // v.normalize();
    
    // size*=10;
  }


  void draw() {
    //stroke( 150, 50, 0 );
    fill( 0 );
    PVector v = velocity.copy();
    float s = v.x * v.x + v.y * v.y;
    s *= size;
    ellipse( pos.x, pos.y, s, s );
  }
}