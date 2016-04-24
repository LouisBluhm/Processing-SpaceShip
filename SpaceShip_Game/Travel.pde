class Travel {
  
  String currentPlanet;
  float currentPlanetX, currentPlanetY;
  int systemSize = 10;
  int systemStartX = width/2;
  int systemStartY = height/2;
  int[] travelID = {};
  
  // Defines the number of systems to be drawn on the travel menu
  int systemAmount = 10;
  
  color systemHover;
  PImage travel_window;
  
  // travelPanel UI object is declared
  UI travelPanel;
  
  // Hashmap to store the position of the systems on the travel menu
  HashMap<Integer, Integer> system_position = new HashMap<Integer, Integer>();

  // Int dictionary to store co-ords of each system 
  IntDict systemcordsX = new IntDict();
  IntDict systemcordsY = new IntDict();
  
  Travel() {
    travelPanel = new UI(width/2, height/2, color(255));
    travel_window = loadImage("travel.png");
    systemHover = color(0, 255, 0);
    
    // Loop to fill the Hashmap and the dictionary
    for(int i = 0; i < systemAmount; i++) {
      // Random x, y co-ords are made within the given range
      int x = (int)random(300, 1150);
      int y = (int)random(250, 650);
      // These are then added to hashmap
      system_position.put(x, y);
      // And the X/Y dictionary, with the corresponding index value
      systemcordsX.set(str(i), x);
      systemcordsY.set(str(i), y);
    }
    
  }
  
  void draw() {
    // Draws the main travel menu
    mainGame.travelPanelOpen = true;
    image(travel_window, width/2, height/2);
    // currentPlanet = mainGame.planet.planetNameRandom;
    draw_systems();
  }
  
  void draw_systems() {
    // The method to draw the systems on the travel menu
    
    // The current planet X/Y co-ords are taken from the dictionaries by index value (the planet counter from the planet class)
    currentPlanetX = systemcordsX.get(str(mainGame.planet.planetCount));
    currentPlanetY = systemcordsY.get(str(mainGame.planet.planetCount));
    
    // Text to tell the player which planet they must travel to next
    travelPanel.text_string(width/2-450, height/2+235, "Next planet to explore: " + mainGame.planet.planetNames[mainGame.planet.planetCount+1], 25, color(255), LEFT, travelPanel.font);
    
    // If the ship doesn't have the right amount of energy, play an audio effect and notify the player
    if(mainGame.shipEnergyCurrent < 75) {
      error.play();
      travelPanel.text_string(width/2-50, height/2+235, "Not enough energy. Charge cells first!", 27, color(255, 0, 0), LEFT, travelPanel.font);
    }
    
    // Draws a line to show the connection between the last visited planets on the map
    for(int i = 0; i < mainGame.planet.planetCount; i++) {
      line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
    }
    
    for(int i = 0; i < systemAmount; i++) {
      
      // For loop allows us to get the key and value data from the dictionary
      // @@@ REF:5
      for(Map.Entry system : system_position.entrySet()) {
        
        // Key and values used to draw the 3D systems on the map
        // The key being the x coord, and the value being the y coord 
        draw_system_3d((int)system.getKey(), (int)system.getValue(), systemSize, systemHover);
        
        // If the player hovers over a system/planet (ellipseHover takes the key/value pairs) a '<' is drawn so the player can see their decision clearly
        if(ellipseHover((int)system.getKey(), (int)system.getValue(), systemSize*2) && (int)system.getKey() != systemStartX && (int)system.getValue() != systemStartY) { 
          travelPanel.text_string((int)system.getKey() + 20, (int)system.getValue() + 5, "<", 22, color(255, 255, 0), RIGHT, travelPanel.font);
        }
      }
      
      // This UI method is used to draw the names of the planets next to the correct planet
      travelPanel.text_string(systemcordsX.get(str(i)) - 12, systemcordsY.get(str(i)), mainGame.planet.planetNames[i], 20, travelPanel.c, RIGHT, travelPanel.font);

      // Make sure we are not at the end of the planet choices
      if(mainGame.planet.planetCount != mainGame.planet.planetNames.length) {
        // Check that a planet is selected and that it isn't the current planet the player is at
        if(mousePressed && ellipseHover(systemcordsX.get(str(mainGame.planet.planetCount+1)), systemcordsY.get(str(mainGame.planet.planetCount+1)), systemSize*2) && (systemcordsX.get(str(i)) != currentPlanetX && systemcordsY.get(str(i)) != currentPlanetY)) {
          // Do nothing if the player doesn't have enough energy (text printed to console for debugging)  
          if(mainGame.shipEnergyCurrent < mainGame.shipEnergyCost) {
            println("[INFO] Energy critical amount, travel disabled");
          } else {
            // This is executed if the player selects the correct planet and has enough energy
            println("[INFO] Success: newPlanet selected!");
            // Minus the energy cost from the current ship energy
            mainGame.shipEnergyCurrent -= mainGame.shipEnergyCost;
            // Create a new planet
            mainGame.createPlanet();
            mainGame.eventOpen = false;
            mainGame.eventResponsesOpen = false;
            // Start a new event
            mainGame.startNewEvent();
            // Close the travel panel
            mainGame.travelPanelOpen = false;
            // Stop the dropship if it's still deployed
            mainShip.dropship.deployed = false;
            mainShip.dropship.charging = false;
            // Rewind the audio effect so it can be used again in the future if the player doesn't have enough energy
            error.rewind();
          }
        }
      }
    }
    if(mousePressed && ellipseHover(currentPlanetX, currentPlanetY, systemSize*2)) {
      // If the player selects the current planet (planet which they are already at) play an error audio effect
      error.rewind();
      error.play();
      println("[ERROR] Error: currentPlanet selected");  
    }
  }
  
  void draw_system_3d(int x, int y, int size, color systemHover) {
    // Similar to draw planet method, the difference being no fill and a lower detail
    pushMatrix();
    translate(x, y, 0);
    fill(0);
    stroke(systemHover);
    rotateY(radians(frameCount * PI/2));
    sphereDetail(5);
    sphere(size);
    popMatrix();
  }
  
  void drawTravelButton() {
    // UNUSED BUTTON!
    // Draws the travel button the main screen
    //int x = width - 110;
    //int y = 10;
    //if(rectHover(x, y, 100, 25)) {
    //  fill(31, 31, 31);
    //  if(mousePressed && mainGame.travelPanelOpen == false) {
    //    mainGame.travelPanelOpen = true;
    //  }
    //} else {
    //  fill(51, 51, 51);
    //}
    //rect(x, y, 100, 25);
    travelPanel.text_string((width-20), 28, "Q - TRAVEL", 20, color(255), RIGHT, travelPanel.font);
    travelPanel.text_string((width-20), 48, "W - DROPSHIP", 20, color(255), RIGHT, travelPanel.font);
  }
}