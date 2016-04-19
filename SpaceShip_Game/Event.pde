class Event {

  JSONObject json, event;
  JSONArray events, choices, stats_array;
  float events_length;
  
  int event_id;
  int player_choice;
  String event_message;
  boolean event_stats_done = false;
  String ship_health_output;
  
  String[] choice_text = new String[3];
  String[] stats_to_get = {"message", "ship_health", "crew_health", "oxygen"};
  
  JSONObject[] response_objects = new JSONObject[3];
  JSONArray[] response_object_array = new JSONArray[3];
  JSONObject[] object_responses = new JSONObject[3];  

  String[] responses = new String[3];
  int[] responses_ship_health = new int[3];
  int[] responses_crew_health = new int[3];
  int[] responses_oxygen = new int[3];
  
  // Create UI objects
  UI eventMessage;
  
  // UI positioning
  float response_xpos = width/2 - 300;
  float[] response_ypos = {height/2+30, height/2+70, height/2+110};
  
  Event() {
    // Load the main JSON file
    json = loadJSONObject("events/events.json");
    
    // Load the main events structure
    events = json.getJSONArray("events");

    // Get a random event
    events_length = events.size();
    event = events.getJSONObject((int)random(events_length));
    
    // Get the main event message and id
    event_id = event.getInt("id");
    event_message = event.getString("message");
    
    // Get an array of responses for an event
    choices = event.getJSONArray("responses");
    stats_array = event.getJSONArray("stats");
    
    // Load the response data into an array
    for(int i = 0; i < choices.size(); i++) {
      choice_text[i] = choices.getJSONObject(i).getString("response");
    }
  
    for(int i = 0; i < stats_array.size(); i++) {
      response_objects[i] = stats_array.getJSONObject(i);
      response_object_array[i] = response_objects[i].getJSONArray("response");
      
      responses[i] = response_object_array[i].getJSONObject(0).getString(stats_to_get[0]);
      responses_ship_health[i] = response_object_array[i].getJSONObject(1).getInt(stats_to_get[1]);
      responses_crew_health[i] = response_object_array[i].getJSONObject(2).getInt(stats_to_get[2]);
      responses_oxygen[i] = response_object_array[i].getJSONObject(3).getInt(stats_to_get[3]);
    }
    
    eventMessage = new UI(width/2, height/2-100, event_message, color(255));
  }
  
  void displayEventMessage() {
    eventMessage.drawEventPanel();
    if(mainGame.eventResponsesOpen == false) {
      eventMessage.text_string(eventMessage.x, eventMessage.y, eventMessage.title, 20, eventMessage.c, CENTER);
      eventMessageHover();
      for(int i = 0; i < 3; i++) {
        eventMessage.text_string(response_xpos, response_ypos[i], eventParse(choice_text[i]), 18, eventMessage.c, LEFT);
      }
    }
    if(mainGame.eventResponsesOpen) {
      displayEventResponse();
    }
  }
  
  void eventMessageHover() {
    for(int i = 0; i < response_ypos.length; i++) {
      if(rectHover(response_xpos, response_ypos[i]-25, 600, 25)) {
        fill(51, 51, 51);
        rect(response_xpos, response_ypos[i]-14, 600, 20);
        if(mousePressed) {
          player_choice = i;
          mainGame.eventResponsesOpen = true;
        }
      }
    }
  }
  
  void displayEventResponse() {
    if(event_stats_done == false) {
      eventStatsChecker();
      event_stats_done = true;
    }
    if(event_stats_done) {
      eventMessage.text_string(eventMessage.x, eventMessage.y, responses[player_choice], 20, eventMessage.c, CENTER);
      eventStatsLogs();
    }
  }

  void eventStatsChecker() {
    if(!(mainGame.shipHealthCurrent + responses_ship_health[player_choice] >= mainGame.shipHealth)) {
      mainGame.shipHealthCurrent += responses_ship_health[player_choice];
    }
    
    int crew_stat_change = (int)random(0, 3);
    switch(crew_stat_change) {
      case 0: mainGame.crew1.changeHealth(responses_crew_health[player_choice]);
      case 1: mainGame.crew2.changeHealth(responses_crew_health[player_choice]);
      case 2: mainGame.crew3.changeHealth(responses_crew_health[player_choice]);
    }
    
    if(!(mainGame.shipOxygenCurrent + responses_oxygen[player_choice] >= mainGame.shipOxygen)) {
      mainGame.shipOxygenCurrent += responses_oxygen[player_choice];
    }
  }
  
  void eventStatsLogs() {
    eventStatsLogsShipHealth();
    eventStatsLogsShipOxygen();
  }
  
  void eventStatsLogsShipHealth() {
    if(responses_ship_health[player_choice] != 0) {
      //if(!(responses_ship_health[player_choice] + mainGame.shipHealthCurrent >= mainGame.shipHealth) && responses_ship_health[player_choice] < 0) {
      //  ship_health_output = "Ship Health: +" + responses_ship_health[player_choice];
      //  eventMessage.text_string(width/2, response_ypos[0], ship_health_output, mainGame.event_log_size, mainGame.gain, CENTER);        
      //}
      //if(responses_ship_health[player_choice] + mainGame.shipHealthCurrent < mainGame.shipHealth) {
      //  ship_health_output = "Ship Health: " + responses_ship_health[player_choice];
      //  eventMessage.text_string(width/2, response_ypos[0], ship_health_output, mainGame.event_log_size, mainGame.loss, CENTER);
      //}
      if(responses_ship_health[player_choice] + mainGame.shipHealthCurrent <= mainGame.shipHealth && responses_ship_health[player_choice] > 0) {
        ship_health_output = "Ship Health: +" + responses_ship_health[player_choice];
        eventMessage.text_string(width/2, response_ypos[0], ship_health_output, mainGame.event_log_size, mainGame.gain, CENTER);  
      }
      if(responses_ship_health[player_choice] < 0) {
        ship_health_output = "Ship Health: " + responses_ship_health[player_choice];
        eventMessage.text_string(width/2, response_ypos[0], ship_health_output, mainGame.event_log_size, mainGame.loss, CENTER);        
      }
    }    
  }
  
  void eventStatsLogsShipOxygen() {
    
  }
  
  String eventParse(String text) {
    if(text.equals("Null")) {
      return "";
    } else {
      return text;
    }
  }
  
}

