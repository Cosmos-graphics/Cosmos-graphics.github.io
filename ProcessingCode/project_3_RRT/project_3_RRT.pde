// init input
ArrayList<Edge> edges = new ArrayList<Edge>();
Obstacle obs = new Obstacle(300, 300, 50);
RRT rrt = new RRT();
boolean isReached = false;
int count = 0;

// Boundarys
float top = 0;
float bottom = 600;
float left = 0; 
float right = 600;

Vertice start_v = new Vertice(30.0, 600.0 - 30.0, 0, null);
Vertice end_v = new Vertice(600.0 -30.0, 30.0, -1, null);

Agent agent = new Agent(start_v.getPos().x, start_v.getPos().y, 50.0);


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

  // draw RRT
  for (Edge e : edges)
  {
    stroke(255);
    strokeWeight(1);
    e.draw();
  }
  
  if (isReached)
  {
    for (Edge e: rrt.path)
    {
      stroke(0, 0, 255);
      strokeWeight(3);
      e.draw();
    }
  }
  
  if(!isReached) {
    rrt.update(edges);
    rrt.detectTarget();
  }
  
  
  if (count == 22 && rrt.eta > 1)
  {
    print("rrt.eta: ", rrt.eta );
    rrt.eta = rrt.eta*4/5;
    if (rrt.eta <= 5)
    {
      rrt.eta = 5;
    }
    count %= 22;
  }
  
  // draw start vertice
  noStroke();
  fill(255, 0, 0);
  ellipse(start_v.getPos().x, start_v.getPos().y, 5, 5);
  // draw end vertice
  fill(0, 255, 0);
  ellipse(end_v.getPos().x, end_v.getPos().y, 5, 5);
  
  if (isReached) {
    updateAgent();
  }
  noStroke();
  agent.draw();
  
  count++;
  
}

//==============================================
class RRT {
  ArrayList<Vertice> vs = new ArrayList<Vertice>();
  int tId = -1; // current id for last v
  float eta = 100; // movement value
  int countRRT = 0;
  ArrayList<Edge> path = new ArrayList<Edge>();
  
  void addV(Vertice v) {
    vs.add(v);
  }
  
  //------------------------------------------------
  void update(ArrayList<Edge> edges) {    
    for (int i = 0; i < 3; i++) { // for i = 1, ..., n do
      // generate a random vertice
      Vertice vr = new Vertice(random(left, right), random(top, bottom), -2, null);
      
      // find nearest vertice
      Vertice v_nearest = vr.nearest_vertice(vs);
      
      // generate new vertice according to vr and eta
      PVector n = new PVector(vr.getPos().x - v_nearest.getPos().x, vr.getPos().y - v_nearest.getPos().y);
      n.setMag(eta);
      Vertice v_new = new Vertice(v_nearest.getPos().x + n.x, v_nearest.getPos().y + n.y, tId, v_nearest);
      
      // ## detect obstacles with new edge
      boolean isValidEdge = validEdge(v_nearest, v_new);
      
      if (isValidEdge && !detectBoundary(v_new)) {
        // update vertice array
        vs.add(v_new);

        tId += 1; // update id
        
        v_new.setParent(v_nearest);
        edges.add(new Edge(v_nearest, v_new));

      }
    }
  }
  
  //-------------------------------------------------
  void detectTarget() {
    // detect target every
    //println(countRRT);
    countRRT += 1;
    if (countRRT == 3) {
      for (Vertice v : vs) {
        if (PVector.dist(v.getPos(), end_v.getPos()) <= 5 && !isReached) {
          end_v.setParent(v);
          vs.add(end_v);
          edges.add(new Edge(v, end_v));
          path.add(new Edge(v, end_v));
          isReached = true;
          findPath(end_v);
          break;
        }
      }

      countRRT = 0;
    }
  }
  
  
  
  // findPath
  void findPath(Vertice v) {
      if (v.parent == null)
      {
        return;
      }
      path.add(new Edge(v.getParent(), v));
      findPath(v.getParent());

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
  
  float getCost(){
    return PVector.dist(a.getPos(), b.getPos());
  }
  
  PVector getNVector() {
    PVector temp = new PVector(b.getPos().x - (a.getPos().x), b.getPos().y - a.getPos().y);
    return temp.normalize();
  }
  
  void draw() {
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
  }
  
}

//==============================================
class Vertice {
  PVector pos;
  int id;
  Vertice parent;
  float cost = 0;
  
  Vertice (float x, float y, int ID, Vertice p) {
    this.parent = p;
    this.pos = new PVector(x, y);
    this.id = ID;
    if (p != null) {
      this.cost = PVector.dist(p.getPos(), pos) + p.getCost();
    }else {
      this.cost = 0;
    }
    
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
  
  void setCost(float c) {
    this.cost = c;
  }
  
  void setParent(Vertice p) {
    this.parent = p;
    this.cost = PVector.dist(p.getPos(), pos) + p.getCost();
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
  
  float getCost() {
    return this.cost;
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

//=============== helper function ==============
boolean validEdge(Vertice a, Vertice b)
{
  float px = b.pos.x - a.pos.x;
  float py = b.pos.y - a.pos.y;
  float s = px*px + py*py;

  float u = ((obs.pos.x - a.pos.x) * px + (obs.pos.y - a.pos.y)*py) / s;

  if (u > 1)
  {
    u = 1f;
  }
  else if (u < 0)
  {
    u = 0f;
  }

  float x = a.pos.x + u * px;
  float y = a.pos.y + u * py;
  
  float dx = x - obs.pos.x;
  float dy = y - obs.pos.y;
  
  if (sqrt(dx * dx + dy * dy) < obs.getR())
  {
    return false;
  }
    
  return true;
}

//==================================
class Agent
{
  float x;
  float y;
  float speed;
  int id;
  
  Agent(float x, float y, float s)
  {
    this.x = x;
    this.y = y;
    speed = s;
    id = 0;
  }
  
  void reset()
  {
    this.x = start_v.pos.x;
    this.y = start_v.pos.y;
    id = 0;
  }
  
  void draw() {
    pushMatrix();
    rect(x - 7, y - 7, 14, 14, 2);
    popMatrix();
  }
}

void updateAgent()
{
  if (agent.id == rrt.path.size())
  {
    return;
  }
  
  Edge current = rrt.path.get(rrt.path.size() - 1 - agent.id);
  PVector currentDir = current.getNVector();
  
  float x = agent.x;
  float y = agent.y;
  PVector movement = PVector.mult(currentDir, agent.speed/frameRate);
  
  PVector rest = new PVector(current.b.getPos().x - x, current.b.getPos().y - y);
  
  if (movement.mag() >= rest.mag())
  {
    agent.x = current.b.getPos().x;
    agent.y = current.b.getPos().y;
    agent.id++;
  }else {
    agent.x = x + movement.x;
    agent.y = y + movement.y;
  }
  
}