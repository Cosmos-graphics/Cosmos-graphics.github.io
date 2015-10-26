import java.util.Collections;

float validDistance = 100f;
float ff = 0.25f;

ArrayList<Vertice> vertices = new ArrayList<Vertice>();
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Edge> edges = new ArrayList<Edge>();
Vertice start_v = new Vertice(100 + 30, 100 + 19 * 30);
Vertice end_v = new Vertice(100 + 19 * 30, 100 + 30);
Agent agent = new Agent(start_v.x, start_v.y, 50);

PImage[] misty;


ArrayList<Integer> aStarPath = new ArrayList<Integer>();

/*
 0 -- normal mode
 1 -- placing start mode     shortcut: s
 2 -- placing end mode       shortcut: g
 3 -- placing vertice mode   shortcut: v
 4 -- agent moving           shortcut: p
 5 -- reset agent            shortcut: r
 6 -- placing obstacle       shortcut: o
 7 -- generate Map           shortcut: m
*/
int mode = 0;


ArrayList<Vertice> path = new ArrayList<Vertice>();


void setup()
{
  size(800, 800, P2D);
  background(0);
  strokeWeight(5);
  smooth(8);

  obstacles.add(new Obstacle(width/2, height/2, 60));
  randomObstacles(5);
  vertices.add(start_v);
  vertices.add(end_v);
  generateMap();
  aStarPath = aStarSearch(start_v, end_v);
  misty = new PImage[12];
  misty[0] = loadImage("uFrame1.png");
  misty[1] = loadImage("uFrame2.png");
  misty[2] = loadImage("uFrame3.png");
  misty[3] = loadImage("dFrame1.png");
  misty[4] = loadImage("dFrame2.png");
  misty[5] = loadImage("dFrame3.png");
  misty[6] = loadImage("lFrame1.png");
  misty[7] = loadImage("lFrame2.png");
  misty[8] = loadImage("lFrame3.png");
  misty[9] = loadImage("rFrame1.png");
  misty[10] = loadImage("rFrame2.png");
  misty[11] = loadImage("rFrame3.png");
}

void draw()
{
  background(0);
  noStroke();
  fill(255);
  for(Obstacle o : obstacles)
  {
    ellipse(o.x, o.y, o.r * 2, o.r * 2);
  }
  
  stroke(255);
  strokeWeight(1);
  
  for (Edge e : edges)
  {
    line(e.a.x, e.a.y, e.b.x, e.b.y);
  }
  
  
  strokeWeight(5);

  stroke(255);
  for (Vertice v : vertices)
  {
    String s = (v.x + "," + v.y + " " + v.getID());
    point(v.x, v.y);
    fill(0, 255, 0);
    text(s, v.x, v.y);
  }
  

  
  noStroke();
  fill(255, 0, 0);
  ellipse(vertices.get(0).x, vertices.get(0).y, 5, 5);
  fill(0, 255, 0);
  ellipse(vertices.get(1).x, vertices.get(1).y, 5, 5);
  
  if (mode == 1)
  {
    noStroke();
    fill(255, 0, 0);
    ellipse(mouseX, mouseY, 5, 5);
  }
  else if (mode == 2)
  {
    noStroke();
    fill(0, 255, 0);
    ellipse(mouseX, mouseY, 5, 5);
  }
  else if (mode == 3)
  {
    noStroke();
    fill(255);
    ellipse(mouseX, mouseY, 5,5);
  }
  else if(mode == 6)
  {
    fill(255);
    ellipse(mouseX, mouseY, 30,30);
  }
  
  for (int i = 0 ; i < aStarPath.size() - 1 ; i++)
  {
    strokeWeight(2);
    stroke(0,0,255);
    line(vertices.get(aStarPath.get(i)).x, vertices.get(aStarPath.get(i)).y, vertices.get(aStarPath.get(i+1)).x, vertices.get(aStarPath.get(i+1)).y);
  }
  
  noStroke();
  fill(171, 157, 114);
  //ellipse(agent.x, agent.y, 5,5);
  image(misty[agent.frame + agent.face], agent.x - 8.5, agent.y-15);
  if (mode == 4 && aStarPath != null)
  {
    updateAgent();
  }
  if (mode == 7)
  {
    if (aStarPath.size() == 0)
    {
      generateMap();
    }
    else
    {
      mode = 0;
    }
  }
  
}

