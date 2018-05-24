
// Box 2d tower

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.collision.AABB;
import org.jbox2d.callbacks.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// import controlP5.*;

Box2DProcessing box2d;

// Object to manage MouseJoint
ArrayList<ChainSegment> chain;
ArrayList<Boundary> boundaries;
Vec2 gravity = new Vec2( 0, -5 );

AABB area;
ForceField ff;

void setup() {
  size(1200,800);
  box2d = new Box2DProcessing(this);
  box2d.createWorld(); 
  chain = new ArrayList();
  box2d.world.setGravity( gravity );

  boundaries = new ArrayList<Boundary>();
  boundaries.add( new Boundary( 15, height /2, 10, height-20 ) );
  boundaries.add( new Boundary( width - 15, height/2, 10, height-20 ) );
  boundaries.add( new Boundary( width / 2, 15, width-40, 10 ) );
  boundaries.add( new Boundary( width/2, height - 15, width-40, 10 ) );
  Vec2 lower = box2d.coordPixelsToWorld( 10, height-00 );
  Vec2 upper = box2d.coordPixelsToWorld( width-(width/2)-10, 10 );
  area = new AABB( lower, upper );
  ff = new ForceField( width/2, height/2, 100 );
}

void mousePressed() {
  int len = chain.size();
  ChainSegment segment = new ChainSegment( mouseX, mouseY );
  if ( 0 == len ) {
    segment.body.setType( BodyType.STATIC );
    chain.add( segment );
  } else {
    ChainSegment end = chain.get( len - 1 );
    end.next = segment;
    segment.previous = end;
    // Rope aligns the bodies in the correct angle
    segment.createRopeJoint();
    // Distance just keeps the bodies in a certain distance of each other
    //segment.createDistJoint();
    chain.add( segment );
  }
}
 
void draw() {
  
  background(255);
  box2d.step();
  

  for ( int i = 0; i < chain.size(); i++ ) {
    ChainSegment link = chain.get(i);
    link.tick();
    link.draw();
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }
  rectMode( CORNER );
  
  // Debugging
  Vec2 lower = box2d.coordWorldToPixels( area.lowerBound );
  Vec2 upper = box2d.coordWorldToPixels( area.upperBound );
  fill(255,0,0);
  ellipse( lower.x, lower.y, 50, 50 );
  fill(0,255,0);
  ellipse( upper.x, upper.y, 50, 50 );

  strokeWeight( 50 );
  stroke( 255,255,0, 50 );
  noFill();
  println(lower.x +","+ upper.y +","+ (upper.x-lower.x) +","+ (lower.y-upper.y));
  rect( lower.x, upper.y, upper.x-lower.x, lower.y-upper.y );
  noStroke();
  strokeWeight( 1 );
  box2d.world.queryAABB( new SearchCallback(), area );
  ff.display();
}