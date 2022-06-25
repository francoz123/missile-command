class DefenceMissile{
  float radius = 5;
  boolean exploded = false;
  float angle;
  float x;
  float y;
  float targetX;
  float targetY;
  int speed = 5;
  Explosion explosion;
  PImage target;
  PVector velocity;
 
  
  DefenceMissile(){
  }
  
  /**
  * constructor to initialize x, y, targetX, targetY, and  explosion
  * @param x float-x coordinate of a missile
  * @param y floatx-ycoordinate of a missile
  * @param targetX float-x coordinate of missile's target
  * @param targetY floatx-ycoordinate of amissile's target
  * @param explosion - an Explosion object
  */
  DefenceMissile (float x, float y, float targetX, float targetY, float angle, Explosion explosion){
    this.x = x;
    this.y = y;
    this.targetX = targetX;
    this.targetY = targetY;
    this.angle = angle;
    this.explosion = explosion;
    target = loadImage("targets/red_circle.png");
    velocity = new PVector(1, 1);
    
  }
  
  /**
  * Method to draw missile object on the game canvas
  * @return void
  */
  void show(){
    if(!this.exploded){
      ellipseMode(CENTER);
      fill(0);
      //ellipse(x,y, radius*2, radius*2);
      stroke(255,0,0);
      strokeWeight(9);
      line(x+13*sin(angle), y+13*cos(angle), x+6*sin(angle), y+6*cos(angle));
      stroke(255,255,0);
      strokeWeight(5);
      line(x+9*sin(angle), y+9*cos(angle), x, y);
      strokeWeight(1);
      stroke(0);
      ellipse(x,y, 10, 10);
    }
  }
  
  /**
  * Method to simulate missile movement
  * @return void
  */
  void move(){
    
    if(!this.exploded){
      
      PVector aceleration = new PVector(0.5, 0.5);
      velocity.add(aceleration); // increment velocity using acceleration
      y -= velocity.x*cos(angle);
      x -= velocity.y*sin(angle);
      
      showTarget(); // draw target on the canvas
    }
    
    show();
    
    if (y < targetY){ // if this missile reaches it's target, it should explode
      
      if (!exploded){
        missileExplossion.play(); // play explosion sound
        
      }
      
      // set explosion parameters
      this.explosion.x = targetX;
      this.explosion.y = targetY;
      this.explosion.explode(images,targetX, targetY);
      this.explosion.incrementCounter();
      this.exploded = true;
      
    }
  }
  
  /**
  * Method to draw target on the screen
  * @return void
  */
  void showTarget(){
    image(target, targetX, targetY, 50, 50);
  }
}
