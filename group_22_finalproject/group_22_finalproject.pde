//Uses millionth vector sprites (http://millionthvector.blogspot.com/p/free-sprites.html)
boolean StartScreen = true;
boolean PauseScreen = false;
boolean Quit = false;
boolean GameOver = false;
boolean Victory = false;
boolean ShipSelect = true;

// Ship Selection Variables
PImage img;
PImage ship;
PImage orangeship;
PImage greenship;
PImage en_image;
boolean blueSelect = false;
boolean orangeSelect = false;
boolean greenSelect = false;
ButtonRect blue;
ButtonRect orange;
ButtonRect green;

// Gui Buttons 
ButtonRect rect;
ButtonRect quit;
ButtonRect mute;
boolean rectPressed = false;
boolean mutePressed = false;
Vehicle player;
//Enemy enemy1;

//starting position
int playerPosX = 500/2;
int playerPosY = 500-30;
int score = 0; 
int lives = 3;
float hp = 10;
int level = 1;
Gui gui;
int levelIndicatorTime = 0;
int ownerMarker = 0;

//keys pressed
boolean upPressed = false;
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;
boolean mouseClicked = false;

//enemies 
int numEnemies;
boolean new_enemy = false;
boolean flag = true;
boolean skip;
PFont courier, titleFont;

//declare sound variables
import processing.sound.*;
SoundFile sample, pew;

//time variables
Timer t1;

// Arrays of varaibles
ArrayList <Bullet> bullets;
ArrayList <Enemy> enemies;
ArrayList <Enemy> boss;
ArrayList <Bullet> enemybullets;
ArrayList <enemyShield> enemyshield;

int counter = 1;
IntList deadBullets;
IntList deadEnemies;
IntList deadEnemyBullets;

void setup() {
  size(500,500);
  
  //ship images
  img = loadImage("home.jpg");
  ship = loadImage("blueship3.png");
  orangeship = loadImage("orangeship.png");
  greenship = loadImage("greenship3.png");
  en_image = loadImage("alien3.png");
  
  //buttons and text loading
  courier = createFont("Courier-New", 30);
  titleFont = loadFont("BankGothicBT-Medium-80.vlw");
  textFont(courier);
  textAlign(CENTER);
  blue = new ButtonRect(20,150,150,200, color(140), color(0));
  orange = new ButtonRect(175,150,150,200, color(140), color(0));
  green = new ButtonRect(330,150,150,200, color(140), color(0));
  mute = new ButtonRect(180,150,140,60, color(140), color(110));
  quit = new ButtonRect(180,250,140,60, color(140), color(110));
  rect = new ButtonRect(180,350,140,60, color(140), color(110));

  
  noStroke();
  
  //HUD and player
  player = new Vehicle(playerPosX,playerPosY,30,30);
  gui = new Gui(score, hp, lives, level);
  
  //sound
  sample = new SoundFile(this, "combine.mp3");
  sample.loop();
  pew = new SoundFile(this, "ATST.wav");
  //game mechanics
  t1 = new Timer(3500); 
  bullets = new ArrayList();
  enemies = new ArrayList();
  boss = new ArrayList();
  enemybullets = new ArrayList();
  deadBullets = new IntList();
  deadEnemies = new IntList();
  deadEnemyBullets = new IntList();
}

