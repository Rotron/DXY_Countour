import gab.opencv.*;
import sjunnesson.HPGL_plotter.*;
import processing.serial.*;

PImage src, dst;
OpenCV opencv;

ArrayList<Contour> polygons;

ContourMachine machine = new ContourMachine();
Plot plot;

void setup() {
  //size(1200, 800);
  //size(1024,677);
  size(600,418);
  src = loadImage("deer.jpg");
  
  //src.resize(0, round(src.height/2));
  opencv = new OpenCV(this, src);
  
  scale(0.5);
  background(255);
  noFill();
  
  plot = new Plot();
  //plot.init( this, 5 );
  machine = new ContourMachine();
}

float blurry( float x ) {
  if ( x > 1 ) { x+=0; }
  return x / 3.0;
}

boolean first = true;
int len = 10;
int x = 1;
int y = 1;
void draw() {
  if ( x < len ) {
    machine.draw_step( x, len, true );
    x++;
  } else if ( y < len ) {
    if ( y == 1 ) {
      delay(1000);
      background( 255 );
    }
    machine.draw_step( y, len, false );
    y++;
  }
  delay( 10 );
}