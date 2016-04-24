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

  void displayEventMessage() {
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

  void eventMessageHover() {
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
  
  String eventParse(String text, int parse_checker_position) {
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
  int stringSearch(String main_string, String sub_string) {
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

  void displayEventResponse() {
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

  void eventStatsChecker() {
    // Method which actually changes the ship and crew stats
    if (!(mainGame.shipHealthCurrent + responses_ship_health[player_choice] >= mainGame.shipHealth)) {
      // When current ship health + health gained/loss is less than the maximum ship health, the health is added/subtracted to/from the ship
      mainGame.shipHealthCurrent += responses_ship_health[player_choice];
      mainShip.shipCurrentSectionHP += responses_ship_health[player_choice] * 0.3;
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

  void eventStatsLogs(float x, float y, int change, int health, int health_total, String log_message, int align) {
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
  
  void eventStatsLogsCrew(int change, Crew player, int y_index) {
    // Display the logging for crew members
    color change_color = color(255);
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