void draw() {
  //open start screen if game hasn't been started
  if (StartScreen == true) {
    if (rectPressed) {
      background(255);
    }
    //waiting for button press
    else {
      background(245,30,50);
      image(img,0,0,500,500);
    }
    rect.update(mouseX, mouseY);
    rect.display();
    fill(225);
    textFont(courier);
    text("Start", width/2,height/2+140);
    textFont(titleFont);
    fill(232,236,40,200);
    text("StarSpace", width/2, height/4+50);
  }
  // Ship Select Menu
  if (!StartScreen && ShipSelect == true){
    background(0);
    blue.update(mouseX, mouseY);
    blue.display();
    fill(235);
    orange.update(mouseX, mouseY);
    orange.display();
    fill(235);
    green.update(mouseX, mouseY);
    green.display();
    fill(235);
    fill(255);
    textSize(20);  
    if (blue.isMouseOver == true){
      text("The Blueberry Bazzle ship has a long laser. This ship will get you far.", 100, 50, 300, 500);
    }
    if (orange.isMouseOver == true){
      text("The Orange You Glad ship has multiple shots", 100, 50, 300, 500);
    }
    if (green.isMouseOver == true){
      text("The Lean Mean Charlie Sheen String Bean Green Machine it has powerful bombs, but there is a delay in shooting them", 100, 50, 300, 500);
    }
    
    image(ship, 50, 150, 100, 200);
    image(orangeship, 200, 150, 100, 200);
    image(greenship, 350, 150, 100, 200);
  }
  //if game has been started, they havnt quit and they havn't won
  if (!StartScreen && !Quit && !Victory && !ShipSelect) {
    background(0);
    gui.display(score, hp, lives, level);
    //GAME OVER- check if they lost their last life
    if (lives == -1) {
      GameOver = true;
      background(0);
      fill(255);
      text("Game Over",width/2,height/2);
      text(score,width/2,height/3);
    //check if health is 0 -> lose a life
    } else if (hp == 0) {
      lives -= 1;
      hp = 10;
    }else if (level == 6) {                              //number of levels
      //check if the last level has been passed
      Victory = true;
    }else if (PauseScreen && !Quit) {
      //draws pause screen if game is paused and they havn't quit
      background(0);
      if (rectPressed && !Quit) {
        //continue was clicked, game is unpaused
        PauseScreen = false;

      }else {
        //paused
        PauseScreen = true;
      }
      
      //pause screen buttons and game title
      mute.update(mouseX, mouseY);
      mute.display();
      fill(235);
      textFont(courier);
      text("Mute", width/2, height/2-60);
      // quit button in start
      quit.update(mouseX, mouseY);
      quit.display();
      fill(235);
      textFont(courier);
      text("Quit", width/2, height/2+40);
      // continune button in pause menu
      rect.update(mouseX, mouseY);
      rect.display();
      fill(235);
      textFont(courier);
      text("Continue", width/2,height/2+140);
      textFont(titleFont);
      text("StarSpace", width/2, height/4);

   
    }else{
      //gameplay
      background(0);
      gui.display(score, hp, lives, level);
      removeToLimit();  //checks number of player bullets and clears extras
      moveAll();        //moves all bullet locations
      displayAll();     //updates all bullets on screen            could combine these 2 functions?
      boundaryBullets();//eliminates enemy bullets that reach the edge of the screen
      imageMode(CENTER);
      
      //improved player actions allows multiple commands at once
      if (upPressed == true) {
        player.moveUp();
      }if(downPressed == true) {
        player.moveDown();
      }if(leftPressed == true) {
        player.moveLeft();
      }if(rightPressed == true) {
        player.moveRight();
      }
      playerPosX = player.getX();
      playerPosY = player.getY();
      //fire
      if(mouseClicked == true) {
        Bullet temp = new Bullet(playerPosX, playerPosY-50,"laser",0);
        bullets.add(temp);
      }
      
      player.display();//draw the player!

      //levels!
      //only level 1 is annotated but the code is the same for all levels
      //changed Ernie's flag scheme because its weird and now you can copy paste to add a level without worrying about variable changes
      //level 1
      if (level == 1) {
        numEnemies = 1;
        //displays level for a couple frames
        if (levelIndicatorTime <= 100){
          text("Level 1",width/2,height/2);
          levelIndicatorTime += 1;
        }
        //spawn enemies
        if (numEnemies <= 1 && flag == true){
          Enemy temp = new Enemy(0, 50, 100, 100, 3, "cannon");
          //Enemy temp = new Enemy(100, 100, 250, 250, 15);
          enemies.add(temp);
          new_enemy = true;
          flag = false;
          //println("t1 time = " + t1.time);
        }
        //spawn enemy bullets
        if ( enemybullets.size() < numEnemies ) {
          for (Enemy grunt:enemies) {
            Bullet ebullet = new Bullet(grunt.getX(), grunt.getY(),grunt.getWeapon(), ownerMarker);
            enemybullets.add(ebullet);
          }
        }  
        counter += 1;
        //check for hits while there are enemies left
        //int bullCount = -1;
        if (new_enemy == true){
          updateAll();
          evalCollisions();
        }
        //if no enemies then advance level and reset variables
        if (numEnemies == 0) {
          level += 1;
          levelIndicatorTime = 0;
          new_enemy = false;
          counter = 1;
          enemybullets.clear();
          flag = true;
        }
      }//level2
      if (level == 2) {
        if (levelIndicatorTime <= 100){
          text("Level 2",width/2,height/2);
          levelIndicatorTime += 1;
        }
        if (numEnemies <= 2 && flag == true){
           println("round 2");
           Enemy temp = new Enemy(0, 50, 100, 100, 5, "enemyLaser");
           Enemy temp2 = new Enemy(100, 50, 100, 100, 5, "enemyLaser");
           enemies.add(temp);
           enemies.add(temp2);
           new_enemy = true;
           flag = false;
           numEnemies = 2;
        }
        if ( enemybullets.size() < numEnemies ) {
          ownerMarker = 0;
          for (Enemy grunt:enemies) {
            skip = false;
            for (Bullet eshot:enemybullets) {
              if (eshot.getOwner(ownerMarker)) {
                skip = true;
              }
            }
            if (!skip) {
              Bullet ebullet = new Bullet(grunt.getX(), grunt.getY(),grunt.getWeapon(),ownerMarker);
              enemybullets.add(ebullet);
            }
            ownerMarker += 1;
            
          }
        }
        counter += 1;
        if (new_enemy == true){
          updateAll();
          evalCollisions();
        }
        if (numEnemies == 0) {
          level += 1;
          levelIndicatorTime = 0;
          new_enemy = false;
          counter = 1;
          enemybullets.clear();
          flag = true;
        }
      }//level 3
      if (level == 3) {
        if (levelIndicatorTime <= 100){
          text("Level 3",width/2,height/2);
          levelIndicatorTime += 1;
        }
        if (numEnemies <= 3 && flag == true){
           println("round 3");
           Enemy temp = new Enemy(0, 100, 100, 100, 5,"cannon");
           Enemy temp2 = new Enemy(100, 50, 100, 100, 5,"cannon");
           Enemy temp3 = new Enemy(200, 100, 100, 100, 5, "enemyLaser");
           enemies.add(temp);
           enemies.add(temp2);
           enemies.add(temp3);
           new_enemy = true;
           flag = false;
           numEnemies = 3;
        } 
        if ( enemybullets.size() < numEnemies ) {
          ownerMarker = 0;
          for (Enemy grunt:enemies) {
            skip = false;
            for (Bullet eshot:enemybullets) {
              if (eshot.getOwner(ownerMarker)) {
                skip = true;
              }
            }
            if (!skip) {
              Bullet ebullet = new Bullet(grunt.getX(), grunt.getY(),grunt.getWeapon(),ownerMarker);
              enemybullets.add(ebullet);
            }
            ownerMarker += 1;
            
          }
        }
          counter += 1;
        if (new_enemy == true){
          updateAll();
          evalCollisions();
        }
        if (numEnemies == 0) {
          level += 1;
          levelIndicatorTime = 0;
          new_enemy = false;
          counter = 1;
          enemybullets.clear();
          flag = true;
        }
      }//level 4
      if (level == 4) {
        if (levelIndicatorTime <= 100){
          text("Level 4",width/2,height/2);
          levelIndicatorTime += 1;
        }
        if (numEnemies <= 4 && flag == true){
           println("round 4");
           Enemy temp = new Enemy(0, 50, 100, 100, 8,"cannon");
           Enemy temp2 = new Enemy(100, 50, 100, 100, 8,"enemyLaser");
           Enemy temp3 = new Enemy(200, 150, 100, 100, 8,"weapon");
           Enemy temp4 = new Enemy(100, 150, 100, 100, 8,"enemyLaser");
           enemies.add(temp);
           enemies.add(temp2);
           enemies.add(temp3);
           enemies.add(temp4);
           new_enemy = true;
           flag = false;
           numEnemies = 4;
        } 
        if ( enemybullets.size() < numEnemies ) {
          ownerMarker = 0;
          for (Enemy grunt:enemies) {
            skip = false;
            for (Bullet eshot:enemybullets) {
              if (eshot.getOwner(ownerMarker)) {
                skip = true;
              }
            }
            if (!skip) {
              Bullet ebullet = new Bullet(grunt.getX(), grunt.getY(),grunt.getWeapon(),ownerMarker);
              enemybullets.add(ebullet);
            }
            ownerMarker += 1;
            
          }
        }
         counter += 1;
        if (new_enemy == true){
          updateAll();
          evalCollisions();
        }
        if (numEnemies == 0) {
          level += 1;
          levelIndicatorTime = 0;
          new_enemy = false;
          counter = 1;
          enemybullets.clear();
          flag = true;
        }
      }//level 5
    if (level == 5) {
      if (levelIndicatorTime <= 100){
        text("BOSS LEVEL",width/2,height/2);
        levelIndicatorTime += 1;
      }
      if (numEnemies <= 4 && flag == true){
         //println("BOSS ROUND");
         //BOSSS
         Enemy temp = new Enemy(100, 100, 250, 250, 15,"boss");
         //Enemy temp2 = new Enemy(300, 300, 100, 100, 5);
         //Enemy temp3 = new Enemy(100, 300, 100, 100, 5);
         enemies.add(temp);
        // enemies.add(temp2);
         //enemies.add(temp3);
         new_enemy = true;
         flag = false;
         numEnemies = 1;
      }
      if (enemybullets.size() < numEnemies ) {
          for (Enemy grunt:enemies) {
            Bullet ebullet = new Bullet(grunt.getX(), grunt.getY(),grunt.getWeapon(),ownerMarker);
            enemybullets.add(ebullet);
          }
         /* for (Enemy bos:boss) {
            Bullet ebullet = new Bullet(bos.getX(), bos.getY(),"laser");
            enemybullets.add(ebullet);
          }*/
      }  
          counter += 1;
      if (new_enemy == true){
        updateAll();
        evalCollisions();
      }
      if (numEnemies == 0) {
        level += 1;
        levelIndicatorTime = 0;
        new_enemy = false;
        counter = 1;
        flag = true;
      }
    }
    
    }
  }
  //if quit is true then end the game
  else if (Quit) {
    lives = -1;
    PauseScreen = false;
    Quit = false;
  //if victory then display results
  }else if(Victory) {
    background(0);
    fill(255);
    text("YOU WIN!", width/2, height/2);
    text(score, width/2, height/3);
    if (mousePressed == true){
      exit();
    }
  }
}

