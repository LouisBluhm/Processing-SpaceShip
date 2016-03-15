class Inventory {

  PImage inv, inv_item;
  boolean invOpen = false;

  float inv_itemX;
  float inv_itemY;

  UI itemData;

  //Load JSON data
  JSONArray values;

  Inventory() {
    inv = loadImage("inventory_withpanelstext.png");
    inv_item = loadImage("inventory_item.png");
    itemData = new UI(0, 0, "data", color(255));
    inv_itemX = width/2 - 400;
    inv_itemY = height/2;
  }

  void loadDefault() {
    values = loadJSONArray("text.json");
    image(inv, width/2 + 100, height/2);
    image(inv_item, inv_itemX, inv_itemY);
    item();
  }

  void item() {
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