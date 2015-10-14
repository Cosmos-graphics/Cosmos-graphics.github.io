class Environment {
  float x;
  float y;
  float z;
  float w;
  float l;
  float h;
  
  Environment (float pos_x, float pos_y, float pos_z, float Width, float Height, float Length) {
    x = pos_x;
    y = pos_y;
    z = pos_z;
    w = Width;
    l = Length;
    h = Height;
  }
  
  void show() {
    noFill();
    pushMatrix();
    stroke(255);
    translate(x, y, z);
    box(w, h, l);
    noStroke();
    popMatrix();
  }
  
  //---------------accessor--------------
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float getZ() {
    return z;
  }
  
  float getWidth() {
    return w;
  }
  
  float getLength() {
    return l;
  }
  
  float getHeight() {
    return h;
  }
  
}