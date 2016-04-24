class UI {

  // Positioning and color
  float x, y;
  float shipSectionX, shipSectionY;
  color c;
  color hostility;
  
  // Game images
  // PImage inv;
  PImage shipSectionPanel;
  PImage travelPanel;
  PImage eventPanel;
  PImage planetHoverPanel;

  // Define the fonts used in program
  PFont font, font2;

  UI(float _x, float _y, color _c) {
    
    // Load the font files
    font = loadFont("assets/fonts/SharpRetro-48.vlw");
    font2 = loadFont("assets/fonts/pixelmix-bold-14.vlw");

    x = _x;
    y = _y;
    c = _c;
    
    // Various game images are loaded
    shipSectionPanel = loadImage("assets/ui/ship_area.png");
    shipSectionX = width/2 - 515;
    shipSectionY = height - 130;
    travelPanel = loadImage("assets/ui/travel.png");
    eventPanel = loadImage("assets/ui/modal1.png");
    planetHoverPanel = loadImage("assets/ui/planet_hover.png");
  }

  void draw(String title) {
    // Method to draw basic text from given string
    textFont(font, 140);
    fill(c);
    textAlign(0);
    textSize(19);
    text(title, x, y);
  }
  
  void hoverPanel(float hoverX, float hoverY, String message, String message2, String message3, float hoverWidth, float hoverHeight) {
    // Method to draw a panel when a specified item is hovered over, makes use of the text_string method
    fill(31, 31, 31);
    stroke(255);
    rect(hoverX, hoverY, hoverWidth, hoverHeight);
    text_string(hoverX+5, hoverY+20, message, 10, color(255), LEFT, font2);
    text_string(hoverX+5, hoverY+45, message2, 10, color(255), LEFT, font2);
    text_string(hoverX+5, hoverY+70, message3, 10, color(255), LEFT, font2);
  }

  void bar(float barX, float barY, float barWidth, float barHeight, color barColor, float barWidthTotal) {
    // Draws a bar from given parameters (used for ship health and energy etc.)
    rectMode(CORNER);
    stroke(255);
    fill(0);
    rect(barX, barY, barWidthTotal, barHeight);
    stroke(barColor);
    fill(barColor);
    rect(barX, barY, barWidth, barHeight);
  }

  void text_string(float x, float y, String string, int font_size, color c, int align, PFont text_font) {
    // The most commonly used method from this class
    // Draws text but has many parameters allowing for greater options, e.g. font, alignment
    textFont(text_font, 140);
    fill(c);
    textAlign(align);
    textSize(font_size);
    text(string, x, y);
  }

  void drawEventPanel() {
    // Draws the event panel when called in the Event class
    image(eventPanel, width/2, height/2);
  }

  void responsePanelClose() {
    
    // Checks for hover over the button, and changes colour if so
    rectMode(CENTER);
    if (rectHover(width/2-100, height/2 + 170, 200, 25)) {
      fill(30, 30, 30);
    } else {
      fill(51, 51, 51);
    }
    
    // Draws the exit button on the event menu
    rect(width/2, height/2+180, 200, 25);
    text_string(width/2, height/2+185, "Click here to close", 12, color(255), CENTER, font2);
    
    // If exit button is pressed the following is executed
    if (rectHover(width/2-100, height/2+170, 200, 25) && mousePressed) {
      
      // Event panel is closed
      mainGame.eventPanelClosed = true;
      mainGame.eventOpen = false;
      
      // If the ship is not alive after the event, initiate a game over
      if(mainShip.shipAlive == false) {
        mainGame.gameOver(0);
      }
      
      // If the player reachs the final planet, inform them and initiate a game complete
      if(mainGame.planet.planetCount == mainGame.planet.planetNames.length - 2) {
        println("[INFO] Player reach final planet");
        mainGame.gameOver(1);
      }
      
      // If all crew are dead, initiate a game over
      if(mainGame.all_crew_dead) {
        mainGame.gameOver(0);
      }
      
      // Call the Crew stat_increase method on event exit
      for(int i = 0; i < mainGame.crew.size(); i++) {
        mainGame.crew.get(i).stat_increase = true;
      }
      
      // Add a new Crew member to the Crew arraylist if a crew member was gained
      if(mainGame.newEvent.crew_gained) {
        // Adds a new crew member, using randomly generated stats
        mainGame.crew.add(new Crew(mainGame.crew_member_gained, mainGame.crew_roles[(int)(Math.random() * mainGame.crew_roles.length)], mainGame.last_crew_position_x + 60, 10, mainGame.last_crew_position_x + 60, 45));
        // Increments the x-position for drawing the crew on screen in the correct place
        mainGame.last_crew_position_x += 60;
        // Reverts the boolean back to false to stop if repeating every frame
        mainGame.newEvent.crew_gained = false;
      }
      
      // Play an audio effect on button press
      selection.rewind();
      selection.play();
    }
  }

  void shipSectionDisplay() {
    // Draws the ship section panel image and calls the corresponding method
    image(shipSectionPanel, shipSectionX, shipSectionY);
    mainShip.shipSectionDraw();
  }

  void planetHoverInfo() {
    // UI method to draw the planet hover info/stats
    image(planetHoverPanel, x, y);
    float textX = x - 165;
    float textXside = x + 165;
    int textSize = 20;
    int textSizePlanet = 24;
    // Line used to create space in the panel
    line(textX, y-145, textXside, y-145);
    // Planet name
    text_string(textX, y-150, "Planet: ", textSizePlanet, c, LEFT, font);
    text_string(textXside, y-150, mainGame.planet.planetNameRandom, textSizePlanet, c, RIGHT, font);
    // Species + Hostility
    text_string(textX, y-120, "Main Species: ", textSize, c, LEFT, font);
    text_string(textXside, y-120, mainGame.planet.planetSpeciesRandom, textSize, c, RIGHT, font);
    text_string(textX, y-100, "Hostility: ", textSize, c, LEFT, font);
    
    // Changes the hostility text colour depending on the generated hostility e.g. dangerous = red
    if (mainGame.planet.planetSpeciesHostility.equals("DANGEROUS")) {
      hostility = color(255, 0, 0);
    }
    if (mainGame.planet.planetSpeciesHostility.equals("PASSIVE")) {
      hostility = color(102, 135, 231);
    }
    if (mainGame.planet.planetSpeciesHostility.equals("NEUTRAL")) {
      hostility = color(255);
    }
    if (mainGame.planet.planetSpeciesHostility.equals("N/A")) {
      hostility = color(150, 76, 150);
    }
    text_string(textXside, y-100, mainGame.planet.planetSpeciesHostility, textSize, hostility, RIGHT, font);

    // Other stats
    text_string(textX, y-60, "Circumference: ", textSize, c, LEFT, font);
    text_string(textXside, y-60, mainGame.planet.planetCircumference + " km", textSize, c, RIGHT, font);
    text_string(textX, y-40, "Axial Tilt: ", textSize, c, LEFT, font);
    text_string(textXside, y-40, mainGame.planet.planetTilt + " RAD", textSize, c, RIGHT, font);
    text_string(textX, y-20, "Surface Temp: ", textSize, c, LEFT, font);
    text_string(textXside, y-20, mainGame.planet.planetTemperature + " DEG", textSize, c, RIGHT, font);
  }
}