void updateAgent()
{
  if (agent.id == aStarPath.size() - 1)
  {
    return;
  }
  float x = agent.x;
  float y = agent.y;
  float nx = 1.0 * vertices.get(aStarPath.get(agent.id + 1)).x;
  float ny = 1.0 * vertices.get(aStarPath.get(agent.id + 1)).y;
  float ds = agent.speed/(1.0 * frameRate);
  
  if (nx - x > 0 && y - ny > 0)
  {
    if (nx - x > y - ny)
    {
      agent.face = 6;
    }
    else
    {
      agent.face = 0;
    }
  }
  if (nx - x < 0 && y - ny < 0)
  {
    if (abs(nx - x) > abs(y - ny))
    {
      agent.face = 9;
    }
    else
    {
      agent.face = 3;
    }
  }
  if (nx - x > 0 && y - ny < 0)
  {
    if (nx - x > abs(y - ny))
    {
      agent.face = 6;
    }
    else
    {
      agent.face = 3;
    }
  }
  if (nx - x < 0 && y - ny > 0)
  {
    if (abs(nx - x) > y - ny)
    {
      agent.face = 9;
    }
    else
    {
      agent.face = 0;
    }
  }
  
  float p = ds / sqrt(pow(ny - y, 2) + pow(nx - x, 2));
  agent.acc += 1/frameRate;
  if(agent.acc >= ff)
  {
    agent.acc = 0;
    agent.increaseFrame();
  }

  
  while (p > 1)
  {
    ds -= sqrt(pow(ny - y, 2) + pow(nx - x, 2));
    agent.id += 1;
    x = nx;
    y = ny;
    if (agent.id == aStarPath.size() - 1)
    {
      agent.x = x;
      agent.y = y;
      return;
    }
    nx = 1.0 * vertices.get(aStarPath.get(agent.id + 1)).x;
    ny = 1.0 * vertices.get(aStarPath.get(agent.id + 1)).y;

    p = ds / sqrt(pow(ny - y, 2) + pow(nx - x, 2));

  }
  agent.x = x + p * (nx - x);
  agent.y = y + p * (ny - y);
  
}

void randomObstacles(int x)
{
  for (int i = 0; i < x; i ++)
  {
    obstacles.add(new Obstacle((int)random(100,700), (int)random(100,700), (int)random(20,50)));
  }
}

ArrayList<Integer> aStarSearch(Vertice s, Vertice e)
{
  AStarNode current = new AStarNode(s.getID(), 0, getHeristics(s), null);
  ArrayList<AStarNode> openList = new ArrayList<AStarNode>();
  ArrayList<Integer> closedList = new ArrayList<Integer>();
    
  ArrayList<Integer> thePath = new ArrayList<Integer>();
  
  closedList.add(current.id);
  while(!vertices.get(current.id).equals(e))
  {
    ArrayList<Integer> ids = getNeighbors(current);
    for (int i : ids)
    {
      if(!closedList.contains(i))
      {
        openList.add(new AStarNode(i, getHeristics(vertices.get(i)), current.cost + distance2(vertices.get(current.id), vertices.get(i)), current));
      }
    }
    
    //for (AStarNode i : openList)
    //{
    //  println(i.id + " " + i.cost + " " + i.h);
    //}
    
    if (openList.size() == 0)
    {
      return thePath;
    }
    float minF = 100000000;
    int best_k = 0;
    for (int k = 0; k < openList.size(); k ++)
    {
      if(openList.get(k).h + openList.get(k).cost < minF)
      {
        minF = openList.get(k).h + openList.get(k).cost;
        best_k = k;
      }
    }

    current = openList.get(best_k);
    closedList.add(current.id);
    openList.remove(best_k);
    //println(current.id + " " + current.parent.id);
    
  }

  while (current.parent != null)
  {
    thePath.add(current.id);
    current = current.parent;
  }
  thePath.add(current.id);
  Collections.reverse(thePath);
  //float len = 0;
  //for (int i = 0; i < thePath.size()-1; i++)
  //{
  //  len += distance2(vertices.get(thePath.get(i)), vertices.get(thePath.get(i+1)));
  //}
  //println(len);
  return thePath;

  
}

float distance2(Vertice a, Vertice b)
{
  return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}

ArrayList<Integer> getNeighbors(AStarNode a)
{
  ArrayList<Integer> ids = new ArrayList<Integer>();
  Vertice v = vertices.get(a.id);
  for (Edge e : edges)
  {
    if(e.contains(v))
    {
      if(e.a.equals(v))
      {
        ids.add(e.b.getID());
      }
      else
      {
        ids.add(e.a.getID());
      }
    }
  }
  return ids;
}


float getHeristics(Vertice a)
{
  return sqrt(pow(end_v.x - a.x,2) + pow(end_v.y - a.y,2));
}

void generateEdges()
{
  for (int i = 0; i < vertices.size(); i++)
  {
    Vertice v1 = vertices.get(i);
    for (int j = i+1; j < vertices.size(); j ++)
    {
      Vertice v2 = vertices.get(j);
      if(validEdge(v1, v2))
      {
        edges.add(new Edge(v1, v2));
      } 
    }
  }
}

float pointDistance2(Vertice a, Vertice b)
{
  return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}

boolean validEdge(Vertice a, Vertice b)
{
  if (pointDistance2(a, b) > validDistance)
  {
    return false;
  }
  float px = b.x - a.x;
  float py = b.y - a.y;
  float s = px*px + py*py;
  
  for (Obstacle o : obstacles)
  {
    float u = ((o.x - a.x) * px + (o.y - a.y)*py) / s;

    if (u > 1)
    {
      u = 1f;
    }
    else if (u < 0)
    {
      u = 0f;
    }

    float x = a.x + u * px;
    float y = a.y + u * py;
    
    float dx = x - o.x;
    float dy = y - o.y;
    
    if (sqrt(dx * dx + dy * dy) < o.r)
    {
      return false;
    }

  }
  return true;
}

