
/**
 * Perlin Noise Field
 */
public class PNField {
  public PVector pos;
  public int width = 0;
  public int height = 0;
  public float scale = 0.5;

  PNField( PVector pos ) {
    this.pos = pos;
  }

  PNField( float x, float y ) {
    pos = new PVector( x, y );
  }
  PNField( float x, float y, float z ) {
    pos = new PVector( x, y, z );
  }

  PNField( float x, float y, float x2, float y2 ) {
    pos = new PVector( x, y );
  }
  
  /**
   * Get 2D
   */
  public float get2d( float x, float y ) {
    return noise(
      scale * pos.x + scale * x,
      scale * pos.y + scale * y
    );
  }
  
  /**
   * Get 3D
   */
  public float get3d( float x, float y, float z ) {
    return noise(
      scale * pos.x + scale * x,
      scale * pos.y + scale * y,
      scale * pos.z + scale * z
    );
  }
}