import java.util.ArrayList;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioInput input;

ArrayList<Spark> sparks = new ArrayList<Spark>();

float gravity = 0.2;
float sparkC = 500;

int startTime;
int elapsedTime;

void setup()
{
  size(800,800, P3D);
  smooth();
  addFireWork(200,200,-500);
  background(0);
  
  minim = new Minim(this);
  player = minim.loadFile("fireworks.mp3");
  input = minim.getLineIn();
  
  
  startTime = millis();
}

void draw()
{
  background(0);
  lights();
  elapsedTime = millis() - startTime; 
  startTime = millis(); 
  surface.setTitle("Proj-Title FPS: " + 1000.0/elapsedTime);
  
  for(Spark spark : sparks)
  {

    if(spark.lifeTime > 0)
    {
          spark.vX += 0;
    spark.vY += gravity;
    spark.vZ += 0;
    
    spark.posX += spark.vX;
    spark.posY += spark.vY;
    spark.posZ += spark.vZ;
    
    spark.lifeTime -= 1/frameRate;
    
      noStroke();
      fill(spark.c, spark.lifeTime * 255);
      
      pushMatrix();
      translate(spark.posX, spark.posY, spark.posZ);
      //sphere(5);
      ellipse(0, 0, 5, 5);
      popMatrix();
    }
  }
  filter(18);
  println(frameRate);
}

void addFireWork(float a, float b, float c)
{
  color col = color(random(50,255), random(50,255), 0);
  for(int i = 0; i < sparkC; i ++)
  {
    
    float x = random(0,50);
    float y = random(0,50);
    float z = random(0,50);
    
    if (x*x + y*y + z*z <= 50*50*50);
    {
      x = random(0,50);
      y = random(0,50);
      z = random(0,50);
    }
    
    sparks.add(new Spark(a+x,b+y,c+z, random(-2,2)*random(0,TWO_PI), random(-2,2)*random(0,TWO_PI), random(-2,2)*random(0,TWO_PI),col));
  }
}

void mousePressed()
{
  player.close();
  addFireWork(mouseX, mouseY, -500);
  player = minim.loadFile("fireworks.mp3");
  player.play();
}


class Spark
{
  float posX;
  float posY;
  float posZ;
  
  float vX;
  float vY;
  float vZ;
  
  color c;
  
  float lifeTime = 2.0;
  
  Spark(float posX, float posY, float posZ, float vX, float vY, float vZ, color c)
  {
    this.posX = posX;
    this.posZ = posZ;
    this.posY = posY;
    
    this.vX = vX;
    this.vY = vY;
    this.vZ = vZ;
    
    this.c = c;
  }
}