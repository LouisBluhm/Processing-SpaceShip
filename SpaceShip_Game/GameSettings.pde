class GameSettings {

  //UI objects
  UI health, oxygen, planetNameUI, ftl_travel, modal1;
  
  //Ship configuration
  float shipHealth = 300;
  float shipHealthCurrent = 300;

  float shipOxygen = 100;
  float shipOxygenCurrent = 100;

  //UI Color
  color shipHealthColor = color(0, 255, 0);
  color shipOxygenColor = color(114, 188, 212);
  color planetNameUIColor = color(255);

  //Planet settings
  String[] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid"};
  String planetNameRandom;

  //Create a planet object
  Planet planet;

  //Game config
  float resourceTimer;
  boolean audioMuted = false;

  //Load JSON data
  JSONArray values;

  GameSettings() {
    values = loadJSONArray("text.json");
    planet = new Planet(color(random(255), random(255), random(255)), (int)random(5, 50), random(100, 300), PI / 20);
    planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
  }

  void createLevel() {
    planet.planetRender();
    getJSON("info");
    drawUI();
  }
  
  void createUI() {
    health = new UI(20, 20, "Health (" + shipHealthCurrent + " / " + shipHealth + ")", shipHealthColor);
    oxygen = new UI(20, 55, "Oxygen (" + shipOxygenCurrent + " / " + shipOxygen + ")", shipOxygenColor);
    planetNameUI = new UI(20, 90, "Planet: " + planetNameRandom, planetNameUIColor);
    ftl_travel = new UI(0, 0, "FTL", color(255));
  }
  
  void drawUI() {
    createUI();
    health.draw();
    health.bar(20, 25, shipHealth, 10, shipHealthColor);
    oxygen.draw();
    oxygen.bar(20, 60, shipOxygen, 10, shipOxygenColor);
    planetNameUI.draw();
    
    ftl_travel.button(1300, 40, 70, 30, color(89, 89, 89));
  }

  void getJSON(String value) {
    for (int i = 0; i < values.size(); i++) {
      JSONObject text = values.getJSONObject(i);
      String infoText = text.getString(value);
      //println(infoText);
    }
  }

  void minusResource(float resource) {
    if (millis() - resourceTimer >= 500) {
      resource--;
      resourceTimer = millis();
    }
  }
}