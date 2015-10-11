import ddf.minim.*;
int width = 800;
int height = 600;
int dx = 4;
float dt = 0.05;
int vertical_points = width/dx + 1;
float[] water_heights = new float[vertical_points ];
float[] m_values = new float[vertical_points];
float[] m_star_values = new float[vertical_points];
final float E = 2.7182818284590452353602875;
float gravity = 30;
float friction = 0.99;
int anime_on = 0;
Minim minim;
AudioPlayer player;
AudioInput input;

void setup()
{
  size(800,600,P2D);
  for (int i = 0; i < vertical_points; i++)
  {
    water_heights[i] = (height*1.0/2) * 1/(1+ pow(E,-12*(i-vertical_points/2)/(1.0*vertical_points))) - height/4.0;
//    water_heights[i] = 0;
    m_values[i] = 0;
    m_star_values[i] = 0;
  }
  noStroke();
  minim = new Minim(this);
  player = minim.loadFile("water_drop.mp3");
  input = minim.getLineIn();
}

void draw()
{
  background(255);
  fill(0,0,255);
  translate(0, height/2);
  beginShape();
  for (int i = 0; i < vertical_points; i++)
  {
     vertex(i*dx, -water_heights[i]);
  }
  vertex(width, height/2);
  vertex(0,height/2);
  endShape(CLOSE);
  if (anime_on ==1)
  {
    update_height();
  }
  println(frameRate*(frameRate*dt));
  
}

void update_height()
{
  for(int i = 1 ; i < vertical_points - 1; i++)
  {
    m_values[i] = m_values[i] - (1/2.0)*(dt/dx)*gravity*(water_heights[i] + height/2.0)*(water_heights[i+1]-water_heights[i-1]);
  }
  for(int i = 1 ; i < vertical_points - 1; i++)
  {
    m_star_values[i] = m_values[i] - (1/2.0)*(dt/dx)*gravity*(water_heights[i] + height/2.0)*(water_heights[i+1]-water_heights[i-1]);
  }
  for(int i = 1; i < vertical_points -1; i++)
  {
    water_heights[i] = friction*(water_heights[i] - ((dt/dx)/4)*(m_values[i+1] - m_values[i-1]) - ((dt/dx)/4)*(m_star_values[i+1] - m_star_values[i-1]));
  }
  water_heights[0] = water_heights[1];
  water_heights[vertical_points-1] = water_heights[vertical_points-2];
  
}

void mousePressed()
{
  if (anime_on == 0)
  {
    anime_on = 1;
  }
  else
  {
    int index = (int) mouseX/dx;
    println(index);
    int point_height = (height - mouseY) - height/2;
    water_heights[index] = point_height;
    player.close();
    player = minim.loadFile("water_drop.mp3");
    player.play();
  }
}