class GameOver {
  
  PImage game_over_background;
  UI gameOverText;
  
  // Stats
  int crew_alive = 0;
  boolean crew_check = true;
  int score = 0;
  
  GameOver() {
    game_over_background = loadImage("game_over.png");
    gameOverText = new UI(width/2, height/2+200, "You made it to the planet " + mainGame.travel.currentPlanet, color(255));
  }
  
  void draw() {
    image(game_over_background, 0, 0);
    
    gameOverText.text_string(gameOverText.x, gameOverText.y, "You made it to the planet " + mainGame.travel.currentPlanet, 24, gameOverText.c, CENTER, gameOverText.font);

    if(crew_check) {
      for(int i = mainGame.crew.size() - 1; i >= 0; i--) {
        if(mainGame.crew.get(i).alive) {
          crew_alive++;
        }
      }
      score = crew_alive + mainGame.planet.planetCount * 25;
      crew_check = false;
    }
    
    gameOverText.text_string(gameOverText.x, gameOverText.y + 25, "You had " + crew_alive + " crew remaining", 24, gameOverText.c, CENTER, gameOverText.font);
    gameOverText.text_string(gameOverText.x, gameOverText.y + 50, "Your score is " + score, 24, gameOverText.c, CENTER, gameOverText.font);
    gameOverText.text_string(gameOverText.x, gameOverText.y + 100, "Click anywhere to quit", 22, gameOverText.c, CENTER, gameOverText.font);
    
    if(mousePressed) {
      exit();
    }
  }
}