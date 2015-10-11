
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

int w = 50;

float dx = 5;
float dt = 0.05;
float square_size = w * dx;
float gravity = 10;
float friction = 0.992;

float[][] water_heights = new float[w][w];
float[][] m_values_i = new float[w][w];
float[][] m_values_j = new float[w][w];
float[][] m_star_values_i = new float[w][w];
float[][] m_star_values_j = new float[w][w];

boolean anime_start = false;

void setup()
{
  size(800, 600, P3D);
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  for(int i = 0; i < w; i++)
  {
    for(int j = 0; j < w; j++)
    {
      water_heights[i][j] = 2*i + 2*j - w;
      m_values_i[i][j] = 0;
      m_star_values_i[i][j] = 0;
      m_values_j[i][j] = 0;
      m_star_values_j[i][j] = 0;
    }
  }
  lights();
}

void draw(){
  background(0);
  lights();
  smooth();
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  translate(tx, ty);
  rotateX(rotx);
  rotateY(roty);
  scale(s);
  stroke(255);
  //for(int i = 0; i < w; i++)
  //{
  //  for(int j = 0; j < w; j++)
  //  {
  //    point(-square_size/2.0 + dx*i, -water_heights[i][j], -square_size/2.0 + dx*j);
  //  }
  //}
  noFill();
  for(int i = 0; i < w-1; i++)
  {
    for(int j = 0; j < w-1; j++)
    {
      beginShape(QUADS);
      vertex(-square_size/2.0 + dx*i, -water_heights[i][j], -square_size/2.0 + dx*j);
      vertex(-square_size/2.0 + dx*(i+1), -water_heights[i+1][j], -square_size/2.0 + dx*j);
      vertex(-square_size/2.0 + dx*(i+1), -water_heights[i+1][j+1], -square_size/2.0 + dx*(j+1));
      vertex(-square_size/2.0 + dx*i, -water_heights[i][j+1], -square_size/2.0 + dx*(j+1));
      endShape(); 
    }
  }
  if (keyPressed)
  {
    if (key == 's' || key == 'S')
    {
      anime_start = !anime_start;
    }
    if (key == 'd' || key == 'D')
    {
      drop_water();
    }
  }
  if (anime_start)
  {
    update_height();
  }
  println(frameRate*frameRate*dt);
}

void update_height()
{
  for(int i = 1; i < w-1; i++)
  {
    for(int j = 1; j < w-1; j++)
    {
      m_values_i[i][j] = m_values_i[i][j] -  (1/2.0)*(dt/dx)*gravity*(water_heights[i][j]+200)*(water_heights[i][j+1]-water_heights[i][j-1]);
      m_values_j[i][j] = m_values_j[i][j] -  (1/2.0)*(dt/dx)*gravity*(water_heights[i][j]+200)*(water_heights[i+1][j]-water_heights[i-1][j]);
    }
  }
  
  for(int i = 1; i < w-1; i++)
  {
    for(int j = 1; j < w-1; j++)
    {
      //water_heights[i][j] = friction*(water_heights[i][j] -((dt/dx)/4)*(m_values_j[i+1][j] - m_values_j[i-1][j]));
      water_heights[i][j] = friction*(water_heights[i][j] - ((dt/dx)/4)*(m_values_i[i][j+1] - m_values_i[i][j-1])-((dt/dx)/4)*(m_values_j[i+1][j] - m_values_j[i-1][j]));
    }
    water_heights[i][0] = water_heights[i][1];
    water_heights[i][w-1] = water_heights[i][w-2];
    water_heights[0][i] = water_heights[1][i];
    water_heights[w-1][i] = water_heights[w-2][i];
  }
  water_heights[0][0] = water_heights[1][1];
  water_heights[w-1][w-1] = water_heights[w-2][w-2];
  water_heights[0][w-1] = water_heights[1][w-2];
  water_heights[w-1][0] = water_heights[w-2][1];
}

void drop_water()
{
  water_heights[w/2][w/2] = 40;
  water_heights[w/2-1][w/2] = 35;
  water_heights[w/2][w/2-1] = 35;
  water_heights[w/2+1][w/2] = 35;
  water_heights[w/2][w/2+1] = 35;
  water_heights[w/2-1][w/2-1] = 30;
  water_heights[w/2][w/2-2] = 30;
  water_heights[w/2+2][w/2] = 30;
  water_heights[w/2+1][w/2+1] = 30;
  water_heights[w/2-2][w/2] = 30;
  water_heights[w/2][w/2+2] = 30;
}

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