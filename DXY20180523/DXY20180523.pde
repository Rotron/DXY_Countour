import sjunnesson.HPGL_plotter.*;
import processing.serial.*;

PNField noise_field;

ArrayList<Car> cars;

void setup() {
  size( 720, 480 );
  noise_field = new PNField( 0, 0 );
  noise_field.scale = 0.01;
  cars = new ArrayList();

  int amount = 20;
  for( int y= 0 ; y < amount ; y++ ) {
    for( int x= 0 ; x < amount ; x++ ) {
      Car car = new Car( 
        new PVector( width * x / amount , height * y / amount ),
        noise_field
      );
      cars.add( car );  
    }
  }
  background( 255 );
}

float z = 0;
void draw() {
	noise_field.pos.z += 0.4;
  // Some sort of car that navigates a noise field
  // Attraction to white, Repulsion from black
  // Has a velocity
  //render_noise();
  noStroke();
  fill( 255, 10 );
  rect(0,0,width,height);


  for ( int i = 0 ; i < cars.size() ; i++ ) {
    Car car = cars.get( i );
    car.tick();
    car.draw();
  }

}

void render_noise() {
  loadPixels();
  for( int y = 0; y < height; y++ ) {
    for( int x = 0; x < width; x++ ) {
      int pos = y * width + x;
      float val = noise_field.get3d( x, y, 0 );
      pixels[pos] = color( val * 255 );
    }
  }
  updatePixels();
}