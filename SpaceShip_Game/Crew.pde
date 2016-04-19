class Crew {
  
  PImage crew_icon;
  
  //Crew settings
  color crewCurrentHealthColor = color(0, 255, 0);  
  float crewNameX, crewNameY;
  float crewIconX, crewIconY;
  
  //Crew stats
  String crewName, crewRole;
  float crewHealth = 100;
  float crewCurrentHealth = 100;
  int INT, STR, CHAR, DEX;
  
  UI crewInfo;  
  
  Crew(String _crewName, String _crewRole, float _crewIconX, float _crewIconY, float _crewNameX, float _crewNameY) {
    
    crewName = _crewName;
    crewRole = _crewRole;
    crewIconX = _crewIconX;
    crewIconY = _crewIconY;
    crewNameX = _crewNameX;
    crewNameY = _crewNameY;
    
    INT = (int)random(1, 6);
    STR = (int)random(1, 6);
    CHAR = (int)random(1, 6);
    DEX = (int)random(1, 6);
    
    crew_icon = loadImage("crew_icon.png");
    
    crewInfo = new UI(crewNameX, crewNameY, crewName, color(255));
  }
  
  void icon(float x, float y) {
    imageMode(CORNER);
    image(crew_icon, x, y);
  }

  void status() {
    if(crewCurrentHealth > 50) {
      crewCurrentHealthColor = mainGame.goodHP;
    }
    if(crewCurrentHealth <= 50) {
      crewCurrentHealthColor = mainGame.lowHP;
    }
    if(crewCurrentHealth <= 25) {
      crewCurrentHealthColor = mainGame.verylowHP;
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

  void changeHealth(int amount) {
   println("[INFO] Changing health of " + this.getClass().getCanonicalName() + " by " + amount);
   if(!(crewCurrentHealth + amount >= crewHealth)) {
     crewCurrentHealth += amount;
   }
  }
  
  void draw_crew_detailed() {
    rect(crewIconX+25, crewIconY+50, 150, 200);
    crewInfo.text_string(crewIconX+30, crewIconY+65, "Name: " + crewName, 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+80, "HP: " + (int)crewCurrentHealth + "%", 20, crewCurrentHealthColor, LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+95, "Role: " + crewRole, 20, color(255), LEFT);
    line(crewIconX+30, crewIconY+105, crewIconX+170, crewIconY+105);
    crewInfo.text_string(crewIconX+30, crewIconY+125, "INT: " + INT, 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+140, "STR: " + STR, 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+155, "CHAR: " + CHAR, 20, color(255), LEFT);
    crewInfo.text_string(crewIconX+30, crewIconY+170, "DEX: " + DEX, 20, color(255), LEFT);
  }
  
}