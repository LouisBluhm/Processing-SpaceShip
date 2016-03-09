class Tile {
  
  float x, y;
  float dx, dy;
  color c;
  
  Tile(float _x, float _y, float _dx, float _dy, color _c) {
    
    x = _x;
    y = _y;
    dx = _dx;
    dy = _dy;
    c = _c;
    
  }
  
  void display() {
    rectMode(CENTER);
    stroke(0);
    fill(c);
    rect(x, y, dx, dy, 3);
  }
}