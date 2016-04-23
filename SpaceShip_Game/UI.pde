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

  PFont font, font2;

  UI(float _x, float _y, String _title, color _c) {

    font = loadFont("SharpRetro-48.vlw");
    font2 = loadFont("pixelmix-bold-14.vlw");
    
    // font2 = loadFont("KenPixel-48.vlw");
    // textFont(font, 140);

    x = _x;
    y = _y;
    title = _title;
    c = _c;

    //font = createFont("KenPixel", 32);
    panel = loadImage("modal1.png");
    panel2 = loadImage("panel2.png");
    panel2hover = loadImage("panel2hover.png");

    shipSectionPanel = loadImage("ship_area.png");
    shipSectionX = width/2 - 515;
    shipSectionY = height - 130;

    travelPanel = loadImage("travel.png");

    eventPanel = loadImage("modal1.png");

    planetHoverPanel = loadImage("planet_hover.png");
    travelHover = loadImage("travel_hover.png");
  }

  void draw() {
    textFont(font, 140);
    fill(c);
    textAlign(0);
    textSize(19);
    text(title, x, y);
    //textFont(font);
  }

  void bar(float barX, float barY, float barWidth, float barHeight, color barColor, float barWidthTotal) {
    rectMode(CORNER);
    stroke(255);
    fill(0);
    rect(barX, barY, barWidthTotal, barHeight);
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

  void text_string(float x, float y, String string, int font_size, color c, int align, PFont text_font) {
    textFont(text_font, 140);
    fill(c);
    textAlign(align);
    textSize(font_size);
    text(string, x, y);
  }

  void drawEventPanel() {
    image(eventPanel, width/2, height/2);
  }

  void responsePanelClose() {
    rectMode(CENTER);
    if (rectHover(width/2-100, height/2 + 170, 200, 25)) {
      fill(30, 30, 30);
    } else {
      fill(51, 51, 51);
    } 
    rect(width/2, height/2+180, 200, 25);
    text_string(width/2, height/2+185, "Click here to close", 12, color(255), CENTER, font2);
    if (rectHover(width/2-100, height/2+170, 200, 25) && mousePressed) {
      mainGame.eventPanelClosed = true;
      mainGame.eventOpen = false;
      if(mainShip.shipAlive == false) {
        mainGame.gameOver();
      }
      for(int i = 0; i < mainGame.crew.size(); i++) {
        mainGame.crew.get(i).stat_increase = true;
      }
      if(mainGame.newEvent.crew_gained) {
        mainGame.crew.add(new Crew(mainGame.crew_names[(int)(Math.random() * mainGame.crew_names.length)], mainGame.crew_roles[(int)(Math.random() * mainGame.crew_roles.length)], mainGame.last_crew_position_x + 60, 10, mainGame.last_crew_position_x + 60, 45));
        mainGame.last_crew_position_x += 60;
        mainGame.newEvent.crew_gained = false;
       // planetNames[(int)(Math.random() * planetNames.length)];
      }
    }
  }

  void shipSectionDisplay() {
    image(shipSectionPanel, shipSectionX, shipSectionY);
    mainShip.shipSectionDraw();
  }

  boolean hoverDetection(float x, float y, float diameter) {
    if (dist(mouseX, mouseY, x, y) < diameter * 0.5) {
      println("hover detected");
      return true;
    } else {
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
    text_string(textX, y-150, "Planet: ", textSizePlanet, c, LEFT, font);
    text_string(textXside, y-150, mainGame.planet.planetNameRandom, textSizePlanet, c, RIGHT, font);
    //Species + Hostility
    text_string(textX, y-120, "Main Species: ", textSize, c, LEFT, font);
    text_string(textXside, y-120, mainGame.planet.planetSpeciesRandom, textSize, c, RIGHT, font);
    text_string(textX, y-100, "Hostility: ", textSize, c, LEFT, font);

    if (mainGame.planet.planetSpeciesHostility.equals("DANGEROUS")) {
      hostility = color(255, 0, 0);
    }
    if (mainGame.planet.planetSpeciesHostility.equals("PASSIVE")) {
      hostility = color(102, 135, 231);
    }
    if (mainGame.planet.planetSpeciesHostility.equals("NEUTRAL")) {
      hostility = color(255);
    }
    if (mainGame.planet.planetSpeciesHostility.equals("N/A")) {
      hostility = color(150, 76, 150);
    }
    text_string(textXside, y-100, mainGame.planet.planetSpeciesHostility, textSize, hostility, RIGHT, font);


    //Other
    text_string(textX, y-60, "Circumference: ", textSize, c, LEFT, font);
    text_string(textXside, y-60, mainGame.planet.planetCircumference + " km", textSize, c, RIGHT, font);
    text_string(textX, y-40, "Axial Tilt: ", textSize, c, LEFT, font);
    text_string(textXside, y-40, mainGame.planet.planetTilt + " RAD", textSize, c, RIGHT, font);
    text_string(textX, y-20, "Surface Temp: ", textSize, c, LEFT, font);
    text_string(textXside, y-20, mainGame.planet.planetTemperature + " DEG", textSize, c, RIGHT, font);
  }
}