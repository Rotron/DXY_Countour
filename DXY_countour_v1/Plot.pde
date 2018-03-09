

public class Plot {
  public boolean enabled = false;
  public int x = 200;
  public int y = 200;
  public float scale = 20;
  public Plotter plotter;
  
  /**
   * Init
   * Connect to the plotter and enable plotting
   */
  public void init( PApplet app, int port ) {
    String portName = Serial.list()[port]; //make sure you pick the right one
    this.plotter = new Plotter(portName, app, 2);
    this.enabled = true;
  }
  
  /**
   * Line
   * Draw a line using the plotter
   */
  public void line( PVector point, PVector point2 ) {
    plotter.drawTo( 
      point.x * this.scale + this.x,
      point.y * this.scale + this.y
    );
    delay(20);
    plotter.drawTo(
      point2.x * this.scale + this.x,
      point2.y * this.scale + this.y
    );
    delay( 20 );
  }
  
  public void moveTo( PVector point ) {
    plotter.moveTo( 
      point.x * this.scale + this.x,
      point.y * this.scale + this.y
    );
  }
  
  public void pd() {
    plotter.write("PD;");
  }
  
  public void pu() {
    plotter.write("PU;");
  }
}