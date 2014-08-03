class Ballon {

  Body body;
  color c;
  float xpos;
  float ypos;
  int r = 10;

  Ballon() {
    c=color(80,255,30);
    xpos=width/2;
    ypos=height/4;
    makeBody(r, xpos, ypos);
    body.setUserData(this);
  }

 void display() {
    // We look at each body and get its screen position
    Vec2 pos = monMonde2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(0);
    strokeWeight(2);
    stroke(232,82,182);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(0,0,r,0);
    popMatrix();
  }

  void makeBody(float r, float x, float y ) {

    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    // Set its position
    bd.position = monMonde2d.coordPixelsToWorld(x, y);
    body = monMonde2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = monMonde2d.scalarPixelsToWorld(r);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1;

     

    body.createFixture(fd);
    body.setGravityScale(0);

    body.setLinearVelocity(new Vec2(random(-5, 5), random(-5, -5)));
    body.setAngularVelocity(random(-1, 1));
  }
}