void boundaryBullets() {
  //removes enemy bullets once off screen
  int bullCount = -1;
  //records which bullets need to be removed and builds an array
  for (Bullet bullet: bullets) {
    if (bullet.getY() < 0) {
      bullCount += 1;
      deadBullets.append(bullCount);
    }
  }
  int bcounter = 0;
  //uses array to eliminate player bullets from their array  *overcomes simultaneous reading and erasing error 
  while(deadBullets.size() >0) {
    if (deadBullets.get(0) == 0) {
      bullets.remove(deadBullets.get(0));
    }else {
      bullets.remove(deadBullets.get(0)-bcounter);//////
    }
    deadBullets.remove(0);
    bcounter += 1;
  }    
  //removes enemy bullets once off screen
  int ebullCount = -1;
  //records which bullets need to be removed and builds an array
  for (Bullet ebullet: enemybullets) {
    if (ebullet.getY() > 500) {
      ebullCount += 1;
      deadEnemyBullets.append(ebullCount);
    }
  }
  int ebcounter = 0;
  //uses array to eliminate enemy bullets from their array  *overcomes simultaneous reading and erasing error 
  while(deadEnemyBullets.size() >0) {
    //println("num dead bullets",deadEnemyBullets.size(),"num ebullets", enemybullets.size(), "ebcounter", ebcounter,"bullet number", deadEnemyBullets.get(0));
    //fix to the bullet counting error
    if (deadEnemyBullets.get(0) == 0) {
      enemybullets.remove(deadEnemyBullets.get(0));
    }else {
      enemybullets.remove(deadEnemyBullets.get(0)-ebcounter);//////
    }
    deadEnemyBullets.remove(0);
    ebcounter += 1;
  }
}


