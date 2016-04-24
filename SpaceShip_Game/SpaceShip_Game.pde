import ddf.minim.*;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

AudioPlayer game_over_music, selection, error, beep, ambient;
Minim minim;

GameSettings mainGame;
Ship mainShip;

PImage backgroundImage, menu1img, menu2img, menu3img;
int currentScreen;

void setup() {
  // Use of 3D Engine
  // size(1440, 900, OPENGL);
  size(1440, 900, P3D);
  surface.setResizable(false);
  
  // Load background images for windows
  backgroundImage = loadImage("background.png");
  menu1img = loadImage("menu1.png");
  menu2img = loadImage("menu2.png");
  menu3img = loadImage("menu3.png");

  // Create a new game instance
  mainGame = new GameSettings();

  // Load audio for game instance
  createAudio();

  // Spaceship
  mainShip = new Ship(width/2 - 300, height/2);
}

void draw() {

  frameRate(60);
  // Display FPS in Window title, useful while debugging
  surface.setTitle("Ventura - alpha 1.2 | " + int(frameRate) + " fps");
  
  minim.stop();
  drawMainGame();
  
  // Menu selection
  //switch(currentScreen) {
  //case 0: drawMenu1(); break;
  //case 1: drawMenu2(); break;
  //case 2: drawMenu3(); break;
  //case 3: drawMainGame(); break;
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
  
  //if(mainShip.shipAlive) {
  //    background(backgroundImage);

  //    // Draw the ship
  //    mainShip.draw();
    
  //    // Create initial level
  //    mainGame.createLevel();
  //} else {
  //   mainGame.gameOver();
  //}
  if(mainGame.game_over == false) {
    background(backgroundImage);
    mainShip.draw();
    mainGame.createLevel();
  } else {
    mainGame.mainGameOver.draw();
  }

  
}

void mousePressed() {
  if (currentScreen < 3) currentScreen++;
}

void keyPressed() {
  if (key == 'm' && mainGame.audioMuted == false) {
   println("audio muted");
   mainGame.audioMuted = true;
   ambient.mute();
  }
  if (key == 'n' && mainGame.audioMuted == true) {
   println("audio unmuted");
   mainGame.audioMuted = false;
   ambient.unmute();
  }
  if (key == 'w') {
    mainGame.inventoryOpen = !mainGame.inventoryOpen;
    mainGame.travelPanelOpen = false;
  }
  if (key == 'q') {
    mainGame.travelPanelOpen = !mainGame.travelPanelOpen;
    mainGame.inventoryOpen = false;
  }
  if (key == 'c') {
    mainGame.createPlanet();
  }
  if (key == 'v') {
    mainShip.dropship.charging = true;
    mainShip.dropship.deployed = !mainShip.dropship.deployed;
    mainShip.dropship.paused = !mainShip.dropship.paused;
    mainShip.dropship.energyGenerated = 0;
  }
  if (key == 'k') {
    mainGame.shipEnergyCurrent += 100;
  }
  if (key == 'j') {
    mainGame.shipEnergyCurrent -= 100;
  }
  if (key == 'g') {
    mainGame.gameOver();
  }
}

void createAudio() {
  minim = new Minim(this);
  //battle music
  //player = minim.loadFile("assets/audio/music.mp3", 2048);
  // Ambient music
  ambient = minim.loadFile("assets/audio/ambient2.mp3", 2048);
  ambient.loop();
  // Gameover music
  game_over_music = minim.loadFile("assets/audio/game_over.mp3", 2048);
  // Menu selection
  selection = minim.loadFile("assets/audio/selection.wav", 2048);
  // Error
  error = minim.loadFile("assets/audio/error.wav", 2048);
  // Beep
  beep = minim.loadFile("assets/audio/beep.wav", 2048);
}

// Global functions

boolean rectHover(float x, float y, float w, float h) {
  return (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
}

boolean ellipseHover(float x, float y, float diameter) {
  if (dist(mouseX, mouseY, x, y) < diameter * 0.5) {
    return true;
  } else {
    return false;
  }
}