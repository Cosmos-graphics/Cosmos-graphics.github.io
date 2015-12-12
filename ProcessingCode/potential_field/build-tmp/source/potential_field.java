import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class potential_field extends PApplet {



PeasyCam cam;

final float REP_STR = 40;
final float GOAL_FORCE = 0.2f;
final float SEEK_DISTANCE = 150;
final float GEN_RATE = 0.97f;
final float ALIGN_STR = 2;

ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Agent> agents2 = new ArrayList<Agent>();
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Agent> enemies = new ArrayList<Agent>();
ArrayList<Missile> missiles = new ArrayList<Missile>();

PVector goal = new PVector(1200, -1200, 0);

boolean movement = true;
int render_case = 0;
int render_case_lim = 2;
boolean draw_pf = false;

/* Render cases:
 * 0: agent
 * 1: circle
 */

PotentialField pf = new PotentialField(3000, 3000, goal);

Agent a;

public void setup(){
  
  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(3000);
  
  for (int i = 0; i < 15; i++)
  {
    agents.add(new Agent(new PVector(random(-1400, 1400),random(-1400, 1400),0), 5, 10));
  }
  //for (int i = 0; i < 15; i ++)
  //{
    //obstacles.add(new Obstacle((int)random(-24,24), (int)random(-24,24), (int)random(1, 5)));
  //}
  //add_moutains();
  enemies.add(new Agent(new PVector(200, 200, 0), 0, 10));
  enemies.get(enemies.size()-1).col = color(140,0,0,240);
  enemies.get(enemies.size()-1).scol = color(195,0,0);

}

public void add_moutains() {
  for (int i = 3; i < 15 ; i ++) {
      for (int j = 0; j < 15-i+5; j ++) {
        obstacles.add(new Obstacle( i, j,(int)random(1,5)));
        obstacles.add(new Obstacle(-i, -j, (int)random(1,5)));
      }
  }
}

public void add_random_obs() {
  obstacles.add(new Obstacle((int)random(-20, 20), (int)random(-20, 20), (int)random(1,5) ));
}

public void draw(){
  if(random(1) > GEN_RATE) {
    agents.add(new Agent(new PVector(random(-1300,-500), random(500,1300), 0), 5, 10));
    agents2.add(new Agent(new PVector(random(-1300,-500), random(500, 1300), 300), 5, 10));
  }
  if(random(1) > 0.99f) {
    enemies.add(new Agent(new PVector(random(600, 1200), -600 - 600*random(1), 0), 0, 0));
    enemies.get(enemies.size()-1).col = color(140,0,0,240);
    enemies.get(enemies.size()-1).scol = color(195,0,0);
  }

  pf.update(enemies, obstacles);
  background(0);
  for (Agent a : agents) {
    a.update_status(enemies);
    a.update(pf);
    a.render(render_case);
  }
  for (Agent a : agents2) {
    a.update(pf);
    a.render(render_case);
  }
  for (Obstacle o : obstacles) {
    o.render();
  }
  for (Agent e : enemies) {
    e.update_status(agents);
    e.update(pf);
    e.render(render_case);
  }
  for (Missile m : missiles) {
    m.update();
    m.render();  
  }
  terrain();
  
  int gx = (int) getPFP(goal).x;
  int gy = (int) getPFP(goal).y;

  for (int i = 0; i < agents.size(); i++) {
    if (manhattan_distance(gx, gy, (int)getPFP(agents.get(i).pos).x, (int)getPFP(agents.get(i).pos).y) < 4) {
      agents.remove(i);
      i--;
    }
  }

  for (int i = 0; i < agents2.size(); i++) {
    if (manhattan_distance(gx, gy, (int)getPFP(agents2.get(i).pos).x, (int)getPFP(agents2.get(i).pos).y) < 4) {
      agents2.remove(i);
      i--;
    }
  }


  for (int i = 0; i < missiles.size(); i ++) {
    if (PVector.sub(missiles.get(i).target, missiles.get(i).pos).mag() < 50 )
    {
      for (Agent e : enemies) {
        if (PVector.sub(e.pos, missiles.get(i).target).mag() < 5) {
          e.hit();
        }
      }
      missiles.remove(i);
      i--;
    }
  }

  for (int i = 0; i < enemies.size(); i ++) {
    if (enemies.get(i).hp < 0) {
      enemies.remove(i);
      i --;
    }
  }
}

public void terrain() {
  noStroke();
  fill(0, 180, 120);
  //rect(-1500, -1500, 3000, 3000);
  for(int i = 0; i < pf.w; i ++) {
    for(int j = 0; j < pf.h; j ++) {
      if (draw_pf) {
        fill(0, pf.field[i][j], 0);
      }
      else {
        fill(0, 120, 0);
      }
      //fill(0, 255, 0);
      rect(60*(i - 25), 60*(j-25), 60, 60);
    }
  }
  
}

class Obstacle {
  int x;
  int y;
  int h;

  Obstacle(int x, int y, int h) {
    this.x = x;
    this.y = y;
    this.h = h;
  }

  public void render() {
    pushMatrix();
    fill(180,0,0,230);
    stroke(230,0,0);
    translate(60*x + 30, 60*y + 30, 30);
    for(int i = 0; i<h; i++) {
      box(60);
      translate(0,0,65);
    }
    popMatrix();
  }

}

class Agent {
  PVector pos; // Position of the Agent
  PVector vel; // Velocity of the Agent
  float r; // Radius of the Agent
  float max_speed; // maximum movement speed

  int col = color(0,0,140,240);
  int scol = color(0,0,195);

  float period = random(1.2f, 2.4f); // in seconds
  float dur = 0; // fraction of the peroid (0 ~ 1)
  FirePS f = new FirePS(new PVector(0, 0, 0));
  float apti = random(4, 7);
  boolean attacking = false;
  float atk_dur = 0;
  float atk_period = 0.7f;
  PVector target = new PVector();
  float hp = 100;
  float hei;

  public void hit() {
    hp -= 20;
  }

  Agent(PVector pos, float max_speed, float r) {
    this.pos = pos;
    this.max_speed = max_speed;
    this.r = r;
    this.vel = new PVector();
    hei = pos.z;

    //vel.add(1, 0, 0);
  }

  public void render(int type) {
    switch (type) {
      case 0:
        render_agent();
        break;
      case 1:
        render_circle();
    }
  }

  public ArrayList<Agent> get_neighbors(ArrayList<Agent> agents) {
    ArrayList<Agent> n = new ArrayList<Agent>();
    for(Agent a : agents)
    {
      if (PVector.sub(a.pos, pos).mag() <= SEEK_DISTANCE && PVector.sub(a.pos, pos).mag() != 0){
        n.add(a);
      }
    }
    return n;
  }

  public void render_circle() {
    stroke(scol);
    fill(col);
    pushMatrix();
    translate(pos.x, pos.y, 2);
    ellipse(0, 0, 50, 50);
    popMatrix();
  }

  public void render_agent() {
    stroke(scol);
    fill(col);
    pushMatrix();
    translate(pos.x, pos.y, pos.z + 30);
    float rz = atan2(vel.y, vel.x);
    rotateZ(rz);
    rotateY(PI/24*vel.mag()/(max_speed + 1));
    box(60);
    pushMatrix();
    translate(35, 0, 5);
    box(10);
    popMatrix();
    pushMatrix();
    translate(-45, 15, 10);
    rotateY(PI/24*vel.mag()/(max_speed+1));
    box(15);
    f.render();
    popMatrix();
    pushMatrix();
    translate(-45, -15, 10);
    rotateY(PI/24*vel.mag()/(max_speed + 1));
    box(15);
    f.render();
    popMatrix();
    popMatrix();
  }

  public void update_status(ArrayList<Agent> enemies) {
    vel = new PVector();
    for (Agent e : enemies) {
      if (PVector.sub(e.pos, pos).mag() < 300)
      {
        attacking = true;
        target = e.pos;
        return;
      }
    }
    attacking = false;
  }

  public PVector getAveVel(ArrayList<Agent> n) {
    float sumX = 0;
    float sumY = 0;
    float sumZ = 0;
    for (Agent a : n) {
      sumX += a.vel.x;
      sumY += a.vel.y;
      sumZ += a.vel.z;
    }
    return new PVector(sumX/(float)n.size(), sumY/(float)n.size(), sumZ/(float)n.size());
  }


  public void align(ArrayList<Agent> n) {
    if (n.size() == 0) {
      return;
    }
    PVector avel = getAveVel(n);
    PVector pvel = PVector.sub(avel, vel);
    pvel.div(n.size());
    vel.add(pvel.div(ALIGN_STR));
  }

  public void update(PotentialField pf)
  {
    animation();
    f.update();
    if (movement && !attacking) {
      ArrayList<Agent> n = get_neighbors(agents);
      updateVel(pf);
      repel(n);
      align(n);
      //vel.add(PVector.sub(goal, pos).normalize().mult(GOAL_FORCE));
      if (vel.mag() > max_speed) {
        vel.normalize().mult(max_speed);
      }
      else {
        vel.mult(1.02f);
      }
      if (max_speed != 0) {
        pos.add(vel);
      }
    }
    if (attacking) {
      attack();
    }
  }

  public void attack() {
    vel = PVector.sub(target, pos).normalize().mult(0.0005f);
    atk_dur += 1.0f/frameRate;
    if (atk_dur > atk_period) {
      atk_dur = 0f;
      missiles.add(new Missile(pos, target));
    }
  }

  public void repel(ArrayList<Agent> agents) {
    for(Agent a : agents) {
      PVector dis = PVector.sub(pos, a.pos);
      float mag = dis.mag();
      if (mag == 0) {
        continue;
      }
      mag = REP_STR/mag;
      dis.normalize();
      dis.mult(mag);
      vel.add(dis);
    }
  }

  public void updateVel(PotentialField pf) {
    PVector block = getPFP(pos);
    int w = (int) block.x;
    int h = (int) block.y;
    vel.add(pf.getVel(w, h).mult(2));
  }

  public void animation() {
    dur += 1.0f/frameRate;
    if (dur > period) {
      dur = 0f;
    }
    float h = apti * sin(2*PI*dur/period);
    pos.z = hei + 10 + h;

  }
}

class Missile {
  PVector pos = new PVector();
  PVector target = new PVector();
  float speed = 1000;

  Missile(PVector pos, PVector target) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.pos.z = 5;
    this.target.x = target.x;
    this.target.y = target.y;
    this.target.z = target.z;
  }

  public void update()
  {
    pos.add(PVector.sub(target, pos).normalize().mult(speed/frameRate));
  }

  public void render()
  {
    stroke(255);
    fill(0, 0, 0, 240);
    pushMatrix();
    translate(pos.x, pos.y, 2);
    ellipse(0, 0, 25, 25);
    popMatrix();

  }
}


