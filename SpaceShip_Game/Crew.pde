class Crew {
  
  PImage crew_icon;
  
  float crewHealth = 100;
  float crewCurrentHealth = 100;
  color crewCurrentHealthColor = color(0, 255, 0);  
  float crewNameX, crewNameY;
  float crewIconX, crewIconY;
  
  String crewName, crewRole;
  
  UI crewInfo;  
  
  Crew(String _crewName, String _crewRole, float _crewIconX, float _crewIconY, float _crewNameX, float _crewNameY) {
    
    crewName = _crewName;
    crewRole = _crewRole;
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
    check_crew();
    icon(crewIconX, crewIconY);
    crewInfo.text_string(crewInfo.x, crewInfo.y, crewInfo.title, 16, crewInfo.c, LEFT);
    status();
    crewInfo.bar(crewNameX, crewNameY+4, crewCurrentHealth * 0.5, 2, crewCurrentHealthColor, 0);
  }

  void check_crew() {
    if(rectHover(crewIconX, crewIconY, 50, 50) && mainGame.eventOpen == false) {
      stroke(114, 188, 212);
      fill(51, 51, 51);
      rect(crewIconX, crewIconY, 50, 50);
      if(mousePressed) {
        draw_crew_detailed();
      }
    }
  }
  
  void draw_crew_detailed() {
    rect(crewIconX+25, crewIconY+50, 150, 200);
    crewInfo.text_string(crewIconX+30, crewIconY+65, "Name: " + crewName, 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+80, "HP: " + crewCurrentHealth, 20, crewCurrentHealthColor, LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+95, "Role: " + crewRole, 20, color(255), LEFT);
    line(crewIconX+30, crewIconY+105, crewIconX+170, crewIconY+105);
    crewInfo.text_string(crewIconX+30, crewIconY+125, "INT: ", 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+140, "STR: ", 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+155, "CHAR: ", 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+170, "DEX: ", 20, color(255), LEFT);
  }
  
}