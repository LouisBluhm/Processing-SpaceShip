class Dropship {

  PImage defaultDropship;

  float dropship_x = width/2;
  float dropship_y = height/2+300;
  boolean deployed = false;
  boolean charging = true;
  boolean paused = true;

  // Stats
  float energyGenerated = 0;
  float energyGain = 20;
  int energyUsage = 20;

  UI dropshipDisplay;
  Timer timer = new Timer(); 
  AudioPlayer charging_sfx;

  Dropship() {
    charging_sfx = minim.loadFile("assets/audio/charging.wav", 2048);
    defaultDropship = loadImage("assets/ship/dropship.png");
    dropshipDisplay = new UI(20, 120, color(0, 255, 0));
  }

  void draw() {
    if(deployed) {
      image(defaultDropship, dropship_x, dropship_y);
      if(mainGame.shipEnergyCurrent < mainGame.shipEnergy) {
        println("[INFO] Dropship deployed and charging cells");
        mainGame.shipEnergyUsage = 40;
        energyUsage = 40;
        status();
        charge();
      } else {
        dropshipDisplay.c = color(0, 255, 0);
        dropshipDisplay.draw("Dropship deployed");
        dropshipDisplay.text_string(20, 140, "Energy already full!", 20, color(255, 255, 0), LEFT, dropshipDisplay.font);
      }
    } else {
      mainGame.shipEnergyUsage = 60;
      energyUsage = 20;
      dropshipDisplay.c = color(255, 0, 0);
      dropshipDisplay.draw("Dropship not active");
    }
  }

  void charge() {
    if(charging) {
      println("[INFO] Dropship charging");
      timer.schedule(new TimerTask() {
        public void run() {
          if(!paused && mainGame.shipEnergyCurrent < mainGame.shipEnergy) {
            println("[INFO] Dropship generated " + energyGain);
            mainGame.shipEnergyCurrent += energyGain;
            energyGenerated += energyGain;
            charging_sfx.rewind();
            charging_sfx.play();
            println("[INFO] shipEnergyCurrent: " + mainGame.shipEnergyCurrent + " / " + mainGame.shipEnergy);
          }
        }
      }
      , 0, 5000);
      charging = false;
    }
  }

  void status() {
    if(rectHover(dropship_x-(187/2), dropship_y-(68/2), 187, 68)) {
      fill(31, 31, 31);
      rect(dropship_x, dropship_y-200, 150, 200);
    }
    dropshipDisplay.c = color(0, 255, 0);
    dropshipDisplay.draw("Dropship deployed");
    dropshipDisplay.text_string(dropship_x-90, dropship_y+60, "Energy generated:", 18, color(255), LEFT, dropshipDisplay.font);
    dropshipDisplay.text_string(dropship_x+100, dropship_y+60, str(energyGenerated), 18, color(255, 255, 0), RIGHT, dropshipDisplay.font);
  }
}