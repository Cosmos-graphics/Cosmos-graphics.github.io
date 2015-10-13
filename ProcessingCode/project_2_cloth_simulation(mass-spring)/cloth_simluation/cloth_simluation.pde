/**
 * Authors: Zixiao Wang, Wenhan Zhu
 * Date: 10/10/2015
 * Topic: Cloth simulation(mass-spring)
 *
 *
 * key: 
 *    'q' -> add ball y negative speed
 *    'e' -> add ball y positive speed
 *    'a' -> add ball x negative speed
 *    'd' -> add ball x positive speed
 *    's' -> add ball z negative speed
 *    'w' -> add ball z positive speed
 *
 *    'UP' -> add cloth z negative speed
 *    'DOWN' -> add cloth z positive speed
 *    'LEFT' -> add cloth x negative speed
 *    'RIGHT' -> add cloth x positive speed
 *    '>' -> add cloth y positive speed
 *    '<' -> add cloth y negative speed
 */


// Environment factors
float gravity = 0.01;
float ground = 0.0; // ground is always parallel to ZOX plane, format: y = ground
float ks = 0.05; // Spring constant
float kd = 0.8; // Damping factor
Ball ball;
Environment env = new Environment(0, -200, 0, 1000, 800, 800);
float envX = env.getX();
float envY = env.getY();
float envZ = env.getZ();
float envHalfW = env.getWidth()/2;
float envHalfH = env.getHeight()/2;
float envHalfL = env.getLength()/2;

// camera variables
float cx = 0.0;
float cy = 0.0;
float cz = 1200.0;

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

// keyboard control variables
int value;


//---------------------------------------------------------
// Cloth arguments
int numLengthParticals = 20;  // # of particals in length
int numWidthParticals = 20; // # of particals in width
float startY = -400;
Cloth cloth;
PImage img;

// setup and draw --------------------------------------------------------
void setup() {
  size(800, 800, P3D);
  smooth();
  lights();
  noStroke();
  frameRate(120);
  textureMode(IMAGE);
  
  img = loadImage("pikacpu.gif");
  ball = new Ball(75, -100, 0, 100, -1, -5 , 0);
  cloth = new Cloth(numLengthParticals, numWidthParticals, startY, img);
  
}
 
void draw() {
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
  
  // draw scene
  env.show();
  
  // keyboard press check------------------
  if (keyPressed) {
    
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
    }
      
    // cloth interaction
    if (key == ',')
    {
      int i = numLengthParticals/2;
      int j = numWidthParticals/2;
      PVector v =cloth.getV(0, 0);
      v.y -= 10;
      
      cloth.setV(i, j, v);
    }
    if (key == '.')
    {
      int i = numLengthParticals/2;
      int j = numWidthParticals/2;
      PVector v =cloth.getV(0, 0);
      v.y += 10;
      
      cloth.setV(i, j, v);
    }
    if (keyCode == LEFT)
    {
      int i = numLengthParticals/2;
      int j = numWidthParticals/2;
      PVector v =cloth.getV(0, 0);
      v.x -= 10;
      
      cloth.setV(i, j, v);
    }
    if (keyCode == RIGHT)
    {
      int i = numLengthParticals/2;
      int j = numWidthParticals/2;
      PVector v =cloth.getV(0, 0);
      v.x += 10;
      
      cloth.setV(i, j, v);
    }
    if (keyCode == UP) 
    {
      int i = numLengthParticals/2;
      int j = numWidthParticals/2;
      PVector v =cloth.getV(0, 0);
      v.z -= 10;
      
      cloth.setV(i, j, v);
    }
    if (keyCode == DOWN) 
    {
      int i = numLengthParticals/2;
      int j = numWidthParticals/2;
      PVector v =cloth.getV(0, 0);
      v.z += 10;
      
      cloth.setV(i, j, v);
    }
  }
  //---------------------------------------
  
  // update and draw ball
  ball.move(envX, envY, envZ, envHalfW, envHalfH, envHalfL);
  ball.draw();
  
  // update and draw cloth
  cloth.update(ball, env); //<>//
  cloth.draw();
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