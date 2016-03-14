class GameSettings {

  //UI objects
  UI health, oxygen, planetNameUI, ftl_travel, modal1, shipDisplayPanel;
  boolean buttonHover = false;
  
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

  //Planet settings
  String[] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid"};
  String planetNameRandom;

  //Create a planet object
  Planet planet;

  //Game config
  float resourceTimer;
  boolean audioMuted = false;
  boolean inventoryOpen = false;
  
  //Load Images
  PImage defaultPointer;

  GameSettings() {
    planet = new Planet(color(random(255), random(255), random(255)), (int)random(5, 50), random(100, 300), PI / 20);
    planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
    
    defaultPointer = loadImage("pointer_shadow.png");
    
    shipDisplayPanel = new UI(0, 0, "Section", color(255));
    health = new UI(20, 20, "Health (" + shipHealthCurrent + " / " + shipHealth + ")", shipHealthColor);
    oxygen = new UI(20, 55, "Oxygen (" + shipOxygenCurrent + " / " + shipOxygen + ")", shipOxygenColor);
    planetNameUI = new UI(20, 90, "Planet: " + planetNameRandom, planetNameUIColor);
    ftl_travel = new UI(0, 0, "HYPERSPACE", color(255));
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
  }
  
  void drawCursor(float cursor) {
    if(cursor == 1) {
      cursor(defaultPointer, 0, 0);
    }
  }

  void minusResource(float resource) {
    if (millis() - resourceTimer >= 500) {
      resource--;
      resourceTimer = millis();
    }
  }
}