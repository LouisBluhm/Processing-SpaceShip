import ddf.minim.*;

AudioPlayer player;
Minim minim;
PFont font;

GameSettings mainGame, level2;
Ship mainShip;

Inventory inventory;
//boolean invOpen;
PImage backgroundImage;

void setup() {
  size(1440, 900, P3D);
  font = createFont("SharpRetro-48", 32);
  backgroundImage = loadImage("background.png");
  mainGame = new GameSettings();
  createAudio();
  textFont(font);
  //Inventory
  inventory = new Inventory();

  //Spaceship
  mainShip = new Ship(width/2 - 300, height/2);

  //Text modal
  mainGame.modal1 = new UI(width/2 - 75, height/2, mainGame.planetNameRandom, color(255));
}

void draw() {
  frameRate(144);
  surface.setTitle(int(frameRate) + " fps");

  background(backgroundImage);

  //Create initial level
  mainGame.createLevel();

  //mainGame.drawUI();
  //mainGame.minusResource(mainGame.shipOxygenCurrent);

  //Draw UI

  //Draw the ship
  mainShip.draw();
  //mainShip.drawPlayers();
  //mainShip.playerMovement();

  //mainGame.modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  //mainGame.modal1.draw();

  // TODO: Move modal detection to method within UI class
  //if(mouseX > 1000 - planet.planetRadius) {
  //  modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  //  modal1.draw();
  //}
  //println(mouseX, mouseY);
  if (mouseX > width-200 && mouseX < width-95 && mouseY > 15 && mouseY < height-830) {
    mainGame.buttonHover = true;
    //println("button hover detected in draw()");
  } else {
    mainGame.buttonHover = false;
  }
  
  if(inventory.invOpen) {
    inventory.loadDefault();
  }
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
  if (key == CODED) {
    if (keyCode == SHIFT) {
      inventory.invOpen = !inventory.invOpen;
    }
  }
}

void createAudio() {
  minim = new Minim(this);
  //battle music
  //player = minim.loadFile("music.mp3", 2048);
  //ambient music
  player = minim.loadFile("ambient.mp3", 2048);
  player.loop();
}