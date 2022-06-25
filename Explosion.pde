/**
* This class represents an explosion animation
*/
class Explosion{
  
  PImage[] images;
  float imageHeight = 60;
  float imageWidth = 50;
  int frame = 0;
  float x;
  float y;
  float blastRadius = imageWidth/2;
  boolean finished = false;
  Counter counter;
  
  /**
  * Constructor to initialize counter
  * @param counter - a counter object
  */
  Explosion (Counter counter){
    this.counter = counter;
  }
  
  /**
  * Method to initiate explosion animation
  * @param images - an array of PImage objects
  * @param x - x coordinate of the explosion images
  * @param y - y coordinate of the explosion images
  */
  void explode(PImage[] images,float x, float y){
    
    if(counter.count % 5 == 0 && frame < images.length){ // switch image every 5 frames
      frame += 1;//(frame+1) % images.length;
    }
    
    if(frame < images.length){ // repeat same image till next 5 frames
      
      image (images[frame], x, y, imageWidth,imageHeight);
      return;
    }
    
    this.finished = true;
    
  }
  
  /** 
  * Method to increment counter
  * @return void
  */
  void incrementCounter(){
    this.counter.increment();
  }
}
