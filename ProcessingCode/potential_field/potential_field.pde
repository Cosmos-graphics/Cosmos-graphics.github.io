import peasy.*;

PeasyCam cam;

ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

PVector goal = new PVector(1200, -1200, 0);

boolean movement = true;

PotentialField pf = new PotentialField(3000, 3000, goal);

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
  for (int i = 3; i < 15 ; i ++) {
      for (int j = 0; j < 15-i+5; j ++) {
        obstacles.add(new Obstacle( i, j,(int)random(1,5)));
        obstacles.add(new Obstacle(-i, -j, (int)random(1,5)));
      }
  }
}

void draw(){
  if(random(1) > 0.95) {
    agents.add(new Agent(new PVector(random(-1300,-500), random(500,1300), 0), 5, 10));
  }
  background(0);
  for (Agent a : agents) {
    a.update();
    a.render();
  }
  for (Obstacle o : obstacles) {
    o.render();
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
}

void terrain() {
  noStroke();
  fill(0, 180, 120);
  //rect(-1500, -1500, 3000, 3000);
  pf.update(agents, obstacles);
  for(int i = 0; i < pf.w; i ++) {
    for(int j = 0; j < pf.h; j ++) {
      fill(0, pf.field[i][j], 0);
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

  void render() {
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

  float period = random(1.2, 2.4); // in seconds
  float dur = 0; // fraction of the peroid (0 ~ 1)
  FirePS f = new FirePS(new PVector(0, 0, 0));
  float apti = random(4, 7);

  Agent(PVector pos, float max_speed, float r) {
    this.pos = pos;
    this.max_speed = max_speed;
    this.r = r;
    this.vel = new PVector();

    //vel.add(1, 0, 0);
  }

  void render() {
    stroke(0, 0, 195);
    fill(0, 0, 140, 240);
    pushMatrix();
    translate(pos.x, pos.y, pos.z + 30);
    float rz = atan2(vel.y, vel.x);
    rotateZ(rz);
    rotateY(PI/24*vel.mag()/max_speed);
    box(60);
    pushMatrix();
    translate(35, 0, 5);
    box(10);
    popMatrix();
    pushMatrix();
    translate(-45, 15, 10);
    rotateY(PI/24*vel.mag()/max_speed);
    box(15);
    f.render();
    popMatrix();
    pushMatrix();
    translate(-45, -15, 10);
    rotateY(PI/24*vel.mag()/max_speed);
    box(15);
    f.render();
    popMatrix();
    popMatrix();
  }

  void update()
  {
    animation();
    f.update();
    if (movement) {
      updateVel();
      vel.add(PVector.sub(goal, pos).normalize().mult(0.2));
      vel.normalize();
      vel.mult(max_speed*0.8);
      pos.add(vel);
    }
  }

  void updateVel() {
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
    pos.z = 10 + h;

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

  }

  void update(ArrayList<Agent> as, ArrayList<Obstacle> os) {
    for (int i = 0; i < 50; i ++) {
      for (int j = 0; j < 50; j ++) {
        field[i][j] =0;      
      }
    }


    for (Obstacle o : os) {
      for (int i = 0; i < 50; i ++) {
        for (int j = 0; j < 50; j ++) {
          field[i][j] += pcliff(manhattan_distance(i,j,o.x+25,o.y+25));
        }
      }
    }
    

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



    for (Agent a : as) {
      int x = (int)getPFP(a.pos).x;
      int y = (int)getPFP(a.pos).y;
      field[x][y] -= 40;
      field[x+1][y] -= 15;
      field[x][y+1] -= 15;
      field[x-1][y] -= 15;
      field[x][y-1] -= 15;

    }
  }

  PVector getVel(int r, int c) {
    if (r != 0 && r != 49 && c != 0 && c!= 49) {
      int id = -1;
      float cmax = 0;
      float[] neighbors = getNeihbors(r, c);
      for (int i = 0 ;i < 8; i ++) {
        if (neighbors[i] > cmax) {
          cmax = neighbors[i];
          id = i;
        }
      }
      return unitV(id);
    }
    return goal;
    
  }

  float[] getNeihbors(int r, int c) {
    float[] v = new float[8];
    v[0] = field[r+1][c] + 15;
    v[1] = field[r+1][c+1];
    v[2] = field[r][c+1] + 15;
    v[3] = field[r-1][c+1];
    v[4] = field[r-1][c] + 15;
    v[5] = field[r-1][c-1];
    v[6] = field[r][c-1] + 15;
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
}
