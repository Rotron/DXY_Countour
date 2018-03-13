
import sjunnesson.HPGL_plotter.*;
import processing.serial.*;

Plot plot;

void setup() {
  size(600,400);
  background(255);
  noFill();  
  plot = new Plot();
  
  HalftonePoint htp = new HalftonePoint( 300, 200, 50 );
  htp.draw();
  
  int len = 10;
  for ( int i = 0; i < len; i++ ) {
    int x = round( 300 + sin( i * 2 * PI / len ) * 150 );
    int y = round( 200 + cos( i * 2 * PI / len ) * 150 );
    htp = new HalftonePoint( x, y, random(20,50) );
    htp.angle = i * 360 / len + 0.01;
    htp.draw();
  }
}