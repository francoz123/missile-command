/**
* This class represents a defence missile and can be used to
* -calculate missile launch angles
* -draw nissiles on the canvas
* -check for collissions
* -simulate movement
* -initiate explosions in other missile objects
*/
class Missile extends DefenceMissile{
  float explosionX;
  float explosionY;
  float angle;
  boolean explode = false;
  boolean exploding = false;
  boolean exploded = false;
  Explosion explosion;
  boolean hitGround = false;
  float speedMultiplier;
  int stikeRate = 100;
  
  /**
  * constructor to initialize x, y, and speedMultiplier
  * @param x float-x coordinate of a missile
  * @param y floatx-ycoordinate of a missile
  * @param speedMultiplier float-magmitude with which to mulltiply the speed 
  */
  Missile (float x, float y, float speedMultiplier){
    
    this.x = x;
    this.y = y;
    this.explosion = new Explosion(new Counter());
    float minAngle = atan((0 - this.x)/height);
    float maxAngle = atan((width - this.x)/height);
    this.angle = random(minAngle, maxAngle);
    this.speedMultiplier = speedMultiplier;
  }
  
  /**
  * Method to draw missile object on the game canvas
  * @return void
  */
  void show(){
    
    if(!this.exploded){ // if missile has not exploded
    
      ellipseMode(CENTER);
      fill(0);
      stroke(255,0,0);
      strokeWeight(9);
      line(x-20*sin(angle), y-20*cos(angle), x-6*sin(angle), y-6*cos(angle));
      stroke(255,255,0);
      strokeWeight(5);
      line(x-9*sin(angle), y-9*cos(angle), x, y);
      strokeWeight(1);
      stroke(0);
      ellipse(x,y, 10, 10);
    }
    
    if (hitGround()){ // missiles y coodinate is greater than or equal to hieght
      explode();
    }
  }
  
  /**
  * Method to simulate missile movement on the canvas
  * @param defenceMissiles - an ArrayList of DefenceMissilw objects
  * @param missiles - an ArrayList of missile objects
  * @return void
  */
  void move(ArrayList<DefenceMissile> defenceMissiles, ArrayList<Missile> missiles){
      if (!exploded){
        // reset x and y coodinates using missle angle
        x += gameManager.speed*sin(angle);
        y += gameManager.speed*cos(angle);
      }
      // display this missile
      show();
      
      if (collide(defenceMissiles, missiles) || explode) {
        
        if (!exploded){ // play sound if this missile hasn't exploded yet
          missileExplossion.play();
        }
        
        // set flag and explosion coordinates
        exploding = true;
        explosionX = x;
        explosionY = y;
        explode();
        
      }
      
      if (exploding){
        
        this.explosion.explode(images,explosionX, explosionY);
        this.explosion.incrementCounter();
        this.exploded = true;
        
      }
  }
  
  /**
  * Method to check collisions between missile objects
  * @param defenceMissiles - an ArrayList of DefenceMissilw objects
  * @param missiles - an ArrayList of missile objects
  * @return boolean
  */
  boolean collide(ArrayList<DefenceMissile> defenceMissiles, ArrayList<Missile> missiles){
    // return false if array is not initialized
    if((defenceMissiles == null || defenceMissiles.size() == 0) || (missiles == null || missiles.size() == 0)){return false;}
    
      // detect collisions between missiles
      for(int i=0; i<defenceMissiles.size(); i++)  {
        DefenceMissile defenceMissile = defenceMissiles.get(i);
        if(dist(this.x, this.y, defenceMissile.x, defenceMissile.y) < radius*2 && !defenceMissile.exploded && !this.exploded  ||
        (dist(this.x, this.y, defenceMissile.explosion.x, defenceMissile.explosion.y) < this.radius+defenceMissile.explosion.blastRadius)
        && !defenceMissile.explosion.finished && !this.exploded){
              
           defenceMissile.exploded = true;
           gameManager.incrementScore();
           return true;
        }
        
        for(int j=0; j<missiles.size(); j++)  {
          Missile missile = missiles.get(j);
          if(missile == this) continue;
          if(dist(this.x, this.y, missile.x, missile.y) < this.radius+missile.radius && !missile.exploded && !this.exploded  ||
          (dist(this.x, this.y, missile.explosion.x, missile.explosion.y) < this.radius+missile.explosion.blastRadius)
          && !missile.explosion.finished && !this.exploded){
            
             missile.explode();
             return true;
          }
        }
      
    }
    
    if(dist(this.x, this.y, width/2, height) < 40+this.radius){
      canon.distroy();
      return true;
    } 
        
    return false;
  }
  
  /**
  * Method to initiate missile explosion by a non missile object
  * @return void
  */
  void explode(){
    this.explode = !this.explode;
  }
  
  /**
  * Method to check if a missile object is at the bottom of the canvas
  * @return boolean
  */
  boolean hitGround() {
    return this.y >= height;
  }
}