//class Event {
  
// int time = minute();
// Table random_events;
// Table random_event_responses;
  
// //Row handlers
// int row_total, response_row_total;
// int row_random;
// TableRow row, response_row;
  
// //Event variables
// String message, responses, event, row_id;
// String[] parsed_responses;
// float id;
  
// //Response variables
// String response_message;
// String[] parsed_response_messages;
// int response_id;
// String unparsed_text;
// String[] unparsed_text_info;
// float response_stats;
// boolean response_stats_found = false;
  
// //UI objects/positioning
// UI eventMainText;
// UI eventMainResponse_1, eventMainResponse_2, eventMainResponse_3;
// UI[] eventMainResponses = new UI[3];
// float response_xpos = width/2 - 300;
// float[] response_ypos = {height/2+30, height/2+70, height/2+110};
  
// Event() {
//   //Load CSV files
//   random_events = loadTable("events.csv", "header");
//   random_event_responses = loadTable("event_responses.csv", "header");
    
//   //Get the number of rows of each CSV file
//   row_total = random_events.getRowCount();
//   response_row_total = random_event_responses.getRowCount();
    
//   //Select a random row number from table
//   row_random = (int)random(row_total);
//   //Select rows from the random row number
//   row = random_events.getRow(row_random);
//   response_row = random_event_responses.getRow(row_random);
    
//   message = row.getString("event");
//   responses = row.getString("responses");
//   response_message = response_row.getString("responses");
//   row_id = response_row.getString("id");
    
//   parsed_responses = split(responses, "|");
//   parsed_response_messages = split(response_message, "|");
    
//   for(int i = 0; i < parsed_responses.length; i++) {
//     if(parsed_responses[i].equals("Null")) {
//       parsed_responses[i].replaceAll("Null", "");
//     }
//     if(parsed_response_messages[i].equals("Null")) {
//       parsed_response_messages[i].replaceAll("Null", "");
//     }
//   }
    
//   eventMainText = new UI(width/2, height/2-100, message, color(255));
//   for(int i = 0; i < eventMainResponses.length; i++) {
//     eventMainResponses[i] = new UI(width/2, height/2-100, parsed_response_messages[i], color(255));
//   }
// }
  
// void displayEventText() {
    
//   eventMainText.text_string(eventMainText.x, eventMainText.y, eventMainText.title, 25, eventMainText.c, CENTER);
    
//   for(int i = 0; i < 3; i++) {
//     String point_int;
//     String response;
//     if(parsed_responses[i].equals("Null")) {
//       point_int = "";
//       response = "";
//     } else {
//       point_int = (i+1) + ". ";
//       response = parsed_responses[i];
//     }
//     eventMainText.text_string(response_xpos, response_ypos[i], point_int + response, 22, eventMainText.c, LEFT);  
//   }
// }
  
// void displayResponseText(int choice) {
//   unparsed_text = eventMainResponses[choice].title;
//   findResponseStats();
    
//   String response;
//   if(response_stats_found) {
//     response = unparsed_text_info[0];
//   } else {
//     response = eventMainResponses[choice].title;
//   }
//   eventMainResponses[choice].text_string(eventMainText.x, eventMainText.y, response, 22, eventMainText.c, CENTER);
// }
  
// void findResponseStats() {
//   if((unparsed_text.contains("$")) && response_stats_found == false) {
//     response_stats_found = true;
//     if(response_stats_found) {
//       unparsed_text_info = split(unparsed_text, "$");
//       response_stats = Float.valueOf(unparsed_text_info[1]).floatValue();
//       //println(response_stats);
//       mainGame.shipHealthCurrent += response_stats;
//       mainGame.crew1.crewCurrentHealth += response_stats;
//       //mainShip.shipEngineCurrentHP -= 70;
//     }
//   }
// }
  
// void createEvent() {
//   mainGame.eventOpen = true;
//   //if(mainGame.eventOpen == false) {
//   // if(minute() > time) {
//   //   if(mainGame.eventPanelClosed && mainGame.inventoryOpen == false && mainGame.travelPanelOpen == false) {
//   //     println("Checking for event");
//   //     if(randomEvent()) {
//   //       mainGame.eventOpen = true;
//   //     }
//   //     else {
//   //       mainGame.eventOpen = false;
//   //     }
//   //   }
//   // }
//   //}
//   //time = minute();
// }
  
// boolean randomEvent() {
//   int rand = (int)random(255);
//   if(rand % 3 == 0) {
//     return true;
//   } else {
//     return false;
//   }
// }
 
//}