import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.contacts.*;
import SimpleOpenNI.*;



// A reference to our box2d world
Box2DProcessing monMonde2d;
//Barre myBarre;
Box myBarre;
Ballon myBallon;
Spring mySpring;
ArrayList<Boundary> myBoundary;
ArrayList<Window> myWindow;

// ON/OFF pour Kinect // Debug
boolean debug = true;

Spring2 spring2;

SimpleOpenNI  context;
color[]       userClr = new color[] { 
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};
PVector com = new PVector();                                   
PVector com2d = new PVector(); 
ArrayList    userVecList = new ArrayList();
int          userVecListSize = 30;
// declaration d'une varibale de chaine de caractere
// pour afficher le type de mouvement de la main
// détecté par la kinect
String       lastGesture = "";

PrismaticJoint m_joint3;


void setup() {
  size(1024, 768);
  smooth();

  if (debug == false)
  {
  
  context = new SimpleOpenNI(this);// initialize SimpleOpenNI object

  //Le Kinect
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }






  // enable depthMap generation 
  context.enableDepth();
  // enable skeleton generation for all joints
  context.enableUser();
  
  }
  
  background(0);
  strokeWeight(3);
  smooth();  

  monMonde2d = new Box2DProcessing(this);
  monMonde2d.createWorld();
  //monMonde2d.setGravity(0,0);

  // Add a listener to listen for collisions!
  monMonde2d.world.setContactListener(new CustomListener());


  myBallon = new Ballon();
  //myBarre = new Barre(width/2, 760, 100, 10);
  myBarre = new Box(width/2, 760);

  mySpring = new Spring();

  mySpring.bind(width/2, 760, myBarre);
  
 // spring2 = new Spring2();
  //spring2.bind(width/2,height/2,myBarre);
  
  //create arraylist of windows
  myWindow = new ArrayList<Window>();
  myWindow.add(new Window(140, 140, 115, 115));
  myWindow.add(new Window(320, 140, 115, 115));
  myWindow.add(new Window(500, 140, 115, 115));
  myWindow.add(new Window(680, 140, 115, 115));
  myWindow.add(new Window(860, 140, 115, 115));
  //Create arrayList of boundaries
  myBoundary = new ArrayList<Boundary>();
  myBoundary.add(new Boundary(width/2, 0, 1024, 10));
  myBoundary.add(new Boundary(width, height/2, 10, height));
  myBoundary.add(new Boundary(0, height/2, 10, height));
  
  PrismaticJointDef pjd = new PrismaticJointDef();
  Boundary myBoundaryTest = new Boundary(0, 760, 5, 5);
  
  pjd.initialize(myBoundaryTest.getBody(), myBarre.getBody(), new Vec2(0.0f, 0.0f), new Vec2(1.0f, 0.0f));
  
  
  m_joint3 = (PrismaticJoint) monMonde2d.createJoint(pjd);


  
}  


void draw() {
  background(0);
  // update the cam
  if (debug == false)
  {
  context.update();
  }
  
  
  monMonde2d.step();
  

  // Display all the boundaries
  for (Boundary wall: myBoundary) {
    wall.display();
  }
  for (Window wall: myWindow) {
    wall.display();
  }






  if (debug == false)
  {
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  //image(context.userImage(),0,0);

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  // for (int i=0;i<userList.length;i++)
  println(userList.length);
  if (userList.length>0)
  {
     int i=0;
    
      if (context.isTrackingSkeleton(userList[i]))
      {
        stroke(userClr[ (userList[i] - 1) % userClr.length ] );
        drawSkeleton(userList[i]);
      }      


      // draw the center of mass
      if (context.getCoM(userList[i], com))
      {
        context.convertRealWorldToProjective(com, com2d);
        stroke(100, 255, 0);
        strokeWeight(1);
        beginShape(LINES);
        vertex(com2d.x, com2d.y - 5);
        vertex(com2d.x, com2d.y + 5);

        vertex(com2d.x - 5, com2d.y);
        vertex(com2d.x + 5, com2d.y);
        endShape();

        fill(0, 255, 100);
        text(Integer.toString(userList[i]), com2d.x, com2d.y);
      }
    }
  }
  
  if (debug == false)
  {
    mySpring.update((int)com2d.x, 760);
  } else 
  {
    mySpring.update((int)mouseX, 760);
    //mySpring.display();
  }
  
 
  
  myBarre.display();
  myBallon.display();
  
}





// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data

  /*PVector jointPos = new PVector();
   context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
   println(jointPos);
   */

  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT); 


}


// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{

  //int[] userList = curContext.getUsers();
  //if (userList.length<1)
 //{ 
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  curContext.startTrackingSkeleton(userId);
  //}
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}

