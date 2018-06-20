class SerialInput {

  Serial serial_port;
  
  boolean changed = false;

  int encoders[] = {0,0,0,0,0,0,0,0};

  SerialInput( PApplet app, int baud ) {
    int last = Serial.list().length - 1;
    String port_name = Serial.list()[last];
    serial_port = new Serial( app, port_name, baud );
  }

  void listen() {
    changed = false;
    if ( serial_port.available() <= 0 ) {
      return;
    }
    // If data is available,
    String val = trim( serial_port.readStringUntil(10) );         // read it and store it in val
    if ( val == null ) {
      return;
    }
    String parts[] = split( val, ":" );
    if ( ! "E".equals( parts[0].substring(0,1) ) ) {
      // Not an encoder, return early
      return;
    }
    int i = int( parts[0].substring(1) );
    if ( i < 0 || i > 7 ) {
      // Out of bounds
      return;
    }
    changed = true;
    encoders[i] = int( trim( parts[1] ) );
  }
}