void evalCollisions() {
  int px = player.getX();
  int py = player.getY();
  int pw = 50;
  int ph = 30;
  //cycle through enemies
  int enemyCount = -1;
  for(Enemy grunt : enemies) {
    enemyCount += 1;
    int ex = grunt.getX();
    int ey = grunt.getY();
    int ew = grunt.getW();
    int eh = grunt.getH();
    
    //uses location and size properties to determine if they collided
    if(collision(px, py, pw, ph, ex, ey, ew, eh)) {
      //kill player and reset location
      hp = 0;
      player.setX(250);
      player.setY(470);
    }
  }
  
  //looks for bullets in ship space and if true adds to a dead list to remove or lower health
  //player bullets
  int bullCount = -1;
  //cycle through player bullets
  for(Bullet temp : bullets ){
    bullCount += 1;
    int bx = temp.getX();
    int by = temp.getY();
    int bw = 5;
    int bh = 10;
    enemyCount = -1;
    //cycle through enemies
    for(Enemy grunt : enemies) {
      enemyCount += 1;
      int ex = grunt.getX();
      int ey = grunt.getY();
      int ew = grunt.getW();
      int eh = grunt.getH();
      
      //uses location and size properties to determine if they collided
      if(collision(bx, by, bw, bh, ex, ey, ew, eh)) {
        //println(!deadEnemies.hasValue(enemyCount));
        //println(enemyCount);
        //records number of enemy/bullet into 2 arrays to use for deletion
        if (!deadEnemies.hasValue(enemyCount)) {
          deadEnemies.append(enemyCount);
        }
        if (!deadBullets.hasValue(bullCount)) {
          deadBullets.append(bullCount);
        }

      }
    }
  }
  //repeat for enemy bullets hitting the player
  int ebullCount = -1;
  for(Bullet ebullet: enemybullets) {
    ebullCount += 1;
    int ebx = ebullet.getX();
    int eby = ebullet.getY();
    int ebw = 5;
    int ebh = 10;
    //int px = player.getX();
    //int py = player.getY();
    //int pw = 50;
    //int ph = 30;
    
    if(collision(ebx,eby,ebw,ebh,px,py,pw,ph)) {
      if(!deadEnemyBullets.hasValue(ebullCount)) {
        deadEnemyBullets.append(ebullCount);
      }
      hp -= 1;
    }
  }
  //correction if a ship is destroyed
  int ecounter = 0;
  while (deadEnemies.size() > 0) {
    //damages or removes hit enemy ships
    enemies.get(deadEnemies.get(0)-ecounter).healthDamage();
    if (enemies.get(deadEnemies.get(0)-ecounter).getHealth() == 0){
      enemies.remove(deadEnemies.get(0)-ecounter); 
      numEnemies -= 1;
      ecounter += 1;
    }
    deadEnemies.remove(0);
    score += 100;
    
  }
  //removes used player bullets
  int bcounter = 0;
  while (deadBullets.size() > 0) {
    bullets.remove(deadBullets.get(0)-bcounter);
    deadBullets.remove(0);
    bcounter += 1;
  }
}

