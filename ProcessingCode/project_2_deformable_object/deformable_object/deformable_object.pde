Ball ball = new Ball(20.0, 0.0, 0.0,  20.0, 1, -1, 1);
DObject dobj;
Environment env = new Environment(0, -200, 0, 1000, 800, 800);
float gravity = 0.1;
float ks = 0.2; // Spring constant
float kd = 0.8; // Damping factor

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

//----------------------------------------
// deformable object arguments
int numLengthParticles = 10;  // # of particals in length
int numWidthParticles = 10; // # of particals in width
int numHeightParticles = 10;
//----------------------------------------

void setup()
{
  size(800, 600, P3D);
  smooth();
  lights();
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  startTime = millis();
  
  dobj = new DObject(numLengthParticles, numWidthParticles, numHeightParticles, -100.0, 100.0, 100.0, -100.0, -400.0, -200.0);
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
  
  //translate(tx, ty, tz);
  env.show();
  ball.move(envX, envY, envZ, envHalfW, envHalfH, envHalfL);
  ball.draw();
  
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