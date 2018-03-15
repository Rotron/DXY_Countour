

public class Plot {
  public boolean enabled = false;
  public int x = 0;
  public int y = 0;
  public float scale = 2;
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
    plotter.line( 
      point.x * this.scale + this.x,
      point.y * this.scale + this.y,
      point2.x * this.scale + this.x,
      point2.y * this.scale + this.y
    );
  }
}