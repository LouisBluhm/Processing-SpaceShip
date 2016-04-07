class Planet {
  
  color planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  
  String [] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid"};
  String planetNameRandom;
  
  Planet(color _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;

    planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
  }
  
  void planetRender() {
    pushMatrix();
    translate(1200, height/2, -500);
    fill(planetColor);
    stroke(255);
    rotateY(radians(frameCount * planetRevolution));
    sphereDetail(planetDetail);
    sphere(planetRadius);
    //lights();
    popMatrix();
    planetInfo();
  }
  
  void planetInfo() {
    // ellipse(1025, height/2, 200, 200);
    println(planetNameRandom);
    if(mousePlanetHover(1025, height/2, planetRadius)) {
      mainGame.planetHoverInfoOpen = true;
    } else {
      mainGame.planetHoverInfoOpen = false;
    }
  }
  
  boolean mousePlanetHover(int x, int y, float diameter) {
    return (dist(mouseX, mouseY, x, y) < diameter * 0.5);
  }
  
}