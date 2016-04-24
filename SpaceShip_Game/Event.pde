class Event {

  JSONObject json, event;
  JSONArray events, choices, stats_array;
  float events_length;

  int event_id;
  int player_choice;
  String event_message;
  String[] split_event_message;
  boolean event_stats_done = false;
  String ship_health_output;

  String[] choice_text;
  String[] stats_to_get = {"message", "ship_health", "crew_health", "oxygen", "missiles", "crew_gain", "energy"};

  JSONObject[] response_objects;
  JSONArray[] response_object_array;
  JSONObject[] object_responses;

  String[] responses;
  String[] split_responses;
  int[] responses_ship_health;
  int[] responses_crew_health;
  int[] responses_oxygen;
  int[] responses_missiles;
  int[] responses_crew_gain;
  int[] responses_energy;

  // Create UI objects
  UI eventMessage;

  // UI positioning
  float response_xpos = width/2 - 300;
  float[] response_ypos = {height/2+30, height/2+70, height/2+110};
  float[] crew_logs_ypos = {height/2+110, height/2+130, height/2+150};
  
  // Other
  float timer;
  boolean event_message_open = false;
  int crew_stat_change;
  boolean[] event_parse_check;
  boolean crew_gained = false;
  
  int event_to_get;
  
  // String searching
  int message_count = 0;
  int response_count = 0;

  Event() {
    // Create empty arrays/json objects
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

    // Load the main events structure
    events = json.getJSONArray("events");

    // Get a random event
    events_length = events.size();
    println("[DEBUG] " + events_length + " events found in data file");
    
    if(mainGame.event_fill_done == false) {
      for(int i = 0; i < events_length; i++) {
        mainGame.events_to_check.add(i);
        
      }
      mainGame.event_fill_done = true;
    }
    
    // event_to_get = (int)random(mainGame.events_to_check.get());
    int test = (int)random(mainGame.events_to_check.size());
    event_to_get = mainGame.events_to_check.get(test);
    
    println("[DEBUG] Event chosen: " + event_to_get + " from " + mainGame.events_to_check.size() + " possible events");

    // Get the main event message and id
    event = events.getJSONObject(event_to_get);
    event_id = event.getInt("id");

    split_event_message = new String[(int)events_length];    
    event_message = event.getString("message");
    println("[DEBUG] New event message: " + event_message);
    
    split_event_message = split(event_message, '.');
    message_count = stringSearch(event_message, ".");

    // Get an array of responses for an event
    choices = event.getJSONArray("responses");
    stats_array = event.getJSONArray("stats");
    
    // Load the response data into an array
    for (int i = 0; i < choices.size(); i++) {
      choice_text[i] = choices.getJSONObject(i).getString("response");
    }

    for (int i = 0; i < stats_array.size(); i++) {
      response_objects[i] = stats_array.getJSONObject(i);
      response_object_array[i] = response_objects[i].getJSONArray("response");

      responses[i] = response_object_array[i].getJSONObject(0).getString(stats_to_get[0]);
      responses_ship_health[i] = response_object_array[i].getJSONObject(1).getInt(stats_to_get[1]);
      responses_crew_health[i] = response_object_array[i].getJSONObject(2).getInt(stats_to_get[2]);
      responses_oxygen[i] = response_object_array[i].getJSONObject(3).getInt(stats_to_get[3]);
      responses_missiles[i] = response_object_array[i].getJSONObject(4).getInt(stats_to_get[4]);
      responses_crew_gain[i] = response_object_array[i].getJSONObject(5).getInt(stats_to_get[5]);
      responses_energy[i] = response_object_array[i].getJSONObject(6).getInt(stats_to_get[6]);
    }

    eventMessage = new UI(width/2, height/2-100, color(255));
    timer = second();
    crew_stat_change = (int)random(0, mainGame.crew.size());
    
    mainGame.events_to_check.remove(test);
  }

  void displayEventMessage() {
    if(second() > timer && event_message_open == false) {
      event_message_open = true;
      beep.rewind();
      beep.play();
    }
    if(event_message_open) {
      // println("[DEBUG] Alert: " + second() + " > " + timer);
      eventMessage.drawEventPanel();
      
      if (mainGame.eventResponsesOpen == false) {
        eventMessage.text_string(eventMessage.x, eventMessage.y, split_event_message[0], mainGame.event_message_size, eventMessage.c, CENTER, eventMessage.font2);
        if(message_count >= 1) {
          eventMessage.text_string(eventMessage.x, eventMessage.y + 25, split_event_message[1], mainGame.event_message_size, eventMessage.c, CENTER, eventMessage.font2);
        }
        eventMessageHover();
        for (int i = 0; i < 3; i++) {
          eventMessage.text_string(response_xpos, response_ypos[i], eventParse(choice_text[i], i), mainGame.event_choice_size, eventMessage.c, LEFT, eventMessage.font2);
        }
      }
      if (mainGame.eventResponsesOpen) {
        displayEventResponse();
      }
    }
    
  }

  void eventMessageHover() {
    for (int i = 0; i < response_ypos.length; i++) {
      if (rectHover(response_xpos, response_ypos[i]-25, 600, 25) && (event_parse_check[i] == true)) {
      fill(51, 51, 51);
      rect(response_xpos, response_ypos[i]-14, 600, 20);
      if (mousePressed && rectHover(response_xpos, response_ypos[i]-25, 600, 25)) {
          println("[DEBUG] User selected choice " + i);
          player_choice = i;
          mainGame.eventResponsesOpen = true;
          selection.rewind();
          selection.play();
        }
      }
    }
  }
  
  String eventParse(String text, int parse_checker_position) {
    if (text.equals("Null")) {
      event_parse_check[parse_checker_position] = false;
      return "";
    } else {
      event_parse_check[parse_checker_position] = true;
      return (parse_checker_position+1) + ". " + text;
    }
  }
  
  int stringSearch(String main_string, String sub_string) {
    int lastIndex = 0;
    int count = 0;
    while(lastIndex != -1) {
      lastIndex = main_string.indexOf(sub_string, lastIndex);
      if(lastIndex != -1) {
        count++;
        lastIndex ++;
      }
    }
    return count;
  }

  void displayEventResponse() {
    if (event_stats_done == false) {
      println("[INFO] Displaying choice response to user");
      eventStatsChecker();
      event_stats_done = true;
    }
    if (event_stats_done) {
      
      response_count = stringSearch(responses[player_choice], ".");
      split_responses = split(responses[player_choice], '.');
      
      // eventMessage.text_string(eventMessage.x, eventMessage.y, responses[player_choice], 12, eventMessage.c, CENTER, eventMessage.font2);
      eventMessage.text_string(eventMessage.x, eventMessage.y, split_responses[0], 12, eventMessage.c, CENTER, eventMessage.font2);
      if(response_count >= 1) {
        eventMessage.text_string(eventMessage.x, eventMessage.y + 25, split_responses[1], 12, eventMessage.c, CENTER, eventMessage.font2);
      }
      
      eventStatsLogs(width/2, response_ypos[0], responses_ship_health[player_choice], mainGame.shipHealthCurrent, mainGame.shipHealth, "Ship:",CENTER);
      eventStatsLogs(width/2, response_ypos[1], responses_oxygen[player_choice], mainGame.shipOxygenCurrent, mainGame.shipOxygen, "Oxygen:", CENTER);
      eventStatsLogs(width/2, response_ypos[0]-40, responses_energy[player_choice], mainGame.shipEnergyCurrent, mainGame.shipEnergy, "Energy Cells:", CENTER);
      
      if(crew_gained) {
        eventMessage.text_string(width/2, height/2 - 40, "You gained the crew member " + mainGame.crew_member_gained, mainGame.event_log_size + 2, mainGame.gain, CENTER, eventMessage.font2);
      }
      
      if(mainShip.shipAlive == false) {
        eventMessage.text_string(width/2, height/2 - 40, "The ship hull breaks apart. Your mission is over.", mainGame.event_log_size + 2, mainGame.loss, CENTER, eventMessage.font2);
      }
      
      // Logging for crew members
      switch(crew_stat_change) {
       case 0:
         eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(0), 0);
       case 1:
         eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(1), 1);
       case 2:
         eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(2), 2);
      }
      //eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(crew_stat_change), 0);
      //eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(crew_stat_change), 1);
      //eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew.get(crew_stat_change), 2);
      
      eventMessage.responsePanelClose();
    }
  }

  void eventStatsChecker() {
    // Method which actually changes the ship and crew stats
    if (!(mainGame.shipHealthCurrent + responses_ship_health[player_choice] >= mainGame.shipHealth)) {
      mainGame.shipHealthCurrent += responses_ship_health[player_choice];
      mainShip.shipCurrentSectionHP += responses_ship_health[player_choice] * 0.3;
    }

    mainGame.crew.get(crew_stat_change).changeHealth(responses_crew_health[player_choice]);

    if (!(mainGame.shipOxygenCurrent + responses_oxygen[player_choice] >= mainGame.shipOxygen)) {
      mainGame.shipOxygenCurrent += responses_oxygen[player_choice];
    }

    if (mainShip.shipMissiles > 0) {
      mainShip.shipMissiles += responses_missiles[player_choice];
    }
    
    if (responses_crew_gain[player_choice] > 0) {
      crew_gained = true;
      int rand_crew_name = (int)random(0, mainGame.crew_names.size());
      mainGame.crew_member_gained = mainGame.crew_names.get(rand_crew_name);
      mainGame.crew_names.remove(rand_crew_name);
    }
    
    if (responses_energy[player_choice] + mainGame.shipEnergyCurrent <= mainGame.shipEnergy) {
      mainGame.shipEnergyCurrent += responses_energy[player_choice];
    }
  }

  void eventStatsLogs(float x, float y, int change, int health, int health_total, String log_message, int align) {
    if (change != 0) {
      if ((change + health <= health_total) && (change > 0)) {
        String log_output = log_message +  " +" + change;
        eventMessage.text_string(x, y, log_output, mainGame.event_log_size, mainGame.gain, align, eventMessage.font2);
      }
      if (change < 0) {
        String log_output = log_message + " " + change;
        eventMessage.text_string(x, y, log_output, mainGame.event_log_size, mainGame.loss, align, eventMessage.font2);
      }
    }
  }
  
  void eventStatsLogsCrew(int change, Crew player, int y_index) {
    color change_color = color(255);
    String log_output = "";
    // println("[DEBUG] " + player + " health: " + player.crewHealth);
    if (change != 0) {
      if ((change + player.crewCurrentHealth <= player.crewHealth) && (change > 0)) {
        log_output = player.crewName + ": +" + change;
        change_color = mainGame.gain;
      }
      if (change < 0) {
        log_output = player.crewName + " : " + change;
        change_color = mainGame.loss;
        if(player.alive == false) {
          // println("[DEBUG] Player " + player.crewName + " is dead");
          log_output = player.crewName + " is dead.";
        }
      }
      eventMessage.text_string(width/2, crew_logs_ypos[y_index], log_output, mainGame.event_log_size, change_color, CENTER, eventMessage.font2);
    }
  }
}