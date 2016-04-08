class Crew {
  
  PImage crew_icon;
  
  float crewHealth = 100;
  float crewCurrentHealth = 100;
  color crewCurrentHealthColor = color(0, 255, 0);  
  float crewNameX, crewNameY;
  float crewIconX, crewIconY;
  
  String crewName;
  
  UI crewInfo;
  
  Crew(String _crewName, float _crewIconX, float _crewIconY, float _crewNameX, float _crewNameY) {
    
    crewName = _crewName;
    crewIconX = _crewIconX;
    crewIconY = _crewIconY;
    crewNameX = _crewNameX;
    crewNameY = _crewNameY;
    
    crew_icon = loadImage("crew_icon.png");
    
    crewInfo = new UI(crewNameX, crewNameY, crewName, color(255));
  }
  
  void icon(float x, float y) {
    imageMode(CORNER);
    image(crew_icon, x, y);
  }

  void status() {
    if(crewCurrentHealth > 50) {
      crewCurrentHealthColor = color(0, 255, 0);
    }
    if(crewCurrentHealth <= 50) {
      crewCurrentHealthColor = color(255, 71, 25);
    }
    if(crewCurrentHealth <= 25) {
      crewCurrentHealthColor = color(255, 0, 0);
    }
  }
  
  void draw_crew() {
    icon(crewIconX, crewIconY);
    crewInfo.text_string(crewInfo.x, crewInfo.y, crewInfo.title, 16, crewInfo.c, LEFT);
    status();
    crewInfo.bar(crewNameX, crewNameY+4, crewCurrentHealth * 0.5, 2, crewCurrentHealthColor);
  }
  
}