class FirePS {
  float[] xpos = new float[25];
  float[] ypos = new float[25];
  float[] zpos = new float[25];

  PVector pos;

  FirePS(PVector pos)
  {
    this.pos = pos;
    for (int i = 0; i < 25; i++) {
      xpos[i] = pos.x + random(-5,5);
      ypos[i] = pos.y + random(-5,5);
      zpos[i] = pos.z + random(-10,-7);
    }
  }

  public void update() {
    for (int i = 0; i < 24; i++) {
      xpos[i] = xpos[i+1];
      ypos[i] = ypos[i+1];
      zpos[i] = zpos[i+1] - random(2);
    }
    xpos[24] = pos.x + random(-5,5);
    ypos[24] = pos.y + random(-5,5);
    zpos[24] = pos.z + random(-10,-7);
  }

  public void render() {
    for (int i = 0; i< 25; i++) {
      pushMatrix();
      translate(xpos[i], ypos[i], zpos[i]);
      rect(-i/3,-i/3, 2*i/3, 2*i/3);
      popMatrix();
    }
  }

}

public int manhattan_distance(int a, int b, int c, int d) {
  return abs(a-c) + abs(b-d);
}

public float penemies(Agent e, int i, int j) {
  int a = manhattan_distance(i, j, (int)getPFP(e.pos).x, (int)getPFP(e.pos).y);
  if (a == 0)
  {
    return -100;
  }
  else if (a < 5)
  {
    return 100/(5*a);
  }
  else if (a > 6)
  {
    float v = 100 - 40*(a - 6);
    if (v > -0) {
      return v;  
    }
    return 0;
  }
  else
  {
    return 240;
  }
}

