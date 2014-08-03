class Window {

  // A window is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  color col = 0;

  // But we also have to make a body for box2d to know about it
  Body b;

  Window(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = monMonde2d.scalarPixelsToWorld(w/2);
    float box2dH = monMonde2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(monMonde2d.coordPixelsToWorld(x, y));
    b = monMonde2d.createBody(bd);

    // Attached the shape to the body using a Fixture
    b.createFixture(sd, 1);
    b.setUserData(this);
  }

  void change()
  {
     col= 255; 
  }
  
  // Draw the windows, if it were at an angle we'd have to do something fancier
  void display() {
    fill(col);
    stroke(232,82,182);
    rectMode(CENTER);

    float a = b.getAngle();

    pushMatrix();
    translate(x, y);
    rect(0, 0, w, h);
    popMatrix();

}
}