void removeToLimit() {
  //limits number of shots fired by the player
  while(bullets.size() > 1) {
    bullets.remove(0);
  }
  /*for (enemyBullet ebullet: enemybullets) {
    if (ebullet.getY() > 500) {
      enemybullets.remove(0);
    }
  }*/
}

void moveAll() {
  //updates all bullet locations
  for(Bullet temp: bullets) {
    temp.move("player");
  }
  for(Bullet ebullet: enemybullets) {
    ebullet.move("enemy");
  }
}

void displayAll() {
  //displays all bullets
  for(Bullet temp : bullets) {
    temp.display();
  }
  for(Bullet ebullet: enemybullets) {
    ebullet.display();
  }
}

void updateAll() {
  //updates all enemy ship locations and displays
  for(Enemy temp : enemies) {
    temp.display();
  }
}

public Boolean collision(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
  //checks if 2 objects intersect
  if (x1 + w1/2 > x2 - w2/2 && x1 - w1/2 < x2 + w2/2) { 
    //return true;
    if (y1 + h1/2 > y2 - h2/2 && y1 - h1/2 < y2 + h2/2) {
      //println("Hit");
      beginShape();
      vertex(x1-40,y1);
      vertex(x1-20,y1+20);
      vertex(x1,y1);
      vertex(x1+20,y1+20);
      vertex(x1+40,y1);
      endShape();
      return true;
    }
  }
  return false;
}

