class Gui {
    
  Gui(int _score, float _hp, int _lives, int _level) {
    score = _score;
    hp = _hp;
    lives = _lives;
    level = _level;
  }
  void display(int score, float hp, int lives, int level) {
    //display number of lives
    textFont(courier);
    text("Lives: ", 44, 24);
    for (int i = 0; i < lives; i++) {
      int x = 10 + i*10;
      fill(255);
      rect(x,40,5,23);
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
    //display score
    textFont(courier);
    fill(255);
    text(score,width/2,30);
    //display level
    textAlign(LEFT);
    text("Lv: " + level, 0, height-5);
    textAlign(CENTER);
  }
}