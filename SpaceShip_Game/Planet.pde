class Planet {
  
  color planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  
  Planet(color _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;
    //mainGame.planetNameRandom = mainGame.planetNames[(int)(Math.random() * mainGame.planetNames.length)];
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
    
  }
  
}