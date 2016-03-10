class Players {
  
  float playerX;
  float playerY;
  float playerSpeed;
  PImage playerImage;
  
  float pre_x, pre_y;
  float easing = 0.05;
  
  Players(float _playerX, float _playerY, float _playerSpeed) {
    playerX = _playerX;
    playerY = _playerY;
    playerSpeed = _playerSpeed;
    
    playerImage = loadImage("player.png");
  }
  
  void draw() {
    fill(0);
    stroke(0);
    
    playerX = (1-easing) * pre_x + easing * mouseX;
    playerY = (1-easing) * pre_y + easing * mouseY;
    
    image(playerImage, playerX, playerY);
  }
  
  void playerMovement() {
    if(mousePressed) {
      pre_x = playerX;
      pre_y = playerY;
    }
  }
  
}