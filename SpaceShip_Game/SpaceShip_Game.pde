GameSettings mainGame;
UI health, oxygen, planetNameUI, modal1;
Tile[] tiles = new Tile[10];

void setup() {
  size(1440, 900, P3D);
  
  //Iniate random values for background planet
  mainGame = new GameSettings(color(random(255), random(255), random(255)), (int)random(5, 50), random(100, 300), PI / 20);
  
  health = new UI(20, 20, "Health (" + mainGame.shipHealthCurrent + " / " + mainGame.shipHealth + ")", mainGame.shipHealthColor);
  oxygen = new UI(20, 55, "Oxygen (" + mainGame.shipOxygenCurrent + " / " + mainGame.shipOxygenCurrent + ")", mainGame.shipOxygenColor);
  planetNameUI = new UI(20, 90, "Planet: " + mainGame.planetNameRandom, mainGame.planetNameUIColor);
  
  modal1 = new UI(width/2 - 75, height/2, mainGame.planetNameRandom, color(255));
  
  //tile1 = new Tile(width/2, height/2, 500, 500, color(255));
 
}

void draw() {
  
  background(0);
  
  //Draw UI
  health.draw();
  health.bar(20, 25, mainGame.shipHealth, 10, mainGame.shipHealthColor);
  oxygen.draw();
  oxygen.bar(20, 60, mainGame.shipOxygen, 10, mainGame.shipOxygenColor);
  planetNameUI.draw();
  
  //Draw Planet
  mainGame.planetRender();
  
  if(mouseX > 1000 - mainGame.planetRadius) {
    modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
    modal1.draw();
  }

  
  //Draw Ship
  //tile1.display();
  
}