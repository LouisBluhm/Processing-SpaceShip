class Travel {
  
  String currentPlanet;
  float currentPlanetX, currentPlanetY;
  int systemSize = 10;
  int systemStartX = width/2;
  int systemStartY = height/2;
  int[] travelID = {};
  int systemAmount = 10;
  
  color systemHover;

  PImage travel_window;
  
  UI travelPanel;
  HashMap<Integer, Integer> system_position = new HashMap<Integer, Integer>();
  IntDict systemcordsX = new IntDict();
  IntDict systemcordsY = new IntDict();
  
  Travel() {
    travelPanel = new UI(width/2, height/2, color(255));
    travel_window = loadImage("travel.png");
    systemHover = color(0, 255, 0);
    // Add a temp starting map position
    // system_position.put(systemStartX, systemStartY);
    
    for(int i = 0; i < systemAmount; i++) {
      int x = (int)random(300, 1150);
      int y = (int)random(250, 650);
      system_position.put(x, y);
      systemcordsX.set(str(i), x);
      systemcordsY.set(str(i), y);
    }
    
  }
  
  void draw() {
    mainGame.travelPanelOpen = true;
    image(travel_window, width/2, height/2);
    currentPlanet = mainGame.planet.planetNameRandom;
    draw_systems();
  }
  
  void draw_systems() {
    
    currentPlanetX = systemcordsX.get(str(mainGame.planet.planetCount));
    currentPlanetY = systemcordsY.get(str(mainGame.planet.planetCount));
    
    travelPanel.text_string(width/2-450, height/2+235, "Next planet to explore: " + mainGame.planet.planetNames[mainGame.planet.planetCount+1], 25, color(255), LEFT, travelPanel.font);
    
    if(mainGame.shipEnergyCurrent < 75) {
      error.play();
      travelPanel.text_string(width/2-50, height/2+235, "Not enough energy. Charge cells first!", 27, color(255, 0, 0), LEFT, travelPanel.font);
    }
    
    for(int i = 0; i < mainGame.planet.planetCount; i++) {
      line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
    }
    
    for(int i = 0; i < systemAmount-1; i++) {
      
      for(Map.Entry system : system_position.entrySet()) {
        
        draw_system_3d((int)system.getKey(), (int)system.getValue(), systemSize, systemHover);
        
        if(ellipseHover((int)system.getKey(), (int)system.getValue(), systemSize*2) && (int)system.getKey() != systemStartX && (int)system.getValue() != systemStartY) {
           
          travelPanel.text_string((int)system.getKey() + 20, (int)system.getValue() + 5, "<", 22, color(255, 255, 0), RIGHT, travelPanel.font);
          // line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
          //if(mousePressed && ((int)system.getKey() != currentPlanetX && (int)system.getValue() != currentPlanetY)) {
          //  println("Success: newPlanet selected!"
          //}
        }
      }

      travelPanel.text_string(systemcordsX.get(str(i)) - 12, systemcordsY.get(str(i)), mainGame.planet.planetNames[i], 20, travelPanel.c, RIGHT, travelPanel.font);

      if(mainGame.planet.planetCount != mainGame.planet.planetNames.length) {
        if(mousePressed && ellipseHover(systemcordsX.get(str(mainGame.planet.planetCount+1)), systemcordsY.get(str(mainGame.planet.planetCount+1)), systemSize*2) && (systemcordsX.get(str(i)) != currentPlanetX && systemcordsY.get(str(i)) != currentPlanetY)) {
        //if(mousePressed && ellipseHover(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemSize) && (systemcordsX.get(str(i)) != currentPlanetX && systemcordsY.get(str(i)) != currentPlanetY)) {
          
          if(mainGame.shipEnergyCurrent < mainGame.shipEnergyCost) {
            println("[INFO] Energy critical amount, travel disabled");
          } else {
            println("[INFO] Success: newPlanet selected!");
            mainGame.shipEnergyCurrent -= mainGame.shipEnergyCost;
            mainGame.createPlanet();
            mainGame.eventOpen = false;
            mainGame.eventResponsesOpen = false;
            mainGame.startNewEvent();
            mainGame.travelPanelOpen = false;
            mainShip.dropship.deployed = false;
            mainShip.dropship.charging = false;
            error.rewind();
          }
        }
      }
    }
    if(mousePressed && ellipseHover(currentPlanetX, currentPlanetY, systemSize*2)) {
      error.rewind();
      error.play();
      println("[ERROR] Error: currentPlanet selected");  
    }
  }
  
  void draw_system_3d(int x, int y, int size, color systemHover) {
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
    int x = width - 110;
    int y = 10;
    if(rectHover(x, y, 100, 25)) {
      fill(31, 31, 31);
      if(mousePressed) {
        if(mainGame.travelPanelOpen == true) {
          mainGame.travelPanelOpen = false;
        }
        mainGame.travelPanelOpen = !mainGame.travelPanelOpen;
      }
    } else {
      fill(51, 51, 51);
    }
    rect(x, y, 100, 25);
    travelPanel.text_string(x+50, y+18, "Q - TRAVEL", 20, color(255), CENTER, travelPanel.font);
  }
  
  //void closeTravelButton() {
  //  if(rectHover(width-110, 10, 100, 25) && mousePressed && mainGame.travelPanelOpen == true) {
  //    mainGame.travelPanelOpen = !mainGame.travelPanelOpen;
  //  }
  //}
}