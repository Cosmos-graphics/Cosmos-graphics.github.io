class DObject {
  int numLengthParticles;
  int numWidthParticles;
  int numHeightParticles;
  PVector[][][] p; //  Particles position array
  PVector[][][] vn; //  Particles speed array
  float l0v; //  Particles rest length vertical
  float l0h; //  Particles rest length horizontal
  float l0l; //  Particles rest length longitudinal

  float left;
  float right;
  float front;
  float back;
  float top;
  float bottom;


  DObject(int nlp, int nwp, int nhp, float l, float r, float f, float b, float t, float bo) {
    numLengthParticles = nlp;
    numWidthParticles = nwp;
    numHeightParticles = nhp;
    p = new PVector[nlp][nwp][nhp];
    vn = new PVector[nlp][nwp][nhp];

    // initial boundary of object
    left = l;
    right = r;
    front = f;
    back = b;
    top = t;
    bottom = bo;

    l0v = (right - left)/(nlp-1);
    l0h = (front - back)/(nwp-1);
    l0l = (bottom - top)/(nhp-1);

    float xdiv = (right - left) / (nlp-1);
    float ydiv = (bottom - top) / (nhp-1);
    float zdiv = (front - back) / (nwp-1);

    // position initilization
    for (int i = 0; i < nlp; i++) {
      for (int j = 0; j < nwp; j++) {
        for (int k = 0; k < nhp; k++) {
          p[i][j][k] = new PVector(left + i*xdiv, top + k*ydiv, back + j*zdiv);
        }
      }
    }

    // speed initilization
    for (int i = 0; i < nlp; i++) {
      for (int j = 0; j < nwp; j++) {
        for (int k = 0; k < nhp; k++) {
          vn[i][j][k] = new PVector(0, 0, 0);
        }
      }
    }
  }

  // -------------------------Draw----------------------------------
  void draw () {
    fill(0, 255, 255);
    // top surface -- 
    for (int i = 0; i < numLengthParticles-1; i++) {
      for (int j = 0; j < numWidthParticles-1; j++) {
        beginShape(QUADS);
        vertex(p[i][j][0].x, p[i][j][0].y, p[i][j][0].z);
        vertex(p[i+1][j][0].x, p[i+1][j][0].y, p[i+1][j][0].z);
        vertex(p[i+1][j+1][0].x, p[i+1][j+1][0].y, p[i+1][j+1][0].z);
        vertex(p[i][j+1][0].x, p[i][j+1][0].y, p[i][j+1][0].z);
        endShape();
      }
    }
    
    // bottom surface -- 
    for (int i = 0; i < numLengthParticles-1; i++) {
      for (int j = 0; j < numWidthParticles-1; j++) {
        beginShape(QUADS);
        vertex(p[i][j][numHeightParticles-1].x, p[i][j][numHeightParticles-1].y, p[i][j][numHeightParticles-1].z);
        vertex(p[i+1][j][numHeightParticles-1].x, p[i+1][j][numHeightParticles-1].y, p[i+1][j][numHeightParticles-1].z);
        vertex(p[i+1][j+1][numHeightParticles-1].x, p[i+1][j+1][numHeightParticles-1].y, p[i+1][j+1][numHeightParticles-1].z);
        vertex(p[i][j+1][numHeightParticles-1].x, p[i][j+1][numHeightParticles-1].y, p[i][j+1][numHeightParticles-1].z);
        endShape();
      }
    }
    
    // right surface --
    for (int i = 0; i < numWidthParticles-1; i++) {
      for (int j = 0; j < numHeightParticles-1; j++) {
        beginShape(QUADS);
        vertex(p[numLengthParticles-1][i][j].x, p[numLengthParticles-1][i][j].y, p[numLengthParticles-1][i][j].z);
        vertex(p[numLengthParticles-1][i+1][j].x, p[numLengthParticles-1][i+1][j].y, p[numLengthParticles-1][i+1][j].z);
        vertex(p[numLengthParticles-1][i+1][j+1].x, p[numLengthParticles-1][i+1][j+1].y, p[numLengthParticles-1][i+1][j+1].z);
        vertex(p[numLengthParticles-1][i][j+1].x, p[numLengthParticles-1][i][j+1].y, p[numLengthParticles-1][i][j+1].z);
        endShape();
      }
    }
    
    // left surface --
    for (int i = 0; i < numWidthParticles-1; i++) {
      for (int j = 0; j < numHeightParticles-1; j++) {
        beginShape(QUADS);
        vertex(p[0][i][j].x, p[0][i][j].y, p[0][i][j].z);
        vertex(p[0][i+1][j].x, p[0][i+1][j].y, p[0][i+1][j].z);
        vertex(p[0][i+1][j+1].x, p[0][i+1][j+1].y, p[0][i+1][j+1].z);
        vertex(p[0][i][j+1].x, p[0][i][j+1].y, p[0][i][j+1].z);
        endShape();
      }
    }
    
    // back surface -- 
    for (int i = 0; i < numLengthParticles-1; i++) {
      for (int j = 0; j < numHeightParticles-1; j++) {
        beginShape(QUADS);
        vertex(p[i][0][j].x, p[i][0][j].y, p[i][0][j].z);
        vertex(p[i+1][0][j].x, p[i+1][0][j].y, p[i+1][0][j].z);
        vertex(p[i+1][0][j+1].x, p[i+1][0][j+1].y, p[i+1][0][j+1].z);
        vertex(p[i][0][j+1].x, p[i][0][j+1].y, p[i][0][j+1].z);
        endShape();
      }
    }
    
    // front surface -- 
    for (int i = 0; i < numLengthParticles-1; i++) {
      for (int j = 0; j < numHeightParticles-1; j++) {
        beginShape(QUADS);
        vertex(p[i][numWidthParticles-1][j].x, p[i][numWidthParticles-1][j].y, p[i][numWidthParticles-1][j].z);
        vertex(p[i+1][numWidthParticles-1][j].x, p[i+1][numWidthParticles-1][j].y, p[i+1][numWidthParticles-1][j].z);
        vertex(p[i+1][numWidthParticles-1][j+1].x, p[i+1][numWidthParticles-1][j+1].y, p[i+1][numWidthParticles-1][j+1].z);
        vertex(p[i][numWidthParticles-1][j+1].x, p[i][numWidthParticles-1][j+1].y, p[i][numWidthParticles-1][j+1].z);
        endShape();
      }
    }
    
  }
  
  //-------------------detect collision with Env----------------------
  void detectCollision_Env(Environment env) {
    float envX = env.getX();
    float envY = env.getY();
    float envZ = env.getZ();
    float envHalfW = env.getWidth()/2;
    float envHalfH = env.getHeight()/2;
    float envHalfL = env.getLength()/2;
    
    float threshold = 1/1000;
    float bounce_factor = -0.6;
    
    for (int i = 0; i < numLengthParticles; i++) {
      for (int j = 0; j < numWidthParticles; j++) {
        for (int k = 0; k < numHeightParticles; k++) {
          boolean f = false;
          
          if (p[i][j][k].y < envY - envHalfH) // left hand bottom
          {
            vn[i][j][k].y = bounce_factor * vn[i][j][k].y;
            p[i][j][k].y = envY - envHalfH;
            f = true;
          }
          
          if (p[i][j][k].y > envY + envHalfH) // left hand top
          {
            vn[i][j][k].y = bounce_factor * vn[i][j][k].y;
            p[i][j][k].y = envY + envHalfH;
            f = true;
          }
          
          if (p[i][j][k].x < envX - envHalfW) // left
          {
            vn[i][j][k].x = bounce_factor * vn[i][j][k].x;
            p[i][j][k].x = envX - envHalfW;
            f = true;
          }
          
          if (p[i][j][k].x > envX + envHalfW) // right
          {
            vn[i][j][k].x = bounce_factor * vn[i][j][k].x;
            p[i][j][k].x = envX + envHalfW;
            f = true;
          }
          
          if (p[i][j][k].z < envZ - envHalfL) // behind
          {
            vn[i][j][k].z = bounce_factor * vn[i][j][k].z;
            p[i][j][k].z = envZ - envHalfL;
            f = true;
          }
          
          if (p[i][j][k].z > envZ + envHalfL) // front
          {
            vn[i][j][k].z = bounce_factor * vn[i][j][k].z;
            p[i][j][k].z = envZ + envHalfL;
            f = true;
          }
          
          if (f) {
            //-------------------------------------------------
            vn[i][j][k].mult(0.2); // friction
            
            if (vn[i][j][k].x < threshold)
            {
              vn[i][j][k].x = 0.0;
            }
            
            
            if (vn[i][j][k].y < threshold)
            {
              vn[i][j][k].y = 0.0;
            }
            
            if (vn[i][j][k].z < threshold)
            {
              vn[i][j][k].z = 0.0;
            }
          }
        }
      }
    }
  }
  
  // Collision Detection
  void detectCollision_Ball(Ball ball)
  {
    for (int i = 0; i < numLengthParticles; i++) {
      for (int j = 0; j < numWidthParticles; j++) {
        for (int k = 0; k < numHeightParticles; k++) {
          float d = PVector.dist(p[i][j][k], ball.getPos());
          float l = ball.getR() + 3;
          if (d < l)
          {
            PVector n = PVector.sub(p[i][j][k], ball.getPos());
            n.normalize();
            PVector bounce = PVector.mult(n, PVector.dot(n, vn[i][j][k]));
            vn[i][j][k].sub(PVector.mult(bounce, 1.05));
            p[i][j][k].add(PVector.mult(n, ball.getR() - d + 3));
          }
        }
      }
    }
  }
  
  // Update vels. before pos.
  void update(Ball ball, Environment env) {
    // loop through horizontal direction //<>//
    for (int i = 0; i < numLengthParticles - 1; i++) {
      for (int j = 0; j < numWidthParticles; j++) {
        for (int k = 0; k < numHeightParticles; k++) {
        
          float f; // Force along thread
          PVector e = PVector.sub(p[i+1][j][k], (p[i][j][k])); // Unit length vetor from partical i,j to i+1,j
          
          float l = PVector.dist(p[i][j][k], (p[i+1][j][k])); // Distance between two points
          
          e = e.normalize(); // Normalize
          float v1 = PVector.dot(e, vn[i][j][k]);
          float v2 = PVector.dot(e, vn[i+1][j][k]);
          f = -ks * (l0h - l) - kd * (v1 - v2);
          vn[i][j][k].add(PVector.mult(e, f));
          vn[i+1][j][k].sub(PVector.mult(e, f));
        }
      }
    }
    
    // loop through vertical direction //<>//
    for (int i = 0; i < numLengthParticles; i++) {
      for (int j = 0; j < numWidthParticles - 1; j++) {
        for (int k = 0; k < numHeightParticles; k++) {
        
          // left hand coordinate
          float f; // Force along thread
          PVector e = PVector.sub(p[i][j+1][k],p[i][j][k]); // Unit length vetor from partical i,j to i+1,j
          
          float l = PVector.dist(p[i][j][k], p[i][j+1][k]); // Distance between two points
          
          e = e.div(l); // Normalize
          
          float v1 = PVector.dot(e, vn[i][j][k]);
          float v2 = PVector.dot(e, vn[i][j+1][k]);
          f = -ks * (l0v - l) - kd * (v1 - v2);
          vn[i][j][k].add(PVector.mult(e, f));
          vn[i][j+1][k].sub(PVector.mult(e, f));
        }
      }
    }
    
    // loop through longitudinal direction //<>//
    for (int i = 0; i < numLengthParticles; i++) {
      for (int j = 0; j < numWidthParticles; j++) {
        for (int k = 0; k < numHeightParticles - 1; k++) {
        
          // left hand coordinate
          float f; // Force along thread
          PVector e = PVector.sub(p[i][j][k+1],p[i][j][k]); // Unit length vetor from partical i,j to i+1,j
          
          float l = PVector.dist(p[i][j][k], p[i][j][k+1]); // Distance between two points
          
          e = e.div(l); // Normalize
          
          float v1 = PVector.dot(e, vn[i][j][k]);
          float v2 = PVector.dot(e, vn[i][j][k+1]);
          f = -ks * (l0l - l) - kd * (v1 - v2);
          vn[i][j][k].add(PVector.mult(e, f));
          vn[i][j][k+1].sub(PVector.mult(e, f));
        }
      }
    }
    
    
    for (int i = 0; i < numLengthParticles; i++) { //<>//
      for (int j = 0; j < numWidthParticles; j++) {
        for (int k = 0; k < numHeightParticles; k++) {
          // left hand coordinate
          vn[i][j][k].add(0, gravity, 0);
          p[i][j][k].add(vn[i][j][k]);
        }
      }
    }
    
    detectCollision_Ball(ball);
    detectCollision_Env(env); //<>//
    
  }
}