public float pcliff(float a) {
  if (a < 1)
  {
    return -80f;
  }
  else if (a == 1) {
    return -40f;
  }
  else if (a == 2) {
    return -20f;
  }
  return 0f;
}

class PotentialField {
  
  float[][] field;
  PVector goal;
  int w;
  int h;

  PotentialField(float w, float h, PVector goal) {
    this.w = ceil(w/60);
    this.h = ceil(h/60);

    field = new float[this.w][this.h];
    this.goal = goal;

  }

  public void add_obstacle_potential(ArrayList<Obstacle> os) {
    for (Obstacle o : os) {
      for (int i = 0; i < 50; i ++) {
        for (int j = 0; j < 50; j ++) {
          field[i][j] += pcliff(manhattan_distance(i,j,o.x+25,o.y+25));
        }
      }
    }
    
  }

  public void clear() {
    for (int i = 0; i < 50; i ++) {
      for (int j = 0; j < 50; j ++) {
        field[i][j] =0;      
      }
    }
  }

  public void add_goal_potential() {
    for(int i = 0; i < w; i ++) {
        for(int j = 0; j < h; j ++) {
        float potential = field[i][j];
        if (potential >= -150 && potential <= -1 && i != 0 && i!=49 && j!=0 && j!=49) {
          if (field[i-1][j] < potential && field[i+1][j] < potential)
          {
            field[i][j] = 0;
          }
          if (field[i][j-1] < potential && field[i][j+1]< potential)
          {
            field[i][j] = 0;
          }  
        }
        field[i][j] +=  200 - 3*manhattan_distance(i, j, (int)getPFP(goal).x, (int)getPFP(goal).y);
        if(i ==0 || i ==49 || j == 0 || j == 49) {
          field[i][j] = -100;
        }
      }
    }
  }
  
