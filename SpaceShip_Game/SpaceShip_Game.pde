GameSettings mainGame = new GameSettings();
UI health, oxygen;

void setup() {
  size(1440, 900);
  
  health = new UI(20, 20, "Health (" + mainGame.shipHealthCurrent + " / " + mainGame.shipHealth + ")", mainGame.shipHealthColor);
  oxygen = new UI(20, 55, "Oxygen (" + mainGame.shipOxygenCurrent + " / " + mainGame.shipOxygenCurrent + ")", mainGame.shipOxygenColor);
  
}

void draw() {
  background(0);
  
  health.draw();
  health.bar(20, 25, mainGame.shipHealth, 10, mainGame.shipHealthColor);
  
  oxygen.draw();
  oxygen.bar(20, 60, mainGame.shipOxygen, 10, mainGame.shipOxygenColor);
  
}