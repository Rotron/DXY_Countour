class ChainSegment {
  
  float len;
  float k = 0.1;
  float w = 20;
  float h = 5;
  
  float slack = 50;
  ChainSegment previous;
  ChainSegment next;
  
  Body body;
  BodyDef bd;
  FixtureDef fd;
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
    
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density=100;
    fd.friction=0.5;
    fd.restitution=0.2;
    
    body.createFixture(fd);

    // Create the shape on the body
    //body.createShape( sd );
    //body.setMassFromShapes();
  }
  
  void createRopeJoint() {
    if ( null == previous ) {
      return;
    }
    // Create the joint definition
    RopeJointDef jd = new RopeJointDef();
    jd.maxLength = box2d.scalarPixelsToWorld( slack );
    // Vec2 b2Vec2_zero = new Vec2();
    // jd.localAnchorA = b2Vec2_zero;
    // jd.localAnchorB = b2Vec2_zero;
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
    
    // Vec2 pos = box2d.getBodyPixelCoord(body);
    // Vec2 previous_pos = box2d.getBodyPixelCoord(previous.body);
    // b2DistanceJointDef distJDef;
    // distJDef.Initialize(previous, body, anchor1, anchor2);
    // distJDef.collideConnected = false;
    // distJDef.dampingRatio = dampingRatio;
    // distJDef.frequencyHz = frequencyHz;
    // world->CreateJoint(&distJDef);

    // Create the joint definition
    DistanceJointDef jd = new DistanceJointDef();
    jd.length = box2d.scalarPixelsToWorld( slack );
    jd.collideConnected = false;
    jd.frequencyHz = 0;
    jd.dampingRatio = 0;

    // Connect the bodies
    jd.bodyA = previous.body;
    jd.bodyB = body;

    // Create the joint
    dist_joint = (DistanceJoint) box2d.world.createJoint(jd);
  }


  void draw() {
    
    
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    rect(0,0,w,h);
    popMatrix();
    
    if ( null == previous ) {
      ellipse( pos.x, pos.y, 10, 10 );
      return;
    }
    
    Vec2 previous_pos = box2d.getBodyPixelCoord(previous.body);
    
    line( pos.x, pos.y, previous_pos.x, previous_pos.y );
    if ( null == next ) {
      ellipse( pos.x, pos.y, 10, 10 );
    }
  }

}