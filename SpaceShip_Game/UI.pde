class UI {
  
  //PFont font;
  
  float x, y;
  String title;
  color c;
  PImage panel, panel2, panel2hover;
  PImage inv;
  
  UI(float _x, float _y, String _title, color _c) {
    
    x = _x;
    y = _y;
    title = _title;
    c = _c;
    
    //font = createFont("KenPixel", 32);
    
    panel = loadImage("modal1.png");
    panel2 = loadImage("panel2.png");
    panel2hover = loadImage("panel2hover.png");
  }
  
  void draw() {
    fill(c);
    textAlign(0);
    textSize(12);
    text(title, x, y);
    //textFont(font);
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
    //rect(modalX, modalY, modalWidth, modalHeight);
    //image(panel2, width/2, height/2);
  }
  
  void button(float buttonX, float buttonY) {
    if(mainGame.buttonHover == false) {
      image(panel2, buttonX, buttonY);
    }
    if(mainGame.buttonHover == true) {
      image(panel2hover, buttonX, buttonY);
    }
    text_string(buttonX, buttonY + 5, title, 14, color(255));
  }
  
  void text_string(float x, float y, String string, int font_size, color c) {
    fill(c);
    textAlign(CENTER);
    textSize(font_size);
    text(string, x, y);
  }
  
}