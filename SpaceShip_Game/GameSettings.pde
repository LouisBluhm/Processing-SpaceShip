class GameSettings {

  //UI objects
  UI health, oxygen, planetNameUI, ftl_travel, modal1, shipDisplayPanel;
  UI travelMenu;
  UI travelInfo;
  UI eventPanel;
  UI planetHoverInfo;
  boolean buttonHover = false;
  
  //Inventory
  Inventory inventory;
  
  //Ship configuration
  float shipHealth = 300;
  float shipHealthCurrent = 300;

  float shipOxygen = 100;
  float shipOxygenCurrent = 100;
  
  float shipEngineHealth = 100;
  float shipEngineHealthCurrent = 100;

  //UI Color
  color shipHealthColor = color(0, 255, 0);
  color shipOxygenColor = color(114, 188, 212);
  color planetNameUIColor = color(255);

  //Create a planet object
  Planet planet;
  
  //Crew
  Crew crew1, crew2, crew3;
  
  //Game states
  boolean travelPanelOpen = false;
  boolean inventoryOpen = false;
  boolean eventOpen = false;
  boolean eventPanelClosed = true;
  boolean planetHoverInfoOpen = false;

  //Game default config
  float resourceTimer;
  boolean audioMuted = false;
  
  //Load Images
  PImage defaultPointer;

  GameSettings() {
    //Create a random planet object
    planet = new Planet(color(random(255), random(255), random(255)), (int)random(5, 25), random(100, 300), PI / 50, random(-0.2, 0.2));
    
    //Create the crew objects
    crew1 = new Crew("Walker", 400, 10, 400, 45);
    crew2 = new Crew("Andez", 460, 10, 460, 45);
    crew3 = new Crew("Cooper", 520, 10, 520, 45);
    
    //Load cursor image
    defaultPointer = loadImage("pointer_shadow.png");
    
    //Create various UI elements
    shipDisplayPanel = new UI(0, 0, "Section", color(255));
    health = new UI(20, 20, "Health (" + shipHealthCurrent + " / " + shipHealth + ")", shipHealthColor);
    oxygen = new UI(20, 55, "Oxygen (" + shipOxygenCurrent + " / " + shipOxygen + ")", shipOxygenColor);
    planetNameUI = new UI(20, 90, "Planet: " + planet.planetNameRandom, planetNameUIColor);
    ftl_travel = new UI(0, 0, "HYPERSPACE", color(255));
    travelMenu = new UI(0, 0, "travelMenu", color(255));
    travelInfo = new UI(0, 0, "travelInfo", color(255));
    eventPanel = new UI(0, 0, "eventPanel", color(255));
    planetHoverInfo = new UI(1200, height/2 + 200, "planetHoverinfo", color(255));
    
    //Create a new inventory object
    inventory = new Inventory();
  }

  void createLevel() {
    planet.planetRender();
    drawUI();
    drawCursor(1);
  }
  
  void drawUI() {

    health.draw();
    health.bar(20, 25, shipHealth, 10, shipHealthColor);
    oxygen.draw();
    oxygen.bar(20, 60, shipOxygen, 10, shipOxygenColor);
    planetNameUI.draw();
    ftl_travel.button(1300, 40);
    if(mainShip.shipEngineOpen) {
     shipDisplayPanel.shipSectionDisplay();
    }
    drawTravelMenu();
    drawInventory();
    drawEvent();
    drawPlanetHoverInfo();
    drawCrew();
  }
  
  void drawCrew() {
    crew1.draw_crew();
    crew2.draw_crew();
    crew3.draw_crew();
  }
  
  void drawCursor(float cursor) {
    if(cursor == 1) {
      cursor(defaultPointer, 0, 0);
    }
  }
  
  void gamePause() {
    planet.planetRevolution = 0;
  }
  
  void drawTravelMenu() {
    if(travelPanelOpen) {
      travelMenu.travelPanelDisplay();
    }
  }
  
  void drawInventory() {
    if(inventoryOpen) {
      inventory.loadDefault();
    }
  }
  
  void drawEvent() {
    if(eventOpen) {
      eventPanel.eventPanelDisplay();
      eventPanelClosed = false;
    }
  }
  
  void drawPlanetHoverInfo() {
    if(planetHoverInfoOpen && travelPanelOpen == false && inventoryOpen == false && eventOpen == false) {
      planetHoverInfo.planetHoverInfo();
    }
  }
}