class GameSettings {

  //Ship configuration
  float shipHealth = 300;
  float shipHealthCurrent = 300;
  
  float shipOxygen = 100;
  float shipOxygenCurrent = 100;
  
  //UI Color
  color shipHealthColor = color(0, 255, 0);
  color shipOxygenColor = color(114, 188, 212);
  color planetNameUIColor = color(255);

  //Background planet variables
  color planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  String[] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid"};
  String planetNameRandom;
  
  GameSettings(color _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;
    planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
  }
  
  void planetRender() {   
    pushMatrix();
    //translate(width/2, height/2);
    translate(1000, height/2, -500);
    fill(planetColor);
    stroke(255);
    rotateY(radians(frameCount * planetRevolution));
    sphereDetail(planetDetail);
    sphere(planetRadius);
    //lights();
    popMatrix();
    
    //if(dist(mouseX, mouseY, 1000, height/2) < (planetRadius / 2) && mousePressed == true) {
    //  ellipse(width/2, height/2, 10, 10);
    //}
  }
  
}