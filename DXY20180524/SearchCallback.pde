

class SearchCallback implements QueryCallback {
	boolean reportFixture( Fixture f ) {
	Body body = f.getBody();
    Vec2 force = ff.getForce( body );
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);


    fill(0,0,255, 20);
    Vec2 p = box2d.getBodyPixelCoord( body );
    ellipse( p.x, p.y, force.x,force.y );

    return true;
	}
}