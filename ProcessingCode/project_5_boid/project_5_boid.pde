
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Boid> boids = new ArrayList<Boid>();

final float SPEED_LIMIT = 5;
final float ATT_STR = 250;
final float REP_STR = 5;
final float ALIGN_STR = 15;
final float PULL_STR = 0.2;
final float OBS_STR = 5;
final float BOID_SIGHT = 100;

final float OVER_DAMP = 0.8;
final float DES_RAN = 50;

boolean gen = true;
int des = 0;

float camFOV = PI/3.0;
PVector camPos = new PVector(0, 0, 1200);
PVector camCent = new PVector(0,0,0);

ParticleBoidSystem ps;
ParticleBoidSystem ps2;
ParticleBoidSystem pss;

void setup() {
  size(800, 800, P3D);
  camera(camPos.x, camPos.y, camPos.z, camCent.x, camCent.y, camCent.z,
          0.0, 1.0, 0.0);
  pss = new ParticleBoidSystem(5, new PVector(0,0,0), (PVector) null, "point", new ArrayList<Float>() {{add(1f);}}, new PVector(255,0,0) );

  ps = new ParticleBoidSystem(15, new PVector(-400,-400,0), new PVector(400,400,0), "point", new ArrayList<Float>() {{add(1f);}}, new PVector(255,255,255) );

  ps2 = new ParticleBoidSystem(2, new PVector(400,-400,400), new PVector(-400,400,-400), "point", new ArrayList<Float>() {{add(1f);}}, new PVector(0,0,255) );

  ArrayList<Float> r = new ArrayList<Float>();
  r.add(50.0);

  obstacles.add(new Obstacle(new PVector(0,0,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(-80,0,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(0,-80,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(-160,0,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(0,-160,0), new PVector(5, 3, 3), "sphere", false, r));
  
  obstacles.add(new Obstacle(new PVector(-240,0,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(0,-240,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(-320,0,0), new PVector(5, 3, 3), "sphere", false, r));
  obstacles.add(new Obstacle(new PVector(0,-320,0), new PVector(5, 3, 3), "sphere", false, r));
  
  
  //for (int i = 0; i < 20; i ++) {
    //boids.add(new Boid(new PVector(-50,50,0), new PVector(0,0,0), new PVector(0,0,0), 25, new PVector(0,0,0)));
  //}
}

void draw() {
  pss.update();
  ps.update();
  ps2.update();
  camera(camPos.x, camPos.y, camPos.z, camCent.x, camCent.y, camCent.z,
          0.0, 1.0, 0.0);
  background(185);
  smooth();
  
  for (Obstacle o : obstacles) {
    //o.position.x = mouseX - width/2;
    //o.position.y = mouseY - height/2;

    o.render();
  }
  
  for (Boid b : boids) {
    b.update();
    b.render();
    //println(b.position.x + " " + b.position.y);
  }

  for (int i = 0; i < boids.size(); i ++)
  {
    if (boids.get(i).destiny != null)
    {
      if (PVector.sub(boids.get(i).position, boids.get(i).destiny).mag() < DES_RAN)
      {
        boids.remove(i);
        i --;
        continue;
      }
    }
    if (PVector.sub(boids.get(i).position, camCent).mag() > 2000)
    {
      boids.remove(i);
      i --;
    }
  }
}

PVector cartesianToPolar(PVector v) {
  PVector p = new PVector();
  p.x = v.mag();
  if (p.x > 0) {
    p.y = atan2(v.y, v.x);
    p.z = acos(v.z / p.x);
  }
  else {
    p.y = 0;
    p.z = 0;
  }
  return p;
}

class ParticleBoidSystem {
  float genRate;
  PVector position;
  String type;
  ArrayList<Float> attributes;
  PVector goal;
  PVector acolor;

  ParticleBoidSystem(float genRate, PVector position, PVector goal, String type, ArrayList<Float> attributes, PVector acolor)
  {
    this.genRate = genRate;
    this.position = position;
    this.goal = goal;
    this.type = type;
    this.attributes = attributes;
    this.acolor = acolor;
  }
  
  void update() {
    if (!gen)
    {
      return;
    }
    float num = genRate / frameRate;
    int i = (int)num;
    if (random(0, 1) < num-i)
    {
      i += 1;
    }
    
    for (int j = 0; j < i; j ++)
    {
      switch(type) {
        case "point":
          boids.add(new Boid(new PVector(position.x + random(0,5), position.y + random(0,5), position.z /*+ random(0,5)*/), new PVector(0,0,0), goal, 25, acolor));
          break;
      }
    }

  }

}

class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float sight = BOID_SIGHT;
  PVector destiny;
  PVector acolor;

  Boid(PVector position, PVector velocity, PVector destiny, float r, PVector acolor) {
    this.position = position;
    this.velocity = velocity;
    this.destiny = destiny;
    this.r = r;
    this.acolor = acolor;
  }
  void render() {
    pushMatrix();
    stroke(acolor.x, acolor.y, acolor.z);
    noFill();
    translate(position.x, position.y, position.z);

    PVector polar = cartesianToPolar(velocity);

    rotateZ(polar.y);
    rotateY(polar.z);

    float a = r;

    beginShape();
    
    vertex(a, 0, -a);
    vertex(0, -a/2, -a);
    vertex(0, 0, a);

    vertex(-a, 0, -a);
    vertex(0, -a/2, -a);
    vertex(0, 0, a);  
    
    vertex(a, 0, -a);
    vertex(0, a/2, -a);
    vertex(0, 0, a);  
    
    vertex(-a, 0, -a);
    vertex(0, a/2, -a);
    vertex(0, 0, a);   
    
    endShape();
    popMatrix();
  }

  void update() {
    //if (des == 1) {
      //destiny = new PVector(0,0,0);
      //destiny.x = mouseX - width/2;
      //destiny.y = mouseY - height/2;
    //}
    //else
    //{
      //destiny = null;
    //}
    acceleration = new PVector(0.0, 0.0, 0.0);
    ArrayList<Boid> neighbors = getNeighbors();
    PVector cen = getCenter(neighbors);
    PVector vel = getAveVel(neighbors);
    pull();

    attract(cen);
    repel(neighbors);
    align(vel, neighbors);

    avoid();

    velocity.add(acceleration);
    if (velocity.mag() > SPEED_LIMIT) {
        velocity.normalize().mult(SPEED_LIMIT);
    }

    position.add(velocity);

  }

  void pull() {
    if (destiny != null) {
      acceleration.add(PVector.sub(destiny, position).normalize().mult(PULL_STR));
    }
  }


  
  PVector getCenter(ArrayList<Boid> n) {
    float sumX = 0;
    float sumY = 0;
    float sumZ = 0;
    for (Boid b : n) {
      sumX += b.position.x;
      sumY += b.position.y;
      sumZ += b.position.z;
    }
    return new PVector(sumX/(float)n.size(), sumY/(float)n.size(), sumZ/(float)n.size());
  }

  PVector getAveVel(ArrayList<Boid> n) {
     float sumX = 0;
    float sumY = 0;
    float sumZ = 0;
    for (Boid b : n) {
      sumX += b.velocity.x;
      sumY += b.velocity.y;
      sumZ += b.velocity.z;
    }
    return new PVector(sumX/(float)n.size(), sumY/(float)n.size(), sumZ/(float)n.size());
   
  }


  void attract(PVector cen) {
    PVector dis = PVector.sub(cen, position);
    if (dis.mag() > ATT_STR/10.0) {
      acceleration.add(dis.div(ATT_STR));
    }
  }

  void avoid()
  {
    for (Obstacle o : obstacles) {
      PVector dis = PVector.sub(position, o.position);
      float s = dis.mag() - o.attributes.get(0) - r;
      s = OBS_STR/s;
      if (s < 0) {
        s = 100;
      }
      acceleration.add(dis.normalize().mult(s));
    }

  }
  void repel(ArrayList<Boid> n) {
    for (Boid b : n) {
      PVector dis = PVector.sub(position, b.position);
      float mag = dis.mag();
      mag = REP_STR/mag;
      dis.normalize();
      dis.mult(mag);
      acceleration.add(dis);
    }
  }

  void align(PVector vel, ArrayList<Boid> n) {
    if (n.size() > 0) {

      PVector pVel = PVector.sub(vel, velocity);
      pVel.div(n.size());
      acceleration.add(pVel.div(ALIGN_STR));
    }
  }

  ArrayList<Boid> getNeighbors() {
    ArrayList<Boid> neighbors = new ArrayList<Boid>();
    for (Boid b : boids) {
      if (distance(b) < sight && distance(b) != 0.0) {
        neighbors.add(b);
      }
    }
    return neighbors;
  }

  float distance(Boid b){
    return b.position.dist(position);
  }
}

class Obstacle {
  PVector position;
  PVector velocity;
  String type;
  Boolean movable;
  ArrayList<Float> attributes;

  Obstacle(PVector position, PVector velocity, String type, Boolean movable, ArrayList<Float> attributes) {
    this.position = position;
    this.velocity = velocity;
    this.type = type;
    this.movable = movable;
    this.attributes = attributes;
  }

  void render() {
    pushMatrix();
    stroke(255);
    noFill();
    translate(position.x, position.y, position.z);

    PVector polar = cartesianToPolar(velocity);

    rotateZ(polar.y);
    rotateY(polar.z);

    
    float a = attributes.get(0);

    switch(type) {
      case "sphere":
        noStroke();
        lights();
        fill(255, 0, 0);
        sphere(a);
        break;
      case "arrow":
        beginShape();
        vertex(-a, -a, 0);
        vertex(0, -a, a/2);
        vertex(0, a, 0);

        vertex(a, -a, 0);
        vertex(0, -a, a/2.0);
        vertex(0, a, 0);

        vertex(a, -a, 0);
        vertex(0, -a, -a/2.0);
        vertex(0, a,0);

        vertex(-a, -a, 0);
        vertex(0, -a, -a/2.0);
        vertex(0, a, 0);
        endShape();
        break;
    }
    popMatrix();
  }
}

void keyPressed()
{
  if (key == 'd')
  {
    if (des == 0) {
      des = 1;
    }
    else {
      des = 0;
    }
  }
  if (key == 'g')
  {
    gen = !gen;
  }
}

