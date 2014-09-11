class Barre {
  
  // PARAMETRES DE LA BARRE
  float densite = 1;
  float friction = 0;
  float restitution = 1;
  
  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  // But we also have to make a body for box2d to know about it
  Body b;
  Barre(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
 // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(monMonde2d.coordPixelsToWorld(x, y));
    b = monMonde2d.createBody(bd);
    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = monMonde2d.scalarPixelsToWorld(w/2);
    float box2dH = monMonde2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);
  // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = densite;
    fd.friction = friction;
    fd.restitution = restitution;
    // Attached the shape to the body using a Fixture
    b.createFixture(fd);
     b.setUserData(this);
  }
  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    Vec2 pos = monMonde2d.getBodyPixelCoord(b);
    fill(255);
    stroke(232,82,182);
    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rect(0, 0, w, h);
    popMatrix();
  }
}

