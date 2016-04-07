class UI {
  
  //PFont font;
  
  float x, y;
  String title;
  color c;
  PImage panel, panel2, panel2hover;
  PImage inv;
  PImage shipSectionPanel;
  PImage travelPanel;
  PImage eventPanel;

  float shipSectionX, shipSectionY;
  
  UI(float _x, float _y, String _title, color _c) {
    
    x = _x;
    y = _y;
    title = _title;
    c = _c;
    
    //font = createFont("KenPixel", 32);
    panel = loadImage("modal1.png");
    panel2 = loadImage("panel2.png");
    panel2hover = loadImage("panel2hover.png");
    
    shipSectionPanel = loadImage("shipSectionPanel.png");
    shipSectionX = width/2 - 515;
    shipSectionY = height - 130;
    
    travelPanel = loadImage("travel.png");
    
    eventPanel = loadImage("modal1.png");
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
    text_string(buttonX, buttonY + 5, title, 14, color(255), CENTER);
  }
  
  void text_string(float x, float y, String string, int font_size, color c, int align) {
    fill(c);
    textAlign(align);
    textSize(font_size);
    text(string, x, y);
  }
  
  void eventPanelDisplay() {
    image(eventPanel, width/2, height/2);
    text_string(width/2, height/2, eventChecker.randomEventString(), 16, color(255), CENTER);
    //Response 1
    text_string(width/2 - 300, height/2 + 50, "1. " + eventChecker.eventResponses(0), 14, color(255), LEFT);
    //Response 2
    text_string(width/2 - 300, height/2 + 70, "2. "+ eventChecker.eventResponses(1), 14, color(255), LEFT);
  }
  
  void shipSectionDisplay() {
    image(shipSectionPanel, shipSectionX, shipSectionY);
  }
  
  void travelPanelDisplay() {
    image(travelPanel, width/2, height/2);
    travelPanelSelection();
  }
  
  void travelPanelSelection() {
    float[] travelID = {400, height/2, 500, height/2+75, 600, height/2-50, 750, height/2+10, 770, height/2-150, 800, height/2+200};
    int systemSize = 10;
    // String planet1 = mainGame.planetNameRandom;
    //translate(width/2, height/2);
    fill(255);

    for(int i = 0; i < travelID.length; i += 2) {
      ellipse(travelID[i], travelID[i+1], systemSize, systemSize);
      if(hoverDetection(travelID[i], travelID[i+1], systemSize)) {
        ellipse(travelID[i], travelID[i+1], 12, 12);
      }
    }
    //for(int i = 0; i < travelID.length; i++) {
    //  for(int n = 1; n < travelID.length; n+=2) {
    //    if(hoverDetection(travelID[i], travelID[n], systemSize)) {

    //      ellipse(travelID[i], travelID[n], 12, 12);
    //      // line(travelID[i], travelID[n], travelID[i+1], travelID[n+1]);
          
    //      travelPlanetInfo(travelID[0], travelID[n], n);
          
    //      println("i[pos] >>> " + travelID[i]);
    //      println("i >>> " + i);
    //      println("n >>> " + n);
    //      //println("X1: " + travelID[i] + ">>>" + travelID[0]);
    //      //println("Y1: " + travelID[n] + ">>>" + travelID[1]);
    //      //println("X2: " + travelID[i+2] + ">>>" + travelID[2]);
    //      //println("Y2: " + travelID[n+2] + ">>>" + travelID[3]);
    //    }
    //  }
    //}
  }
  
  void travelPlanetInfo(float x, float y, int planetNum) {
    mainGame.travelInfo.modal(x, y, 50, 50, color(89, 89, 89));
    mainGame.travelInfo.text_string(x, y, mainGame.planet.planetNames[planetNum], 12, color(255), CENTER);
  }
  
  boolean hoverDetection(float x, float y, float diameter) {
    if(dist(mouseX, mouseY, x, y) < diameter * 0.5) {
      println("hover detected");
      return true;
    }
    else {
      return false;
    }
  }
  
}