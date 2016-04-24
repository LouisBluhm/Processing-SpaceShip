class Planet {
  
  // Planet variables
  color planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  float planetTilt;
  
  // Variables that will be generated
  float planetTemperature;
  float planetCircumference;
  
  // Array of planet names
  String [] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid", "Hypersia", "Arda"};
  // Keeps track of current planet
  int planetCount;
  String planetNameRandom;
  
  // Planet species
  String [] planetSpecies = {"Vloux", "Lovlons", "Hobbits", "Strask", "Ryard", "NONE FOUND"};
  // Hostility of species
  String [] planetHostility = {"DANGEROUS", "PASSIVE", "NEUTRAL", "PASSIVE", "DANGEROUS", "N/A"};
  String planetSpeciesRandom;
  String planetSpeciesHostility;
  
  // Hashmap for pairing species with hostility
  HashMap<String,String> planetLife = new HashMap<String,String>();
  
  Planet(color _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution, float _planetTilt, int _planetCount) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;
    planetTilt = _planetTilt;
    planetCount = _planetCount;
    
    // Puts the species and hostility values into the hashmap
    for(int i = 0; i < planetSpecies.length; i++) {
      planetLife.put(planetSpecies[i], planetHostility[i]);
    }
 
    // planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
    planetNameRandom = planetNames[planetCount];
    
    // Get a random species from the species array
    planetSpeciesRandom = planetSpecies[(int)(Math.random() * planetSpecies.length)];
    // Get this value from the hashmap
    planetSpeciesHostility = planetLife.get(planetSpeciesRandom);
    
    // Calculate the planet circumference
    planetCircumference = (PI * planetRadius * 2) * 35;

    // Array to store extracted planet colours
    float[] planetRGB = extractColors(planetColor); 

    // Cold
    if(planetRGB[0] < 100 && planetRGB[1] < 100 && planetRGB[2] < 100) {
      planetTemperature = (int)random(-40, 5);
    }
    // Very cold
    if(planetRGB[0] > 200 && planetRGB[1] > 200 && planetRGB[2] > 200) {
      planetTemperature = (int)random(-40, -5);
    }
    // Very hot
    if(planetRGB[0] > 150 && planetRGB[1] < 100 && planetRGB[2] < 100) {
      planetTemperature = (int)random(30, 40);
    } else {
      planetTemperature = (int)random(5, 15);
    }
    
    // Formula to 'try' and create an accurate planet temperature
    planetTemperature *= 0.00005 * sq(planetRadius);
  }
  
  void planetRender() {
    // Method which actually draws the 3D planet sphere
    pushMatrix();
    // Moves it to the correct position
    translate(1200, height/2, -500);
    fill(planetColor);
    stroke(255);
    // Rotate the planet X/Y
    rotateY(radians(frameCount * planetRevolution));
    rotateX(planetTilt);
    sphereDetail(planetDetail);
    // Creates a sphere with random size value
    sphere(planetRadius);
    // lights();
    popMatrix();
    planetInfo();
  }
  
  // @@@ REF:4
  float[] extractColors(color c) {
    // Extracts the exact values of red, green and blue from the randomly generated planet colour
    // (c >> 16) & 0xFF esentially takes a bitmask and gets only the bits specified (16 in this case), representing the color (red in this case)
    float r = (c >> 16) & 0xFF;
    float g = (c >> 8) & 0xFF;
    // This could be (c >> 0) & 0xFF as well
    float b = c & 0xFF;
    // Each value is placed into an array which is then returned
    float[] color_values = {r, g, b}; 
    return color_values;
  }
  
  void planetInfo() {
    // Draw planet hover state to true if hovered over planet 
    if(ellipseHover(1025, height/2, planetRadius)) {
      mainGame.planetHoverInfoOpen = true;
    } else {
      mainGame.planetHoverInfoOpen = false;
    }
  }
}