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
    
    itemData = new UI(0, 0, "data", color(255));
    inv_itemX = width/2 - 400;
    inv_itemY = height/2;
    items = loadJSONArray("items.json");
    loadJSON();
    // printArray(itemNames);
  }

  void loadDefault() {
    image(inv, width/2 + 100, height/2);
    image(inv_item, inv_itemX, inv_itemY);
    drawItems();
  }
  
  void drawItems() {
    for(int i = 0; i < inventory_items.length; i++) {
      image(inventory_items[i], width/2-123, height/2-214);
      if(rectHover(width/2-123, height/2-214, 100, 100)) {
        println("Item hover detected");
      }
    println("--------");
    }
  } 

  void loadJSON() {
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