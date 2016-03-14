class Ship {

  Tile tile1, tile2;
  float tileX = width/2 - 250;
  float tileY = height/2;
  float shipX, shipY;
  
  PImage shipImageDefault, shipImageEngine, shipImageMain, shipImagePilot, shipImageArrayTop, shipImageArrayBottom;
  PImage ship_selection;
  
  boolean shipEngineOpen = false;
  boolean shipMainOpen = false;
  boolean shipPilotOpen = false;
  boolean shipArrayTopOpen = false;
  boolean shipArrayBottomOpen = false;

  Players player1 = new Players(width/2, height/2, 5);       
  UI shipSection;

  Ship(float _shipX, float _shipY) {

    shipX = _shipX;
    shipY = _shipY;

    shipImageDefault = loadImage("mainShip_h.png");
    shipImageEngine = loadImage("mainShip_h_engine.png");
    shipImageMain = loadImage("mainShip_h_main.png");
    shipImagePilot = loadImage("mainShip_h_pilot.png");
    shipImageArrayTop = loadImage("mainShip_h_arrayTop.png");
    shipImageArrayBottom = loadImage("mainShip_h_arrayBottom.png");
    ship_selection = shipImageDefault;
    
    shipSection = new UI(0, 0, "ship section", color(255));
  }

  void draw() {

    //tile1 = new Tile(tileX - 250, tileY, 200, 200, color(255));
    //tile1.display();

    imageMode(CENTER);
    image(ship_selection, shipX, shipY);

    if(mousePressed) {
        shipEngineSelection();
        shipMainSelection();
        shipPilotSelection();
        shipArraySelection();
    }

    tile1 = new Tile(mainShip.shipX + 32, mainShip.shipY, 150, 70, color(255));
    tile2 = new Tile(mainShip.shipX + 200, mainShip.shipY, 145, 60, color(255));

    //tile1.display();
    //tile2.display();
  }

  void drawPlayers() {
    player1.draw();
  }

  void playerMovement() {
    player1.playerMovement();
  }

  void shipEngineSelection() {
    if(mouseX > width/2-600 && mouseX < width/2-350 && mouseY < height/2+60 && mouseY > height/2-60) {
      ship_selection = shipImageEngine;
      shipEngineOpen = true;
    }
  }
  void shipMainSelection() {
    if(mouseX > width/2-350 && mouseX < width/2-175 && mouseY < height/2+50 && mouseY > height/2-50) {
      ship_selection = shipImageMain;
    }
  }
  void shipPilotSelection() {
    if(mouseX > width/2-175 && mouseX < width/2 && mouseY < height/2+60 && mouseY > height/2-60) {
      ship_selection = shipImagePilot;
    }
  }
  void shipArraySelection() {
    if(mouseX > width/2-350 && mouseX < width/2-175 && mouseY < height/2-50 && mouseY > height/2-180) {
      ship_selection = shipImageArrayTop;
    } else if(mouseX > width/2-350 && mouseX < width/2-175 && mouseY < height/2+180 && mouseY > height/2+50) {
      ship_selection = shipImageArrayBottom;
    }
  }
}