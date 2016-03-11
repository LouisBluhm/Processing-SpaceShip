class Inventory {
  
  IntDict items;
  PImage inv;
  
  Inventory() {
    inv = loadImage("inventory_withpanels.png");
  }
  
  void loadDefault() {
    items = new IntDict();
    createDefaultItems(items);
    println(items);
    image(inv, width/2, height/2);
  }
  
  void createDefaultItems(IntDict dict) {
    dict.set("Energy Cell", 10);
    dict.set("Missile", 5);
  }
  
  int getItemAmount(IntDict dict, String item) {
    int amount = dict.get(item);
    return amount;
  }
  
}