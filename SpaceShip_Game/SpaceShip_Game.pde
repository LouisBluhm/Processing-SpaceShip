// VENTURA - A game by Louis Bluhm
// Github.com/kritzware/ventura
//
// NOTE: I have included references and other comments in README.txt
// References to code are marked by '@@@ REF:x' (where x = corresponding reference number)
// NOTE 2: Throughout the code there are println("[INFO]") or println("[DEBUG]") which I used during debugging, these can be ignored.
//

// Importing required packages
import ddf.minim.*;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

// Create the audio objects
AudioPlayer game_over_music, selection, error, beep, ambient, charging_sfx;
Minim minim;

// Create a main game and ship
GameSettings mainGame;
Ship mainShip;

// Load images for menu selection
PImage backgroundImage, menu1, menu2, menu3;
int currentScreen;

void setup() {
  // Use of P3D Engine
  size(1440, 900, P3D);
  surface.setResizable(false);
  
  // Load background images for windows
  backgroundImage = loadImage("assets/states/background.png");
  menu1 = loadImage("assets/states/menu1.png");
  menu2 = loadImage("assets/states/menu2.png");
  menu3 = loadImage("assets/states/controls.png");

  // Create a new game instance
  mainGame = new GameSettings();

  // Load audio for game instance
  createAudio();

  // Spaceship
  mainShip = new Ship(width/2 - 300, height/2);
}

void draw() {

  frameRate(60);
  // Display FPS in Window title, useful while debugging/optimizing
  //surface.setTitle("Ventura - alpha | " + int(frameRate) + " fps");
  surface.setTitle("Ventura");
 
  // Menu selection screens
  switch(currentScreen) {
  case 0: drawMenu(menu1); break;
  case 1: drawMenu(menu2); break;
  case 2: drawMenu(menu3); break;
  case 3: drawMainGame(); break;
  }
}

void drawMenu(PImage screen) {
  // Draws the menu screen defined by the function parameter
  background(screen);
}

void drawMainGame() {
  // This functions draws the main game and checks if the game is over
  if(mainGame.game_over == false) {
    background(backgroundImage);
    mainShip.draw();
    // Method which creates the game level
    mainGame.createLevel();
  } else {
    mainGame.mainGameOver.draw();
  }  
}

void mousePressed() {
  // Keeps track of the current screen during the menu
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
  if (key == 'q') {
    mainGame.travelPanelOpen = !mainGame.travelPanelOpen;
    mainGame.inventoryOpen = false;
  }
  if (key == 'w') {
    mainShip.dropship.charging = true;
    mainShip.dropship.deployed = !mainShip.dropship.deployed;
    mainShip.dropship.paused = !mainShip.dropship.paused;
    mainShip.dropship.energyGenerated = 0;
  }
  //if (key == 'k') {
  //  mainGame.shipEnergyCurrent += 100;
  //}
  //if (key == 'j') {
  //  mainGame.shipEnergyCurrent -= 100;
  //}
  //if (key == 'g') {
  //  mainGame.gameOver(1);
  //}
  //if (key == 'h') {
  //  mainGame.gameOver(0);
  //}
  //if (key == 'l') {
  //  for(Crew members : mainGame.crew) {
  //    members.alive = false;
  //  }
  //}
}

void createAudio() {
  // Audio is loaded here
  minim = new Minim(this);
  // Ambient music
  ambient = minim.loadFile("assets/audio/ambient2.mp3", 2048);
  // Loop the main ambient music during the game
  ambient.loop();
  // Gameover music
  game_over_music = minim.loadFile("assets/audio/game_over.mp3", 2048);
  // Menu selection
  selection = minim.loadFile("assets/audio/selection.wav", 2048);
  // Error
  error = minim.loadFile("assets/audio/error.wav", 2048);
  // Beep
  beep = minim.loadFile("assets/audio/beep.wav", 2048);
  // Charging
  charging_sfx = minim.loadFile("assets/audio/charging.wav", 2048);
}

// Global functions for use in other classes

// @@@REF:1
boolean rectHover(float x, float y, float w, float h) {
  // Returns true if mouseX and mouseY are within the boundaries of the rectangle
  return (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
}

// @@@REF:1
boolean ellipseHover(float x, float y, float diameter) {
  // Returns true if the distance of the mouse and x,y is less than the diameter of the ellipse
  if (dist(mouseX, mouseY, x, y) < diameter * 0.5) {
    return true;
  } else {
    return false;
  }
}