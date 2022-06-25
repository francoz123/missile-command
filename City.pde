/**
* Class to represent a group of buildings
* it can be used to
* -draw the buildings
* -check for collisions
* -simulate building destruction
* -initiate misile explosions
*/
class City{
  ArrayList<float[]> rects;// = new ArrayList<>();
  float start; // start position of the drawings
  float end; // start position of the drawings
  float cityWidth; // width of each building group the drawings
  int rectWidth; // width of rectangles
  float spacing; // spacing between buildings
  boolean crumbled; // flag for crumbling animation
  boolean crumbling; // flag to determine when crumbling animation has finished
  int frame = 0;  // frame count
  
  /** 
  * constructor to initialize all fields
  * @param start - starting offset of the drawings
  */
  City(float start){
    rectWidth = 20;
    cityWidth = 3*rectWidth;
    this.start = start;
    end = start;
    rects = new ArrayList<>();
    crumbled = false;
    crumbling = false;
    populate();
    
  }
  
  // method to return the x coordinate of the previous building
  float getEnd(){
    return this.end;
  }
  
  /**
  * Method to check for collisions with offence missiles
  * @param missiles - an array of missile objects
  * @return bollean
  */
  boolean collide(ArrayList<Missile> missiles){
    
    for (int i=0; i<missiles.size(); i++){
      
      Missile missile = missiles.get(i);
      
      for (float[] f : this.rects){
        
        if(((abs(missile.x- f[0]) < missile.radius && missile.y > height - (f[1] + missile.radius)
        && missile.y < height-2) || (missile.y > height - (f[1] + missile.radius) && 
        missile.y < height-2 && (missile.x > f[0]) && missile.x < f[0] + rectWidth)
        && !missile.exploded))
        {          
          missile.explode();
          this.crumbling = true;
          return true;
        }
      }
   }
   
    return false;
  }
  
  /**
  * Method to draw all buildings on the convas
  * @return void
  */
  void show(){
    
    rectMode(CORNER);
    fill(255);
    stroke(0);
    
    for (float[] f : rects){
      
      fill(175);
      stroke(0);
      rect(f[0], height - f[1], rectWidth, f[1]);
      drawWindows(f[0], height - f[1]);
      end += rectWidth;
      
    }
     // check crumbling
    if (crumbling){
      crumble();
    }
  }
  
  /**
  * Method to populate rect array
  * @return void
  */
  void populate(){
    
    rects.add(new float[]{start, 30});
    rects.add(new float[]{start+rectWidth, 20});
    rects.add(new float[]{start+2*rectWidth, 25});
    
  }
  
  /**
  * Method to draw windows on buildoings
  * @param x - x offset of first window
  * @param y - y offset of first window
  */
  void drawWindows(float x, float y){
    
    float offsetX = x;
    float offsetY = y;
    
    while (offsetY < height -10 ){
      
      fill(0);
      stroke(0);
      rect (offsetX+3, offsetY+5, 4, 4);
      offsetX += 10;
      rect (offsetX, offsetY+5, 4, 4);
      offsetY += 10;
      offsetX = x;
      
    }
    
    fill(255);
  }
  
  /** Method to simulate crumbling buildings
  * @return void
  */
  void crumble(){
    
    frame++;
    
    if (frame % 5 == 0){// animate every 5 frames
      
      if (rects.get(0)[1] > 10){ 
        
        for (float[] f: rects){ // cycle through rectangles and decrement their heights
          
          f[1] -= 5;
          
        }
        
      }else crumbled = true;
      
    }
  }
  
}
