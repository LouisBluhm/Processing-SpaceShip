class Weapon {
  
  // Weapon variables defined
  float weaponX, weaponY;
  PImage weaponImg;
  
  // weaponDisplay UI object created
  UI weaponDisplay;
  
  String weaponType;
  
  Weapon(float _weaponX, float _weaponY, String image) {
    
    weaponX = _weaponX;
    weaponY = _weaponY;
    
    // This isn't really necessary at the moment since there is only 1 weapon type in the game
    if(image.equals("missile")) {
      weaponImg = loadImage("assets/ship/missile.png");
      weaponType = "Proton Missile";
    }
    weaponDisplay = new UI(weaponX, weaponY, color(255));
  }
  
  void draw() {
    // Draws the weapon on screen and the count
    image(weaponImg, weaponX, weaponY);
    weaponDisplay.text_string(weaponDisplay.x - (weaponImg.width), weaponDisplay.y + 5, "x" + mainShip.shipMissiles, 24, weaponDisplay.c, LEFT, weaponDisplay.font);
    checkStatus();
  }
  
  void checkStatus() {
    // Displays more information in a hover menu
    if(rectHover(weaponX - (weaponImg.width/2), weaponY - (weaponImg.height/2), weaponImg.width, weaponImg.height)) {
      weaponDisplay.hoverPanel(weaponX, weaponY+25, " " + weaponType, " Amount: " + mainShip.shipMissiles, "", 150, 60);
    }
  }
  
}