class Ship {
  
  Tile tile1;
  float tileX = width/2 - 250;
  float tileY = height/2;
  PImage shipImage;
  
  Players player1 = new Players(tileX - 200, tileY, 5);
  
  Ship() {
    
    shipImage = loadImage("mainShip_h.png");
    //shipImage.resize(250, 431);
  }
  
  void draw() {
    
    //tile1 = new Tile(tileX - 250, tileY, 200, 200, color(255));
    //tile1.display();
    
    image(shipImage, 0, 0);
    
  }
  
  void drawPlayers() {
    player1.draw();
  }
  
  void playerMovement() {
    player1.playerMovement();
  }
}