  public void add_enemy_potential(ArrayList<Agent> enemies) {
    for (Agent e : enemies) {
      for (int i = 0; i < 50; i ++) {
        for (int j = 0; j < 50; j ++) {
          field[i][j] += penemies(e, i, j);
        }
      }
    }

    
  }

  public void update(ArrayList<Agent> enemies, ArrayList<Obstacle> os) {
    clear();
    add_obstacle_potential(os);
    add_goal_potential();
    add_enemy_potential(enemies);
  }

  public PVector getVel(int r, int c) {
    PVector toGoal = PVector.sub(goal, new PVector(50*(r-25), 50*(c-25), 0));
    if (r != 0 && r != 49 && c != 0 && c!= 49) {
      int id = -1;
      //float cmax = field[r][c];
      float cmax = -1000;
      float[] neighbors = getNeihbors(r, c);
      for (int i = 0 ;i < 8; i ++) {
        if (neighbors[i] > cmax) {
          cmax = neighbors[i];
          id = i;
        }
      }
      if (id == -1) {
        return new PVector();
      }
      return unitV(id);
    }
    return toGoal;
    
  }

  public float[] getNeihbors(int r, int c) {
    float[] v = new float[8];
    if (r < 1 || c < 1 || r > 48 || c > 48) {
      return v;
    }
    v[0] = field[r+1][c] ;
    v[1] = field[r+1][c+1];
    v[2] = field[r][c+1] ;
    v[3] = field[r-1][c+1];
    v[4] = field[r-1][c] ;
    v[5] = field[r-1][c-1];
    v[6] = field[r][c-1] ;
    v[7] = field[r+1][c-1];
    return v;

  }

}

public PVector getPFP(PVector v) {
  return new PVector(floor((v.x+1500)/60), floor((v.y+1500)/60));
}

public PVector unitV(int id) {
  PVector a;
  switch(id) {
    case 0:
      return new PVector(1 ,0 ,0);
    case 1:
      a = new PVector(1,1,0);
      return a.normalize();
    case 2:
      return new PVector(0,1,0);
    case 3:      
      a = new PVector(-1,1,0);
      return a.normalize();
    case 4:
      return new PVector(-1,0,0);
    case 5:      
      a = new PVector(-1,-1,0);
      return a.normalize();
    case 6:
      return new PVector(0, -1, 0);
    case 7:      
      a = new PVector(1,-1,0);
      return a.normalize();
  
  }
  return new PVector();
}


public void keyPressed() {
  if (key == 's') {
    movement = !movement;
  }
  if (key == 'c') {
    switch_render_case();
  }
  if (key == 'p') {
    draw_pf = !draw_pf;
  }
  if (key == 'm') {
    obstacles.clear();
    agents.clear();
    enemies.clear();
    add_moutains();
  }
  if (key == 'o') {
    obstacles.clear();
  }
  if (key == 'r') {
    add_random_obs();
  }
}

public void switch_render_case() {
  render_case += 1;
  if (render_case >= render_case_lim) {
    render_case = 0;
  }
}
  public void settings() {  size(1280, 720, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "potential_field" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
