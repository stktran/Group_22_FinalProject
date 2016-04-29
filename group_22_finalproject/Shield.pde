class enemyShield {
  int x, y, speed;
  enemyShield(int _x, int _y) {
    x = _x;
    y = _y;
  }
  void display() {
    beginShape();
    vertex(x-20,y);
    vertex(x-10,y+10);
    vertex(x,y);
    vertex(x+10,y+10);
    vertex(x+20,y);
    endShape();
  }
}