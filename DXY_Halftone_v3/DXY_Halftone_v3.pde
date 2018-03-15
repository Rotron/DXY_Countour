
import sjunnesson.HPGL_plotter.*;
import processing.serial.*;

Plot plot;
PImage img;
ArrayList<PVector> points;
void setup() {
  size(880,542);
  background(255);
  noFill();  
  plot = new Plot();
  
  
  img = loadImage( "cat.jpg" );
  
  //HalftonePoint htp = new HalftonePoint( 300, 200, 50 );
  //htp.draw();
  
  img.resize(0, height);
  background( 0 );
  points = new ArrayList();
}


int step = 0;
void draw() {
  if ( step == 0 ) {
    image( img, 0, 0 );
  } else if ( step == 1 ) {
    background( 255 );
    strokeWeight( 0 );
    fill( 0 );
  } else if ( step < 1000 ) {
    carpetBomb( img );
  } else if ( step == 1001 ) {
    background( 255 );
    image( img, 0, 0 );
  } else if ( step == 1002 ) {
    strokeWeight( 2 );
    hlps();
  }
  if ( step < 10000 ) {
    step++;
  }
}
float mult = 2;
void carpetBomb( PImage img ) {
  //ArrayList<PVector> points = new ArrayList();
  PVector p;
  for ( int i = 0; i < 50; i++ ) {
    p = new PVector(
      random( 0, width ),
      random( 0, height ),
      random( 2,8 )
    );
    if ( validatePoint( p ) ) {
      ellipse( p.x, p.y, p.z*1.5, p.z*1.5 );
      points.add( p );
    }
  }
  
  mult /= 1.1;
}

boolean validatePoint( PVector p ) {
  loadPixels();
  int r = round( p.z + 1 );
  for ( int _y = -r; _y < r; _y ++ ) {
    int y = _y + round( p.y );
    if ( y < 0 || y >= height ) {
      continue;
    }
    for ( int _x = -r; _x < r; _x ++ ) {
      int x = _x + round( p.x );
      if ( x < 0 || x >= width ) {
        continue;
      }
      int loc = y * width + x;
      if ( brightness( pixels[loc] ) < 150 ) {
        return false;
      }
    }
  }
  return true;
}
void hlps() {
  ArrayList<HalftonePoint> hlps = new ArrayList();
  for ( PVector p : points ) {
      hlps.add( prepareHLP( p, p.z ) );
  }
  background( 255 );
  for ( HalftonePoint hlp : hlps ) {
    if ( hlp == null ) {
      continue;
    }
    hlp.draw();
  }
}

HalftonePoint prepareHLP( PVector p, float radius ) {
  HalftonePoint htp = new HalftonePoint( p.x, p.y, radius );
  img.loadPixels();
  int r = round( p.z + 1 );
  int count = 0;
  int bright = 0;
  
  for ( int _y = -r; _y < r; _y ++ ) {
    int y = _y + round( p.y );
    if ( y < 0 || y >= img.height ) {
      continue;
    }
    for ( int _x = -r; _x < r; _x ++ ) {
      int x = _x + round( p.x );
      if ( x < 0 || x >= img.width ) {
        continue;
      }
      int loc = y * img.width + x;
      bright += brightness( img.pixels[loc] );
      count++;
    }
  }
  float sum = 255;
  
  if ( count > 0 ) {
    sum = bright / count;
  }
  if ( sum > 200 ) {
    return null;
  }
  println( sum );
  htp.fill_spacing = map( sum, 0, 255, 0.1, 30 );
  return htp;
}