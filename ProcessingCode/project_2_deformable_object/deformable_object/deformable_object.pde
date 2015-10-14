/**
 * Authors: Zixiao Wang, Wenhan Zhu
 * Date: 10/13/2015
 * Topic: 3D deformable objects
 *
 *
 * key: 
 *    'UP' -> add cloth z negative speed
 *    'DOWN' -> add cloth z positive speed
 *    'LEFT' -> add cloth x negative speed
 *    'RIGHT' -> add cloth x positive speed
 *    '>' -> add cloth y positive speed
 *    '<' -> add cloth y negative speed
 */

Ball ball = new Ball(-200.0, 0.0, -200.0,  80.0, 1, -1, 1);
DObject dobj;
Environment env = new Environment(0, 0, 0, 600, 400, 400);
float gravity = 0.05;
float ks = 0.4; // Spring constant
float kd = 0.4; // Damping factor

float envX = env.getX();
float envY = env.getY();
float envZ = env.getZ();
float envHalfW = env.getWidth()/2;
float envHalfH = env.getHeight()/2;
float envHalfL = env.getLength()/2;

// camera variables
float cx = 0.0;
float cy = 0.0;
float cz = 600.0;

// mouse click variables
float clickedX; 
float clickedY;
float rotx = 0;
float roty = 0;
float tx = 0.0;
float ty = 0.0;
float s = 1.0;
int startTime;
int elapsedTime;

//----------------------------------------
// deformable object arguments
int numLengthParticles = 5;  // # of particals in length
int numWidthParticles = 5; // # of particals in width
int numHeightParticles = 5;
//----------------------------------------

void setup()
{
  size(800, 600, P3D);
  smooth();
  lights();
  frameRate(120);
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  startTime = millis();
  
  dobj = new DObject(numLengthParticles, numWidthParticles, numHeightParticles, -60.0, 60.0, 60.0, -60.0, -180.0, -60.0);
}

void draw(){
  lights();
  background(0);
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  translate(tx, ty);
  rotateX(rotx);
  rotateY(roty);
  scale(s);
  
  elapsedTime = millis() - startTime;
  startTime = millis();
  surface.setTitle("Proj-Title FPS: " + 1000.0/elapsedTime);
  
  // keyboard press check------------------
  if (keyPressed) {
    
    /*
    // ball interaction
    if (key == 'q')
    {
        ball.setVy(ball.getVy() - 0.05);
    }      
    if (key == 'e')
    {
        ball.setVy(ball.getVy() + 0.05);
    }
    if (key == 'a')
    {
        ball.setVx(ball.getVx() - 0.05);
    }
    if (key == 'd')
    {
        ball.setVx(ball.getVx() + 0.05);
    }
    if (key == 's') 
    {
        ball.setVz(ball.getVz() + 0.05);
    }
    if (key == 'w')
    {
        ball.setVz(ball.getVz() - 0.05);
    }*/
      
    // deformable object interaction
    if (key == ',')
    {
      int i = numLengthParticles/2;
      int k = numWidthParticles/2;
      int j = numHeightParticles/2;
      PVector v =dobj.getV(0, 0, 0);
      v.y -= 10;
      dobj.setV(0, 0, 0, v);
      //dobj.setV(i, j, k, v);
      
    }
    if (key == '.')
    {
      int i = numLengthParticles/2;
      int k = numWidthParticles/2;
      int j = numHeightParticles/2;
      PVector v =dobj.getV(0, 0,0);
      v.y += 10;
      
      dobj.setV(0, 0, 0, v);
      //dobj.setV(i, j, k, v);
    }
    if (keyCode == LEFT)
    {
      int i = numLengthParticles/2;
      int k = numWidthParticles/2;
      int j = numHeightParticles/2;
      PVector v =dobj.getV(0, 0,0);
      v.x -= 10;
      
      dobj.setV(0, 0, 0, v);
      //dobj.setV(i, j, k, v);
    }
    if (keyCode == RIGHT)
    {
      int i = numLengthParticles/2;
      int k = numWidthParticles/2;
      int j = numHeightParticles/2;
      PVector v = dobj.getV(0, 0,0);
      v.x += 10;
      
      dobj.setV(0, 0, 0, v);
      //dobj.setV(i, j, k, v);
    }
    if (keyCode == UP) 
    {
      int i = numLengthParticles/2;
      int k = numWidthParticles/2;
      int j = numHeightParticles/2;
      PVector v =dobj.getV(0, 0,0);
      v.z -= 10;
      
      dobj.setV(0, 0, 0, v);
      //dobj.setV(i, j, k, v);
    }
    if (keyCode == DOWN) 
    {
      int i = numLengthParticles/2;
      int k = numWidthParticles/2;
      int j = numHeightParticles/2;
      PVector v =dobj.getV(0, 0,0);
      v.z += 10;
      
      dobj.setV(0, 0, 0, v);
      //dobj.setV(i, j, k, v);
    }
    if (keyCode == ENTER)
    {
      dobj.reset();
    }
  }
  
  //translate(tx, ty, tz);
  env.show();
  //ball.move(envX, envY, envZ, envHalfW, envHalfH, envHalfL);
  //ball.draw();
  
  // draw deformable object
  dobj.update(ball, env); //<>//
  dobj.draw();
  
}

//----- mouse and key board function

void mouseDragged() {
  float rate = 0.01;
  if (mouseButton == LEFT){
    rotx += (pmouseY-mouseY) * rate;
    roty += (mouseX-pmouseX) * rate;
  }
  
  if (mouseButton == RIGHT) {
    tx += mouseX - pmouseX;
    ty -= pmouseY - mouseY;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  if (e < 0.0) {
    s *= 1.2;
  }
  else if (e > 0.0) {
    s *= 0.8;
  }
}