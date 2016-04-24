import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import java.util.Map; 
import java.util.Timer; 
import java.util.TimerTask; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SpaceShip_Game extends PApplet {

// VENTURA - A game by Louis Bluhm
// Github.com/kritzware/ventura
//
// NOTE: I have included references and other comments in README.txt
// References to code are marked by '@@@ REF:x' (where x = corresponding reference number)
// NOTE 2: Throughout the code there are println("[INFO]") or println("[DEBUG]") which I used during debugging, these can be ignored.
//

// Importing required packages





// Create the audio objects
AudioPlayer game_over_music, selection, error, beep, ambient, charging_sfx;
Minim minim;

// Create a main game and ship
GameSettings mainGame;
Ship mainShip;

// Load images for menu selection
PImage backgroundImage, menu1, menu2, menu3;
int currentScreen;

public void setup() {
  // Use of P3D Engine
  
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

public void draw() {

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

public void drawMenu(PImage screen) {
  // Draws the menu screen defined by the function parameter
  background(screen);
}

public void drawMainGame() {
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

public void mousePressed() {
  // Keeps track of the current screen during the menu
  if (currentScreen < 3) currentScreen++;
}

public void keyPressed() {
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

public void createAudio() {
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
public boolean rectHover(float x, float y, float w, float h) {
  // Returns true if mouseX and mouseY are within the boundaries of the rectangle
  return (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
}

// @@@REF:1
public boolean ellipseHover(float x, float y, float diameter) {
  // Returns true if the distance of the mouse and x,y is less than the diameter of the ellipse
  if (dist(mouseX, mouseY, x, y) < diameter * 0.5f) {
    return true;
  } else {
    return false;
  }
}
class Crew {
  
  PImage crew_icon, crew_icon_dead;
  
  // Crew settings
  int crewCurrentHealthColor = color(0, 255, 0);  
  float crewNameX, crewNameY;
  float crewIconX, crewIconY;
  
  // Crew stats
  String crewName, crewRole;
  float crewHealth = 100;
  float crewCurrentHealth = 100;
  int INT, STR, CHAR, DEX;
  boolean alive = true;
  boolean stat_increase = false;
  
  // Crew UI object
  UI crewInfo;  
  
  Crew(String _crewName, String _crewRole, float _crewIconX, float _crewIconY, float _crewNameX, float _crewNameY) {
    
    crewName = _crewName;
    crewRole = _crewRole;
    crewIconX = _crewIconX;
    crewIconY = _crewIconY;
    crewNameX = _crewNameX;
    crewNameY = _crewNameY;
    
    // Assign random starting stats for each crew member
    INT = (int)random(1, 6);
    STR = (int)random(1, 6);
    CHAR = (int)random(1, 6);
    DEX = (int)random(1, 6);
    
    crew_icon = loadImage("assets/ui/crew_icon.png");
    crew_icon_dead = loadImage("assets/ui/crew_icon_dead.png");
    
    crewInfo = new UI(crewNameX, crewNameY, color(255));
  }
  
  public void icon(float x, float y) {
    // Display the crew icon image
    imageMode(CORNER);
    image(crew_icon, x, y);
  }

  public void status() {
    // Status method which checks for updates to crew health/stats
    if(crewCurrentHealth > 50) {
      crewCurrentHealthColor = mainGame.goodHP;
    }
    if(crewCurrentHealth <= 50) {
      crewCurrentHealthColor = mainGame.lowHP;
    }
    if(crewCurrentHealth <= 25) {
      crewCurrentHealthColor = mainGame.verylowHP;
    }
    if(crewCurrentHealth <= 0) {
      crewCurrentHealth = 0;
      crewHealth = 0;
    }
    // Increment stats for characters every 2 planets
    if(mainGame.planet.planetCount % 2 == 0 && stat_increase) {
      int stat_incr = (int)random(0, 4);
      switch(stat_incr) {
        case 0: INT++;
        case 1: STR++;
        case 2: CHAR++;
        case 3: DEX++;
      }
      stat_increase = false;
    }
  }
  
  public void draw_crew() {
    // Draw the crew in the main game
    check_crew();
    icon(crewIconX, crewIconY);
    crewInfo.text_string(crewInfo.x, crewInfo.y, crewName, 16, crewInfo.c, LEFT, crewInfo.font);
    // Check the status of crew members
    status();
    // Draw the health bar for crew members/ change crew icon image if they are dead
    crewInfo.bar(crewNameX, crewNameY+4, crewCurrentHealth * 0.5f, 2, crewCurrentHealthColor, 0);
    if(alive == false) {
      crew_icon = crew_icon_dead;
      crewInfo.c = color(255, 0, 0);
      crewCurrentHealth = 0;
    }
  }

  public void check_crew() {
    // Display rect on crew hover
    if(rectHover(crewIconX, crewIconY, 50, 50) && mainGame.eventOpen == false && alive == true) {
      stroke(114, 188, 212);
      fill(51, 51, 51);
      rect(crewIconX, crewIconY, 50, 50);
      if(mousePressed) {
        // If mouse is pressed draw a detailed crew panel as well
        draw_crew_detailed();
      }
    }
  }

  public void changeHealth(int amount) {
   // Crew method to change the health of a crew member
   println("[INFO] Changing health of " + this.getClass().getCanonicalName() + " by " + amount);
   if(!(crewCurrentHealth + amount >= crewHealth)) {
     crewCurrentHealth += amount;
   }
   if(crewCurrentHealth + amount <= 0) {
     alive = false;
   }
  }
  
  public void draw_crew_detailed() {
    // Draw UI elements on screen, showing more information about a crew member
    rect(crewIconX+25, crewIconY+50, 150, 200);
    crewInfo.text_string(crewIconX+30, crewIconY+65, "Name: " + crewName, 20, color(255), LEFT, crewInfo.font);
    crewInfo.text_string(crewIconX+30, crewIconY+80, "HP: " + (int)crewCurrentHealth + "%", 20, crewCurrentHealthColor, LEFT, crewInfo.font);
    crewInfo.text_string(crewIconX+30, crewIconY+95, "Role: " + crewRole, 20, color(255), LEFT, crewInfo.font);
    line(crewIconX+30, crewIconY+105, crewIconX+170, crewIconY+105);
    crewInfo.text_string(crewIconX+30, crewIconY+125, "INT: " + INT, 20, color(255), LEFT, crewInfo.font);
    crewInfo.text_string(crewIconX+30, crewIconY+140, "STR: " + STR, 20, color(255), LEFT, crewInfo.font);
    crewInfo.text_string(crewIconX+30, crewIconY+155, "CHAR: " + CHAR, 20, color(255), LEFT, crewInfo.font);
    crewInfo.text_string(crewIconX+30, crewIconY+170, "DEX: " + DEX, 20, color(255), LEFT, crewInfo.font);
  }
  
}
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

  public void draw() {
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

  public void charge() {
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

  public void status() {
    // Status method to inform player of energy generated / dropship deployed
    dropshipDisplay.c = color(0, 255, 0);
    dropshipDisplay.draw("Dropship deployed");
    dropshipDisplay.text_string(dropship_x-90, dropship_y+60, "Energy generated:", 18, color(255), LEFT, dropshipDisplay.font);
    dropshipDisplay.text_string(dropship_x+100, dropship_y+60, str(energyGenerated), 18, color(255, 255, 0), RIGHT, dropshipDisplay.font);
  }
}
class Event {
  
  // The event class parses the JSON file in which we store the events, creates the event modals and status logging
  // I experimented with other forms of data structures for the events system, such as SVG, but settled with JSON as it was the most efficient to use
  // The good thing about this parser is that once is was finished and tested, events could be added easily by simply writing them in the JSON file
  // rather than adding new code to display more events

  // Create JSON object / arrays
  JSONObject json, event;
  JSONArray events, choices, stats_array;
  float events_length;

  // ID of each event
  int event_id;
  // Choice player makes in response menu
  int player_choice;
  // The actual event text
  String event_message;
  // Event message split into an array if the string is too large for the modal
  String[] split_event_message;
  boolean event_stats_done = false;
  String ship_health_output;

  // Array to store choices
  String[] choice_text;
  // Array for stats_to_get used in for loop to get the correct information from the JSON file
  String[] stats_to_get = {"message", "ship_health", "crew_health", "oxygen", "missiles", "crew_gain", "energy"};
  
  // Create various JSON objects / array
  JSONObject[] response_objects;
  JSONArray[] response_object_array;
  JSONObject[] object_responses;
  
  // Arrays that hold the information collected from each player choice
  String[] responses;
  String[] split_responses;
  int[] responses_ship_health, responses_crew_health, responses_oxygen;
  int[] responses_missiles, responses_crew_gain, responses_energy;

  // Create UI object
  UI eventMessage;

  // UI positioning arrays
  float response_xpos = width/2 - 300;
  float[] response_ypos = {height/2+30, height/2+70, height/2+110};
  float[] crew_logs_ypos = {height/2+110, height/2+130, height/2+150};
  
  // Other variables/states
  float timer;
  boolean event_message_open = false;
  int crew_stat_change;
  boolean[] event_parse_check;
  boolean crew_gained = false;
  int event_to_get;
  
  // String parsing
  int message_count = 0;
  int response_count = 0;

  Event() {
    // Create empty arrays/json objects of length 3 (i.e. the amount of player choices)
    choice_text = new String[3];
    response_objects =  new JSONObject[3];
    response_object_array = new JSONArray[3];
    object_responses = new JSONObject[3];
    responses = new String[3];
    responses_ship_health = new int[3];
    responses_crew_health = new int[3];
    responses_oxygen = new int[3];
    responses_missiles = new int[3];
    responses_crew_gain = new int[3];
    responses_energy = new int[3];
    event_parse_check = new boolean[3];
    
    // Load the main JSON file
    json = loadJSONObject("events/events.json");

    // Load the main events array
    events = json.getJSONArray("events");

    // Get a random event from events array
    events_length = events.size();
    println("[DEBUG] " + events_length + " events found in data file");
    
    // Check if the event has been done already during the playthrough
    if(mainGame.event_fill_done == false) {
      for(int i = 0; i < events_length; i++) {
        mainGame.events_to_check.add(i);
      }
      mainGame.event_fill_done = true;
    }
    
    // Get a random event id from events that haven't been done already
    // Takes a random int from 0-size of events_to_check arraylist
    int random_int_event = (int)random(mainGame.events_to_check.size());
    // Chooses this event as the event to parse
    event_to_get = mainGame.events_to_check.get(random_int_event);
    println("[DEBUG] Event chosen: " + event_to_get + " from " + mainGame.events_to_check.size() + " possible events");

    // Get the main event and ID
    event = events.getJSONObject(event_to_get);
    event_id = event.getInt("id");

    split_event_message = new String[(int)events_length];
    // Get the event message
    event_message = event.getString("message");
    println("[DEBUG] New event message: " + event_message);
    
    // Split event message if '.' is detected
    split_event_message = split(event_message, '.');
    // Find the number of '.' in the message
    message_count = stringSearch(event_message, ".");

    // Get an array of responses for the event
    choices = event.getJSONArray("responses");
    // Get the stats array for the event
    stats_array = event.getJSONArray("stats");
    
    // Load the response data into an array
    for (int i = 0; i < choices.size(); i++) {
      // Each choice is loaded into index i in the choices array
      choice_text[i] = choices.getJSONObject(i).getString("response");
    }
    
    // Loops through the main stats array in the event
    for (int i = 0; i < stats_array.size(); i++) {
      // Gets each stats array for each response
      response_objects[i] = stats_array.getJSONObject(i);
      // Gets each stat from the response array above
      response_object_array[i] = response_objects[i].getJSONArray("response");
      
      // Adds responses/stats to responses arrays, loads the data we use for changing ship health etc.
      responses[i] = response_object_array[i].getJSONObject(0).getString(stats_to_get[0]);
      responses_ship_health[i] = response_object_array[i].getJSONObject(1).getInt(stats_to_get[1]);
      responses_crew_health[i] = response_object_array[i].getJSONObject(2).getInt(stats_to_get[2]);
      responses_oxygen[i] = response_object_array[i].getJSONObject(3).getInt(stats_to_get[3]);
      responses_missiles[i] = response_object_array[i].getJSONObject(4).getInt(stats_to_get[4]);
      responses_crew_gain[i] = response_object_array[i].getJSONObject(5).getInt(stats_to_get[5]);
      responses_energy[i] = response_object_array[i].getJSONObject(6).getInt(stats_to_get[6]);
    }
    
    // Create the event message UI object
    eventMessage = new UI(width/2, height/2-100, color(255));
    // Starts a timer
    timer = second();
    // Chooses a random int used to select the crew member to have their stats manipulated
    crew_stat_change = (int)random(0, mainGame.crew.size());
    
    // Remove the event from events done array
    mainGame.events_to_check.remove(random_int_event);
  }

  public void displayEventMessage() {
    // Display the event a second after displayEventMesage is executed
    if(second() > timer && event_message_open == false) {
      // Changes the event_message_open state to true
      event_message_open = true;
      // Rewind the audio effect and play it
      beep.rewind();
      beep.play();
    }
    if(event_message_open) {
      // println("[DEBUG] Alert: " + second() + " > " + timer);
      
      // Calls the UI object to draw the event panel (the image background)
      eventMessage.drawEventPanel();
      
      if (mainGame.eventResponsesOpen == false) {
        // Draws the event message with a UI text_string method
        eventMessage.text_string(eventMessage.x, eventMessage.y, split_event_message[0], mainGame.event_message_size, eventMessage.c, CENTER, eventMessage.font2);
        // If the message was two sentences long, then include the 2nd sentence
        if(message_count >= 1) {
          eventMessage.text_string(eventMessage.x, eventMessage.y + 25, split_event_message[1], mainGame.event_message_size, eventMessage.c, CENTER, eventMessage.font2);
        }
        eventMessageHover();
        for (int i = 0; i < 3; i++) {
          // Draws the event choices the player can make
          // Note the eventParse method used where the string is defined in the text_string method
          eventMessage.text_string(response_xpos, response_ypos[i], eventParse(choice_text[i], i), mainGame.event_choice_size, eventMessage.c, LEFT, eventMessage.font2);
        }
      }
      // If the player makes a choice, draw the response to that choice (calls the displayEventResponse method)
      if (mainGame.eventResponsesOpen) {
        displayEventResponse();
      }
    }
    
  }

  public void eventMessageHover() {
    for (int i = 0; i < response_ypos.length; i++) {
      // For all the player choices check if player hover over choice
      if (rectHover(response_xpos, response_ypos[i]-25, 600, 25) && (event_parse_check[i] == true)) {
        // Draw a rectangle around the hovered choice to help show their selection
        fill(51, 51, 51);
        rect(response_xpos, response_ypos[i]-14, 600, 20);
        if (mousePressed) {
          // If the mouse is pressed then select that choice
          println("[DEBUG] User selected choice " + i);
          // Player choice is equal to i (the choice displayed)
          player_choice = i;
          // Set the responsesOpen state to true
          mainGame.eventResponsesOpen = true;
          // Play an audio effect on selection
          selection.rewind();
          selection.play();
        }
      }
    }
  }
  
  public String eventParse(String text, int parse_checker_position) {
    // This method returns the string "" if the message equals "Null"
    // Used when we don't need 3 player choices
    if (text.equals("Null")) {
      event_parse_check[parse_checker_position] = false;
      return "";
    } else {
      // If the string doesn't equal Null, then the original messsage is returned
      event_parse_check[parse_checker_position] = true;
      return (parse_checker_position+1) + ". " + text;
    }
  }
  
  // @@@ REF:3
  public int stringSearch(String main_string, String sub_string) {
    // Method to search for a specific string inside another string
    // Returns the no. of times the sub string is detected in the main string
    int lastIndex = 0;
    int count = 0;
    while(lastIndex != -1) {
      // lastIndex equal to the index from the sub string to lastIndex
      lastIndex = main_string.indexOf(sub_string, lastIndex);
      if(lastIndex != -1) {
        // As lastIndex increments, so does the count
        count++;
        lastIndex ++;
      }
    }
    return count;
  }

  public void displayEventResponse() {
    if (event_stats_done == false) {
      println("[INFO] Displaying choice response to user");
      // eventStatsChecker is called, then we change the state to true
      // Meaning the ship health etc. is changed only once, and then the response message is displayed to the user
      eventStatsChecker();
      event_stats_done = true;
    }
    if (event_stats_done) {
      
      // Find the number of '.'s inside the response messages
      response_count = stringSearch(responses[player_choice], ".");
      // Splits the message into an array at points where there is a '.'
      split_responses = split(responses[player_choice], '.');
      
      // Draws the choice response
      eventMessage.text_string(eventMessage.x, eventMessage.y, split_responses[0], 12, eventMessage.c, CENTER, eventMessage.font2);
      if(response_count >= 1) {
        // If the response_count (no. of '.'s in the message) > 1 then it draws the second sentence
        eventMessage.text_string(eventMessage.x, eventMessage.y + 25, split_responses[1], 12, eventMessage.c, CENTER, eventMessage.font2);
      }
      
      // Draws the logs on the panel, e.g. showing the user how much health the ship lost/gained from their decision making
      eventStatsLogs(width/2, response_ypos[0], responses_ship_health[player_choice], mainGame.shipHealthCurrent, mainGame.shipHealth, "Ship:",CENTER);
      eventStatsLogs(width/2, response_ypos[1], responses_oxygen[player_choice], mainGame.shipOxygenCurrent, mainGame.shipOxygen, "Oxygen:", CENTER);
      eventStatsLogs(width/2, response_ypos[0]-40, responses_energy[player_choice], mainGame.shipEnergyCurrent, mainGame.shipEnergy, "Energy Cells:", CENTER);
      
      // If crew members are gained from the player choice, log it on the event panel
      if(crew_gained) {
        eventMessage.text_string(width/2, height/2 - 40, "You gained the crew member " + mainGame.crew_member_gained, mainGame.event_log_size + 2, mainGame.gain, CENTER, eventMessage.font2);
      }
      
      // If the ship is detected as not alive after the player choice, log it on the event panel
      if(mainShip.shipAlive == false) {
        eventMessage.text_string(width/2, height/2 - 40, "The ship hull breaks apart. Your mission is over.", mainGame.event_log_size + 2, mainGame.loss, CENTER, eventMessage.font2);
      }
      
      // Logging for crew members
      // Chooses the crew member from the random int we defined earlier
      switch(crew_stat_change) {
       case 0:
         // If int = 0, crew member 0 in the crew arraylist logs are displayed on the event panel
         // e.g. "{crew_member_name} : +50 / -50"
         eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(0), 0);
       case 1:
         eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(1), 1);
       case 2:
         eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(2), 2);
      }
      
      // Checks if all crew members are not alive
      int crew_death_counter = 0;
      for(Crew members : mainGame.crew) {
        if(members.alive == false) {
          crew_death_counter++;
        }
      }
      // Display a message if all crew are dead
      if(crew_death_counter == mainGame.crew.size()) {
        mainGame.all_crew_dead = true;
        eventMessage.text_string(width/2, height/2 - 150, "All crew are dead. Your mission is over.", mainGame.event_log_size + 2, mainGame.loss, CENTER, eventMessage.font2);
      }
      
      // Checks if the event response has been closed
      eventMessage.responsePanelClose();
    }
  }

  public void eventStatsChecker() {
    // Method which actually changes the ship and crew stats
    if (!(mainGame.shipHealthCurrent + responses_ship_health[player_choice] >= mainGame.shipHealth)) {
      // When current ship health + health gained/loss is less than the maximum ship health, the health is added/subtracted to/from the ship
      mainGame.shipHealthCurrent += responses_ship_health[player_choice];
      mainShip.shipCurrentSectionHP += responses_ship_health[player_choice] * 0.3f;
    }
    
    // Change the health of randomly decided crew member using the changeHealth method in the Crew class
    mainGame.crew.get(crew_stat_change).changeHealth(responses_crew_health[player_choice]);

    if (!(mainGame.shipOxygenCurrent + responses_oxygen[player_choice] >= mainGame.shipOxygen)) {
      // When current oxygen + oxygen gained/loss is less than the maximum ship oxygen, the oxygen is added/subtracted to/from the ship
      mainGame.shipOxygenCurrent += responses_oxygen[player_choice];
    }

    if (mainShip.shipMissiles > 0) {
      // Adds missiles to the ship if found
      mainShip.shipMissiles += responses_missiles[player_choice];
    }
    
    if (responses_crew_gain[player_choice] > 0) {
      // If a crew member is gained, crew_gained becomes true
      crew_gained = true;
      // Random crew name taken from an arraylist by index
      int rand_crew_name = (int)random(0, mainGame.crew_names.size());
      mainGame.crew_member_gained = mainGame.crew_names.get(rand_crew_name);
      // This name is then removed from the arraylist so you cannot have members found with a name already used
      mainGame.crew_names.remove(rand_crew_name);
    }
    
    if (responses_energy[player_choice] + mainGame.shipEnergyCurrent <= mainGame.shipEnergy) {
      // If the ship energy is below the maximum value, add the amount to the ship current energy variable
      mainGame.shipEnergyCurrent += responses_energy[player_choice];
    }
  }

  public void eventStatsLogs(float x, float y, int change, int health, int health_total, String log_message, int align) {
    // Method for drawing the logs for ship health, oxygen and energy
    if (change != 0) {
      // If the amount specified in the json array is > 0 then we do logging for the amount
      if ((change + health <= health_total) && (change > 0)) {
        // Executed when an amount is gained
        String log_output = log_message +  " +" + change;
        eventMessage.text_string(x, y, log_output, mainGame.event_log_size, mainGame.gain, align, eventMessage.font2);
      }
      if (change < 0) {
        // Executed when an amount is lost
        String log_output = log_message + " " + change;
        eventMessage.text_string(x, y, log_output, mainGame.event_log_size, mainGame.loss, align, eventMessage.font2);
      }
    }
  }
  
  public void eventStatsLogsCrew(int change, Crew player, int y_index) {
    // Display the logging for crew members
    int change_color = color(255);
    String log_output = "";
    // println("[DEBUG] " + player + " health: " + player.crewHealth);
    if (change != 0) {
      if ((change + player.crewCurrentHealth <= player.crewHealth) && (change > 0)) {
        // Display logging for gaining health
        log_output = player.crewName + ": +" + change;
        change_color = mainGame.gain;
      }
      if (change < 0) {
        // Display logging for losing health
        log_output = player.crewName + " : " + change;
        change_color = mainGame.loss;
        if(player.alive == false) {
          // If the crew member is detected as not alive, a message is displayed
          // println("[DEBUG] Player " + player.crewName + " is dead");
          log_output = player.crewName + " is dead.";
        }
      }
      // Draw the text
      eventMessage.text_string(width/2, crew_logs_ypos[y_index], log_output, mainGame.event_log_size, change_color, CENTER, eventMessage.font2);
    }
  }
}
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
  
  public void draw() {
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
  
  public void getStats() {
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
class GameSettings {
  
  // The main game class which makes use of many other classes within it
  // Also serves as a config file for game settings. It would be better to move the config to a config.ini file instead however.
  
  // UI objects
  UI health, oxygen, planetNameUI, ftl_travel, modal1, shipDisplayPanel, energy;
  UI travelMenu;
  UI travelInfo;
  UI eventPanel;
  UI planetHoverInfo;
  
  // Inventory
  // ! This class is unused/unfinished
  // Inventory inventory;
  
  // Ship configurations
  int shipHealth = 300;
  int shipHealthCurrent = 300;
  int shipOxygen = 100;
  int shipOxygenCurrent = 100;
  int shipEnergy = 300;
  int shipEnergyCurrent = 300;
  int shipEnergyCost = 100;
  int shipEnergyUsage = 60;

  // UI Colors
  int shipHealthColor = color(0, 255, 0);
  int shipOxygenColor = color(114, 188, 212);
  int shipEnergyColor = color(255, 255, 0);
  int planetNameUIColor = color(255);
  int goodHP = color(0, 255, 0);
  int lowHP = color(255, 71, 25);
  int verylowHP = color(255, 0, 0);
  int gain = color(0, 255, 0);
  int loss = color(255, 0, 0);
  
  // UI Font sizes
  int event_log_size = 14;
  int event_message_size = 13;
  int event_choice_size = 12;

  // Create a planet object
  Planet planet;
  int planet_counter;
  
  // Crew
  // Arraylist of Crew objects
  ArrayList<Crew> crew = new ArrayList<Crew>();
  // Name of crew member gained during events
  String crew_member_gained;
  
  // Stats for generating new crew members
  String[] crew_names_temp = {"Murph", "Ripley", "Watney", "Kirk", "Deckard", "Solo"};
  ArrayList<String> crew_names = new ArrayList<String>();
  String[] crew_roles = {"Pilot", "Biologist", "Soldier", "Engineer"};
  int last_crew_position_x = 520;
  
  // Travel
  Travel travel;
  
  // Create random event object and event checking storage;
  Event newEvent;
  ArrayList<Integer> events_to_check = new ArrayList<Integer>();
  boolean event_fill_done = false;
  
  // Create a game over object
  GameOver mainGameOver;
  
  // Game states initialized
  boolean travelPanelOpen = false;
  boolean inventoryOpen = false;
  boolean eventOpen = false;
  boolean eventPanelClosed = true;
  boolean planetHoverInfoOpen = false;
  boolean eventResponsesOpen = false;
  boolean create_planet = true;
  boolean game_over = false;
  boolean all_crew_dead = false;
  boolean audioMuted = false; 
  
  // Load Images
  PImage defaultPointer, handPointer, game_over_background;

  GameSettings() {
    
    // Create an initial planet
    createPlanet();
    
    // Add the default crew to the crew arraylist
    crew.add(new Crew("Walker", "Engineer", 400, 10, 400, 45));
    crew.add(new Crew("Andez", "Physicist", 460, 10, 460, 45));
    crew.add(new Crew("Cooper", "Pilot", 520, 10, 520, 45));
    for(String name : crew_names_temp) {
      crew_names.add(name);
    }
    
    // Load cursor images
    defaultPointer = loadImage("assets/ui/pointer_shadow.png");
    handPointer = loadImage("assets/ui/pointer_hand.png");
    
    // Create various UI elements
    shipDisplayPanel = new UI(0, 0, color(255));
    health = new UI(20, 20, shipHealthColor);
    oxygen = new UI(20, 55, shipOxygenColor);
    energy = new UI(950, 20, shipEnergyColor);
    travelMenu = new UI(0, 0, color(255));
    travelInfo = new UI(0, 0, color(255));
    eventPanel = new UI(0, 0, color(255));
    planetHoverInfo = new UI(1200, height/2 + 200, color(255));
    
    // inventory = new Inventory();
    
    // Create the trave object
    travel = new Travel();
  }
  
  public void createPlanet() {
    // Method used to create new planets when selected on the travel menu
    // Create a new planet, with random settings
    planet = new Planet(color(random(255), random(255), random(255)), (int)random(5, 25), random(100, 300), PI / 50, random(-0.2f, 0.2f), planet_counter);
    // Create the planet UI object
    planetNameUI = new UI(20, 90, planetNameUIColor);
    // Increment the planet counter to keep track of planets created
    planet_counter++;
  }
  
  public void startNewEvent() {
    // Creates a new event when called
    newEvent = new Event();
    // Changes the game state to eventOpen
    eventOpen = true;
  }

  public void createLevel() {
    // Method to create our initial level
    // Draws the planet
    planet.planetRender();
    // Draws the UI
    drawUI();
    // Draws the custom cursors
    drawCursor();
  }
  
  public void gameOver(int type) {
    // Creates a game over screen when called
    if(game_over == false) {
      ambient.pause();
      println("[INFO] Game over state started");
      mainGameOver = new GameOver(type);
      // Plays music during the game over screen, called here instead of GameOver class to stop it looping every frame
      game_over_music.loop();
      game_over = true;
    }
  }
  
  public void drawUI() {
    // Method which draws various UI elements on the main screen
    
    // Health
    health.draw("Health (" + shipHealthCurrent + " / " + shipHealth + ")");
    health.bar(20, 25, shipHealthCurrent, 10, shipHealthColor, shipHealth);
    
    // Energy 
    energy.draw("Energy (" + shipEnergyCurrent + " / " + shipEnergy + ")");
    energy.bar(950, 25, shipEnergyCurrent, 10, shipEnergyColor, shipEnergy);
    // Displays more information when hovered over
    if(rectHover(950, 10, 300, 30)) {
      energy.hoverPanel(950, 50, "- Travelling to a system uses " + shipEnergyCost + " cells", "- Deploy dropship to charge energy cells", "- Run out of energy and you will be stranded!", 360, 80);
      energy.hoverPanel(950, 140, "Engines: " + shipEnergyUsage + "% Energy", "Oxygen: 20% Energy", "Dropship: " + mainShip.dropship.energyUsage + "% Energy", 360, 80);
    }
    
    // Oxygen
    oxygen.draw("Oxygen (" + shipOxygenCurrent + " / " + shipOxygen + ")");
    oxygen.bar(20, 60, shipOxygenCurrent, 10, shipOxygenColor, shipOxygen);
    
    // Planet Name
    planetNameUI.draw("Planet: " + planet.planetNameRandom);
    
    // Ship sections
    if((mainShip.shipEngineOpen || mainShip.shipMainOpen || mainShip.shipArrayTopOpen || mainShip.shipArrayBottomOpen || mainShip.shipPilotOpen) && travelPanelOpen == false) {
     shipDisplayPanel.shipSectionDisplay();
    }
    
    drawTravelMenu();
    // drawInventory();
    drawEvent();
    drawPlanetHoverInfo();
    drawCrew();
  }
  
  public void drawCrew() {
    // Draws all crew members from the arraylist
    for(Crew members : crew) {
      members.draw_crew();
    }
  }
  
  public void drawCursor() {
    // Draw cursors depending on game location e.g. travel panel or default window
    if(travelPanelOpen || eventOpen) {
      cursor(handPointer, 0, 0);
    } else {
      cursor(defaultPointer, 0, 0);
    }
  }
  
  public void gamePause() {
    // If the game is paused, stop planet from rotating
    planet.planetRevolution = 0;
  }
  
  public void drawTravelMenu() {
    travel.drawTravelButton();
    if(travelPanelOpen) {
      // If travel panel is open draw the travel menu and negate the states of the ship sections
      shipStateChange();
      travel.draw();
    }
  }
  
  //void drawInventory() {
  //  if(inventoryOpen) {
  //    shipStateChange();
  //    inventory.loadDefault();
  //  }
  //}
  
  public void drawEvent() {
    if(eventOpen) {
      // If event is open draw the event and negate the states of the ship sections
      shipStateChange();
      // Display the event
      newEvent.displayEventMessage();
      eventPanelClosed = false;
    }
  }
  
  public void drawPlanetHoverInfo() {
    // Draw planet hover info if other menus are closed
    if(planetHoverInfoOpen && travelPanelOpen == false && eventOpen == false) {
      planetHoverInfo.planetHoverInfo();
    }
  }
  
  public void shipStateChange() {
    // Closes all ship sections when method is called
    mainShip.shipEngineOpen = false;
    mainShip.shipMainOpen = false;
    mainShip.shipArrayBottomOpen = false;
    mainShip.shipArrayTopOpen = false;
    mainShip.shipPilotOpen = false;
  }
}
//
//
// THIS CLASS IS UNFINISHED AND UNUSED
// THIS CLASS IS UNFINISHED AND UNUSED
// THIS CLASS IS UNFINISHED AND UNUSED
//
//

class Inventory {

 PImage inv, inv_item;
 PImage[] inventory_items;
 int n = 1;

 float inv_itemX;
 float inv_itemY;

 UI itemData;

 //Load JSON data
 JSONArray items;
 String[] itemNames = {};

 Inventory() {
   inv = loadImage("inventory_withpanelstext.png");
   inv_item = loadImage("inventory_item.png");
    
   inventory_items = new PImage[n];
   for(int i = 0; i < inventory_items.length; i++) {
     inventory_items[i] = loadImage("inventory_items/" + str(i) + ".png");
   }
    
   itemData = new UI(0, 0, color(255));
   inv_itemX = width/2 - 400;
   inv_itemY = height/2;
   items = loadJSONArray("items.json");
   loadJSON();
   // printArray(itemNames);
 }

 public void loadDefault() {
   image(inv, width/2 + 100, height/2);
   image(inv_item, inv_itemX, inv_itemY);
   drawItems();
 }
  
 public void drawItems() {
   for(int i = 0; i < inventory_items.length; i++) {
     image(inventory_items[i], width/2-123, height/2-214);
     if(rectHover(width/2-123, height/2-214, 100, 100)) {
       println("Item hover detected");
     }
   println("--------");
   }
 } 

 public void loadJSON() {
   for(int i = 0; i < items.size(); i++) {
     JSONObject item_json = items.getJSONObject(i);
     String itemName = item_json.getString("name");
     itemNames = append(itemNames, itemName);
     // println(itemNames.length);
   }
 }
  
 //String getJSON(String data) {
 //  String return_data = "";
 //  for(int i = 0; i < values.size(); i++) {
 //    JSONObject text = values.getJSONObject(i);
 //    return_data = text.getString(data);
 //  }
 //  return return_data;
 //}
}
class Planet {
  
  // Planet variables
  int planetColor;
  int planetDetail;
  float planetRadius;
  float planetRevolution;
  float planetTilt;
  
  // Variables that will be generated
  float planetTemperature;
  float planetCircumference;
  
  // Array of planet names
  String [] planetNames = {"Pohl 3", "Singhana", "Hopi", "Lazda", "Zelos", "Prima 2", "Xenu", "Epusid", "Hypersia", "Arda"};
  // Keeps track of current planet
  int planetCount;
  String planetNameRandom;
  
  // Planet species
  String [] planetSpecies = {"Vloux", "Lovlons", "Hobbits", "Strask", "Ryard", "NONE FOUND"};
  // Hostility of species
  String [] planetHostility = {"DANGEROUS", "PASSIVE", "NEUTRAL", "PASSIVE", "DANGEROUS", "N/A"};
  String planetSpeciesRandom;
  String planetSpeciesHostility;
  
  // Hashmap for pairing species with hostility
  HashMap<String,String> planetLife = new HashMap<String,String>();
  
  Planet(int _planetColor, int _planetDetail, float _planetRadius, float _planetRevolution, float _planetTilt, int _planetCount) {
    planetColor = _planetColor;
    planetDetail = _planetDetail;
    planetRadius = _planetRadius;
    planetRevolution = _planetRevolution;
    planetTilt = _planetTilt;
    planetCount = _planetCount;
    
    // Puts the species and hostility values into the hashmap
    for(int i = 0; i < planetSpecies.length; i++) {
      planetLife.put(planetSpecies[i], planetHostility[i]);
    }
 
    // planetNameRandom = planetNames[(int)(Math.random() * planetNames.length)];
    planetNameRandom = planetNames[planetCount];
    
    // Get a random species from the species array
    planetSpeciesRandom = planetSpecies[(int)(Math.random() * planetSpecies.length)];
    // Get this value from the hashmap
    planetSpeciesHostility = planetLife.get(planetSpeciesRandom);
    
    // Calculate the planet circumference
    planetCircumference = (PI * planetRadius * 2) * 35;

    // Array to store extracted planet colours
    float[] planetRGB = extractColors(planetColor); 

    // Cold
    if(planetRGB[0] < 100 && planetRGB[1] < 100 && planetRGB[2] < 100) {
      planetTemperature = (int)random(-40, 5);
    }
    // Very cold
    if(planetRGB[0] > 200 && planetRGB[1] > 200 && planetRGB[2] > 200) {
      planetTemperature = (int)random(-40, -5);
    }
    // Very hot
    if(planetRGB[0] > 150 && planetRGB[1] < 100 && planetRGB[2] < 100) {
      planetTemperature = (int)random(30, 40);
    } else {
      planetTemperature = (int)random(5, 15);
    }
    
    // Formula to 'try' and create an accurate planet temperature
    planetTemperature *= 0.00005f * sq(planetRadius);
  }
  
  public void planetRender() {
    // Method which actually draws the 3D planet sphere
    pushMatrix();
    // Moves it to the correct position
    translate(1200, height/2, -500);
    fill(planetColor);
    stroke(255);
    // Rotate the planet X/Y
    rotateY(radians(frameCount * planetRevolution));
    rotateX(planetTilt);
    sphereDetail(planetDetail);
    // Creates a sphere with random size value
    sphere(planetRadius);
    // lights();
    popMatrix();
    planetInfo();
  }
  
  // @@@ REF:4
  public float[] extractColors(int c) {
    // Extracts the exact values of red, green and blue from the randomly generated planet colour
    // (c >> 16) & 0xFF esentially takes a bitmask and gets only the bits specified (16 in this case), representing the color (red in this case)
    float r = (c >> 16) & 0xFF;
    float g = (c >> 8) & 0xFF;
    // This could be (c >> 0) & 0xFF as well
    float b = c & 0xFF;
    // Each value is placed into an array which is then returned
    float[] color_values = {r, g, b}; 
    return color_values;
  }
  
  public void planetInfo() {
    // Draw planet hover state to true if hovered over planet 
    if(ellipseHover(1025, height/2, planetRadius)) {
      mainGame.planetHoverInfoOpen = true;
    } else {
      mainGame.planetHoverInfoOpen = false;
    }
  }
}
class Ship {

  // Ship coordinates
  float shipX, shipY;
  
  // Different images for ship selection
  PImage shipImageDefault, shipImageEngine, shipImageMain, shipImagePilot, shipImageArrayTop, shipImageArrayBottom;
  PImage ship_selection;
  
  // Ship section states
  boolean shipEngineOpen = false;
  boolean shipMainOpen = false;
  boolean shipPilotOpen = false;
  boolean shipArrayTopOpen = false;
  boolean shipArrayBottomOpen = false;
  
  boolean shipAlive = true;
  
  // Ship stats
  String[] shipSections = {"Engines", "Crew Quarters", "Bridge", "Solar Array 1", "Solar Array 2"};
  float shipEngineHP = 100;
  float shipMainHP = 100;
  float shipPilotHP = 100;
  float shipArrayTopHP = 100;
  float shipArrayBottomHP = 100;
  
  // Realtime stats
  float shipEngineCurrentHP = 100;
  float shipMainCurrentHP = 100;
  float shipPilotCurrentHP = 100;
  float shipArrayTopCurrentHP = 100;
  float shipArrayBottomCurrentHP = 100;
  String shipCurrentSection;
  float shipCurrentSectionHP;
  
  // Starting missile count
  int shipMissiles = 5;
  
  // shipSection UI object
  UI shipSection;
  
  // weapon object (missiles)
  Weapon weapon1;
  
  // dropship object (for charging energy cells)
  Dropship dropship;

  Ship(float _shipX, float _shipY) {

    shipX = _shipX;
    shipY = _shipY;

    // Load the various ship section images
    shipImageDefault = loadImage("assets/ship/mainShip_h.png");
    shipImageEngine = loadImage("assets/ship/mainShip_h_engine.png");
    shipImageMain = loadImage("assets/ship/mainShip_h_main.png");
    shipImagePilot = loadImage("assets/ship/mainShip_h_pilot.png");
    shipImageArrayTop = loadImage("assets/ship/mainShip_h_arrayTop.png");
    shipImageArrayBottom = loadImage("assets/ship/mainShip_h_arrayBottom.png");
    
    // Assign ship_selection to the default ship image
    ship_selection = shipImageDefault;
    
    shipSection = new UI(width/2-700, height/2+225, color(255));
    
    // Create the missile and dropship objects
    weapon1 = new Weapon(800, 25, "missile");
    dropship = new Dropship();
  }

  public void draw() {
    imageMode(CENTER);
    image(ship_selection, shipX, shipY);
    
    // Check for mouse press when events are not open
    if(mousePressed && (mainGame.eventOpen == false || mainGame.eventPanelClosed == true)) {
      // Run through these methods to draw sections
      shipEngineSelection();
      shipMainSelection();
      shipPilotSelection();
      shipArraySelection();
    } else {
      // Otherwise, draw the default ship image for no change/selection
      ship_selection = shipImageDefault;
    }
    checkStatus();
    weapon1.draw();
    dropship.draw();
  }
  
  public void checkStatus() {
    // Checks the ship status/if it's still alive
    if(mainGame.shipHealthCurrent <= 0) {
      shipAlive = false;
    }
  }
  
  public void shipSectionDraw() {
    // Text/stats to be drawn when a ship section panel is displayed
    shipSection.text_string(shipSection.x, shipSection.y, "Section: " + shipCurrentSection, 26, shipSection.c, LEFT, shipSection.font);
    shipSection.text_string(shipSection.x, shipSection.y + 25, "Condition: ", 21, color(255), LEFT, shipSection.font);
    shipSection.text_string(shipSection.x + 110, shipSection.y + 25, "" + shipCurrentSectionHP, 21, colorHealthChanger(shipCurrentSectionHP), LEFT, shipSection.font);
  }
  
  // Returns a colour based on the input health amount e.g. low health will return a red colour
  public int colorHealthChanger(float hp) {
    if(hp > 50) {
      return color(0, 255, 0);
    }
    if(hp <= 50) {
      return color(255, 71, 25);
    }
    if(hp <= 25) {
      return color(255, 0, 0);
    }
    else {
      return color(255); 
    }
  }
  
  public void shipEngineSelection() {
    // Checks if the engines are selected and draws the corresponding image
    if(rectHover(width/2-600, height/2-70, 250, 140)) {
      ship_selection = shipImageEngine;
      // Changes the open state to true
      shipEngineOpen = true;
      // Gets the stats for the shipSection
      shipCurrentSection = shipSections[0];
      // e.g. the health of the selected ship section
      shipCurrentSectionHP = shipEngineCurrentHP;
    } else {
      shipEngineOpen = false;
    }
  }
  public void shipMainSelection() {
    // Checks if the main area is selected and draws the corresponding image
    if(rectHover(width/2-350, height/2-50, 170, 100)) {
      ship_selection = shipImageMain;
      shipMainOpen = true;
      shipCurrentSection = shipSections[1];
      shipCurrentSectionHP = shipMainCurrentHP;
    } else {
      shipMainOpen = false;
    }
  }
  public void shipPilotSelection() {
    // Checks if the command module is selected and draws the corresponding image
    if(rectHover(width/2-180, height/2-50, 170, 100)) {
      ship_selection = shipImagePilot;
      shipPilotOpen = true;
      shipCurrentSection = shipSections[2];
      shipCurrentSectionHP = shipPilotCurrentHP;
    } else {
      shipPilotOpen = false;
    }
  }
  public void shipArraySelection() {
    // Checks if the arrays are selected and draws the corresponding image
    if(rectHover(width/2-350, height/2-170, 170, 120)) {
      ship_selection = shipImageArrayTop;
      shipArrayTopOpen = true;
      shipCurrentSection = shipSections[3];
      shipCurrentSectionHP = shipArrayTopCurrentHP;
    } else if(rectHover(width/2-350, height/2+50, 170, 120)) {
      ship_selection = shipImageArrayBottom;
      shipArrayBottomOpen = true;
      shipCurrentSection = shipSections[4];
      shipCurrentSectionHP = shipArrayBottomCurrentHP;
    } else {
      shipArrayTopOpen = false;
      shipArrayBottomOpen = false;
    }
  }
}
class Travel {
  
  String currentPlanet;
  float currentPlanetX, currentPlanetY;
  int systemSize = 10;
  int systemStartX = width/2;
  int systemStartY = height/2;
  int[] travelID = {};
  
  // Defines the number of systems to be drawn on the travel menu
  int systemAmount = 10;
  
  int systemHover;
  PImage travel_window;
  
  // travelPanel UI object is declared
  UI travelPanel;
  
  // Hashmap to store the position of the systems on the travel menu
  HashMap<Integer, Integer> system_position = new HashMap<Integer, Integer>();

  // Int dictionary to store co-ords of each system 
  IntDict systemcordsX = new IntDict();
  IntDict systemcordsY = new IntDict();
  
  Travel() {
    travelPanel = new UI(width/2, height/2, color(255));
    travel_window = loadImage("assets/ui/travel.png");
    systemHover = color(0, 255, 0);
    
    // Loop to fill the Hashmap and the dictionary
    for(int i = 0; i < systemAmount; i++) {
      // Random x, y co-ords are made within the given range
      int x = (int)random(300, 1150);
      int y = (int)random(250, 650);
      // These are then added to hashmap
      system_position.put(x, y);
      // And the X/Y dictionary, with the corresponding index value
      systemcordsX.set(str(i), x);
      systemcordsY.set(str(i), y);
    }
    
  }
  
  public void draw() {
    // Draws the main travel menu
    mainGame.travelPanelOpen = true;
    image(travel_window, width/2, height/2);
    // currentPlanet = mainGame.planet.planetNameRandom;
    draw_systems();
  }
  
  public void draw_systems() {
    // The method to draw the systems on the travel menu
    
    // The current planet X/Y co-ords are taken from the dictionaries by index value (the planet counter from the planet class)
    currentPlanetX = systemcordsX.get(str(mainGame.planet.planetCount));
    currentPlanetY = systemcordsY.get(str(mainGame.planet.planetCount));
    
    // Text to tell the player which planet they must travel to next
    travelPanel.text_string(width/2-450, height/2+235, "Next planet to explore: " + mainGame.planet.planetNames[mainGame.planet.planetCount+1], 25, color(255), LEFT, travelPanel.font);
    
    // If the ship doesn't have the right amount of energy, play an audio effect and notify the player
    if(mainGame.shipEnergyCurrent < 75) {
      error.play();
      travelPanel.text_string(width/2-50, height/2+235, "Not enough energy. Charge cells first!", 27, color(255, 0, 0), LEFT, travelPanel.font);
    }
    
    // Draws a line to show the connection between the last visited planets on the map
    for(int i = 0; i < mainGame.planet.planetCount; i++) {
      line(systemcordsX.get(str(i)), systemcordsY.get(str(i)), systemcordsX.get(str(i+1)), systemcordsY.get(str(i+1)));
    }
    
    for(int i = 0; i < systemAmount; i++) {
      
      // For loop allows us to get the key and value data from the dictionary
      // @@@ REF:5
      for(Map.Entry system : system_position.entrySet()) {
        
        // Key and values used to draw the 3D systems on the map
        // The key being the x coord, and the value being the y coord 
        draw_system_3d((int)system.getKey(), (int)system.getValue(), systemSize, systemHover);
        
        // If the player hovers over a system/planet (ellipseHover takes the key/value pairs) a '<' is drawn so the player can see their decision clearly
        if(ellipseHover((int)system.getKey(), (int)system.getValue(), systemSize*2) && (int)system.getKey() != systemStartX && (int)system.getValue() != systemStartY) { 
          travelPanel.text_string((int)system.getKey() + 20, (int)system.getValue() + 5, "<", 22, color(255, 255, 0), RIGHT, travelPanel.font);
        }
      }
      
      // This UI method is used to draw the names of the planets next to the correct planet
      travelPanel.text_string(systemcordsX.get(str(i)) - 12, systemcordsY.get(str(i)), mainGame.planet.planetNames[i], 20, travelPanel.c, RIGHT, travelPanel.font);

      // Make sure we are not at the end of the planet choices
      if(mainGame.planet.planetCount != mainGame.planet.planetNames.length) {
        // Check that a planet is selected and that it isn't the current planet the player is at
        if(mousePressed && ellipseHover(systemcordsX.get(str(mainGame.planet.planetCount+1)), systemcordsY.get(str(mainGame.planet.planetCount+1)), systemSize*2) && (systemcordsX.get(str(i)) != currentPlanetX && systemcordsY.get(str(i)) != currentPlanetY)) {
          // Do nothing if the player doesn't have enough energy (text printed to console for debugging)  
          if(mainGame.shipEnergyCurrent < mainGame.shipEnergyCost) {
            println("[INFO] Energy critical amount, travel disabled");
          } else {
            // This is executed if the player selects the correct planet and has enough energy
            println("[INFO] Success: newPlanet selected!");
            // Minus the energy cost from the current ship energy
            mainGame.shipEnergyCurrent -= mainGame.shipEnergyCost;
            // Create a new planet
            mainGame.createPlanet();
            mainGame.eventOpen = false;
            mainGame.eventResponsesOpen = false;
            // Start a new event
            mainGame.startNewEvent();
            // Close the travel panel
            mainGame.travelPanelOpen = false;
            // Stop the dropship if it's still deployed
            mainShip.dropship.deployed = false;
            mainShip.dropship.charging = false;
            // Rewind the audio effect so it can be used again in the future if the player doesn't have enough energy
            error.rewind();
          }
        }
      }
    }
    if(mousePressed && ellipseHover(currentPlanetX, currentPlanetY, systemSize*2)) {
      // If the player selects the current planet (planet which they are already at) play an error audio effect
      error.rewind();
      error.play();
      println("[ERROR] Error: currentPlanet selected");  
    }
  }
  
  public void draw_system_3d(int x, int y, int size, int systemHover) {
    // Similar to draw planet method, the difference being no fill and a lower detail
    pushMatrix();
    translate(x, y, 0);
    fill(0);
    stroke(systemHover);
    rotateY(radians(frameCount * PI/2));
    sphereDetail(5);
    sphere(size);
    popMatrix();
  }
  
  public void drawTravelButton() {
    // UNUSED BUTTON!
    // Draws the travel button the main screen
    //int x = width - 110;
    //int y = 10;
    //if(rectHover(x, y, 100, 25)) {
    //  fill(31, 31, 31);
    //  if(mousePressed && mainGame.travelPanelOpen == false) {
    //    mainGame.travelPanelOpen = true;
    //  }
    //} else {
    //  fill(51, 51, 51);
    //}
    //rect(x, y, 100, 25);
    travelPanel.text_string((width-20), 28, "Q - TRAVEL", 20, color(255), RIGHT, travelPanel.font);
    travelPanel.text_string((width-20), 48, "W - DROPSHIP", 20, color(255), RIGHT, travelPanel.font);
  }
}
class UI {

  // Positioning and color
  float x, y;
  float shipSectionX, shipSectionY;
  int c;
  int hostility;
  
  // Game images
  // PImage inv;
  PImage shipSectionPanel;
  PImage travelPanel;
  PImage eventPanel;
  PImage planetHoverPanel;

  // Define the fonts used in program
  PFont font, font2;

  UI(float _x, float _y, int _c) {
    
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

  public void draw(String title) {
    // Method to draw basic text from given string
    textFont(font, 140);
    fill(c);
    textAlign(0);
    textSize(19);
    text(title, x, y);
  }
  
  public void hoverPanel(float hoverX, float hoverY, String message, String message2, String message3, float hoverWidth, float hoverHeight) {
    // Method to draw a panel when a specified item is hovered over, makes use of the text_string method
    fill(31, 31, 31);
    stroke(255);
    rect(hoverX, hoverY, hoverWidth, hoverHeight);
    text_string(hoverX+5, hoverY+20, message, 10, color(255), LEFT, font2);
    text_string(hoverX+5, hoverY+45, message2, 10, color(255), LEFT, font2);
    text_string(hoverX+5, hoverY+70, message3, 10, color(255), LEFT, font2);
  }

  public void bar(float barX, float barY, float barWidth, float barHeight, int barColor, float barWidthTotal) {
    // Draws a bar from given parameters (used for ship health and energy etc.)
    rectMode(CORNER);
    stroke(255);
    fill(0);
    rect(barX, barY, barWidthTotal, barHeight);
    stroke(barColor);
    fill(barColor);
    rect(barX, barY, barWidth, barHeight);
  }

  public void text_string(float x, float y, String string, int font_size, int c, int align, PFont text_font) {
    // The most commonly used method from this class
    // Draws text but has many parameters allowing for greater options, e.g. font, alignment
    textFont(text_font, 140);
    fill(c);
    textAlign(align);
    textSize(font_size);
    text(string, x, y);
  }

  public void drawEventPanel() {
    // Draws the event panel when called in the Event class
    image(eventPanel, width/2, height/2);
  }

  public void responsePanelClose() {
    
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

  public void shipSectionDisplay() {
    // Draws the ship section panel image and calls the corresponding method
    image(shipSectionPanel, shipSectionX, shipSectionY);
    mainShip.shipSectionDraw();
  }

  public void planetHoverInfo() {
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
    if(mainGame.planet.planetTilt < 0) {
      mainGame.planet.planetTilt *= -1;
    }
    text_string(textXside, y-40, mainGame.planet.planetTilt + " RAD", textSize, c, RIGHT, font);
    text_string(textX, y-20, "Surface Temp: ", textSize, c, LEFT, font);
    text_string(textXside, y-20, mainGame.planet.planetTemperature + " DEG", textSize, c, RIGHT, font);
  }
}
class Weapon {
  
  // Weapon variables defined
  float weaponX, weaponY;
  PImage weaponImg;
  
  // weaponDisplay UI object created
  UI weaponDisplay;
  
  String weaponType;
  
  Weapon(float _weaponX, float _weaponY, String image) {
    
    weaponX = _weaponX;
    weaponY = _weaponY;
    
    // This isn't really necessary at the moment since there is only 1 weapon type in the game
    if(image.equals("missile")) {
      weaponImg = loadImage("assets/ship/missile.png");
      weaponType = "Proton Missile";
    }
    weaponDisplay = new UI(weaponX, weaponY, color(255));
  }
  
  public void draw() {
    // Draws the weapon on screen and the count
    image(weaponImg, weaponX, weaponY);
    weaponDisplay.text_string(weaponDisplay.x - (weaponImg.width), weaponDisplay.y + 5, "x" + mainShip.shipMissiles, 24, weaponDisplay.c, LEFT, weaponDisplay.font);
    checkStatus();
  }
  
  public void checkStatus() {
    // Displays more information in a hover menu
    if(rectHover(weaponX - (weaponImg.width/2), weaponY - (weaponImg.height/2), weaponImg.width, weaponImg.height)) {
      weaponDisplay.hoverPanel(weaponX, weaponY+25, " " + weaponType, " Amount: " + mainShip.shipMissiles, "", 150, 60);
    }
  }
  
}
  public void settings() {  size(1440, 900, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SpaceShip_Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
