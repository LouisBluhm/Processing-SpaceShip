class Ship {
  
  Tile tile1, tile2;
  float tileX = width/2 - 250;
  float tileY = height/2;
  float shipX, shipY;
  PImage shipImage;
  
  Players player1 = new Players(width/2, height/2, 5);
  
  Ship(float _shipX, float _shipY) {
    
    shipX = _shipX;
    shipY = _shipY;
    
    shipImage = loadImage("mainShip_h.png");
 
  }
  
  void draw() {
    
    //tile1 = new Tile(tileX - 250, tileY, 200, 200, color(255));
    //tile1.display();
    
    imageMode(CENTER);
    image(shipImage, shipX, shipY);
    
    tile1 = new Tile(mainShip.shipX + 32, mainShip.shipY, 150, 70, color(255));
    tile2 = new Tile(mainShip.shipX + 200, mainShip.shipY, 145, 60, color(255));
    
    tile1.display();
    tile2.display();
    
  }
  
  void drawPlayers() {
    player1.draw();
  }
  
  void playerMovement() {
    player1.playerMovement();
  }
}