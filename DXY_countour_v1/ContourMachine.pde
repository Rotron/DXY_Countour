public class ContourMachine {
  public void draw_x_contours( int len ) {
    for ( int x = 1; x < len; x++ ) {
      this.draw_step( x, len, false );
    }
  }
  public void draw_step( int x, int len, boolean debug_image ) {
    if ( plot.enabled ) {
      plot.plotter.selectPen( x );
    }
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
    PVector point;
    PVector point2;
    ArrayList<PVector> points = contour.getPolygonApproximation().getPoints();
    if ( plot.enabled ) {
      delay( 250 );
      point = points.get( 0 );
      plot.moveTo( point );
    }
    for ( int i = 0; i < points.size() - 1; i++ ) {
      int next = i + 1;
      if ( next >= points.size() ) {
        next-=points.size();
      }
      // Get the points
      point  = points.get( i );
      point2 = points.get( next );
      // Draw
      line( point.x, point.y, point2.x, point2.y );
      
      //public int xMax = 9000;
      //public int yMax = 6402;
      if ( plot.enabled ) {
        // Plot draw
        plot.line( point, point2 );
      }
    }
    
    if ( plot.enabled ) {
      plot.pu();
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