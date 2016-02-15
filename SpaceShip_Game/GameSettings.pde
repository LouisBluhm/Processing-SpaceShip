class GameSettings {

  float shipHealth = 300;
  float shipHealthCurrent = 300;

  float shipOxygen = 100;
  float shipOxygenCurrent = 100;

  color shipHealthColor = color(0, 255, 0);
  color shipOxygenColor = color(114, 188, 212);

  //Background planet variables
  color planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  
  GameSettings(color _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;
  }
  
  void planetRender() {
    pushMatrix();
    //translate(width/2, height/2);
    translate(1000, height/2);
    fill(planetColor);
    rotateY(radians(frameCount * planetRevolution));
    sphereDetail(planetDetail);
    sphere(planetRadius);
    lights();
    popMatrix();
  }
  
}