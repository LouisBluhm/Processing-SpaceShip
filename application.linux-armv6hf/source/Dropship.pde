class Dropship {

  PImage defaultDropship;

  float dropship_x = width/2;
  float dropship_y = height/2+300;
  boolean deployed = false;
  boolean charging = true;
  boolean paused = true;

  // Dropship Stats
  float energyGenerated = 0;
  float energyGain = 20;
  int energyUsage = 20;

  // UI dropship display object
  UI dropshipDisplay;
  // Create a new Timer object
  Timer timer = new Timer(); 

  Dropship() {
    defaultDropship = loadImage("assets/ship/dropship.png");
    dropshipDisplay = new UI(20, 120, color(0, 255, 0));
  }

  void draw() {
    // Draw the dropship on screen if deployed = true
    if(deployed) {
      image(defaultDropship, dropship_x, dropship_y);
      if(mainGame.shipEnergyCurrent < mainGame.shipEnergy) {
        // Executed if energy cells need charging
        println("[INFO] Dropship deployed and charging cells");
        mainGame.shipEnergyUsage = 40;
      // Change the power usage of the ship engines/dropship energy
        energyUsage = 40;
        status();
        charge();
      } else {
        // Executed if energy cells are already full
        dropshipDisplay.c = color(0, 255, 0);
        dropshipDisplay.draw("Dropship deployed");
        dropshipDisplay.text_string(20, 140, "Energy already full!", 20, color(255, 255, 0), LEFT, dropshipDisplay.font);
      }
    } else {
      // Tell the user the dropship is not active
      mainGame.shipEnergyUsage = 60;
      // Change the power usage of the ship engines/dropship energy
      energyUsage = 20;
      dropshipDisplay.c = color(255, 0, 0);
      dropshipDisplay.draw("Dropship not active");
    }
  }

  void charge() {
    if(charging) {
      println("[INFO] Dropship charging");
      // Start the timer .schedule when the dropship is charging energy cells
      // @@@REF:2
      timer.schedule(new TimerTask() {
        public void run() {
          if(!paused && mainGame.shipEnergyCurrent < mainGame.shipEnergy) {
            println("[INFO] Dropship generated " + energyGain);
            // Increment the shipEnergyCurrent variable by the amount of energy gained
            mainGame.shipEnergyCurrent += energyGain;
            energyGenerated += energyGain;
            // Rewind the audio effect and play it each time run() is executed
            // Without rewind, it would only play the audio on the first run
            charging_sfx.rewind();
            charging_sfx.play();
            println("[INFO] shipEnergyCurrent: " + mainGame.shipEnergyCurrent + " / " + mainGame.shipEnergy);
          }
        }
      }
      // Repeat run() every 5 seconds
      , 0, 5000);
      // Charging changed to false to stop the timer being created every frame
      charging = false;
    }
  }

  void status() {
    // Status method to inform player of energy generated / dropship deployed
    dropshipDisplay.c = color(0, 255, 0);
    dropshipDisplay.draw("Dropship deployed");
    dropshipDisplay.text_string(dropship_x-90, dropship_y+60, "Energy generated:", 18, color(255), LEFT, dropshipDisplay.font);
    dropshipDisplay.text_string(dropship_x+100, dropship_y+60, str(energyGenerated), 18, color(255, 255, 0), RIGHT, dropshipDisplay.font);
  }
}