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
  PImage planetHoverPanel;
  PImage travelHover;
  
  color hostility;

  float shipSectionX, shipSectionY;
  
  PFont font;
  
  UI(float _x, float _y, String _title, color _c) {
    
    font = loadFont("SharpRetro-48.vlw");
    //font = loadFont("KenPixel-48.vlw");
    textFont(font, 140);
    
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
    
    planetHoverPanel = loadImage("planet_hover.png");
    travelHover = loadImage("travel_hover.png");
  }
  
  void draw() {
    fill(c);
    textAlign(0);
    textSize(19);
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
    text_string(buttonX, buttonY + 5, title, 19, color(255), CENTER);
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
        imageMode(CORNER);
        image(travelHover, travelID[i], travelID[i+1]);
        text_string(travelID[i]+25, travelID[i+1]+25, mainGame.planet.planetNameRandom, 25, color(255), LEFT);
        ellipse(travelID[i], travelID[i+1], 12, 12);
      }
    }
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
  
  void planetHoverInfo() {
    image(planetHoverPanel, x, y);
    float textX = x - 165;
    float textXside = x + 165;
    int textSize = 20;
    int textSizePlanet = 24;
    line(textX, y-145, textXside, y-145);
    //Planet name
    text_string(textX, y-150, "Planet: ", textSizePlanet, c, LEFT);
    text_string(textXside, y-150, mainGame.planet.planetNameRandom, textSizePlanet, c, RIGHT);
    //Species + Hostility
    text_string(textX, y-120, "Main Species: ", textSize, c, LEFT);
    text_string(textXside, y-120, mainGame.planet.planetSpeciesRandom, textSize, c, RIGHT);
    text_string(textX, y-100, "Hostility: ", textSize, c, LEFT);
    
    if(mainGame.planet.planetSpeciesHostility.equals("DANGEROUS")) {
      hostility = color(255, 0, 0);
    }
    if(mainGame.planet.planetSpeciesHostility.equals("PASSIVE")) {
      hostility = color(102, 135, 231);
    }
    if(mainGame.planet.planetSpeciesHostility.equals("NEUTRAL")) {
      hostility = color(255);
    }
    if(mainGame.planet.planetSpeciesHostility.equals("N/A")) {
      hostility = color(150, 76, 150);
    }
    text_string(textXside, y-100, mainGame.planet.planetSpeciesHostility, textSize, hostility, RIGHT);
    
    
    //Other
    text_string(textX, y-60, "Circumference: ", textSize, c, LEFT);
    text_string(textXside, y-60, mainGame.planet.planetCircumference + " km", textSize, c, RIGHT);
    text_string(textX, y-40, "Axial Tilt: ", textSize, c, LEFT);
    text_string(textXside, y-40, mainGame.planet.planetTilt + " RAD", textSize, c, RIGHT);
    text_string(textX, y-20, "Surface Temp: ", textSize, c, LEFT);
    text_string(textXside, y-20, mainGame.planet.planetTemperature + " DEG", textSize, c, RIGHT);
  }
  
}