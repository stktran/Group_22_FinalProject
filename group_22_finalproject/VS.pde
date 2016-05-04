class versusGui {
  
  versusGui(float _hp1, int _lives1, float _hp2, int _lives2) {
    hp = _hp1;
    lives = _lives1;
    hp2 = _hp2;
    lives2 = _lives2;
  }
  void display(float hp, int lives, float hp2, int lives2) {
    //display number of lives
    textFont(courier);
    text("P2: ", 44, 24);
    for (int i = 0; i < lives2; i++) {
      int x2 = 10 + i*10;
      fill(255);
      rect(x2,40,5,23);
    }
    text("P1: ", 344, 24);
    for (int i = 0; i < lives; i++) {
      int x = 10 + i*10;
      fill(255);
      rect(x,340,5,23);
    }
    //display health
    for (int j = 0; j < hp; j++) {
      int y = 10 + j*30;
      if (hp > 5) {
        fill(21,149,5);
      } else if (hp > 2){
        fill(232,226,40);
      } else {
        fill(235,50,30);
      }
      rect(460,y,15,30);
    }
    for (int j = 0; j < hp2; j++) {
      int y = 10 + j*30;
      if (hp2 > 5) {
        fill(21,149,5);
      } else if (hp2 > 2){
        fill(232,226,40);
      } else {
        fill(235,50,30);
      }
      rect(460,y,15,30);
    }
  }
}