SPH sph;
Particle_system particle_system;

float gravity = 0.03;
float damping = 0.99;
float maxSpeed = 5;
float t = 0.01;
float r = 0.001;
float cw = 10;
float delta = 0.5;

boolean p_on = false;
boolean draw_points = false;

void setup()
{
  size(600, 600);
  background(0);
  sph = new SPH(0, height-200, width-100, 100, 10);
  stroke(0, 0, 255);
  particle_system = new Particle_system(450, 350);
  strokeWeight(3);
}


void draw()
{
  background(255);
  sph.update();
  fill(102, 204, 255);
  stroke(102, 204, 255);
  for (int i = 0; i < sph.size; i ++)
  {
    if(draw_points)
    {
      point(sph.particles.get(i).x, sph.particles.get(i).y);
    }
    else
    {
      ellipse(sph.particles.get(i).x, sph.particles.get(i).y, 20, 20);
    }
  }
  if(!draw_points)
  {
    fill(255);
    stroke(255);
    pushMatrix();
    translate(50, height-200);
    rect(0,0,60,-height);
    rect(0,20,width,-30);
    rect(width-150 -10,0,60,-height);
    popMatrix();
  }
  surface.setTitle("SPH 2D FPS: " + (int)frameRate);
  if (p_on && random(1) > 0.8)
  {
    sph.size++;
    sph.particles.add(particle_system.getParticle());
  }
  
}

void keyPressed()
{
  if (key == 'p')
  {
    draw_points = !draw_points;
  }
  if (key == 's')
  {
    p_on = !p_on;
  }
}

class Particle
{
  float x = 0, y = 0, vx = 0, vy = 0, ax = 0, ay = 0, nextX = 0, nextY = 0;
  int cx = 0, cy = 0;
  Particle(float xx, float yy, float vxx, float vyy)
  {
    x = xx;
    y = yy;
    vx = vxx;
    vy = vyy;
  }  
}

class SPH
{
  int size = 0;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float up, right, left, down, gap;

  float d0 = 12;
  float w0 = 30;
  float d1 = 10;
  float d2 = 15;

  SPH(float nup, float ndown, float nright, float nleft, float ngap)
  {
    up = nup;
    right = nright;
    down = ndown;
    left = nleft;
    gap = ngap;
  }

  void particle_update(Particle p)
  {
    p.x = ((p.x + p.vx) + p.nextX) / 2;
    p.y = ((p.y + p.vy) + p.nextY) / 2;
    p.vx += p.ax;
    p.vy += p.ay;
    p.vy += gravity;
    p.ax *= 0.9;
    p.ay *= 0.9;
    p.nextX = p.x + p.vx;
    p.nextY = p.y + p.vy;

    if (p.vx > maxSpeed) {
      p.vx = maxSpeed;
    }
    if (p.vx < -maxSpeed) {
      p.vx = -maxSpeed;
    }
    if (p.vy > maxSpeed) {
      p.vy = maxSpeed;
    }
    if (p.vy < -maxSpeed) {
      p.vy = -maxSpeed;
    }
    p.cx = (int) (p.x / cw);
    p.cy = (int) (p.y / cw);
    
    if (p.y > down - gap)
    {
      p.y = down - gap;
      p.vy = -0.5 * p.vy;
    }
    if (p.x > right - gap)
    {
      p.x = right - gap;
      p.vx = -0.5*p.vx;
    }
    if (p.y < up + gap)
    {
      p.y = up + gap;
      p.vy = -0.5*p.vy;
    }
    if (p.x < left + gap)
    {
      p.x = left + gap;
      p.vx = -0.5*p.vx;
    }
  }
  
  
  void update()
  {
    for (int i = 0; i < size; i ++)
    {
      Particle p1 = particles.get(i);
      particle_update(p1);
      for (int j = i + 1; j < size; j ++)
      {
        Particle p2 = particles.get(j);
        
        
        float dist = dist(p1.x, p1.y, p2.x, p2.y);
        if (dist < d0)
        {
          p1.vx = (p1.vx*(dist * 0.1) * w0 + p2.vx)/ ((dist * 0.1) * w0+1);
          p1.vy = (p1.vy*(dist * 0.1) * w0 + p2.vy)/ ((dist * 0.1) * w0+1);
        }
        
        
        if (abs(p1.cx - p2.cx) < 2 && abs(p1.cy - p2.cy) < 2)
        {
          float dx = p1.x - p2.x;
          float dy = p1.y - p2.y;
          float temp = 2;
          float dr;
          if (dist > d1 && dist < d1 * 4) 
          {
            dr = (d1 + dist) / 2;
          }
          else 
          {
            dr = d1;
          }
          
          
          if (dist < d2)
          {
            float angle = atan2(dy, dx);
            float ax = cos(angle) * (dr - dist) * t;
            float ay = sin(angle) * (dr - dist) * t;
            ax = min(temp, ax);
            ax = max(ax, -temp);
            ay = min(temp, ay);
            ay = max(ay, -temp);
    
            p1.vx += ax;
            p1.vy += ay;
            p2.vx -= ax;
            p2.vy -= ay;
          }
          
          
          if (dist < d1)
          {
            float angle = atan2(dy, dx);
            float ax = cos(angle) * pow(dr - dist,3) * r;
            float ay = sin(angle) * pow(dr - dist,3) * r;
            p1.vx += ax;
            p1.vy += ay;
            p2.vx -= ax;
            p2.vy -= ay;
            ax = min(temp, ax);
            ax = max(ax, -temp);
            ay = min(temp, ay);
            ay = max(ay, -temp);
          }
        }
      }
    }
    for(Particle p : particles)
    {
      p.vx *= damping;
      p.vy *= damping;
      float possi = random(1);
      if(possi > 0.8)
      {
        p.x -= delta;
      }
      else if (possi > 0.6)
      {
        p.x += delta;
      }
      else if (possi > 0.4)
      {
        p.y -= delta;
      }
      else if (possi > 0.2)
      {
        p.y += delta;
      }
      
    }
  }
}

class Particle_system
{
  float x;
  float y;
  float dir;
  float fan_r;
  
  Particle_system(float xx, float yy)
  {
    x = xx;
    y = yy;
  }
  
  Particle getParticle()
  {
    Particle p = new Particle(x,y, 0, 0);
    return p;
  }
}