float g = 0.05;
float bounce_factor = -.7;

class Ball{
  
  PVector pos;
  float r;
  float vx;
  float vy;
  float vz;
  
  Ball(float x, float y, float z, float radius, float Vx, float Vy, float Vz ) {
     pos = new PVector(x, y, z);
     r = radius;
     
     vx = Vx;
     vy = Vy;
     vz = Vz;
  }
  
  void draw() {
    pushMatrix();
    fill(255, 0, 0);
    translate(pos.x, pos.y, pos.z);
    sphere(r);
    popMatrix();
  }
  
  void accelerate() {
    vy += g;
  }
  
  void move(float envX, float envY, float envZ, float envHalfW, float envHalfH, float envHalfL) {
    accelerate();
    pos.x += vx;
    pos.y += vy;
    pos.z += vz;
    
    detect_bounce(envX, envY, envZ, envHalfW, envHalfH, envHalfL);
  }
  
  void detect_bounce (float envX, float envY, float envZ, float envHalfW, float envHalfH, float envHalfL) {
    boolean f = false;
    
    if (pos.x + r > envX + envHalfW) { // right
      pos.x = envX + envHalfW - r;
      vx *= bounce_factor;
    }
    if (pos.x - r < envX - envHalfW) { // left
      pos.x = r + envX - envHalfW;
      vx *= bounce_factor;
    }
    if (pos.y + r > envY + envHalfH) { // top
      pos.y = envY + envHalfH - r;
      vy *= bounce_factor;
    }
    if (pos.y - r < envY - envHalfH) { // bottom
      pos.y = r + envY - envHalfH;
      vy *= bounce_factor;
    }
    if (pos.z + r > envZ + envHalfL) { // front
      pos.z = envZ + envHalfL - r;
      vz *= bounce_factor;
    }
    if (pos.z - r < envZ - envHalfL) { // behind
      pos.z = r + envZ - envHalfL;
      vz *= bounce_factor;
    }
    
    float threshold = 1/1000;
    
    if (f) {
          //-------------------------------------------------
          vx *= 0.7; // friction
          vy *= 0.7;
          vz *= 0.7;
          
          if (vx < threshold)
          {
            vx = 0.0;
          }
          
          if (vy < threshold)
          {
            vy = 0.0;
          }
          
          if (vz < threshold)
          {
            vz = 0.0;
          }
        }
  }
  
  //---------------accessor----------------
  PVector getPos(){
    return pos;
  }
  
  float getR() {
    return r;
  }
  
  float getVx() {
    return vx;
  }
  
  float getVy() {
    return vx;
  }
  
  float getVz() {
    return vz;
  }
  
  //---------------mutator----------------
  void setVx(float Vx) {
    vx = Vx;
  }
  
  void setVy(float Vy) {
    vy = Vy;
  }
  
  void setVz(float Vz) {
    vz = Vz;
  }
  
  
  
  
}