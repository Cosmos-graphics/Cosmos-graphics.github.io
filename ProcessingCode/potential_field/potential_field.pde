import peasy.*;

PeasyCam cam;

final float REP_STR = 60;
final float GOAL_FORCE = 0.2;
final float SEEK_DISTANCE = 200;
final float GEN_RATE = 0.98;
final float ALIGN_STR = 2;

ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Agent> agents2 = new ArrayList<Agent>();
ArrayList<Agent> agents3 = new ArrayList<Agent>();
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Agent> enemies = new ArrayList<Agent>();
ArrayList<Agent> enemies2 = new ArrayList<Agent>();
ArrayList<Missile> missiles = new ArrayList<Missile>();
ArrayList<Obstacle> obstacles2 = new ArrayList<Obstacle>();

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
PotentialField pfh = new PotentialField(3000, 3000, goal);
PotentialField pff = new PotentialField(3000, 3000, goal);

Agent a;

void setup(){
  size(1280, 720, P3D);
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

void add_moutains() {
  for (int i = 3; i < 7 ; i ++) {
      for (int j = 0; j < 7-i+5; j ++) {
        obstacles.add(new Obstacle( i, j,0, 1));
        obstacles.add(new Obstacle(-i, -j,0,  1));
      }
  }
  for (int i = 0; i < 7 ; i ++) {
    for (int j = 0; j < 7; j ++) {
      obstacles2.add(new Obstacle( i, j, 1, 2));
      obstacles2.add(new Obstacle(-i, -j, 1,  2));
      obstacles2.add(new Obstacle( -i, j, 1, 2));
      obstacles2.add(new Obstacle(i, -j, 1,  2));
    }
  }
}

void add_random_obs() {
  obstacles.add(new Obstacle((int)random(-20, 20), (int)random(-20, 20), 0, 5));
}

void draw(){
  if(random(1) > GEN_RATE) {
    agents.add(new Agent(new PVector(random(-1300,-500), random(500,1300), 0), 5, 10));
    agents2.add(new Agent(new PVector(random(-1300,-500), random(500, 1300), 160), 5, 10));
    agents3.add(new Agent(new PVector(random(-1300, -500), random(500, 1300), 0), 5, 10));
  }
  if(random(1) > 0.99) {
    enemies.add(new Agent(new PVector(random(600, 1200), -600 - 600*random(1), 0), 0, 0));
    enemies.get(enemies.size()-1).col = color(140,0,0,240);
    enemies.get(enemies.size()-1).scol = color(195,0,0);
  }
  //lights();

  ArrayList<Agent> allenemies = new ArrayList<Agent>();
  allenemies.addAll(enemies);
  allenemies.addAll(enemies2);  
  ArrayList<Agent> groundAgents = new ArrayList<Agent>();
  groundAgents.addAll(agents);
  groundAgents.addAll(agents3);
  
  
  pf.update(enemies, obstacles);
  pfh.update(enemies2, obstacles2);
  pff.clear();
  pff.add(pf);
  pff.add(pfh);
  background(0);
  for (Agent a : agents) {
    a.update_status(enemies);
    a.update(pf, groundAgents);
    a.render(render_case, 1);
  }
  for (Agent a : agents2) {
    a.update_status(enemies);
    a.update(pfh, agents2);
    a.render(render_case, 1);
  }


  for (Agent a : agents3) {
    a.update_status(allenemies);
    a.update(pff, groundAgents);
    a.render(render_case, 2);
  }
  
  for (Obstacle o : obstacles) {
    o.render();
  }

  for (Obstacle o : obstacles2) {
    o.render();
  }

  for (Agent e : enemies) {
    e.update_status(agents);
    e.update(pf, enemies);
    e.render(render_case, 1);
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

  for (int i = 0; i < agents3.size(); i++) {
    if (manhattan_distance(gx, gy, (int)getPFP(agents3.get(i).pos).x, (int)getPFP(agents3.get(i).pos).y) < 4) {
      agents3.remove(i);
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

void terrain() {
  noStroke();
  fill(0, 180, 120);
  //rect(-1500, -1500, 3000, 3000);
  for(int i = 0; i < pf.w; i ++) {
    for(int j = 0; j < pf.h; j ++) {
      if (draw_pf) {
        fill(0, pf.field[i][j], 0);
        rect(60*(i-25), 60*(j-25), 60,60);
        pushMatrix();
        translate(0,0,300);
        fill(0, pfh.field[i][j], 0, 180);
        rect(60*(i-25), 60*(j-25), 60,60);
        popMatrix();
      }
      else {
        fill(0, 120, 0);
        rect(60*(i - 25), 60*(j-25), 60, 60);
      }
      //fill(0, 255, 0);
    }
  }
  
}

class Obstacle {
  int x;
  int y;
  int h;
  int g;

  Obstacle(int x, int y, int g, int h) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.g = g;
  }

  void render() {
    pushMatrix();
    fill(180,0,0,230);
    stroke(230,0,0);
    translate(60*x + 30, 60*y + 30, 30 + 65*g);
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

  color col = color(0,140,140,240);
  color scol = color(0,195,195);

  float period = random(1.2, 2.4); // in seconds
  float dur = 0; // fraction of the peroid (0 ~ 1)
  FirePS f = new FirePS(new PVector(0, 0, 0));
  float apti = random(4, 7);
  boolean attacking = false;
  float atk_dur = 0;
  float atk_period = 0.7;
  PVector target = new PVector();
  float hp = 100;
  float hei;

  void hit() {
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

  void render(int type, float s) {
    switch (type) {
      case 0:
        render_agent(s);
        break;
      case 1:
        render_circle(s);
    }
  }

  ArrayList<Agent> get_neighbors(ArrayList<Agent> agents) {
    ArrayList<Agent> n = new ArrayList<Agent>();
    for(Agent a : agents)
    {
      if (PVector.sub(a.pos, pos).mag() <= SEEK_DISTANCE && PVector.sub(a.pos, pos).mag() != 0){
        n.add(a);
      }
    }
    return n;
  }

  void render_circle(float s) {
    stroke(scol);
    fill(col);
    pushMatrix();
    translate(pos.x, pos.y, 2 + pos.z);
    line(0,0,0, 0,0,-pos.z);
    scale(s);
    ellipse(0, 0, 50, 50);
    popMatrix();
  }

  void render_agent(float s) {
    stroke(scol);
    fill(col);
    pushMatrix();
    translate(pos.x, pos.y, pos.z + 30);
    scale(s);
    float rz = atan2(vel.y, vel.x);
    rotateZ(rz);
    rotateY(PI/24*vel.mag()/(max_speed + 1));
    box(60);
    line(0,0,0, 0,0,-pos.z-30);
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

  void update_status(ArrayList<Agent> enemies) {
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

  PVector getAveVel(ArrayList<Agent> n) {
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


  void align(ArrayList<Agent> n) {
    if (n.size() == 0) {
      return;
    }
    PVector avel = getAveVel(n);
    PVector pvel = PVector.sub(avel, vel);
    pvel.div(n.size());
    vel.add(pvel.div(ALIGN_STR));
  }

  void update(PotentialField pf, ArrayList<Agent> as)
  {
    animation();
    f.update();
    if (movement && !attacking) {
      ArrayList<Agent> n = get_neighbors(as);
      updateVel(pf);
      repel(n);
      align(n);
      //vel.add(PVector.sub(goal, pos).normalize().mult(GOAL_FORCE));
      if (vel.mag() > max_speed) {
        vel.normalize().mult(max_speed);
      }
      else {
        vel.mult(1.02);
      }
      if (max_speed != 0) {
        pos.add(vel);
      }
    }
    if (attacking) {
      attack();
    }
  }

  void attack() {
    vel = PVector.sub(target, pos).normalize().mult(0.0005);
    atk_dur += 1.0/frameRate;
    if (atk_dur > atk_period) {
      atk_dur = 0f;
      missiles.add(new Missile(pos, target));
    }
  }

  void repel(ArrayList<Agent> agents) {
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

  void updateVel(PotentialField pf) {
    PVector block = getPFP(pos);
    int w = (int) block.x;
    int h = (int) block.y;
    vel.add(pf.getVel(w, h).mult(2));
  }

  void animation() {
    dur += 1.0/frameRate;
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

  void update()
  {
    pos.add(PVector.sub(target, pos).normalize().mult(speed/frameRate));
  }

  void render()
  {
    stroke(255);
    fill(0, 0, 0, 240);
    pushMatrix();
    translate(pos.x, pos.y, 2+pos.z);
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

  void update() {
    for (int i = 0; i < 24; i++) {
      xpos[i] = xpos[i+1];
      ypos[i] = ypos[i+1];
      zpos[i] = zpos[i+1] - random(2);
    }
    xpos[24] = pos.x + random(-5,5);
    ypos[24] = pos.y + random(-5,5);
    zpos[24] = pos.z + random(-10,-7);
  }

  void render() {
    for (int i = 0; i< 25; i++) {
      pushMatrix();
      translate(xpos[i], ypos[i], zpos[i]);
      rect(-i/3,-i/3, 2*i/3, 2*i/3);
      popMatrix();
    }
  }

}

int manhattan_distance(int a, int b, int c, int d) {
  return abs(a-c) + abs(b-d);
}

float penemies(Agent e, int i, int j) {
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

float pcliff(float a) {
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
    clear();

  }

  void add_obstacle_potential(ArrayList<Obstacle> os) {
    for (Obstacle o : os) {
      for (int i = 0; i < 50; i ++) {
        for (int j = 0; j < 50; j ++) {
          field[i][j] += pcliff(manhattan_distance(i,j,o.x+25,o.y+25));
        }
      }
    }
    
  }

  void clear() {
    for (int i = 0; i < 50; i ++) {
      for (int j = 0; j < 50; j ++) {
        field[i][j] =0;      
      }
    }
  }

  void add(PotentialField p) {
    for (int i = 0; i < 50; i ++) {
      for (int j = 0; j < 50; j ++) {
        field[i][j] += p.field[i][j];      
      }
    }
  }

  void add_goal_potential() {
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
  
  void add_enemy_potential(ArrayList<Agent> enemies) {
    for (Agent e : enemies) {
      for (int i = 0; i < 50; i ++) {
        for (int j = 0; j < 50; j ++) {
          field[i][j] += penemies(e, i, j);
        }
      }
    }

    
  }

  void update(ArrayList<Agent> enemies, ArrayList<Obstacle> os) {
    clear();
    add_obstacle_potential(os);
    add_goal_potential();
    add_enemy_potential(enemies);
  }

  PVector getVel(int r, int c) {
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

  float[] getNeihbors(int r, int c) {
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

PVector getPFP(PVector v) {
  return new PVector(floor((v.x+1500)/60), floor((v.y+1500)/60));
}

PVector unitV(int id) {
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


void keyPressed() {
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
    obstacles2.clear();
    agents2.clear();
    agents3.clear();
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

void switch_render_case() {
  render_case += 1;
  if (render_case >= render_case_lim) {
    render_case = 0;
  }
}
