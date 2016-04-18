class Travel {
  
  String currentPlanet;
  int systemSize = 10;
  int systemStartX = width/2;
  int systemStartY = height/2;
  int[] travelID = {};
  int systemAmount = 10;

  PImage travel_window;
  
  UI travelPanel;
  HashMap<Integer, Integer> system_position = new HashMap<Integer, Integer>();
  IntDict systemcordsX = new IntDict();
  IntDict systemcordsY = new IntDict();
  
  Travel() {
    travelPanel = new UI(width/2, height/2, "travelPanel", color(255));
    travel_window = loadImage("travel.png");
    
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
    image(travel_window, width/2, height/2);
    currentPlanet = mainGame.planet.planetNameRandom;
    draw_systems();
  }
  
  void draw_systems() {

    // travelPanel.text_string(systemStartX - 12, systemStartY + 10, "You are here > ", 21, travelPanel.c, RIGHT);
    
    
    travelPanel.text_string(width/2-450, height/2+235, "Select planet: ", 25, color(255), LEFT);
    
    println(systemcordsX.get("0"));
    
    for(int i = 0; i < systemAmount-1; i++) {
      
      for(Map.Entry system : system_position.entrySet()) {
        
        draw_system_3d((int)system.getKey(), (int)system.getValue(), systemSize);
               
        if(ellipseHover((int)system.getKey(), (int)system.getValue(), systemSize*2) && (int)system.getKey() != systemStartX && (int)system.getValue() != systemStartY) {
         
          // travelPanel.text_string((int)system.getKey() - 12, (int)system.getValue() + 10, currentPlanet, 22, travelPanel.c, RIGHT);
          
          line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
         
          if(mousePressed) {
            if((int)system.getKey() != systemcordsX.get(str(i)) && (int)system.getValue() != systemcordsY.get(str(i))) {
              mainGame.createPlanet();
              mainGame.travelPanelOpen = false;
            }
          }
        }
      }
      travelPanel.text_string(systemcordsX.get(str(i)) - 12, systemcordsY.get(str(i)), mainGame.planet.planetNames[i], 20, travelPanel.c, RIGHT);
    }

    
  }
  
  void draw_system_3d(int x, int y, int size) {
    pushMatrix();
    translate(x, y, 0);
    fill(0);
    stroke(0, 255, 0);
    rotateY(radians(frameCount * PI/2));
    sphereDetail(5);
    sphere(size);
    popMatrix();
  }
  
}



  //void travelPanelDisplay() {
  //  image(travelPanel, width/2, height/2);
  //  travelPanelSelection();
  //}

  //void travelPanelSelection() {
  //  float[] travelID = {400, height/2, 500, height/2+75, 600, height/2-50, 650, height/2+10, 770, height/2-150, 800, height/2+200};
  //  int systemSize = 10;
  //  // String planet1 = mainGame.planetNameRandom;
  //  //translate(width/2, height/2);
  //  fill(255);

  //  for (int i = 0; i < travelID.length; i += 2) {
  //    ellipse(travelID[i], travelID[i+1], systemSize, systemSize);
  //    text_string(width/2-450, height/2+235, "Select planet: ", 25, color(255), LEFT);
  //    if (hoverDetection(travelID[i], travelID[i+1], systemSize)) {
  //      // imageMode(CORNER);
  //      // image(travelHover, travelID[i], travelID[i+1]);
  //      text_string(width/2-450, height/2+235, "Select planet: " + mainGame.planet.planetNameRandom, 25, color(255), LEFT);
  //      ellipse(travelID[i], travelID[i+1], 12, 12);
  //      line(travelID[i], travelID[i+1], travelID[i+2], travelID[i+3]);
        
  //      if(mousePressed) {
  //        mainGame.createPlanet();
  //        mainGame.travelPanelOpen = false;
  //      }
        
  //    }
  //  }
  //}

  //void travelPlanetInfo(float x, float y, int planetNum) {
  //  mainGame.travelInfo.modal(x, y, 50, 50, color(89, 89, 89));
  //  mainGame.travelInfo.text_string(x, y, mainGame.planet.planetNames[planetNum], 12, color(255), CENTER);
  //}