// init input
ArrayList<Edge> edges = new ArrayList<Edge>();
Obstacle obs = new Obstacle(300, 300, 50);
RRT rrt = new RRT();
boolean isReached = false;
int count = 0;

// Boundarys
float top = 0;
float bottom = 600;
float left = 00; 
float right = 600;

Vertice start_v = new Vertice(30, 600 - 30, 0, null);
Vertice end_v = new Vertice(600 -30, 30, -1, null);


void setup() {
  size(600, 600, P2D);
  background(0);
  strokeWeight(5);
  smooth(8);
  
  rrt.addV(start_v);
}

void draw() {
  background(0);
  
  // draw obstacle
  obs.draw();
  
  // draw start vertice
  noStroke();
  fill(255, 0, 0);
  ellipse(start_v.getPos().x, start_v.getPos().y, 5, 5);
  text("start", 0, 700);
  // draw end vertice
  fill(0, 255, 0);
  ellipse(end_v.getPos().x, end_v.getPos().y, 5, 5);
  
  if (!isReached) {
    rrt.update(edges);
  }else{
    for (Edge e: rrt.path)
    {
      stroke(0, 0, 255);
      e.draw();
    }
  }
  
  // draw RRT
  for (Edge e : edges)
  {
    stroke(255);
    e.draw();
  }
  
  
  if (count == 100 && rrt.dd > 1)
  {
    rrt.dd /= 2;
  }
  count++;
  
}

//==============================================
class RRT {
  ArrayList<Vertice> vs = new ArrayList<Vertice>();
  int tId = -1; // current id for last v
  float dd = 20; // movement value
  int num = 1;
  int count = 0;
  ArrayList<Edge> path = new ArrayList<Edge>();
  
  void addV(Vertice v) {
    vs.add(v);
  }
  
  void update(ArrayList<Edge> edges) {
    boolean isBoundary = false;
    boolean isObstacle = false;
    
    // generate a random vertice
    Vertice vr = new Vertice(random(left, right), random(top, bottom), -2, null);
    
    // find nearest vertice
    Vertice v_nearest = vr.nearest_vertice(vs);
    
    // movement
    PVector n = new PVector(vr.getPos().x - v_nearest.getPos().x, vr.getPos().y - v_nearest.getPos().y);
    n.setMag(dd);
    Vertice v_new = new Vertice(v_nearest.getPos().x + n.x, v_nearest.getPos().y + n.y, tId, v_nearest);
    
    // detect Boundary
    isBoundary = detectBoundary(v_new);
    isObstacle = detectObstacle(obs, v_new);
    
    if (!isBoundary && !isObstacle) {
      // update vertice array
      vs.add(v_new);
      num += 1; // total number of vertices
      count += 1;
      tId += 1;
      
      // update edge array
      edges.add(new Edge(v_new, v_nearest));
      
    }
  }
  
  //
  void detectTarget() {
    for (Vertice v : vs) {
      if (PVector.dist(v.getPos(), end_v.getPos()) == 0) {
        isReached = true;
        findPath(v);
      }
    }
  }
  
  // findPath
  void findPath(Vertice v) {
    while(v.getParent() != null)
    {
      path.add(new Edge(v, v.getParent()));
      findPath(v.getParent());
    }
  }
  
  boolean detectBoundary(Vertice v) {
    float x = v.getPos().x;
    float y = v.getPos().y;
    
    if (x <= left || x >= right || y <= top || y >= bottom) {
      return true;
    }else {
      return false;
    }
  }
  
  boolean detectObstacle(Obstacle ob, Vertice v) {
    if (PVector.dist(ob.getPos(), v.getPos()) <= ob.getR()){
      return true;
    }else {
      return false;
    }
  }
  
  // ------- accessor --------
  boolean getIsReached() {
    return isReached;
  }
  
}

//==============================================
class Edge
{
  Vertice a;
  Vertice b;
  
  Edge(Vertice a, Vertice b)
  {
    this.a = a;
    this.b = b;
  }
  
  boolean contains(Vertice v)
  {
    if ((v.pos.x == a.pos.x && v.pos.y == a.pos.y) ||( v.pos.x == b.pos.x && v.pos.y == b.pos.y ))
    {
      return true;
    }
    return false;
  }
  
  void draw() {
    fill(255);
    strokeWeight(1);
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
  }
}

//==============================================
class Vertice {
  PVector pos;
  int id;
  Vertice parent;
  
  Vertice (float x, float y, int ID, Vertice p) {
    this.parent = p;
    this.pos = new PVector(x, y);
    this.id = ID;
  }
  
  Vertice nearest_vertice (ArrayList<Vertice> vs) {
    // simulate infinite
    float d = 100000;
    Vertice nearest_v = null;
    
    for (Vertice v : vs) {
      
      float temp = PVector.dist(this.pos, v.getPos());
      if (temp < d) {
        d = temp;
        nearest_v = v;
      }
    }
    
    return nearest_v;
    
  }
  
  //------------ mutator ------------------
  void setPos(float x, float y) {
    this.pos.x = x;
    this.pos.y = y;
  }
  
  void setId(int ID) {
    this.id = ID;
  }
  
  //------------ accessor ------------------
  PVector getPos() {
    return this.pos;
  }
  
  int getId() {
    return this.id;
  }
  
  Vertice getParent() {
    return this.parent;
  }
  
}

//==============================================
class Obstacle {
  PVector pos;
  float r;
  
  Obstacle(float x, float y, float R) {
    this.pos = new PVector(x, y);
    this.r = R;
  }
  
  void draw() {
    pushMatrix();
    noStroke();
    fill(100);
    ellipse(this.pos.x, this.pos.y, 2 * this.r, 2 * this.r);
    popMatrix();
  }
  
  PVector getPos() {
    return this.pos;
  }
  
  float getR() {
    return r;
  }
}