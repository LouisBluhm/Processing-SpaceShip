class Event {
  
  int time = minute();
  Table random_events;
  Table random_event_responses;
  
  //Row handlers
  int row_total, response_row_total;
  int row_random;
  TableRow row, response_row;
  
  //Event text
  String message, responses, event;
  String[] parsed_responses;
  float id;
  //Response text
  String response_message;
  String[] parsed_response_messages;
  int response_id;
  String unparsed_text;
  String[] unparsed_text_info;
  float response_stats;
  boolean response_stats_found = false;
  
  //UI positioning
  UI eventMainText;
  UI eventMainResponse_1, eventMainResponse_2, eventMainResponse_3;
  UI[] eventMainResponses = new UI[3];
  float response_xpos = width/2 - 300;
  float[] response_ypos = {height/2+30, height/2+70, height/2+110};
  
  Event() {
    //Load CSV files
    random_events = loadTable("events.csv", "header");
    random_event_responses = loadTable("event_responses.csv", "header");
    
    //Get the number of rows of each CSV file
    row_total = random_events.getRowCount();
    response_row_total = random_event_responses.getRowCount();
    
    //Select a random row number from table
    row_random = (int)random(row_total);
    //Select rows from the random row number
    row = random_events.getRow(row_random);
    response_row = random_event_responses.getRow(row_random);
    
    message = row.getString("event");
    responses = row.getString("responses");
    response_message = response_row.getString("responses");
    
    parsed_responses = split(responses, "|");
    parsed_response_messages = split(response_message, "|");
    
    for(int i = 0; i < parsed_responses.length; i++) {
      if(parsed_responses[i].equals("Null")) {
        parsed_responses[i].replaceAll("Null", "");
      }
      if(parsed_response_messages[i].equals("Null")) {
        parsed_response_messages[i].replaceAll("Null", "");
      }
    }
    
    eventMainText = new UI(width/2, height/2-100, message, color(255));
    for(int i = 0; i < eventMainResponses.length; i++) {
      eventMainResponses[i] = new UI(width/2, height/2-100, parsed_response_messages[i], color(255));
    }
  }
  
  void displayEventText() {
    
    eventMainText.text_string(eventMainText.x, eventMainText.y, eventMainText.title, 25, eventMainText.c, CENTER);
    
    for(int i = 0; i < 3; i++) {
      String point_int;
      String response;
      if(parsed_responses[i].equals("Null")) {
        point_int = "";
        response = "";
      } else {
        point_int = (i+1) + ". ";
        response = parsed_responses[i];
      }
      eventMainText.text_string(response_xpos, response_ypos[i], point_int + response, 22, eventMainText.c, LEFT);  
    }
  }
  
  void displayResponseText(int choice) {
    unparsed_text = eventMainResponses[choice].title;
    findResponseStats();
    
    String response;
    if(response_stats_found) {
      response = unparsed_text_info[0];
    } else {
      response = eventMainResponses[choice].title;
    }
    eventMainResponses[choice].text_string(eventMainText.x, eventMainText.y, response, 22, eventMainText.c, CENTER);
  }
  
  void findResponseStats() {
    if((unparsed_text.contains("$")) && response_stats_found == false) {
      response_stats_found = true;
      if(response_stats_found) {
        unparsed_text_info = split(unparsed_text, "$");
        response_stats = Float.valueOf(unparsed_text_info[1]).floatValue();
        println(response_stats);
        mainGame.shipHealthCurrent += response_stats;
        mainGame.crew1.crewCurrentHealth += response_stats;
      }
    }
  }
  
  void createEvent() {
    if(mainGame.eventOpen == false) {
      if(minute() > time) {
        if(mainGame.eventPanelClosed && mainGame.inventoryOpen == false && mainGame.travelPanelOpen == false) {
          println("Checking for event");
          if(randomEvent()) {
            mainGame.eventOpen = true;
          }
          else {
            mainGame.eventOpen = false;
          }
        }
      }
    }
    time = minute();
  }
  
  boolean randomEvent() {
    int rand = (int)random(255);
    if(rand % 3 == 0) {
      return true;
    } else {
      return false;
    }
  }
 
}