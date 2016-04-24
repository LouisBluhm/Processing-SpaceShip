class Ship {

  // Ship coordinates
  float shipX, shipY;
  
  // Different images for ship selection
  PImage shipImageDefault, shipImageEngine, shipImageMain, shipImagePilot, shipImageArrayTop, shipImageArrayBottom;
  PImage ship_selection;
  
  // Ship section states
  boolean shipEngineOpen = false;
  boolean shipMainOpen = false;
  boolean shipPilotOpen = false;
  boolean shipArrayTopOpen = false;
  boolean shipArrayBottomOpen = false;
  
  boolean shipAlive = true;
  
  // Ship stats
  String[] shipSections = {"Engines", "Crew Quarters", "Bridge", "Solar Array 1", "Solar Array 2"};
  float shipEngineHP = 100;
  float shipMainHP = 100;
  float shipPilotHP = 100;
  float shipArrayTopHP = 100;
  float shipArrayBottomHP = 100;
  
  // Realtime stats
  float shipEngineCurrentHP = 100;
  float shipMainCurrentHP = 100;
  float shipPilotCurrentHP = 100;
  float shipArrayTopCurrentHP = 100;
  float shipArrayBottomCurrentHP = 100;
  String shipCurrentSection;
  float shipCurrentSectionHP;
  
  // Starting missile count
  int shipMissiles = 5;
  
  // shipSection UI object
  UI shipSection;
  
  // weapon object (missiles)
  Weapon weapon1;
  
  // dropship object (for charging energy cells)
  Dropship dropship;

  Ship(float _shipX, float _shipY) {

    shipX = _shipX;
    shipY = _shipY;

    // Load the various ship section images
    shipImageDefault = loadImage("assets/ship/mainShip_h.png");
    shipImageEngine = loadImage("assets/ship/mainShip_h_engine.png");
    shipImageMain = loadImage("assets/ship/mainShip_h_main.png");
    shipImagePilot = loadImage("assets/ship/mainShip_h_pilot.png");
    shipImageArrayTop = loadImage("assets/ship/mainShip_h_arrayTop.png");
    shipImageArrayBottom = loadImage("assets/ship/mainShip_h_arrayBottom.png");
    
    // Assign ship_selection to the default ship image
    ship_selection = shipImageDefault;
    
    shipSection = new UI(width/2-700, height/2+225, color(255));
    
    // Create the missile and dropship objects
    weapon1 = new Weapon(800, 25, "missile");
    dropship = new Dropship();
  }

  void draw() {
    imageMode(CENTER);
    image(ship_selection, shipX, shipY);
    
    // Check for mouse press when events are not open
    if(mousePressed && (mainGame.eventOpen == false || mainGame.eventPanelClosed == true)) {
      // Run through these methods to draw sections
      shipEngineSelection();
      shipMainSelection();
      shipPilotSelection();
      shipArraySelection();
    } else {
      // Otherwise, draw the default ship image for no change/selection
      ship_selection = shipImageDefault;
    }
    checkStatus();
    weapon1.draw();
    dropship.draw();
  }
  
  void checkStatus() {
    // Checks the ship status/if it's still alive
    if(mainGame.shipHealthCurrent <= 0) {
      shipAlive = false;
    }
  }
  
  void shipSectionDraw() {
    // Text/stats to be drawn when a ship section panel is displayed
    shipSection.text_string(shipSection.x, shipSection.y, "Section: " + shipCurrentSection, 26, shipSection.c, LEFT, shipSection.font);
    shipSection.text_string(shipSection.x, shipSection.y + 25, "Condition: ", 21, color(255), LEFT, shipSection.font);
    shipSection.text_string(shipSection.x + 110, shipSection.y + 25, "" + shipCurrentSectionHP, 21, colorHealthChanger(shipCurrentSectionHP), LEFT, shipSection.font);
  }
  
  // Returns a colour based on the input health amount e.g. low health will return a red colour
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
    else {
      return color(255); 
    }
  }
  
  void shipEngineSelection() {
    // Checks if the engines are selected and draws the corresponding image
    if(rectHover(width/2-600, height/2-70, 250, 140)) {
      ship_selection = shipImageEngine;
      // Changes the open state to true
      shipEngineOpen = true;
      // Gets the stats for the shipSection
      shipCurrentSection = shipSections[0];
      // e.g. the health of the selected ship section
      shipCurrentSectionHP = shipEngineCurrentHP;
    } else {
      shipEngineOpen = false;
    }
  }
  void shipMainSelection() {
    // Checks if the main area is selected and draws the corresponding image
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
    // Checks if the command module is selected and draws the corresponding image
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
    // Checks if the arrays are selected and draws the corresponding image
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