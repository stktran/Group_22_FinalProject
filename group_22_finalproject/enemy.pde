class Enemy{
  int x,y;
  int w,h;
  int health;
  String weapon;
  float maxHealth;
  boolean forward = true;
  Enemy(int _x, int _y, int _w, int _h, int _health, String _weapon) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    weapon = _weapon;
    health = _health; 
    maxHealth = _health;
  }
  void display() {
    imageMode(CENTER);
    image(en_image, x, y, w, h);
    update();
    for (int j = 0; j < health; j++) {
      int p = x-w/2+ j*w/15;
      if (health > maxHealth/2) {
        fill(21,149,5);
      } else if (health > maxHealth/4){
        fill(232,226,40);
      } else {
        fill(235,50,30);
      }
      rect(p, y-30, w/20, h/10);
    }
  }

  void update() { 
    if (x <= 500-w/2 && forward == true){
      x = x + 5;
    }
    if (x > 500-w/2){
      forward = false;
    }
    if (x >= 0+w/2 && forward == false){
      x = x - 5;
    }
    if (x < 0+w/2){
      forward = true;
    }
  }
  void healthDamage(){
    health = health - 1;
  }
  public Integer getX() {
    return x;
  }
  public Integer getY() {
    return y;
  }
  public Integer getW() {
    return w;
  }
  public Integer getH() {
    return h;
  }
  public Integer getHealth() {
    return health;
  }
  public String getWeapon() {
    return weapon;
  }
 }