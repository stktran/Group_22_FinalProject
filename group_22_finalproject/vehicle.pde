class Vehicle {
  int x,y;
  int w,h;
  Vehicle(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  void display() {
    //fill(255,0,0);
    rectMode(CENTER);
    //rect(x,y,w,h);
    if (blueSelect == true){
    image(ship, x,y,w+50,h+50);
    }
    if (orangeSelect == true){
    image(orangeship, x,y,w+50,h+70);
    }
    if (greenSelect == true){
    image(greenship, x,y,w+40,h+70);
    }
    //println(x,y,w,h);
  }
  void setX(int xLoc) {
    x = xLoc;
  }
  void setY(int yLoc) {
    y = yLoc;
  }
  void moveUp() {
    if (y - 3 - h >= 0) {
      y -= 5;
    }
  }
  void moveDown() {
    if (y + 3 + h <= height) {
       y += 5;
    }
  }
  void moveLeft() {
    if (x - 3 - w >= 0) {
      x -= 5;
    }
  }
  void moveRight() {
    if (x + 3 + w <= width) {
      x += 5;
    }
  }
  public Integer getX() {
    return x;
  }
  public Integer getY() {
    return y;
  }
}