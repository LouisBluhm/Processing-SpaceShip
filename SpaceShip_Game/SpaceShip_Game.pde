import ddf.minim.*;

AudioPlayer player;
Minim minim;

GameSettings mainGame;
Ship mainShip;

PImage backgroundImage, menu1img, menu2img, menu3img;

Event eventChecker;

int currentScreen;

void setup() {
  //Size of window and use of 3D Engine
  size(1440, 900, P3D);
  //Set background image for window
  backgroundImage = loadImage("background.png");
  menu1img = loadImage("menu1.png");
  menu2img = loadImage("menu2.png");
  menu3img = loadImage("menu3.png");
  
  //Create a new game instance
  mainGame = new GameSettings();
  
  //Load audio for game instance
  createAudio();

  //Spaceship
  mainShip = new Ship(width/2 - 300, height/2);

  //Text modal
  mainGame.modal1 = new UI(width/2 - 75, height/2, mainGame.planet.planetNameRandom, color(255));

  //Create a new event object
  eventChecker = new Event();
  
}

void draw() {

  frameRate(60);
  surface.setTitle("Ventura - alpha 1.2 | " + int(frameRate) + " fps");

  drawMainGame();

  // Menu selection
  //switch(currentScreen) {
  //  case 0: drawMenu1(); break;
  //  case 1: drawMenu2(); break;
  //  case 2: drawMenu3(); break;
  //  case 3: drawMainGame(); break;
  //}
}

void drawMenu1() {
  background(menu1img);
}
void drawMenu2() {
  background(menu2img);
}
void drawMenu3() {
  background(menu3img);
}

void drawMainGame() {
  background(backgroundImage);
  
  //Draw the ship
  mainShip.draw();
  
  //Create initial level
  mainGame.createLevel();
  
  //Check for random events
  eventChecker.createEvent();

  if(mousePressed && mainGame.eventPanelClosed == false) {
    println("Event panel closed!");
    mainGame.eventPanelClosed = true;
  }

  // TODO: Move modal detection to method within UI class
  //if(mouseX > 1000 - planet.planetRadius) {
  //  modal1.modal(width/2, height/2, 300, 100, color(89, 89, 89));
  //  modal1.draw();
  //}
  //println(mouseX, mouseY);
  if (mouseX > width-200 && mouseX < width-95 && mouseY > 15 && mouseY < height-830) {
    mainGame.buttonHover = true;
  } else {
    mainGame.buttonHover = false;
  }
}

void mousePressed() {
  if(currentScreen < 3) currentScreen++;
}

void keyPressed() {
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
  if (key == 'w') {
    mainGame.inventoryOpen = !mainGame.inventoryOpen;
    mainGame.travelPanelOpen = false;
  }
  if (key == 'q') {
    mainGame.travelPanelOpen = !mainGame.travelPanelOpen;
    mainGame.inventoryOpen = false;
  }
}

void createAudio() {
  minim = new Minim(this);
  //battle music
  //player = minim.loadFile("music.mp3", 2048);
  //ambient music
  player = minim.loadFile("ambient.mp3", 2048);
  //menu music
  //player = minim.loadFile("menu.mp3", 2048);
  //player.loop();
}