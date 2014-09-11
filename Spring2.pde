// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// Class to describe the spring joint (displayed as a line)

class Spring2 {

  // This is the box2d object we need to create
  MouseJoint mouseJoint;

  Spring2() {
    // At first it doesn't exist
    mouseJoint = null;
  }

  // If it exists we set its target to the mouse location 
  void update(float x, float y) {
    if (mouseJoint != null) {
      // Always convert to world coordinates!
      Vec2 mouseWorld = monMonde2d.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }

  void display() {
    if (mouseJoint != null) {
      // We can get the two anchor points
      Vec2 v1 = null;
      mouseJoint.getAnchorA(v1);
      Vec2 v2 = null;
      mouseJoint.getAnchorB(v2);
      // Convert them to screen coordinates
      v1 = monMonde2d.coordWorldToPixels(v1);
      v2 = monMonde2d.coordWorldToPixels(v2);
      // And just draw a line
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }


  // This is the key function where
  // we attach the spring to an x,y location
  // and the Box object's location
  void bind(float x, float y, Box box) {
    // Define the joint
    MouseJointDef md = new MouseJointDef();
    
    // Body A is just a fake ground body for simplicity (there isn't anything at the mouse)
    md.bodyA = monMonde2d.getGroundBody();
    // Body 2 is the box's boxy
    md.bodyB = box.body;
    // Get the mouse location in world coordinates
    Vec2 mp = monMonde2d.coordPixelsToWorld(x,y);
    // And that's the target
    md.target.set(mp);
    // Some stuff about how strong and bouncy the spring should be
    md.maxForce = 1000.0f * box.body.m_mass;
    md.frequencyHz = 5.0f;
    md.dampingRatio = 0.000001f;

    // Wake up body!
    //box.body.wakeUp();

    // Make the joint!
    mouseJoint = (MouseJoint) monMonde2d.world.createJoint(md);
  }

  void destroy() {
    // We can get rid of the joint when the mouse is released
    if (mouseJoint != null) {
      monMonde2d.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }

}


