GameSettings mainGame;
UI health, oxygen;

void setup() {
  size(1440, 900, P3D);
  
  //Iniate random values for background planet
  mainGame = new GameSettings(color(random(255), random(255), random(255)), (int)random(5, 11), random(40, 300), PI / 20);
  
  health = new UI(20, 20, "Health (" + mainGame.shipHealthCurrent + " / " + mainGame.shipHealth + ")", mainGame.shipHealthColor);
  oxygen = new UI(20, 55, "Oxygen (" + mainGame.shipOxygenCurrent + " / " + mainGame.shipOxygenCurrent + ")", mainGame.shipOxygenColor);
  
}

void draw() {
  
  background(0);
  
  mainGame.planetRender();
  
  health.draw();
  health.bar(20, 25, mainGame.shipHealth, 10, mainGame.shipHealthColor);
  
  oxygen.draw();
  oxygen.bar(20, 60, mainGame.shipOxygen, 10, mainGame.shipOxygenColor);
  
}