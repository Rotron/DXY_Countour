class ChainSegment {
  
  float len;
  float k = 0.1;
  float w = 20;
  float h = 5;
  
  float slack = 5;
  ChainSegment previous;
  ChainSegment next;
  
  Body body;
  BodyDef bd;
  FixtureDef fd;
  Fixture fixture;
  RopeJoint rope_joint;
  DistanceJoint dist_joint;

  ChainSegment( int x, int y ) {
    
    // Define the body
    bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set( box2d.coordPixelsToWorld( x,y ) );
    
    body = box2d.createBody(bd);

    // Define the polygon / box shape
    PolygonShape sd = new PolygonShape();
    
    float _w = box2d.scalarPixelsToWorld(w/2);
    float _h = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(_w, _h);
    
    FixtureDef fd  = new FixtureDef();
    fd.shape       = sd;
    fd.density     = 1;
    fd.friction    = 0.2;
    fd.restitution = 0.2;
    
    fixture = body.createFixture(fd);
  }
  
  void createRopeJoint() {
    if ( null == previous ) {
      return;
    }
    // Create the joint definition
    RopeJointDef jd = new RopeJointDef();
    jd.maxLength = box2d.scalarPixelsToWorld( slack );

    // Connect the bodies
    jd.bodyA = previous.body;
    jd.bodyB = body;

    // Create the joint
    rope_joint = (RopeJoint) box2d.world.createJoint(jd);
  }

  
  void createDistJoint() {
    if ( null == previous ) {
      return;
    }

    // Create the joint definition
    DistanceJointDef jd = new DistanceJointDef();
    jd.length = box2d.scalarPixelsToWorld( slack * 5 );
    jd.collideConnected = false;
    jd.frequencyHz = 0;
    jd.dampingRatio = 0;

    // Connect the bodies
    jd.bodyA = previous.body;
    jd.bodyB = body;

    // Create the joint
    dist_joint = (DistanceJoint) box2d.world.createJoint(jd);
  }


  void tick() {

  }
  void draw() {
    
    
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    
    // Get its angle of rotation
    float a = body.getAngle();

    Vec2 force = new Vec2();

    int red = 0;
    int green = 0;
    int blue = 0;

    if ( null != rope_joint ) {
      rope_joint.getReactionForce( 1 / dt, force );
      red = round( force.length() );
     if ( ! box2d.world.isLocked() && red > 2000 && null != rope_joint && null != dist_joint ) {
       box2d.world.destroyJoint( rope_joint );
       rope_joint = null;
       box2d.world.destroyJoint( dist_joint );
       dist_joint = null;
     }
     red = min( 255, red );
    }
    if ( null != rope_joint ) {
      green = round( min( 255, rope_joint.getReactionTorque( 1 / dt ) ) );
    }
    if ( null != dist_joint ) {
      dist_joint.getReactionForce( 1 / dt, force );
      blue = round( min( 255, force.length() ) );
    }



    rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(red,green,blue);
    stroke(0);
    rect(0,0,w,h);
    popMatrix();
    
    if ( null == previous ) {
      ellipse( pos.x, pos.y, 10, 10 );
      return;
    }
    
    Vec2 previous_pos = box2d.getBodyPixelCoord(previous.body);
    if ( null != rope_joint )
      line( pos.x, pos.y, previous_pos.x, previous_pos.y );
    if ( null == next ) {
      ellipse( pos.x, pos.y, 10, 10 );
    }
  }

}