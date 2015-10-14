class Cloth{
  int numLengthParticals;
  int numWidthParticals;
  float startY;
  PVector[][] p; // Cloth particals position array
  PVector[][] vn; // Cloth particals speed array
  float[][] l0v; // Cloth particals rest length vertical array
  float[][] l0h; // Cloth particals rest length horizontal array
  float[][] l0d1; // Cloth particals rest length diagonal array
  float[][] l0d2; // Cloth particals rest length diagonal array
  PImage img;
  
  // Cloth particals Initilization function
  Cloth(int nlp, int nwp, float y, PImage image) {
    numLengthParticals = nlp;
    numWidthParticals = nwp;
    img = image;
    startY = y;
    p = new PVector[nlp][nwp];
    vn = new PVector[nlp][nwp];
    l0v = new float[nlp][nwp-1];
    l0h = new float[nlp-1][nwp];
    l0d1 = new float[nlp -1][nwp-1];
    l0d2 = new float[nlp-1][nwp-1];
    
    float left = -200;
    float right = 200;
    float front = 200;
    float back = -200;
    
    float xdiv = (right - left) / (nlp-1);
    float zdiv = (front - back) / (nwp-1);
    
    // position initilization
    for (int i = 0; i < nlp; i++) {
      for (int j = 0; j < nwp; j++) {
        //print(left + i*xdiv);
        //print();
        //print(back + j*zdiv);
        p[i][j] = new PVector(left + i*xdiv, startY, back + j*zdiv);
      }
    }
    
    // speed initilization
    for (int i = 0; i < nlp; i++) {
      for (int j = 0; j < nwp; j++) {
        vn[i][j] = new PVector(-1, 0.0, 0);
      }
    }
    
    // rest length horizontal initilization
    for (int i = 0; i < nlp-1; i++) {
      for (int j = 0; j < nwp; j++) {
        l0h[i][j] = PVector.dist(p[i][j], p[i+1][j]);
      }
    }
    
    // rest length vertical initilization
    for (int i = 0; i < nlp; i++) {
      for (int j = 0; j < nwp-1; j++) {
        l0v[i][j] = PVector.dist(p[i][j], p[i][j+1]);
      }
    }
    
    // rest length diagonal initilization
    for (int i = 0; i < nlp-1; i++) {
      for (int j = 0; j < nwp-1; j++) {
        l0d1[i][j] = PVector.dist(p[i][j], p[i+1][j+1]);
      }
    }
    
    // rest length diagonal initilization
    for (int i = 0; i < nlp-1; i++) {
      for (int j = 0; j < nwp-1; j++) {
        l0d2[i][j] = PVector.dist(p[i+1][j], p[i][j+1]);
      }
    }
      
  }
  
  // Draw cloth
  void draw() {
    float du = 512/(numLengthParticals-1); //<>//
    float dv = 512/(numWidthParticals-1);    
    fill(255);
    for (int i = 0; i < numLengthParticals-1; i++) {
      for (int j = 0; j < numWidthParticals-1; j++) {
        beginShape();
        texture(img);
        vertex(p[i][j].x, p[i][j].y, p[i][j].z, i*du, j*dv);
        vertex(p[i+1][j].x, p[i+1][j].y, p[i+1][j].z, (i+1)*du, j*dv);
        vertex(p[i+1][j+1].x, p[i+1][j+1].y, p[i+1][j+1].z, (i+1)*du, (j+1)*dv);
        vertex(p[i][j+1].x, p[i][j+1].y, p[i][j+1].z, i*du, (j+1)*dv);
        endShape();
        
        
      }
    }
    
    /*
    beginShape();
    texture(img);
    for (int i = 0; i < numLengthParticals; i++){
      for (int j = 0; j < numWidthParticals; j++) {
        vertex(p[i][j].x, p[i][j].y, p[i][j].z, i*du, j*dv);
      }
    }
    endShape();*/
  }
  
  // Update vels. before pos.
  void update(Ball ball, Environment env) {
    // loop through horizontal direction
    for (int i = 0; i < numLengthParticals - 1; i++) {
      for (int j = 0; j < numWidthParticals; j++) {
        
        float f; // Force along thread
        PVector e = PVector.sub(p[i+1][j], (p[i][j])); // Unit length vetor from partical i,j to i+1,j
        
        /*
        print(e);
        println();
        print("p[i][j]:", p[i][j], "  p[i+1][j]: ", p[i+1][j]);*/
        
        float l = PVector.dist(p[i][j], (p[i+1][j])); // Distance between two points
        
        /*
        print(l);
        println();*/
        
        e = e.normalize(); // Normalize
        /*
        print(e);
        println();*/
        float v1 = PVector.dot(e, vn[i][j]);
        float v2 = PVector.dot(e, vn[i+1][j]);
        f = -ks * (l0h[i][j] - l) - kd * (v1 - v2);
        vn[i][j].add(PVector.mult(e, f));
        vn[i+1][j].sub(PVector.mult(e, f));
        /*
        print("vn[i][j]", vn[i][j], "  ");
        print("vn[i+1][j]", vn[i+1][j]);
        println();
        println();*/
        
        
      }
    }
    
    // loop through vertical direction
    for (int i = 0; i < numLengthParticals; i++) {
      for (int j = 0; j < numWidthParticals - 1; j++) {
        
        // left hand coordinate
        float f; // Force along thread
        PVector e = PVector.sub(p[i][j+1],p[i][j]); // Unit length vetor from partical i,j to i+1,j
        /*
        print(e);
        println();*/
        
        float l = PVector.dist(p[i][j], p[i][j+1]); // Distance between two points
        /*
        print(l);
        println();*/
        
        e = e.div(l); // Normalize
        /*
        print(e);
        println();*/
        
        float v1 = PVector.dot(e, vn[i][j]);
        float v2 = PVector.dot(e, vn[i][j+1]);
        f = -ks * (l0v[i][j] - l) - kd * (v1 - v2);
        vn[i][j].add(PVector.mult(e, f));
        vn[i][j+1].sub(PVector.mult(e, f));
        /*
        print("vn[i][j]", vn[i][j], "  ");
        print("vn[i][j+1]", vn[i][j+1]);
        println();
        println();*/
    
      }
    }
    
    // loop through diagonal direction
    for (int i = 0; i < numLengthParticals -1; i++) {
      for (int j = 0; j < numWidthParticals -1; j++) {
        
        // left hand coordinate
        float f; // Force along thread
        PVector e = PVector.sub(p[i+1][j+1],p[i][j]); // Unit length vetor from partical i,j to i+1,j
        
        float l = PVector.dist(p[i][j], p[i+1][j+1]); // Distance between two points
        
        e = e.div(l); // Normalize
        
        float v1 = PVector.dot(e, vn[i][j]);
        float v2 = PVector.dot(e, vn[i+1][j+1]);
        f = -ks * (l0d1[i][j] - l) - kd * (v1 - v2);
        vn[i][j].add(PVector.mult(e, f));
        vn[i+1][j+1].sub(PVector.mult(e, f));
    
      }
    }
    
    // loop through diagonal direction
    for (int i = 0; i < numLengthParticals -1; i++) {
      for (int j = 0; j < numWidthParticals - 1; j++) {
        
        // left hand coordinate
        float f; // Force along thread
        PVector e = PVector.sub(p[i][j+1], p[i+1][j]); // Unit length vetor from partical i,j to i+1,j
        
        float l = PVector.dist(p[i+1][j], p[i][j+1]); // Distance between two points
        
        e = e.div(l); // Normalize
        
        float v1 = PVector.dot(e, vn[i+1][j]);
        float v2 = PVector.dot(e, vn[i][j+1]);
        f = -ks * (l0d2[i][j] - l) - kd * (v1 - v2);
        vn[i+1][j].add(PVector.mult(e, f));
        vn[i][j+1].sub(PVector.mult(e, f));
    
      }
    }
    
    
    
    for(int i = 0; i < numWidthParticals; i++)
    {
      //vn[0][i].set(0, 0, 0); 
    }
    
    for (int i = 0; i < numLengthParticals; i++) {
      for (int j = 0; j < numWidthParticals; j++) {  
        // left hand coordinate
        vn[i][j].add(0, gravity, 0);
        p[i][j].add(vn[i][j]);
      }
    }
    
    detectCollision_Ball(ball);
    detectCollision_Env(env);
    
  }
  
  // Collision Detection
  void detectCollision_Ball(Ball ball)
  {
    for (int i = 0; i < numLengthParticals; i++) {
      for (int j = 0; j < numWidthParticals; j++) {
        float d = PVector.dist(p[i][j], ball.getPos());
        float l = ball.getR() + 3;
        if (d < l)
        {
          PVector n = PVector.sub(p[i][j], ball.getPos());
          n.normalize();
          PVector bounce = PVector.mult(n, PVector.dot(n, vn[i][j]));
          vn[i][j].sub(PVector.mult(bounce, 1.05));
          p[i][j].add(PVector.mult(n, ball.getR() - d + 3));
        }
      }
    }
  }
  
  void detectCollision_Env(Environment env) {
    float envX = env.getX();
    float envY = env.getY();
    float envZ = env.getZ();
    float envHalfW = env.getWidth()/2;
    float envHalfH = env.getHeight()/2;
    float envHalfL = env.getLength()/2;
    
    float threshold = 1/1000;
    
    for (int i = 0; i < numLengthParticals; i++) {
      for (int j = 0; j < numWidthParticals; j++) {
        boolean f = false;
        
        if (p[i][j].y < envY - envHalfH) // left hand top
        {
          vn[i][j].y = 0.0;
          p[i][j].y = envY - envHalfH;
          f = true;
        }
        
        if (p[i][j].y > envY + envHalfH) // left hand bottom
        {
          vn[i][j].y = 0.0;
          p[i][j].y = envY + envHalfH;
          f = true;
        }
        
        if (p[i][j].x < envX - envHalfW) // left
        {
          vn[i][j].x = 0.0;
          p[i][j].x = envX - envHalfW;
          f = true;
        }
        
        if (p[i][j].x > envX + envHalfW) // right
        {
          vn[i][j].x = 0.0;
          p[i][j].x = envX + envHalfW;
          f = true;
        }
        
        if (p[i][j].z < envZ - envHalfL) // behind
        {
          vn[i][j].z = 0.0;
          p[i][j].z = envZ - envHalfL;
          f = true;
        }
        
        if (p[i][j].z > envZ + envHalfL) // front
        {
          vn[i][j].z = 0.0;
          p[i][j].z = envZ + envHalfL;
          f = true;
        }
        
        if (f) {
          //-------------------------------------------------
          vn[i][j].mult(0.2); // friction
          
          if (vn[i][j].x < threshold)
          {
            vn[i][j].x = 0.0;
          }
          
          
          if (vn[i][j].y < threshold)
          {
            vn[i][j].y = 0.0;
          }
          
          if (vn[i][j].z < threshold)
          {
            vn[i][j].z = 0.0;
          }
        }
      }
    }
  
  }
  
  //---------------accessor-------------------
  PVector getV(int i, int j) {
    return vn[i][j];
  }
  
  //---------------mutator--------------------
  void setV(int i, int j, PVector v)
  {
    vn[i][j].set(v);
  }
}