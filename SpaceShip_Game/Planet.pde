class Planet {
  
  color planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  float planetTilt;
  
  float planetTemperature;
  float planetCircumference;
  
  String [] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid", "Hypersia", "Arda"};
  int planetCount;
  String planetNameRandom;
  String [] planetSpecies = {"Vloux", "Lovlons", "Hobbits", "Strask", "Ryard", "NONE FOUND"};
  String [] planetHostility = {"DANGEROUS", "PASSIVE", "NEUTRAL", "PASSIVE", "DANGEROUS", "N/A"};
  String planetSpeciesRandom;
  String planetSpeciesHostility;
  
  HashMap<String,String> planetLife = new HashMap<String,String>();
  
  Planet(color _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution, float _planetTilt, int _planetCount) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;
    planetTilt = _planetTilt;
    planetCount = _planetCount;

    for(int i = 0; i < planetSpecies.length; i++) {
      planetLife.put(planetSpecies[i], planetHostility[i]);
    }

    // planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
  
    planetNameRandom = planetNames[planetCount];
         
    planetSpeciesRandom = planetSpecies[(int)(Math.random() * planetSpecies.length)];
    planetSpeciesHostility = planetLife.get(planetSpeciesRandom);
    
    planetCircumference = (PI * planetRadius * 2) * 35;

    float[] planetRGB = extractColors(planetColor); 

    //Cold
    if(planetRGB[0] < 100 && planetRGB[1] < 100 && planetRGB[2] < 100) {
      planetTemperature = (int)random(-40, 5);
    }
    //Very cold
    if(planetRGB[0] > 200 && planetRGB[1] > 200 && planetRGB[2] > 200) {
      planetTemperature = (int)random(-40, -5);
    }
    //Very hot
    if(planetRGB[0] > 150 && planetRGB[1] < 100 && planetRGB[2] < 100) {
      planetTemperature = (int)random(30, 40);
    } else {
      planetTemperature = (int)random(5, 15);
    }
    planetTemperature *= 0.00005 * sq(planetRadius);
  }
  
  void planetRender() {
    pushMatrix();
    translate(1200, height/2, -500);
    fill(planetColor);
    stroke(255);
    //stroke(255);
    rotateY(radians(frameCount * planetRevolution));
    rotateX(planetTilt);
    sphereDetail(planetDetail);
    sphere(planetRadius);
    //lights();
    popMatrix();
    planetInfo();
  }
  
  float[] extractColors(color c) {
    float r = (c >> 16) & 0xFF;
    float g = (c >> 8) & 0xFF;
    float b = c & 0xFF;
    float[] color_values = {r, g, b}; 
    return color_values;
  }
  
  void planetInfo() {
    if(ellipseHover(1025, height/2, planetRadius)) {
      mainGame.planetHoverInfoOpen = true;
    } else {
      mainGame.planetHoverInfoOpen = false;
    }
  }
}