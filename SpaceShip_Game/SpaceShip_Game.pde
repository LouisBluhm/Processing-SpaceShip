import ddf.minim.*;

AudioPlayer player;
Minim minim;

GameSettings mainGame;
Ship mainShip;

void setup() {
  size(1440, 900, P3D);

  mainGame = new GameSettings();
  createAudio();

  //Spaceship
  mainShip = new Ship(width/2 - 300, height/2);

  //Text modal
  mainGame.modal1 = new UI(width/2 - 75, height/2, mainGame.planetNameRandom, color(255));
}

void draw() {

  background(0);

  //Create initial level
  mainGame.createLevel();
  //mainGame.drawUI();
  
  mainGame.minusResource(mainGame.shipOxygenCurrent);
  
  //Draw UI

  //Draw the ship
  mainShip.draw();
  mainShip.drawPlayers();
  mainShip.playerMovement();

  mainGame.modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  mainGame.modal1.draw();

  // TODO: Move modal detection to method within UI class
  //if(mouseX > 1000 - planet.planetRadius) {
  //  modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  //  modal1.draw();
  //}
}

void keyPressed() {
  if (key == 'w') {
    mainGame.createLevel();
  }
  if (key == 'm' && mainGame.audioMuted == false) {
    println("audio muted");
    mainGame.audioMuted = true;
    player.mute();
  }
  if (key == 'n' && mainGame.audioMuted == true) {
    println("audio unmuted");
    mainGame.audioMuted = false;
    player.unmute();
  }
}

void createAudio() {
  minim = new Minim(this);
  //battle music
  //player = minim.loadFile("music.mp3", 2048);
  //ambient music
  player = minim.loadFile("ambient.mp3", 2048);
  //player.loop();
}