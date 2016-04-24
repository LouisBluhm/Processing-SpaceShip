class GameSettings {
  
  //  UI objects
  UI health, oxygen, planetNameUI, ftl_travel, modal1, shipDisplayPanel, energy;
  UI travelMenu;
  UI travelInfo;
  UI eventPanel;
  UI planetHoverInfo;
  boolean buttonHover = false;
  
  //  Inventory
  Inventory inventory;
  
  //  Ship configurations
  int shipHealth = 300;
  int shipHealthCurrent = 300;
  int shipOxygen = 100;
  int shipOxygenCurrent = 100;
  int shipEnergy = 300;
  int shipEnergyCurrent = 300;
  int shipEnergyCost = 100;
  int shipEnergyUsage = 60;

  //  UI Colors
  color shipHealthColor = color(0, 255, 0);
  color shipOxygenColor = color(114, 188, 212);
  color shipEnergyColor = color(255, 255, 0);
  color planetNameUIColor = color(255);
  color goodHP = color(0, 255, 0);
  color lowHP = color(255, 71, 25);
  color verylowHP = color(255, 0, 0);
  color gain = color(0, 255, 0);
  color loss = color(255, 0, 0);
  
  //  UI Fonts
  int event_log_size = 14;
  int event_message_size = 13;
  int event_choice_size = 12;

  //  Create a planet object
  Planet planet;
  
  // Crew
  ArrayList<Crew> crew = new ArrayList<Crew>();
  String crew_member_gained;
  
  // Stats for generating new crew members
  String[] crew_names_temp = {"Murph", "Ripley", "Watney", "Kirk", "Deckard", "Solo"};
  ArrayList<String> crew_names = new ArrayList<String>();
  String[] crew_roles = {"Pilot", "Biologist", "Soldier", "Engineer"};
  int last_crew_position_x = 520;
  
  // Audio
  Minim minim;
  AudioPlayer selection;
  
  // Travel window object
  Travel travel;
  
  // Create random event object and event checking storage;
  Event newEvent;
  ArrayList<Integer> events_to_check = new ArrayList<Integer>();
  boolean event_fill_done = false;
  
  // Create a game over object
  GameOver mainGameOver;
  
  // Game states
  boolean travelPanelOpen = false;
  boolean inventoryOpen = false;
  boolean eventOpen = false;
  boolean eventPanelClosed = true;
  boolean planetHoverInfoOpen = false;
  boolean eventResponsesOpen = false;
  boolean create_planet = true;
  boolean game_over = false;

  // Game default config
  float resourceTimer;
  boolean audioMuted = false;
  
  // Load Images
  PImage defaultPointer, handPointer, game_over_background;
  
  // test vars
  int planet_counter;

  GameSettings() {
    
    // Create an initial planet
    createPlanet();
    
    // Add the default crew to the crew arraylist
    crew.add(new Crew("Walker", "Engineer", 400, 10, 400, 45));
    crew.add(new Crew("Andez", "Physicist", 460, 10, 460, 45));
    crew.add(new Crew("Cooper", "Pilot", 520, 10, 520, 45));
    for(String name : crew_names_temp) {
      crew_names.add(name);
    }
    
    // Load cursor image
    defaultPointer = loadImage("assets/ui/pointer_shadow.png");
    handPointer = loadImage("assets/ui/pointer_hand.png");
    
    // Create various UI elements
    shipDisplayPanel = new UI(0, 0, color(255));
    health = new UI(20, 20, shipHealthColor);
    oxygen = new UI(20, 55, shipOxygenColor);
    energy = new UI(950, 20, shipEnergyColor);
    travelMenu = new UI(0, 0, color(255));
    travelInfo = new UI(0, 0, color(255));
    eventPanel = new UI(0, 0, color(255));
    planetHoverInfo = new UI(1200, height/2 + 200, color(255));
    
    // Create various objects
    inventory = new Inventory();
    travel = new Travel();
  }
  
  void createPlanet() {
    // Create a new planet, with random settings
    planet = new Planet(color(random(255), random(255), random(255)), (int)random(5, 25), random(100, 300), PI / 50, random(-0.2, 0.2), planet_counter);
    // Create the planet UI object
    planetNameUI = new UI(20, 90, planetNameUIColor);
    // Increment the planet counter to keep track of planets created
    planet_counter++;
  }
  
  void startNewEvent() {
    // Creates a new event when called
    newEvent = new Event();
    eventOpen = true;
  }

  void createLevel() {
    // Method to create our initial level
    // Draws the planet
    planet.planetRender();
    // Draws the UI
    drawUI();
    // Draws the custom cursors
    drawCursor();
  }
  
  void gameOver() {
    // Creates a game over screen when called
    if(game_over == false) {
      ambient.pause();
      println("[INFO] Game over state started");
      mainGameOver = new GameOver();
      // Plays music during the game over screen, called here instead of GameOver class to stop it looping every frame
      game_over_music.loop();
      game_over = true;
    }
  }
  
  void drawUI() {
    // Method which draws various UI elements on the main screen
    
    // Health
    health.draw("Health (" + shipHealthCurrent + " / " + shipHealth + ")");
    health.bar(20, 25, shipHealthCurrent, 10, shipHealthColor, shipHealth);
    
    // Energy 
    energy.draw("Energy (" + shipEnergyCurrent + " / " + shipEnergy + ")");
    energy.bar(950, 25, shipEnergyCurrent, 10, shipEnergyColor, shipEnergy);
    if(rectHover(950, 10, 300, 30)) {
      energy.hoverPanel(950, 50, "- Travelling to a system uses " + shipEnergyCost + " cells", "- Deploy dropship to charge energy cells", "- Run out of energy and you will be stranded!", 360, 80);
      energy.hoverPanel(950, 140, "Engines: " + shipEnergyUsage + "% Energy", "Oxygen: 20% Energy", "Dropship: " + mainShip.dropship.energyUsage + "% Energy", 360, 80);
    }
    
    // Oxygen
    oxygen.draw("Oxygen (" + shipOxygenCurrent + " / " + shipOxygen + ")");
    oxygen.bar(20, 60, shipOxygenCurrent, 10, shipOxygenColor, shipOxygen);
    
    // Planet Name
    planetNameUI.draw("Planet: " + planet.planetNameRandom);
    
    // Ship sections
    if((mainShip.shipEngineOpen || mainShip.shipMainOpen || mainShip.shipArrayTopOpen || mainShip.shipArrayBottomOpen || mainShip.shipPilotOpen) && travelPanelOpen == false) {
     shipDisplayPanel.shipSectionDisplay();
    }
    
    drawTravelMenu();
    drawInventory();
    drawEvent();
    drawPlanetHoverInfo();
    drawCrew();
  }
  
  void drawCrew() {
    //crew1.draw_crew();
    //crew2.draw_crew();
    //crew3.draw_crew();
    for(Crew members : crew) {
      members.draw_crew();
    }
  }
  
  void drawCursor() {
    // Draw cursors depending on game location e.g. travel panel or default window
    if(travelPanelOpen || eventOpen) {
      cursor(handPointer, 0, 0);
    } else {
      cursor(defaultPointer, 0, 0);
    }
  }
  
  void gamePause() {
    // If the game is paused, stop planet from rotating
    planet.planetRevolution = 0;
  }
  
  void drawTravelMenu() {
    travel.drawTravelButton();
    if(travelPanelOpen) {
      //  travel.closeTravelButton();
      shipStateChange();
      travel.draw();
      //  travelMenu.travelPanelDisplay();
    }
  }
  
  void drawInventory() {
    if(inventoryOpen) {
      shipStateChange();
      inventory.loadDefault();
    }
  }
  
  void drawEvent() {
    if(eventOpen) {
      shipStateChange();
      newEvent.displayEventMessage();
      eventPanelClosed = false;
    }
  }
  
  void drawPlanetHoverInfo() {
    if(planetHoverInfoOpen && travelPanelOpen == false && eventOpen == false) {
     // if(planetHoverInfoOpen && (travelPanelOpen == false || inventoryOpen == false || eventOpen == false)) {
      planetHoverInfo.planetHoverInfo();
    }
  }
  
  void shipStateChange() {
    // Closes all ship sections when method is called
    mainShip.shipEngineOpen = false;
    mainShip.shipMainOpen = false;
    mainShip.shipArrayBottomOpen = false;
    mainShip.shipArrayTopOpen = false;
    mainShip.shipPilotOpen = false;
  }
}