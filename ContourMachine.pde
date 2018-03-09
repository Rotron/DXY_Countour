public class ContourMachine {
  public void draw_x_contours( int len ) {
    
    for ( int x = 1; x < len; x++ ) {
      this.draw_step( x, len, false );
    }
  }
  public void draw_step( int x, int len, boolean debug_image ) {
    //strokeWeight( round( (len - x)) );
    // Reload the image
    PImage img = src.copy();
    // Blur the shit out of it
    float blur = blurry( x );
    img.filter( BLUR, blur );
    // add som noice
    img = this.noise_it_up( img, x * 1.0 / ( len - 1 ) );
    opencv.loadImage( img );
    
    println( x * 1.0 / len );
    
    //opencv.erode();
  
    if ( debug_image ) {
      //Debug the image
      image(opencv.getOutput(), 0, 0);
    } else {
      opencv.threshold( 130 );
    }
    
    // Find the contours
    ArrayList<Contour> contours;
    contours = opencv.findContours();
    
    // Change the colour a bit
    stroke(
      255 - ( 100+x*155/(len-1) ),
      0,
      ( 100+x*155/(len-1) )
    );
    
    // Draw the damn things
    this.draw_contours( contours );
  }
  
  /** 
   * Draw the contours
   */
  public void draw_contours( ArrayList<Contour> contours ) {
    // Boring standard stuff...
    for (Contour contour : contours) {
      this.draw_contour( contour );
    }
  }
  
  public void draw_contour( Contour contour ) {
    ArrayList<PVector> points = contour.getPolygonApproximation().getPoints();
    for ( int i = 0; i < points.size() - 1; i++ ) {
      PVector point = points.get( i );
      int next = i + 1;
      if ( next >= points.size() ) {
        next-=points.size();
      }
      PVector point2 = points.get( next );
      line( point.x, point.y, point2.x, point2.y );
      
      
      //public int xMax = 9000;
      //public int yMax = 6402;
      if ( plot.enabled ) {
        plot.line( point, point2 );
      }
    }
  }
  
  public PImage noise_it_up( PImage img, float amount ) {
    
    amount = 0.3 + amount * 0.7;
      noiseDetail(8, 0.6);
    float increment = 0.03;
    img.loadPixels();
    float xoff = 0.0 + amount * 50;
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (int x = 0; x < img.width; x++) {
      xoff += increment;   // Increment xoff 
      float yoff = 0.0;   // For every xoff, start yoff at 0
      for (int y = 0; y < img.height; y++) {
        yoff += increment; // Increment yoff
        
        float org_px = brightness( img.pixels[x+y*width] );
        
        // Calculate noise and scale by 255
        float bright = max( 0, noise(xoff, yoff) * 16 );
        bright = pow( bright, 2 );
        bright = min( 255, org_px + bright * 1.2 );
        
        float result = lerp( org_px, bright, amount );
  
        // Try using this line instead
        //float bright = random(0,255);
        
        // Set each pixel onscreen to a grayscale value
        img.pixels[x+y*width] = color( result );
      }
    }
    
    img.updatePixels();
    return img;
  }
}