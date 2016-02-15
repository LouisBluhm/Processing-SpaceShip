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
    stroke(barColor);
    fill(barColor);
    rect(barX, barY, barWidth, barHeight);
  }
  
}