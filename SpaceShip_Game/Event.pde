class Event {
  
  int time = minute();
  Table random_events; 
  //String[] random_events;
  String message, responses;
  String[] parsed_responses;
  float id;
  String event;
  
  //UI positioning
  float response_xpos = width/2 - 300;
  float[] response_ypos = {height/2+30, height/2+70, height/2+110};
  
  Event() {
    //random_events = loadStrings("events.ven");
    //message = random_events[(int)(Math.random() * random_events.length)];
    random_events = loadTable("events.csv", "header");
    
    //for(TableRow row : random_events.rows()) {
    //  id = row.getInt("id");
    //  event = row.getString("event");
    //  println(id);
    //  println(event);
    //}
    int row_total = random_events.getRowCount();
    println(row_total);
    int row_random = (int)random(row_total);
    println(row_random);
    
    TableRow row = random_events.getRow(row_random);
    message = row.getString("event");
    responses = row.getString("responses");
    
    parsed_responses = split(responses, "|");
    for(int i = 0; i < parsed_responses.length; i++) {
      if(parsed_responses[i].equals("Null")) {
        parsed_responses[i].replaceAll("Null", "");
      }
    }
  }
  
  String randomEventString() {
    return message;
  }
  String eventResponses(int id) {
    return parsed_responses[id];
  }
  
  void createEvent() {
    if(true) {
    // if(minute() > time) {
      if(true) {
      // if(mainGame.eventPanelClosed && mainGame.inventoryOpen == false && mainGame.travelPanelOpen == false) {
        if(true) {
        // if(randomEvent()) {
          mainGame.eventOpen = true;
        }
        else {
          mainGame.eventOpen = false;
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