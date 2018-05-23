import sjunnesson.HPGL_plotter.*;
import processing.serial.*;

PNField noise_field;

ArrayList<Car> cars;

void setup() {
  size( 500, 500 );
  noise_field = new PNField( 0, 0 );
  noise_field.scale = 0.01;
  cars = new ArrayList();

  for( int y= 0 ; y < 10 ; y++ ) {
    for( int x= 0 ; x < 10 ; x++ ) {
      Car car = new Car( 
        new PVector( 50 * x , 50 * y ),
        noise_field
      );
      cars.add( car );  
    }
  }
}

float z = 0;
void draw() {
	noise_field.pos.z += 0.4;
  // Some sort of car that navigates a noise field
  // Attraction to white, Repulsion from black
  // Has a velocity
	loadPixels();
  for( int y = 0; y < height; y++ ) {
	  for( int x = 0; x < width; x++ ) {
	  	int pos = y * width + x;
	  	float val = noise_field.get3d( x, y, 0 );
	  	pixels[pos] = color( val * 255 );
    }
  }
  updatePixels();


  for ( int i = 0 ; i < cars.size() ; i++ ) {
    Car car = cars.get( i );
    car.tick();
    car.draw();
  }

}