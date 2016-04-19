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
    travelPanel = new UI(width/2, height/2, "travelPanel", color(255));
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
    
    travelPanel.text_string(width/2-450, height/2+235, "Next planet to explore: " + mainGame.planet.planetNames[mainGame.planet.planetCount+1], 25, color(255), LEFT);
    
    for(int i = 0; i < mainGame.planet.planetCount; i++) {
      line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
    }
    
    for(int i = 0; i < systemAmount-1; i++) {
      
      for(Map.Entry system : system_position.entrySet()) {
        
        draw_system_3d((int)system.getKey(), (int)system.getValue(), systemSize, systemHover);
        
        if(ellipseHover((int)system.getKey(), (int)system.getValue(), systemSize*2) && (int)system.getKey() != systemStartX && (int)system.getValue() != systemStartY) {
           
          travelPanel.text_string((int)system.getKey() + 20, (int)system.getValue() + 5, "<", 22, color(255, 255, 0), RIGHT);
          // line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
          //if(mousePressed && ((int)system.getKey() != currentPlanetX && (int)system.getValue() != currentPlanetY)) {
          //  println("Success: newPlanet selected!"
          //}
        }
      }

      travelPanel.text_string(systemcordsX.get(str(i)) - 12, systemcordsY.get(str(i)), mainGame.planet.planetNames[i], 20, travelPanel.c, RIGHT);

      if(mainGame.planet.planetCount != mainGame.planet.planetNames.length) {
        if(mousePressed && ellipseHover(systemcordsX.get(str(mainGame.planet.planetCount+1)), systemcordsY.get(str(mainGame.planet.planetCount+1)), systemSize*2) && (systemcordsX.get(str(i)) != currentPlanetX && systemcordsY.get(str(i)) != currentPlanetY)) {
        //if(mousePressed && ellipseHover(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemSize) && (systemcordsX.get(str(i)) != currentPlanetX && systemcordsY.get(str(i)) != currentPlanetY)) {
          println("Success: newPlanet selected!");
          mainGame.createPlanet();
          mainGame.travelPanelOpen = false;        
        }
      }
    }
    if(mousePressed && ellipseHover(currentPlanetX, currentPlanetY, systemSize*2)) {
      println("Error: currentPlanet selected");  
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
}