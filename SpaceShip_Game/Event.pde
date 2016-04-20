class Event {

  JSONObject json, event;
  JSONArray events, choices, stats_array;
  float events_length;

  int event_id;
  int player_choice;
  String event_message;
  boolean event_stats_done = false;
  String ship_health_output;

  String[] choice_text;
  String[] stats_to_get = {"message", "ship_health", "crew_health", "oxygen"};

  JSONObject[] response_objects;
  JSONArray[] response_object_array;
  JSONObject[] object_responses;

  String[] responses;
  int[] responses_ship_health;
  int[] responses_crew_health;
  int[] responses_oxygen;

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
    event_parse_check = new boolean[3];
    
    // Load the main JSON file
    json = loadJSONObject("events/events.json");

    // Load the main events structure
    events = json.getJSONArray("events");

    // Get a random event
    events_length = events.size();
    event = events.getJSONObject((int)random(events_length));
    // println("[DEBUG] New event : " + event);

    // Get the main event message and id
    event_id = event.getInt("id");
    event_message = event.getString("message");
    println("[DEBUG] New event message: " + event_message);

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
    }

    eventMessage = new UI(width/2, height/2-100, event_message, color(255));
    timer = second();
    crew_stat_change = (int)random(0, 3);
  }

  void displayEventMessage() {
    if(second() > timer && event_message_open == false) {
      event_message_open = true;
    }
    if(event_message_open) {
      // println("[DEBUG] Alert: " + second() + " > " + timer);
      eventMessage.drawEventPanel();
      
      if (mainGame.eventResponsesOpen == false) {
        eventMessage.text_string(eventMessage.x, eventMessage.y, eventMessage.title, mainGame.event_message_size, eventMessage.c, CENTER, eventMessage.font2);
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
      return text;
    }
  }

  void displayEventResponse() {
    if (event_stats_done == false) {
      println("[INFO] Displaying choice response to user");
      eventStatsChecker();
      event_stats_done = true;
    }
    if (event_stats_done) {
      eventMessage.text_string(eventMessage.x, eventMessage.y, responses[player_choice], 12, eventMessage.c, CENTER, eventMessage.font2);
      eventStatsLogs(responses_ship_health[player_choice], mainGame.shipHealthCurrent, mainGame.shipHealth, "Ship:", 0);
      eventStatsLogs(responses_oxygen[player_choice], mainGame.shipOxygenCurrent, mainGame.shipOxygen, "Oxygen:", 1);
      
      // Logging for crew members
      switch(crew_stat_change) {
        case 0:
          eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew1, 0);
        case 1:
        eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew2, 1);
        case 2:
        eventStatsLogsCrew(responses_crew_health[player_choice], mainGame.crew3, 2);
      }
      eventMessage.responsePanelClose();
    }
  }

  void eventStatsChecker() {
    if (!(mainGame.shipHealthCurrent + responses_ship_health[player_choice] >= mainGame.shipHealth)) {
      mainGame.shipHealthCurrent += responses_ship_health[player_choice];
      mainShip.shipCurrentSectionHP += responses_ship_health[player_choice] * 0.3;
    }

    switch(crew_stat_change) {
    case 0: 
      mainGame.crew1.changeHealth(responses_crew_health[player_choice]);
    case 1: 
      mainGame.crew2.changeHealth(responses_crew_health[player_choice]);
    case 2: 
      mainGame.crew3.changeHealth(responses_crew_health[player_choice]);
    }

    if (!(mainGame.shipOxygenCurrent + responses_oxygen[player_choice] >= mainGame.shipOxygen)) {
      mainGame.shipOxygenCurrent += responses_oxygen[player_choice];
    }
  }

  void eventStatsLogs(int change, int health, int health_total, String log_message, int y_index) {
    if (change != 0) {
      if ((change + health <= health_total) && (change > 0)) {
        String log_output = log_message +  " +" + change;
        eventMessage.text_string(width/2, response_ypos[y_index], log_output, mainGame.event_log_size, mainGame.gain, CENTER, eventMessage.font2);
      }
      if (change < 0) {
        String log_output = log_message + " " + change;
        eventMessage.text_string(width/2, response_ypos[y_index], log_output, mainGame.event_log_size, mainGame.loss, CENTER, eventMessage.font2);
      }
    }
  }
  
  void eventStatsLogsCrew(int change, Crew player, int y_index) {
    color change_color = color(255);
    String log_output = "";
    if (change != 0) {
      if ((change + player.crewCurrentHealth <= player.crewHealth) && (change > 0)) {
        log_output = player.crewName + ": +" + change;
        change_color = mainGame.gain;
      }
      if (change < 0) {
        log_output = player.crewName + " : " + change;
        change_color = mainGame.loss;
      }
      eventMessage.text_string(width/2, crew_logs_ypos[y_index], log_output, mainGame.event_log_size, change_color, CENTER, eventMessage.font2);
    }
  }
}