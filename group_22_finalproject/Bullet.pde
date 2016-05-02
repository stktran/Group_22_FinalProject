//AudioDevice device;
//SoundFile[]
//use assignment 5
class Bullet {
  int x, y, originY, speed, owner;
  String type;
  int leadTime = 0;
  int rearTime = 0;
  int burstX = x;
  //boolean burstX = true;
  Bullet(int _x, int _y, String _type, int _owner) {
    x = _x;
    y = _y;
    type = _type;
    owner = _owner;
    originY = _y;
  }
  void display() {
    if (type == "cannon") {
      //println("cannon", y);
      fill(255);
      rect(x,y-20,5,10);//bullet appearance
    }
    else if (type == "burst") {
      fill(0, 200, 175);
      rect(x,y,10,20);
      fill(255);
      rect(burstX,y,10,10);
      //rect(burstX,y,burstX,10);
      //triangle(x,y,x+50, y+10, x+10, y+10);//bullet appearance
      //rect(x+100,x+100,15, 15);//bullet appearance
      //ellipse(x+100,y,x+10,y);

    }
    else if (type == "laser"){
      //println(y);
      fill(255);
      if (y > 30) {
        y-= 30;
      }
      if (leadTime <= 10) {
        fill(255);
        rectMode(CORNERS);
        rect(x,y,x+5,originY);
        rectMode(CENTER);
      }else if (leadTime < 19) {
        //print("ping");
        originY -= rearTime;
        fill(255);
        rectMode(CORNERS);
        rect(x,0,x+5,originY);
        rectMode(CENTER);
        rearTime += 20;
      }else {

        y=-1;

      }
    }
    else if (type == "enemyLaser"){
      //println("laser",y);
      fill(255);
      //fill(255,0,0);
      if (leadTime <= 10) {
        fill(255);
        //fill(0,255,0);
        rectMode(CORNERS);
        rect(x,y,x+5,originY);
        rectMode(CENTER);
      }else if (leadTime < 15) {
        //print("ping");
        originY += rearTime;
        fill(255);
        rectMode(CORNERS);
        rect(x,500,x+5,originY);
        rectMode(CENTER);
        rearTime += 20;
      }
      
    }
    else if (type == "rocket") {
      fill(255,0,0);
      rect(x,y,10,10);
    }
    else if (type == "boss"){
      //println(y);
      if (y > 30) {
        y+= 30;
      }
      if (leadTime <= 40) {
        fill(255);
        rectMode(CORNERS);
        fill(0, 145, 235, 145);
       // rect(x,y+100,x+30,originY);
        triangle(x-5,y,x,originY,x+40,originY+ 90);
        fill(215, 45, 170, 145);
        triangle(x-5,y,x,originY,x-40,originY+ 90 );
       // rect(x,y+100,x+7,originY);
        
        rectMode(CENTER);
        fill(255);
        
      }else if (leadTime < 39) {
        //print("ping");
        originY += rearTime;
        fill(255);
        rectMode(CORNERS);
        rect(x,0,x+40,originY);
        rectMode(CENTER);
        rearTime += 10;
      }else {

        //y=+80;

      }
    }
    
    leadTime += 1;
  }
  void move(String direction) {
    if ( y >-10 && type == "cannon"){
      if (direction == "player") {
        y -= 10;
      } else if (direction == "enemy") {
        y += 8;
      }
      
    }else if (type == "burst") {
      
          burstX = x + int(sin(y)*50);
          y -= 4;
          
        
        /*
       if (burstX == true) {
        y -= 10;
        x += 50;
        burstX = false;
        
       }else if (burstX == false){
         y -= 10;
         x -= 50;
         burstX = true;
        }
        */
      
    }else if (type == "enemyLaser") {
      //if (y < 480) {
        y+= 30;
      //}
      
    }else if (type == "rocket") {
      if (leadTime < 25) {
        if (direction == "enemy") {
          y += 1;
        }else if (direction == "player") {
          y -= 1;
        }
      }
      else {
        if (direction == "enemy") {
          y += 20;
        }else if (direction == "player") {
          y -= 20;
        }
        
      }
    }
    
  }
  //return coordinates
  public Integer getX() {
    return x;
  }
  public Integer getY() {
    return y;
  }
  public String getType() {
    return type;
  }
  public Boolean getOwner(int grunt) {
    if (grunt == owner) {
      return true;
    }else {
      return false;
    }
  }
}