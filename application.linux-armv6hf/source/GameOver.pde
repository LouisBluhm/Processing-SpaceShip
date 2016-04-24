class GameOver {
  
  // Load state images
  PImage game_over_background, game_complete_background;
  // Create the gameOverText UI object
  UI gameOverText;
  int type;
  
  // Stats
  int crew_alive = 0;
  boolean crew_check = true;
  int score = 0;
  
  GameOver(int _type) {
    type = _type;
    game_over_background = loadImage("assets/states/game_over.png");
    game_complete_background = loadImage("assets/states/game_complete_background.png");
    // Initialize the UI object
    gameOverText = new UI(width/2, height/2+200, color(255));
  }
  
  void draw() {
    if(type == 0) {
      // Game over screen is drawn
      image(game_over_background, 0, 0);
      // Displays stats to the user about their playthrough
      getStats();            
    } else {
      // Game complete screen is drawn
      image(game_complete_background, 0, 0);
      getStats();
    }
  }
  
  void getStats() {
    if(type == 0) {
      // Type 0 means the player died before reaching the end, hence the current planet is shown in the stats
      gameOverText.text_string(gameOverText.x, gameOverText.y, "You made it to the planet " + mainGame.travel.currentPlanet, 24, gameOverText.c, CENTER, gameOverText.font);
    } else {
      gameOverText.text_string(gameOverText.x, gameOverText.y, "You made it to the planet Hypersia", 24, gameOverText.c, CENTER, gameOverText.font);
    }
    if(crew_check) {
      // Checks how many crew members are alive when state is entered
      for(int i = mainGame.crew.size() - 1; i >= 0; i--) {
        if(mainGame.crew.get(i).alive) {
          // Increments counter is crew.get(i).alive == true
          crew_alive++;
        }
      }
        // Random score formula
        score = crew_alive + mainGame.planet.planetCount * 25;
        // State changed to false to stop the score increasing each frame
        crew_check = false;
      }
      
      // Draws the stats text to screen
      gameOverText.text_string(gameOverText.x, gameOverText.y + 25, "You had " + crew_alive + " crew remaining", 24, gameOverText.c, CENTER, gameOverText.font);
      gameOverText.text_string(gameOverText.x, gameOverText.y + 50, "Your score is " + score, 24, gameOverText.c, CENTER, gameOverText.font);
      gameOverText.text_string(gameOverText.x, gameOverText.y + 100, "Click anywhere to quit", 22, gameOverText.c, CENTER, gameOverText.font);
      
      // If mouse is pressed anywhere, exit the program
      if(mousePressed) {
        exit();
      }
  }
}