void mousePressed(){
  //start game
  if(StartScreen == true) { 
    if(rect.isPressed()) {
      StartScreen = false;
    }
  }

  //ship selection
  if (!StartScreen && ShipSelect == true){
    if(blue.isPressed()){
      blueSelect = true;
      ShipSelect = false;
    }
    if(orange.isPressed()){
      orangeSelect = true;
      ShipSelect = false;
    }
    if(green.isPressed()){
      greenSelect = true;
      ShipSelect = false;
    }
  }
    //fire bullets!
  else if(!StartScreen && !PauseScreen) {
    Bullet temp = new Bullet(playerPosX, playerPosY-50,"laser",0);
    bullets.add(temp);
  }
  
  //unpause game or quit
  else if (PauseScreen == true) {
    if(rect.isPressed()) {
      PauseScreen = false;
    }else if(quit.isPressed()) {
      Quit = true;
      //PauseScreen = false;
    }else if(mute.isPressed() && mutePressed == false){
      sample.amp(0);
      mutePressed = true;
    }else if(mute.isPressed() && mutePressed == true){
      sample.amp(1.0);
      mutePressed = false;
    }
  //close game after loss
  }if (lives == -1) {
    exit();
  }
}

void mouseReleased() {
  rect.isReleased();
  quit.isReleased();
}


void keyPressed() {
  if (keyCode == TAB && !StartScreen) {
      PauseScreen = !PauseScreen;
  }
  else if (!StartScreen && !PauseScreen) {
    //movement  
    if (keyCode == UP) {
      upPressed = true;
    }if(keyCode == DOWN) {
      downPressed = true;
    }if(keyCode == LEFT) {
      leftPressed = true;
    }if(keyCode == RIGHT) {
      rightPressed = true;
    //secret weapon
    }if(keyPressed && key == ' ') {
      mouseClicked = true;
    }
  }
}

void keyReleased() {
  if (!StartScreen && !PauseScreen) {
    //movement  
    if (keyCode == UP) {
      upPressed = false;
    }if(keyCode == DOWN) {
      downPressed = false;
    }if(keyCode == LEFT) {
      leftPressed = false;
    }if(keyCode == RIGHT) {
      rightPressed = false;
    }if(keyPressed && key == ' ') {
      mouseClicked = false;
    }
  }
}