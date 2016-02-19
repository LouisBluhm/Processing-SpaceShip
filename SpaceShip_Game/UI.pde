
class UI {
  
  float x, y;
  String title;
  color c;
  
  UI(float _x, float _y, String _title, color _c) {
    
    x = _x;
    y = _y;
    title = _title;
    c = _c;
    
  }
  
  void draw() {
    fill(c);
    text(title, x, y);
   
  }
  
  void bar(float barX, float barY, float barWidth, float barHeight, color barColor) {
    rectMode(CORNER);
    stroke(barColor);
    fill(barColor);
    rect(barX, barY, barWidth, barHeight);
  }
  
  void modal(float modalX, float modalY, float modalWidth, float modalHeight, color modalColor) {
    rectMode(CENTER);
    fill(modalColor);
    rect(modalX, modalY, modalWidth, modalHeight);
  }
}