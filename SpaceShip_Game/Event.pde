class Event {
  
  int time = minute();
  Table random_events; 
  //String[] random_events;
  String message, responses;
  String[] parsed_responses;
  float id;
  String event;
  
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
    
  }
  
  void createEvent() {
    if(minute() > time) {
      println("Checking for event");
      if(mainGame.eventPanelClosed && mainGame.inventoryOpen == false && mainGame.travelPanelOpen == false) {
        if(randomEvent()) {
          println(">>>>> EVENT <<<<<");
          mainGame.eventOpen = true;
        }
        else {
          print("Event not started");
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
  
  String randomEventString() {
    return message;
  }
  String eventResponses(int id) {
    return parsed_responses[id];
  }
 
}