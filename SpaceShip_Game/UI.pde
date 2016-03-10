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
    textAlign(0);
    text(title, x, y);
  }
  
  void bar(float barX, float barY, float barWidth, float barHeight, color barColor) {
    rectMode(CORNER);
    stroke(barColor);
    fill(barColor);
    rect(barX, barY, barWidth, barHeight);
  }
  
  void modal(float modalX, float modalY, float modalWidth, float modalHeight, color modalColor) {
    translate(0, 0, 100);
    rectMode(CENTER);
    fill(modalColor);
    stroke(255);
    rect(modalX, modalY, modalWidth, modalHeight);
  }
  
  void button(float buttonX, float buttonY, float buttonWidth, float buttonHeight, color buttonColor) {
    rectMode(CENTER);
    fill(buttonColor);
    stroke(255);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(44, 44, 44);
    rect(buttonX, buttonY + 17, buttonWidth, 5);
    text_string(buttonX, buttonY, title, color(255));
  }
  
  void text_string(float x, float y, String string, color c) {
    fill(c);
    textAlign(CENTER);
    text(string, x, y);
  }
}