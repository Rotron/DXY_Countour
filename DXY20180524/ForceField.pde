

class ForceField {
  
  // We need to keep track of a Body and a radius
  Body body;
  float r;

  ForceField( float x, float y, float r) {
    this.r = r;
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);
    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    body.createFixture(cs,1);
  }

  // Formula for gravitational attraction
  // We are computing this in "world" coordinates
  // No need to convert to pixels and back
  Vec2 getForce( Body target_body ) {
    // Note the attractor's mass is 0 because it's fixed so can't use that
    float G = 1000; // Strength of force
    // clone() makes us a copy
    Vec2 pos = body.getWorldCenter();    
    Vec2 target_pos = target_body.getWorldCenter();
    // Vector pointing from mover to attractor
    Vec2 force = pos.sub( target_pos );
    float distance = force.length();
    // Keep force within bounds
    distance = constrain( distance, 0, 5 );
    force.normalize();
    // Calculate gravitional force magnitude
    float strength = (G * 1 * target_body.m_mass) / (distance * distance);
    force.mulLocal( strength );
    return force;
  }

  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}