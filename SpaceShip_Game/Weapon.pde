class Weapon {
  
  float weaponX, weaponY;
  PImage weaponImg;
  UI weaponDisplay;
  
  String weaponType;
  
  Weapon(float _weaponX, float _weaponY, String image) {
    
    weaponX = _weaponX;
    weaponY = _weaponY;
    
    if(image.equals("missile")) {
      weaponImg = loadImage("assets/ship/missile.png");
      weaponType = "Proton Missile";
    }
    
    weaponDisplay = new UI(weaponX, weaponY, "Missiles", color(255));
    
  }
  
  void draw() {
    image(weaponImg, weaponX, weaponY);
    weaponDisplay.text_string(weaponDisplay.x - (weaponImg.width), weaponDisplay.y + 5, "x" + mainShip.shipMissiles, 24, weaponDisplay.c, LEFT, weaponDisplay.font);
    checkStatus();
  }
  
  void checkStatus() {
    if(rectHover(weaponX - (weaponImg.width/2), weaponY - (weaponImg.height/2), weaponImg.width, weaponImg.height)) {
      fill(31, 31, 31);
      rect(weaponX, weaponY+25, 150, 200);
      weaponDisplay.text_string(weaponX+5, weaponY+50, weaponType, 21, color(255), LEFT, weaponDisplay.font);
      weaponDisplay.text_string(weaponX+5, weaponY+70, "Amount: " + mainShip.shipMissiles, 20, color(255), LEFT, weaponDisplay.font);
    }
  }
  
}