class Ship {

  float shipX, shipY;
  
  PImage shipImageDefault, shipImageEngine, shipImageMain, shipImagePilot, shipImageArrayTop, shipImageArrayBottom;
  PImage ship_selection;
  
  boolean shipEngineOpen = false;
  boolean shipMainOpen = false;
  boolean shipPilotOpen = false;
  boolean shipArrayTopOpen = false;
  boolean shipArrayBottomOpen = false;
  
  boolean shipAlive = true;
  
  //Ship stats
  String[] shipSections = {"Engines", "Crew Quarters", "Bridge", "Solar Array 1", "Solar Array 2"};
  float shipEngineHP = 100;
  float shipMainHP = 100;
  float shipPilotHP = 100;
  float shipArrayTopHP = 100;
  float shipArrayBottomHP = 100;
  
  //Realtime stats
  float shipEngineCurrentHP = 100;
  float shipMainCurrentHP = 100;
  float shipPilotCurrentHP = 100;
  float shipArrayTopCurrentHP = 100;
  float shipArrayBottomCurrentHP = 100;
  String shipCurrentSection;
  float shipCurrentSectionHP;
  
  int shipMissiles = 5;
  
  UI shipSection;
  
  Weapon weapon1;
  
  Dropship dropship;

  Ship(float _shipX, float _shipY) {

    shipX = _shipX;
    shipY = _shipY;

    shipImageDefault = loadImage("mainShip_h.png");
    shipImageEngine = loadImage("mainShip_h_engine.png");
    shipImageMain = loadImage("mainShip_h_main.png");
    shipImagePilot = loadImage("mainShip_h_pilot.png");
    shipImageArrayTop = loadImage("mainShip_h_arrayTop.png");
    shipImageArrayBottom = loadImage("mainShip_h_arrayBottom.png");
    ship_selection = shipImageDefault;
    
    shipSection = new UI(width/2-700, height/2+225, color(255));
    
    weapon1 = new Weapon(800, 25, "missile");
    dropship = new Dropship();
  }

  void draw() {
    imageMode(CENTER);
    image(ship_selection, shipX, shipY);

    if(mousePressed && (mainGame.eventOpen == false || mainGame.eventPanelClosed == true)) {
      shipEngineSelection();
      shipMainSelection();
      shipPilotSelection();
      shipArraySelection();
    } else {
      ship_selection = shipImageDefault;
    }
    checkStatus();
    
    weapon1.draw();
    
    dropship.draw();
  }
  
  void checkStatus() {
    if(mainGame.shipHealthCurrent <= 0) {
      shipAlive = false;
    }
  }
  
  void shipSectionDraw() {
    shipSection.text_string(shipSection.x, shipSection.y, "Section: " + shipCurrentSection, 26, shipSection.c, LEFT, shipSection.font);
    shipSection.text_string(shipSection.x, shipSection.y + 25, "Condition: ", 21, color(255), LEFT, shipSection.font);
    shipSection.text_string(shipSection.x + 110, shipSection.y + 25, "" + shipCurrentSectionHP, 21, colorHealthChanger(shipCurrentSectionHP), LEFT, shipSection.font);
  }
  
  color colorHealthChanger(float hp) {
    if(hp > 50) {
      return color(0, 255, 0);
    }
    if(hp <= 50) {
      return color(255, 71, 25);
    }
    if(hp <= 25) {
      return color(255, 0, 0);
    }
    return color(255);
  }
  
  void shipEngineSelection() {
    if(rectHover(width/2-600, height/2-70, 250, 140)) {
      ship_selection = shipImageEngine;
      shipEngineOpen = true;
      shipCurrentSection = shipSections[0];
      shipCurrentSectionHP = shipEngineCurrentHP;
    } else {
      shipEngineOpen = false;
    }
  }
  void shipMainSelection() {
    if(rectHover(width/2-350, height/2-50, 170, 100)) {
      ship_selection = shipImageMain;
      shipMainOpen = true;
      shipCurrentSection = shipSections[1];
      shipCurrentSectionHP = shipMainCurrentHP;
    } else {
      shipMainOpen = false;
    }
  }
  void shipPilotSelection() {
    if(rectHover(width/2-180, height/2-50, 170, 100)) {
      ship_selection = shipImagePilot;
      shipPilotOpen = true;
      shipCurrentSection = shipSections[2];
      shipCurrentSectionHP = shipPilotCurrentHP;
    } else {
      shipPilotOpen = false;
    }
  }
  void shipArraySelection() {
    if(rectHover(width/2-350, height/2-170, 170, 120)) {
      ship_selection = shipImageArrayTop;
      shipArrayTopOpen = true;
      shipCurrentSection = shipSections[3];
      shipCurrentSectionHP = shipArrayTopCurrentHP;
    } else if(rectHover(width/2-350, height/2+50, 170, 120)) {
      ship_selection = shipImageArrayBottom;
      shipArrayBottomOpen = true;
      shipCurrentSection = shipSections[4];
      shipCurrentSectionHP = shipArrayBottomCurrentHP;
    } else {
      shipArrayTopOpen = false;
      shipArrayBottomOpen = false;
    }
  }
}