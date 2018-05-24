
// Box 2d tower

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// import controlP5.*;

Box2DProcessing box2d;

// Object to manage MouseJoint
ArrayList<ChainSegment> chain;
ArrayList<Boundary> boundaries;

void setup() {
  size(400,300);
  box2d = new Box2DProcessing(this);
  box2d.createWorld(); 
  chain = new ArrayList();

  boundaries = new ArrayList<Boundary>();
  boundaries.add( new Boundary( 15, height /2, 10, height-20 ) );
  boundaries.add( new Boundary( width - 15, height/2, 10, height-20 ) );
  boundaries.add( new Boundary( width / 2, 15, width-40, 10 ) );
  boundaries.add( new Boundary( width/2, height - 15, width-40, 10 ) );
}
 
void mousePressed() {
  int len = chain.size();
  if ( 0 == len ) {
    chain.add( new ChainSegment( mouseX, mouseY ) );
  } else {
    ChainSegment end = chain.get( len - 1 );
    ChainSegment segment = new ChainSegment( mouseX, mouseY );
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
    ChainSegment spring = chain.get(i);
    spring.draw();
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }
}