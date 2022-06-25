/**
 * This class represents a conon
 * it can be used to
 * - fire missiles
 * - draw a canon on the canvas
 * - draw missile targets on the canvas
 */
class Canon{
  float centerX;
  float centerY;
  float canonWidth;
  float canonHight;
  float x2;
  float y2;
  float missileAngle;
  PImage target;
  boolean distroyed;

  /**
   * constructor to initialize five fields
   * @param centerX - x coordinate of the canon
   * @param centerY - y coordinate of the canon
   * @param canonWidth - width of the canon
   * @param canonHight - height of the canon
   */
  public Canon(float centerX,float centerY,float canonWidth,float canonHight){
    this.centerX = centerX;
    this.centerY = centerY;
    this.canonWidth = canonWidth;
    this.canonHight = canonHight;
    this.target = loadImage("targets/black_circle2.png");
    this.distroyed = false;
  }

  // Metnhod to draw canon on the canvas
  void show(){
      
    float x = mouseX - (centerX);
    float y = (centerY-mouseY);
    float angle = atan(x/y);
    missileAngle = -atan(x/y);
    x2 = (0*cos(missileAngle) - canonHight*sin(missileAngle))+width/2;
    y2 = 200-(0*sin(missileAngle) + canonHight*cos(missileAngle))+width/2;

    pushMatrix(); // save current matrix on the stack memory
    translate(centerX, centerY);

    if((x<0 && y<0) || x>0 && y<0){
        
        rotate(radians(180)+angle);
        
    }else rotate(angle);

    fill(0);//
    rect(0-(canonWidth/2), 0, canonWidth, -canonHight);
    noStroke();
    fill(175);//
    ellipse(0, 0, 40, 40);//
    fill(70);//
    ellipse(0, 0, 20, 20);//
    popMatrix();
    fill(0);//
    rectMode(CENTER);
    rect(width/2, height, 50, 8);//
    rectMode(CORNER);//
    showTarget();
  }

  /**
  * Method to return a missile object
  * @return DefenceMissile
  */
  DefenceMissile fire(){
      
    return new DefenceMissile(x2, y2, mouseX, mouseY, missileAngle, 
    new Explosion(new Counter()));
  }

  /**
  * Method to draw missile targets
  * @return void
  */
  void showTarget(){
    image(target,mouseX, mouseY, 100, 100);
  }
  
  /**
  * Method to set the destroyed flag to true
  * @return void
  */
  void distroy(){
    distroyed = true;
  }
}
