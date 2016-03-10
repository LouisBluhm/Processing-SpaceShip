GameSettings mainGame;
UI health, oxygen, planetNameUI, modal1;
Ship mainShip;

void setup() {
  size(1440, 900, P3D);
  
  //Iniate random values for background planet
  //mainGame = new GameSettings(color(random(255), random(255), random(255)), (int)random(5, 50), random(100, 300), PI / 20);
  mainGame = new GameSettings();
  
  health = new UI(20, 20, "Health (" + mainGame.shipHealthCurrent + " / " + mainGame.shipHealth + ")", mainGame.shipHealthColor);
  oxygen = new UI(20, 55, "Oxygen (" + mainGame.shipOxygenCurrent + " / " + mainGame.shipOxygen + ")", mainGame.shipOxygenColor);
  planetNameUI = new UI(20, 90, "Planet: " + mainGame.planetNameRandom, mainGame.planetNameUIColor);
  
  //Spaceship
  mainShip = new Ship(width/2 - 300, height/2);
  
  //Text modal
  modal1 = new UI(width/2 - 75, height/2, mainGame.planetNameRandom, color(255));
 
}

void draw() {
  
  background(0);
  
  //Create initial level
  mainGame.CreateLevel();
  mainGame.minusResource(mainGame.shipOxygenCurrent);
  
  //Draw UI
  health.draw();
  health.bar(20, 25, mainGame.shipHealth, 10, mainGame.shipHealthColor);
  oxygen.draw();
  oxygen.bar(20, 60, mainGame.shipOxygen, 10, mainGame.shipOxygenColor);
  planetNameUI.draw();
  
  //Draw the ship
  mainShip.draw();
  mainShip.drawPlayers();
  mainShip.playerMovement();
  
  modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  modal1.draw();
  
  // TODO: Move modal detection to method within UI class
  //if(mouseX > 1000 - planet.planetRadius) {
  //  modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  //  modal1.draw();
  //}
  
}

void keyPressed() {
  if(key == 'w') {
    mainGame.CreateLevel();
  }
}