void prm(int k)
{
  for (int i = 0; i < k; i++)
  {
    addRandomPoint();
    removeDuplicate();
    removeCollisionWithObstacle();
  }

}

void removeCollisionWithObstacle()
{
  for(int i = 0; i < vertices.size(); i++)
  {
    for(int j = 0; j < obstacles.size(); j++)
    {
      if (pow(vertices.get(i).x - obstacles.get(j).x, 2) + pow(vertices.get(i).y - obstacles.get(j).y, 2) < pow(obstacles.get(j).r, 2))
      {
        vertices.remove(i);
        i--;
      }
    }
  }
}

void removeDuplicate()
{
  for (int i = 0; i < vertices.size(); i++)
  {
    for(int j = i + 1; j < vertices.size(); j++)
    {
      if (vertices.get(i).x == vertices.get(j).x && vertices.get(i).y == vertices.get(j).y)
      {
        vertices.remove(j);
        j--;
      }
    }
  }
}

void generateMap()
{
  int i = 0;
  while(aStarPath.size() == 0 && i < 60)
  {
    prm(20);
    edges.clear();
    generateEdges();
    aStarPath = aStarSearch(start_v, end_v);
  }
}

void addRandomPoint()
{
  int x = (int) (random(100, 700));
  int y = (int) (random(100, 700));
  vertices.add(new Vertice(x, y));
}

class Obstacle
{
  int x;
  int y;
  int r;
  Obstacle(int x, int y, int r)
  {
    this.x = x;
    this.y = y;
    this.r = r;
  }
}

class Vertice
{
  int x;
  int y;
  Vertice(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  int getID()
  {
    for (int i = 0; i < vertices.size(); i ++)
    {
      if (vertices.get(i).x == x && vertices.get(i).y == y)
      {
        return i;
      }
    }
    return -1;
  }
  
  boolean equal(Vertice a)
  {
    if (a.x == x && a.y == y)
    {
      return true;
    }
    return false;
  }
}

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
    if ((v.x == a.x && v.y == a.y) ||( v.x == b.x && v.y == b.y ))
    {
      return true;
    }
    return false;
  }
}

class AStarNode
{
  int id;
  float h;
  AStarNode parent;
  float cost;
  AStarNode(int id, float h, float cost, AStarNode parent)
  {
    this.id = id;
    this.h = h;
    this.cost = cost;
    this.parent = parent;
  }
}

class Agent
{
  float x;
  float y;
  float speed;
  int id;
  float acc = 0;
  int frame = 0;
  int face = 6;
  Agent(int x, int y, float s)
  {
    this.x = x;
    this.y = y;
    speed = s;
    id = 0;
  }
  void increaseFrame()
  {
    frame++;
    if (frame == 3)
    {
      frame = 1;
    }
  }
  
  void reset()
  {
    this.x = start_v.x;
    this.y = start_v.y;
    id = 0;
    acc = 0;
    frame = 0;
  }  
}

void keyPressed()
{
  if (key == 's')
  {
    mode = 1;
  }
  if (key == 'g')
  {
    mode = 2;
  }
  if (key == 'v')
  {
    mode = 3;
  }
  if (key == 'c')
  {
    mode = 0;
    for (int i = 2; i < vertices.size(); i ++)
    {
      vertices.remove(i);
      i --;
    }
    for (int i = 1; i < obstacles.size(); i ++)
    {
      obstacles.remove(i);
      i --;
    }
    edges.clear();
    generateEdges();
    aStarPath = aStarSearch(start_v, end_v);
    agent.reset();
  }
  if (key == 'p')
  {
    mode = 4;
  }
  if (key == 'r')
  {
    agent.reset();
    mode = 0;
  }
  if (key == 'o')
  {
    mode = 6;
  }
  if (key == 'm')
  {
    mode = 7;
  }
}

void mousePressed()
{
  if (mode == 1)
  {
    start_v = new Vertice((int)mouseX, (int)mouseY);
    vertices.set(0, start_v);
    edges.clear();
    generateEdges();
    mode = 0;
    agent.reset();
  }
  
  if (mode == 2)
  {
    end_v = new Vertice((int)mouseX, (int)mouseY);
    vertices.set(1, end_v);
    edges.clear();
    generateEdges();
    mode = 0;
    agent.reset();
  }
  if (mode == 3)
  {
    vertices.add(new Vertice((int)mouseX, (int)mouseY));
    removeCollisionWithObstacle();
    edges.clear();
    generateEdges();
    aStarPath = aStarSearch(start_v, end_v);
    mode = 0;
    agent.reset();
  }
  if(mode == 6)
  {
    obstacles.add(new Obstacle((int)mouseX, (int)mouseY, (int)random(30, 60)));
    removeCollisionWithObstacle();
    edges.clear();
    generateEdges();
    aStarPath = aStarSearch(start_v, end_v);
    mode = 0;
    agent.reset();
  }
}